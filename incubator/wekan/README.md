# Wekan Helm Chart

This directory contains a Kubernetes chart to deploy a Wekan server.

## Prerequisites Details

* Kubernetes 1.6+

## Chart Details

This chart will do the following:

* Implement a Wekan deployment

Please note that an existing MongoDB instance is required for this chart to
function. This can be accomplished using the `mongodb-replicaset` chart for
example.

## Installing the Chart

To install the chart, use the following:

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --values wekan-values.yaml incubator/wekan
```

Please be sure to specify the correct MongoDB for your deployment.

## Configuration

The following tables lists the configurable parameters of the vault chart and their default values.

|       Parameter         |           Description               |                         Default                     |
|-------------------------|-------------------------------------|-----------------------------------------------------|
| `image.pullPolicy`      | Container pull policy               | `IfNotPresent`                                      |
| `image.repository`      | Container image to use              | `wekanteam/wekan`                                   |
| `image.tag`             | Container image tag to deploy       | `v0.50`                                             |
| `wekan.mongoURL`        | MongoDB URL for Wekan               | ``                                                  |
| `wekan.rootURL`         | Root URL for Wekan                  | ``                                                  |
| `replicaCount`          | k8s replicas                        | `1`                                                 |
| `resources.limits.cpu`  | Container requested CPU             | `nil`                                               |
| `resources.limits.memory` | Container requested memory        | `nil`                                               |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.
