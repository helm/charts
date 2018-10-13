# PostgreSQL

[Cachet](https://cachethq.io/) is an open source status page system for everyone.

## TL;DR;

```bash
$ helm install incubator/cachet
```

## Introduction

This chart bootstraps a [Cachet](https://cachethq.io/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure (Only when persisting data)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/cachet
```

The command deploys Cachet on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the PostgreSQL chart and their default values.

| Parameter                      | Description                                                   | Default                                                            |
| ------------------------------ | ------------------------------------------------------------- | ------------------------------------------------------------------ |
| `replicaCount`                 | k8s replicas                                                  | `1`                                                                |
| `image`                        | `cachet` image repository                                     | `cachethq/docker`                                                  |
| `imageTag`                     | `cachet` image tag                                            | `2.3.13`                                                           |
| `imagePullPolicy`              | `cachet` image pull policy                                    | `IfNotPresent`                                                     |
| `key`                          | `cachet` application key                                      | `base64:Vx7JbMYQI+YvBfxk5kXxIiLub2AC9qXETotxBgfDv4c=`              |
| `log`                          | `cachet` log                                                  | `errorlog`                                                         |
| `debug`                        | `cachet` debug                                                | `false`                                                            |
| `url`                          | `cachet` application url                                      | `http://chart-example.local`                                       |
| `session.domain`               | `cachet` session domain                                       | `chart-example.local`                                              |
| `session. secureCookie`        | `cachet` session secure cookie                                | `z5bXJgV7ZqhrzXSLp8QWBhg37kuz2jL5LeFF2AAaLKJZnyxba9RtLcPYsWgcAPBA` |
| `postgresql.enabled`           | Spin up PostgreSQL instance as part of the release            | `true`                                                             |
| `postgresql.postgresDatabase`  | PostgreSQL Database                                           | `cachet`                                                           |
| `postgresql.postgresUser`      | PostgreSQL username                                           | `cachet`                                                           |
| `postgresql.postgresPassword`  | PostgreSQL password                                           | `yexbpHvEBGUqCUEGPpzM4eVS8BZbnq2xuNkPBS26d38xGtkTs627evKxnnugWw3B` |
| `postgresql.service.type`      | PostgreSQL k8s service type exposing ports, e.g. `NodePort`   | `ClusterIP`                                                        |
| `postgresql.service.port`      | PostgresSQL k8s service port                                  | `5432`                                                             |
| `postgresql.service.resources` | PostreSQL CPU/Memory resource requests/limits                 | Memory: `256Mi`, CPU: `100m`                                       |
| `db.driver`                    | Cachet DB driver to use if `postgresql.enabled` = `false`     | `pgsql`                                                            |
| `db.host`                      | Cachet DB host to use if `postgresql.enabled` = `false`       | `nil`                                                              |
| `db.port`                      | Cachet DB port to use if `postgresql.enabled` = `false`       | `nil`                                                              |
| `db.database`                  | Cachet DB database to use if `postgresql.enabled` = `false`   | `nil`                                                              |
| `db.username`                  | Cachet DB username to use if `postgresql.enabled` = `false`   | `nil`                                                              |
| `db.password`                  | Cachet DB password to use if `postgresql.enabled` = `false`   | `nil`                                                              |
| `db.prefix`                    | Cachet DB prefix to use if `postgresql.enabled` = `false`     | `chq_`                                                             |
| `redis.enabled`                | Spin up Redis instance as part of the release                 | `true`                                                             |
| `redis.redisPassword`          | Redis password                                                | `8k65Mgv4NS9EQ5HSALZhaQUyzZadzXYdyG8MpQ2WmLuPzmHchVVccDWqJWFy3QUv` |
| `redis.persistence.enabled`    | Use a PVC to persist Redis data                               | `false`                                                            |
| `redis.service.resources`      | Redis CPU/Memory resource requests/limits                     | Memory: `256Mi`, CPU: `100m`                                       |
| `service.type`                 | k8s service type exposing ports, e.g. `NodePort`              | `ClusterIP`                                                        |
| `service.nodePort`             | NodePort value if service.type is `NodePort`                  | `nil`                                                              |
| `ingress.enabled`              | If true, Ingress will be created                              | `false`                                                            |
| `ingress.annotations`          | Ingress annotations                                           | {}                                                                 |
| `ingress.hosts`                | Ingress hostnames	                                         | []                                                                 |
| `ingress.tls`                  | Ingress TLS configuration (YAML)                              | []                                                                 |
| `resources`                    | CPU/Memory resource requests/limits                           | Memory: `256Mi`, CPU: `100m`                                       |
| `nodeSelector`                 | Node labels for pod assignment                                | {}                                                                 |
| `affinity`                     | Affinity settings for pod assignment                          | {}                                                                 |
| `tolerations`                  | Toleration labels for pod assignment                          | []                                                                 |

The above parameters map to the env variables defined in [Cachet](https://github.com/CachetHQ/Docker). For more information please refer to the [Cachet Docker variables](https://github.com/CachetHQ/Docker/blob/master/conf/.env.docker).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set url=http://example.com,key=base64:Vx7JbMYQI+YvBfxk5kXxIiLub2AC9qXETotxBgfDv4c=,postgresql.postgresPassword=secretpassword, \
    incubator/cachet
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/cachet
```

> **Tip**: You can use the default [values.yaml](values.yaml)

For more info on customizing 

## Further customization

For more advanced customization see the following:

[Cachet Documentation](https://docs.cachethq.io/docs)

[PostgreSQL chart](../../stable/postgresql/README.md)

[Redis Chart](../../stable/redis/README.md)
