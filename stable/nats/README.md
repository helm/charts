# NATS

[NATS](https://nats.io/) is an open-source, cloud-native messaging system. It provides a lightweight server that is written in the Go programming language.

## This Helm chart is deprecated

Given the [`stable` deprecation timeline](https://github.com/helm/charts#deprecation-timeline), the Bitnami maintained Nats Helm chart is now located at [bitnami/charts](https://github.com/bitnami/charts/).

The Bitnami repository is already included in the Hubs and we will continue providing the same cadence of updates, support, etc that we've been keeping here these years. Installation instructions are very similar, just adding the _bitnami_ repo and using it during the installation (`bitnami/<chart>` instead of `stable/<chart>`)

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/<chart>           # Helm 3
$ helm install --name my-release bitnami/<chart>    # Helm 2
```

To update an exisiting _stable_ deployment with a chart hosted in the bitnami repository you can execute

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm upgrade my-release bitnami/<chart>
```

Issues and PRs related to the chart itself will be redirected to `bitnami/charts` GitHub repository. In the same way, we'll be happy to answer questions related to this migration process in [this issue](https://github.com/helm/charts/issues/20969) created as a common place for discussion.

## TL;DR;

```bash
$ helm install my-release stable/nats
```

## Introduction

This chart bootstraps a [NATS](https://github.com/bitnami/bitnami-docker-nats) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release stable/nats
```

The command deploys NATS on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the NATS chart and their default values.

| Parameter                            | Description                                                                                  | Default                                                       |
| ------------------------------------ | -------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| `global.imageRegistry`               | Global Docker image registry                                                                 | `nil`                                                         |
| `global.imagePullSecrets`            | Global Docker registry secret names as an array                                              | `[]` (does not add image pull secrets to deployed pods)       |
| `image.registry`                     | NATS image registry                                                                          | `docker.io`                                                   |
| `image.repository`                   | NATS Image name                                                                              | `bitnami/nats`                                                |
| `image.tag`                          | NATS Image tag                                                                               | `{TAG_NAME}`                                                  |
| `image.pullPolicy`                   | Image pull policy                                                                            | `IfNotPresent`                                                |
| `image.pullSecrets`                  | Specify docker-registry secret names as an array                                             | `[]` (does not add image pull secrets to deployed pods)       |
| `nameOverride`                       | String to partially override nats.fullname template with a string (will prepend the release name) | `nil`                                                    |
| `fullnameOverride`                   | String to fully override nats.fullname template with a string                                | `nil`                                                         |
| `auth.enabled`                       | Switch to enable/disable client authentication                                               | `true`                                                        |
| `auth.user`                          | Client authentication user                                                                   | `nats_client`                                                |
| `auth.password`                      | Client authentication password                                                               | `random alhpanumeric string (10)`                             |
| `auth.token`                         | Client authentication token                                                                  | `nil`                                                         |
| `clusterAuth.enabled`                | Switch to enable/disable cluster authentication                                              | `true`                                                        |
| `clusterAuth.user`                   | Cluster authentication user                                                                  | `nats_cluster`                                                |
| `clusterAuth.password`               | Cluster authentication password                                                              | `random alhpanumeric string (10)`                             |
| `clusterAuth.token`                  | Cluster authentication token                                                                 | `nil`                                                         |
| `debug.enabled`                      | Switch to enable/disable debug on logging                                                    | `false`                                                       |
| `debug.trace`                        | Switch to enable/disable trace debug level on logging                                        | `false`                                                       |
| `debug.logtime`                      | Switch to enable/disable logtime on logging                                                  | `false`                                                       |
| `maxConnections`                     | Max. number of client connections                                                            | `nil`                                                         |
| `maxControlLine`                     | Max. protocol control line                                                                   | `nil`                                                         |
| `maxPayload`                         | Max. payload                                                                                 | `nil`                                                         |
| `writeDeadline`                      | Duration the server can block on a socket write to a client                                  | `nil`                                                         |
| `replicaCount`                       | Number of NATS nodes                                                                         | `1`                                                           |
| `resourceType`                       | NATS cluster resource type under Kubernetes (Supported: StatefulSets, or Deployment)         | `statefulset`                                                 |
| `securityContext.enabled`            | Enable security context                                                                      | `true`                                                        |
| `securityContext.fsGroup`            | Group ID for the container                                                                   | `1001`                                                        |
| `securityContext.runAsUser`          | User ID for the container                                                                    | `1001`                                                        |
| `statefulset.updateStrategy`         | Statefulsets Update strategy                                                                 | `OnDelete`                                                    |
| `statefulset.rollingUpdatePartition` | Partition for Rolling Update strategy                                                        | `nil`                                                         |
| `podLabels`                          | Additional labels to be added to pods                                                        | {}                                                            |
| `priorityClassName`                  | Name of pod priority class                                                                   | `nil`                                                         |
| `podAnnotations`                     | Annotations to be added to pods                                                              | {}                                                            |
| `nodeSelector`                       | Node labels for pod assignment                                                               | `nil`                                                         |
| `schedulerName`                      | Name of an alternate                                                                         | `nil`                                                         |
| `antiAffinity`                       | Anti-affinity for pod assignment                                                             | `soft`                                                        |
| `tolerations`                        | Toleration labels for pod assignment                                                         | `nil`                                                         |
| `resources`                          | CPU/Memory resource requests/limits                                                          | {}                                                            |
| `extraArgs`                          | Optional flags for NATS                                                                      | `[]`                                                          |
| `natsFilename`                       | Filename used by several NATS files (binary, configurarion file, and pid file)               | `nats-server`                                                 |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                     | `30`                                                          |
| `livenessProbe.periodSeconds`        | How often to perform the probe                                                               | `10`                                                          |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                                                     | `5`                                                           |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed. | `1`                                                           |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | `6`                                                           |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                                                    | `5`                                                           |
| `readinessProbe.periodSeconds`       | How often to perform the probe                                                               | `10`                                                          |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                                                     | `5`                                                           |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | `6`                                                           |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed. | `1`                                                           |
| `client.service.type`                | Kubernetes Service type (NATS client)                                                        | `ClusterIP`                                                   |
| `client.service.port`                | NATS client port                                                                             | `4222`                                                        |
| `client.service.nodePort`            | Port to bind to for NodePort service type (NATS client)                                      | `nil`                                                         |
| `client.service.annotations`         | Annotations for NATS client service                                                          | {}                                                            |
| `client.service.loadBalancerIP`      | loadBalancerIP if NATS client service type is `LoadBalancer`                                 | `nil`                                                         |
| `cluster.service.type`               | Kubernetes Service type (NATS cluster)                                                       | `ClusterIP`                                                   |
| `cluster.service.port`               | NATS cluster port                                                                            | `6222`                                                        |
| `cluster.service.nodePort`           | Port to bind to for NodePort service type (NATS cluster)                                     | `nil`                                                         |
| `cluster.service.annotations`        | Annotations for NATS cluster service                                                         | {}                                                            |
| `cluster.service.loadBalancerIP`     | loadBalancerIP if NATS cluster service type is `LoadBalancer`                                | `nil`                                                         |
| `cluster.connectRetries`             | Configure number of connect retries for implicit routes                                      | `nil`                                                         |
| `monitoring.service.type`            | Kubernetes Service type (NATS monitoring)                                                    | `ClusterIP`                                                   |
| `monitoring.service.port`            | NATS monitoring port                                                                         | `8222`                                                        |
| `monitoring.service.nodePort`        | Port to bind to for NodePort service type (NATS monitoring)                                  | `nil`                                                         |
| `monitoring.service.annotations`     | Annotations for NATS monitoring service                                                      | {}                                                            |
| `monitoring.service.loadBalancerIP`  | loadBalancerIP if NATS monitoring service type is `LoadBalancer`                             | `nil`                                                         |
| `ingress.enabled`                    | Enable ingress controller resource                                                           | `false`                                                       |
| `ingress.hosts[0].name`              | Hostname for NATS monitoring                                                                 | `nats.local`                                                  |
| `ingress.hosts[0].path`              | Path within the url structure                                                                | `/`                                                           |
| `ingress.hosts[0].tls`               | Utilize TLS backend in ingress                                                               | `false`                                                       |
| `ingress.hosts[0].tlsSecret`         | TLS Secret (certificates)                                                                    | `nats.local-tls-secret`                                       |
| `ingress.hosts[0].annotations`       | Annotations for this host's ingress record                                                   | `[]`                                                          |
| `ingress.secrets[0].name`            | TLS Secret Name                                                                              | `nil`                                                         |
| `ingress.secrets[0].certificate`     | TLS Secret Certificate                                                                       | `nil`                                                         |
| `ingress.secrets[0].key`             | TLS Secret Key                                                                               | `nil`                                                         |
| `networkPolicy.enabled`              | Enable NetworkPolicy                                                                         | `false`                                                       |
| `networkPolicy.allowExternal`        | Allow external connections                                                                   | `true`                                                        |
| `metrics.enabled`                    | Enable Prometheus metrics via exporter side-car                                              | `false`                                                       |
| `metrics.image.registry`             | Prometheus metrics exporter image registry                                                   | `docker.io`                                                   |
| `metrics.image.repository`           | Prometheus metrics exporter image name                                                       | `bitnami/nats-exporter`                                       |
| `metrics.image.tag`                  | Prometheus metrics exporter image tag                                                        | `{TAG_NAME}`                                                  |
| `metrics.image.pullPolicy`           | Prometheus metrics image pull policy                                                         | `IfNotPresent`                                                |
| `metrics.image.pullSecrets`          | Prometheus metrics image pull secrets                                                        | `[]` (does not add image pull secrets to deployed pods)       |
| `metrics.port`                       | Prometheus metrics exporter port                                                             | `7777`                                                        |
| `metrics.podAnnotations`             | Prometheus metrics exporter annotations                                                      | `prometheus.io/scrape: "true"`,  `prometheus.io/port: "7777"` |
| `metrics.resources`                  | Prometheus metrics exporter resource requests/limit                                          | {}                                                            |
| `sidecars`                           | Attach additional containers to the pod                                                      | `nil`                                                         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set auth.enabled=true,auth.user=my-user,auth.password=T0pS3cr3t \
    stable/nats
```

The above command enables NATS client authentication with `my-user` as user and `T0pS3cr3t` as password credentials.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml stable/nats
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration and horizontal scaling

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Number of NATS nodes
```diff
- replicaCount: 1
+ replicaCount: 3
```

- Enable and set the max. number of client connections, protocol control line, payload and duration the server can block on a socket write to a client
```diff
- # maxConnections: 100
- # maxControlLine: 512
- # maxPayload: 65536
- # writeDeadline: "2s"
+ maxConnections: 100
+ maxControlLine: 512
+ maxPayload: 65536
+ writeDeadline: "2s"
```

- Enable NetworkPolicy:
```diff
- networkPolicy.enabled: false
+ networkPolicy.enabled: true
```

- Allow external connections:
```diff
- networkPolicy.allowExternal: true
+ networkPolicy.allowExternal: false
```

- Enable ingress controller resource:
```diff
- ingress.enabled: false
+ ingress.enabled: true
```

- Enable Prometheus metrics via exporter side-car:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

To horizontally scale this chart, you can use the `--replicas` flag to modify the number of nodes in your NATS replica set.

### Sidecars

If you have a need for additional containers to run within the same pod as NATS (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
   containerPort: 1234
```

## Upgrading

## Deploy chart with NATS version 1.x.x

NATS version 2.0.0 has renamed the server binary filename from `gnatsd` to `nats-server`. Therefore, the default values has been changed in the chart,
however, it is still possible to use the chart to deploy NATS version 1.x.x using the `natsFilename` property.

```bash
helm install nats-v1 --set natsFilename=gnatsd --set image.tag=1.4.1 stable/nats
```

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is nats:

```console
$ kubectl delete statefulset nats-nats --cascade=false
```
