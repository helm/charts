# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# ⚠️ Chart Deprecated

# Prisma Helm Chart

[Prisma](https://prisma.io) is a performant open-source GraphQL ORM-like layer doing the heavy lifting in your GraphQL server.

## TL;DR;

```bash
$ helm install stable/prisma
```

## Introduction

This chart bootstraps a Prisma deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

**Note**: This chart doesn't support horizontal scaling for Prisma yet.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/prisma
```

**Note**: Prisma requires a properly configured database in order to initialize. See the `values.yaml` file for the configuration values that need to be set. Also, if preferred you can set `postgresql.enabled` to `true` and Helm will deploy the PostgreSQL chart listed in the `requirements.yaml` file, and Prisma will be able to initialize properly using the default values.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Prisma chart and their default values.

Parameter                        | Description                                  | Default
-------------------------------- | -------------------------------------------- | ---------------------------------------------------------
`serviceAccount.create`          | If true, create a service account for Prisma | `true`
`serviceAccount.name`            | Name of the service account to create or use | `{{ prisma.fullname }}`
`image.repository`               | Prisma image repository                      | `prismagraphql/prisma`
`image.tag`                      | Prisma image tag                             | `1.29.1-heroku`
`image.pullPolicy`               | Image pull policy                            | `IfNotPresent`
`database.connector`             | Database connector                           | `postgres`
`database.host`                  | Host for the database endpoint               | `""`
`database.port`                  | Port for the database endpoint               | `""`
`database.name`                  | Database name for Prisma objects             | `prisma`
`database.user`                  | Database user                                | `prisma`
`database.password`              | Database password                            | `""`
`database.migrations`            | Enable database migrations                   | `true`
`database.ssl`                   | Enable SSL for DB connections                | `false`
`database.connectionLimit`       | The maximum number of database connections   | `2`
`auth.enabled`                   | Enable Prisma Management API authentication  | `false`
`auth.secret`                    | Secret to use for authentication             | `nil`
`service.type`                   | Type of Service                              | `ClusterIP`
`service.port`                   | Service TCP port                             | `4466`
`ingress.enabled`                | Enables Ingress                              | `false`
`ingress.annotations`            | Ingress annotations                          | `{}`
`ingress.path`                   | Ingress path                                 | `/`
`ingress.hosts`                  | Ingress accepted hostnames                   | `[]`
`ingress.tls`                    | Ingress TLS configuration                    | `[]`
`resources`                      | CPU/Memory resource requests/limits          | `{}`
`nodeSelector`                   | Node labels for pod assignment               | `{}`
`affinity`                       | Affinity settings for pod assignment         | `{}`
`tolerations`                    | Toleration labels for pod assignment         | `[]`
`postgresql.enabled`             | Install PostgreSQL chart                     | `false`
`postgresql.imagePullPolicy`     | PostgreSQL image pull policy                 | `Always` if `imageTag` is `latest`, else `IfNotPresent`
`postgresql.persistence.enabled` | Persist data to a PV                         | `false`
`postgresql.postgresUser`        | Username of new user to create               | `prisma`
`postgresql.postgresPassword`    | Password for the new user                    | `""`
`postgresql.service.port`        | PostgreSQL service TCP port                  | `5432`
`postgresql.resources`           | PostgreSQL resource requests and limits      | Memory: `256Mi`, CPU: `100m`

Additional configuration parameters for the PostgreSQL database deployed with Prisma can be found [here](https://github.com/kubernetes/charts/tree/master/stable/postgresql).

> **Tip**: You can use the default [values.yaml](values.yaml)
