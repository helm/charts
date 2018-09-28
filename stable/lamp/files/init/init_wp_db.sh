#!/bin/bash
shopt -s expand_aliases

export WEBDIR=/var/www/html
export MYSQLDIR=/var/www/mysql

alias msql="mysql -uroot -p\"$MYSQL_ROOT_PASSWORD\" -e"
alias wpc="su www-data -s /bin/bash -c"
SQLHEADER=$(cat <<EOF
-- MySQL dump 10.13  Distrib 5.5.52, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: xc218_db1
-- ------------------------------------------------------
-- Server version       5.5.52-0+deb7u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
EOF
)

function exit_clean
{
	exit 1
}

function start_mysql
{
	if [ -z "$1" ]; then
		PASSWORD="$MYSQL_ROOT_PASSWORD"
	else
		PASSWORD="$1"
	fi

	/entrypoint.sh mysqld &

	until mysql -uroot -p"$PASSWORD" -e ";"
	do
		echo "Can't connect to mysql, retrying in 5 seconds."
		sleep 5
	done
}

function stop_mysql
{
	mysqladmin -uroot -p"$MYSQL_ROOT_PASSWORD" shutdown

	while ! [ -z "$(ps aux | grep mysqld | grep -v grep)" ]
	do
		sleep 1
	done
}

function search-replace
{
	if ! [ -z "$WEB_DOMAIN" ] && ! [ -z "$WEB_TEST_DOMAIN" ];  then
		echo "Search replacing: $WEB_DOMAIN with $WEB_TEST_DOMAIN"
		wpc "wp --path=$WEBDIR search-replace --all-tables $WEB_DOMAIN $WEB_TEST_DOMAIN"
		if ! [ "$?" -eq 0 ]; then
			return 1
		fi
		echo "Search replacing: www.$WEB_TEST_DOMAIN $WEB_TEST_DOMAIN"
		wpc "wp --path=$WEBDIR search-replace --all-tables www.$WEB_TEST_DOMAIN $WEB_TEST_DOMAIN"
		if ! [ "$?" -eq 0 ]; then
			return 1
		fi

		if [ "$SSL_ENABLED" == "true" ]; then
			echo "Search replacing: http://$WEB_TEST_DOMAIN with https://$WEB_TEST_DOMAIN"
			wpc "wp --path=$WEBDIR search-replace --all-tables http://$WEB_TEST_DOMAIN https://$WEB_TEST_DOMAIN"
			if ! [ "$?" -eq 0 ]; then
				return 1
			fi
		else
			echo "Search replacing: https://$WEB_TEST_DOMAIN with http://$WEB_TEST_DOMAIN"
			wpc "wp --path=$WEBDIR search-replace --all-tables https://$WEB_TEST_DOMAIN http://$WEB_TEST_DOMAIN"
			if ! [ "$?" -eq 0 ]; then
				return 1
			fi
		fi

		echo "Search replacing: @$WEB_TEST_DOMAIN with @$WEB_DOMAIN"
		wpc "wp --path=$WEBDIR search-replace --all-tables @$WEB_TEST_DOMAIN @$WEB_DOMAIN"
		if ! [ "$?" -eq 0 ]; then
			return 1
		fi
	fi

	return 0
}

function init_from_sql
{
	name="$(grep DB_ $WEBDIR/wp-config.php)"

	re="define ?\( ?'DB_NAME' ?, ?'([^']+)' ?\);"
	if [[ $name =~ $re ]]; then
	export MYSQL_DATABASE=${BASH_REMATCH[1]};
	else
	echo "Could not get DB Name from wp-config.php. Aborting."
	exit_clean
	fi

	re="define ?\( ?'DB_USER' ?, ?'([^']+)' ?\);"
	if [[ $name =~ $re ]]; then
	export MYSQL_USER=${BASH_REMATCH[1]};
	else
	echo "Could not get DB User from wp-config.php. Aborting."
	exit_clean
	fi

	re="define ?\( ?'DB_PASSWORD' ?, ?'([^']+)' ?\);"
	if [[ $name =~ $re ]]; then
	export MYSQL_PASSWORD=${BASH_REMATCH[1]};
	else
	echo "Could not get DB Password from wp-config.php. Aborting."
	exit_clean
	fi

	start_mysql

	LATEST_SQL="$(ls -t $MYSQLDIR/*.sql | head -n1)"

	grep "MySQL dump" "$LATEST_SQL" 1>/dev/null
	if [ "$?" -eq 1 ]; then
		echo "MySQL header missing, adding to sql file..."
		(echo "$SQLHEADER" && cat "$LATEST_SQL") > "$LATEST_SQL.tmp"
		mv "$LATEST_SQL.tmp" "$LATEST_SQL"
	fi

	echo "Importing SQL file..."
	mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < "$LATEST_SQL"

	if ! [ "$?" -eq 0 ]; then
	echo "Could not import DB, exiting..."
	exit_clean
	fi

	if ! [ -z "$WEB_TEST_DOMAIN" ]; then
		until search-replace
		do
			echo "Search Replace failed, retrying in 30 seconds"
			sleep 30
		done
	fi

	stop_mysql

	echo "Successfully imported and prepared backup sql image."
}

function init_from_backup
{
	start_mysql

	OLD_DOMAIN=$(wpc "wp --path=$WEBDIR option get siteurl" | sed "s/.*\/\/\(.*\)/\1/g")

	echo "Search replacing: $OLD_DOMAIN with $WEB_TEST_DOMAIN"
	wpc "wp --path=$WEBDIR search-replace --all-tables $OLD_DOMAIN $WEB_TEST_DOMAIN"
	if ! [ "$?" -eq 0 ]; then
		return 1
	fi

	stop_mysql

	echo "Successfully prepared backup files."
}

if [ -e "$WEBDIR/db_initialized" ]; then
	echo "DB already initialized, continuing..."
else
	if [ -z "$CLONE_INIT" ]; then
		init_from_sql
	elif ! [ -z "$WEB_TEST_DOMAIN" ]; then
		init_from_backup
	fi

	touch "$WEBDIR/db_initialized"
fi
