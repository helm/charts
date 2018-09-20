# Barbarian

Barbarian is the world's best cloud-first, cloud-agnostic big data system founded on Apache Hadoop for enterprise-ready parallel distributed data processing at scale.

This release brings:
- Apache Hadoop 2.8.4
- Apache Hive 3.1, with LLAP & Tez
- Apache Zookeeper 3.5
- Apache Ignite as a distributed, parallel write-through cache of your big data backing store (nb. only s3 is supported by Barbarian today)

Read more at:

https://barbarians.io/
  

## Helm Charts

This repo contains the Helm charts for installing the Barbarian big data system on Kubernetes.


## Installing

Install the charts with the following commands. Note that some configuration parameters must be supplied.

- ```helm repo add barbarians http://charts.barbarians.org/barbarian```
- ```helm install -f my-custom-config.yaml barbarians/barbarian```

## Configuration Parameters

Barbarian exposes many configuration parameters. Some important ones are listed below

| parameter | default | description
|--|--|--|
| hive_hms.count | 3 | how many Metastores to deploy |
| hive_hms.db_auto | false | automatically deploy a MariaDb instance for the HMS? |
| hive_hms.db_uri | n/a | JDBC URI for your HMS RDBMS |
| hive_hms.db_username | n/a | Username for your HMS RDBMS |
| hive_hms.db_password | n/a | Password for your HMS RDBMS |
| hive_hms.db_type | mysql | Currently only tested against Mariadb
| hive_hms.db_driver | org.mariadb.jdbc.Driver | Currently only tested against Mariadb
| hive_hs2.llapd_enabled | true | automatically deploy Hive LLAP? |
| hive_hs2.llapd_count | 4 | How many LLAP daemons to deploy |
| hive_hs2.llapd_mem | 24g | How much RAM to allocate to each LLAP daemon |
| hive_hs2.ingress_enabled | false | should Hiveserver2 be exposed to the outside? |
| yarn_rm.count | 1 | How many YARN RMs to deploy. Currently only supports 1 |
| yarn_nm.count | 5 | How many YARN NodeManagers to deploy |
| zookeeper.count | 5 | How many ZooKeepers to deploy |
| ignite.count | 5 | How many IGFS servers to deploy |
| ignite.secondary_fs_uri | n/a | Filesystem URI in the form s3a://YOUR_BUCKET/. Currently only supports S3a. Other filesystem will be supported in the future |
| ignite.s3a.access_key_id | n/a | AWS S3 access key ID |
| ignite.s3a.secret_access_key | n/a | AWS S3 secret access key |
| ignite.s3a.endpoint | s3-eu-west-1.amazonaws.com | S3 regional endpoint to connect to |
| ignite.s3a.ssl_enabled | true | disable this if using an S3 API compatible storage system that doesn't use SSL |
| ignite.s3a.s3guard_ddb.create | true | set up a dynamodb table to defend against eventual consistency |
| ignite.s3a.s3guard_ddb.region | eu-west-1 | AWS Dyanomdb region for the table |
| ignite.s3a.s3guard_ddb.capacity.read | 3 | You pay AWS for this whether you use it or not |
| ignite.s3a.s3guard_ddb.capacity.write | 3 | You pay AWS for this whether you use it or not |


