# Vues Notion — réglages de référence

## Pourquoi ce fichier

L'API Notion ne permet pas de créer des vues (Kanban, calendrier, chronologie, galerie).
Elle ne gère que les bases, les propriétés et les pages. Les 9 vues ont donc été créées
à la main dans l'interface Notion, le 23 octobre 2026.

Ce n'est pas une limite de l'outillage Claude : aucun client ne peut le faire aujourd'hui.

Ce fichier garde le réglage exact de chaque vue. Il sert à les reconstruire si l'espace
est perdu, à comprendre un filtre si une vue se vide un jour, et à vérifier qu'un
réglage est juste — voir les comptages attendus en fin de fichier.

## Comment créer une vue

1. Ouvrir la base concernée.
2. Cliquer sur **+** à droite du nom des vues existantes.
3. Choisir le type de vue.
4. Nommer la vue.
5. Régler le filtre, le tri et le regroupement avec les boutons en haut à droite.

---

## Base « Clients & prospects »

### Vue 1 — Pipeline
- **Type** : Tableau Kanban
- **Regroupement** : `Statut`
- **Ordre des colonnes** : Prospect → Contacté → Proposition → Client → Perdu
- **Tri dans chaque colonne** : `Dernier contact`, décroissant
- **Filtre** : aucun

### Vue 2 — Par pays
- **Type** : Tableau
- **Regroupement** : `Pays`
- **Tri** : `Nom`, croissant
- **Filtre** : aucun

### Vue 3 — À relancer
- **Type** : Tableau
- **Filtre** : `Dernier contact` → **est antérieur à** → **Il y a 30 jours**
  - Dans Notion : `Dernier contact` / `is before` / `30 days ago` (option relative, pas une date fixe)
- **Tri** : `Dernier contact`, croissant (les plus anciens en premier)
- **Regroupement** : aucun
- **Filtre complémentaire conseillé** : `Statut` **n'est pas** `Perdu` — inutile de relancer un dossier abandonné

---

## Base « Appels d'offres »

### Vue 1 — Échéancier
- **Type** : Calendrier
- **Propriété de date** : `Date limite`
- **Filtre** : aucun

### Vue 2 — Avancement
- **Type** : Tableau Kanban
- **Regroupement** : `Statut`
- **Ordre des colonnes** : Veille → Go/No-go → Rédaction → Soumis → Gagné → Perdu
- **Tri dans chaque colonne** : `Date limite`, croissant

### Vue 3 — Urgents
- **Type** : Tableau
- **Filtre** : `Date limite` → **est dans les prochains** → **14 jours**
  - Dans Notion : `Date limite` / `is within` / `the next 14 days`
- **Tri** : `Date limite`, croissant
- **Filtre complémentaire conseillé** : `Statut` **n'est pas** `Soumis`, `Gagné`, `Perdu` — ne garder que les dossiers encore à traiter

---

## Base « Projets / études »

### Vue 1 — Planning
- **Type** : Chronologie (Timeline)
- **Propriété de date** : `Période`
- **Affichage** : par mois
- **Filtre** : aucun

### Vue 2 — Par équipe
- **Type** : Tableau
- **Regroupement** : `Équipe (démo)` — **pas** `Équipe`
- **Tri** : `Nom`, croissant

> ⚠️ Deux propriétés se ressemblent dans cette base. Regrouper sur la bonne :
> `Équipe` est de type « personne » et reste vide (voir la remarque en fin de fichier).
> `Équipe (démo)` est une sélection, renseignée sur les quatre projets. C'est elle
> qui donne une vue utilisable.
>
> Le CLAUDE.md demandait « tableau par Responsable » pour cette base, mais
> « Projets / études » n'a pas de propriété `Responsable` : elle a `Équipe`.

---

## Base « Documentation »

### Vue 1 — Par catégorie
- **Type** : Galerie
- **Regroupement** : `Catégorie`
- **Taille des cartes** : moyenne
- **Aperçu de la carte** : contenu de la page
- **Tri** : `Dernière mise à jour`, décroissant

---

## Remarque sur les propriétés « personne »

