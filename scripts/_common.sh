#!/bin/bash

CHECK_VAR () {	# Vérifie que la variable n'est pas vide.
# $1 = Variable à vérifier
# $2 = Texte à afficher en cas d'erreur
	test -n "$1" || (echo "$2" >&2 && false)
}

CHECK_PATH () {	# Vérifie la présence du / en début de path. Et son absence à la fin.
	if [ "${path:0:1}" != "/" ]; then    # Si le premier caractère n'est pas un /
		path="/$path"    # Ajoute un / en début de path
	fi
	if [ "${path:${#path}-1}" == "/" ] && [ ${#path} -gt 1 ]; then    # Si le dernier caractère est un / et que ce n'est pas le seul caractère.
		path="${path:0:${#path}-1}"	# Supprime le dernier caractère
	fi
}

CHECK_DOMAINPATH () {	# Vérifie la disponibilité du path et du domaine.
	sudo yunohost app checkurl $domain$path -a $app
}

CHECK_FINALPATH () {	# Vérifie que le dossier de destination n'est pas déjà utilisé.
	final_path=/var/www/$app
	if [ -e "$final_path" ]
	then
		echo "This path already contains a folder" >&2
		false
	fi
}

GARRADIN_VERSION="0.7.7"
GARRADIN_SOURCE_URL="http://dev.kd2.org/garradin/files/garradin-${GARRADIN_VERSION}.tar.bz2"

extract_source() {
  local DESTDIR=$1
    
  # retrieve and extract Garradin tarball
  rc_tarball="${DESTDIR}/garradin.tar.gz"
  sudo wget -q -O "$rc_tarball" "$GARRADIN_SOURCE_URL" \
    || ynh_die "Unable to download source tarball"
  sudo tar -xf "$rc_tarball" -C "$DESTDIR" --strip-components 1 \
    || ynh_die "Unable to extract source tarball"
  sudo rm "$rc_tarball"
}
