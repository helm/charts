# PostgreSQL

[PostgreSQL](https://postgresql.org) is a powerful, open source object-relational database system. It has more than 15 years of active development and a proven architecture that has earned it a strong reputation for reliability, data integrity, and correctness.

## TL;DR;

```bash
$ helm install stable/postgresql
```

## Introduction

This chart bootstraps a [PostgreSQL](https://github.com/docker-library/postgres) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure (Only when persisting data)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/potgresql
```

The command deploys PostgreSQL on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the PostgresSQL chart and their default values.

| Parameter                  | Description                                | Default                                                    |
| -----------------------    | ----------------------------------         | ---------------------------------------------------------- |
| `imageTag`                 | `postgres` image tag                       | `9.5.4`                                           |
| `imagePullPolicy`          | Image pull policy                          | `Always` if `imageTag` is `latest`, else `IfNotPresent`    |
| `postgresUser`             | Username of new user to create.            | `potgres`                                                  |
| `postgresPassword`         | Password for the new user.                 | random 10 characters                                       |
| `postgresDatabase`         | Name for new database to create.           | `postgres`                                                 |
| `persistence.enabled`      | Use a PVC to persist data                  | `true`                                                     |
| `persistence.storageClass` | Storage class of backing PVC               | `generic`                                                  |
| `persistence.accessMode`   | Use volume as ReadOnly or ReadWrite        | `ReadWriteOnce`                                            |
| `persistence.size`         | Size of data volume                        | `8Gi`                                                      |

The above parameters map to the env variables defined in [postgres](http://github.com/docker-library/postgres). For more information please refer to the [postgres](http://github.com/docker-library/postgres) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set posstgresUser=my-user,postgresPassword=secretpassword,postgresDatabase=my-database \
    stable/postgresql
```

The above command creates a PostgresSQL user named `root` with password `secretpassword`. Additionally it creates a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/postgresql
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [postgres](https://github.com/docker-library/postgres) image stores the PostgreSQL data and configurations at the `/var/lib/postgresql/data/pgdata` path of the container.

The chart mounts a [Persistent Volume](kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning.
