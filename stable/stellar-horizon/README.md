# Stellar Horizon

[Stellar](https://www.stellar.org) is an open-source and distributed payments infrastructure. Stellar Horizon is a HTTP REST API server that allows applications to interact with the Stellar network. Stellar Horizon needs access to a Stellar Core node. For more information see the [Stellar network overview](https://www.stellar.org/developers/guides/get-started/).

## Introduction

This chart bootstraps a [Stellar Horizon](https://github.com/stellar/go/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. By default the deployment includes a PostgreSQL database and a Stellar Core node (which in turn includes another PostgreSQL database). The chart is based on the Kubernetes-ready [Stellar Horizon images provided by SatoshiPay](https://github.com/satoshipay/docker-stellar-horizon/).

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure (Only when persisting data)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/stellar-horizon
```

## Configuration

The following table lists the configurable parameters of the Stellar Horizon chart and their default values.

| Parameter                                    | Description                                                            | Default                                          |
| -----------------------                      | ---------------------------------------------                          | ---------------------------------------------    |
| `postgresql.enabled`                         | Enable PostgreSQL database                                             | `true`                                           |
| `postgresql.postgresDatabase`                | PostgreSQL database name                                               | `stellar-core`                                   |
| `postgresql.postgresUser`                    | PostgreSQL username                                                    | `postgres`                                       |
| `postgresql.postgresPassword`                | PostgreSQL password                                                    | Random password (see PostgreSQL chart)           |
| `postgresql.persistence`                     | PostgreSQL persistence options                                         | See PostgreSQL chart                             |
| `postgresql.*`                               | Any PostgreSQL option                                                  | See PostgreSQL chart                             |
| `existingDatabase`                           | Provide existing database (used if `postgresql.enabled` is `false`)    |                                                  |
| `existingDatabase.passwordSecret`            | Existing secret with the database password                             | `{name: 'postgresql-horizon', value: 'password'}`|
| `existingDatabase.url`                       | Existing database URL (use `$(DATABASE_PASSWORD` as the password)      | Not set                                          |
| `stellar-core.enabled`                       | Enable Stellar Core                                                    | `true`                                           |
| `stellar-core.nodeSeed`                      | Node seed for Stellar Core                                             | Not set                                          |
| `stellar-core.*`                             | Any Stellar Core option, see `stellar-core` chart                      |                                                  |
| `stellar-core.postgresql.*`                  | Any PostgreSQL option (for Stellar Core)                               |                                                  |
| `existingStellarCore`                        | Provide existing Stellar Core (used if `stellar-core.enabled` is false)|                                                  |
| `existingStellarCore.url`                    | URL for HTTP admin endpoint of Stellar Core                            | Not set                                          |
| `existingStellarCore.databaseUrl`            | URL for Stellar Core PostgreSQL                                        | Not set                                          |
| `existingStellarCore.databasePasswordSecret` | Existing secret with the Stellar Core PostgreSQL password              | `{name: 'postgresql-core', value: 'password'}`   |
| `environment`                                | Additional environment variables for Stellar Horizon                   | `{}`                                             |
| `image.repository`                           | `stellar-horizon` image repository                                     | `satoshipay/stellar-horizon`                     |
| `image.tag`                                  | `stellar-horizon` image tag                                            | `0.14.2`                                         |
| `image.pullPolicy`                           | Image pull policy                                                      | `IfNotPresent`                                   |
| `service.type`                               | HTTP endpoint service type                                             | `ClusterIP`                                      |
| `service.port`                               | HTTP endpoint TCP port                                                 | `80`                                             |
| `ingress.enabled`                            | Enable ingress controller resource                                     | `false`                                          |
| `ingress.hosts[0].name`                      | Hostname to your Horizon installation                                  | `stellar-horizon.local`                          |
| `ingress.hosts[0].path`                      | Path within the url structure                                          | `/`                                              |
| `ingress.hosts[0].tlsSecret`                 | TLS Secret (certificates)                                              | `stellar-horizon.local-tls-secret`               |
| `ingress.hosts[0].annotations`               | Annotations for this host's ingress record                             | `[]`                                             |
| `ingress.secrets[0].name`                    | TLS Secret Name                                                        | `nil`                                            |
| `ingress.secrets[0].certificate`             | TLS Secret Certificate                                                 | `nil`                                            |
| `ingress.secrets[0].key`                     | TLS Secret Key                                                         | `nil`                                            |
| `resources`                                  | CPU/Memory resource requests/limits                                    | Requests: `512Mi` memory, `100m` CPU             |
| `nodeSelector`                               | Node labels for pod assignment                                         | {}                                               |
| `tolerations`                                | Toleration labels for pod assignment                                   | []                                               |
| `affinity`                                   | Affinity settings for pod assignment                                   | {}                                               |
| `serviceAccount.create`                      | Specifies whether a ServiceAccount should be created                   | `true`                                           |
| `serviceAccount.name`                        | The name of the ServiceAccount to create                               | Generated using the fullname template            |

## Persistence

If PostgreSQL is enabled (`postgresql.enabled` is `true`) or if Stellar Core is enabled (`stellar-core.enabled` is `true`), they need to store data and thus this chart creates [Persistent Volumes](http://kubernetes.io/docs/user-guide/persistent-volumes/) by default. Make sure to size them properly for your needs and use an appropriate storage class, e.g. SSDs.

You can also use existing claims with the `postgresql.persistence.existingClaim` and `stellar-core.persistence.existingClaim` options.
