# Projet : démo Notion + Claude pour la candidature H Factory

## 1. Contexte

Je postule chez H Factory (société de conseil et de services aux entreprises, présente à La Réunion, Maurice, Madagascar, Mayotte, Seychelles, Comores). Le poste : piloter l'automatisation par l'IA (Claude), structurer leur espace Notion et créer des sites web.

Je dois présenter un portfolio et réussir un cas pratique : **automatiser avec Claude la synthèse d'un rapport d'activité et l'organiser dans Notion**.

Objectif de ce projet : construire une démo propre, reproductible et documentée, avec uniquement des données fictives, qui prouve que je sais :
- structurer un espace Notion (CRM, appels d'offres, projets, documentation) ;
- connecter Claude à Notion et automatiser une tâche réelle ;
- documenter pour une équipe non technique.

Je suis développeur full-stack (PHP/Laravel, JavaScript/TypeScript, Python). Je communique en français. Mon niveau d'anglais est intermédiaire : écris tes réponses en français.

## 2. Règles permanentes (à respecter dans toute la session)

1. **Données 100 % fictives.** Aucun vrai client, aucun vrai nom, aucun vrai montant. Les noms d'entreprises inventés doivent être crédibles mais ne doivent pas correspondre à des entreprises réelles connues.
2. **Périmètre Notion.** Travailler uniquement sous la page Notion nommée « H Factory – Démo ». Ne jamais lire, modifier ou supprimer autre chose dans le workspace.
3. **Valider avant d'agir.** Avant toute création en masse (plus de 5 éléments d'un coup) ou toute suppression, présente-moi le plan et attends ma validation.
4. **Une phase à la fois.** À la fin de chaque phase, fais un court résumé de ce qui a été fait, de ce qui reste, et attends mon « ok » avant de passer à la suivante.
5. **Pas de secret dans Git.** Aucune clé d'API ni jeton dans les fichiers du dépôt. Utiliser des variables d'environnement et un fichier `.env` listé dans `.gitignore`.
6. **Honnêteté technique.** Si une opération n'est pas possible avec les outils Notion disponibles (par exemple la création de certaines vues), dis-le clairement, n'invente pas de succès, et propose une solution de contournement manuelle.
7. **Ne jamais inventer de chiffre** dans les synthèses de rapports : si une donnée manque, écrire « non précisé ».
8. **Documenter au fur et à mesure** dans le dossier `/docs`, en français, avec des phrases courtes.
9. **Langue** : français pour tous les contenus (propriétés Notion, textes, documentation, messages de commit).

## 3. Structure du dépôt à créer

```
demo-notion-claude/
├── CLAUDE.md
├── README.md
├── .gitignore
├── .env.example
├── input/                  # rapports d'activité à synthétiser
├── output/                 # synthèses générées (copie locale, optionnel)
├── scripts/
│   └── lancer_synthese.sh  # exécution planifiable
├── docs/
│   ├── guide-equipe.md
│   ├── schema-flux.md
│   ├── vues-a-creer-manuellement.md   (seulement si nécessaire)
│   └── mesure-gain-de-temps.md
└── .claude/
    └── skills/
        └── synthese-rapport-activite/
            └── SKILL.md
```

## 4. Phases de travail

### Phase 0 : Vérifications préalables

1. Vérifie que le serveur MCP Notion est bien connecté (liste les outils Notion disponibles) et indique-moi lesquels tu peux utiliser (recherche, création de pages, création de bases, mise à jour de propriétés, ajout de blocs, etc.).
2. Vérifie que la page « H Factory – Démo » existe et que tu peux y accéder. Si elle n'existe pas ou n'est pas accessible, arrête-toi et dis-moi quoi faire.
3. Crée la structure de dossiers de la section 3, `.gitignore` (avec `.env`, `output/`, fichiers temporaires) et `.env.example`.
4. Résume les capacités et les limites que tu as constatées. Attends mon « ok ».

### Phase 1 : Créer les quatre bases Notion

Crée-les **une par une**, sous la page « H Factory – Démo », et montre-moi le résultat après chacune.

**Base 1 : « Clients & prospects »**
- Nom (titre)
- Secteur (sélection : Tourisme, Agriculture, Énergie, Collectivité, Finance, Autre)
- Pays (sélection : Madagascar, Maurice, La Réunion, Mayotte, Seychelles, Comores)
- Statut (sélection : Prospect, Contacté, Proposition, Client, Perdu)
- Responsable (personne)
- Dernier contact (date)
- Prochaine action (texte)

