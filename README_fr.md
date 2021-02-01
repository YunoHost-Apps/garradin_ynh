# Garradin pour YunoHost

[![Niveau d'intégration](https://dash.yunohost.org/integration/garradin.svg)](https://dash.yunohost.org/appci/app/garradin) ![](https://ci-apps.yunohost.org/ci/badges/garradin.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/garradin.maintain.svg)
[![Installer Garradin avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=garradin)

*[Read this readme in english.](./README.md)*

> *Ce package vous permet d'installer Garradin rapidement et simplement sur un serveur YunoHost.
Si vous n'avez pas YunoHost, consultez [le guide](https://yunohost.org/#/install) pour apprendre comment l'installer.*

## Vue d'ensemble
Garradin est un logiciel libre de gestion associative. il permet de gérer des membres.

**Version incluse :** 1.0.4

## Captures d'écran

![](images/membre.png)
![](images/compta.png)
![](images/emails.png)
![](images/wiki.png)
![](images/site.jpg)

## Démo

* [Démo officielle](https://garradin.eu/essai/)

## Documentation

 * Documentation officielle : https://fossil.kd2.org/garradin/wiki?name=Documentation

## Caractéristiques spécifiques YunoHost

#### Support multi-utilisateur

* L'authentification LDAP n'est pas disponible.

#### Architectures supportées

* x86-64 - [![Build Status](https://ci-apps.yunohost.org/ci/logs/garradin%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/garradin/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/garradin%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/garradin/)

## Limitations

* Garradin n'est disponible qu'en français.
* N'installez pas cette apllication à la racine du domaine par défaut sans ajouter un sous-domaine. Sinon la page de connexion SSO sera remplacée par la page d'accueil de Garradin.

## Liens

 * Signaler un bug : https://github.com/YunoHost-Apps/garradin_ynh/issues
 * Site de l'application : http://garradin.eu
 * Dépôt de l'application principale : https://fossil.kd2.org/garradin/wiki?name=Garradin
 * Site web YunoHost : https://yunohost.org/

---

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/garradin_ynh/tree/testing).

Pour essayer la branche testing, procédez comme suit.
```
sudo yunohost app install https://github.com/YunoHost-Apps/garradin_ynh/tree/testing --debug
ou
sudo yunohost app upgrade garradin -u https://github.com/YunoHost-Apps/garradin_ynh/tree/testing --debug
```
