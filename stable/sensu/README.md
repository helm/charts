# Sensu

[Sensu](https://sensuapp.org/) is monitoring that doesn't suck.


## TL;DR;

```console
$ helm install stable/sensu
```

## Introduction

This chart bootstraps a [Sensu](https://github.com/sstarcher/docker-sensu) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```console
$ git clone https://github.com/kubernetes/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/sensu
```

The command deploys Sensu on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Sensu chart and their default values.

| Parameter                            | Description                              | Default                                                    |
| -------------------------------      | -------------------------------          | ---------------------------------------------------------- |
| `image`                              | Sensu image                          | `sstarcher/sensu`                              |
| `imageTag`                              | Sensu version                          | `0.26`                              |
| `imagePullPolicy`                    | Image pull policy                        | `IfNotPresent`   |
| `replicaCount`         | Number of sensu replicas | `1`  |
| `httpPort` | Service port for kubernetes | `80` |
| `deis.routable` | Enables routing through the Deis router | `false` |
| `deis.domain` | The service name for deis to route | `sensu` |
| `server.resources.requests.cpu` | CPU request for sensu server | `100m` |
| `server.resources.requests.memory` | Memory request for sensu server | `100Mi` |
| `server.resources.limits.cpu` | CPU limit for sensu server | `` |
| `server.resources.limits.memory` | Memory limit for sensu server | `` |
| `api.resources.requests.cpu` | CPU request for api server | `50m` |
| `api.resources.requests.memory` | Memory request for api server | `100Mi` |
| `api.resources.limits.cpu` | CPU limit for api server | `` |
| `api.resources.limits.memory` | Memory limit for api server | `` |
| `REDIS_PORT` | Default port for redis | `6379` |
| `REDIS_DB` | The Redis instance DB to use/select | `0` |
| `REDIS_AUTO_RECONNECT` | Reconnect to Redis in the event of a connection failure | `true` |
| `REDIS_RECONNECT_ON_ERROR` | Reconnect to Redis in the event of a Redis error, e.g. READONLY | `true` |

Configuration reference for sensu [Sensu/Docs](https://sensuapp.org/docs/latest/reference/)

```console
$ helm install --name my-release \
  --set imageTag=0.26.5 \
    stable/sensu
```

The above command sets the Sensu version to `0.26.5`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/sensu
```

> **Tip**: You can use the default [values.yaml](values.yaml)
