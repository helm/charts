# MongoDB

[MongoDB](https://www.mongodb.com/) is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas, making the integration of data in certain types of applications easier and faster.

## TL;DR;

```bash
$ helm install stable/mongodb
```

## Introduction

This chart bootstraps a [MongoDB](https://github.com/bitnami/bitnami-docker-mongodb) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/mongodb
```

The command deploys MongoDB on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the MongoDB chart and their default values.

|         Parameter          |             Description             |                         Default                          |
|----------------------------|-------------------------------------|----------------------------------------------------------|
| `image`                    | MongoDB image                       | `bitnami/mongodb:{VERSION}`                              |
| `imagePullPolicy`          | Image pull policy                   | `Always` if `imageTag` is `latest`, else `IfNotPresent`. |
| `mongodbRootPassword`      | MongoDB admin password              | `nil`                                                    |
| `mongodbUsername`          | MongoDB custom user                 | `nil`                                                    |
| `mongodbPassword`          | MongoDB custom user password        | `nil`                                                    |
| `mongodbDatabase`          | Database to create                  | `nil`                                                    |
| `persistence.enabled`      | Use a PVC to persist data           | `true`                                                   |
| `persistence.storageClass` | Storage class of backing PVC        | `nil` (uses alpha storage class annotation)              |
| `persistence.accessMode`   | Use volume as ReadOnly or ReadWrite | `ReadWriteOnce`                                          |
| `persistence.size`         | Size of data volume                 | `8Gi`                                                    |

The above parameters map to the env variables defined in [bitnami/mongodb](http://github.com/bitnami/bitnami-docker-mongodb). For more information please refer to the [bitnami/mongodb](http://github.com/bitnami/bitnami-docker-mongodb) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set mongodbRootPassword=secretpassword,mongodbUsername=my-user,mongodbPassword=my-password,mongodbDatabase=my-database \
    stable/mongodb
```

The above command sets the MongoDB `root` account password to `secretpassword`. Additionally it creates a standard database user named `my-user`, with the password `my-password`, who has access to a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/mongodb
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami MongoDB](https://github.com/bitnami/bitnami-docker-mongodb) image stores the MongoDB data and configurations at the `/bitnami/mongodb` path of the container.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning.
