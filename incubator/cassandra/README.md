# Multi-node Cassandra Cluster using StatefulSets

[Apache Cassandra](http://cassandra.apache.org) is a free and open-source distributed database system designed to handle large amounts of data across multiple servers, providing high availability with no one point of failure.

## Credit

Credit to https://github.com/kubernetes/kubernetes/tree/master/examples/storage/cassandra. This is an implementation of that work as a Helm Chart.

## Introduction

This chart bootstraps a multi-node Cassandra deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. This work is largely based upon the StatefulSet example for deploying Cassandra documented in this [tutorial](https://github.com/kubernetes/kubernetes/tree/master/examples/storage/cassandra).

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled (Kubernetes 1.5.3+ for Azure)
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/cassandra
```

The command deploys a Cassandra cluster on the Kubernetes cluster using the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

### Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

It should be noted, that the installation of the chart installs a persistent volume claim per Cassandra node deployed.  These volumes are not deleted by the `helm delete` command.  They can be managed using the `kubectl delete` command for Persistent Volume Claim resources.

## Configuration

The following tables lists the configurable parameters of the Cassandra chart and their default values.

| Parameter                  | Description                                | Default                             |
| -----------------------    | ------------------------------------------ | ----------------------------------- |
| `Image`                    | `cassandra` image.                         | gcr.io/google-samples/cassandra     |
| `ImageTag`                 | `cassandra` image tag.                     | v12                                 |
| `replicaCount`             | Number of `cassandra` instances to run     | 3                                   |
| `cassandra.MaxHeapSize`    | Max heap for JVM running `cassandra`.      | 512M                                |
| `cassandra.HeapNewSize`    | Min heap size for JVM running `cassandra.` | 100M                                |
| `cassandra.ClusterName`    | Name of the `cassandra` cluster.           | K8Demo                              |
| `cassandra.DC`             | Name of the DC for `cassandra` cluster.    | DC1-K8Demo                          |
| `cassandra.Rack`           | Name of the Rack for `cassandra` cluster.  | Rack1-K8Demo                        |
| `persistence.enabled`      | Create a volume to store data              | true                                |
| `persistence.size`         | Size of persistent volume claim            | 10Gi                                |
| `persistence.storageClass` | Type of persistent volume claim            | default                             |
| `persistence.accessMode`   | ReadWriteOnce or ReadOnly                  | ReadWriteOnce                       |
| `resources`                | CPU/Memory resource requests/limits        | Memory: `1Gi`, CPU: `500m`          |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

## Persistence

The deployment of the Cassandra cluster relies on persistent storage.  A PersistentVolumeClaim is created and mounted in the directory `/cassandra-data` on a per Cassandra instance.

By default, the chart will uses the default StorageClass for the provider where Kubernetes is running.  If `default` isn't supported, or if one wants to use a specifc StorageClass, for instance premium storage on Azure, one would need to define the appropriate StorageClass and update the values.yaml file or use the `--set key=persitence.storageClass=<value>` flag to specify such.  To specify a Premium Storage disk (ssd) on Azure, the yaml file for the StorageClass definition would resemble:

```
# https://kubernetes.io/docs/user-guide/persistent-volumes/#azure-disk
apiVersion: storage.k8s.io/v1beta1
kind: StorageClass
metadata:
  name: fast
  annotations:
    storageclass.beta.kubernetes.io/is-default-class: "true"
provisioner: kubernetes.io/azure-disk
parameters:
  skuName: Premium_LRS
  location: westus
```

In order to disable this functionality you can change the values.yaml to disable persistence and use an emptyDir instead.
