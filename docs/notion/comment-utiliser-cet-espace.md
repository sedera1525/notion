# Comment utiliser cet espace

> Source de la page Notion du même nom, dans la base « Documentation ».
> À lire en premier si vous arrivez dans cet espace. Dix minutes suffisent.

## À quoi sert cet espace

Il rassemble en un seul endroit ce qui était dispersé entre les boîtes mail, les
tableurs et les dossiers partagés : qui sont nos clients, quelles consultations sont en
cours, où en sont les missions, et comment on travaille.

Une règle résume tout le reste : **une information se saisit à un seul endroit**, puis on
la réutilise par des liens. Un client n'existe qu'une fois, dans « Clients & prospects ».
Les appels d'offres et les projets le rattachent au lieu de recopier son nom.

## Les quatre bases, et ce qu'on y met

| Base | Ce qu'on y met | Ce qu'on n'y met pas |
|---|---|---|
| **Clients & prospects** | Une fiche par entreprise ou collectivité, avec son secteur, son pays, son statut et la prochaine action à mener | Les contacts individuels, les comptes rendus de réunion |
| **Appels d'offres** | Une fiche par consultation : bailleur, date limite, budget estimé, avancement | Les pièces du dossier elles-mêmes |
| **Projets / études** | Une fiche par mission gagnée : période, phase, livrables. Les synthèses de rapports s'y ajoutent automatiquement | Les missions non encore gagnées — elles restent dans « Appels d'offres » |
| **Documentation** | Les procédures, les modèles, les bonnes pratiques | Les documents clients |

## Le cycle de vie d'un dossier

Un dossier traverse les bases dans cet ordre. Chaque étape a son endroit, et on ne saute
pas d'étape.

1. **Une piste apparaît.** Créer la fiche dans « Clients & prospects », statut
   *Prospect*. Renseigner la prochaine action, sinon la fiche s'endort.
2. **Le contact est pris.** Passer le statut à *Contacté* et mettre à jour « Dernier
   contact ». C'est cette date qui alimente la relance.
3. **Une consultation s'ouvre.** Créer la fiche dans « Appels d'offres » et la rattacher
   au client. Renseigner la date limite dès le premier jour, même approximative.
4. **La proposition part.** Statut *Soumis* sur l'appel d'offres, statut *Proposition*
   sur le client.
5. **C'est gagné.** Statut *Gagné* sur l'appel d'offres, *Client* sur la fiche client, et
   création d'une fiche dans « Projets / études ».
6. **La mission avance.** Faire évoluer la phase. Les rapports d'activité déposés dans le
   dossier `input/` viennent s'y synthétiser tout seuls.

## Quatre conventions à respecter

- **On ne supprime pas une fiche.** On change son statut. Un dossier perdu reste
  instructif : on veut savoir pourquoi.
- **Quand une information manque, on écrit « non précisé ».** Jamais une estimation,
  jamais une case vide qu'on croira oubliée. Cette convention vaut aussi pour les
  synthèses produites automatiquement.
- **Une date limite se saisit dès qu'on la connaît**, même approximative. Une date absente
  ne remonte dans aucune alerte.
- **La prochaine action n'est jamais vide** sur une fiche active. C'est la seule colonne
  qui dit quoi faire demain.

## Ce qui est automatique, ce qui ne l'est pas

**Automatique** : la synthèse d'un rapport d'activité. On dépose le rapport, sa synthèse
apparaît dans la fiche du projet concerné. La procédure complète est dans « Procédure :
synthèse de rapport d'activité ».

**Pas automatique**, et ça ne le sera pas : la relecture. Une synthèse non relue ne part
pas chez un client. L'outil ne se trompe pas sur les chiffres, mais il ne sait pas ce qui
est politiquement délicat, ni ce qu'il faut taire.

## Si vous hésitez

Mieux vaut une fiche imparfaite qu'une information qui reste dans une boîte mail. Créez
la fiche, mettez « non précisé » où vous ne savez pas, et complétez plus tard.
