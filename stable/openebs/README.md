OpenEBS
=======

[OpenEBS](https://github.com/openebs/openebs) is an open source storage platform that provides persistent and containerized block storage for DevOps and container environments.

OpenEBS can be deployed on any Kubernetes cluster - either in cloud, on-premise or developer laptop (minikube). OpenEBS itself is deployed as just another container on your cluster, and enables storage services that can be designated on a per pod, application, cluster or container level.

Introduction
------------

This chart bootstraps OpenEBS deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
- Kubernetes 1.7.5+ with RBAC enabled
- iSCSI PV support in the underlying infrastructure

## Installing OpenEBS
```
helm install stable/openebs
```

## Installing OpenEBS with the release name `my-release`:
```
helm install --name `my-release` stable/openebs
```

## To uninstall/delete the `my-release` deployment:
```
helm ls --all
helm delete `my-release`
```


## Configuration

The following table lists the configurable parameters of the OpenEBS chart and their default values.

| Parameter                               | Description                                   | Default                                   |
| ----------------------------------------| --------------------------------------------- | ----------------------------------------- |
| `rbac.create`                           | Enable RBAC Resources                         | `true`                                    |
| `image.pullPolicy`                      | Container pull policy                         | `IfNotPresent`                            |
| `apiserver.image`                       | Docker Image for API Server                   | `quay.io/openebs/m-apiserver`             |
| `apiserver.imageTag`                    | Docker Image Tag for API Server               | `0.7.1`                                   |
| `apiserver.replicas`                    | Number of API Server Replicas                 | `1`                                       |
| `provisioner.image`                     | Docker Image for Provisioner                  | `quay.io/openebs/openebs-k8s-provisioner` |
| `provisioner.imageTag`                  | Docker Image Tag for Provisioner              | `0.7.1`                                   |
| `provisioner.replicas`                  | Number of Provisioner Replicas                | `1`                                       |
| `snapshotOperator.provisioner.image`    | Docker Image for Snapshot Provisioner         | `quay.io/openebs/snapshot-provisioner`    |
| `snapshotOperator.provisioner.imageTag` | Docker Image Tag for Snapshot Provisioner     | `0.7.1`                                   |
| `snapshotOperator.controller.image`     | Docker Image for Snapshot Controller          | `quay.io/openebs/snapshot-controller`     |
| `snapshotOperator.controller.imageTag`  | Docker Image Tag for Snapshot Controller      | `0.7.1`                                   |
| `snapshotOperator.replicas`             | Number of Snapshot Operator Replicas          | `1`                                       |
| `ndm.image`                             | Docker Image for Node Disk Manager            | `quay.io/openebs/openebs/node-disk-manager-amd64` |
| `ndm.imageTag`                          | Docker Image Tag for Node Disk Manager        | `v0.2.0`                                  |
| `ndm.sparse.enabled`                    | Create Sparse files and cStor Sparse Pool     | `true`                                    |
| `ndm.sparse.path`                       | Directory where Sparse files are created      | `/var/openebs/sparse`                     |
| `ndm.sparse.size`                       | Size of the sparse file in bytes              | `10737418240`                             |
| `ndm.sparse.count`                      | Number of sparse files to be created          | `1`                                       |
| `ndm.sparse.filters.excludeVendors`     | Exclude devices with specified vendor         | `CLOUDBYT,OpenEBS`                        |
| `ndm.sparse.filters.excludePaths`       | Exclude devices with specified path patterns  | `loop,fd0,sr0,/dev/ram,/dev/dm-`          |
| `jiva.image`                            | Docker Image for Jiva                         | `quay.io/openebs/jiva`                    |
| `jiva.imageTag`                         | Docker Image Tag for Jiva                     | `0.7.1`                                   |
| `jiva.replicas`                         | Number of Jiva Replicas                       | `3`                                       |
| `cstor.pool.image`                      | Docker Image for cStor Pool                   | `quay.io/openebs/cstor-pool`              |
| `cstor.pool.imageTag`                   | Docker Image Tag for cStor Pool               | `0.7.1`                                   |
| `cstor.poolMgmt.image`                  | Docker Image for cStor Pool  Management       | `quay.io/openebs/cstor-pool-mgmt`         |
| `cstor.poolMgmt.imageTag`               | Docker Image Tag for cStor Pool Management    | `0.7.1`                                   |
| `cstor.target.image`                    | Docker Image for cStor Target                 | `quay.io/openebs/cstor-istgt`             |
| `cstor.target.imageTag`                 | Docker Image Tag for cStor Target             | `0.7.1`                                   |
| `cstor.volumeMgmt.image`                | Docker Image for cStor Volume  Management     | `quay.io/openebs/cstor-volume-mgmt`       |
| `cstor.volumeMgmt.imageTag`             | Docker Image Tag for cStor Volume Management  | `0.7.1`                                   |
| `policies.monitoring.image`             | Docker Image for Prometheus Exporter          | `quay.io/openebs/m-exporter`              |
| `policies.monitoring.imageTag`          | Docker Image Tag for Prometheus Exporter      | `0.7.1`                                   |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```shell
helm install --name `my-release` -f values.yaml stable/openebs
```

> **Tip**: You can use the default [values.yaml](values.yaml)
