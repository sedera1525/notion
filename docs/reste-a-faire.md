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

⚠️ Pour « Par équipe », regrouper sur `Équipe (démo)` et **non** sur `Équipe`, qui est
une propriété « personne » restée vide. Les deux se ressemblent dans la liste.

## 2. Mesurer les temps

Remplir le tableau de [mesure-gain-de-temps.md](mesure-gain-de-temps.md).

Rappel de la méthode : même rapport pour les deux colonnes, passage manuel **en
premier**, et compter la relecture de contrôle dans le temps automatisé.

## 3. Enregistrer la vidéo de démonstration (2 minutes)

Déroulé suggéré :

1. Montrer la page « Accueil – Démo » et les quatre bases (15 s).
2. Déposer un rapport dans `input/` (10 s).
3. Lancer `./scripts/lancer_synthese.sh` (10 s).
4. Ouvrir « Projets / études » et montrer qu'**aucune ligne n'a été ajoutée** : la
   synthèse est allée dans la fiche « Étude de filière vanille durable ». Ouvrir cette
   fiche et faire défiler jusqu'à la section « Synthèse T3 2026 » (30 s).
5. Ouvrir la synthèse et pointer deux choses (40 s) :
   - un chiffre avec sa référence « (section 2) », à comparer au rapport ;
   - une mention « non précisé », pour montrer que rien n'est inventé.
6. Conclure sur les limites assumées (15 s).

Le point 5 est celui qui distingue une démonstration sérieuse d'une démonstration
qui fait joli.

### ⚠️ Traces de test à connaître avant d'enregistrer

Les exécutions de test ont laissé des traces, conservées volontairement :

| Où | État |
|---|---|
| Fiche « Étude de filière vanille durable » | **4 sections** de synthèse du même rapport |
| Page « Synthèse T3 2026 — Caldeira Solaire » | **6 sections**, dont deux au titre identique |
| Base « Projets / études » | **5 lignes** au lieu de 4 : la page Caldeira s'est ajoutée |

Deux façons de s'en servir :

- **Les expliquer.** C'est l'occasion de montrer qu'un rapport redéposé ne détruit jamais
  la version précédente, et que l'arbitrage reste humain. Les deux titres identiques dans
  la page Caldeira datent d'avant le correctif qui ajoute l'heure — autant ne pas s'y
  attarder.
- **Les réduire.** Une seule opération par page suffit, et la page Caldeira peut être
  supprimée entièrement : elle n'existe que pour le test. Demande-le.

Dans les deux cas, ne pas laisser le spectateur découvrir ces sections sans un mot : vues
sans explication, elles ressemblent au doublon non maîtrisé que ce travail corrige.

La propriété `Source du rapport` de la fiche vanille contient aussi
`input/rapport-t3-demo.docx`, écrit par un passage antérieur au correctif. Le skill
n'écrit plus cette propriété sur un projet existant. C'est sans conséquence, mais la
valeur ne se régénérerait pas si tu la vidais.

## 4. Partager la page Notion en lecture seule

Sur « H Factory – Démo » : **Partager** → *Partager sur le web* → lecture seule.

⚠️ **Avant de partager**, vérifier qu'aucune donnée n'a été ajoutée par erreur.
Tout le contenu actuel est fictif.

## 5. Régénérer le jeton Notion — recommandé

Le jeton actuel a transité par une conversation. Le risque réel est faible — dépôt
jamais poussé, données fictives — mais la régénération coûte deux clics.

Page de la connexion → *Régénérer le jeton* → mettre à jour `.mcp.json`.

À faire **avant** de publier le dépôt ou de partager quoi que ce soit publiquement.

---

## Décisions tranchées, et ce qui a été vérifié

Les deux décisions qui attendaient sur cette page ont été prises le 21 octobre 2026.
Elles ne demandent plus rien.

### Doublon projet / synthèse — résolu

Le skill rattache désormais la synthèse au projet existant du client au lieu de créer
une ligne concurrente. La correspondance se fait sur **la relation « Client »**, puis
sur un **chevauchement** de périodes.

Le détail compte, parce qu'il a failli faire échouer la règle : le projet « Étude de
filière vanille durable » couvre 01/09→15/12/2026 alors que le rapport couvre
01/07→30/09/2026. Les deux périodes se chevauchent **sans que l'une contienne
l'autre**. Un test d'inclusion aurait donc rejeté le bon projet et créé une ligne
inutile ; un test de chevauchement le retient.

Le chevauchement est vérifié même quand le client n'a qu'un seul projet : sans ce
filtre, une synthèse du T3 2026 pourrait atterrir dans une étude close en 2024. En cas
d'ambiguïté, le skill crée une ligne et le signale, plutôt que de ranger la synthèse
dans le mauvais dossier.

Les deux pages « Synthèse T3 2026 — Vanille Horizon » ont été mises à la corbeille
Notion. La base « Projets / études » est revenue à quatre lignes.

### Propriétés « personne » — résolu

Une seule des neuf vues en dépendait. Une propriété de sélection `Équipe (démo)` a été
ajoutée à « Projets / études » et renseignée sur les quatre projets. Détail et tableau
des affectations en fin de
[vues-a-creer-manuellement.md](vues-a-creer-manuellement.md).

### Test de bout en bout — joué

`./scripts/lancer_synthese.sh` a été exécuté **treize fois** — une simulation, un passage
sans nouveau fichier, et **douze appels réels à Claude** allant jusqu'à Notion, sur deux
rapports et deux clients différents. Code de sortie 0 chaque fois, entre 45 et 130
secondes par exécution. Ce qui a été vérifié :

