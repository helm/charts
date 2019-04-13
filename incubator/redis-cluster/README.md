# Redis Cluster

[Redis](http://redis.io/) is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

[Redis Cluster](https://redislabs.com/redis-features/redis-cluster) is a set of redis instances working together to make your data storage scale across nodes while also making it a bit more resilient. Data is automatically split across nodes and it supports a master/slave setup for increased availability in case of a failure. It is basically a data sharding strategy, with the ability to reshard keys from one node to another while the cluster is running, together with a failover procedure that makes sure the system is able to survive certain kinds of failures.

## TL;DR;

```bash
$ helm install incubator/redis-cluster
```

By default this chart install 6 statefulset pods total:
 * three master pods (keys are sharded across these three pods)
 * three slave pods (one slave per master pod, available for failover)

## Introduction

This chart bootstraps a [Redis Cluster](https://redislabs.com/redis-features/redis-cluster) in a [Kubernetes](http://kubernetes.io) cluster using the Helm package manager.

## Prerequisites

- kubernetes 1.8+
- helm
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart

```bash
$ helm install incubator/redis-cluster
```

The command deploys Redis Cluster on the Kubernetes cluster in the default configuration. By default this chart installs three master pods and three slave pods.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the deployment:

```bash
$ helm delete <chart-name>
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Redis chart and their default values.

| Parameter                | Description                                                                                                                                                                                              | Default                                                                                    |
|:-------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------|
| `image.registry`         | Registry hosting the docker image                                                                                                                                                                        | `docker.io`                                                                                |
| `image.repository`       | Reids docker image name                                                                                                                                                                                  | `redis`                                                                                    |
| `image.tag`              | Redis image ta                                                                                                                                                                                           | `5.0.0`                                                                                    |
| `replicas`               | Number of redis master/slave pods                                                                                                                                                                        | `6`                                                                                        |
| `service.clientPort`     | Port to access the redis service                                                                                                                                                                         | `6379`                                                                                     |
| `service.gossipPort`     | Port used by redis pods for communicating via gossip-protocol                                                                                                                                            | `16379`                                                                                    |
| `annotations`            | Additional annotations for redis pods                                                                                                                                                                    | `{}`                                                                                       |
| `labels`                 | Additional labels for redis pods                                                                                                                                                                         | `{}`                                                                                       |
| `persistence.size`       | Size of the redis database                                                                                                                                                                               | `1Gi`                                                                                      |
| `redisConfig`            | Custom values for redis.conf                                                                                                                                                                             | `see values.yaml`                                                                          |
| `statefulset.affinity`   | Define affinity rules for the redis pods                                                                                                                                                                 | `see values.yaml`                                                                          |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install \
  --set image=redis \
  --set tag=5.0.3-alpine \
    incubator/redis-cluster
```

## Custom RedisCluster Configurations

This chart allows you to configure redis-configurations for the redis-cluster under `redisConfig`.
See the link below to check what parameters redis allows you to configure

[redis.conf](http://download.redis.io/redis-stable/redis.conf)
