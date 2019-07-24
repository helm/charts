# Postgres Operator Chart

The Postgres Operator enables highly-available [PostgreSQL](https://www.postgresql.org/)
clusters on Kubernetes (K8s) powered by [Patroni](https://github.com/zalando/spilo).
It is configured only through manifests to ease integration into automated CI/CD
pipelines with no access to Kubernetes directly.

### Operator features

* Rolling updates on Postgres cluster changes
* Volume resize without Pod restarts
* Cloning Postgres clusters
* Logical Backups to S3 Bucket
* Standby cluster from S3 WAL archive
* Configurable for non-cloud environments
* UI to create and edit Postgres cluster manifests

### PostgreSQL features

* Supports PostgreSQL 9.6+
* Streaming replication cluster via Patroni
* Point-In-Time-Recovery with
[pg_basebackup](https://www.postgresql.org/docs/11/app-pgbasebackup.html) /
[WAL-E](https://github.com/wal-e/wal-e) via [Spilo](https://github.com/zalando/spilo)
* Preload libraries: [bg_mon](https://github.com/CyberDem0n/bg_mon),
[pg_stat_statements](https://www.postgresql.org/docs/9.4/pgstatstatements.html),
[pgextwlist](https://github.com/dimitri/pgextwlist),
[pg_auth_mon](https://github.com/RafiaSabih/pg_auth_mon)
* Incl. popular Postgres extensions such as
[decoderbufs](https://github.com/debezium/postgres-decoderbufs),
[hypopg](https://github.com/HypoPG/hypopg),
[pg_cron](https://github.com/citusdata/pg_cron),
[pg_partman](https://github.com/pgpartman/pg_partman),
[pg_stat_kcache](https://github.com/powa-team/pg_stat_kcache),
[pgq](https://github.com/pgq/pgq),
[plpgsql_check](https://github.com/okbob/plpgsql_check),
[postgis](https://postgis.net/),
[set_user](https://github.com/pgaudit/set_user) and
[timescaledb](https://github.com/timescale/timescaledb)

The Postgres Operator has been developed at Zalando and is being used in
production for over two years.

## Installation

To install the chart with the release name `my-release`:

```bash
helm install --name my-release stable/postgres-operator
```

This will create a deployment for the Postgres Operator pod. Check if the
operator is running:

```bash
kubectl get pod -l app.kubernetes.io/name=postgres-operator
```

The helm chart will also register two CustomeResourceDefinitions:

* `postgresql`, which defines the metadata for the Postgres cluster
* `OperatorConfiguration`, which can be used to configure the operator

After this setup you can start to create Postgres clusters simply by passing a
manifest file. A minimal setup looks like this:

```yaml
apiVersion: "acid.zalan.do/v1"
kind: postgresql
metadata:
  name: acid-minimal-cluster
  namespace: default
spec:
  teamId: "ACID"
  volume:
    size: 1Gi
  numberOfInstances: 2
  users:
    # database owner
    zalando:
    - superuser
    - createdb
    # role for application foo
    foo_user: []
  #databases: name->owner
  databases:
    foo: zalando
  postgresql:
    version: "11"
```

After the cluster manifest is submitted the operator will create Service and
Endpoint resources and a StatefulSet which spins up new Pod(s) given the number
of instances specified in the manifest. All resources are named like the
cluster. The database pods can be identified by their number suffix, starting
from `-0`. They run the Spilo container image by Zalando. As for the services
and endpoints, there will be one for the master pod and another one for all the
replicas (`-repl` suffix). Check if all components are coming up. Use the label
`application=spilo` to filter and list the label `spilo-role` to see who is
currently the master.

```bash
# check the deployed cluster
kubectl get postgresql

# check created database pods
kubectl get pods -l application=spilo -L spilo-role

# check created service resources
kubectl get svc -l application=spilo -L spilo-role
```

## Configuration

The operator can be configured by defining an `OperatorConfiguration` custom
resource or by creating a ConfigMap that contains the parameters to be changed.
Choose the `values-crd.yaml` file for CRD-based configuration. When using the
default `values.yaml` file a ConfigMap will be used. The values in both files
represent the internal defaults. For a detailed description of each parameter
checkout out the operator [reference](https://github.com/zalando/postgres-operator/blob/master/docs/reference/operator_parameters.md)

Changing configuration parameters after setting up the operator requires a
restart of the Postgres Operator pod. Only then will the new values be obtained.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```
helm delete my-release
```


### How it works

The operator watches additions, updates, and deletions of PostgreSQL cluster
manifests and changes the running clusters accordingly. For each PostgreSQL
custom resource it creates StatefulSets, Services, and also Postgres roles. For
some configuration changes, e.g. updating a pod's Docker image, the operator
carries out the rolling update.


## Community      

There are two places to get in touch with the community:
1. The [GitHub issue tracker](https://github.com/zalando/postgres-operator/issues)
2. The #postgres-operator slack channel under [Postgres Slack](https://postgres-slack.herokuapp.com)
