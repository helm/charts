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

## Upgrading the Chart

To upgrade the chart, you need to make sure that you are using the same value
of the `rabbitmqErlangCookie` amongst the releases. If you didn't define it at
the first place, you can upgrade using the following command:

```
$ export ERLANGCOOKIE=$(kubectl get secrets -n <NAMESPACE> <HELM_RELEASE_NAME>-rabbitmq-ha -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 --decode)
$ helm upgrade \
    --set rabbitmqErlangCookie=$ERLANGCOOKIE \
    <HELM_RELEASE_NAME> stable/rabbitmq-ha
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following table lists the configurable parameters of the RabbitMQ chart
and their default values.

| Parameter                                      | Description                                                                                                                                                                                           | Default                                                    |
|------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------|
| `existingConfigMap`                            | Use an existing ConfigMap                                                                                                                                                                             | `false`                                                    |
| `existingSecret`                               | Use an existing secret for password & erlang cookie                                                                                                                                                   | `""`                                                       |
| `extraPlugins`                                 | Additional plugins to add to the default configmap                                                                                                                                                    | `rabbitmq_shovel, rabbitmq_shovel_management, rabbitmq_federation, rabbitmq_federation_management,` |
| `extraConfig`                                  | Additional configuration to add to default configmap                                                                                                                                                  | `{}`                                                         |
| `definitions.users`                            | Additional users | `""` |
| `definitions.vhosts`                           | Additional vhosts | `""` |
| `definitions.parameters`                       | Additional parameters | `""` |
| `definitions.permissions`                      | Additional permissions | `""` |
| `definitions.queues`                           | Pre-created queues | `""` |
| `definitions.exchanges`                        | Pre-created exchanges | `""` |
| `definitions.bindings`                         | Pre-created bindings | `""` |
| `definitions.policies`                         | HA policies to add to definitions.json | `""` |
| `definitionsSource`                            | Use this key within an existing secret to reference the definitions specification | `"definitions.json"` |
| `image.pullPolicy`                             | Image pull policy                                                                                                                                                                                     | `Always` if `image` tag is `latest`, else `IfNotPresent`   |
| `image.repository`                             | RabbitMQ container image repository                                                                                                                                                                   | `rabbitmq`                                                 |
| `image.tag`                                    | RabbitMQ container image tag                                                                                                                                                                          | `3.7-alpine`                                               |
| `image.pullSecrets`                            | Specify docker-registry secret names as an array                                                                                                                                                      | `[]`                                                       |
| `managementPassword`                           | Management user password. Should be changed from default                                                                                                                                              | `E9R3fjZm4ejFkVFE`                                         |
| `managementUsername`                           | Management user with minimal permissions used for health checks                                                                                                                                       | `management`                                               |
| `nodeSelector`                                 | Node labels for pod assignment                                                                                                                                                                        | `{}`                                                       |
| `persistentVolume.accessMode`                  | Persistent volume access modes                                                                                                                                                                        | `[ReadWriteOnce]`                                          |
| `persistentVolume.annotations`                 | Persistent volume annotations                                                                                                                                                                         | `{}`                                                       |
| `persistentVolume.enabled`                     | If `true`, persistent volume claims are created                                                                                                                                                       | `false`                                                    |
| `persistentVolume.name`                        | Persistent volume name                                                                                                                                                                                | `data`                                                     |
| `persistentVolume.size`                        | Persistent volume size                                                                                                                                                                                | `8Gi`                                                      |
| `persistentVolume.storageClass`                | Persistent volume storage class                                                                                                                                                                       | `-`                                                        |
| `podAntiAffinity`                              | Pod antiaffinity, `hard` or `soft`                                                                                                                                                                    | `hard`                                                     |
| `podManagementPolicy`                          | Whether the pods should be restarted in parallel or one at a time. Either `OrderedReady` or `Parallel`.                                                                                               | `OrderedReady`                                             |
| `prometheus.exporter.enabled`                  | Configures Prometheus Exporter to expose and scrape stats                                                                                                                                             | `false`                                                    |
| `prometheus.exporter.env`                      | Environment variables to set for Exporter container                                                                                                                                                   | `{}`                                                       |
| `prometheus.exporter.image.repository`         | Prometheus Exporter repository                                                                                                                                                                        | `kbudde/rabbitmq-exporter`                                 |
| `prometheus.exporter.image.tag`                | Image Tag                                                                                                                                                                                             | `v0.29.0`                                                  |
| `prometheus.exporter.image.pullPolicy`         | Image Pull Policy                                                                                                                                                                                     | `IfNotPresent`                                             |
| `prometheus.exporter.port`                     | Port Prometheus scrapes for metrics                                                                                                                                                                   | `9090`                                                     |
| `prometheus.exporter.capabilities`             | Comma-separated list of extended scraping capabilities supported by the target RabbitMQ server. [Click here for details.](https://github.com/kbudde/rabbitmq_exporter#extended-rabbitmq-capabilities) | `bert,no_sort`                                             |
| `prometheus.exporter.resources`                | Resource Limits for Prometheus Exporter                                                                                                                                                               | `{}`                                                       |
| `prometheus.operator.enabled`                  | Are you using Prometheus Operator?  [Blog Post](https://coreos.com/blog/the-prometheus-operator.html)                                                                                                 | `true`                                                     |
| `prometheus.operator.alerts.enabled`           | Create default Alerts for RabbitMQ                                                                                                                                                                    | `true`                                                     |
| `prometheus.operator.alerts.selector`          | Selector to find ConfigMaps and create Prometheus Alerts                                                                                                                                              | `alert-rules`                                              |
| `prometheus.operator.alerts.labels`            | Labels to add to Alerts                                                                                                                                                                               | `{}`                                                       |
| `prometheus.operator.serviceMonitor.interval`  | How often Prometheus Scrapes metrics                                                                                                                                                                  | `10s`                                                      |
| `prometheus.operator.serviceMonitor.namespace` | Namespace which Prometheus is installed                                                                                                                                                               | `monitoring`                                               |
| `prometheus.operator.serviceMonitor.selector`  | Label Selector for Prometheus to find ServiceMonitors                                                                                                                                                 | `{ prometheus: kube-prometheus }`                          |
| `rabbitmqCert.enabled`                         | Mount a Secret container certificates                                                                                                                                                                 | `false`                                                    |
| `rabbitmqCert.cacertfile`                      | base64 encoded CA certificate (overwrites existing Secret)                                                                                                                                            | ``                                                         |
| `rabbitmqCert.certfile`                        | base64 encoded server certificate (overwrites existing Secret)                                                                                                                                        | ``                                                         |
| `rabbitmqCert.existingSecret`                  | Name of an existing `Secret` to mount for amqps                                                                                                                                                       | `""`                                                       |
| `rabbitmqCert.keyfile`                         | base64 encoded server private key (overwrites existing Secret)                                                                                                                                        | ``                                                         |
| `rabbitmqClusterPartitionHandling`             | [Automatic Partition Handling Strategy (split brain handling)](https://www.rabbitmq.com/partitions.html#automatic-handling)                                                                           | `autoheal`                                                 | 
| `extraVolumes`                             | Extra volumes to attach to the statefulset                                                                                                                                                           | `[]`                                                     |
| `extraVolumeMounts`                             | Extra volume mounts to mount to the statefulset                                                                                                                                                           | `[]`                                                     |
| `rabbitmqEpmdPort`                             | EPMD port used for cross cluster replication                                                                                                                                                          | `4369`                                                     |
| `rabbitmqErlangCookie`                         | Erlang cookie                                                                                                                                                                                         | _random 32 character long alphanumeric string_             |
| `rabbitmqHipeCompile`                          | Precompile parts of RabbitMQ using HiPE                                                                                                                                                               | `false`                                                    |
| `rabbitmqMQTTPlugin.config`                    | MQTT configuration                                                                                                                                                                                    | ``                                                         |
| `rabbitmqMQTTPlugin.enabled`                   | Enable MQTT plugin                                                                                                                                                                                    | `false`                                                    |
| `rabbitmqManagerPort`                          | RabbitMQ Manager port                                                                                                                                                                                 | `15672`                                                    |
| `rabbitmqMemoryHighWatermark`                  | Memory high watermark                                                                                                                                                                                 | `256MB`                                                    |
| `rabbitmqMemoryHighWatermarkType`              | Memory high watermark type. Either absolute or relative                                                                                                                                               | `absolute`                                                 |
| `rabbitmqNodePort`                             | Node port                                                                                                                                                                                             | `5672`                                                     |
| `rabbitmqPassword`                             | RabbitMQ application password                                                                                                                                                                         | _random 10 character long alphanumeric string_             |
| `rabbitmqSTOMPPlugin.config`                   | STOMP configuration                                                                                                                                                                                   | ``                                                         |
| `rabbitmqSTOMPPlugin.enabled`                  | Enable STOMP plugin                                                                                                                                                                                   | `false`                                                    |
| `rabbitmqUsername`                             | RabbitMQ application username                                                                                                                                                                         | `guest`                                                    |
| `rabbitmqVhost`                                | RabbitMQ application vhost                                                                                                                                                                            | `/`                                                        |
| `rabbitmqWebMQTTPlugin.config`                 | MQTT over websocket configuration                                                                                                                                                                     | ``                                                         |
| `rabbitmqWebMQTTPlugin.enabled`                | Enable MQTT over websocket plugin                                                                                                                                                                     | `false`                                                    |
| `rabbitmqWebSTOMPPlugin.config`                | STOMP over websocket configuration                                                                                                                                                                    | ``                                                         |
| `rabbitmqWebSTOMPPlugin.enabled`               | Enable STOMP over websocket plugin                                                                                                                                                                    | `false`                                                    |
| `rbac.create`                                  | If true, create & use RBAC resources                                                                                                                                                                  | `true`                                                     |
| `replicaCount`                                 | Number of replica                                                                                                                                                                                     | `3`                                                        |
| `resources`                                    | CPU/Memory resource requests/limits                                                                                                                                                                   | `{}`                                                       |
| `serviceAccount.create`                        | Create service account                                                                                                                                                                                | `true`                                                     |
| `serviceAccount.name`                          | Service account name to use                                                                                                                                                                           | _name of the release_                                      |
| `service.annotations`                          | Annotations to add to the service                                                                                                                                                                     | `{}`                                                       |
| `service.clusterIP`                            | IP address to assign to the service                                                                                                                                                                   | `None`                                                     |
| `service.externalIPs`                          | Service external IP addresses                                                                                                                                                                         | `[]`                                                       |
| `service.loadBalancerIP`                       | IP address to assign to load balancer (if supported)                                                                                                                                                  | `""`                                                       |
| `service.loadBalancerSourceRanges`             | List of IP CIDRs allowed access to load balancer (if supported)                                                                                                                                       | `[]`                                                       |
| `service.type`                                 | Type of service to create                                                                                                                                                                             | `ClusterIP`                                                |
| `tolerations`                                  | Toleration labels for pod assignment                                                                                                                                                                  | `[]`                                                       |
| `podAnnotations`                               | Extra annotations to add to pod                                                                                                                                                                       | `{}`                                                       |
| `terminationGracePeriodSeconds`                | Duration pod needs to terminate gracefully                                                                                                                                                            | `10`                                                       |
| `updateStrategy`                               | Statefulset update strategy                                                                                                                                                                           | `OnDelete`                                                 |
| `priorityClassName`                            | Statefulsets Pod Priority                                                                                                                                                                             | ``                                                         |
| `extraLabels`                                  | Labels to add to the Resources                                                                                                                                                                        | `{}`                                                       |
| `busyboxImage.repository`                      | Busybox initContainer image repo                                                                                                                                                                      | `busybox`                                                  |
| `busyboxImage.tag`                             | Busybox initContainer image tag                                                                                                                                                                       | `latest`                                                   |
| `busyboxImage.pullPolicy`                      | Busybox initContainer image pullPolicy                                                                                                                                                                | `Always`                                                   |
| `clusterDomain`                                | The internal Kubernetes cluster domain                                                                                                                                                                | `cluster.local`                                            |

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

When creating a new chart with this chart as a dependency, `existingConfigMap`
can be used to override the default [configmap.yaml](templates/configmap.yaml)
provided. It also allows for providing additional configuration files that will
be mounted into `/etc/rabbitmq`. In the parent chart's values.yaml, set the
value to true and provide the file [templates/configmap.yaml][] for your use
case.

Example of using RabbitMQ definition to setup users, permissions or policies:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-release-rabbitmq-ha
data:
  enabled_plugins: |
    [
      rabbitmq_consistent_hash_exchange,
      rabbitmq_federation,
      rabbitmq_federation_management,
      rabbitmq_management,
      rabbitmq_peer_discovery_k8s,
      rabbitmq_shovel,
      rabbitmq_shovel_management
    ].
  rabbitmq.conf: |
    # ....
    management.load_definitions = /etc/rabbitmq/definitions.json
  definitions.json: |
    {
      "permissions": [],
      "users": [],
      "policies: []
    }
```

Then, install the chart with the above configuration:

```
$ helm install --name my-release --set existingConfigMap=true stable/rabbitmq-ha
```

### Custom Secret

Similar to custom ConfigMap, `existingSecret` can be used to override the default secret.yaml provided, and
`rabbitmqCert.existingSecret` can be used to override the default certificates. The custom secret must provide
the following keys: 

* `rabbitmq-user`
* `rabbitmq-password`
* `rabbitmq-erlang-cookie`
* `definitions.json` (the name can be altered by setting the `definitionsSource`)

### Prometheus Monitoring & Alerts

Prometheus and its features can be enabled by setting `prometheus.enabled` to `true`.  See values.yaml for more details and configuration options
