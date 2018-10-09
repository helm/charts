# Terracotta

The [Terracotta 5.x OSS](http://www.terracotta.org/) offering includes the following:

 *  Ehcache 3.x compatibility
 *  Distributed In-Memory Data Management with fault-tolerance via Terracotta Server (1 stripe – active with optional mirror)
 *  In memory off-heap storage - take advantage of all the RAM in your server


## Quick Start

```bash
$ helm install stable/terracotta
```

## Introduction

This chart bootstraps a [Terracotta server](https://github.com/Terracotta-OSS/docker) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.10+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/terracotta
```

The command deploys Terracotta on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Terracotta chart and their default values.

| Parameter                                  | Description                                                                                                    | Default                                              |
|--------------------------------------------|----------------------------------------------------------------------------------------------------------------|------------------------------------------------------|
| `image.repository`                         | Terracotta Image name                                                                                          | `terracotta/terracotta-server-oss`                   |
| `image.tag`                                | Terracotta Image tag                                                                                           | `{VERSION}`                                          |
| `image.pullPolicy`                         | Image pull policy                                                                                              | `Always`                                             |
| `replicaCount`                             | Number of Terracotta members                                                                                   | 2                                                    |
| `offheaps`                                 | Offheap resource defintions, as a list of {name, size, unit}                                                   | `[{offheap-1, 512, MB}, {offheap-2, 256, MB}]`       |
| `nodeSelector`                             | Terracotta Node labels for pod assignment                                                                      | `nil`                                                |
| `resources`                                | CPU/Memory resource requests/limits                                                                            | `nil`                                                |
| `service.type`                             | Kubernetes service type ('ClusterIP', 'LoadBalancer', or 'NodePort')                                           | `ClusterIP`                                          |
| `service.clusterIP`                        | Kubernetes service ClusterIP                                                                                   | `None`                                               |
| `service.terracottaPort`                   | Kubernetes main service port                                                                                   | `9410`                                               |
| `service.syncPort`                         | Kubernetes sync service port                                                                                   | `9430`                                               |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

helm install --dry-run --name my-release  --set replicaCount=4   --debug stable/terracotta

```bash
$ helm install --name my-release \
  --set replicaCount=3  --set offheaps[0].name=otherOffheap --set offheaps[0].unit=GB --set offheaps[0].size=6 \
    stable/terracotta
```

The above command sets number of Terracotta nodes to 3, and it defines just 1 offheap resource named otherOffheap, 6 GB large

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/terracotta
```

> **Tip**: You can use the default [values.yaml](values.yaml)
