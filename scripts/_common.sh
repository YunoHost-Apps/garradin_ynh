#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================
# dependencies used by the app
if [ "$lsb_release --codename --short" = "buster"]; then
  pkg_dependencies="php7.3-sqlite3"
else [ "$lsb_release --codename --short" = "stretch"]
  pkg_dependencies="php7.0-sqlite3"
fi

#=================================================
# PERSONAL HELPERS
#=================================================

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
