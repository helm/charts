#!/bin/bash

write_password_file() {
    if [[ -n "${MYSQL_ROOT_PASSWORD}" ]]; then
        cat <<EOF > /root/.my.cnf
        [client]
        user=root
        password=${MYSQL_ROOT_PASSWORD}
EOF
    fi
}

init_mysql() {
    DATADIR=/var/lib/mysql
    # if we have CLUSTER_JOIN - then we do not need to perform datadir initialize
    # the data will be copied from another node
    if [ ! -e "$DATADIR/mysql" ]; then
        if [ -z "$MYSQL_ROOT_PASSWORD" -a -z "$MYSQL_ALLOW_EMPTY_PASSWORD" -a -z "$MYSQL_RANDOM_ROOT_PASSWORD" -a -z "$MYSQL_ROOT_PASSWORD_FILE" ]; then
            echo >&2 'error: database is uninitialized and password option is not specified '
            echo >&2 '  You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_ROOT_PASSWORD_FILE,  MYSQL_ALLOW_EMPTY_PASSWORD or MYSQL_RANDOM_ROOT_PASSWORD'
            exit 1
        fi

        if [ ! -z "$MYSQL_ROOT_PASSWORD_FILE" -a -z "$MYSQL_ROOT_PASSWORD" ]; then
            MYSQL_ROOT_PASSWORD=$(cat $MYSQL_ROOT_PASSWORD_FILE)
        fi
        mkdir -p "$DATADIR"

        echo "Running --initialize-insecure on $DATADIR"
        ls -lah $DATADIR
        if [ "$PERCONA_MAJOR" = "5.6" ]; then
            mysql_install_db --user=mysql --datadir="$DATADIR"
        else
            mysqld --user=mysql --datadir="$DATADIR" --initialize-insecure
        fi
        chown -R mysql:mysql "$DATADIR" || true # default is root:root 777
        if [ -f /var/log/mysqld.log ]; then
            chown mysql:mysql /var/log/mysqld.log
        fi
        echo 'Finished --initialize-insecure'

        mysqld --user=mysql --datadir="$DATADIR" --skip-networking &
        pid="$!"

        mysql=( mysql --protocol=socket -uroot )

        for i in {30..0}; do
            if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
                break
            fi
            echo 'MySQL init process in progress...'
            sleep 1
        done

        if [ "$i" = 0 ]; then
            echo >&2 'MySQL init process failed.'
            exit 1
        fi

        # sed is for https://bugs.mysql.com/bug.php?id=20545
        mysql_tzinfo_to_sql /usr/share/zoneinfo | sed 's/Local time zone must be set--see zic manual page/FCTY/' | "${mysql[@]}" mysql
        "${mysql[@]}" <<-EOSQL
        -- What's done in this file shouldn't be replicated
        --  or products like mysql-fabric won't work
        SET @@SESSION.SQL_LOG_BIN=0;
        CREATE USER 'root'@'${ALLOW_ROOT_FROM}' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
        GRANT ALL ON *.* TO 'root'@'${ALLOW_ROOT_FROM}' WITH GRANT OPTION ;
        GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION ;
        CREATE USER 'xtrabackup'@'localhost' IDENTIFIED BY '$XTRABACKUP_PASSWORD';
        GRANT RELOAD,PROCESS,LOCK TABLES,REPLICATION CLIENT ON *.* TO 'xtrabackup'@'localhost';
        GRANT REPLICATION CLIENT ON *.* TO monitor@'%' IDENTIFIED BY 'monitor';
        GRANT PROCESS ON *.* TO monitor@localhost IDENTIFIED BY 'monitor';
        CREATE USER 'mysql'@'localhost' IDENTIFIED BY '' ;
        DROP DATABASE IF EXISTS test ;
        FLUSH PRIVILEGES ;
EOSQL

        if [ "$PERCONA_MAJOR" = "5.6" ]; then
            echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}'); FLUSH PRIVILEGES;" | "${mysql[@]}"
        else
            echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;" | "${mysql[@]}"
        fi

        if [ ! -z "$MYSQL_ROOT_PASSWORD" ]; then
            mysql+=( -p"${MYSQL_ROOT_PASSWORD}" )
        fi

        if [ "$MYSQL_DATABASE" ]; then
            echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` ;" | "${mysql[@]}"
            mysql+=( "$MYSQL_DATABASE" )
        fi

        if [ "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]; then
            echo "CREATE USER '"$MYSQL_USER"'@'%' IDENTIFIED BY '"$MYSQL_PASSWORD"' ;" | "${mysql[@]}"

            if [ "$MYSQL_DATABASE" ]; then
                echo "GRANT ALL ON \`"$MYSQL_DATABASE"\`.* TO '"$MYSQL_USER"'@'%' ;" | "${mysql[@]}"
            fi

            echo 'FLUSH PRIVILEGES ;' | "${mysql[@]}"
        fi

        if [ ! -z "$MYSQL_ONETIME_PASSWORD" ]; then
            "${mysql[@]}" <<-EOSQL
            ALTER USER 'root'@'%' PASSWORD EXPIRE;
EOSQL
        fi
        if ! kill -s TERM "$pid" || ! wait "$pid"; then
            echo >&2 'MySQL init process failed.'
            exit 1
        fi

        echo
        echo 'MySQL init process done. Ready for start up.'
        echo
    fi
}
