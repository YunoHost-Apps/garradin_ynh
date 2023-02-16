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
ynh_send_readme_to_admin() {
	local app_message="${1:-...No specific information...}"
	local recipients="${2:-root}"

	# Retrieve the email of users
	find_mails () {
		local list_mails="$1"
		local mail
		local recipients=" "
		# Read each mail in argument
		for mail in $list_mails
		do
			# Keep root or a real email address as it is
			if [ "$mail" = "root" ] || echo "$mail" | grep --quiet "@"
			then
				recipients="$recipients $mail"
			else
				# But replace an user name without a domain after by its email
				if mail=$(ynh_user_get_info "$mail" "mail" 2> /dev/null)
				then
					recipients="$recipients $mail"
				fi
			fi
		done
		echo "$recipients"
	}
	recipients=$(find_mails "$recipients")

	local mail_subject="☁️🆈🅽🅷☁️: \`$app\` has important message for you"

	local mail_message="This is an automated message from your beloved YunoHost server.
Specific information for the application $app.
$app_message
---
Automatic diagnosis data from YunoHost
$(yunohost tools diagnosis | grep -B 100 "services:" | sed "/services:/d')"
	
	# Define binary to use for mail command
	if [ -e /usr/bin/bsd-mailx ]
	then
		local mail_bin=/usr/bin/bsd-mailx
	else
		local mail_bin=/usr/bin/mail.mailutils
	fi

	# Send the email to the recipients
	echo "$mail_message" | $mail_bin -a "Content-Type: text/plain; charset=UTF-8" -s "$mail_subject" "$recipients"
}
#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
