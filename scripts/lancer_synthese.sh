#!/usr/bin/env bash
#
# Traite les nouveaux rapports déposés dans input/ et publie leur synthèse
# dans Notion, en appelant Claude Code en mode non interactif.
#
# Un fichier déjà traité n'est pas retraité. Le suivi se fait par empreinte
# du contenu : si un rapport est corrigé puis redéposé, il est retraité.
#
# Usage :
#   scripts/lancer_synthese.sh              traitement normal
#   scripts/lancer_synthese.sh --simulation n'appelle pas Claude, montre ce qui serait fait
#   scripts/lancer_synthese.sh --aide       affiche cette aide
#
# Codes de sortie : 0 = tout s'est bien passé
#                   1 = problème de configuration (rien n'a été traité)
#                   2 = au moins un fichier en erreur

set -euo pipefail

RACINE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$RACINE"

ENTREE="$RACINE/input"
SORTIE="$RACINE/output"
JOURNAL="$SORTIE/journal.log"
SUIVI="$SORTIE/traites.txt"
VERROU="$SORTIE/.verrou"
SIMULATION=0

# Outils autorisés pour l'exécution non surveillée.
# Liste volontairement restreinte : on n'utilise PAS --permission-mode bypassPermissions,
# qui donnerait tous les droits à un agent tournant sans personne devant l'écran.
#
# python-docx vit dans .venv, hors de ce périmètre : le skill lit donc le .docx
# avec la bibliothèque standard (zipfile). C'est voulu — élargir l'allowlist à
# .venv/bin/python3 pour une seule bibliothèque ne vaut pas le droit accordé.
#
# Les trois outils de lecture (retrieve-a-page, retrieve-a-database,
# get-block-children) servent à la règle de rattachement : retrouver le projet
# du client et vérifier qu'il ne contient pas déjà la synthèse.
#
# Volontairement absent : patch-page. Il permettrait de modifier n'importe quelle
# propriété — et d'archiver — sur toute page accessible au jeton. Le skill ne
# modifie aucune propriété d'un projet existant, donc ce droit n'a pas lieu
# d'être accordé à un agent qui tourne sans personne devant l'écran.
OUTILS_AUTORISES=(
  "Skill"
  "Read"
  "Bash(python3:*)"
  "mcp__notion__API-post-search"
  "mcp__notion__API-query-data-source"
  "mcp__notion__API-retrieve-a-data-source"
  "mcp__notion__API-retrieve-a-database"
  "mcp__notion__API-retrieve-a-page"
  "mcp__notion__API-get-block-children"
  "mcp__notion__API-post-page"
  "mcp__notion__API-patch-block-children"
)

# ---------------------------------------------------------------- arguments
case "${1:-}" in
  --aide|-h|--help) sed -n '2,17p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
  --simulation)     SIMULATION=1 ;;
  "")               ;;
  *) echo "Option inconnue : $1 (voir --aide)" >&2; exit 1 ;;
esac

mkdir -p "$SORTIE"
touch "$SUIVI"

# ---------------------------------------------------------------- journal
journal() {
  local niveau="$1"; shift
  printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$niveau" "$*" | tee -a "$JOURNAL"
}

liberer_verrou() { rmdir "$VERROU" 2>/dev/null || true; }
erreur_fatale()  { journal ERREUR "$*"; exit 1; }

# ---------------------------------------------------------------- verrou
# Empêche deux exécutions simultanées (utile si une exécution cron déborde
# sur la suivante). mkdir est atomique, contrairement à un test de fichier.
if ! mkdir "$VERROU" 2>/dev/null; then
  journal INFO "Une autre exécution est déjà en cours. Abandon."
  exit 0
fi
trap liberer_verrou EXIT

if [ "$SIMULATION" = 1 ]; then
  journal INFO "--- Démarrage (simulation) ---"
else
  journal INFO "--- Démarrage ---"
fi

# ---------------------------------------------------------------- prérequis
[ -d "$ENTREE" ] || erreur_fatale "Dossier d'entrée introuvable : $ENTREE"

if [ "$SIMULATION" = 0 ]; then
  command -v claude >/dev/null 2>&1 ||
    erreur_fatale "La commande « claude » est introuvable. Installez Claude Code, ou corrigez le PATH (oubli fréquent avec cron)."
fi

[ -f "$RACINE/.mcp.json" ] ||
  erreur_fatale "Fichier .mcp.json absent : la connexion Notion n'est pas configurée. Copiez .mcp.json.example et renseignez le jeton."

