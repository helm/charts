# Gitea Helm Chart

This directory contains a Kubernetes chart to deploy Gitea, a painless
self-hosted Git server.

## Prerequisites Details

* PV support on underlying infrastructure (if persistence is required)

## Chart Details

This chart will do the following:

* Implement a Gitea deployment

## Installing the Chart

To install the chart, use the following:

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/gitea
```

Please note that the default database used is SQLite3. If another database is
desired, that must be deployed beforehand and the `gitea.database.*`
variables must be configured.

## Configuration

The following tables lists the configurable parameters of the vault chart and
their default values.

|       Parameter         |           Description               |                         Default                     |
|-------------------------|-------------------------------------|-----------------------------------------------------|
| `image.pullPolicy`      | Container pull policy               | `IfNotPresent`                                      |
| `image.repository`      | Container image to use              | `gitea/gitea`                                       |
| `image.tag`             | Container image tag to deploy       | `1.2`                                               |
| `gitea.*`               | Gitea configuration                 | Please see `values.yaml`                            |
| `replicaCount`          | k8s replicas                        | `1`                                                 |
| `resources.limits.cpu`  | Container requested CPU             | `nil`                                               |
| `resources.limits.memory` | Container requested memory        | `nil`                                               |

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`.
