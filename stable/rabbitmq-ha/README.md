# RabbitMQ High Available

[RabbitMQ](https://www.rabbitmq.com) is an open source message broker software
that implements the Advanced Message Queuing Protocol (AMQP).

## TL;DR;

```bash
$ helm install stable/rabbitmq-ha
```

## Introduction

This chart bootstraps a [RabbitMQ](https://hub.docker.com/r/_/rabbitmq)
deployment on a [Kubernetes](http://kubernetes.io) cluster using the
[Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.5+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/rabbitmq-ha
```

The command deploys RabbitMQ on the Kubernetes cluster in the default
configuration. The [configuration](#configuration) section lists the parameters
that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following tables lists the configurable parameters of the RabbitMQ chart
and their default values.

|          Parameter                 |                       Description                               |                         Default                          |
|------------------------------------|-----------------------------------------------------------------|----------------------------------------------------------|
| `customConfigMap`                  | Use a custom ConfigMap                                          | `false`                                                  |
| `image.pullPolicy`                 | Image pull policy                                               | `Always` if `image` tag is `latest`, else `IfNotPresent` |
| `image.repository`                 | RabbitMQ container image repository                             | `rabbitmq`                                               |
| `image.tag`                        | RabbitMQ container image tag                                    | `3.7-alpine`                                             |
| `nodeSelector`                     | Node labels for pod assignment                                  | `{}`                                                     |
| `persistentVolume.accessMode`      | Persistent volume access modes                                  | `[ReadWriteOnce]`                                        |
| `persistentVolume.annotations`     | Persistent volume annotations                                   | `{}`                                                     |
| `persistentVolume.enabled`         | If `true`, persistent volume claims are created                 | `false`                                                  |
| `persistentVolume.size`            | Persistent volume size                                          | `8Gi`                                                    |
| `persistentVolume.storageClass`    | Persistent volume storage class                                 | `-`                                                      |
| `podAntiAffinity`                  | Pod antiaffinity, `hard` or `soft`                              | `hard`                                                   |
| `rabbitmqEpmdPort`                 | EPMD port used for cross cluster replication                    | `4369`                                                   |
| `rabbitmqErlangCookie`             | Erlang cookie                                                   | _random 32 character long alphanumeric string_           |
| `rabbitmqHipeCompile`              | Precompile parts of RabbitMQ using HiPE                         | `false`                                                  |
| `rabbitmqManagerPort`              | RabbitMQ Manager port                                           | `15672`                                                  |
| `rabbitmqMemoryHighWatermark`      | Memory high watermark                                           | `256MB`                                                  |
| `rabbitmqNodePort`                 | Node port                                                       | `5672`                                                   |
| `rabbitmqPassword`                 | RabbitMQ application password                                   | _random 10 character long alphanumeric string_           |
| `rabbitmqUsername`                 | RabbitMQ application username                                   | `guest`                                                  |
| `rabbitmqVhost`                    | RabbitMQ application vhost                                      | `/`                                                      |
| `rbac.create`                      | If true, create & use RBAC resources                            | `true`                                                   |
| `rbac.serviceAccountName`          | Service account name to use (ignored if rbac.create=true)       | `default`                                                |
| `replicaCount`                     | Number of replica                                               | `3`                                                      |
| `resources`                        | CPU/Memory resource requests/limits                             | `{}`                                                     |
| `service.annotations`              | Annotations to add to service                                   | `none`                                                   |
| `service.clusterIP`                | IP address to assign to service                                 | `""`                                                     |
| `service.externalIPs`              | Service external IP addresses                                   | `[]`                                                     |
| `service.loadBalancerIP`           | IP address to assign to load balancer (if supported)            | `""`                                                     |
| `service.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported) | `[]`                                                     |
| `service.type`                     | Type of service to create                                       | `ClusterIP`                                              |
| `tolerations`                      | Toleration labels for pod assignment                            | `[]`                                                     |
| `updateStrategy`                   | Statefulset update strategy                                     | `OnDelete`                                               |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set rabbitmqUsername=admin,rabbitmqPassword=secretpassword,rabbitmqErlangCookie=secretcookie \
    stable/rabbitmq-ha
```

The above command sets the RabbitMQ admin username and password to `admin` and
`secretpassword` respectively. Additionally the secure erlang cookie is set to
`secretcookie`.

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/rabbitmq-ha
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Custom ConfigMap

When creating a new chart with this chart as a dependency, `customConfigMap`
can be used to override the default configmap.yaml provided. It also allows for
providing additional configuration files that will be mounted into
`/etc/rabbitmq`. In the parent chart's values.yaml, set the value to true and
provide the file `templates/configmap.yaml` for your use case.
