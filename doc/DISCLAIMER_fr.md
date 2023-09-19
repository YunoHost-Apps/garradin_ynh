# Garradin devient Paheko ! 
## Pourquoi changer de nom ? 
Il est apparu que la prononciation de « Garradin » en Français est parfois un peu compliquée, tout comme son orthographe. 

Il existe déjà un logiciel commercial appelé « Garradin » en Australie, qui finance de grands groupes. Pour le moment, ce n'était pas un problème car notre solution de gestion d'association n'était disponible qu'en Français et n'avait jusque-là pas beaucoup de portée. Mais nous aimerions pouvoir proposer le logiciel dans d'autres langues dans les années à venir, et comme Garradin (le projet Français) commence à être assez connu, il semble nécessaire de limiter les risques de confusion à l'avenir avec cette solution commerciale. 

Vous pouvez dès maintenant mettre à niveau Garradin avec Paheko ! 

Ne continuez pas avec ce dépôt, il ne sera plus maintenu. Lisez ces instructions pour migrer votre application Garradin vers Paheko :

### Migrer depuis Garradin

Ce paquet supporte la migration de Garradin vers Paheko. Pour ce faire, vous allez devoir mettre à jour l'application Garradin à l'aide de ce dépôt. Cette opération ne peut se faire seulement depuis une interface en ligne de commande, autrement dit en SSH. Une fois connecté/e, vous devez simplement lancer la commande suivante :

```bash
sudo yunohost app upgrade garradin -u https://github.com/YunoHost-Apps/paheko_ynh/tree/garradin-migration --debug
```

L'option debug vous permet de voir l'entièreté du journal d'installation. Si vous rencontrez des difficultés, merci de créer un ticket en collant le journal d'erreur.

**Important** : Après la migration, veuillez attendre quelques instants (maximum 3 minutes) avant de commencer à utiliser Paheko.

Une fois la migration terminée, vous pourrez mettre à jour avec la dernière version stable de Paheko

```
sudo yunohost app upgrade paheko