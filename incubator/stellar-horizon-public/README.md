# stellar-horizon

A starter helm chart for stellar-horizon based on [stellar-horizon](https://hub.docker.com/r/satoshipay/stellar-horizon)

Upstream development: https://github.com/charyorde/stellar-horizon

## Prerequisites
- You must have a running [stellar-core](https://github.com/helm/charts/tree/master/stable/stellar-core) helm chart

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/stellar-horizon
```

## Configuration
| Parameter                           | Description                                                        | Default                                          |
| -----------------------             | ---------------------------------------------                      | ---------------------------------------------    |
| `stellarCoreUrl`                    | Stellar Core URL                                                   | `http://stellar-core-http:11626`                 |
| `stellarCorePostgresDatabase`       | Stellar Core postgres DB name                                      | stellar-core
| `stellarCoreIngest        `         | ingest data from Stellar Core (true/false)                         | `true`
| `environment`                       | Additional environment variables for Stellar Core                  | `{}`                                             |
| `postgresql.enabled`                | Enable PostgreSQL database                                         | `false`                                          |
| `postgresql.postgresDatabase`       | PostgreSQL database name                                           | `stellar-core`                                   |
| `postgresql.postgresUser`           | PostgreSQL username                                                | `postgres`                                       |
| `postgresql.postgresPassword`       | PostgreSQL password                                                | Random password (see PostgreSQL chart)           |
| `postgresql.persistence`            | PostgreSQL persistence options                                     | See PostgreSQL chart                             |
| `postgresql.*`                      | Any PostgreSQL option                                              | See PostgreSQL chart                             |
| `existingDatabase`                  | Provide existing database (used if `postgresql.enabled` is `false`)|                                                  |
| `existingDatabase.passwordSecret`   | Existing secret with the database password                         | `{name: 'postgresql-core', value: 'password'}`   |
| `existingDatabase.url`              | Existing database URL (use `$(DATABASE_PASSWORD` as the password)  | Not set                                          |
| `existingDatabase.stellarUrl`       | Existing stellar core database URL (use `$(DATABASE_PASSWORD`)     | Not set                                          |
| `image.repository`                  | `stellar-horizon` image repository                                 | `satoshipay/stellar-horizon`                        |
| `image.tag`                         | `stellar-horizon` image tag                                        | `latest`                                        |
| `image.flavor`                      | `stellar-horizon` flavor (e.g., `aws` or `gcloud`)                 | Not set                                          |
| `image.pullPolicy`                  | Image pull policy                                                  | `IfNotPresent`                                   |
| `horizonService.type`               | horizon service type                                               | `LoadBalancer`                                   |
| `horizonService.port`               | horizon service TCP port                                           | `8000`                                          |
| `horizonService.loadBalancerIP`     | horizon service load balancer IP                                   | Not set                                          |
| `horizonService.externalTrafficPolicy` | horizon service traffic policy                                  | Not set                                          |
| `httpService.type`                  | Non-public HTTP admin endpoint service type                        | `ClusterIP`                                      |
| `httpService.port`                  | Non-public HTTP admin endpoint TCP port                            | `8000`                                          |
| `persistence.enabled`               | Use a PVC to persist data                                          | `true`                                           |
| `persistence.existingClaim`         | Provide an existing PersistentVolumeClaim                          | Not set                                          |
| `persistence.storageClass`          | Storage class of backing PVC                                       | Not set (uses alpha storage class annotation)    |
| `persistence.accessMode`            | Use volume as ReadOnly or ReadWrite                                | `ReadWriteOnce`                                  |
| `persistence.annotations`           | Persistent Volume annotations                                      | `{}`                                             |
| `persistence.size`                  | Size of data volume                                                | `8Gi`                                            |
| `persistence.subPath`               | Subdirectory of the volume to mount at                             | `stellar-horizon`                                   |
| `persistence.mountPath`             | Mount path of data volume                                          | `/data`                                          |
| `resources`                         | CPU/Memory resource requests/limits                                | Requests: `512Mi` memory, `100m` CPU             |
| `nodeSelector`                      | Node labels for pod assignment                                     | {}                                               |
| `tolerations`                       | Toleration labels for pod assignment                               | []                                               |
| `affinity`                          | Affinity settings for pod assignment                               | {}                                               |
| `serviceAccount.create`             | Specifies whether a ServiceAccount should be created               | `true`                                           |
| `serviceAccount.name`               | The name of the ServiceAccount to create                           | Generated using the fullname template            |

## Persistence

Both Stellar Core and PostgreSQL (if `postgresql.enabled` is `true`) need to store data and thus this chart creates [Persistent Volumes](http://kubernetes.io/docs/user-guide/persistent-volumes/) by default. Make sure to size them properly for your needs and use an appropriate storage class, e.g. SSDs.

You can also use existing claims with the `persistence.existingClaim` and `postgresql.persistence.existingClaim` options.
