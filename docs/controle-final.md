# Contrôle final

Liste de contrôle demandée en phase 9 du `CLAUDE.md`. Chaque point porte **ce qui a été
vérifié et comment**, pas une simple coche : une coche sans preuve ne vaut rien.

Contrôle effectué le 24 octobre 2026.

## ✅ Les quatre bases existent avec les bonnes propriétés et relations

Vérifié par appel API sur le schéma de chaque base, pas à l'œil dans l'interface.

| Base | Lignes | Vérification |
|---|---|---|
| Clients & prospects | 12 | 7 propriétés conformes ; relations doubles vers les deux autres bases |
| Appels d'offres | 6 | 7 propriétés ; `Budget estimé` bien au format euro ; relation `Client` |
| Projets / études | 5 | 9 propriétés, dont `Équipe (démo)` ajoutée ; relation `Client` |
| Documentation | 4 | 4 propriétés conformes |

Les relations sont de type `dual_property` dans les deux sens : un client ouvert depuis
un projet affiche bien le projet en retour.

Les valeurs de chaque liste de sélection ont été recoupées avec la spécification :
`Statut` client (Prospect, Contacté, Proposition, Client, Perdu), `Statut` appel d'offres
(Veille, Go/No-go, Rédaction, Soumis, Gagné, Perdu), `Pays` (6 territoires), `Secteur`
(6 valeurs), `Phase` projet (5 valeurs), `Catégorie` documentation (3 valeurs).

## ✅ Les données sont fictives et cohérentes

**Fictives** : aucune des 12 entreprises inventées ne correspond à une entreprise
réelle. Aucun montant, aucune date, aucune personne n'est réel.

**Réparties** : 12 clients sur 6 pays, exactement 2 par pays. Statuts : Prospect 3,
Contacté 2, Proposition 2, Client 4, Perdu 1 — conforme à la consigne « au moins 2 par
statut sauf Perdu ».

**Cohérentes** : la cohérence croisée entre les trois bases a été auditée, et trois
contradictions ont été corrigées :

| Contradiction trouvée | Correction |
|---|---|
| Appel d'offres « Étude de filière vanille durable » en *Soumis* alors que le projet du même nom existe | Passé en *Gagné* |
| Appel d'offres « Schéma directeur touristique » en *Veille* alors que le projet du même nom existe | Passé en *Gagné* |
| Appel d'offres « Diagnostic énergétique des bâtiments communaux » en *Rédaction* alors qu'un projet quasi homonyme existe | Renommé « Diagnostic énergétique — phase 2 (groupes scolaires) » : phase distincte d'un client récurrent, le statut reste juste |

Une quatrième anomalie a été examinée puis **écartée volontairement** : l'appel d'offres
« Audit financier et conformité » est en *Veille* alors que son client Morne Bleu Capital
est en *Proposition*. Ce n'est pas une contradiction : le statut d'un client décrit l'état
de la relation commerciale, celui d'un appel d'offres décrit une consultation précise. Un
client peut avoir une proposition en cours sur un dossier et une simple veille sur un
autre.

Une ligne vide a été supprimée de « Appels d'offres » : créée par un clic involontaire,
elle apparaissait en groupe « Aucun statut » dans le Kanban.

## ✅ La page d'accueil existe et les liens fonctionnent

« Accueil – Démo » existe sous « H Factory – Démo ».

Les quatre liens ont été vérifiés **par identifiant de base**, et non en cliquant : les
quatre blocs `link_to_page` pointent respectivement vers Clients & prospects, Appels
d'offres, Projets / études et Documentation, dans l'ordre des descriptions qui les
accompagnent. Aucun lien mort, aucune inversion.

## ✅ Le skill de synthèse fonctionne sur le rapport fictif

Douze appels réels à Claude allant jusqu'à Notion, sur **deux** rapports et **deux**
clients, code de sortie 0 à chaque fois.

Le détail des vérifications — chiffres recoupés un par un, « non précisé » sur les
informations absentes, rattachement au bon projet, idempotence, conservation des versions
précédentes — figure dans [reste-a-faire.md](reste-a-faire.md), section « Test de bout en
bout ».

Un chemin reste non éprouvé, et c'est écrit comme tel dans le README : un rapport dont le
client n'est **pas identifiable**.

## ✅ Aucun secret n'est présent dans le dépôt

Recherche sur l'ensemble des fichiers suivis par Git. Trois fichiers contiennent une
chaîne commençant par `ntn_` : `.env.example`, `.mcp.json.example` et
`docs/schema-flux.md`. Les trois ne contiennent que le gabarit `ntn_xxxxx…`, aucun jeton
réel.

Les trois fichiers sensibles sont ignorés et non suivis, vérifié par `git check-ignore` :
`.env`, `.mcp.json` et `note.md`.

⚠️ **Reste à faire, et c'est important** : le jeton Notion actuel a transité par une
conversation. Le régénérer **avant** toute publication du dépôt ou tout partage de
l'espace. Voir [reste-a-faire.md](reste-a-faire.md).

## ✅ La documentation est complète et lisible par un non-technicien

Dans Notion, les quatre pages de la base « Documentation » ont un contenu réel. Trois
d'entre elles étaient encore des phrases d'attente le 22 octobre, alors que la page
d'accueil renvoyait explicitement à la première.

Dans le dépôt : README, guide équipe, schéma de flux, réglages des vues, mesure du gain
de temps, et le texte des pages Notion sous `docs/notion/`.

Le guide équipe et les pages Notion sont écrits sans jargon, en phrases courtes, et
expliquent aussi **ce que l'outil ne fait pas** — notamment qu'il ne remplace pas la
relecture.

## ✅ La liste de ce qui reste à faire à la main est claire

[reste-a-faire.md](reste-a-faire.md) : trois points restants, tous hors de portée de
l'outillage — mesurer les temps, enregistrer la vidéo, régénérer le jeton puis partager
en lecture seule. Les 9 vues Notion, qui en faisaient partie, ont été créées le
23 octobre.

---

## Deux réserves honnêtes

**Les vues ne sont pas vérifiables par l'API.** Notion n'expose aucun point d'entrée pour
les lire ni les créer. Leur existence et leurs réglages reposent donc sur une
vérification visuelle, pas sur une preuve. Les nombres de lignes attendus sont écrits
dans [vues-a-creer-manuellement.md](vues-a-creer-manuellement.md) pour permettre ce
contrôle à l'œil.

**Les synthèses visibles ont été réduites à la main.** Les exécutions de test avaient
laissé plusieurs versions dans chaque page ; une seule a été conservée par page. Ce n'est
donc pas l'état brut qu'aurait produit une exécution unique. Le skill, lui, ne supprime
jamais rien — c'est sa règle, et c'est pour cela qu'il y avait des versions à départager.