**Base 2 : « Appels d'offres »**
- Intitulé (titre)
- Bailleur (texte)
- Date limite (date)
- Budget estimé (nombre, format euro)
- Statut (sélection : Veille, Go/No-go, Rédaction, Soumis, Gagné, Perdu)
- Responsable (personne)
- Client (relation vers « Clients & prospects »)

**Base 3 : « Projets / études »**
- Nom (titre)
- Client (relation vers « Clients & prospects »)
- Phase (sélection : Cadrage, Collecte de données, Analyse, Rédaction, Livré)
- Période (date, avec plage)
- Statut (sélection : En cours, En attente, Terminé)
- Équipe (personne)
- Livrables (texte)
- Source du rapport (URL)

**Base 4 : « Documentation »**
- Titre (titre)
- Catégorie (sélection : Procédure, Bonnes pratiques de prompts, Modèle)
- Auteur (personne)
- Dernière mise à jour (date)

**Vues** : essaie de créer ces vues. Si les outils ne le permettent pas, ne bloque pas : écris la liste précise dans `docs/vues-a-creer-manuellement.md` (nom de la vue, type, filtre, tri, regroupement) pour que je les crée à la main.
- Clients : Kanban par Statut ; tableau par Pays ; « À relancer » (Dernier contact de plus de 30 jours).
- Appels d'offres : calendrier sur Date limite ; Kanban par Statut ; « Urgents » (échéance dans moins de 14 jours).
- Projets : chronologie sur Période ; tableau par Responsable.
- Documentation : galerie par Catégorie.

Termine par un résumé et attends mon « ok ».

### Phase 2 : Données fictives

1. Présente-moi d'abord le plan (liste des entreprises et appels d'offres prévus), puis attends mon « ok ».
2. Ajoute :
   - 12 entreprises fictives dans « Clients & prospects », réparties sur les pays de l'océan Indien et sur les secteurs, avec des statuts variés (au moins 2 par statut sauf « Perdu » : 1).
   - 6 appels d'offres fictifs, tous liés à un client, dont 2 avec une échéance dans moins de 14 jours à partir d'aujourd'hui.
   - 4 projets d'étude fictifs liés à des clients.
   - 4 pages de documentation : « Comment utiliser cet espace », « Bonnes pratiques de prompts », « Procédure : synthèse de rapport d'activité », « Modèle : trame d'étude type ».
3. Vérifie que les relations fonctionnent (un projet est bien rattaché à son client, etc.).

### Phase 3 : Créer la page d'accueil

Crée une page d'accueil « Accueil – Démo » qui contient : une courte présentation de l'espace, des liens vers les quatre bases, et une section « Démarrer » pour un nouvel utilisateur. Garde-la sobre et lisible pour des non-techniciens.

### Phase 4 : Le skill de synthèse de rapport

Crée le fichier `.claude/skills/synthese-rapport-activite/SKILL.md` avec le contenu suivant :

```markdown
---
name: synthese-rapport-activite
description: Synthétise un rapport d'activité (Word ou PDF) et publie la synthèse dans la base Notion « Projets / études ». À utiliser quand on demande de synthétiser un rapport d'activité.
---

# Objectif
À partir d'un rapport d'activité, produire une synthèse structurée, fiable et lisible, puis la créer dans Notion.

# Étapes
1. Lire le fichier fourni (dossier input/). Si le format n'est pas lisible, le dire clairement.
2. Identifier : le client, la période couverte, l'auteur du rapport.
3. Rédiger la synthèse au format ci-dessous.
4. Créer une page dans la base « Projets / études » (sous « H Factory – Démo »), renseigner les propriétés (Nom, Client si identifiable, Période, Statut, Source du rapport), puis ajouter la synthèse comme contenu de la page.
5. Afficher un récapitulatif : titre de la page créée, éléments non précisés dans le rapport.

# Format de la synthèse (toujours identique)
1. Contexte (3 lignes maximum)
2. Chiffres clés (5 indicateurs maximum, avec l'évolution quand elle est donnée)
3. Réalisations de la période
4. Points d'attention et risques
5. Actions à mener (responsable et échéance)
6. Prochaines étapes

# Règles de fiabilité
- Ne jamais inventer un chiffre, un nom ou une date. Si l'information manque, écrire « non précisé ».
- Indiquer la section ou la page source pour chaque chiffre clé.
- Ton factuel, phrases courtes, français professionnel.
- Ne pas reprendre d'informations confidentielles hors du périmètre de la synthèse.

# Contrôle qualité avant publication
- Tous les chiffres cités existent dans le rapport.
- Aucune section du format n'est manquante.
- La page Notion est bien rattachée au bon client (si identifiable).
```

