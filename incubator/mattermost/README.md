# Mattermost Helm Chart

This directory contains a Kubernetes chart to deploy a Mattermost application
server.

## Prerequisites Details

* Kubernetes 1.5
* PV support on the underlying infrastructure

## Chart Details

This chart will do the following:

* Implement a Mattermost deployment

Please note that an existing database service (either PostgreSQL or MySQL) must
be deployed beforehand and configured with the `mattermost.db.*` options.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/mattermost
```

## Configuration

The following tables lists the configurable parameters of the mattermost chart and their default values.

|       Parameter         |           Description               |                         Default                     |
|-------------------------|-------------------------------------|-----------------------------------------------------|
| `image.pullPolicy`      | Container pull policy               | `IfNotPresent`                                      |
| `image.repository`      | Container image to use              | `mattermost/mattermost-prod-app`                    |
| `image.tag`             | Container image tag to deploy       | `3.10.0`                                            |
| `mattermost.db.host`    | Database host to use for Mattermost | `db`                                                |
| `mattermost.db.port`    | Database port to use for Mattermost | `5432`                                              |
| `mattermost.db.name`    | Database name to use for Mattermost | `mattermost`                                        |
| `mattermost.db.username`| Database username to use for Mattermost | `mmuser`                                        |
| `mattermost.db.password`| Database password to use for Mattermost | `mmpassword`                                    |
| `replicaCount`          | k8s replicas                        | `1`                                                 |
| `resources.limits.cpu`  | Container requested CPU             | `nil`                                               |
| `resources.limits.memory` | Container requested memory        | `nil`                                               |
| `persistence.enabled`   | Enable app persistent storage       | `false`                                             |
| `persistence.size`      | Persistent storage size             | `5Gi`                                             |
| `persistence.storageClass` | Persistent storage class         | `default`                                             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/mattermost
```

> **Tip**: You can use the default [values.yaml](values.yaml)
