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

- Kubernetes 1.9+ with Beta APIs enabled
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

| Parameter                                           | Description                                                                                                                                                                                           | Default                                                    |
|-----------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------|
| `existingConfigMap`                                 | Use an existing ConfigMap                                                                                                                                                                             | `false`                                                    |
| `existingSecret`                                    | Use an existing secret for password, managementPassword & erlang cookie                                                                                                                               | `""`                                                       |
| `extraPlugins`                                      | Additional plugins to add to the default configmap                                                                                                                                                    | `rabbitmq_shovel, rabbitmq_shovel_management, rabbitmq_federation, rabbitmq_federation_management,` |
| `extraConfig`                                       | Additional configuration to add to default configmap                                                                                                                                                  | `{}`                                                       |
| `extraContainers`                                   | Additional containers passed through the tpl                                                                                                                                                          | `[]`                                                       |
| `extraInitContainers`                               | Additional init containers passed through the tpl                                                                                                                                                     | `[]`                                                       |
| `env`                                               | Environment variables to set for Rabbitmq container                                                                                                                                                   | `{}`                                                       |
| `advancedConfig`                                    | Additional configuration in classic config format                                                                                                                                                     | `""`                                                       |
| `definitions.globalParameters`                      | Pre-configured global parameters | `""` |
| `definitions.users`                                 | Additional users | `""` |
| `definitions.vhosts`                                | Additional vhosts | `""` |
| `definitions.parameters`                            | Additional parameters | `""` |
| `definitions.permissions`                           | Additional permissions | `""` |
| `definitions.topicPermissions`                      | Additional permissions for topic management | `""` |
| `definitions.queues`                                | Pre-created queues | `""` |
| `definitions.exchanges`                             | Pre-created exchanges | `""` |
| `definitions.bindings`                              | Pre-created bindings | `""` |
| `definitions.policies`                              | HA policies to add to definitions.json | `""` |
| `definitionsSource`                                 | Use this key within an existing secret to reference the definitions specification | `"definitions.json"` |
| `forceBoot`                                         | [Force](https://www.rabbitmq.com/rabbitmqctl.8.html#force_boot) the cluster to start even if it was shutdown in an unexpected order, preferring availability over integrity | `false` |
| `lifecycle`                                         | RabbitMQ container lifecycle hooks                                                                                                                                                                    | `{}`             |
| `image.pullPolicy`                                  | Image pull policy                                                                                                                                                                                     | `IfNotPresent`   |
| `image.repository`                                  | RabbitMQ container image repository                                                                                                                                                                   | `rabbitmq`                                                 |
| `image.tag`                                         | RabbitMQ container image tag                                                                                                                                                                          | `3.8.0-alpine`                                             |
| `image.pullSecrets`                                 | Specify docker-registry secret names as an array                                                                                                                                                      | `[]`                                                       |
| `managementPassword`                                | Management user password.                                                                                                                                                                             | _random 24 character long alphanumeric string_             |
| `managementUsername`                                | Management user with minimal permissions used for health checks                                                                                                                                       | `management`                                               |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                        | `{}`                                                       |
| `persistentVolume.accessMode`                       | Persistent volume access modes                                                                                                                                                                        | `[ReadWriteOnce]`                                          |
| `persistentVolume.annotations`                      | Persistent volume annotations                                                                                                                                                                         | `{}`                                                       |
| `persistentVolume.labels`                           | Persistent volume labels                                                                                                                                                                              | `{}`                                                       |
| `persistentVolume.enabled`                          | If `true`, persistent volume claims are created                                                                                                                                                       | `false`                                                    |
| `persistentVolume.name`                             | Persistent volume name                                                                                                                                                                                | `data`                                                     |
| `persistentVolume.size`                             | Persistent volume size                                                                                                                                                                                | `8Gi`                                                      |
| `persistentVolume.storageClass`                     | Persistent volume storage class                                                                                                                                                                       | `-`                                                        |
| `podAntiAffinity`                                   | Pod anti-affinity, `hard` or `soft`                                                                                                                                                                   | `soft`                                                     |
| `podAntiAffinityTopologyKey`                        | TopologyKey for anti-affinity, default is hostname                                                                                                                                                    | `"kubernetes.io/hostname"`                                 |
| `affinity`                                          | Affinity settings. If specified, this will disable `podAntiAffinity` settings. If you still need anti-affinity, you must include the configuration here.                                              | `{}`                                                       |
| `podDisruptionBudget`                               | Pod Disruption Budget rules                                                                                                                                                                           | `{}`                                                       |
| `podManagementPolicy`                               | Whether the pods should be restarted in parallel or one at a time. Either `OrderedReady` or `Parallel`.                                                                                               | `OrderedReady`                                             |
| `prometheus.exporter.enabled`                       | Configures Prometheus Exporter to expose and scrape stats                                                                                                                                             | `false`                                                    |
| `prometheus.exporter.env`                           | Environment variables to set for Exporter container                                                                                                                                                   | `{}`                                                       |
| `prometheus.exporter.image.repository`              | Prometheus Exporter repository                                                                                                                                                                        | `kbudde/rabbitmq-exporter`                                 |
| `prometheus.exporter.image.tag`                     | Image Tag                                                                                                                                                                                             | `v0.29.0`                                                  |
| `prometheus.exporter.image.pullPolicy`              | Image Pull Policy                                                                                                                                                                                     | `IfNotPresent`                                             |
| `prometheus.exporter.port`                          | Port Prometheus scrapes for metrics                                                                                                                                                                   | `9090`                                                     |
| `prometheus.exporter.capabilities`                  | Comma-separated list of extended scraping capabilities supported by the target RabbitMQ server. [Click here for details.](https://github.com/kbudde/rabbitmq_exporter#extended-rabbitmq-capabilities) | `bert,no_sort`                                             |
| `prometheus.exporter.resources`                     | Resource Limits for Prometheus Exporter                                                                                                                                                               | `{}`                                                       |
| `prometheus.operator.enabled`                       | Are you using Prometheus Operator?  [Blog Post](https://coreos.com/blog/the-prometheus-operator.html)                                                                                                 | `true`                                                     |
| `prometheus.operator.alerts.enabled`                | Create default Alerts for RabbitMQ                                                                                                                                                                    | `true`                                                     |
| `prometheus.operator.alerts.selector`               | Selector to find ConfigMaps and create Prometheus Alerts                                                                                                                                              | `alert-rules`                                              |
| `prometheus.operator.alerts.labels`                 | Labels to add to Alerts                                                                                                                                                                               | `{}`                                                       |
| `prometheus.operator.serviceMonitor.interval`       | How often Prometheus Scrapes metrics                                                                                                                                                                  | `10s`                                                      |
| `prometheus.operator.serviceMonitor.scrapeTimeout`  | Specify the timeout after which the scrape is ended                                                                                                                                                   | `nil`                                                      |
| `prometheus.operator.serviceMonitor.namespace`      | Namespace which Prometheus is installed                                                                                                                                                               | `monitoring`                                               |
| `prometheus.operator.serviceMonitor.selector`       | Label Selector for Prometheus to find ServiceMonitors                                                                                                                                                 | `{ prometheus: kube-prometheus }`                          |
| `rabbitmqCert.enabled`                              | Mount a Secret container certificates                                                                                                                                                                 | `false`                                                    |
| `rabbitmqCert.cacertfile`                           | base64 encoded CA certificate (overwrites existing Secret)                                                                                                                                            | ``                                                         |
| `rabbitmqCert.certfile`                             | base64 encoded server certificate (overwrites existing Secret)                                                                                                                                        | ``                                                         |
| `rabbitmqCert.existingSecret`                       | Name of an existing `Secret` to mount for amqps                                                                                                                                                       | `""`                                                       |
| `rabbitmqCert.keyfile`                              | base64 encoded server private key (overwrites existing Secret)                                                                                                                                        | ``                                                         |
| `rabbitmqClusterPartitionHandling`                  | [Automatic Partition Handling Strategy (split brain handling)](https://www.rabbitmq.com/partitions.html#automatic-handling)                                                                           | `autoheal`                                                 |
| `extraVolumes`                                      | Extra volumes to attach to the statefulset                                                                                                                                                            | `[]`                                                       |
| `extraVolumeMounts`                                 | Extra volume mounts to mount to the statefulset                                                                                                                                                       | `[]`                                                       |
| `rabbitmqEpmdPort`                                  | EPMD port used for cross cluster replication                                                                                                                                                          | `4369`                                                     |
| `rabbitmqErlangCookie`                              | Erlang cookie                                                                                                                                                                                         | _random 32 character long alphanumeric string_             |
| `rabbitmqHipeCompile`                               | Precompile parts of RabbitMQ using HiPE                                                                                                                                                               | `false`                                                    |
| `rabbitmqMQTTPlugin.config`                         | MQTT configuration                                                                                                                                                                                    | ``                                                         |
| `rabbitmqMQTTPlugin.enabled`                        | Enable MQTT plugin                                                                                                                                                                                    | `false`                                                    |
| `rabbitmqManagerPort`                               | RabbitMQ Manager port                                                                                                                                                                                 | `15672`                                                    |
| `rabbitmqMemoryHighWatermark`                       | Memory high watermark                                                                                                                                                                                 | `256MB`                                                    |
| `rabbitmqMemoryHighWatermarkType`                   | Memory high watermark type. Either absolute or relative                                                                                                                                               | `absolute`                                                 |
| `rabbitmqNodePort`                                  | Node port                                                                                                                                                                                             | `5672`                                                     |
| `rabbitmqPassword`                                  | RabbitMQ application password                                                                                                                                                                         | _random 24 character long alphanumeric string_             |
| `rabbitmqSTOMPPlugin.config`                        | STOMP configuration                                                                                                                                                                                   | ``                                                         |
| `rabbitmqSTOMPPlugin.enabled`                       | Enable STOMP plugin                                                                                                                                                                                   | `false`                                                    |
| `rabbitmqUsername`                                  | RabbitMQ application username                                                                                                                                                                         | `guest`                                                    |
| `rabbitmqVhost`                                     | RabbitMQ application vhost                                                                                                                                                                            | `/`                                                        |
| `rabbitmqWebMQTTPlugin.config`                      | MQTT over websocket configuration                                                                                                                                                                     | ``                                                         |
| `rabbitmqWebMQTTPlugin.enabled`                     | Enable MQTT over websocket plugin                                                                                                                                                                     | `false`                                                    |
| `rabbitmqWebSTOMPPlugin.config`                     | STOMP over websocket configuration                                                                                                                                                                    | ``                                                         |
| `rabbitmqWebSTOMPPlugin.enabled`                    | Enable STOMP over websocket plugin                                                                                                                                                                    | `false`                                                    |
| `rabbitmqPrometheusPlugin.enabled`                  | Enable native RabbitMQ prometheus plugin. (Available in RabbitMQ 3.8)                                                                                                                                 | `false`                                                    |
| `rabbitmqPrometheusPlugin.nodePort`                 | Exposes the native prometheus metrics port on the given NodePort                                                                                                                                      | `null`                                                     |
| `rabbitmqPrometheusPlugin.port`                     | The port RabbitMQ prometheus plugin will use                                                                                                                                                          | `15692`                                                    |
| `rabbitmqPrometheusPlugin.path`                     | The path RabbitMQ prometheus plugin will use                                                                                                                                                          | `/metrics`                                                 |
| `rabbitmqPrometheusPlugin.config`                   | RabbitMQ prometheus plugin aditional configuration                                                                                                                                                    | ``                                                         |
| `rbac.create`                                       | If true, create & use RBAC resources                                                                                                                                                                  | `true`                                                     |
| `replicaCount`                                      | Number of replica                                                                                                                                                                                     | `3`                                                        |
| `resources`                                         | CPU/Memory resource requests/limits                                                                                                                                                                   | `{}`                                                       |
| `schedulerName`                                     | alternate scheduler name                                                                                                                                                                              | `nil`                                                      |
| `securityContext.fsGroup`                           | Group ID for the container's volumes                                                                                                                                                                  | `101`                                                      |
| `securityContext.runAsGroup`                        | Group ID for the container                                                                                                                                                                            | `101`                                                      |
| `securityContext.runAsNonRoot`                      | Enforce non-root user ID for the container                                                                                                                                                            | `true`                                                     |
| `securityContext.runAsUser`                         | User ID for the container                                                                                                                                                                             | `100`                                                      |
| `serviceAccount.create`                             | Create service account                                                                                                                                                                                | `true`                                                     |
| `serviceAccount.automountServiceAccountToken`       | Automount API credentials for a service account                                                                                                                                                       | `true`                                                     |
| `serviceAccount.name`                               | Service account name to use                                                                                                                                                                           | _name of the release_                                      |
| `service.annotations`                               | Annotations to add to the service                                                                                                                                                                     | `{}`                                                       |
| `service.clusterIP`                                 | IP address to assign to the service                                                                                                                                                                   | None                                                       |
| `service.externalIPs`                               | Service external IP addresses                                                                                                                                                                         | `[]`                                                       |
| `service.loadBalancerIP`                            | IP address to assign to load balancer (if supported)                                                                                                                                                  | `""`                                                       |
| `service.loadBalancerSourceRanges`                  | List of IP CIDRs allowed access to load balancer (if supported)                                                                                                                                       | `[]`                                                       |
| `service.type`                                      | Type of service to create                                                                                                                                                                             | `ClusterIP`                                                |
| `ingress.enabled`                                   | Enable Ingress                                                                                                                                                                                        | `false`                                                    |
| `ingress.path`                                      | Ingress path                                                                                                                                                                                          | `/`                                                        |
| `ingress.hostName`                                  | Ingress hostname                                                                                                                                                                                      |                                                            |
| `ingress.tls`                                       | Enable Ingress TLS                                                                                                                                                                                    | `false`                                                    |
| `ingress.tlsSecret`                                 | Ingress TLS secret name                                                                                                                                                                               | `myTlsSecret`                                              |
| `ingress.annotations`                               | Ingress annotations                                                                                                                                                                                   | `{}`                                                       |
| `tolerations`                                       | Toleration labels for pod assignment                                                                                                                                                                  | `[]`                                                       |
| `podAnnotations`                                    | Extra annotations to add to pod                                                                                                                                                                       | `{}`                                                       |
| `statefulSetAnnotations`                            | Extra annotations to add the statefulSet                                                                                                                                                              | `{}`                                                       |
| `terminationGracePeriodSeconds`                     | Duration pod needs to terminate gracefully                                                                                                                                                            | `10`                                                       |
| `updateStrategy`                                    | Statefulset update strategy                                                                                                                                                                           | `OnDelete`                                                 |
| `priorityClassName`                                 | Statefulsets Pod Priority                                                                                                                                                                             | ``                                                         |
| `extraLabels`                                       | Labels to add to the Resources                                                                                                                                                                        | `{}`                                                       |
| `busyboxImage.repository`                           | Busybox initContainer image repo                                                                                                                                                                      | `busybox`                                                  |
| `busyboxImage.tag`                                  | Busybox initContainer image tag                                                                                                                                                                       | `1.30.1`                                                   |
| `busyboxImage.pullPolicy`                           | Busybox initContainer image pullPolicy                                                                                                                                                                | `IfNotPresent`                                             |
| `clusterDomain`                                     | The internal Kubernetes cluster domain                                                                                                                                                                | `cluster.local`                                            |
Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set rabbitmqUsername=admin,rabbitmqPassword=secretpassword,managementPassword=anothersecretpassword,rabbitmqErlangCookie=secretcookie \
    stable/rabbitmq-ha
```

The above command sets the RabbitMQ admin username and password to `admin` and
`secretpassword` respectively. Additionally the management user password is set
to `anothersecretpassword` and the secure erlang cookie is set to
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

* `rabbitmq-username`
* `rabbitmq-password`
* `rabbitmq-management-username`
* `rabbitmq-management-password`
* `rabbitmq-erlang-cookie`
* `definitions.json` (the name can be altered by setting the `definitionsSource`)

### Prometheus Monitoring & Alerts

As of RabbitMQ 3.8.0, it is possible to enable Prometheus metrics natively, no need to run an external exporter. To enable native Prometheus metrics, set `rabbitmqPrometheusPlugin.enabled` to `true`. This will expose all RabbitMQ node metrics via the `<<rabbitmqhost>>:15692/metrics` URL. Since all metrics are node local, they add the least pressure on RabbitMQ and will be available for as long as RabbitMQ is running, regardless of inter-node pressure or other nodes in the cluster going away.

To learn more about RabbitMQ's native support for Prometheus, please refer to the official [Monitoring with Prometheus & Grafana guide](https://www.rabbitmq.com/prometheus.html).

Team RabbitMQ manages Grafana dashboards that are meant to be used with the native Prometheus support. They are publicly available at [grafana.com/orgs/rabbitmq](https://grafana.com/orgs/rabbitmq).

To enable metrics via the traditional [rabbitmq_exporter](https://github.com/kbudde/rabbitmq_exporter) sidecar container, set `prometheus.enabled` to `true`. See `values.yaml` file for more details and configuration options.

### Usage of the `tpl` Function

The `tpl` function allows us to pass values from `values.yaml` through the templating engine. It is used for the following values:

* `extraContainers`
* `extraInitContainers`
* `persistentVolume.annotations`
* `persistentVolume.labels`
* `service.annotations`
