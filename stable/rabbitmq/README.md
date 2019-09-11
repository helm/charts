# RabbitMQ

[RabbitMQ](https://www.rabbitmq.com/) is an open source message broker software that implements the Advanced Message Queuing Protocol (AMQP).

## TL;DR;

```bash
$ helm install stable/rabbitmq
```

## Introduction

This chart bootstraps a [RabbitMQ](https://github.com/bitnami/bitnami-docker-rabbitmq) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

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

| Parameter                            | Description                                      | Default                                                 |
| ------------------------------------ | ------------------------------------------------ | ------------------------------------------------------- |
| `global.imageRegistry`               | Global Docker image registry                     | `nil`                                                   |
| `global.imagePullSecrets`            | Global Docker registry secret names as an array  | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                     | Global storage class for dynamic provisioning                                               | `nil`                                                        |
| `image.registry`                     | Rabbitmq Image registry                          | `docker.io`                                             |
| `image.repository`                   | Rabbitmq Image name                              | `bitnami/rabbitmq`                                      |
| `image.tag`                          | Rabbitmq Image tag                               | `{TAG_NAME}`                                            |
| `image.pullPolicy`                   | Image pull policy                                | `IfNotPresent`                                          |
| `image.pullSecrets`                  | Specify docker-registry secret names as an array | `nil`                                                   |
| `image.debug`                        | Specify if debug values should be set            | `false`                                                 |
| `nameOverride`                       | String to partially override rabbitmq.fullname template with a string (will prepend the release name) | `nil` |
| `fullnameOverride`                   | String to fully override rabbitmq.fullname template with a string                                     | `nil` |
| `rbacEnabled`                        | Specify if rbac is enabled in your cluster       | `true`                                                  |
| `podManagementPolicy`                | Pod management policy                            | `OrderedReady`                                          |
| `rabbitmq.username`                  | RabbitMQ application username                    | `user`                                                  |
| `rabbitmq.password`                  | RabbitMQ application password                    | _random 10 character long alphanumeric string_          |
| `rabbitmq.existingPasswordSecret`    | Existing secret with RabbitMQ credentials        | `nil`                                                   |
| `rabbitmq.erlangCookie`              | Erlang cookie                                    | _random 32 character long alphanumeric string_          |
| `rabbitmq.existingErlangSecret`      | Existing secret with RabbitMQ Erlang cookie      | `nil`                                                   |
| `rabbitmq.plugins`                   | List of plugins to enable                        | `rabbitmq_management rabbitmq_peer_discovery_k8s`       |
| `rabbitmq.extraPlugins`              | Extra plugings to enable                         | `nil`                                                   |
| `rabbitmq.clustering.address_type`   | Switch clustering mode                           | `ip` or `hostname`                                      |
| `rabbitmq.clustering.k8s_domain`     | Customize internal k8s cluster domain            | `cluster.local`                                         |
| `rabbitmq.logs`                      | Value for the RABBITMQ_LOGS environment variable | `-`                                                     |
| `rabbitmq.setUlimitNofiles`          | Specify if max file descriptor limit should be set | `true`                                                |
| `rabbitmq.ulimitNofiles`             | Max File Descriptor limit                        | `65536`                                                 |
| `rabbitmq.maxAvailableSchedulers`    | RabbitMQ maximum available scheduler threads     | `2`                                                     |
| `rabbitmq.onlineSchedulers`          | RabbitMQ online scheduler threads                | `1`                                                     |
| `rabbitmq.env`                       | RabbitMQ [environment variables](https://www.rabbitmq.com/configure.html#customise-environment) | `{}`     |
| `rabbitmq.configuration`             | Required cluster configuration                   | See values.yaml                                         |
| `rabbitmq.extraConfiguration`        | Extra configuration to add to rabbitmq.conf      | See values.yaml                                         |
| `rabbitmq.advancedConfiguration`     | Extra configuration (in classic format) to add to advanced.config    | See values.yaml                                         |
| `service.type`                       | Kubernetes Service type                          | `ClusterIP`                                             |
| `service.port`                       | Amqp port                                        | `5672`                                                  |
| `service.distPort`                   | Erlang distribution server port                  | `25672`                                                 |
| `service.nodePort`                   | Node port override, if serviceType NodePort      | _random available between 30000-32767_                  |
| `service.managerPort`                | RabbitMQ Manager port                            | `15672`                                                 |
| `persistence.enabled`                | Use a PVC to persist data                        | `true`                                                  |
| `service.annotations`                | service annotations as an array                  | []                                                      |
| `schedulerName`                      | Name of the k8s service (other than default)     | `nil`                                                   |
| `persistence.storageClass`           | Storage class of backing PVC                     | `nil` (uses alpha storage class annotation)             |
| `persistence.existingClaim`          | RabbitMQ data Persistent Volume existing claim name, evaluated as a template |  ""          |
| `persistence.accessMode`             | Use volume as ReadOnly or ReadWrite              | `ReadWriteOnce`                                         |
| `persistence.size`                   | Size of data volume                              | `8Gi`                                                   |
| `persistence.path`                   | Mount path of the data volume                    | `/opt/bitnami/rabbitmq/var/lib/rabbitmq`                |
| `securityContext.enabled`            | Enable security context                          | `true`                                                  |
| `securityContext.fsGroup`            | Group ID for the container                       | `1001`                                                  |
| `securityContext.runAsUser`          | User ID for the container                        | `1001`                                                  |
| `resources`                          | resource needs and limits to apply to the pod    | {}                                                      |
| `replicas`                           | Replica count                                    | `1`                                                     |
| `priorityClassName`                  | Pod priority class name                          | ``                                                      |
| `nodeSelector`                       | Node labels for pod assignment                   | {}                                                      |
| `affinity`                           | Affinity settings for pod assignment             | {}                                                      |
| `tolerations`                        | Toleration labels for pod assignment             | []                                                      |
| `updateStrategy`                     | Statefulset update strategy policy               | `RollingUpdate`                                         |
| `ingress.enabled`                    | Enable ingress resource for Management console   | `false`                                                 |
| `ingress.hostName`                   | Hostname to your RabbitMQ installation           | `nil`                                                   |
| `ingress.path`                       | Path within the url structure                    | `/`                                                     |
| `ingress.tls`                        | enable ingress with tls                          | `false`                                                 |
| `ingress.tlsSecret`                  | tls type secret to be used                       | `myTlsSecret`                                           |
| `ingress.annotations`                | ingress annotations as an array                  | []                                                      |
| `livenessProbe.enabled`              | would you like a livenessProbed to be enabled    | `true`                                                  |
| `livenessProbe.initialDelaySeconds`  | number of seconds                                | 120                                                     |
| `livenessProbe.timeoutSeconds`       | number of seconds                                | 20                                                      |
| `livenessProbe.periodSeconds`        | number of seconds                                | 30                                                      |
| `livenessProbe.failureThreshold`     | number of failures                               | 6                                                       |
| `livenessProbe.successThreshold`     | number of successes                              | 1                                                       |
| `readinessProbe.enabled`             | would you like a readinessProbe to be enabled    | `true`                                                  |
| `readinessProbe.initialDelaySeconds` | number of seconds                                | 10                                                      |
| `readinessProbe.timeoutSeconds`      | number of seconds                                | 20                                                      |
| `readinessProbe.periodSeconds`       | number of seconds                                | 30                                                      |
| `readinessProbe.failureThreshold`    | number of failures                               | 3                                                       |
| `readinessProbe.successThreshold`    | number of successes                              | 1                                                       |
| `metrics.enabled`                    | Start a side-car prometheus exporter             | `false`                                                 |
| `metrics.image.registry`             | Exporter image registry                          | `docker.io`                                             |
| `metrics.image.repository`           | Exporter image name                              | `bitnami/rabbitmq-exporter`                             |
| `metrics.image.tag`                  | Exporter image tag                               | `{TAG_NAME}`                                            |
| `metrics.image.pullPolicy`           | Exporter image pull policy                       | `IfNotPresent`                                          |
| `metrics.serviceMonitor.enabled`     | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator   | `false`                   |
| `metrics.serviceMonitor.namespace`   | Namespace where servicemonitor resource should be created                      | `nil`                     |
| `metrics.serviceMonitor.interval`    | Specify the interval at which metrics should be scraped                        | `30s`                     |
| `metrics.serviceMonitor.scrapeTimeout`| Specify the timeout after which the scrape is ended                           | `nil`                     |
| `metrics.serviceMonitor.relabellings`| Specify Metric Relabellings to add to the scrape endpoint                      | `nil`                     |
| `metrics.serviceMonitor.honorLabels` | honorLabels chooses the metric's labels on collisions with target labels.      | `false`                   |
| `metrics.serviceMonitor.additionalLabels`| Used to pass Labels that are required by the Installed Prometheus Operator | `{}`                      |
| `metrics.port`                       | Prometheus metrics exporter port                 | `9419`                                                  |
| `metrics.env`                        | Exporter [configuration environment variables](https://github.com/kbudde/rabbitmq_exporter#configuration) | `{}` |
| `metrics.resources`                  | Exporter resource requests/limit                 | `nil`                                                   |
| `metrics.capabilities`               | Exporter: Comma-separated list of extended [scraping capabilities supported by the target RabbitMQ server](https://github.com/kbudde/rabbitmq_exporter#extended-rabbitmq-capabilities) | `bert,no_sort` |
| `podLabels`                          | Additional labels for the statefulset pod(s).    | {}                                                      |
| `volumePermissions.enabled`         | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work)                                                               | `false`                                          |
| `volumePermissions.image.registry`         | Init container volume-permissions image registry                                                               | `docker.io`                                          |
| `volumePermissions.image.repository`       | Init container volume-permissions image name                                                                   | `bitnami/minideb`                                    |
| `volumePermissions.image.tag`              | Init container volume-permissions image tag                                                                    | `stretch`                                             |
| `volumePermissions.image.pullPolicy`       | Init container volume-permissions image pull policy                                                            | `Always`                                             |
| `volumePermissions.resources`                  | Init container resource requests/limit                 | `nil`                                                   |
| `forceBoot.enabled`         | Executes 'rabbitmqctl force_boot' to force boot cluster shut down unexpectedly in an unknown order. Use it only if you prefer availability over integrity.                                                               | `false`                                          |

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

### Production configuration and horizontal scaling

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`.

```console
$ helm install --name my-release -f ./values-production.yaml stable/rabbitmq
```

- Resource needs and limits to apply to the pod:
```diff
- resources: {}
+ resources:
+   requests:
+     memory: 256Mi
+     cpu: 100m
```

- Replica count:
```diff
- replicas: 1
+ replicas: 3
```

- Node labels for pod assignment:
```diff
- nodeSelector: {}
+ nodeSelector:
+   beta.kubernetes.io/arch: amd64
```

- Enable ingress with TLS:
```diff
- ingress.tls: false
+ ingress.tls: true
```

- Start a side-car prometheus exporter:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

- Enable init container that changes volume permissions in the data directory:
```diff
- volumePermissions.enabled: false
+ volumePermissions.enabled: true
```

To horizontally scale this chart once it has been deployed you have two options:

- Use `kubectl scale` command:

```console
$ kubectl scale statefulset my-release-rabbitmq --replicas=3
```

- Use `helm upgrade` command:

```console
RABBITMQ_PASSWORD="$(kubectl get secret my-release-rabbitmq -o jsonpath='{.data.rabbitmq-password}' | base64 --decode)"
RABBITMQ_ERLANG_COOKIE="$(kubectl get secret my-release-rabbitmq -o jsonpath='{.data.rabbitmq-erlang-cookie}' | base64 --decode)"
$ helm upgrade my-release stable/rabbitmq \
  --set replicas=3 \
  --set rabbitmq.password="$RABBITMQ_PASSWORD" \
  --set rabbitmq.erlangCookie="$RABBITMQ_ERLANG_COOKIE"
```

> Note: please note it's mandatory to indicate the password and erlangCookie that was set the first time the chart was installed to upgrade the chart. Otherwise, new pods won't be able to join the cluster.

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Load Definitions
It is possible to [load a RabbitMQ definitions file to configure RabbitMQ](http://www.rabbitmq.com/management.html#load-definitions). Because definitions may contain RabbitMQ credentials, [store the JSON as a Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-files-from-a-pod). Within the secret's data, choose a key name that corresponds with the desired load definitions filename (i.e. `load_definition.json`) and use the JSON object as the value. For example:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: rabbitmq-load-definition
type: Opaque
stringData:
  load_definition.json: |-
    {
      "vhosts": [
        {
          "name": "/"
        }
      ]
    }
```

Then, specify the `management.load_definitions` property as an `extraConfiguration` pointing to the load definition file path within the container (i.e. `/app/load_definition.json`) and set `loadDefinition.enable` to `true`.

Any load definitions specified will be available within in the container at `/app`.

> Loading a definition will take precedence over any configuration done through [Helm values](#configuration).

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

### To 6.0.0

This new version updates the RabbitMQ image to a [new version based on bash instead of node.js](https://github.com/bitnami/bitnami-docker-rabbitmq#3715-r18-3715-ol-7-r19). However, since this Chart overwrites the container's command, the changes to the container shouldn't affect the Chart. To upgrade, it may be needed to enable the `fastBoot` option, as it is already the case from upgrading from 5.X to 5.Y.  

### To 5.0.0

This major release changes the clustering method from `ip` to `hostname`.
This change is needed to fix the persistence. The data dir will now depend on the hostname which is stable instead of the pod IP that might change.

> IMPORTANT: Note that if you upgrade from a previous version you will lose your data.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is rabbitmq:

```console
$ kubectl delete statefulset rabbitmq --cascade=false
```
