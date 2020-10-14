# nfs-client-provisioner

The [NFS client provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client) is an automatic provisioner for Kubernetes that uses your *already configured* NFS server, automatically creating Persistent Volumes.

## TL;DR;

```console
$ helm install --set nfs.server=x.x.x.x --set nfs.path=/exported/path stable/nfs-client-provisioner
```

For **arm** deployments set `image.repository` to `--set image.repository=quay.io/external_storage/nfs-client-provisioner-arm`

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

| Parameter                           | Description                                                 | Default                                           |
| ----------------------------------- | ----------------------------------------------------------- | ------------------------------------------------- |
| `replicaCount`                      | Number of provisioner instances to deployed                 | `1`                                               |
| `strategyType`                      | Specifies the strategy used to replace old Pods by new ones | `Recreate`                                        |
| `image.repository`                  | Provisioner image                                           | `quay.io/external_storage/nfs-client-provisioner` |
| `image.tag`                         | Version of provisioner image                                | `v3.1.0-k8s1.11`                                  |
| `image.pullPolicy`                  | Image pull policy                                           | `IfNotPresent`                                    |
| `storageClass.name`                 | Name of the storageClass                                    | `nfs-client`                                      |
| `storageClass.defaultClass`         | Set as the default StorageClass                             | `false`                                           |
| `storageClass.allowVolumeExpansion` | Allow expanding the volume                                  | `true`                                            |
| `storageClass.reclaimPolicy`        | Method used to reclaim an obsoleted volume                  | `Delete`                                          |
| `storageClass.provisionerName`      | Name of the provisionerName                                 | null                                              |
| `storageClass.archiveOnDelete`      | Archive pvc when deleting                                   | `true`                                            |
| `storageClass.accessModes`          | Set access mode for PV                                      | `ReadWriteOnce`                                   |
| `nfs.server`                        | Hostname of the NFS server                                  | null (ip or hostname)                             |
| `nfs.path`                          | Basepath of the mount point to be used                      | `/ifs/kubernetes`                                 |
| `nfs.mountOptions`                  | Mount options (e.g. 'nfsvers=3')                            | null                                              |
| `resources`                         | Resources required (e.g. CPU, memory)                       | `{}`                                              |
| `rbac.create`                       | Use Role-based Access Control                               | `true`                                            |
| `podSecurityPolicy.enabled`         | Create & use Pod Security Policy resources                  | `false`                                           |
| `priorityClassName`                 | Set pod priorityClassName                                   | null                                              |
| `serviceAccount.create`             | Should we create a ServiceAccount                           | `true`                                            |
| `serviceAccount.name`               | Name of the ServiceAccount to use                           | null                                              |
| `nodeSelector`                      | Node labels for pod assignment                              | `{}`                                              |
| `affinity`                          | Affinity settings                                           | `{}`                                              |
| `tolerations`                       | List of node taints to tolerate                             | `[]`                                              |

