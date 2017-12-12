# RabbitMQ

[RabbitMQ](https://www.rabbitmq.com/) is an open source message broker software that implements the Advanced Message Queuing Protocol (AMQP).

## TL;DR;

```bash
$ helm install stable/rabbitmq
```

## Introduction

This chart bootstraps a [RabbitMQ](https://github.com/bitnami/bitnami-docker-rabbitmq) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/rabbitmq
```

The command deploys RabbitMQ on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the RabbitMQ chart and their default values.

|          Parameter          |                       Description                       |                         Default                          |
|-----------------------------|---------------------------------------------------------|----------------------------------------------------------|
| `image`                     | RabbitMQ image                                          | `bitnami/rabbitmq:{VERSION}`                             |
| `imagePullPolicy`           | Image pull policy                                       | `Always` if `imageTag` is `latest`, else `IfNotPresent`. |
| `rabbitmqUsername`          | RabbitMQ application username                           | `user`                                                   |
| `rabbitmqPassword`          | RabbitMQ application password                           | _random 10 character long alphanumeric string_           |
| `rabbitmqErlangCookie`      | Erlang cookie                                           | _random 32 character long alphanumeric string_           |
| `rabbitmqNodePort`          | Node port                                               | `5672`                                                   |
| `rabbitmqNodeType`          | Node type                                               | `stats`                                                  |
| `rabbitmqNodeName`          | Node name                                               | `rabbit`                                                 |
| `rabbitmqClusterNodeName`   | Node name to cluster with. e.g.: `clusternode@hostname` | `nil`                                                    |
| `rabbitmqVhost`             | RabbitMQ application vhost                              | `/`                                                      |
| `rabbitmqManagerPort`       | RabbitMQ Manager port                                   | `15672`                                                  |
| `rabbitmqDiskFreeLimit`     | Disk free limit                                         | `"8GiB"`                                    |
| `serviceType`               | Kubernetes Service type                                 | `ClusterIP`                                              |
| `persistence.enabled`       | Use a PVC to persist data                               | `true`                                                   |
| `persistence.existingClaim` | Use an existing PVC to persist data                     | `nil`                                                    |
| `persistence.storageClass`  | Storage class of backing PVC                            | `nil` (uses alpha storage class annotation)              |
| `persistence.accessMode`    | Use volume as ReadOnly or ReadWrite                     | `ReadWriteOnce`                                          |
| `persistence.size`          | Size of data volume                                     | `8Gi`                                                    |

The above parameters map to the env variables defined in [bitnami/rabbitmq](http://github.com/bitnami/bitnami-docker-rabbitmq). For more information please refer to the [bitnami/rabbitmq](http://github.com/bitnami/bitnami-docker-rabbitmq) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set rabbitmqUsername=admin,rabbitmqPassword=secretpassword,rabbitmqErlangCookie=secretcookie \
    stable/rabbitmq
```

The above command sets the RabbitMQ admin username and password to `admin` and `secretpassword` respectively. Additionally the secure erlang cookie is set to `secretcookie`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/rabbitmq
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami RabbitMQ](https://github.com/bitnami/bitnami-docker-rabbitmq) image stores the RabbitMQ data and configurations at the `/bitnami/rabbitmq` path of the container.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. By default, the volume is created using dynamic volume provisioning. An existing PersistentVolumeClaim can also be defined.


### Existing PersistentVolumeClaims

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart
```bash
$ helm install --set persistence.existingClaim=PVC_NAME rabbitmq
```
