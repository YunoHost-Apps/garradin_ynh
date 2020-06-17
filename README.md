# Garradin

## Garradin est un logiciel libre de gestion associative. il permet de gérer des membres.


### State : Testing/Production ###

report issue/rapport de bogues: https://github.com/Yunohost-Apps/garradin_ynh/issues
site de garradin : http://garradin.eu

[![Integration level](https://dash.yunohost.org/integration/garradin.svg)](https://ci-apps.yunohost.org/jenkins/job/garradin%20%28Community%29/lastBuild/consoleFull)<br>
[![Install Garradin with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=garradin)

## Installation :
- CLI
`sudo yunohost app install https://github.com/Yunohost-Apps/garradin_ynh`

- À travers l'interface d'administration

### TODO list :
- Permissions de certains fichiers sensibles ?

#### Problèmes / Avertissements :
- le système SSO n'est pas implémenté, ni l'installation directe. L'utilisateur admin devra créer son compte avec le formulaire de création de compte qu'il trouvera à la fin de l'installation. Plusieurs raisons m'ont poussé à ne pas implémenter le SSO :
  - Le SSO n'est pas implémenté dans l'app originale.
  - Avoir 150+ utilisateurs dans Yunohost n'est pas très pratique, ni très sécurisé, et revient en fin de compte à centraliser les services.
  - Ce formulaire laisse le choix à l'administrateur de choisir les modalités de création de son compte. On pourrait peut-être me reprocher de ne pas avoir intégré ce formulaire dans le formulaire d'installation que l'utilisateur remplit avant l'installation de ce paquet. Il est vrai que j'aurais pu mettre les ~dix champs qui compose le formulaire de Garradin, mais je ne trouvais pas cela très pratique.
- Cette application n'est disponible qu'en Français (la loi 1901 sur les asso n'étant appliquée qu'en France).



# Garradin

[![Integration level](https://dash.yunohost.org/integration/garradin.svg)](https://dash.yunohost.org/appci/app/garradin) ![](https://ci-apps.yunohost.org/ci/badges/garradin.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/garradin.maintain.svg)  
[![Install Garradin with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=garradin)

*[Lire ce readme en français.](./README_fr.md)*

> *This package allows you to install Garradin quickly and simply on a YunoHost server.  
If you don't have YunoHost, please consult [the guide](https://yunohost.org/#/install) to learn how to install it.*

## Overview
Garradin is a free association managing software.

**Shipped version:** 0.9.5

## Screenshots

![](images/membre.png)
![](images/compta.png)
![](images/emails.png)
![](images/wiki.png)
![](images/site.jpg)

## Demo

* [Official demo](https://garradin.eu/essai/)


## Documentation

 * Official documentation: https://fossil.kd2.org/garradin/wiki?name=Documentation

## YunoHost specific features

#### Multi-user support

LDAP is not supported yet.

#### Supported architectures

* x86-64 - [![Build Status](https://ci-apps.yunohost.org/ci/logs/garradin%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/garradin/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/garradin%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/garradin/)

## Limitations

* The application is ONLY translated into french.

**More info on the documentation page:**  
https://yunohost.org/packaging_apps

## Links

 * Report a bug: https://github.com/YunoHost-Apps/garradin_ynh/issues
 * App website: https://garradin.eu
 * Upstream app repository: https://fossil.kd2.org/garradin/wiki?name=Garradin
 * YunoHost website: https://yunohost.org/

---

Developer info
----------------

**Only if you want to use a testing branch for coding, instead of merging directly into master.**
Please send your pull request to the [testing branch](https://github.com/YunoHost-Apps/garradin_ynh/tree/testing).

To try the testing branch, please proceed like that.
```
sudo yunohost app install https://github.com/YunoHost-Apps/garradin_ynh/tree/testing --debug
or
sudo yunohost app upgrade REPLACEBYYOURAPP -u https://github.com/YunoHost-Apps/garradin_ynh/tree/testing --debug
```
