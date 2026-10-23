# Bonnes pratiques de prompts

> Source de la page Notion du même nom, dans la base « Documentation ».
> Aucune compétence technique n'est nécessaire. Formuler une bonne demande, c'est le même
> travail que briefer un stagiaire compétent qui ne connaît pas le dossier.

## Les quatre ingrédients

Une demande qui donne un bon résultat contient presque toujours ces quatre choses. Il
manque rarement les quatre : c'est généralement le format et les contraintes qu'on
oublie.

| Ingrédient | La question à se poser |
|---|---|
| **Le contexte** | Qui est le client, de quel dossier parle-t-on, pour qui est le résultat ? |
| **La tâche** | Quel verbe ? Résumer, comparer, rédiger, vérifier, reformuler ? |
| **Le format** | Combien de lignes, quelles rubriques, un tableau ou du texte ? |
| **Les contraintes** | Qu'est-ce qui est interdit ? Quel ton ? Que faire si une information manque ? |

## Trois exemples, avant et après

### Exemple 1 — résumer

❌ « Résume ce rapport. »

Résultat : un texte de longueur imprévisible, qui mélange l'important et l'anecdotique,
et dans lequel il faut rechercher soi-même ce qu'on voulait.

✅ « Résume ce rapport d'activité en six rubriques : contexte, chiffres clés,
réalisations, points d'attention, actions à mener, prochaines étapes. Cinq chiffres clés
au maximum, chacun avec la section du rapport d'où il vient. Si une information manque,
écris « non précisé » plutôt que de l'estimer. »

### Exemple 2 — rédiger

❌ « Écris un mail au client. »

Résultat : un mail générique et trop long, au ton commercial, qu'il faudra réécrire.

✅ « Rédige un mail court à la cheffe de projet d'un client, pour lui annoncer que la
remise du livrable glisse de deux semaines à cause d'un retard d'accès aux données. Ton
factuel, pas d'excuses répétées. Propose une nouvelle date et une mesure pour limiter
l'impact. Dix lignes maximum. »

### Exemple 3 — vérifier

❌ « Est-ce que cette synthèse est bonne ? »

Résultat : un avis complaisant et vague, qui ne vérifie rien.

✅ « Compare cette synthèse au rapport source. Pour chaque chiffre cité, dis s'il figure
bien dans le rapport et à quelle section. Signale tout chiffre que tu ne retrouves pas.
Ne corrige rien, liste seulement les écarts. »

## Trois contraintes à exiger systématiquement

Ce sont celles qui distinguent un résultat utilisable d'un résultat à reprendre.

1. **« Indique la source de chaque chiffre. »** Sans ça, vérifier coûte plus cher que
   d'avoir rédigé soi-même.
2. **« Si une information manque, écris "non précisé". »** Un modèle cherche
   naturellement à être utile, et peut combler un trou par une valeur plausible. Cette
   phrase le lui interdit.
3. **« Dis-moi ce dont tu n'es pas sûr. »** La réponse signale alors les endroits à
   relire en priorité.

## Ce qui ne marche pas

- **Demander plusieurs choses sans rapport dans un seul message.** Une demande, un
  résultat. Enchaîner vaut mieux qu'empiler.
- **« Sois exhaustif. »** Sans limite, le texte gonfle et l'essentiel se dilue. Une limite
  chiffrée force la hiérarchie : cinq chiffres, dix lignes, trois risques.
- **Croire qu'un résultat bien écrit est un résultat juste.** La qualité de la langue ne
  dit rien de l'exactitude des chiffres. C'est contre-intuitif, et c'est le piège
  principal.
- **Relancer « fais mieux ».** Dire ce qui ne va pas : trop long, ton trop commercial,
  chiffre introuvable.

## Une trame réutilisable

À copier et compléter. Les quatre lignes correspondent aux quatre ingrédients.

```text
Contexte : [client, dossier, destinataire du résultat]
Tâche : [un seul verbe : résumer, comparer, rédiger, vérifier]
Format : [rubriques attendues, longueur maximale, tableau ou texte]
Contraintes : ton factuel ; indiquer la source de chaque chiffre ;
              écrire « non précisé » si l'information manque ;
              signaler ce dont tu n'es pas sûr.
```

## Le cas des rapports d'activité

Pour ce cas précis, il n'y a rien à rédiger : la demande est déjà écrite une fois pour
toutes et s'applique de la même façon à chaque rapport. C'est le principe même d'une
procédure automatisée — la qualité ne dépend plus de qui formule la demande ce jour-là.

Voir « Procédure : synthèse de rapport d'activité », et
[le skill lui-même](../../.claude/skills/synthese-rapport-activite/SKILL.md).
