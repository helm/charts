#!/bin/bash

export WEBDIR=/var/www/html
export MYSQLDIR=/var/www/mysql

function download_backup
{
	if [ -z "$GDRIVE_FOLDER" ]; then
		export GDRIVE_FOLDER="$WEB_DOMAIN"
	fi
	FOLDERID="$(gdrive --refresh-token $RTOKEN list -q "name='$GDRIVE_FOLDER'" --no-header | head -n1 | awk '{print $1;}')"
	FILELIST="$(gdrive --refresh-token $RTOKEN list -q " '$FOLDERID' in parents" --no-header --name-width 0)"
	while read -r line; do
		# continue if not full backup
		if ! [[ "$line" == *"full_"* ]]; then
			continue
		fi

		FILEID=$(echo "$line" | awk '{print $1;}')

		echo "Downloading: $FILEINFO"

		gdrive --refresh-token $RTOKEN download $FILEID

		if ! [ "$?" -eq 0 ]; then
			echo "Failed to download backup file from gdrive, exiting..."
			exit_clean
		fi

		# quit if not part of backup
		if ! [[ "$line" == *"part_"* ]]; then
			break
		fi
	done <<< "$FILELIST"
}

function exit_clean
{
	exit 1
}

function prepare_iwpbackup
{
	cd /var/www
	download_backup

	echo "Unzipping backup(s) to $WEBDIR"
	find . -name '*.zip' | xargs -l unzip -d $WEBDIR

	cd $WEBDIR

	echo "Getting sql file"
	if ! [  1 == "$(find iwp_db/ -name '*.sql' | grep -c sql)" ]; then
		find . -name "*.sql" | awk '{print substr( $0, length($0) - 8, length($0) ),$0}' | sort -n  | cut -f2- -d' ' | xargs cat >  $MYSQLDIR/backup.sql
	else
		mv iwp_db/*sql $MYSQLDIR
	fi

	touch /var/www/html/prepared_db_backup
	rm -r iwp_db/
}

function prepare_html
{
	echo "Removing any existent svn directories"
	find . -name .svn | xargs -n1 rm -rf

	echo "Removing php.ini, if exists"
	rm -f php.ini

	## WP CONFIG ##

	#https proxy
	if [ "$SSL_ENABLED" == "true" ]; then
		sed -i -n 'H;${x;s/require_once.*$/if (isset($_SERVER["HTTP_X_FORWARDED_PROTO"]) \&\& $_SERVER["HTTP_X_FORWARDED_PROTO"] == "https")\
  $_SERVER["HTTPS"] = "on";\
&/;p;}' wp-config.php
	fi

	#mysql port rather than socket

	echo "Replacing strings in config files"
	if [ -z $USE_MYSQL_SOCKETS ]; then
		sed -i -r "s/'DB_HOST' ?, ?'([^']+)'/'DB_HOST', '127.0.0.1'/g" wp-config.php
	else
		sed -i -r "s/'DB_HOST' ?, ?'([^']+)'/'DB_HOST', 'localhost'/g" wp-config.php
	fi

	#hardcoded paths

	sed -i s/^.*WPCACHEHOME.*$/define\(\'WPCACHEHOME\',\'\\/var\\/www\\/html\\/wp-content\\/plugins\\/wp-super-cache\\/\'\)\;/g wp-config.php
	sed -i s/^\$cache_path.*$/\$cache_path=\'\\/var\\/www\\/html\\/wp-content\\/cache\'\;/g wp-content/wp-cache-config.php

#	if ! [ -z "$OLD_HTTP_ROOT" ]; then
#		echo "Search and Replacing old http root dir entries"
#		grep -lr "$OLD_HTTP_ROOT" . | xargs -l sed -i "s/$(echo ${OLD_HTTP_ROOT//\//\\/})/\/var\/www\/html\//"
#	fi

	#htaccess

	echo "Deleting https rules in htaccess"
	cat .htaccess | sed '/First rewrite any request to www with https/,/RewriteRule/ d' | sed '/Force HTTPS/,/RewriteRule/ d' > .htaccess.tmp
	mv .htaccess.tmp .htaccess

	if ! [ -z "$DEVELOPMENT" ]; then
		echo "Removing cache directory"
		rm -rf wp-content/cache/
		if ! [ -z "$DELETE_UPLOADS" ]; then
			echo "Removing uploads directory"
			rm -rf wp-content/uploads/

			echo "Linking uploads directory to live site"
			(echo "#route all access to downloads directory to real site
RewriteRule ^wp-content/uploads/(.*)$ http://www.$WEB_DOMAIN/wp-content/uploads/\$1 [R=302,L]

" && cat .htaccess) > .htaccess.tmp
			mv .htaccess.tmp .htaccess
		fi


		if ! [ -z "$HTACCESS_AUTH" ]; then
			echo "Adding .htaccess Authentication"
			echo "$HTACCESS_AUTH" > .htpasswd
			(echo -e "AuthType Basic\nAuthName \"Authenticate\"\nAuthUserFile /var/www/html/.htpasswd\nRequire valid-user\n" && cat .htaccess) > .htaccess.tmp
			mv .htaccess.tmp .htaccess
		fi
	fi
}

if [ -z "$(ls -A $WEBDIR)" ] || ( [ -n "$MANUAL_INIT" ] && ! [ -e "$WEBDIR/manually_initialized" ] ); then
	if ! [ -z "$SVN_ENABLED" ] && [ -z "$ALLOW_OVERWRITE" ]; then
		export WEBDIR=/tmp/backup
	fi

	if [ -z "$MANUAL_INIT" ]; then
		prepare_iwpbackup
	fi

	prepare_html

	if [ -n "$MANUAL_INIT" ]; then
		touch "$WEBDIR/manually_initialized"
	fi

	echo "Successfully downloaded and prepared backup image."
elif ! [ -e "$WEBDIR/prepared_db_backup" ] && [ -z "$MANUAL_INIT" ]; then
	export WEBDIR=/tmp/backup
	mkdir $WEBDIR
	prepare_iwpbackup

	echo "Successfully downloaded and prepared db backup."
else
	echo "Web Dir already initialized, continuing..."
fi
