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
Before you create an etcd cluster, the CRD must be installed by the operator, so this option is ignored during helm installs, but can be used in upgrades.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components EXCEPT the persistent volume.

## Configuration

The following table lists the configurable parameters of the etcd-operator chart and their default values.

| Parameter                                         | Description                                                          | Default                                        |
| ------------------------------------------------- | -------------------------------------------------------------------- | ---------------------------------------------- |
| `rbac.create`                                     | install required RBAC service account, roles and rolebindings        | `true`                                         |
| `rbac.apiVersion`                                 | RBAC api version `v1alpha1|v1beta1`                                  | `v1beta1`                                      |
| `rbac.etcdOperatorServiceAccountName`             | Name of the service account resource when RBAC is enabled            | `etcd-operator-sa`                                      |
| `rbac.backupOperatorServiceAccountName`           | Name of the service account resource when RBAC is enabled            | `etcd-backup-operator-sa`                                      |
| `rbac.restoreOperatorServiceAccountName`          | Name of the service account resource when RBAC is enabled            | `etcd-restore-operator-sa`                                      |
| `deployments.etcdOperator`                        | Deploy the etcd cluster operator                                     | `true`                                         |
| `deployments.backupOperator`                      | Deploy the etcd backup operator                                      | `true`                                         |
| `deployments.restoreOperator`                     | Deploy the etcd restore operator                                     | `true`                                         |
| `customResources.createEtcdClusterCRD`            | Create a custom resource: EtcdCluster                                | `false`                                        |
| `customResources.createBackupCRD`                 | Create an a custom resource: EtcdBackup                              | `false`                                        |
| `customResources.createRestoreCRD`                | Create an a custom resource: EtcdRestore                             | `false`                                        |
| `etcdOperator.name`                               | Etcd Operator name                                                   | `etcd-operator`                                |
| `etcdOperator.replicaCount`                       | Number of operator replicas to create (only 1 is supported)          | `1`                                            |
| `etcdOperator.image.repository`                   | etcd-operator container image                                        | `quay.io/coreos/etcd-operator`                 |
| `etcdOperator.image.tag`                          | etcd-operator container image tag                                    | `v0.7.0`                                       |
| `etcdOperator.image.pullpolicy`                   | etcd-operator container image pull policy                            | `Always`                                       |
| `etcdOperator.resources.cpu`                      | CPU limit per etcd-operator pod                                      | `100m`                                         |
| `etcdOperator.resources.memory`                   | Memory limit per etcd-operator pod                                   | `128Mi`                                        |
| `etcdOperator.nodeSelector`                       | Node labels for etcd operator pod assignment                         | `{}`                                           |
| `etcdOperator.commandArgs`                        | Additional command arguments                                         | `{}`                                           |
| `backupOperator.name`                             | Backup operator name                                                 | `etcd-backup-operator`                         |
| `backupOperator.replicaCount`                     | Number of operator replicas to create (only 1 is supported)          | `1`                                            |
| `backupOperator.image.repository`                 | Operator container image                                             | `quay.io/coreos/etcd-operator`                 |
| `backupOperator.image.tag`                        | Operator container image tag                                         | `v0.7.0`                                       |
| `backupOperator.image.pullpolicy`                 | Operator container image pull policy                                 | `Always`                                       |
| `backupOperator.resources.cpu`                    | CPU limit per etcd-operator pod                                      | `100m`                                         |
| `backupOperator.resources.memory`                 | Memory limit per etcd-operator pod                                   | `128Mi`                                        |
| `backupOperator.spec.storageType`                 | Storage to use for backup file, currently only S3 supported          | `S3`                                           |
| `backupOperator.spec.s3.s3Bucket`                 | Bucket in S3 to store backup file                                    |                                                |
| `backupOperator.spec.s3.awsSecret`                | Name of kubernetes secret containing aws credentials                |                                                |
| `backupOperator.nodeSelector`                     | Node labels for etcd operator pod assignment                         | `{}`                                           |
| `backupOperator.commandArgs`                      | Additional command arguments                                         | `{}`                                           |
| `restoreOperator.name`                            | Restore operator name                                                | `etcd-backup-operator`                         |
| `restoreOperator.replicaCount`                    | Number of operator replicas to create (only 1 is supported)          | `1`                                            |
| `restoreOperator.image.repository`                | Operator container image                                             | `quay.io/coreos/etcd-operator`                 |
| `restoreOperator.image.tag`                       | Operator container image tag                                         | `v0.7.0`                                       |
| `restoreOperator.image.pullpolicy`                | Operator container image pull policy                                 | `Always`                                       |
| `restoreOperator.resources.cpu`                   | CPU limit per etcd-operator pod                                      | `100m`                                         |
| `restoreOperator.resources.memory`                | Memory limit per etcd-operator pod                                   | `128Mi`                                        |
| `restoreOperator.spec.s3.path`                    | Path in S3 bucket containing the backup file                         |                                                |
| `restoreOperator.spec.s3.awsSecret`               | Name of kubernetes secret containing aws credentials                |                                                |
| `restoreOperator.nodeSelector`                    | Node labels for etcd operator pod assignment                         | `{}`                                           |
| `restoreOperator.commandArgs`                     | Additional command arguments                                         | `{}`                                           |
| `etcdCluster.name`                                | etcd cluster name                                                    | `etcd-cluster`                                 |
| `etcdCluster.size`                                | etcd cluster size                                                    | `3`                                            |
| `etcdCluster.version`                             | etcd cluster version                                                 | `3.2.10`                                       |
| `etcdCluster.image.repository`                    | etcd container image                                                 | `quay.io/coreos/etcd-operator`                 |
| `etcdCluster.image.tag`                           | etcd container image tag                                             | `v3.2.10`                                      |
| `etcdCluster.image.pullPolicy`                    | etcd container image pull policy                                     | `Always`                                       |
| `etcdCluster.enableTLS`                           | Enable use of TLS                                                    | `false`                                        |
| `etcdCluster.tls.static.member.peerSecret`        | Kubernetes secret containing TLS peer certs                          | `etcd-peer-tls`                                |
| `etcdCluster.tls.static.member.serverSecret`      | Kubernetes secret containing TLS server certs                        | `etcd-server-tls`                              |
| `etcdCluster.tls.static.operatorSecret`           | Kubernetes secret containing TLS client certs                        | `etcd-client-tls`                              |
| `etcdCluster.pod.antiAffinity`                    | Whether etcd cluster pods should have an antiAffinity                | `false`                                        |
| `etcdCluster.pod.resources.limits.cpu`            | CPU limit per etcd cluster pod                                       | `100m`                                         |
| `etcdCluster.pod.resources.limits.memory`         | Memory limit per etcd cluster pod                                    | `128Mi`                                        |
| `etcdCluster.pod.resources.requests.cpu`          | CPU request per etcd cluster pod                                     | `100m`                                         |
| `etcdCluster.pod.resources.requests.memory`       | Memory request per etcd cluster pod                                  | `128Mi`                                        |
| `etcdCluster.pod.nodeSelector`                    | node labels for etcd cluster pod assignment                          | `{}`                                           |

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
By default the chart will install the recommended RBAC roles and rolebindings.

To determine if your cluster supports this running the following:

```console
$ kubectl api-versions | grep rbac
```

You also need to have the following parameter on the api server. See the following document for how to enable [RBAC](https://kubernetes.io/docs/admin/authorization/rbac/)

```
--authorization-mode=RBAC
```

If the output contains "beta" or both "alpha" and "beta" you can may install rbac by default, if not, you may turn RBAC off as described below.

### RBAC role/rolebinding creation

RBAC resources are enabled by default. To disable RBAC do the following:

```console
$ helm install --name my-release stable/etcd-operator --set rbac.create=false
```

### Changing RBAC manifest apiVersion

By default the RBAC resources are generated with the "v1beta1" apiVersion. To use "v1alpha1" do the following:

```console
$ helm install --name my-release stable/etcd-operator --set rbac.install=true,rbac.apiVersion=v1alpha1
```
