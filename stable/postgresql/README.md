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
$ helm install --name my-release stable/postgresql
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

The following table lists the configurable parameters of the PostgreSQL chart and their default values.

| Parameter                  | Description                                     | Default                                                    |
| -----------------------    | ---------------------------------------------   | ---------------------------------------------------------- |
| `image`                    | `postgres` image repository                     | `postgres`                                                 |
| `imageTag`                 | `postgres` image tag                            | `9.6.2`                                                    |
| `imagePullPolicy`          | Image pull policy                               | `Always` if `imageTag` is `latest`, else `IfNotPresent`    |
| `imagePullSecrets`         | Image pull secrets                              | `nil`                                                      |
| `postgresUser`             | Username of new user to create.                 | `postgres`                                                 |
| `postgresPassword`         | Password for the new user.                      | random 10 characters                                       |
| `usePasswordFile`          | Inject the password via file instead of env var | `false`                                                    |
| `postgresDatabase`         | Name for new database to create.                | `postgres`                                                 |
| `postgresInitdbArgs`       | Initdb Arguments                                | `nil`                                                      |
| `schedulerName`            | Name of an alternate scheduler                  | `nil`                                                      |
| `existingSecret`           | Use Existing secret for Admin password          | `nil`                                                      |
| `postgresConfig`           | Runtime Config Parameters                       | `nil`                                                      |
| `pgHbaConf`                | Content of pg\_hba.conf                         | `nil (do not create pg_hba.conf)`                          |
| `persistence.enabled`      | Use a PVC to persist data                       | `true`                                                     |
| `persistence.existingClaim`| Provide an existing PersistentVolumeClaim       | `nil`                                                      |
| `persistence.storageClass` | Storage class of backing PVC                    | `nil` (uses alpha storage class annotation)                |
| `persistence.accessMode`   | Use volume as ReadOnly or ReadWrite             | `ReadWriteOnce`                                            |
| `persistence.annotations`  | Persistent Volume annotations                   | `{}`                                                       |
| `persistence.size`         | Size of data volume                             | `8Gi`                                                      |
| `persistence.subPath`      | Subdirectory of the volume to mount at          | `postgresql-db`                                            |
| `persistence.mountPath`    | Mount path of data volume                       | `/var/lib/postgresql/data/pgdata`                          |
| `persistence.resourcePolicy` | set resource-policy Helm annotation on PVC. Can be nil or "keep" | `nil`                                   |
| `resources`                | CPU/Memory resource requests/limits             | Memory: `256Mi`, CPU: `100m`                               |
| `metrics.enabled`          | Start a side-car prometheus exporter            | `false`                                                    |
| `metrics.image`            | Exporter image                                  | `wrouesnel/postgres_exporter`                              |
| `metrics.imageTag`         | Exporter image                                  | `v0.1.1`                                                   |
| `metrics.imagePullPolicy`  | Exporter image pull policy                      | `IfNotPresent`                                             |
| `metrics.resources`        | Exporter resource requests/limit                | Memory: `256Mi`, CPU: `100m`                               |
| `metrics.customMetrics`    | Additional custom metrics                       | `nil`                                                      |
| `service.externalIPs`      | External IPs to listen on                       | `[]`                                                       |
| `service.port`             | TCP port                                        | `5432`                                                     |
| `service.type`             | k8s service type exposing ports, e.g. `NodePort`| `ClusterIP`                                                |
| `service.nodePort`         | NodePort value if service.type is `NodePort`    | `nil`                                                      |
| `networkPolicy.enabled`    | Enable NetworkPolicy                            | `false`                                                    |
| `networkPolicy.allowExternal` | Don't require client label for connections   | `true`                                                     |
| `nodeSelector`             | Node labels for pod assignment                  | {}                                                         |
| `affinity`                 | Affinity settings for pod assignment            | {}                                                         |
| `tolerations`              | Toleration labels for pod assignment            | []                                                         |
| `terminationGracePeriodSeconds`     | Optional duration in seconds the pod needs to terminate gracefully | `nil`                          |
| `probes.liveness.initialDelay`      | Liveness probe initial delay           | `60`                                                       |
| `probes.liveness.timeoutSeconds`    | Liveness probe timeout seconds         | `5`                                                        |
| `probes.liveness.failureThreshold`  | Liveness probe failure threshold       | `6`                                                        |
| `probes.readiness.initialDelay`     | Readiness probe initial delay          | `5`                                                        |
| `probes.readiness.timeoutSeconds`   | Readiness probe timeout seconds        | `3`                                                        |
| `probes.readiness.failureThreshold` | Readiness probe failure threshold      | `5`                                                        |
| `podAnnotations`           | Annotations for the postgresql pod              | {}                                                         |
| `deploymentAnnotations`    | Annotations for the postgresql deployment       | {}                                                         |

The above parameters map to the env variables defined in [postgres](http://github.com/docker-library/postgres). For more information please refer to the [postgres](http://github.com/docker-library/postgres) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set postgresUser=my-user,postgresPassword=secretpassword,postgresDatabase=my-database \
    stable/postgresql
```

The above command creates a PostgreSQL user named `my-user` with password `secretpassword`. Additionally it creates a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/postgresql
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [postgres](https://github.com/docker-library/postgres) image stores the PostgreSQL data and configurations at the `/var/lib/postgresql/data/pgdata` path of the container.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning. If the PersistentVolumeClaim should not be managed by the chart, define `persistence.existingClaim`.

Note: When using persistence ensure that you either provide a `postgresPassword` or use `existingSecret`, otherwise `helm update` will generate a new random password which is ignored by postgres. That will cause confusing behaviour especially if services depend on the secret

### Existing PersistentVolumeClaims

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart
```bash
$ helm install --set persistence.existingClaim=PVC_NAME postgresql
```

The volume defaults to mount at a subdirectory of the volume instead of the volume root to avoid the volume's hidden directories from interfering with `initdb`.  If you are upgrading this chart from before version `0.4.0`, set `persistence.subPath` to `""`.

## Metrics
The chart optionally can start a metrics exporter for [prometheus](https://prometheus.io). The metrics endpoint (port 9187) is not exposed and it is expected that the metrics are collected from inside the k8s cluster using something similar as the described in the [example Prometheus scrape configuration](https://github.com/prometheus/prometheus/blob/master/documentation/examples/prometheus-kubernetes.yml).

The exporter allows to create custom metrics from additional SQL queries. See the Chart's `values.yaml` for an example and consult the [exporters documentation](https://github.com/wrouesnel/postgres_exporter#adding-new-metrics-via-a-config-file) for more details.

## NetworkPolicy

To enable network policy for PostgreSQL,
install [a networking plugin that implements the Kubernetes
NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin),
and set `networkPolicy.enabled` to `true`.

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting
the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

    kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"

With NetworkPolicy enabled, traffic will be limited to just port 5432.

For more precise policy, set `networkPolicy.allowExternal=false`. This will
only allow pods with the generated client label to connect to PostgreSQL.
This label will be displayed in the output of a successful install.
