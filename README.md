# Garradin

## Garradin est un logiciel libre de gestion associative. il permet de gérer des membres.


### State : Testing/Production ###
report issue/rapport de bogues: https://github.com/frju365/garradin_ynh/issues
site de garradin : http://garradin.eu

[![Integration level](https://dash.yunohost.org/integration/garradin.svg)](https://ci-apps.yunohost.org/jenkins/job/garradin%20%28Community%29/lastBuild/consoleFull)<br>
[![Install Garradin with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=garradin)

## Installation : 
### CLI
`sudo yunohost app install https://github.com/Yunohost-Apps/garradin_ynh`

### À travers l'interface d'administration

### TODO list : 
- Backup de la base de donnée SQlite (AIDE REQUISE) ?

#### Problèmes / Avertissements : 
- le système SSO n'est pas implémenté, ni l'installation directe. L'utilisateur admin devra créer son compte avec le formulaire de création de compte qu'il trouvera à la fin de l'installation. Plusieurs raisons m'ont poussé à ne pas implémenter le SSO : 
  - Le SSO n'est pas implémenté dans l'app originale.
  - Avoir 150+ utilisateurs dans Yunohost n'est pas très pratique, ni très sécurisé, et revient en fin de compte à centraliser les services.
  - Ce formulaire laisse le choix à l'administrateur de choisir les modalités de création de son compte. On pourrait peut-être me reprocher de ne pas avoir intégré ce formulaire dans le formulaire d'installation que l'utilisateur remplit avant l'installation de ce paquet. Il est vrai que j'aurais pu mettre les ~dix champs qui compose le formulaire de Garradin, mais je ne trouvais pas cela très pratique.
- Cette application n'est disponible qu'en Français (la loi 1901 sur les asso n'étant appliquée qu'en France).
