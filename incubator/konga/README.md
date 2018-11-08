# Konga

[Konga](https://pantsel.github.io/konga) provides an elegant and clean GUI that handles the [Kong](https://konghq.com/kong-community-edition/) Admin API.

## TL;DR;

```bash
$ helm install incubator/konga
```

## Introduction

This chart bootstraps a [Konga](https://pantsel.github.io/konga) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/konga
```

The command deploys Konga on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Konga chart and their default values.

| Parameter                  | Description                         | Default                                                   |
| -------------------------- | ----------------------------------- | --------------------------------------------------------- |
| `image.repository` | Konga image | `pantsel/konga` |
| `image.tag`|Tag identifier|`0.13.0`|
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
|`service.type`|Type of the service|`ClusterIP`|
|`service.port`|Exposed Port|`80`|
|`service.annotations`|Annotations|`{}`|
| `env.port` | The port that will be used by Konga's server | `1337` |
| `env.database` | The database that Konga will use. If not set, the localDisk db will be used. | `postgres` |
| `env.environment` | production, development | `development` |
| `env.hook_timeout` | Time in `ms` that Konga will wait for startup tasks to finish before exiting the process. | `60000` |
| `postgresql.enabled` | Use postgress database as storage backend | `true` |
| `postgresql.postgresUser` | DB user | `postgres` |
| `postgresql.postgresPassword`   | DB password | _random 10 character alphanumeric string_ |
| `postgresql.postgresDatabase` | DB Schema | `konga_database` |
| `postgresql.service.port` | DB port | `5432` |
| `postgresql.prepareDb` | DB migration required | `true` |

The above parameters map to the env variables defined in [pantsel/konga](https://hub.docker.com/r/pantsel/konga/). For more information please refer to the [pantsel/konga](https://github.com/pantsel/konga) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set postgresql.postgresUser=konga \
    incubator/konga
```

The above command sets the Konga database password to `konga`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/konga
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Konga](https://github.com/pantsel/konga) image stores the Konga dashboard data and configurations at the `postgres` database.

The chart either spins up a database [Postgres](https://github.com/helm/charts/tree/master/stable/postgresql) DB at this location. The DB is created as part of the dependensy chart provisioning.
