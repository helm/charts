# Redis

[Redis](http://redis.io/) is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

## TL;DR;

```bash
$ helm install stable/redis-ha
```

By default this chart install one master pod containing redis master container and sentinel container, 2 sentinels and 1 redis slave.

## Introduction

This chart bootstraps a [Redis](https://redis.io) highly available master/slave statefulset in a [Kubernetes](http://kubernetes.io) cluster using the Helm package manager. 

## Prerequisites

- Kubernetes 1.5+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart

```bash
$ helm install stable/redis-ha
```

The command deploys Redis on the Kubernetes cluster in the default configuration. By default this chart install one master pod containing redis master container and sentinel container along with 2 redis slave pods each containing their own sentinel sidecars. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the deployment:

```bash
$ helm delete <chart-name>
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


## Configuration

The following table lists the configurable parameters of the Redis chart and their default values.

| Parameter                        | Description                                                                                                                  | Default                                                   |
| -------------------------------- | -----------------------------------------------------                                                                        | --------------------------------------------------------- |
| `image`                          | Redis image                                                                                                                  | `redis`                                                   |
| `tag`                            | Redis tag                                                                                                                    | `4.0.11-stretch`                                          |
| `redis.resources`                | CPU/Memory for master/slave nodes resource requests/limits                                                                   | Memory: `200Mi`, CPU: `100m`                              |
| `sentinel.resources`             | CPU/Memory for sentinel node resource requests/limits                                                                        | Memory: `200Mi`, CPU: `100m`                              |
| `replicas`                       | Number of redis master/slave pods                                                                                            | 3                                                         |
| `nodeSelector`                   | Node labels for pod assignment                                                                                               | {}                                                        |
| `tolerations`                    | Toleration labels for pod assignment                                                                                         | []                                                        |
| `podAntiAffinity.server`         | Antiaffinity for pod assignment of servers, `hard` or `soft`                                                                 | `soft`                                                    |
| `annotations`                    | See Appliance mode                                                                                                           | ``                                                        |
| `redis.config`                   | Valid redis config options can be added prior to install and will be applied to each server                                  | see values.yaml                                           |
| `sentinel.config`                | Valid sentinel config options can be added prior to install and will be applied to each server                               | see values.yaml                                           |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install \
  --set image=quay.io/smile/redis \
  --set tag=4.0.6r2 \
    stable/redis-ha
```

The above command sets the Redis server within  `default` namespace.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install -f values.yaml stable/redis-ha
```

> **Tip**: You can use the default [values.yaml](values.yaml)