Après création, relis le fichier pour vérifier qu'il est correct, puis attends mon « ok ».

### Phase 5 : Rapport fictif et test

1. Génère un faux rapport d'activité de 3 à 5 pages au format Word (.docx), dans `input/rapport-t3-demo.docx`. Contenu : client fictif d'une des entreprises de la base, période = un trimestre, avec des chiffres cohérents (chiffre d'affaires, nombre de participants à une formation, avancement de projets, difficultés rencontrées, prochaines actions). Utilise la bibliothèque Python `python-docx` (installe-la dans un environnement virtuel).
2. Utilise le skill `synthese-rapport-activite` sur ce fichier.
3. Vérifie la page créée dans Notion : propriétés renseignées, format respecté, aucun chiffre inventé (compare avec le rapport source).
4. Si le résultat n'est pas bon, améliore le skill et reteste. Garde la liste de ce que tu as modifié.
5. Montre-moi la page Notion obtenue (décris-la) et attends mon « ok ».

### Phase 6 : Mesure du gain de temps

Crée `docs/mesure-gain-de-temps.md` avec un tableau à remplir que je compléterai :

| Étape | Temps manuel estimé | Temps avec automatisation |
|---|---|---|
| Lecture du rapport | | |
| Rédaction de la synthèse | | |
| Mise en forme dans Notion | | |
| Relecture | | |
| **Total** | | |

Ajoute en dessous une formule claire de calcul du pourcentage de gain, et une phrase d'avertissement : les temps sont ceux que je mesure moi-même sur ce cas fictif.

### Phase 7 : Exécution planifiée

1. Crée `scripts/lancer_synthese.sh` qui traite les nouveaux fichiers du dossier `input/` (ceux qui n'ont pas encore été traités : tiens un petit fichier de suivi `output/traites.txt`) en lançant Claude Code en mode non interactif avec une consigne demandant d'utiliser le skill de synthèse sur chaque nouveau fichier.
2. Gère proprement les erreurs (fichier illisible, Notion indisponible) avec un message clair et un journal `output/journal.log`.
3. Écris dans `docs/schema-flux.md` comment le planifier :
   - sous Windows : Planificateur de tâches ;
   - sous Linux/Mac : cron ;
   - option GitHub Actions si le dépôt est sur GitHub.
4. Signale-moi le point d'attention sur l'authentification : une session OAuth peut expirer en exécution planifiée, et dis-moi quelle alternative est possible avec les outils disponibles. Ne mets jamais de secret dans le dépôt.
5. Vérifie la syntaxe du script, teste-le une fois manuellement, puis attends mon « ok ».

### Phase 8 : Documentation

1. `README.md` : objectif du projet, schéma simple du flux (rapport en entrée, skill, page Notion en sortie), prérequis, installation pas à pas, utilisation, limites connues.
2. `docs/guide-equipe.md` : guide pour des non-techniciens de l'équipe : comment déposer un rapport, comment lancer la synthèse, comment vérifier le résultat dans Notion, que faire en cas d'erreur. Pas de jargon.
3. `docs/schema-flux.md` : compléter avec un schéma en texte (ou Mermaid) du flux complet.
4. Dans la page Notion « Documentation », crée la page « Procédure : synthèse de rapport d'activité » avec le contenu du guide équipe.
5. Fais un `git commit` propre de l'ensemble, message en français.

### Phase 9 : Contrôle final

Vérifie et rapporte sous forme de liste de contrôle :
- [ ] Les quatre bases existent avec les bonnes propriétés et relations.
- [ ] Les données sont fictives et cohérentes.
- [ ] La page d'accueil existe et les liens fonctionnent.
- [ ] Le skill de synthèse fonctionne sur le rapport fictif.
- [ ] Aucun secret n'est présent dans le dépôt (cherche les clés, jetons, URL privées).
- [ ] La documentation est complète et lisible par un non-technicien.
- [ ] La liste de ce qui reste à faire à la main (vues Notion, mesure des temps, capture ou vidéo) est claire.

## 5. Ce que je ferai moi-même

- Créer les vues Notion que tu n'as pas pu créer.
- Mesurer les temps manuel et automatisé.
- Enregistrer une courte vidéo (2 minutes) du flux complet.
- Partager la page Notion en lecture seule pour le portfolio.

## 6. Première consigne

Commence par la **Phase 0** et ne passe à la suite qu'après mon accord.
