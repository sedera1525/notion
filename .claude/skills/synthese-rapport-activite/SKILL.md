---
name: synthese-rapport-activite
description: Synthétise un rapport d'activité (Word ou PDF) et publie la synthèse dans la base Notion « Projets / études », en la rattachant au projet existant du client quand il y en a un. À utiliser quand on demande de synthétiser un rapport d'activité.
---

# Objectif
À partir d'un rapport d'activité, produire une synthèse structurée, fiable et lisible, puis la publier dans Notion.

# Étapes
1. Lire le fichier fourni (dossier input/). Si le format n'est pas lisible, le dire clairement.
2. Identifier : le client, la période couverte, l'auteur du rapport.
3. Rédiger la synthèse au format ci-dessous.
4. Publier dans Notion en appliquant la règle de rattachement ci-dessous.
5. Afficher un récapitulatif : où la synthèse a été publiée (page projet rattachée ou page créée), et la liste des éléments non précisés dans le rapport.

# Lecture du fichier
Un fichier .docx est une archive zip. Si la bibliothèque `python-docx` n'est pas disponible — c'est le cas en exécution planifiée, où seul `python3` est autorisé — extraire le texte de `word/document.xml` avec la bibliothèque standard (`zipfile` et `xml.etree`).

Lire aussi le contenu des tableaux : dans un rapport d'activité, les chiffres clés y sont presque toujours, pas dans les paragraphes.

# Où publier la synthèse (règle de rattachement)
Objectif : **une seule ligne par dossier** dans « Projets / études ». La synthèse rejoint le projet existant du client au lieu de créer une ligne concurrente.

1. Retrouver la fiche du client dans « Clients & prospects » (sous « H Factory – Démo »). Client non identifiable dans le rapport → aller directement au cas C.
2. Chercher dans « Projets / études » les projets dont la relation « Client » pointe vers cette fiche. La comparaison porte sur **l'identifiant de la relation**, pas sur le nom écrit dans le rapport.

3. Parmi ces projets, ne retenir que ceux dont la propriété « Période » **chevauche** la période du rapport. Chevauchement, pas inclusion : un rapport trimestriel déborde souvent de la période du projet. Un projet sans période renseignée reste candidat — rien ne le contredit.

- **Cas A — un seul projet candidat** : rattacher. Ajouter la synthèse dans la page de ce projet, précédée d'un titre de niveau 1 « Synthèse `PÉRIODE` ». Ne créer aucune ligne, et **ne modifier aucune propriété du projet** — voir « Pourquoi ne pas toucher aux propriétés du projet » plus bas.
- **Cas B — plusieurs projets candidats** : cas C, en expliquant l'ambiguïté dans le récapitulatif.
- **Cas C — aucun projet candidat, ou ambiguïté** : créer une page dans « Projets / études », nommée « Synthèse `PÉRIODE` — `CLIENT` », et renseigner Nom, Client (si identifiable), Période, Statut et Source du rapport.

**Client non identifiable : nommer la page d'après le fichier.** Dans ce cas seulement, le titre devient « Synthèse `PÉRIODE` — `NOM DU FICHIER SOURCE` », par exemple « Synthèse T3 2026 — rapport-t3-xyz.docx ». Sans cela, deux rapports de deux clients différents sur la même période porteraient un titre identique, et la règle de redépôt ci-dessous les fusionnerait dans une seule page comme s'ils étaient deux versions du même rapport. Le nom du fichier est le seul élément stable qui reste quand le client manque.

Le filtre sur la période de l'étape 3 s'applique **même quand le client n'a qu'un seul projet**. Sans lui, une synthèse du T3 2026 pourrait atterrir dans une étude close en 2024. Une ligne en trop se corrige d'un coup d'œil ; une synthèse rangée dans le mauvais dossier ne se voit pas.

## Citer la source dans la synthèse — obligatoire
Chaque section de synthèse commence par une ligne en italique donnant le fichier source, sa référence si le rapport en porte une, la période couverte et l'auteur. Exemple :

*Source : input/rapport-t3-demo.docx — réf. VH-2026-T3-001. Période : 1er juillet – 30 septembre 2026. Auteur : R. Andriamalala.*

C'est **le** lien vers le document d'origine. Un projet reçoit plusieurs rapports au fil du temps ; seule cette ligne, écrite dans chaque section, désigne le bon fichier pour la bonne synthèse.

## Rapport corrigé puis redéposé
Le script retraite un rapport dont le contenu a changé — c'est une garantie annoncée à l'équipe. Si une synthèse pour la même période existe déjà à l'endroit où celle-ci doit aller, **ne pas la remplacer et ne pas l'ignorer** : ajouter la nouvelle sous le titre « Synthèse `PÉRIODE` — mise à jour du `DATE DU JOUR` à `HHhMM` », et signaler dans le récapitulatif que la version précédente est conservée au-dessus.

L'heure fait partie du titre, et ce n'est pas un détail : un rapport peut être corrigé deux fois dans la même journée. Sans l'heure, les deux mises à jour porteraient le même titre et deviendraient impossibles à distinguer dans la page.

Lire la date et l'heure de la machine, ne jamais les estimer — la règle « ne jamais inventer une date » s'applique aussi au titre :

```bash
python3 -c "import datetime; print(datetime.datetime.now().strftime('%d/%m/%Y %Hh%M'))"
```

Cette règle vaut pour les trois cas :

- en cas A, la section existante est dans la page du projet ;
- en cas C, **vérifier d'abord si une page du même titre existe déjà** dans « Projets / études ». Si oui, ne pas en créer une seconde : ajouter la section de mise à jour dans cette page.

Rien n'est donc jamais supprimé, et une correction n'est jamais perdue. Si les deux versions font doublon, c'est à un humain de trancher laquelle garder.

## Pourquoi ne pas toucher aux propriétés du projet
En cas A, la synthèse rejoint un projet qui vit sa propre vie : ses propriétés sont tenues par l'équipe, et un projet reçoit plusieurs rapports. Écrire « Source du rapport » sur la fiche projet désignerait le dernier rapport traité, donc un fichier faux pour toutes les synthèses précédentes. La ligne de source de chaque section fait ce travail correctement.

# Propriété « Source du rapport » (cas C seulement)
Sur une page créée par le skill, indiquer le chemin **relatif** depuis la racine du dépôt (exemple : `input/rapport-t3-demo.docx`). Jamais de chemin absolu : il expose l'arborescence locale de la machine et ne sert à personne sur une page partagée.

⚠️ La propriété est de type URL dans Notion, qui affichera donc ce chemin comme un lien. Ce lien **ne mène nulle part** : le fichier est sur le disque, pas sur le web. C'est une valeur à lire, pas à cliquer. En production, avec des rapports stockés sur un espace partagé, la propriété retrouverait son usage normal.

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
- La synthèse est rattachée au bon client (si identifiable), et au bon projet quand il en existe un.
- Aucun chemin absolu dans les propriétés.
