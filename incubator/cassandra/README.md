# Multi-node Cassandra Cluster using StatefulSets

[Apache Cassandra](http://cassandra.apache.org) is a free and open-source distributed database system designed to handle large amounts of data across multiple servers, providing high availability with no one point of failure.

## Credit

Credit to https://github.com/kubernetes/kubernetes/tree/master/examples/storage/cassandra. This is an implementation of that work as a Helm Chart.

## Introduction

This chart bootstraps a multi-node Cassandra deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. This work is largely based upon the StatefulSet example for deploying Cassandra documented in this [tutorial](https://github.com/kubernetes/kubernetes/tree/master/examples/storage/cassandra).

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
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

The following tables lists the configurable parameters of the MySQL chart and their default values.

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
| `persistence.size`         | Size of persistent volume claim            | 10Gi                                |
| `persistence.storageClass` | Type of persistent volume claim            | fast                                |
| `persistence.accessMode`   | ReadWriteOnce or ReadOnly                  | ReadWriteOnce                       |
| `resources`                | CPU/Memory resource requests/limits        | Memory: `1Gi`, CPU: `500m`          |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

## Persistence

The deployment of the Cassandra cluster relies on persistent storage.  A PersistentVolumeClaim is created and mounted in the directory `/cassandra-data` on a per Cassandra instance.

In order to do such, a PersistentVolumeClaim needs to be defined.  An example for defining an SSD based volume claim, the yaml file resembles:
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
