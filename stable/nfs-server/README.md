# NFS Server

## TL;DR;

```console
$ helm install stable/nfs-server
```

## Introduction

This chart bootstraps a NFS server deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

The NFS-server mounts a ReadWriteOnce Persistence Volume Claim in a single node, and creates an NFS service that is connected to a new Persistence Volume of type NFS. This new Volume is of type ReadWriteMany.

This chart hence allows to share within a cluster a filesystem across nodes, where a native ReadWriteMany PV is not available.

```
  |-----|  ClusterIP    |---------|
  | PV  |  --------->   | NFS Svc |
  |-----|               |---------|
 ReadWriteMany               |
                             |
  |-----|   Mounted     |-----------------|
  | PVC |  ---------->  |  NFS deployment |
  |-----|               |-----------------|
 ReadWriteOnce                          

```     



## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/nfs-server
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the WordPress chart and their default values.

| Parameter                            | Description                                | Default                                                    |
| ------------------------------------ | ------------------------------------------ | ---------------------------------------------------------- |
| `image.registry`                     |  Image registry                   | `k8s.gcr.io`                                                |
| `image.repository`                   |  Image name                       | `volume-nfs`                                        |
| `image.tag`                          |  Image tag                        | `0.8`                                                |
| `image.pullPolicy`                   | Image pull policy                          | `Always` if `imageTag` is `latest`, else `IfNotPresent`    |
| `image.pullSecrets`                  | Specify image pull secrets                 | `nil`                                                      |
| `nfs.existingPVC`                    | existing PVC to use for sharing            | not defined                                                |
| `nfs.storageClass`                   | storage class to use if creating a new PVC | not defined                                                |
| `nfs.nfsStorageClass`                | storage class label for the new nfs PV     | not defined, uses release name                       |
| `nfs.clusterIp`                      | Static clusterIP for NFS service           | `10.96.0.200`                                                |
| `nfs.size`                           | WordPress image tag                        | `10Gi`                                                |


Highly recommend that you define a nfs.clusterIP that fits with your network configuration. You can do this by:

```console
$ helm install --name my-release --set nfs.clusterIP=10.96.0.5 stable/nfs-server
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/nfs-server
```

> **Tip**: You can use the default [values.yaml](values.yaml)

