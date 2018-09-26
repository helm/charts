# Barbarian

The Barbarian Data System is the world's best cloud-first, cloud-agnostic data processing system founded on Apache Hadoop for enterprise-ready, low-latency parallel distributed data processing.

This release brings:
- Apache Hadoop 2.8.4
- Apache Hive 3.1, with LLAP & Tez
- Apache Zookeeper 3.5
- Apache Ignite 2.6

Barbarian is designed to run as a horizontally scalable parallel, distributed, *in memory* data warehouse - a bit like SAP Hana™ but with a low TCO.

Barbarian can ingest data from Amazon S3 or a remote HDFS cluster for high performance, low latency analysis, or alternatively Barbarian can be configured to run as a Big Data solution accessing Amazon S3 - using its own storage as an in-memory write-through cache. There is also a hybrid mode whereby Barbarian mounts common paths in memory and acts as a write-through cache for everything else.

We will be adding support for more storage backends including Azure ADLS, GCP Cloud Storage, and Ceph in coming releases.

By default, Barbarian comes with Hive transactional table support, meaning inline record updates are possible for slowly changing dimensions and change-data-capture. You need to use the appropriate Hive syntax when creating a table for this to work:

```
CREATE TABLE mytable (id string, value1 string, value2 int)
CLUSTERED BY (id) INTO 5 BUCKETS
STORED AS ORC
TBLPROPERTIES ("transactional"="true");
```

More info at Apache https://cwiki.apache.org/confluence/display/Hive/Hive+Transactions.

You can load data into Barbarian by declaring an external table over a directory in S3, like this:
```
CREATE EXTERNAL TABLE mys3table (id string, value1 string, value2 int)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 's3a://my-bucket/my-prefix';
INSERT INTO mytable SELECT id, value1, value2 FROM mys3table;
```

Read more at:
https://barbarians.io/

## Helm Charts

This repo contains the Helm charts for installing the Barbarian Data System on Kubernetes.


## Installing

Install the Barbarian Data System with the following commands.

- ```helm install --name my-barbarian incubator/barbarian```

## Uninstalling

To uninstall/delete the ```my-barbarian``` deployment:

- ```helm delete my-barbarian```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Trying it out

To quickly run a query from the shell, connect to the hiveserver2 node and fire up beeline:
```
HS2_HOST=$(kubectl get pods | grep hive-hs2 | awk '{ print $1 }' | tail -n 1)
kubectl exec -it $HS2_HOST /bin/bash
/opt/barbarian/hive/bin/beeline
!connect jdbc:hive2://localhost:10000
< hit enter twice >
set hive.execution.engine=tez;
set hive.llap.io.memory.mode=cache;
set hive.llap.execution.mode=all;
set hive.llap.io.enabled=true;
set hive.llap.daemon.service.hosts=@llap;
set hive.execution.mode=llap;
CREATE TABLE mytable (id string, value1 string, value2 int);
INSERT INTO mytable SELECT 'one', 'world', 1;
SELECT * FROM mytable;
```

## Configuration Parameters

Barbarian exposes many configuration parameters. Some important ones are listed below.

| parameter | default | description |
|--|--|--|
| global.tez_init | true | automatically install the Tez sharelib? |
| hive_hms.ha_enabled | true | deploy Hive Metastore in HA N+N setup? |
| hive_hms.db_auto | true | automatically deploy a MariaDb instance for the HMS? |
| hive_hms.db_init | true | automatically initialize the db schema for HMS? |
| hive_hms.db_uri | n/a | JDBC URI for your remote HMS RDBMS |
| hive_hms.db_username | n/a | Username for your remote HMS RDBMS |
| hive_hms.db_password | n/a | Password for your remote HMS RDBMS |
| hive_hms.db_type | mysql | Currently only tested against Mariadb
| hive_hms.db_driver | org.mariadb.jdbc.Driver | Currently only tested against Mariadb
| hive_hs2.llapd_enabled | true | automatically deploy Hive LLAP? |
| hive_hs2.llapd_count | 4 | How many LLAP daemons to deploy. You can elastically scale Tez but not LLAP, so choose wisely  |
| hive_hs2.llapd_mem | 2g | How much RAM to allocate to each LLAP daemon in production contexts this should be at least 24G, preferably more |
| hive_hs2.ingress_enabled | false | should Hiveserver2 be exposed to the outside? |
| yarn_rm.ha_enabled | true | Should YARN ResourceManager be deployed as an HA pair? |
| yarn_nm.count | 5 | How many YARN NodeManagers to deploy |
| zookeeper.count | 5 | How many ZooKeepers to deploy |
| ignite.count | 5 | How many IGFS servers to deploy |
| ignite.ingress_enabled | false | should the Ignite in-memory filesystem be exposed to the outside? |
| ignite.secondary_fs_enabled | false | Enable a persistent backing store? |
| ignite.hybrid | false | Enable hybrid storage configuration? |
| ignite.data.replicas | 3 | IGFS data replication factor |
| ignite.meta.replicas | 3 | IGFS metadata replication factor |
| ignite.secondary_fs_uri | n/a | Filesystem URI in the form s3a://YOUR_BUCKET/. Currently only supports S3a. Other filesystem will be supported in the future |
| ignite.s3a.access_key_id | n/a | AWS S3 access key ID |
| ignite.s3a.secret_access_key | n/a | AWS S3 secret access key |
| ignite.s3a.endpoint | s3-eu-west-1.amazonaws.com | S3 regional endpoint to connect to |
| ignite.s3a.ssl_enabled | true | disable this if using an S3 API compatible storage system that doesn't use SSL |
| ignite.s3a.s3guard_ddb.create | true | set up a dynamodb table to defend against eventual consistency |
| ignite.s3a.s3guard_ddb.region | eu-west-1 | AWS Dyanomdb region for the table |
| ignite.s3a.s3guard_ddb.capacity.read | 3 | You pay AWS for this whether you use it or not |
| ignite.s3a.s3guard_ddb.capacity.write | 3 | You pay AWS for this whether you use it or not |
| mariadb.db.password | password123! | change this to something else! |
| mariadb.rootUser.password | n/a | Set this if you need to |

## Troubleshooting

If you encounter provisioning issues with MariaDb where it gets stuck on "pending", this is likely to be because you haven't enabled persistent storage claims. To enable persistent storage on AWS EKS you can run something like:

```
echo "\
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: gp2
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
reclaimPolicy: Retain
mountOptions:
  - debug
" > /tmp/storage-class.yaml

kubectl create -f /tmp/storage-class.yaml
kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```
