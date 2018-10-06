# RabbitMQ

[RabbitMQ](https://www.rabbitmq.com/) is an open source message broker software that implements the Advanced Message Queuing Protocol (AMQP).

## TL;DR;

```bash
$ helm install stable/rabbitmq
```

## Introduction

This chart bootstraps a [RabbitMQ](https://github.com/bitnami/bitnami-docker-rabbitmq) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.8+
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

The following table lists the configurable parameters of the RabbitMQ chart and their default values.

|          Parameter          |                       Description                       |                         Default                          |
|-----------------------------|---------------------------------------------------------|----------------------------------------------------------|
| `image.registry`            | Rabbitmq Image registry                                 | `docker.io`                                              |
| `image.repository`          | Rabbitmq Image name                                     | `bitnami/rabbitmq`                                       |
| `image.tag`                 | Rabbitmq Image tag                                      | `{VERSION}`                                              |
| `image.pullPolicy`          | Image pull policy                                       | `Always` if `imageTag` is `latest`, else `IfNotPresent`  |
| `image.pullSecrets`         | Specify docker-registry secret names as an array        | `nil`                                                    |
| `image.debug`               | Specify if debug values should be set                   | `false`                                                  |
| `rbacEnabled`               | Specify if rbac is enabled in your cluster              | `true`                                                   |
| `rabbitmq.username`         | RabbitMQ application username                           | `user`                                                   |
| `rabbitmq.password`         | RabbitMQ application password                           | _random 10 character long alphanumeric string_           |
| `rabbitmq.erlangCookie`     | Erlang cookie                                           | _random 32 character long alphanumeric string_           |
| `rabbitmq.amqpPort`         | Amqp port                                               | `5672`                                                   |
| `rabbitmq.distPort`         | Erlang distribution server port                         | `25672`                                                  |
| `rabbitmq.nodePort`         | Node port override, if serviceType NodePort             | _random avaliable between 30000-32767_                   |
| `rabbitmq.managerPort`      | RabbitMQ Manager port                                   | `15672`                                                  |
| `rabbitmq.diskFreeLimit`    | Disk free limit                                         | `"6GiB"`                                                 |
| `rabbitmq.plugins`         | configuration file for plugins to enable                 | `[rabbitmq_management,rabbitmq_peer_discovery_k8s].`  |
| `rabbitmq.clustering.address_type` | Switch clustering mode                           | `ip` or `hostname`
| `rabbitmq.clustering.k8s_domain`   | Customize internal k8s cluster domain            | `cluster.local`

| `rabbitmq.ulimitNofiles`    | Max File Descriptor limit                               | `65536`                                                  |
| `rabbitmq.configuration`    | rabbitmq.conf content                                   | see values.yaml                                          |
| `serviceType`               | Kubernetes Service type                                 | `ClusterIP`                                              |
| `persistence.enabled`       | Use a PVC to persist data                               | `false`                                                  |
| `persistence.storageClass`  | Storage class of backing PVC                            | `nil` (uses alpha storage class annotation)              |
| `persistence.accessMode`    | Use volume as ReadOnly or ReadWrite                     | `ReadWriteOnce`                                          |
| `persistence.size`          | Size of data volume                                     | `8Gi`                                                    |
| `securityContext.enabled`   | Enable security context                                 | `true`                                                   |
| `securityContext.fsGroup`   | Group ID for the container                              | `1001`                                                   |
| `securityContext.runAsUser` | User ID for the container                               | `1001`                                                   |
| `resources`                 | resource needs and limits to apply to the pod           | {}                                                       |
| `nodeSelector`              | Node labels for pod assignment                          | {}                                                       |
| `affinity`                  | Affinity settings for pod assignment                    | {}                                                       |
| `tolerations`               | Toleration labels for pod assignment                    | []                                                       |
| `ingress.enabled`           | enable ingress for management console                   | `false`                                                  |
| `ingress.tls`               | enable ingress with tls                                 | `false`                                                  |
| `ingress.tlsSecret`         | tls type secret to be used                              | `myTlsSecret`                                            |
| `ingress.annotations`       | ingress annotations as an array                         |  []                                                      |
| `livenessProbe.enabled`               | would you like a livenessProbed to be enabled           |  `true`                                        |
| `livenessProbe.initialDelaySeconds`   | number of seconds                                       |  120                                           |
| `livenessProbe.timeoutSeconds`        | number of seconds                                       |  5                                             |
| `livenessProbe.periodSeconds`         | number of seconds                                       |  5                                             |
| `livenessProbe.failureThreshold`      | number of failures                                      |  6                                             |
| `livenessProbe.successThreshold`      | number of successes                                     |  1                                             |
| `readinessProbe.enabled`              | would you like a readinessProbe to be enabled           |  `true`                                        |
| `readinessProbe.initialDelaySeconds`  | number of seconds                                       |  10                                            |
| `readinessProbe.timeoutSeconds`       | number of seconds                                       |  3                                             |
| `readinessProbe.periodSeconds   `     | number of seconds                                       |  5                                             |
| `readinessProbe.failureThreshold`     | number of failures                                      |  3                                             |
| `readinessProbe.successThreshold`     | number of successes                                     |  1                                             |

The above parameters map to the env variables defined in [bitnami/rabbitmq](http://github.com/bitnami/bitnami-docker-rabbitmq). For more information please refer to the [bitnami/rabbitmq](http://github.com/bitnami/bitnami-docker-rabbitmq) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set rabbitmq.username=admin,rabbitmq.password=secretpassword,rabbitmq.erlangCookie=secretcookie \
    stable/rabbitmq
```

The above command sets the RabbitMQ admin username and password to `admin` and `secretpassword` respectively. Additionally the secure erlang cookie is set to `secretcookie`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/rabbitmq
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Production configuration
A standard configuration is provided by default that will run on most development environments. To operate this chart in a production environment, we recommend you use the alternative file values-production.yaml provided in this repository.
```bash
$ helm install --name my-release -f values-production.yaml stable/rabbitmq
```

## Persistence

The [Bitnami RabbitMQ](https://github.com/bitnami/bitnami-docker-rabbitmq) image stores the RabbitMQ data and configurations at the `/opt/bitnami/rabbitmq/var/lib/rabbitmq/` path of the container.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. By default, the volume is created using dynamic volume provisioning. An existing PersistentVolumeClaim can also be defined.

### Existing PersistentVolumeClaims

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart

```bash
$ helm install --set persistence.existingClaim=PVC_NAME rabbitmq
```

## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is opencart:

```console
$ kubectl delete statefulset rabbitmq --cascade=false
```
