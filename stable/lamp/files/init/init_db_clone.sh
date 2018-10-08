#!/bin/bash

export WEBDIR=/var/www/html

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

function init_from_backup
{
	#change owner of httpdir
	chown -R www-data:www-data /var/www/html

	#change owner of mysqldir
	chown -R mysql:mysql /var/lib/mysql

	start_mysql "$OLD_MYSQL_ROOT_PASSWORD"

  mysqladmin -uroot -p"$OLD_MYSQL_ROOT_PASSWORD" password "$MYSQL_ROOT_PASSWORD"
	mysql -uroot -p"$OLD_MYSQL_ROOT_PASSWORD" -e "ALTER USER 'root' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; flush privileges"

	stop_mysql

	echo "Successfully prepared mysql backup."
}

if [ -e "$WEBDIR/db_clone_initialized" ]; then
	echo "Pod already initialized, continuing..."
else
	init_from_backup
	touch "$WEBDIR/db_clone_initialized"
fi
