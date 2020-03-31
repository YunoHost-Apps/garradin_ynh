
#=================================================
# COMMON VARIABLES
#=================================================
ynh_install_php --phpversion=7.2

YNH_PHP_VERSION="7.2"
extra_pkg_dependencies="php${YNH_PHP_VERSION}-bz2 php${YNH_PHP_VERSION}-imap php${YNH_PHP_VERSION}-gmp php${YNH_PHP_VERSION}-gd php${YNH_PHP_VERSION}-json php${YNH_PHP_VERSION}-intl php${YNH_PHP_VERSION}-curl php${YNH_PHP_VERSION}-apcu php${YNH_PHP_VERSION}-redis php${YNH_PHP_VERSION}-ldap php${YNH_PHP_VERSION}-zip php${YNH_PHP_VERSION}-mbstring php${YNH_PHP_VERSION}-xml php${YNH_PHP_VERSION}-sqlite3"


# Remove the specific version of php used by the app.
#
# usage: ynh_install_php
ynh_remove_php () {
  # Get the version of php used by this app
  local phpversion=$(ynh_app_setting_get $app phpversion)

  # Remove the line for this app
  sed --in-place "/$YNH_APP_INSTANCE_NAME:$phpversion/d" "/etc/php/ynh_app_version"

  # If no other app uses this version of php, remove it.
  if ! grep --quiet "$phpversion" "/etc/php/ynh_app_version"
  then
    # Purge php dependences for this version.
    ynh_package_autopurge "php$phpversion php${phpversion}-fpm php${phpversion}-common"
    # Remove the service from the admin panel
    yunohost service remove php${phpversion}-fpm
  fi

  # If no other app uses alternate php versions, remove the extra repo for php
  if [ ! -s "/etc/php/ynh_app_version" ]
  then
    ynh_secure_remove /etc/php/ynh_app_version
  fi
}
ynh_delete_file_checksum () {
	local checksum_setting_name=checksum_${1//[\/ ]/_}	# Replace all '/' and ' ' by '_'
	ynh_app_setting_delete $app $checksum_setting_name
}

 #=================================================
    # CHANGE THE FAKE DEPENDENCIES PACKAGE
    #=================================================

    # Check if a variable $pkg_dependencies exists
    # If this variable doesn't exist, this part shall be managed in the upgrade script.
    if [ -n "${pkg_dependencies:-}" ]
    then
      # Define the name of the package
      local old_package_name="${old_app//_/-}-ynh-deps"
      local new_package_name="${new_app//_/-}-ynh-deps"

      if ynh_package_is_installed "$old_package_name"
      then
        # Install a new fake package
        app=$new_app
        ynh_install_app_dependencies $pkg_dependencies
        # Then remove the old one
        app=$old_app
        ynh_remove_app_dependencies
      fi
    fi

    # Define the values to configure php-fpm
#
# usage: ynh_get_scalable_phpfpm --usage=usage --footprint=footprint [--print]
# | arg: -f, --footprint      - Memory footprint of the service (low/medium/high).
# low    - Less than 20Mb of ram by pool.
# medium - Between 20Mb and 40Mb of ram by pool.
# high   - More than 40Mb of ram by pool.
# Or specify exactly the footprint, the load of the service as Mb by pool instead of having a standard value.
# To have this value, use the following command and stress the service.
# watch -n0.5 ps -o user,cmd,%cpu,rss -u APP
#
# | arg: -u, --usage     - Expected usage of the service (low/medium/high).
# low    - Personal usage, behind the sso.
# medium - Low usage, few people or/and publicly accessible.
# high   - High usage, frequently visited website.
#
# | arg: -p, --print - Print the result
#
#
#
# The footprint of the service will be used to defined the maximum footprint we can allow, which is half the maximum RAM.
# So it will be used to defined 'pm.max_children'
# A lower value for the footprint will allow more children for 'pm.max_children'. And so for
#    'pm.start_servers', 'pm.min_spare_servers' and 'pm.max_spare_servers' which are defined from the
#    value of 'pm.max_children'
# NOTE: 'pm.max_children' can't exceed 4 times the number of processor's cores.
#
# The usage value will defined the way php will handle the children for the pool.
# A value set as 'low' will set the process manager to 'ondemand'. Children will start only if the
#   service is used, otherwise no child will stay alive. This config gives the lower footprint when the
#   service is idle. But will use more proc since it has to start a child as soon it's used.
# Set as 'medium', the process manager will be at dynamic. If the service is idle, a number of children
#   equal to pm.min_spare_servers will stay alive. So the service can be quick to answer to any request.
#   The number of children can grow if needed. The footprint can stay low if the service is idle, but
#   not null. The impact on the proc is a little bit less than 'ondemand' as there's always a few
#   children already available.
# Set as 'high', the process manager will be set at 'static'. There will be always as many children as
#   'pm.max_children', the footprint is important (but will be set as maximum a quarter of the maximum
#   RAM) but the impact on the proc is lower. The service will be quick to answer as there's always many
#   children ready to answer.
ynh_get_scalable_phpfpm () {
    local legacy_args=ufp
    # Declare an array to define the options of this helper.
    declare -Ar args_array=( [u]=usage= [f]=footprint= [p]=print )
    local usage
    local footprint
    local print
    # Manage arguments with getopts
    ynh_handle_getopts_args "$@"
    # Set all characters as lowercase
    footprint=${footprint,,}
    usage=${usage,,}
    print=${print:-0}

    if [ "$footprint" = "low" ]
    then
        footprint=20
    elif [ "$footprint" = "medium" ]
    then
        footprint=35
    elif [ "$footprint" = "high" ]
    then
        footprint=50
    fi

    # Define the way the process manager handle child processes.
    if [ "$usage" = "low" ]
    then
        php_pm=ondemand
    elif [ "$usage" = "medium" ]
    then
        php_pm=dynamic
    elif [ "$usage" = "high" ]
    then
        php_pm=static
    else
        ynh_die --message="Does not recognize '$usage' as an usage value."
    fi

    # Get the total of RAM available, except swap.
    local max_ram=$(ynh_check_ram --no_swap)

    less0() {
        # Do not allow value below 1
        if [ $1 -le 0 ]
        then
            echo 1
        else
            echo $1
        fi
    }

    # Define pm.max_children
    # The value of pm.max_children is the total amount of ram divide by 2 and divide again by the footprint of a pool for this app.
    # So if php-fpm start the maximum of children, it won't exceed half of the ram.
    php_max_children=$(( $max_ram / 2 / $footprint ))
    # If process manager is set as static, use half less children.
    # Used as static, there's always as many children as the value of pm.max_children
    if [ "$php_pm" = "static" ]
    then
        php_max_children=$(( $php_max_children / 2 ))
    fi
    php_max_children=$(less0 $php_max_children)

    # To not overload the proc, limit the number of children to 4 times the number of cores.
    local core_number=$(nproc)
    local max_proc=$(( $core_number * 4 ))
    if [ $php_max_children -gt $max_proc ]
    then
        php_max_children=$max_proc
    fi

    if [ "$php_pm" = "dynamic" ]
    then
        # Define pm.start_servers, pm.min_spare_servers and pm.max_spare_servers for a dynamic process manager
        php_min_spare_servers=$(( $php_max_children / 8 ))
        php_min_spare_servers=$(less0 $php_min_spare_servers)

        php_max_spare_servers=$(( $php_max_children / 2 ))
        php_max_spare_servers=$(less0 $php_max_spare_servers)

        php_start_servers=$(( $php_min_spare_servers + ( $php_max_spare_servers - $php_min_spare_servers ) /2 ))
        php_start_servers=$(less0 $php_start_servers)
    else
        php_min_spare_servers=0
        php_max_spare_servers=0
        php_start_servers=0
    fi

    if [ $print -eq 1 ]
    then
        ynh_debug --message="Footprint=${footprint}Mb by pool."
        ynh_debug --message="Process manager=$php_pm"
        ynh_debug --message="Max RAM=${max_ram}Mb"
        if [ "$php_pm" != "static" ]; then
            ynh_debug --message="\nMax estimated footprint=$(( $php_max_children * $footprint ))"
            ynh_debug --message="Min estimated footprint=$(( $php_min_spare_servers * $footprint ))"
        fi
        if [ "$php_pm" = "dynamic" ]; then
            ynh_debug --message="Estimated average footprint=$(( $php_max_spare_servers * $footprint ))"
        elif [ "$php_pm" = "static" ]; then
            ynh_debug --message="Estimated footprint=$(( $php_max_children * $footprint ))"
        fi
        ynh_debug --message="\nRaw php-fpm values:"
        ynh_debug --message="pm.max_children = $php_max_children"
        if [ "$php_pm" = "dynamic" ]; then
            ynh_debug --message="pm.start_servers = $php_start_servers"
            ynh_debug --message="pm.min_spare_servers = $php_min_spare_servers"
            ynh_debug --message="pm.max_spare_servers = $php_max_spare_servers"
        fi
    fi
}

# Install another version of php.
#
# usage: ynh_install_php --phpversion=phpversion [--package=packages]
# | arg: -v, --phpversion - Version of php to install.
# | arg: -p, --package - Additionnal php packages to install
ynh_install_php () {
  # Declare an array to define the options of this helper.
  local legacy_args=vp
  declare -Ar args_array=( [v]=phpversion= [p]=package= )
  local phpversion
  local package
  # Manage arguments with getopts
  ynh_handle_getopts_args "$@"
  package=${package:-}

  # Store phpversion into the config of this app
  ynh_app_setting_set $app phpversion $phpversion

  if [ "$phpversion" == "7.0" ]
  then
    ynh_die "Do not use ynh_install_php to install php7.0"
  fi

  # Store the ID of this app and the version of php requested for it
  echo "$YNH_APP_INSTANCE_NAME:$phpversion" | tee --append "/etc/php/ynh_app_version"

  # Add an extra repository for those packages
  ynh_install_extra_repo --repo="https://packages.sury.org/php/ $(lsb_release -sc) main" --key="https://packages.sury.org/php/apt.gpg" --priority=995 --name=extra_php_version

  # Install requested dependencies from this extra repository.
  # Install php-fpm first, otherwise php will install apache as a dependency.
  ynh_add_app_dependencies --package="php${phpversion}-fpm"
  ynh_add_app_dependencies --package="php$phpversion php${phpversion}-common $package"

  # Set php7.0 back as the default version for php-cli.
  update-alternatives --set php /usr/bin/php7.0

  # Pin this extra repository after packages are installed to prevent sury of doing shit
  ynh_pin_repo --package="*" --pin="origin \"packages.sury.org\"" --priority=200 --name=extra_php_version
  ynh_pin_repo --package="php7.0*" --pin="origin \"packages.sury.org\"" --priority=600 --name=extra_php_version --append

  # Advertise service in admin panel
  yunohost service add php${phpversion}-fpm --log "/var/log/php${phpversion}-fpm.log"
}

# Remove the specific version of php used by the app.
#
# usage: ynh_install_php
ynh_remove_php () {
  # Get the version of php used by this app
  local phpversion=$(ynh_app_setting_get $app phpversion)

  if [ "$phpversion" == "7.0" ] || [ -z "$phpversion" ]
  then
    if [ "$phpversion" == "7.0" ]
    then
      ynh_print_err "Do not use ynh_remove_php to install php7.0"
    fi
    return 0
  fi

  # Remove the line for this app
  sed --in-place "/$YNH_APP_INSTANCE_NAME:$phpversion/d" "/etc/php/ynh_app_version"

  # If no other app uses this version of php, remove it.
  if ! grep --quiet "$phpversion" "/etc/php/ynh_app_version"
  then
    # Purge php dependences for this version.
    ynh_package_autopurge "php$phpversion php${phpversion}-fpm php${phpversion}-common"
    # Remove the service from the admin panel
    yunohost service remove php${phpversion}-fpm
  fi

  # If no other app uses alternate php versions, remove the extra repo for php
  if [ ! -s "/etc/php/ynh_app_version" ]
  then
    ynh_secure_remove /etc/php/ynh_app_version
  fi
}

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
# Pin a repository.
#
# usage: ynh_pin_repo --package=packages --pin=pin_filter [--priority=priority_value] [--name=name] [--append]
# | arg: -p, --package - Packages concerned by the pin. Or all, *.
# | arg: -i, --pin - Filter for the pin.
# | arg: -p, --priority - Priority for the pin
# | arg: -n, --name - Name for the files for this repo, $app as default value.
# | arg: -a, --append - Do not overwrite existing files.
#
# See https://manpages.debian.org/stretch/apt/apt_preferences.5.en.html for information about pinning.
#
ynh_pin_repo () {
  # Declare an array to define the options of this helper.
  local legacy_args=pirna
  declare -Ar args_array=( [p]=package= [i]=pin= [r]=priority= [n]=name= [a]=append )
  local package
  local pin
  local priority
  local name
  local append
  # Manage arguments with getopts
  ynh_handle_getopts_args "$@"
  package="${package:-*}"
  priority=${priority:-50}
  name="${name:-$app}"
  append=${append:-0}

  if [ $append -eq 1 ]
  then
    append="tee -a"
  else
    append="tee"
  fi

  mkdir -p "/etc/apt/preferences.d"
  echo "Package: $package
Pin: $pin
Pin-Priority: $priority
" \
  | $append "/etc/apt/preferences.d/$name"
}

# Add a repository.
#
# usage: ynh_add_repo --uri=uri --suite=suite --component=component [--name=name] [--append]
# | arg: -u, --uri - Uri of the repository.
# | arg: -s, --suite - Suite of the repository.
# | arg: -c, --component - Component of the repository.
# | arg: -n, --name - Name for the files for this repo, $app as default value.
# | arg: -a, --append - Do not overwrite existing files.
#
# Example for a repo like deb http://forge.yunohost.org/debian/ stretch stable
#                             uri                               suite   component
# ynh_add_repo --uri=http://forge.yunohost.org/debian/ --suite=stretch --component=stable
#
ynh_add_repo () {
  # Declare an array to define the options of this helper.
  local legacy_args=uscna
  declare -Ar args_array=( [u]=uri= [s]=suite= [c]=component= [n]=name= [a]=append )
  local uri
  local suite
  local component
  local name
  local append
  # Manage arguments with getopts
  ynh_handle_getopts_args "$@"
  name="${name:-$app}"
  append=${append:-0}

  if [ $append -eq 1 ]
  then
    append="tee -a"
  else
    append="tee"
  fi

  mkdir -p "/etc/apt/sources.list.d"
  # Add the new repo in sources.list.d
  echo "deb $uri $suite $component" \
    | $append "/etc/apt/sources.list.d/$name.list"
}

# Add an extra repository correctly, pin it and get the key.
#
# usage: ynh_install_extra_repo --repo="repo" [--key=key_url] [--priority=priority_value] [--name=name] [--append]
# | arg: -r, --repo - Complete url of the extra repository.
# | arg: -k, --key - url to get the public key.
# | arg: -p, --priority - Priority for the pin
# | arg: -n, --name - Name for the files for this repo, $app as default value.
# | arg: -a, --append - Do not overwrite existing files.
ynh_install_extra_repo () {
  # Declare an array to define the options of this helper.
  local legacy_args=rkpna
  declare -Ar args_array=( [r]=repo= [k]=key= [p]=priority= [n]=name= [a]=append )
  local repo
  local key
  local priority
  local name
  local append
  # Manage arguments with getopts
  ynh_handle_getopts_args "$@"
  name="${name:-$app}"
  append=${append:-0}
  key=${key:-0}
  priority=${priority:-}

  if [ $append -eq 1 ]
  then
    append="--append"
    wget_append="tee -a"
  else
    append=""
    wget_append="tee"
  fi

  # Split the repository into uri, suite and components.
  # Remove "deb " at the beginning of the repo.
  repo="${repo#deb }"

  # Get the uri
  local uri="$(echo "$repo" | awk '{ print $1 }')"

  # Get the suite
  local suite="$(echo "$repo" | awk '{ print $2 }')"

  # Get the components
  local component="${repo##$uri $suite }"

  # Add the repository into sources.list.d
  ynh_add_repo --uri="$uri" --suite="$suite" --component="$component" --name="$name" $append

  # Pin the new repo with the default priority, so it won't be used for upgrades.
  # Build $pin from the uri without http and any sub path
  local pin="${uri#*://}"
  pin="${pin%%/*}"
  # Set a priority only if asked
  if [ -n "$priority" ]
  then
    priority="--priority=$priority"
  fi
  ynh_pin_repo --package="*" --pin="origin \"$pin\"" $priority --name="$name" $append

  # Get the public key for the repo
  if [ -n "$key" ]
  then
    mkdir -p "/etc/apt/trusted.gpg.d"
    wget -q "$key" -O - | gpg --dearmor | $wget_append /etc/apt/trusted.gpg.d/$name.gpg > /dev/null
  fi

  # Update the list of package with the new repo
  ynh_package_update
}

# Remove an extra repository and the assiociated configuration.
#
# usage: ynh_remove_extra_repo [--name=name]
# | arg: -n, --name - Name for the files for this repo, $app as default value.
ynh_remove_extra_repo () {
  # Declare an array to define the options of this helper.
  local legacy_args=n
  declare -Ar args_array=( [n]=name= )
  local name
  # Manage arguments with getopts
  ynh_handle_getopts_args "$@"
  name="${name:-$app}"

  ynh_secure_remove "/etc/apt/sources.list.d/$name.list"
  ynh_secure_remove "/etc/apt/preferences.d/$name"
  ynh_secure_remove "/etc/apt/trusted.gpg.d/$name.gpg"
  ynh_secure_remove "/etc/apt/trusted.gpg.d/$name.asc"

  # Update the list of package to exclude the old repo
  ynh_package_update
}

# Install packages from an extra repository properly.
#
# usage: ynh_install_extra_app_dependencies --repo="repo" --package="dep1 dep2" [--key=key_url] [--name=name]
# | arg: -r, --repo - Complete url of the extra repository.
# | arg: -p, --package - The packages to install from this extra repository
# | arg: -k, --key - url to get the public key.
# | arg: -n, --name - Name for the files for this repo, $app as default value.
ynh_install_extra_app_dependencies () {
  # Declare an array to define the options of this helper.
  local legacy_args=rpkn
  declare -Ar args_array=( [r]=repo= [p]=package= [k]=key= [n]=name= )
  local repo
  local package
  local key
  local name
  # Manage arguments with getopts
  ynh_handle_getopts_args "$@"
  name="${name:-$app}"
  key=${key:-0}

  # Set a key only if asked
  if [ -n "$key" ]
  then
    key="--key=$key"
  fi
  # Add an extra repository for those packages
  ynh_install_extra_repo --repo="$repo" $key --priority=995 --name=$name

  # Install requested dependencies from this extra repository.
  ynh_add_app_dependencies --package="$package"

  # Remove this extra repository after packages are installed
  ynh_remove_extra_repo --name=$app
}

#=================================================

# patched version of ynh_install_app_dependencies to be used with ynh_add_app_dependencies

# Define and install dependencies with a equivs control file
# This helper can/should only be called once per app
#
# usage: ynh_install_app_dependencies dep [dep [...]]
# | arg: dep - the package name to install in dependence
#   You can give a choice between some package with this syntax : "dep1|dep2"
#   Example : ynh_install_app_dependencies dep1 dep2 "dep3|dep4|dep5"
#   This mean in the dependence tree : dep1 & dep2 & (dep3 | dep4 | dep5)
#
# Requires YunoHost version 2.6.4 or higher.
ynh_install_app_dependencies () {
    local dependencies=$@
    dependencies="$(echo "$dependencies" | sed 's/\([^\<=\>]\)\ \([^(]\)/\1, \2/g')"
    dependencies=${dependencies//|/ | }
    local manifest_path="../manifest.json"
    if [ ! -e "$manifest_path" ]; then
      manifest_path="../settings/manifest.json" # Into the restore script, the manifest is not at the same place
    fi

    local version=$(grep '\"version\": ' "$manifest_path" | cut -d '"' -f 4)  # Retrieve the version number in the manifest file.
    if [ ${#version} -eq 0 ]; then
        version="1.0"
    fi
    local dep_app=${app//_/-} # Replace all '_' by '-'

    # Handle specific versions
    if [[ "$dependencies" =~ [\<=\>] ]]
    then
        # Replace version specifications by relationships syntax
        # https://www.debian.org/doc/debian-policy/ch-relationships.html
        # Sed clarification
        # [^(\<=\>] ignore if it begins by ( or < = >. To not apply twice.
        # [\<=\>] matches < = or >
        # \+ matches one or more occurence of the previous characters, for >= or >>.
        # [^,]\+ matches all characters except ','
        # Ex: package>=1.0 will be replaced by package (>= 1.0)
        dependencies="$(echo "$dependencies" | sed 's/\([^(\<=\>]\)\([\<=\>]\+\)\([^,]\+\)/\1 (\2 \3)/g')"
    fi

    cat > /tmp/${dep_app}-ynh-deps.control << EOF # Make a control file for equivs-build
Section: misc
Priority: optional
Package: ${dep_app}-ynh-deps
Version: ${version}
Depends: ${dependencies}
Architecture: all
Description: Fake package for $app (YunoHost app) dependencies
 This meta-package is only responsible of installing its dependencies.
EOF
    ynh_package_install_from_equivs /tmp/${dep_app}-ynh-deps.control \
        || ynh_die --message="Unable to install dependencies" # Install the fake package and its dependencies
    rm /tmp/${dep_app}-ynh-deps.control
    ynh_app_setting_set --app=$app --key=apt_dependencies --value="$dependencies"
}

ynh_add_app_dependencies () {
  # Declare an array to define the options of this helper.
  local legacy_args=pr
  declare -Ar args_array=( [p]=package= [r]=replace)
  local package
  local replace
  # Manage arguments with getopts
  ynh_handle_getopts_args "$@"
  replace=${replace:-0}

  local current_dependencies=""
  if [ $replace -eq 0 ]
  then
    local dep_app=${app//_/-} # Replace all '_' by '-'
    if ynh_package_is_installed --package="${dep_app}-ynh-deps"
    then
      current_dependencies="$(dpkg-query --show --showformat='${Depends}' ${dep_app}-ynh-deps) "
    fi

    current_dependencies=${current_dependencies// | /|}
  fi

  ynh_install_app_dependencies "${current_dependencies}${package}"
}

