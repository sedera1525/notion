# Guide de l'équipe

Ce guide s'adresse à toute personne de l'équipe, sans connaissance technique.
Il explique comment obtenir la synthèse d'un rapport d'activité dans Notion.

## En deux phrases

Vous déposez un rapport dans un dossier. Quelques minutes plus tard, sa synthèse
apparaît dans Notion, dans la base « Projets / études ».

Vous n'avez rien à rédiger. Vous avez en revanche une relecture à faire : c'est
expliqué plus bas.

---

## 1. Déposer un rapport

Copiez le fichier dans le dossier `input/` du projet.

Formats acceptés : **Word (.docx)** et **PDF (.pdf)**.

Quelques conseils :

- Donnez un nom clair au fichier, par exemple `rapport-t3-vanille-horizon.docx`.
  Ce nom n'est pas utilisé par la machine, mais il vous servira à vous y retrouver.
- Un document scanné en image ne fonctionne pas : le texte doit être sélectionnable.
  Pour vérifier, ouvrez le PDF et essayez de surligner une phrase à la souris.
  Si rien ne se surligne, le document est une image.
- Si vous corrigez un rapport déjà traité et que vous le redéposez, il sera retraité.
  C'est voulu.

---

## 2. Lancer la synthèse

### Si la tâche automatique est en place

Vous n'avez rien à faire. Le traitement part tout seul, à intervalle régulier.
Demandez à la personne qui a installé l'outil à quelle fréquence il tourne.

### Pour lancer tout de suite

Ouvrez un terminal dans le dossier du projet et tapez :

```bash
./scripts/lancer_synthese.sh
```

Pour voir ce qui serait fait, sans rien publier :

```bash
./scripts/lancer_synthese.sh --simulation
```

Les rapports déjà traités sont ignorés. Relancer la commande plusieurs fois ne crée
pas de doublon.

---

## 3. Vérifier le résultat dans Notion

Ouvrez Notion, puis la base **« Projets / études »** sous la page
**« H Factory – Démo »**. Une nouvelle page porte le nom de la synthèse.

**Relisez-la.** C'est l'étape la plus importante, et elle vous revient.

Points à contrôler :

| À vérifier | Comment |
|---|---|
| La synthèse est rattachée au bon client | Propriété **Client** en haut de la page |
| La période est la bonne | Propriété **Période** |
| Les chiffres sont justes | Chaque chiffre indique sa section d'origine, par exemple « (section 2) ». Ouvrez le rapport à cette section et comparez |
| Rien n'a été inventé | Quand une information manque dans le rapport, la synthèse écrit **« non précisé »**. C'est normal et voulu : ce n'est pas une erreur à corriger, c'est une information absente du document d'origine |

Si un chiffre vous semble faux, revenez toujours au rapport d'origine. Le lien vers le
fichier source figure dans la propriété **Source du rapport**.

---

## 4. En cas de problème

### Rien n'apparaît dans Notion

Ouvrez le fichier `output/journal.log`. Les lignes les plus récentes sont en bas.
Cherchez le mot `ERREUR`.

### Les messages d'erreur courants

| Message dans le journal | Ce que ça veut dire | Quoi faire |
|---|---|---|
| `Fichier vide, ignoré` | Le fichier déposé ne contient rien | Vérifiez que la copie s'est bien terminée, puis redéposez |
| `Fichier illisible` | Le fichier est protégé en lecture | Vérifiez les droits du fichier |
| `Notion refuse le jeton (401)` | La connexion à Notion n'est plus valable | Prévenez la personne qui gère l'outil : le jeton doit être renouvelé |
| `Notion est injoignable` | Pas de connexion internet, ou Notion est en panne | Réessayez plus tard, le rapport sera retraité automatiquement |
| `La commande « claude » est introuvable` | L'outil n'est pas installé sur cette machine | Prévenez la personne qui gère l'outil |

### Bon à savoir

Un rapport qui a échoué **n'est pas perdu**. Il n'est pas marqué comme traité : il sera
repris tout seul au lancement suivant.

### Si vous ne trouvez pas la réponse

Notez ces trois éléments avant de demander de l'aide — ils font gagner beaucoup de
temps :

1. Le nom du fichier déposé.
2. L'heure approximative du dépôt.
3. Les dernières lignes de `output/journal.log`.

---

## Ce que l'outil ne fait pas

Pour éviter les mauvaises surprises :

- Il **ne remplace pas la relecture**. Une synthèse non relue ne doit pas être
  transmise à un client.
- Il **ne lit pas les documents scannés** en image.
- Il **n'invente jamais** un chiffre, un nom ou une date. Si l'information manque, il
  écrit « non précisé ». Un rapport incomplet donnera une synthèse incomplète : c'est
  le comportement attendu, pas un défaut.
- Il **ne modifie pas** le rapport d'origine.
