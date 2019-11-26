# Redis

[Redis](http://redis.io/) is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

## TL;DR;

```bash
$ helm install stable/redis-cluster
```

## Introduction

This chart bootstraps a [Redis](https://redis.io) highly available distributed cluster in a [Kubernetes](http://kubernetes.io) cluster using the Helm package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart

```bash
$ helm install incubator/redis-cluster
```

The command deploys Redis Cluster on the Kubernetes cluster in the default configuration. By default this chart install 3 shards and one replica for each shard. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the deployment:

```bash
$ helm delete <chart-name>
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Note
By default this chart install 3 shards and one replica for each shard:
 * In this chart, one statefulset means one shard (include master and replicas), the statefulset would be dynamic created when shard number changes.
 * The shard number must be equal or greater than 3, or the cluter will create failed.
 * By now, the chart support scale-out (add shards), but the data in cluster won't resharding automatically. You must reshard the data manually.
 * If you want to scale-in the cluster, you must reshard the data and remove the node from cluster carefully first, then run `helm upgrade` command to decrease the shard number.

## Configuration

The following table lists the configurable parameters of the Redis chart and their default values.

| Parameter                        | Description                                                                             | Default                 |
|:---------------------------------|:----------------------------------------------------------------------------------------|:------------------------|
| `image.name`                     | Redis image                                                                             | `redis`                 |
| `image.tag`                      | Redis image tag                                                                         | `5.0.6`                 |
| `image.pullPolicy`               | Redis image pullPolicy                                                                  | `Always`                |
| `shards`                         | Shards of Redis Cluster, must be equal or greater than 3                                | `3`                     |
| `shardReplicas`                  | Replicas of each shard                                                                  | `1`                     |
| `labels`                         | Custom labels for the redis pod                                                         | `{}`                    |
| `redis.port`                     | Port to access the redis service                                                        | `6379`                  |
| `redis.customConfig`             | Allows for custom redis.conf files to be applied.                                       | ``                      |
| `redis.resources`                | CPU/Memory for redis server resource requests/limits                                    | `{}`                    |
| `auth`                           | Configures redis with AUTH (`redisPassword` to be set)                                  | ``                      |
| `nodeSelector`                   | Node labels for pod assignment                                                          | `{}`                    |
| `tolerations`                    | Toleration labels for pod assignment                                                    | `[]`                    |
| `hardAntiAffinity`               | Whether the Redis server pods in one shard should be forced to run on separate nodes.   | `false`                 |
| `persistentVolume.enabled`       | Whether create a volume to store data                                                   | `false`                 |
| `persistentVolume.storageClass`  | Type of persistent volume claim                                                         | `-`                     |
| `persistentVolume.accessModes`   | ReadWriteOnce or ReadOnly                                                               | `ReadWriteOnce`         |
| `persistentVolume.size`          | Size of persistent volume claim                                                         | `1Gi`                   |
| `persistentVolume.annotations`   | Annotations of persistent volume claim                                                  | `{}`                    |
| `sysctl.enabled`                 | Enable an init container to modify Kernel settings                                      | `false`                 |
| `sysctl.command`                 | sysctl command to execute                                                               | []                      |
| `sysctl.image`                   | sysctl Init container image name                                                        | `busybox`               |
| `sysctl.tag`                     | sysctlImage Init container image tag                                                    | `1.31.1`                |
| `sysctl.pullPolicy`              | sysctlImage Init container image pull policy                                            | `Always`                |
| `sysctl.mountHostSys`            | Whether Mount the host `/sys` folder to `/host-sys`                                     | `false`                 |                                                                                                                                                        | `false`                                                                                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install \
  --set image=redis \
  --set tag=5.0.6 \
    incubator/redis-cluster
```

The above command sets the Redis server within `default` namespace.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install -f values.yaml stable/redis-cluster
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Custom Redis options

This chart allows for most redis or sentinel config options to be passed as a key value pair through the `values.yaml` under `redis.customConfig`. See links below for all available options.

[Example redis.conf](http://download.redis.io/redis-stable/redis.conf)

For example `repl-timeout 60` would be added to the `redis.customConfig` section of the `values.yaml` as:

```yml
redis:
  customConfig: |
    repl-timeout 60
```

## Host Kernel Settings
Redis may require some changes in the kernel of the host machine to work as expected, in particular increasing the `somaxconn` value and disabling transparent huge pages.
To do so, you can set up a privileged initContainer with the `sysctl` config values, for example:
```
sysctl:
  enabled: true
  image: busybox
  tag: 1.31.1
  mountHostSys: true
  command:
    - /bin/sh
    - -xc
    - |-
      sysctl -w net.core.somaxconn=10000
      echo never > /host-sys/kernel/mm/transparent_hugepage/enabled
```

