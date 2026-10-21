# Vues Notion à créer à la main

## Pourquoi ce fichier

L'API Notion ne permet pas de créer des vues (Kanban, calendrier, chronologie, galerie).
Elle ne gère que les bases, les propriétés et les pages. Les vues doivent donc être
créées manuellement dans l'interface Notion.

Ce n'est pas une limite de l'outillage Claude : aucun client ne peut le faire aujourd'hui.

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
- **Regroupement** : `Équipe`
- **Tri** : `Nom`, croissant

> ⚠️ Le CLAUDE.md demandait « tableau par Responsable » pour cette base, mais la base
> « Projets / études » n'a pas de propriété `Responsable` : elle a `Équipe`.
> J'ai donc regroupé par `Équipe`. Si tu préfères, dis-le et j'ajoute une propriété
> `Responsable` à la base.

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
fictives, ces champs resteront vides.

Deux options possibles :
- les laisser vides et l'expliquer pendant la démonstration ;
- les remplacer par des champs texte pour y mettre des noms fictifs.

À décider avec Jesse.
