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

| Parameter                  | Description                         | Default                                                   |
| -------------------------- | ----------------------------------- | --------------------------------------------------------- |
| `redis_image`              | Redis image                         | `gcr.io/google_containers/redis:v1`                       |
| `persistence.enabled`      | Use a PVC to persist data           | `true`                                                    |
| `persistence.storageClass` | Storage class of backing PVC        | `generic`                                                 |
| `persistence.accessMode`   | Use volume as ReadOnly or ReadWrite | `ReadWriteOnce`                                           |
| `persistence.size`         | Size of data volume                 | `8Gi`                                                     |
| `resources`                | CPU/Memory resource requests/limits | Memory: `200Mi`, CPU: `100m`                              |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install \
  --set redis_image=gcr.io/google_containers/redis:v1 \
    stable/redis-ha
```

The above command sets the Redis server within  `default` namespace.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install -f values.yaml stable/redis-ha
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The chart mounts a [Persistent Volume](kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning.
