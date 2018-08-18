# nfs-client-provisioner

The [NFS client provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client) is an out-of-tree/external storage provisioner for kubernetes. It provides dynamic provisioning of Persistent Volumes from a single NFS mount point.

## TL;DR;

```console
$ helm install incubator/nfs-client-provisioner
```

## Introduction

This charts installs custom [storage class](https://kubernetes.io/docs/concepts/storage/storage-classes/) into a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. It also installs a [NFS client provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client) into the cluster which dynamically creates persistent volumes from single NFS share.

## Prerequisites

- Kubernetes 1.7+
- NFS Share

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release --set storageclass.name=nfs incubator/nfs-client-provisioner
```

The command deploys the given storage class in the default configuration. It can be used afterswards to provision persistent volumes. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of this chart and their default values.

| Parameter                         | Description                                 | Default                                                   |
| --------------------------------- | -------------------------------------       | --------------------------------------------------------- |
| `replicaCount`                    | number of provisioner instances to deployed | 1                                                         |
| `image.repository`                | provisioner image                           | `quay.io/external_storage/nfs-client-provisioner`         |
| `image.tag`                       | version of provisioner image                | `v2.0.1`                                                  |
| `image.pullPolicy`                | image pull policy                           | `IfNotPresent`                                            |
| `storageclass.nane`               | name of the storageclass                    | `nfs`                                                     |
| `nfs.provisionerName`             | name of the provisionerName                 | `fuseim.pri/ifs`                                          |
| `nfs.server`                      | hostname of the NFS server                  | `10.10.10.60`                                             |
| `nfs.path`                        | basepath of the mount point to be used      | `/ifs/kubernetes`                                         |
| `resources`                       | Resources required (e.g. CPU, memory)       | `{}`                                                      |
