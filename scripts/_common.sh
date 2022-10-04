#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================
# PHP APP SPECIFIC
#=================================================

YNH_PHP_VERSION="8.0"

php_dependencies="php${YNH_PHP_VERSION} php${YNH_PHP_VERSION}-sqlite3 php${YNH_PHP_VERSION}-gd php${YNH_PHP_VERSION}-intl  php${YNH_PHP_VERSION}-cli php${YNH_PHP_VERSION}-gnupg"

# dependencies used by the app (must be on a single line)
pkg_dependencies="$php_dependencies"

#=================================================
# PERSONAL HELPERS
#=================================================

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
