# Couchbase

[Couchbase](https://www.couchbase.com/) is a NoSQL database, which has become the de facto standard for building Systems of Engagement. It is designed with a distributed architecture for performance, scalability, and availability. It enables developers to build applications easier and faster by leveraging the power of SQL with the flexibility of JSON.

## Introduction

This chart bootstraps a [Couchbase](https://www.couchbase.com/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/couchbase
```

The command deploys Couchbase on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Couchbase chart and their default values.

|         Parameter            |             Description             |                         Default                          |
|------------------------------|-------------------------------------|----------------------------------------------------------|
| `workerReplicaCount`         | Number of replica worker            | `3`                                                      |
| `persistence.enabled`        | Use a PVC to persist data           | `true`                                                   |
| `persistence.storageClass`   | Storage class of backing PVC        | `fast`                                                   |
| `persistence.accessMode`     | Use volume as ReadOnly or ReadWrite | `ReadWriteOnce`                                          |
| `persistence.size`           | Size of data volume                 | `10Gi`                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set workerReplicaCount=5 \
    incubator/couchbase
```

When deployed you will have access to the web interface on the port 8091, adn you will be able to setup the security like add more users, buckets, rebalancing etc...

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/couchbase
```