Les propriétés `Responsable`, `Équipe` et `Auteur` ne peuvent être remplies qu'avec
de vrais membres de l'espace de travail Notion. Les données de cette démo étant
fictives, ces champs restent vides.

**Décision prise.** Une seule vue en dépendait : « Par équipe » ci-dessus. Une propriété
de sélection `Équipe (démo)` a été ajoutée à « Projets / études », avec trois pôles
fictifs, et renseignée sur les quatre projets :

| Projet | Équipe (démo) |
|---|---|
| Étude de filière vanille durable | Pôle Agro & Filières |
| Diagnostic énergétique communal | Pôle Énergie & Climat |
| Synthèse T3 2026 — Caldeira Solaire | Pôle Énergie & Climat |
| Schéma directeur touristique | Pôle Territoires & Organisation |
| Refonte du pilotage interne | Pôle Territoires & Organisation |

La cinquième ligne est la page créée par le skill pendant le test du cas C. Sa valeur a
été renseignée après coup : sans elle, la vue « Par équipe » affichait un groupe
« Aucune équipe » avec une ligne isolée dedans.

Les propriétés `Responsable` (Clients & prospects, Appels d'offres) et `Auteur`
(Documentation) sont laissées vides : aucune des neuf vues ne les utilise, donc rien
ne justifie de dupliquer ces champs.

Le type **sélection** a été retenu plutôt que du texte libre, parce que Notion garantit
le regroupement sur une sélection et que cela reste cohérent avec `Statut`, `Phase`,
`Secteur` et `Pays`, déjà des sélections.

---

## Vérifier qu'une vue est bien réglée

Les 9 vues ont été créées le 23 octobre 2026. Pour contrôler qu'un réglage est juste,
compter les lignes : un filtre mal posé se voit immédiatement au nombre.

État au **24 octobre 2026** :

| Vue | Attendu |
|---|---|
| Pipeline | 12 cartes : Prospect 3, Contacté 2, Proposition 2, Client 4, Perdu 1 |
| Par pays | 12 lignes, 6 groupes de 2 exactement |
| À relancer | 4 lignes (5 sans le filtre `Statut n'est pas Perdu`) |
| Échéancier | 6 consultations |
| Avancement | 6 cartes : Veille 1, Go/No-go 1, Rédaction 1, Soumis 0, Gagné 2, Perdu 1 |
| Urgents | 1 ligne — voir l'avertissement ci-dessous |
| Planning | 5 lignes, d'avril 2026 à février 2027 |
| Par équipe | 5 lignes, 3 groupes : Agro & Filières 1, Énergie & Climat 2, Territoires & Organisation 2 |
| Par catégorie | 4 cartes, 3 groupes : Procédure 2, Bonnes pratiques de prompts 1, Modèle 1 |

La colonne *Soumis* du Kanban est vide, et c'est voulu : aucune consultation n'est en
attente de décision. Remplir cette colonne aurait demandé d'inventer un statut faux.

## ⚠️ Deux vues dépendent de la date du jour

« À relancer » et « Urgents » reposent sur des filtres relatifs. Leur contenu bouge donc
tout seul, et les dates fictives ont été calibrées autour du 21 octobre 2026.

**« Urgents » sera vide à partir du 29 octobre 2026.** Son unique ligne, « Diagnostic
énergétique — phase 2 », a une échéance au 28/10. La consultation suivante arrive au
02/11, mais elle est passée en *Gagné* et le filtre de statut l'exclut — à juste titre,
un dossier gagné ne demande plus de travail. La vue restera donc vide jusqu'à la
mi-novembre, quand l'échéance du 30/11 entrera dans la fenêtre de 14 jours.

**« À relancer » passera de 4 à 5 lignes vers le 28 octobre**, quand Pitons Conseil
(dernier contact le 28/09) franchira les 30 jours.

Conséquence pratique : **si la vidéo est enregistrée après le 28 octobre, « Urgents » sera
une vue morte à l'écran.** Deux solutions, au choix :

- ne pas montrer cette vue, et s'appuyer sur « Échéancier » et « Avancement » ;
- recalibrer les échéances fictives sur la date d'enregistrement. C'est de la conception
  de données de démonstration, pas une falsification — mais autant le décider sciemment.
