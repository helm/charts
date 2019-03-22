# Predator Helm Chart

[Predator](https://github.com/Zooz/predator) is an open-source performance testing framework. Predator manages the entire lifecycle of stress-testing a server, from creating a test file, to running scheduled and on-demand tests, and finally viewing the test results in a highly informative report. Bootstrapped with a user-friendly UI alongside a simple REST API, Predator helps developers simplify the performance testing regime.
                                             


## TL;DR;

```console
$ helm install stable/predator
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/predator
```

The command deploys predator on the Kubernetes cluster with the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete --purge my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

By default `predator` runs in with sqlite as it's storage, so it doesn't actually persist anything other than in memory.
`predator` supports other storage backends like Cassandra, postgresSQL, MySql and SQL Server.
If you want to use any of this database just install with these configuration:

```console
$ helm install ./predator --set database.type=MYSQL,database.name=predator,database.address=mysql.default,database.password=cHJlZGF0b3I=,database.password=cHJlZGF0b3I=
```

The following tables lists the configurable parameters of the PostgreSQL chart and their default values.


| Parameter            | Description                                                      | Default                                      |
| -------------------- | ---------------------------------------------------------------- | -------------------------------------------- |
| `image.repository`   | container image                                                  | `zooz/predator                        `      |
| `image.tag`          | container image tag                                              | `Latest`                                     |
| `image.pullPolicy`   | Operator container image pull policy                             | `Always`                                     |
| `nameOverride`       | Override the app name                                            |                                              |
| `fullnameOverride`   | Override the app full name                                       |                                              |
| `resources`          | Set the resource to be allocated and allowed for the Pods        | `{}`                                         |
| `ingress.enabled`    | If true, an ingress is be created                                | `false`
| `ingress.annotations`| Annotations for the ingress                                      | `{}`
| `ingress.path`       | Path for backend                                                 | `/`
| `ingress.hosts`      | A list of hosts for the ingresss                                 | `['predator.local']`
| `ingress.tls`        | Ingress TLS configuration                                        | `[]`
| `nodeSelector`       | Node labels for pod assignment                                   | `{}`                                         |
| `tolerations`        | Tolerations for pod assignment                                   | `[]`                                         |
| `affinity`           | Affinity settings for pod assignment                             | `{}`                                         |
| `service.type`       | type of controller service to create                             | `ClusterIP`
| `database.type`      | chosen storage backend, Optional Values: SQLITE, CASSANDRA, MYSQL, POSTGRES AND SQLSERVER | `SQLITE`
| `datbase.name`       | the name of the database/keyspace with the selected database type|
| `database.username`  | Database username                                                |                                              |
| `database.password`  | Database password                                                |                                              |
| `database.cassandra.replicationFactor`  | replication factor for cassandra              | `1`                                          |
| `database.cassandra.keySpaceStrategy`  | key space strategy for cassandra               | `SimpleStrategy`                             |
| `database.cassandra.localDataCenter`  | local data center for cassandra                                                                |                                              |
