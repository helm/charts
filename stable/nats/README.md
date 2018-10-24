# NATS

[NATS](https://nats.io/) is an open-source, cloud-native messaging system. It provides a lightweight server that is written in the Go programming language.

## TL;DR

```bash
$ helm install stable/nats
```

## Introduction

This chart bootstraps a [NATS](https://github.com/bitnami/bitnami-docker-nats) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/nats
```

The command deploys NATS on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the NATS chart and their default values.

| Parameter                            | Description                                                                                  | Default                           |
|--------------------------------------|----------------------------------------------------------------------------------------------|-----------------------------------|
| `global.imageRegistry`               | Global Docker image registry                                                                 | `nil`                             |
| `image.registry`                     | NATS image registry                                                                          | `docker.io`                       |
| `image.repository`                   | NATS Image name                                                                              | `bitnami/nats`                    |
| `image.tag`                          | NATS Image tag                                                                               | `{VERSION}`                       |
| `image.pullPolicy`                   | Image pull policy                                                                            | `Always`                          |
| `image.pullSecrets`                  | Specify image pull secrets                                                                   | `nil`                             |
| `auth.enabled`                       | Switch to enable/disable client authentication                                               | `true`                            |
| `auth.user`                          | Client authentication user                                                                   | `nats_cluster`                    |
| `auth.password`                      | Client authentication password                                                               | `random alhpanumeric string (10)` |
| `auth.token`                         | Client authentication token                                                                  | `nil`                             |
| `clusterAuth.enabled`                | Switch to enable/disable cluster authentication                                              | `true`                            |
| `clusterAuth.user`                   | Cluster authentication user                                                                  | `nats_cluster`                    |
| `clusterAuth.password`               | Cluster authentication password                                                              | `random alhpanumeric string (10)` |
| `clusterAuth.token`                  | Cluster authentication token                                                                 | `nil`                             |
| `debug.enabled`                      | Switch to enable/disable debug on logging                                                    | `false`                           |
| `debug.trace`                        | Switch to enable/disable trace debug level on logging                                        | `false`                           |
| `debug.logtime`                      | Switch to enable/disable logtime on logging                                                  | `false`                           |
| `maxConnections`                     | Max. number of client connections                                                            | `nil`                             |
| `maxControlLine`                     | Max. protocol control line                                                                   | `nil`                             |
| `maxPayload`                         | Max. payload                                                                                 | `nil`                             |
| `writeDeadline`                      | Duration the server can block on a socket write to a client                                  | `nil`                             |
| `replicaCount`                       | Number of NATS nodes                                                                         | `1`                               |
| `securityContext.enabled`            | Enable security context                                                                      | `true`                            |
| `securityContext.fsGroup`            | Group ID for the container                                                                   | `1001`                            |
| `securityContext.runAsUser`          | User ID for the container                                                                    | `1001`                            |
| `statefulset.updateStrategy`         | Statefulsets Update strategy                                                                | `OnDelete`                        |
| `rollingUpdatePartition`             | Partition for Rolling Update strategy                                                        | `nil`                             |
| `podLabels`                          | Additional labels to be added to pods                                                        | {}                                |
| `podAnnotations`                     | Annotations to be added to pods                                                              | {}                                |
| `nodeSelector`                       | Node labels for pod assignment                                                               | `nil`                             |
| `schedulerName`                      | Name of an alternate                                                                         | `nil`                             |
| `antiAffinity`                       | Anti-affinity for pod assignment                                                             | `soft`                            |
| `tolerations`                        | Toleration labels for pod assignment                                                         | `nil`                             |
| `resources`                          | CPU/Memory resource requests/limits                                                          | {}                                |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                     | `30`                              |
| `livenessProbe.periodSeconds`        | How often to perform the probe                                                               | `10`                              |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                                                     | `5`                               |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed. | `1`                               |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | `6`                               |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                                                    | `5`                               |
| `readinessProbe.periodSeconds`       | How often to perform the probe                                                               | `10`                              |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                                                     | `5`                               |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | `6`                               |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed. | `1`                               |
| `clientService.type`                 | Kubernetes Service type (NATS client)                                                        | `ClusterIP`                       |
| `clientService.port`                 | NATS client port                                                                             | `4222`                            |
| `clientService.nodePort`             | Port to bind to for NodePort service type (NATS client)                                      | `nil`                             |
| `clientService.annotations`          | Annotations for NATS client service                                                          | {}                                |
| `clientService.loadBalancerIP`       | loadBalancerIP if NATS client service type is `LoadBalancer`                                 | `nil`                             |
| `clusterService.type`                | Kubernetes Service type (NATS cluster)                                                       | `ClusterIP`                       |
| `clusterService.port`                | NATS cluster port                                                                            | `6222`                            |
| `clusterService.nodePort`            | Port to bind to for NodePort service type (NATS cluster)                                     | `nil`                             |
| `clusterService.annotations`         | Annotations for NATS cluster service                                                         | {}                                |
| `clusterService.loadBalancerIP`      | loadBalancerIP if NATS cluster service type is `LoadBalancer`                                | `nil`                             |
| `monitoringService.type`             | Kubernetes Service type (NATS monitoring)                                                    | `ClusterIP`                       |
| `monitoringService.port`             | NATS monitoring port                                                                         | `8222`                            |
| `monitoringService.nodePort`         | Port to bind to for NodePort service type (NATS monitoring)                                  | `nil`                             |
| `monitoringService.annotations`      | Annotations for NATS monitoring service                                                      | {}                                |
| `monitoringService.loadBalancerIP`   | loadBalancerIP if NATS monitoring service type is `LoadBalancer`                             | `nil`                             |
| `ingress.enabled`                    | Enable ingress controller resource                                                           | `false`                           |
| `ingress.hosts[0].name`              | Hostname for NATS monitoring                                                                 | `nats.local`                      |
| `ingress.hosts[0].path`              | Path within the url structure                                                                | `/`                               |
| `ingress.hosts[0].tls`               | Utilize TLS backend in ingress                                                               | `false`                           |
| `ingress.hosts[0].tlsSecret`         | TLS Secret (certificates)                                                                    | `nats.local-tls-secret`           |
| `ingress.hosts[0].annotations`       | Annotations for this host's ingress record                                                   | `[]`                              |
| `ingress.secrets[0].name`            | TLS Secret Name                                                                              | `nil`                             |
| `ingress.secrets[0].certificate`     | TLS Secret Certificate                                                                       | `nil`                             |
| `ingress.secrets[0].key`             | TLS Secret Key                                                                               | `nil`                             |
| `networkPolicy.enabled`              | Enable NetworkPolicy                                                                         | `false`                           |
| `networkPolicy.allowExternal`        | Allow external connections                                                                   | `true`                            |
| `sidecars`                           | Attach additional containers to the pod.                                                     | `nil`                             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,


```bash
$ helm install --name my-release \
  --set auth.enabled=true,auth.user=my-user,auth.password=T0pS3cr3t \
    stable/nats
```

The above command enables NATS client authentication with `my-user` as user and `T0pS3cr3t` as password credentials.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/nats
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Sidecars

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

## Production settings and horizontal scaling

The [values-production.yaml](values-production.yaml) file consists a configuration to deploy a scalable and high-available NATS deployment for production environments. We recommend that you base your production configuration on this template and adjust the parameters appropriately.

```console
$ curl -O https://raw.githubusercontent.com/kubernetes/charts/master/stable/nats/values-production.yaml
$ helm install --name my-release -f ./values-production.yaml stable/nats
```

To horizontally scale this chart, run the following command to scale the number of nodes in your NATS replica set.

```console
$ kubectl scale statefulset my-release-nats --replicas=3
```

## Upgrading

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 1.0.0. The following example assumes that the release name is nats:

```console
$ kubectl delete statefulset nats-nats --cascade=false
```
