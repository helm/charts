# CoreOS etcd-operator

[etcd-operator](https://coreos.com/blog/introducing-the-etcd-operator.html) Simplify etcd cluster
configuration and management.

__DISCLAIMER:__ While this chart has been well-tested, the etcd-operator is still currently in beta.
Current project status is available [here](https://github.com/coreos/etcd-operator).

## Introduction

This chart bootstraps an etcd-operator and allows the deployment of etcd-cluster(s).

## Official Documentation

Official project documentation found [here](https://github.com/coreos/etcd-operator)

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- __Suggested:__ PV provisioner support in the underlying infrastructure to support backups

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install stable/etcd-operator --name my-release
```

__Note__: If you set `cluster.enabled` on install, it will have no effect.
Before you create an etcd cluster, the TPR must be installed by the operator, so this option is ignored during helm installs, but can be used in upgrades.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components EXCEPT the persistent volume.

## Updating
Updating the TPR resource will not result in the cluster being update until `kubectl apply` for
TPRs is fixed see [kubernetes/issues/29542](https://github.com/kubernetes/kubernetes/issues/29542)
Work around options are documented [here](https://github.com/coreos/etcd-operator#resize-an-etcd-cluster)

## Configuration

The following tables lists the configurable parameters of the etcd-operator chart and their default values.

| Parameter                                         | Description                                                          | Default                                        |
| ------------------------------------------------- | -------------------------------------------------------------------- | ---------------------------------------------- |
| `replicaCount`                                    | Number of etcd-operator replicas to create (only 1 is supported)     | `1`                                            |
| `image.repository`                                | etcd-operator container image                                        | `quay.io/coreos/etcd-operator`                 |
| `image.tag`                                       | etcd-operator container image tag                                    | `v0.6.1`                                       |
| `image.pullPolicy`                                | etcd-operator container image pull policy                            | `IfNotPresent`                                 |
| `resources.limits.cpu`                            | CPU limit per etcd-operator pod                                      | `100m`                                         |
| `resources.limits.memory`                         | Memory limit per etcd-operator pod                                   | `128Mi`                                        |
| `resources.requests.cpu`                          | CPU request per etcd-operator pod                                    | `100m`                                         |
| `resources.requests.memory`                       | Memory request per etcd-operator pod                                 | `128Mi`                                        |
| `nodeSelector`                                    | node labels for etcd-operator pod assignment                         | `{}`                                           |
| `cluster.enabled`                                 | Whether to enable provisioning of an etcd-cluster                    | `false`                                        |
| `cluster.name`                                    | etcd cluster name                                                    | `etcd-cluster`                                 |
| `cluster.version`                                 | etcd cluster version                                                 | `v3.1.8`                                       |
| `cluster.size`                                    | etcd cluster size                                                    | `3`                                            |
| `cluster.backup.enabled`                          | Whether to create PV for cluster backups                             | `false`                                        |
| `cluster.backup.provisioner`                      | Which PV provisioner to use                                          | `kubernetes.io/gce-pd` (kubernetes.io/aws-ebs) |
| `cluster.backup.config.snapshotIntervalInSecond`  | etcd snapshot interval in seconds                                    | `30`                                           |
| `cluster.backup.config.maxSnapshot`               | maximum number of snapshots to keep                                  | `5`                                            |
| `cluster.backup.config.storageType`               | Type of storage to provision                                         | `PersistentVolume`                             |
| `cluster.backup.config.pv.volumeSizeInMB`         | size of backup PV                                                    | `512MB`                                        |
| `cluster.restore.enabled`                         | Whether to restore from PV                                           | `false`                                        |
| `cluster.restore.config.storageType`              | Type of storage to restore from                                      | `PersistentVolume`                             |
| `cluster.restore.config.backupClusterName`        | Name of cluster to restore from                                      | `etcd-cluster`                                 |
| `cluster.pod.antiAffinity`                        | Whether etcd cluster pods should have an antiAffinity                | `false`                                        |
| `cluster.pod.resources.limits.cpu`                | CPU limit per etcd cluster pod                                       | `100m`                                         |
| `cluster.pod.resources.limits.memory`             | Memory limit per etcd cluster pod                                    | `128Mi`                                        |
| `cluster.pod.resources.requests.cpu`              | CPU request per etcd cluster pod                                     | `100m`                                         |
| `cluster.pod.resources.requests.memory`           | Memory request per etcd cluster pod                                  | `128Mi`                                        |
| `cluster.pod.nodeSelector`                        | node labels for etcd cluster pod assignment                          | `{}`                                           |
| `rbac.install`                                    | install required rbac service account, roles and rolebindings        | `false`                                         |
| `rbac.apiVersion`                                 | rbac api version `v1alpha1|v1beta1`                                  | `v1beta1`                                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install --name my-release --set image.tag=v0.2.1 stable/etcd-operator
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm install --name my-release --values values.yaml stable/etcd-operator
```

## RBAC
By default the chart will not install the recommended RBAC roles and rolebindings.

To determine if your cluster supports this running the following:

```console
$ kubectl api-versions | grep rbac
```

You also need to have the following parameter on the api server. See the following document for how to enable [RBAC](https://kubernetes.io/docs/admin/authorization/rbac/)

```
--authorization-mode=RBAC
```

If the output contains "beta" or both "alpha" and "beta" you can may install with enabling the creating of rbac resources (see below).

### Enable RBAC role/rolebinding creation

To enable the creation of RBAC resources (On clusters with RBAC). Do the following:

```console
$ helm install --name my-release stable/etcd-operator --set rbac.install=true
```

### Changing RBAC manifest apiVersion

By default the RBAC resources are generated with the "v1beta1" apiVersion. To use "v1alpha1" do the following:

```console
$ helm install --name my-release stable/etcd-operator --set rbac.install=true,rbac.apiVersion=v1alpha1
```
