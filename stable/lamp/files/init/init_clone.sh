#!/bin/bash

export WEBDIR=/data/web
export DBDIR=/data/db
export CLONEWEBDIR=/clone_data/web
export CLONEDBDIR=/clone_data/db
if [ -n "$(ls -A $WEBDIR)" ]; then
	echo "Pod already initialized, continuing..."
else
	xtrabackup -uroot -p"$MYSQL_ROOT_PASSWORD" -H$MYSQL_HOST -h $CLONEDBDIR --backup --target-dir=$DBDIR

	if ! [ "$?" -eq 0 ]; then
		echo "Failed to generate DB backup, exiting..."
		exit 1
	fi

	xtrabackup --prepare --target-dir=$DBDIR
	rsync -avzh $CLONEWEBDIR/ $WEBDIR

	if ! [ "$?" -eq 0 ]; then
		echo "Failed to clone html files, exiting..."
		exit 1
	fi

	rm "$WEBDIR/db_initialized"

  echo "Successfully copied all data."
fi
