# Sentry

[Sentry](https://sentry.io/) is a cross-platform crash reporting and aggregation platform.

## TL;DR;

```console
$ helm install --wait stable/sentry
```

## Introduction

This chart bootstraps a [Sentry](https://sentry.io/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also optionally packages the [PostgreSQL](https://github.com/kubernetes/charts/tree/master/stable/postgresql) and [Redis](https://github.com/kubernetes/charts/tree/master/stable/redis) which are required for Sentry.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- helm >= v2.3.0 to run "weighted" hooks in right order.
- PV provisioner support in the underlying infrastructure (with persistence storage enabled)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release --wait stable/sentry
```

> **Note**: We have to use the --wait flag for initial creation because the database creation takes longer than the default 300 seconds

The command deploys Sentry on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

> **Warning**: This Chart does not support `helm upgrade` an upgrade will currently reset your installation

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Warning**: Jobs are not deleted automatically. They need to be manually deleted

```console
$ kubectl delete job/sentry-db-init job/sentry-user-create
```

## Configuration

The following table lists the configurable parameters of the Sentry chart and their default values.

| Parameter                            | Description                                 | Default                                                    |
| -------------------------------      | -------------------------------             | ---------------------------------------------------------- |
| `image.repository`                   | Sentry image                                | `library/sentry`                                           |
| `image.tag`                          | Sentry image tag                            | `9.0`                                                      |
| `imagePullPolicy`                    | Image pull policy                           | `IfNotPresent`                                             |
| `web.podAnnotations`                 | Web pod annotations                         | `{}`                                                       |
| `web.podLabels`                     | Worker pod extra labels                     | `{}`                                                       |
| `web.replicacount`                   | Amount of web pods to run                   | `1`                                                        |
| `web.resources.limits`               | Web resource limits                         | `{cpu: 500m, memory: 500Mi}`                               |
| `web.resources.requests`             | Web resource requests                       | `{cpu: 300m, memory: 300Mi}`                               |
| `web.env`                            | Additional web environment variables        | `[{name: GITHUB_APP_ID}, {name: GITHUB_API_SECRET}]`       |
| `web.nodeSelector`                   | Node labels for web pod assignment          | `{}`                                                       |
| `web.affinity`                       | Affinity settings for web pod assignment    | `{}`                                                       |
| `web.schedulerName`                  | Name of an alternate scheduler for web pod  | `nil`                                                      |
| `web.tolerations`                    | Toleration labels for web pod assignment    | `[]`                                                       |
| `cron.podAnnotations`                | Cron pod annotations                        | `{}`                                                       |
| `cron.podLabels`                     | Worker pod extra labels                     | `{}`                                                       |
| `cron.replicacount`                  | Amount of cron pods to run                  | `1`                                                        |
| `cron.resources.limits`              | Cron resource limits                        | `{cpu: 200m, memory: 200Mi}`                               |
| `cron.resources.requests`            | Cron resource requests                      | `{cpu: 100m, memory: 100Mi}`                               |
| `cron.nodeSelector`                  | Node labels for cron pod assignment         | `{}`                                                       |
| `cron.affinity`                      | Affinity settings for cron pod assignment   | `{}`                                                       |
| `cron.schedulerName`                 | Name of an alternate scheduler for cron pod | `nil`                                                      |
| `cron.tolerations`                   | Toleration labels for cron pod assignment   | `[]`                                                       |
| `worker.podAnnotations`              | Worker pod annotations                      | `{}`                                                       |
| `worker.podLabels`                   | Worker pod extra labels                     | `{}`                                                       |
| `worker.replicacount`                | Amount of worker pods to run                | `2`                                                        |
| `worker.resources.limits`            | Worker resource limits                      | `{cpu: 300m, memory: 500Mi}`                               |
| `worker.resources.requests`          | Worker resource requests                    | `{cpu: 100m, memory: 100Mi}`                               |
| `worker.nodeSelector`                | Node labels for worker pod assignment       | `{}`                                                       |
| `worker.schedulerName`               | Name of an alternate scheduler for worker   | `nil`                                                      |
| `worker.affinity`                    | Affinity settings for worker pod assignment | `{}`                                                       |
| `worker.tolerations`                 | Toleration labels for worker pod assignment | `[]`                                                       |
| `user.create`                        | Create the default admin                    | `true`                                                     |
| `user.email`                         | Username for default admin                  | `admin@sentry.local`                                       |
| `email.from_address`                 | Email notifications are from                | `smtp`                                                     |
| `email.host`                         | SMTP host for sending email                 | `smtp`                                                     |
| `email.port`                         | SMTP port                                   | `25`                                                       |
| `email.user`                         | SMTP user                                   | `nil`                                                      |
| `email.password`                     | SMTP password                               | `nil`                                                      |
| `email.use_tls`                      | SMTP TLS for security                       | `false`                                                    |
| `email.enable_replies`               | Allow email replies                         | `false`                                                    |
| `service.type`                       | Kubernetes service type                     | `LoadBalancer`                                             |
| `service.name`                       | Kubernetes service name                     | `sentry`                                                   |
| `service.externalPort`               | Kubernetes external service port            | `9000`                                                     |
| `service.internalPort`               | Kubernetes internal service port            | `9000`                                                     |
| `service.annotations`                | Service annotations                         | `{}`                                                       |
| `service.nodePort`                   | Kubernetes service NodePort port            | Randomly chosen by Kubernetes                              |
| `ingress.enabled`                    | Enable ingress controller resource          | `false`                                                    |
| `ingress.annotations`                | Ingress annotations                         | `{}`                                                       |
| `ingress.hostname`                   | URL to address your Sentry installation     | `sentry.local`                                             |
| `ingress.path`                       | path to address your Sentry installation    | `/`                                                        |
| `ingress.tls`                        | Ingress TLS configuration                   | `[]`                                                       |
| `postgresql.enabled`                 | Deploy postgres server (see below)          | `true`                                                     |
| `postgresql.postgresDatabase`        | Postgres database name                      | `sentry`                                                   |
| `postgresql.postgresUser`            | Postgres username                           | `sentry`                                                   |
| `postgresql.postgresHost`            | External postgres host                      | `nil`                                                      |
| `postgresql.postgresPassword`        | External postgres password                  | `nil`                                                      |
| `postgresql.postgresPort`            | External postgres port                      | `5432`                                                     |
| `redis.enabled`                      | Deploy redis server (see below)             | `true`                                                     |
| `redis.host`                         | External redis host                         | `nil`                                                      |
| `redis.password`                     | External redis password                     | `nil`                                                      |
| `redis.port`                         | External redis port                         | `6379`                                                     |
| `persistence.enabled`                | Enable persistence using PVC                | `true`                                                     |
| `persistence.existingClaim`          | Provide an existing `PersistentVolumeClaim` | `nil`                                                      |
| `persistence.storageClass`           | PVC Storage Class                           | `nil` (uses alpha storage class annotation)                |
| `persistence.accessMode`             | PVC Access Mode                             | `ReadWriteOnce`                                            |
| `persistence.size`                   | PVC Storage Request                         | `10Gi`                                                     |
| `config.configYml`                   | Sentry config.yml file                      | ``                                                         |
| `config.sentryConfPy`                | Sentry sentry.conf.py file                  | ``                                                         |

Dependent charts can also have values overwritten. Preface values with postgresql.* or redis.*

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set persistence.enabled=false,email.host=email \
    stable/sentry
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/sentry
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## PostgresSQL

By default, PostgreSQL is installed as part of the chart. To use an external PostgreSQL server set `postgresql.enabled` to `false` and then set `postgresql.postgresHost` and `postgresql.postgresPassword`. The other options (`postgresql.postgresDatabase`, `postgresql.postgresUser` and `postgresql.postgresPort`) may also want changing from their default values.

## Redis

By default, Redis is installed as part of the chart. To use an external Redis server/cluster set `redis.enabled` to `false` and then set `redis.host`. If your redis cluster uses password define it with `redis.password`, otherwise just omit it. Check the table above for more configuration options.

## Persistence

The [Sentry](https://github.com/getsentry/docker-sentry) image stores the Sentry data  at the `/var/lib/sentry/files` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Ingress

This chart provides support for Ingress resource. If you have an available Ingress Controller such as Nginx or Traefik you maybe want to set `ingress.enabled` to true and choose an `ingress.hostname` for the URL. Then, you should be able to access the installation using that address.
