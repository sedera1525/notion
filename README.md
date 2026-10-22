# Démo Notion + Claude — synthèse automatique de rapports d'activité

Démonstration d'un flux automatisé : un rapport d'activité est déposé dans un dossier,
sa synthèse est publiée dans un espace Notion structuré, sans ressaisie.

Le projet sert de cas pratique pour une candidature. **Toutes les données sont
fictives** : aucune entreprise, aucun montant, aucune personne ne correspond à la
réalité.

## Le flux

```
   rapport .docx / .pdf              Claude Code                    Notion
   déposé dans input/     ──────▶    + skill de synthèse   ──────▶  base « Projets / études »
                                                                     dans la page du projet
                                                                     du client
```

Le détail figure dans [docs/schema-flux.md](docs/schema-flux.md).

## Ce que contient l'espace Notion

Quatre bases sous la page « H Factory – Démo » :

| Base | Rôle |
|---|---|
| Clients & prospects | Suivi commercial : secteur, pays, statut, prochaine action |
| Appels d'offres | Consultations en cours, échéances, budgets, rattachement client |
| Projets / études | Missions en cours et terminées, périodes, livrables |
| Documentation | Procédures internes et modèles |

Plus une page d'accueil « Accueil – Démo » qui sert de point d'entrée.

## Prérequis

