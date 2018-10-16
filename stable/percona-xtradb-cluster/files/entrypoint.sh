#!/bin/bash
set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

. /startup-scripts/functions.sh

ipaddr=$(hostname -i | awk ' { print $1 } ')
hostname=$(hostname)
echo "I AM $hostname - $ipaddr"

# if command starts with an option, prepend mysqld
if [ "${1:0:1}" = '-' ]; then
    CMDARG="$@"
fi

cluster_join=$(resolveip -s "${K8S_SERVICE_NAME}" || echo "")
if [[ -z "${cluster_join}" ]]; then
    echo "I am the Primary Node"
    init_mysql
    write_password_file
    exec mysqld --user=mysql --wsrep_cluster_name=$SHORT_CLUSTER_NAME --wsrep_node_name=$hostname \
    --wsrep_cluster_address=gcomm:// --wsrep_sst_method=xtrabackup-v2 \
    --wsrep_sst_auth="xtrabackup:$XTRABACKUP_PASSWORD" \
    --wsrep_node_address="$ipaddr" $CMDARG
else
    echo "I am not the Primary Node"
    chown -R mysql:mysql /var/lib/mysql
    touch /var/log/mysqld.log
    chown mysql:mysql /var/log/mysqld.log
    write_password_file
    exec mysqld --user=mysql --wsrep_cluster_name=$SHORT_CLUSTER_NAME --wsrep_node_name=$hostname \
    --wsrep_cluster_address="gcomm://$cluster_join" --wsrep_sst_method=xtrabackup-v2 \
    --wsrep_sst_auth="xtrabackup:$XTRABACKUP_PASSWORD" \
    --wsrep_node_address="$ipaddr" $CMDARG
fi
