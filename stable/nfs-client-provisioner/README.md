# nfs-client-provisioner

The [NFS client provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client) is an automatic provisioner for Kubernetes that uses your *already configured* NFS server, automatically creating Persistent Volumes.

## TL;DR;

```console
$ helm install stable/nfs-client-provisioner
```

## Introduction

This charts installs custom [storage class](https://kubernetes.io/docs/concepts/storage/storage-classes/) into a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. It also installs a [NFS client provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client) into the cluster which dynamically creates persistent volumes from single NFS share.

## Prerequisites

- Kubernetes 1.9+
- Existing NFS Share

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release --set nfs.server=x.x.x.x --set nfs.path=/exported/path stable/nfs-client-provisioner
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
| `replicaCount`                    | number of provisioner instances to deployed | `1`                                                         |
| `strategyType`                    | specifies the strategy used to replace old Pods by new ones | `Recreate`                                  |
| `image.repository`                | provisioner image                           | `quay.io/external_storage/nfs-client-provisioner`         |
| `image.tag`                       | version of provisioner image                | `v3.0.1-k8s1.11`                                          |
| `image.pullPolicy`                | image pull policy                           | `IfNotPresent`                                            |
| `storageclass.name`               | name of the storageclass                    | `nfs-client`                                              |
| `storageclass.defaultClass`       | Set as the default StorageClass             | `false`	                                              |
| `storageclass.allowVolumeExpansion`       | Allow expanding the volume          | `true`	                                              |
| `storageclass.reclaimPolicy`    | Method used to reclaim an obsoleted volume                 | `Delete` 	                                      |
| `storageclass.provisionerName`    | name of the provisionerName                 | null 	                                              |
| `storageclass.archiveOnDelete`    | archive pvc when deleting                   | `true` 	                                              |
| `nfs.server`                      | hostname of the NFS server                  | null (ip or hostname)                                     |
| `nfs.path`                        | basepath of the mount point to be used      | `/ifs/kubernetes`                                         |
| `resources`                       | Resources required (e.g. CPU, memory)       | `{}`                                                      |