- **Claude Code** installé ([claude.com/claude-code](https://claude.com/claude-code))
- **Python 3.9+** avec le module `venv`
- **Node.js** (pour le serveur MCP Notion, lancé via `npx`)
- Un **espace Notion** et le droit d'y créer une intégration
- `curl` et `sha256sum` (présents par défaut sous Linux et macOS)

Sous Windows, le script de traitement nécessite WSL ou Git Bash.

## Installation

### 1. Récupérer le projet

```bash
git clone <url-du-depot>
cd H-Factory
```

### 2. Créer l'intégration Notion

1. Aller sur [notion.so/profile/integrations](https://www.notion.so/profile/integrations)
   → *Nouvelle connexion*.
2. Méthode d'authentification : **Jeton d'API** (et non OAuth — voir la section
   authentification de [docs/schema-flux.md](docs/schema-flux.md)).
3. Autorisations : lire, insérer et mettre à jour le contenu.
4. Copier le jeton (il commence par `ntn_`).

### 3. Donner accès à la page

Dans Notion, créer une page nommée exactement **`H Factory – Démo`** (tiret long).
Puis, sur cette page : menu **•••** → **Connexions** → ajouter l'intégration créée.

> Sans cette étape, l'API ne voit rien du tout. C'est l'oubli le plus fréquent.
> L'accès est hérité par toutes les sous-pages, et limité à celles-ci.

### 4. Configurer la connexion

```bash
cp .mcp.json.example .mcp.json
# puis remplacer la valeur de NOTION_TOKEN par le jeton copié à l'étape 2
```

```bash
cp .env.example .env
# puis renseigner NOTION_PAGE_RACINE_ID (les 32 caractères à la fin de l'URL de la page)
```

Ces deux fichiers contiennent des secrets. Ils sont dans `.gitignore` et ne doivent
**jamais** être commités.

### 5. Préparer l'environnement Python

```bash
python3 -m venv .venv
.venv/bin/pip install python-docx
```

### 6. Vérifier

Redémarrer Claude Code, puis taper `/mcp`. Le serveur `notion` doit apparaître
en **connected**.

## Utilisation

### Générer le rapport de démonstration

```bash
.venv/bin/python scripts/generer_rapport_demo.py
```

Produit `input/rapport-t3-demo.docx`, un rapport fictif de 5 pages, pour un client qui a
déjà un projet dans Notion.

```bash
.venv/bin/python scripts/generer_rapport_cas_c.py
```

Produit `input/rapport-t3-caldeira.docx`, un rapport plus court pour un client qui
n'avait pas de projet. Il a servi à éprouver le chemin où le skill crée une page au lieu
de se rattacher à un projet existant.

⚠️ **Ce fichier est déjà dans le dépôt : inutile de le régénérer.** Le relancer écrase un
fichier versionné et, l'empreinte changeant, le prochain traitement ajoutera une section
« mise à jour » dans Notion. Et le chemin qu'il servait à tester n'est plus celui-là :
voir [Limites connues](#limites-connues). Le détail est en tête du script.

### Synthétiser les nouveaux rapports

```bash
./scripts/lancer_synthese.sh              # traitement normal
./scripts/lancer_synthese.sh --simulation # montre ce qui serait fait, sans rien publier
./scripts/lancer_synthese.sh --aide       # aide
```

Les rapports déjà traités sont ignorés. Le suivi se fait par empreinte du contenu, dans
`output/traites.txt`. Tout est journalisé dans `output/journal.log`.

### Où la synthèse est publiée

La règle est faite pour qu'un dossier reste sur **une seule ligne** dans
« Projets / études » :

1. Le skill retrouve la fiche du client dans « Clients & prospects ».
2. Il cherche les projets liés à cette fiche, par la relation `Client`.
3. Il ne garde que ceux dont la période **chevauche** celle du rapport. Un projet sans
   période renseignée reste candidat.
4. **Un seul candidat** → la synthèse est ajoutée dans la page de ce projet, sous un
   titre « Synthèse `PÉRIODE` ». Aucune ligne n'est créée.
5. **Aucun candidat, ou plusieurs** → une page est créée dans « Projets / études », et
   le récapitulatif explique pourquoi.

Le filtre sur la période s'applique même quand le client n'a qu'un seul projet : sans
lui, une synthèse du T3 2026 pourrait atterrir dans une étude close en 2024.

**Rapport corrigé puis redéposé.** Le script le retraite, puisque son empreinte a
changé. Le skill ajoute alors une section « Synthèse `PÉRIODE` — mise à jour du … à
`HHhMM` » et conserve la précédente au-dessus, que la synthèse vive dans une page projet
ou dans une page créée par le skill. Rien n'est écrasé, et une correction n'est jamais
perdue — c'est à un humain de choisir laquelle des deux versions garder.

L'heure figure dans le titre parce qu'un rapport peut être corrigé deux fois le même
jour : sans elle, les deux mises à jour seraient indistinguables dans la page.

**Où est le lien vers le rapport source.** Chaque section de synthèse commence par une
ligne en italique qui donne le fichier, sa référence, la période et l'auteur. C'est elle
qu'il faut lire, et non la propriété `Source du rapport` de la fiche projet : un projet
reçoit plusieurs rapports, une propriété unique ne peut pas désigner le bon fichier pour
chacun. Le skill ne modifie donc aucune propriété d'un projet existant.

### Planifier l'exécution

Voir [docs/schema-flux.md](docs/schema-flux.md) : cron, Planificateur de tâches
Windows, ou GitHub Actions.

### Pour les utilisateurs non techniques

Voir [docs/guide-equipe.md](docs/guide-equipe.md). Ce guide est également publié dans
Notion, dans la base Documentation, page « Procédure : synthèse de rapport d'activité ».

### Mesurer le gain de temps

Le tableau de relevé et la formule de calcul sont dans
[docs/mesure-gain-de-temps.md](docs/mesure-gain-de-temps.md).

## Limites connues

Elles sont réelles et assumées, pas des oublis.

**L'API Notion ne crée pas de vues.** Kanban, calendrier, chronologie et galerie
doivent être créés à la main. La liste exacte — type, filtre, tri, regroupement — est
dans [docs/vues-a-creer-manuellement.md](docs/vues-a-creer-manuellement.md). Aucun
client ne peut contourner cette limite aujourd'hui.

**Le serveur MCP Notion ne crée pas de bases.** Son outil `create-a-data-source` refuse
l'opération depuis l'API version 2025-09-03, et aucun outil « Create Database » n'est
exposé. Les quatre bases ont donc été créées par appel REST direct. C'est une opération
faite une seule fois, qui ne concerne pas le flux automatisé.

**Les propriétés « personne » restent vides.** `Responsable`, `Équipe` et `Auteur`
n'acceptent que de véritables membres de l'espace de travail. Avec des données
fictives, elles ne peuvent pas être remplies.

Une seule vue en dépendait — « Par équipe » dans « Projets / études ». Une propriété
de sélection `Équipe (démo)` a donc été ajoutée à cette base, avec trois pôles fictifs,
pour que la vue ait quelque chose à afficher. Les autres propriétés « personne » sont
laissées vides : aucune vue ne les utilise.

**Les documents scannés ne sont pas lus.** Le texte doit être sélectionnable dans le
fichier d'origine.

**La session OAuth de Claude Code peut expirer** en exécution planifiée. Pour une mise
en production, utiliser une clé API Anthropic. Détails dans
[docs/schema-flux.md](docs/schema-flux.md).

**La sélection des chiffres clés dépend du jugement du modèle.** Le format limite la
synthèse à 5 indicateurs. Quand le rapport en contient davantage, le choix des cinq
peut varier d'une exécution à l'autre. Les chiffres écartés ne disparaissent pas pour
autant : ils se retrouvent dans les autres rubriques.

**Le rattachement au projet repose sur la relation « Client ».** Si un client a
plusieurs projets dont les périodes chevauchent celle du rapport, le skill ne tranche
pas : il crée une entrée distincte et signale l'ambiguïté. C'est un choix assumé —
mieux vaut une ligne en trop qu'une synthèse rangée dans le mauvais dossier.

**La propriété `Source du rapport` n'est pas un lien cliquable.** Elle est de type URL
dans Notion, mais contient un chemin de fichier local (`input/…`). Notion l'affiche
donc comme un lien qui ne mène nulle part. C'est une valeur à lire. En production, avec
des rapports stockés sur un espace partagé, la propriété retrouverait son usage normal.

**Une page créée par le skill devient le projet du client.** Quand un client n'a pas de
projet, le skill crée une page dans « Projets / études ». Cette page étant reliée au
client, les rapports suivants s'y rattachent comme à n'importe quel projet. Les deux
chemins convergent donc, et aucune ligne ne se duplique — vérifié sur cinq passages
consécutifs du même rapport, qui ont produit une seule ligne.

La règle « page du même titre » prévue pour le cas C n'a donc jamais eu à servir. Elle ne
compte que lorsqu'il n'y a aucune relation client à suivre, c'est-à-dire quand le client
n'est pas identifiable dans le rapport. Ce cas-là n'a pas été éprouvé.

**Régénérer un rapport le fait passer pour un rapport corrigé.** `python-docx` horodate
les entrées de l'archive `.docx`, donc deux générations du même script produisent des
empreintes différentes. Le suivi se faisant par empreinte, relancer un générateur suffit
à déclencher une section « mise à jour » dans Notion. C'est signalé en tête des deux
générateurs.

## Ce qui reste à faire à la main

Vues Notion, mesure des temps, vidéo, partage : voir
[docs/reste-a-faire.md](docs/reste-a-faire.md).

## Structure du dépôt

```
.
├── CLAUDE.md                    consignes du projet
├── README.md
├── .env.example                 modèle de configuration
├── .mcp.json.example            modèle de connexion au serveur MCP Notion
├── input/                       rapports à synthétiser
├── output/                      journal et suivi (non versionné)
├── scripts/
│   ├── _docx_commun.py          fonctions partagées par les générateurs
│   ├── generer_rapport_demo.py  génère le rapport fictif principal
│   ├── generer_rapport_cas_c.py génère un rapport pour un client sans projet
│   └── lancer_synthese.sh       traitement planifiable
├── docs/
│   ├── guide-equipe.md          guide non technique
│   ├── schema-flux.md           flux complet et planification
│   ├── vues-a-creer-manuellement.md
│   ├── mesure-gain-de-temps.md
│   └── reste-a-faire.md
└── .claude/skills/
    └── synthese-rapport-activite/SKILL.md
```

## Sécurité

Aucun jeton ni clé n'est présent dans le dépôt. `.env`, `.mcp.json` et les brouillons
personnels sont exclus par `.gitignore`. Seuls les fichiers `.example` sont versionnés.

L'accès Notion est restreint à la seule page « H Factory – Démo » et à ses sous-pages :
le reste de l'espace de travail est inaccessible à l'intégration.

Le script de traitement n'utilise pas `--permission-mode bypassPermissions`. Il déclare
une liste d'outils autorisés limitée au strict nécessaire.
