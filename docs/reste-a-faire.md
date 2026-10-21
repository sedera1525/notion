# Ce qui reste à faire à la main

État au 21 octobre 2026. Tout ce qui pouvait être automatisé l'a été ; cette page
liste le reste.

## 1. Créer les 9 vues Notion — obligatoire

L'API Notion ne crée pas de vues. C'est une limite de l'API, pas de l'outillage.

| Base | Vues à créer |
|---|---|
| Clients & prospects | Pipeline (Kanban par Statut), Par pays (tableau), À relancer (filtre > 30 jours) |
| Appels d'offres | Échéancier (calendrier), Avancement (Kanban), Urgents (filtre ≤ 14 jours) |
| Projets / études | Planning (chronologie), Par équipe (tableau) |
| Documentation | Par catégorie (galerie) |

Le détail — type, filtre, tri, regroupement, pas à pas — est dans
[vues-a-creer-manuellement.md](vues-a-creer-manuellement.md).

Les données ont été préparées pour que ces vues ne soient pas vides :
**2 appels d'offres** sont à moins de 14 jours et **4 clients** dépassent 30 jours
sans contact.

## 2. Mesurer les temps

Remplir le tableau de [mesure-gain-de-temps.md](mesure-gain-de-temps.md).

Rappel de la méthode : même rapport pour les deux colonnes, passage manuel **en
premier**, et compter la relecture de contrôle dans le temps automatisé.

## 3. Enregistrer la vidéo de démonstration (2 minutes)

Déroulé suggéré :

1. Montrer la page « Accueil – Démo » et les quatre bases (15 s).
2. Déposer un rapport dans `input/` (10 s).
3. Lancer `./scripts/lancer_synthese.sh` (10 s).
4. Montrer la page apparue dans « Projets / études » (30 s).
5. Ouvrir la synthèse et pointer deux choses (40 s) :
   - un chiffre avec sa référence « (section 2) », à comparer au rapport ;
   - une mention « non précisé », pour montrer que rien n'est inventé.
6. Conclure sur les limites assumées (15 s).

Le point 5 est celui qui distingue une démonstration sérieuse d'une démonstration
qui fait joli.

## 4. Partager la page Notion en lecture seule

Sur « H Factory – Démo » : **Partager** → *Partager sur le web* → lecture seule.

⚠️ **Avant de partager**, vérifier qu'aucune donnée n'a été ajoutée par erreur.
Tout le contenu actuel est fictif.

## 5. Régénérer le jeton Notion — recommandé

Le jeton actuel a transité par une conversation. Le risque réel est faible — dépôt
jamais poussé, données fictives — mais la régénération coûte deux clics.

Page de la connexion → *Régénérer le jeton* → mettre à jour `.mcp.json`.

À faire **avant** de publier le dépôt ou de partager quoi que ce soit publiquement.

## 6. Deux décisions en attente

### a. Propriétés « personne » vides

`Responsable`, `Équipe` et `Auteur` n'acceptent que de vrais membres de l'espace
de travail Notion. Avec des données fictives, elles restent vides — et les vues
« par équipe » et « par responsable » n'auront rien à afficher.

- **Option 1** : laisser ainsi et l'expliquer pendant la démonstration.
- **Option 2** : ajouter des propriétés texte `Responsable (démo)` et `Équipe (démo)`
  avec des noms fictifs, pour rendre ces vues démontrables.

### b. Doublon projet / synthèse

La base « Projets / études » contient à la fois le projet
« Étude de filière vanille durable » et la synthèse
« Synthèse T3 2026 — Vanille Horizon », pour le même dossier.

C'est le comportement défini par le skill. Trois options :

- **Option 1** : laisser ainsi — conforme à la spécification.
- **Option 2** : modifier le skill pour qu'il ajoute la synthèse dans la page projet
  existante quand client et période correspondent. *Recommandée* : garde quatre bases
  et donne un CRM cohérent.
- **Option 3** : créer une cinquième base « Synthèses » reliée aux projets. Le plus
  propre structurellement, mais s'écarte de la spécification initiale.

## 7. Test de bout en bout

Chaque maillon a été vérifié séparément — génération du rapport, appel non interactif,
skill, publication Notion, contrôle des chiffres, gestion des erreurs. Le cycle complet
en une seule exécution (`./scripts/lancer_synthese.sh` sur un rapport jamais traité, qui
va jusqu'à la page publiée) **n'a pas été joué**, pour ne pas créer une page
supplémentaire tant que la décision 6-b n'est pas prise.

À faire une fois cette décision tranchée — c'est aussi l'occasion d'enregistrer la
vidéo du point 3.
