# MySQL - Single Master, Multiple Slaves

[MySQL](https://MySQL.org) is one of the most popular database servers in the world. Notable users include Wikipedia, Facebook and Google.

## Introduction

This chart bootstraps a single master and multiple slave MySQL deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. Largely inspired by this [tutorial](https://kubernetes.io/docs/tutorials/stateful-application/run-replicated-stateful-application/), further work was made to 'production-ize' the example.

## Prerequisites

- Kubernetes 1.6+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/mysqlha
```

The command deploys MySQL cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

### Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

## Configuration

The following table lists the configurable parameters of the MySQL chart and their default values.

| Parameter                                    | Description                                       | Default                                |
| -----------------------------------------    | ------------------------------------------------- | -------------------------------------- |
| `mysqlImage`                                 | `mysql` image and tag.                            | `mysql:5.7.13`                         |
| `xtraBackupImage`                            | `xtrabackup` image and tag.                       | `gcr.io/google-samples/xtrabackup:1.0` |
| `imagePullPolicy`                            | Image pull policy.                                | `IfNotPresent`                         |
| `nameOverride`                               | `String to partially override mysqlha.fullname template with a string (will prepend the release name)` | `nil` |
| `fullnameOverride`                           | `String to fully override mysqlha.fullname template with a string`                 | `nil` |
| `replicaCount`                               | Number of MySQL replicas                          | 3                                      |
| `mysqlRootPassword`                          | Password for the `root` user.                     | Randomly generated                     |
| `mysqlUser`                                  | Username of new user to create.                   | `nil`                                  |
| `mysqlPassword`                              | Password for the new user.                        | Randomly generated                     |
| `mysqlReplicationUser`                       | Username for replication user                     | `repl`                                 |
| `mysqlReplicationPassword`                   | Password for replication user.                    | Randomly generated                     |
| `mysqlDatabase`                              | Name of the new Database to create                | `nil`                                  |
| `configFiles.master.cnf`                     | Master configuration file                         | See `values.yaml`                      |
| `configFiles.slave.cnf`                      | Slave configuration file                          | See `values.yaml`                      |
| `podAnnotations`                             | Pod annotations                                   | `nil`                                  |
| `schedulerName`                              | Name of the k8s scheduler (other than default)    | `nil`                                  |
| `persistence.enabled`                        | Create a volume to store data                     | true                                   |
| `persistence.size`                           | Size of persistent volume claim                   | 10Gi                                   |
| `persistence.storageClass`                   | Type of persistent volume claim                   | `nil`                                  |
| `persistence.accessModes`                    | Persistent volume access modes                    | `[ReadWriteOnce]`                      |
| `persistence.annotations`                    | Persistent volume annotations                     | `{}`                                   |
| `resources`                                  | CPU/Memory resource requests/limits               | Memory: `128Mi`, CPU: `100m`           |
| `metrics.enabled`                            | Start a side-car prometheus exporter              | false                                  |
| `metrics.image`                              | Exporter image                                    | `prom/mysqld-exporter`                 |
| `metrics.imageTag`                           | Exporter image                                    | `v0.10.0`                              |
| `metrics.imagePullPolicy`                    | Exporter image pull policy                        | `IfNotPresent`                         |
| `metrics.resources`                          | Exporter resource requests/limit                  | See `values.yaml`                      |
| `metrics.livenessProbe.initialDelaySeconds`  | Delay before metrics liveness probe is initiated  | 15                                     |
| `metrics.livenessProbe.timeoutSeconds`       | When the probe times out                          | 5                                      |
| `metrics.readinessProbe.initialDelaySeconds` | Delay before metrics readiness probe is initiated | 5                                      |
| `metrics.readinessProbe.timeoutSeconds`      | When the probe times out                          | 1                                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

## Persistence

The [MySQL](https://hub.docker.com/_/mysql/) image stores the MySQL data and configurations at the `/var/lib/mysql` path of the container.

By default persistence is enabled, and a PersistentVolumeClaim is created and mounted in that directory. As a result, a persistent volume will need to be defined:

```
# https://kubernetes.io/docs/user-guide/persistent-volumes/#azure-disk
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: fast
provisioner: kubernetes.io/azure-disk
parameters:
  skuName: Premium_LRS
  location: westus
```

In order to disable this functionality you can change the values.yaml to disable persistence and use an emptyDir instead.