# Jeton Notion : lu depuis .mcp.json. Jamais écrit dans le dépôt ni dans le journal.
JETON="$(python3 -c "import json;print(json.load(open('.mcp.json'))['mcpServers']['notion']['env']['NOTION_TOKEN'])" 2>/dev/null || true)"
[ -n "$JETON" ] || erreur_fatale "Jeton Notion introuvable dans .mcp.json."

# Notion répond-il ? Évite de lancer un traitement voué à l'échec.
CODE="$(curl -s -o /dev/null -w '%{http_code}' --max-time 20 \
        -H "Authorization: Bearer $JETON" -H "Notion-Version: 2025-09-03" \
        https://api.notion.com/v1/users/me || echo 000)"
case "$CODE" in
  200) journal INFO "Notion est joignable." ;;
  401) erreur_fatale "Notion refuse le jeton (401). Il a peut-être été régénéré : mettez .mcp.json à jour." ;;
  000) erreur_fatale "Notion est injoignable (pas de réseau, ou délai dépassé). Réessayez plus tard." ;;
  *)   erreur_fatale "Notion a répondu HTTP $CODE. Traitement annulé." ;;
esac

# ---------------------------------------------------------------- traitement
traites=0
erreurs=0
ignores=0

while IFS= read -r -d '' fichier; do
  nom="$(basename "$fichier")"

  if [ ! -r "$fichier" ]; then
    journal ERREUR "Fichier illisible (droits insuffisants) : $nom"
    erreurs=$((erreurs + 1))
    continue
  fi

  if [ ! -s "$fichier" ]; then
    journal ERREUR "Fichier vide, ignoré : $nom"
    erreurs=$((erreurs + 1))
    continue
  fi

  empreinte="$(sha256sum "$fichier" | cut -d' ' -f1)"
  if grep -qF "$empreinte" "$SUIVI" 2>/dev/null; then
    ignores=$((ignores + 1))
    continue
  fi

  journal INFO "Nouveau rapport détecté : $nom"

  if [ "$SIMULATION" = 1 ]; then
    journal INFO "  (simulation) Claude aurait été appelé sur ce fichier."
    traites=$((traites + 1))
    continue
  fi

  # La consigne ne dit pas « crée une page » : le skill décide s'il rattache la
  # synthèse au projet existant du client ou s'il crée une ligne.
  #
  # L'interdiction de lire les fichiers de sortie évite que l'agent prenne les
  # comptes rendus des passages précédents pour ses propres instructions.
  consigne="Utilise le skill synthese-rapport-activite sur le fichier input/$nom.
Ne pose aucune question : travaille de bout en bout et publie la synthèse dans Notion,
en appliquant la règle de rattachement du skill.
Ne lis ni output/journal.log ni output/traites.txt : ce sont les sorties du script,
ils contiennent les exécutions précédentes et ne te concernent pas.
Ne traite aucun autre fichier que input/$nom.
Termine par l'endroit où la synthèse a été publiée : nom de la page projet complétée,
ou titre de la page créée."

  # « < /dev/null » n'est pas une précaution de style, c'est une correction de bug.
  # La boucle while lit sa liste de fichiers sur stdin (substitution de processus en
  # fin de boucle). claude -p lit aussi stdin : sans redirection il avalait le reste
  # de la liste. Deux effets, tous deux observés : un seul fichier traité par
  # exécution, et les chemins avalés arrivaient dans le prompt de Claude, qui
  # répondait « votre message se termine aussi par le chemin … ».
  if claude -p "$consigne" --allowedTools "${OUTILS_AUTORISES[@]}" \
       --output-format text </dev/null >>"$JOURNAL" 2>&1; then
    printf '%s\t%s\t%s\n' "$empreinte" "$(date '+%Y-%m-%dT%H:%M:%S')" "$nom" >>"$SUIVI"
    # « traité » et non « publié » : le script sait que Claude s'est terminé sans
    # erreur, pas ce qu'il a écrit dans Notion. Le détail est dans son récapitulatif,
    # juste au-dessus dans ce journal.
    journal INFO "  Traité sans erreur : $nom"
    traites=$((traites + 1))
  else
    journal ERREUR "  Échec du traitement de $nom. Le détail figure juste au-dessus dans ce journal."
    journal ERREUR "  Le fichier n'est PAS marqué comme traité : il sera retenté au prochain lancement."
    erreurs=$((erreurs + 1))
  fi

done < <(find "$ENTREE" -maxdepth 1 -type f \( -iname '*.docx' -o -iname '*.pdf' \) -print0 | sort -z)

journal INFO "Bilan : $traites traité(s), $ignores déjà fait(s), $erreurs en erreur."
journal INFO "--- Fin ---"

[ "$erreurs" -eq 0 ] || exit 2
