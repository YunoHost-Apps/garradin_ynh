# Garradin

[![Integration level](https://dash.yunohost.org/integration/garradin.svg)](https://dash.yunohost.org/appci/app/garradin) ![](https://ci-apps.yunohost.org/ci/badges/garradin.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/garradin.maintain.svg)  
[![Install Garradin with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=garradin)

*[Lire ce readme en français.](./README_fr.md)*

> *This package allows you to install Garradin quickly and simply on a YunoHost server.  
If you don't have YunoHost, please consult [the guide](https://yunohost.org/#/install) to learn how to install it.*

## Overview
Garradin is a free association managing software.

**Shipped version:** 0.9.6

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
