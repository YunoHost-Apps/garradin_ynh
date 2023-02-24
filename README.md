<!--
N.B.: This README was automatically generated by https://github.com/YunoHost/apps/tree/master/tools/README-generator
It shall NOT be edited by hand.
-->

# Garradin for YunoHost

[![Integration level](https://dash.yunohost.org/integration/garradin.svg)](https://dash.yunohost.org/appci/app/garradin) ![Working status](https://ci-apps.yunohost.org/ci/badges/garradin.status.svg) ![Maintenance status](https://ci-apps.yunohost.org/ci/badges/garradin.maintain.svg)

[![Install Garradin with YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=garradin)

*[Lire ce readme en français.](./README_fr.md)*

> *This package allows you to install Garradin quickly and simply on a YunoHost server.
If you don't have YunoHost, please consult [the guide](https://yunohost.org/#/install) to learn how to install it.*

## Overview

Garradin (word meaning money in an aboriginal dialect of northern Australia, pronounced "gar-a-dine" em) is software for associative management. It is the tool of choice for managing an association, a sports club, an NGO, etc. It is designed to meet the needs of a small to medium-sized structure: management of members, accounting, website, note-taking in meetings, archiving and sharing of the association's operating documents, discussion between members, etc. etc. . 

**Shipped version:** 1.2.6~ynh1

**Demo:** https://garradin.eu/essai/

## Screenshots

![Screenshot of Garradin](./doc/screenshots/screenshot.png)

## Disclaimers / important information

# Garradin becomes Paheko!
## Why change your name?

It appeared that the pronunciation of "Garradin" in French is sometimes a bit complicated, as is its spelling.

There is already a commercial software called "Garradin" in Australia, which does finance for large groups. For the moment this was not a problem because our association management solution was only available in French and until then did not have much scope. But we would like to be able to offer the software in other languages in the years to come, and as Garradin (the French project) is starting to be quite well known, it seems necessary to limit the risk of confusion in the future with this commercial solution.

You can now upgrade Garradin with Paheko ! 
Don't stay with this repository, it will be no more supported.

Take a Look at the Paheko repository and read the instructions how to migrate your application Garradin to Paheko: 

https://github.com/YunoHost-Apps/paheko_ynh/

## Documentation and resources

* Official app website: <http://garradin.eu>
* Official admin documentation: <https://fossil.kd2.org/garradin/wiki?name=Documentation>
* Upstream app code repository: <https://fossil.kd2.org/garradin/dir?ci=tip>
* YunoHost documentation for this app: <https://yunohost.org/app_garradin>
* Report a bug: <https://github.com/YunoHost-Apps/garradin_ynh/issues>

## Developer info

Please send your pull request to the [testing branch](https://github.com/YunoHost-Apps/garradin_ynh/tree/testing).

To try the testing branch, please proceed like that.

``` bash
sudo yunohost app install https://github.com/YunoHost-Apps/garradin_ynh/tree/testing --debug
or
sudo yunohost app upgrade garradin -u https://github.com/YunoHost-Apps/garradin_ynh/tree/testing --debug
```

**More info regarding app packaging:** <https://yunohost.org/packaging_apps>
