<?php

/**
 * NE PAS MODIFIER CE FICHIER!
 *
 * Ce fichier sera mis à jour à chaque nouvelle version de Yunohost
 *
 * Pour ajouter vos configurations personnalisées, rendez-vous dans le fichier config.local.user.php
 *
 */

// Nécessaire pour situer les constantes dans le bon namespace
namespace Garradin;

/**
 * Clé secrète, doit être unique à chaque instance de Garradin
 *
 * Ceci est utilisé afin de sécuriser l'envoi de formulaires
 * (protection anti-CSRF).
 *
 * Cette valeur peut être modifiée sans autre impact que la déconnexion des utilisateurs
 * actuellement connectés.
 *
 * Si cette constante n'est définie, Garradin ajoutera automatiquement
 * une valeur aléatoire dans le fichier config.local.php.
 */

const SECRET_KEY = '__SECRET_KEY__';

/**
 * Adresse URI de la racine du site Garradin
 * (doit se terminer par un slash)
 *
 * Défaut : découverte automatique à partir de SCRIPT_NAME
 */

const WWW_URI = '__PATH__/';

/**
 * Activer la possibilité de faire une mise à jour semi-automatisée
 * depuis fossil.kd2.org.
 *
 * Si mis à TRUE, alors un bouton sera accessible depuis le menu "Configuration"
 * pour faire une mise à jour en deux clics.
 *
 * Il est conseillé de désactiver cette fonctionnalité si vous ne voulez pas
 * permettre à un utilisateur de casser l'installation !
 *
 * Défaut : true, ajout pour l'environement Yunohost défaut : false
 *
 * @var bool
 */

const ENABLE_UPGRADES = false;

/**
 * Since 1.2.4, I downgraded the default SQLite journal mode to TRUNCATE instead of WAL because 
 * it might have been a cause of corruption on some hosting providers using NFS.
 *
 * I don't think that Yunohost can use NFS, so you should set it back to WAL 
 * by adding the following line to config.local.php when installing:
*/

const SQLITE_JOURNAL_MODE = 'WAL';

