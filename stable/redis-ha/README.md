# Redis

[Redis](http://redis.io/) is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

## TL;DR;

```bash
$ helm install stable/redis-ha
```

By default this chart install one master pod containing redis master container and sentinel container, 2 sentinels and 1 redis slave.

## Introduction

This chart bootstraps a [Redis](https://github.com/bitnami/bitnami-docker-redis) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.5+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart

```bash
$ helm install stable/redis-ha
```

The command deploys Redis on the Kubernetes cluster in the default configuration. By default this chart install one master pod containing redis master container and sentinel container, 2 sentinels and 1 redis slave. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the deployment:

```bash
$ helm delete <chart-name>
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Redis chart and their default values.

| Parameter                        | Description                                           | Default                                                   |
| -------------------------------- | ----------------------------------------------------- | --------------------------------------------------------- |
| `redis_image`                    | Redis image                                           | `quay.io/smile/redis:4.0.2`                               |
| `persistentVolume.enabled`       | Use a PVC to persist data                             | `false`                                                   |
| `persistentVolume.storageClass`  | Storage class of backing PVC                          | `generic`                                                 |
| `persistentVolume.accessMode`    | Use volume as ReadOnly or ReadWrite                   | `ReadWriteOnce`                                           |
| `persistentVolume.size`          | Size of data volume                                   | `8Gi`                                                     |
| `persistentVolume.annotations`   | Redis data Persistent Volume Claim annotations        | `{}`                                                      |
| `persistentVolume.existingClaim` | Redis data Persistent Volume existing claim name      | ``                                                        |
| `persistentVolume.mountPath`     | Redis data Persistent Volume mount root path          | `/data`                                                   |
| `persistentVolume.subPath`       | Subdirectory of redis data Persistent Volume to mount | ``                                                        |
| `resources.master`               | CPU/Memory for master nodes resource requests/limits  | Memory: `200Mi`, CPU: `100m`                              |
| `resources.slave`                | CPU/Memory for slave nodes  resource requests/limits  | Memory: `200Mi`, CPU: `100m`                              |
| `resources.sentinel`             | CPU/Memory for sentinel node resource requests/limits | Memory: `200Mi`, CPU: `100m`                              |
| `replicas.master`                | Number of master pods                                 | 1                                                         |
| `replicas.slave`                 | Number of slave pods                                  | 1                                                         |
| `replicas.sentinel`              | Number of sentinel pods                               | 3                                                         |
| `nodeSelector`                   | Node labels for pod assignment                        | {}                                                        |
| `tolerations`                    | Toleration labels for pod assignment                  | []                                                        |



Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install \
  --set redis_image=quay.io/smile/redis:4.0.2 \
    stable/redis-ha
```

The above command sets the Redis server within  `default` namespace.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install -f values.yaml stable/redis-ha
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The chart mounts a [Persistent Volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning.