- les chiffres de la synthèse recoupés un par un avec le rapport source : aucun
  inventé, aucun faux ;
- les deux informations absentes du rapport écrites « non précisé » ;
- les 6 sections du format présentes, chaque chiffre citant sa section d'origine ;
- aucune ligne créée dans « Projets / études » quand le projet du client existe ;
- le chevauchement de périodes effectivement appliqué, et pas l'inclusion ;
- un rapport redéposé ajoute une section « mise à jour du … » et **laisse intacte** la
  précédente — vérifié dans la page, les deux sections coexistent ;
- aucune propriété du projet modifiée ;
- **cas C** : pour un client sans projet (Caldeira Solaire), une page est créée, avec
  Client, Période, Statut et Source du rapport renseignés ;
- **pas de ligne en double** : le même rapport Caldeira repassé quatre fois de plus n'a
  créé **aucune seconde ligne**. La base est passée de 4 à 5 lignes, et s'y est tenue ;
- le script traite bien **tous** les fichiers non traités d'une même exécution, et pas
  seulement le premier : suivi vidé, deux rapports neufs, une seule exécution, bilan
  « 2 traité(s), 0 déjà fait(s) » et les deux empreintes enregistrées. Avant correction
  du bug de stdin, ce résultat était impossible.

Précision sur le point ci-dessus, parce que la nuance compte : l'absence de doublon ne
vient pas de la règle « page du même titre » écrite pour le cas C. Elle vient de ce
qu'une page créée en cas C est **reliée à la fiche client**, et devient donc le projet
de ce client : les passages suivants la retrouvent par le cas A. Les deux chemins
convergent.

**Reste non éprouvée** : la règle « page du même titre » du cas C. Elle ne sert que
lorsqu'il n'y a aucune relation client à suivre, c'est-à-dire quand le client n'est pas
identifiable dans le rapport. Il faudrait un rapport sans client nommé pour la jouer.

Sept choses que ces tests ont révélées, et que la vérification maillon par maillon
n'avait pas vues :

1. `python-docx` vit dans `.venv`, hors de l'allowlist du script, qui n'autorise que
   `python3`. Le skill lit donc le `.docx` avec la bibliothèque standard (`zipfile`).
   C'est documenté dans le skill, plutôt que contourné en élargissant les droits d'un
   agent qui tourne sans surveillance.
2. La propriété `Source du rapport` contenait un chemin absolu, qui exposait
   l'arborescence de la machine sur une page destinée au partage. Elle n'est plus
   écrite du tout sur un projet existant : un projet reçoit plusieurs rapports, donc une
   propriété unique désignerait un fichier faux pour toutes les synthèses sauf la
   dernière. C'est la ligne de source en tête de chaque section qui fait ce travail.
3. Une règle d'**inclusion** de périodes aurait rejeté le bon projet. C'est un
   chevauchement qu'il faut tester.
4. Première version de la règle de redépôt : elle ignorait un rapport corrigé dont la
   période était déjà synthétisée, ce qui contredisait la garantie « un rapport corrigé
   est retraité » annoncée à l'équipe. La correction était silencieusement perdue.
   Remontée par la revue de code, pas par le test.
5. **Le bug le plus grave, et celui que j'ai d'abord mal diagnostiqué.** Les
   récapitulatifs contenaient des phrases absurdes : « votre message se termine aussi par
   le chemin input/rapport-t3-demo.docx ». J'ai conclu que l'agent lisait
   `output/journal.log` et lui ai interdit de le faire. Le symptôme a persisté.

   La vraie cause est dans le shell. La boucle `while read` lit sa liste de fichiers sur
   l'entrée standard ; `claude -p` lit aussi l'entrée standard, et avalait donc le reste
   de la liste. Deux conséquences :

   - les chemins avalés arrivaient dans le prompt de Claude, d'où les phrases absurdes ;
   - **un seul fichier était traité par exécution.** Les autres disparaissaient en
     silence, sans erreur et sans trace dans le journal.

   Le second effet est bien plus grave que le premier, et il était invisible tant qu'un
   seul rapport se trouvait dans `input/`. Il n'est apparu qu'en ajoutant le second
   rapport de ce test. Correctif : `claude … < /dev/null`. Preuve : le bilan affichait
   « 0 déjà fait » alors qu'un rapport était marqué traité ; il affiche « 1 déjà fait »
   après correction.

   La leçon n'est pas le `/dev/null`, c'est la méthode : un symptôme bizarre expliqué par
   une hypothèse plausible reste une hypothèse. Celle-ci a tenu une heure parce qu'elle
   semblait raisonnable, et elle était fausse.
6. **Deux mises à jour le même jour portaient le même titre.** La règle ne datait la
   section qu'au jour. Un rapport corrigé deux fois dans la journée produisait deux
   sections indistinguables. Le titre porte maintenant l'heure, lue sur la machine et non
   estimée. Remonté par l'agent lui-même dans son récapitulatif.
7. **Un `.docx` régénéré passe pour un rapport corrigé.** `python-docx` horodate les
   entrées de l'archive zip : deux générations du même script donnent des empreintes
   SHA-256 différentes. Le suivi se faisant par empreinte, relancer un générateur suffit
   à déclencher une section « mise à jour » dans Notion. C'est documenté en tête des deux
   générateurs plutôt que corrigé : forcer les horodatages du zip compliquerait les
   scripts pour un gain nul en démonstration.
