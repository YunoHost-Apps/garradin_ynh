<?php

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
 * Commande de création de PDF
 *
 * Commande qui sera exécutée pour créer un fichier PDF à partir d'un HTML.
 * Si laissé non spécifié (ou NULL), Garradin essaiera de détecter une solution entre
 * PrinceXML, Chromium, wkhtmltopdf ou weasyprint.
 *
 * %1$s sera remplacé par le chemin du fichier HTML, et %2$s par le chemin du fichier PDF.
 *
 * Exemple : chromium --headless --print-to-pdf=%2$s %1$s
 *
 * Défaut : null
 */
//const PDF_COMMAND = 'wkhtmltopdf %2$s %1$s';

/**
 * Clé de licence
 *
 * Cette clé permet de débloquer certaines fonctionnalités dans des extensions officielles.
 *
 * Pour l'obtenir il faut se créer un compte sur Garradin.eu
 * et faire une contribution financière.
 * La clé apparaîtra ensuite en dessous des informations
 * de l'association dans la page "Mon abonnement Garradin.eu".
 *
 * Il faut recopier cette clé dans le fichier config.local.php
 * dans la constante CONTRIBUTOR_LICENSE.
 *
 * Merci de ne pas essayer de contourner cette licence et de contribuer au
 * financement de notre travail :-)
 */
//const CONTRIBUTOR_LICENSE = 'XXXXX';