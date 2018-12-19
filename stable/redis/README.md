# Redis

[Redis](http://redis.io/) is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

## TL;DR

```bash
# Testing configuration
$ helm install stable/redis
```

```bash
# Production configuration
$ helm install stable/redis --values values-production.yaml
```

## Introduction

This chart bootstraps a [Redis](https://github.com/bitnami/bitnami-docker-redis) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.8+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/redis
```

The command deploys Redis on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Upgrading an existing Release to a new major version

A major chart version change (like v1.2.3 -> v2.0.0) indicates that there is an
incompatible breaking change needing manual actions.

### 5.0.0

The default image in this release may be switched out for any image containing the `redis-server`
and `redis-cli` binaries. If `redis-server` is not the default image ENTRYPOINT, `master.command`
must be specified.

#### Breaking changes
- `master.args` and `slave.args` are removed. Use `master.command` or `slave.command` instead in order to override the image entrypoint, or `master.extraFlags` to pass additional flags to `redis-server`.
- `disableCommands` is now interpreted as an array of strings instead of a string of comma separated values.
- `master.persistence.path` now defaults to `/data`.

### 4.0.0

This version removes the `chart` label from the `spec.selector.matchLabels`
which is immutable since `StatefulSet apps/v1beta2`. It has been inadvertently
added, causing any subsequent upgrade to fail. See https://github.com/helm/charts/issues/7726.

It also fixes https://github.com/helm/charts/issues/7726 where a deployment `extensions/v1beta1` can not be upgraded if `spec.selector` is not explicitly set.

Finally, it fixes https://github.com/helm/charts/issues/7803 by removing mutable labels in `spec.VolumeClaimTemplate.metadata.labels` so that it is upgradable.

In order to upgrade, delete the Redis StatefulSet before upgrading:
```bash
$ kubectl delete statefulsets.apps --cascade=false my-release-redis-master
```
And edit the Redis slave (and metrics if enabled) deployment:
```bash
kubectl patch deployments my-release-redis-slave --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
kubectl patch deployments my-release-redis-metrics --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```

## Configuration

The following table lists the configurable parameters of the Redis chart and their default values.

| Parameter                                  | Description                                                                                                    | Default                                              |
|--------------------------------------------|----------------------------------------------------------------------------------------------------------------|------------------------------------------------------|
| `global.imageRegistry`                     | Global Docker image registry                                                                                   | `nil`                                                |
| `image.registry`                           | Redis Image registry                                                                                           | `docker.io`                                          |
| `image.repository`                         | Redis Image name                                                                                               | `bitnami/redis`                                      |
| `image.tag`                                | Redis Image tag                                                                                                | `{VERSION}`                                          |
| `image.pullPolicy`                         | Image pull policy                                                                                              | `Always`                                             |
| `image.pullSecrets`                        | Specify docker-registry secret names as an array                                                               | `nil`                                                |
| `cluster.enabled`                          | Use master-slave topology                                                                                      | `true`                                               |
| `cluster.slaveCount`                       | Number of slaves                                                                                               | `1`                                                  |
| `existingSecret`                           | Name of existing secret object (for password authentication)                                                   | `nil`                                                |
| `usePassword`                              | Use password                                                                                                   | `true`                                               |
| `password`                                 | Redis password (ignored if existingSecret set)                                                                 | Randomly generated                                   |
| `configmap`                                | Redis configuration file to be used                                                                            | `nil`                                                |
| `networkPolicy.enabled`                    | Enable NetworkPolicy                                                                                           | `false`                                              |
| `networkPolicy.allowExternal`              | Don't require client label for connections                                                                     | `true`                                               |
| `serviceAccount.create`                    | Specifies whether a ServiceAccount should be created                                                           | `false`                                              |
| `serviceAccount.name`                      | The name of the ServiceAccount to create                                                                       | Generated using the fullname template                |
| `rbac.create`                              | Specifies whether RBAC resources should be created                                                             | `false`                                              |
| `rbac.role.rules`                          | Rules to create                                                                                                | `[]`                                                 |
| `metrics.enabled`                          | Start a side-car prometheus exporter                                                                           | `false`                                              |
| `metrics.image.registry`                   | Redis exporter image registry                                                                                  | `docker.io`                                          |
| `metrics.image.repository`                 | Redis exporter image name                                                                                      | `oliver006/redis_exporter`                           |
| `metrics.image.tag`                        | Redis exporter image tag                                                                                       | `v0.20.2`                                            |
| `metrics.image.pullPolicy`                 | Image pull policy                                                                                              | `IfNotPresent`                                       |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                               | `nil`                                                |
| `metrics.extraArgs`                        | Extra arguments for the binary; possible values [here](https://github.com/oliver006/redis_exporter#flags)      | {}                                                   |
| `metrics.podLabels`                        | Additional labels for Metrics exporter pod                                                                     | {}                                                   |
| `metrics.podAnnotations`                   | Additional annotations for Metrics exporter pod                                                                | {}                                                   |
| `metrics.service.type`                     | Kubernetes Service type (redis metrics)                                                                        | `ClusterIP`                                          |
| `metrics.service.annotations`              | Annotations for the services to monitor  (redis master and redis slave service)                                | {}                                                   |
| `metrics.service.loadBalancerIP`           | loadBalancerIP if redis metrics service type is `LoadBalancer`                                                 | `nil`                                                |
| `metrics.resources`                        | Exporter resource requests/limit                                                                               | Memory: `256Mi`, CPU: `100m`                         |
| `metrics.serviceMonitor.enabled`           | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)         | `false`                                              |
| `metrics.serviceMonitor.namespace`         | Optional namespace which Prometheus is running in                                                              | `nil`                                                |
| `metrics.serviceMonitor.interval`          | How frequently to scrape metrics (use by default, falling back to Prometheus' default)                         |  `nil`                                               |
| `metrics.serviceMonitor.selector`          | Default to kube-prometheus install (CoreOS recommended), but should be set according to Prometheus install     | `{ prometheus: kube-prometheus }`                    |
| `persistence.existingClaim`                | Provide an existing PersistentVolumeClaim                                                                      | `nil`                                                |
| `master.persistence.enabled`               | Use a PVC to persist data (master node)                                                                        | `true`                                               |
| `master.persistence.path`                  | Path to mount the volume at, to use other images                                                               | `/data`                                              |
| `master.persistence.subPath`               | Subdirectory of the volume to mount at                                                                         | `""`                                                 |
| `master.persistence.storageClass`          | Storage class of backing PVC                                                                                   | `generic`                                            |
| `master.persistence.accessModes`           | Persistent Volume Access Modes                                                                                 | `[ReadWriteOnce]`                                    |
| `master.persistence.size`                  | Size of data volume                                                                                            | `8Gi`                                                |
| `master.statefulset.updateStrategy`        | Update strategy for StatefulSet                                                                                | onDelete                                             |
| `master.statefulset.rollingUpdatePartition`| Partition update strategy                                                                                      | `nil`                                                |
| `master.podLabels`                         | Additional labels for Redis master pod                                                                         | {}                                                   |
| `master.podAnnotations`                    | Additional annotations for Redis master pod                                                                    | {}                                                   |
| `master.port`                              | Redis master port                                                                                              | `6379`                                               |
| `master.command`                           | Redis master entrypoint array. The docker image's ENTRYPOINT is used if this is not provided.                  | []                                                   |
| `master.disableCommands`                   | Array of Redis commands to disable (master)                                                                    | `["FLUSHDB", "FLUSHALL"]`                                   |
| `master.extraFlags`                        | Redis master additional command line flags                                                                     | []                                                   |
| `master.nodeSelector`                      | Redis master Node labels for pod assignment                                                                    | {"beta.kubernetes.io/arch": "amd64"}                 |
| `master.tolerations`                       | Toleration labels for Redis master pod assignment                                                              | []                                                   |
| `master.affinity   `                       | Affinity settings for Redis master pod assignment                                                              | []                                                   |
| `master.schedulerName`                     | Name of an alternate scheduler                                                                                 | `nil`                                                |
| `master.service.type`                      | Kubernetes Service type (redis master)                                                                         | `ClusterIP`                                          |
| `master.service.port`                      | Kubernetes Service port (redis master)                                                                         | `6379`                                               |
| `master.service.nodePort`                  | Kubernetes Service nodePort (redis master)                                                                     | `nil`                                                |
| `master.service.annotations`               | annotations for redis master service                                                                           | {}                                                   |
| `master.service.loadBalancerIP`            | loadBalancerIP if redis master service type is `LoadBalancer`                                                  | `nil`                                                |
| `master.securityContext.enabled`           | Enable security context (redis master pod)                                                                     | `true`                                               |
| `master.securityContext.fsGroup`           | Group ID for the container (redis master pod)                                                                  | `1001`                                               |
| `master.securityContext.runAsUser`         | User ID for the container (redis master pod)                                                                   | `1001`                                               |
| `master.resources`                         | Redis master CPU/Memory resource requests/limits                                                               | Memory: `256Mi`, CPU: `100m`                         |
| `master.livenessProbe.enabled`             | Turn on and off liveness probe (redis master pod)                                                              | `true`                                               |
| `master.livenessProbe.initialDelaySeconds` | Delay before liveness probe is initiated (redis master pod)                                                    | `30`                                                 |
| `master.livenessProbe.periodSeconds`       | How often to perform the probe (redis master pod)                                                              | `30`                                                 |
| `master.livenessProbe.timeoutSeconds`      | When the probe times out (redis master pod)                                                                    | `5`                                                  |
| `master.livenessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed (redis master pod) | `1`                                                  |
| `master.livenessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.                     | `5`                                                  |
| `master.readinessProbe.enabled`            | Turn on and off readiness probe (redis master pod)                                                             | `true`                                               |
| `master.readinessProbe.initialDelaySeconds`| Delay before readiness probe is initiated (redis master pod)                                                   | `5`                                                  |
| `master.readinessProbe.periodSeconds`      | How often to perform the probe (redis master pod)                                                              | `10`                                                 |
| `master.readinessProbe.timeoutSeconds`     | When the probe times out (redis master pod)                                                                    | `1`                                                  |
| `master.readinessProbe.successThreshold`   | Minimum consecutive successes for the probe to be considered successful after having failed (redis master pod) | `1`                                                  |
| `master.readinessProbe.failureThreshold`   | Minimum consecutive failures for the probe to be considered failed after having succeeded.                     | `5`                                                  |
| `volumePermissions.image.registry`         | Init container volume-permissions image registry                                                               | `docker.io`                                          |
| `volumePermissions.image.repository`       | Init container volume-permissions image name                                                                   | `bitnami/minideb`                                    |
| `volumePermissions.image.tag`              | Init container volume-permissions image tag                                                                    | `latest`                                             |
| `volumePermissions.image.pullPolicy`       | Init container volume-permissions image pull policy                                                            | `IfNotPresent`                                       |
| `slave.service.type`                       | Kubernetes Service type (redis slave)                                                                          | `ClusterIP`                                          |
| `slave.service.nodePort`                   | Kubernetes Service nodePort (redis slave)                                                                      | `nil`                                                |
| `slave.service.annotations`                | annotations for redis slave service                                                                            | {}                                                   |
| `slave.service.loadBalancerIP`             | LoadBalancerIP if Redis slave service type is `LoadBalancer`                                                   | `nil`                                                |
| `slave.port`                               | Redis slave port                                                                                               | `master.port`                                        |
| `slave.command`                            | Redis slave entrypoint array. The docker image's ENTRYPOINT is used if this is not provided.                   | `master.command`                                     |
| `slave.disableCommands`                    | Array of Redis commands to disable (slave)                                                                     | `master.disableCommands`                             |
| `slave.extraFlags`                         | Redis slave additional command line flags                                                                      | `master.extraFlags`                                  |
| `slave.livenessProbe.enabled`              | Turn on and off liveness probe (redis slave pod)                                                               | `master.livenessProbe.enabled`                       |
| `slave.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated (redis slave pod)                                                     | `master.livenessProbe.initialDelaySeconds`           |
| `slave.livenessProbe.periodSeconds`        | How often to perform the probe (redis slave pod)                                                               | `master.livenessProbe.periodSeconds`                 |
| `slave.livenessProbe.timeoutSeconds`       | When the probe times out (redis slave pod)                                                                     | `master.livenessProbe.timeoutSeconds`                |
| `slave.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed (redis slave pod)  | `master.livenessProbe.successThreshold`              |
| `slave.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                     | `master.livenessProbe.failureThreshold`              |
| `slave.readinessProbe.enabled`             | Turn on and off slave.readiness probe (redis slave pod)                                                        | `master.readinessProbe.enabled`                      |
| `slave.readinessProbe.initialDelaySeconds` | Delay before slave.readiness probe is initiated (redis slave pod)                                              | `master.readinessProbe.initialDelaySeconds`          |
| `slave.readinessProbe.periodSeconds`       | How often to perform the probe (redis slave pod)                                                               | `master.readinessProbe.periodSeconds`                |
| `slave.readinessProbe.timeoutSeconds`      | When the probe times out (redis slave pod)                                                                     | `master.readinessProbe.timeoutSeconds`               |
| `slave.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed (redis slave pod)  | `master.readinessProbe.successThreshold`             |
| `slave.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded. (redis slave pod)   | `master.readinessProbe.failureThreshold`             |
| `slave.podLabels`                          | Additional labels for Redis slave pod                                                                          | `master.podLabels`                                   |
| `slave.podAnnotations`                     | Additional annotations for Redis slave pod                                                                     | `master.podAnnotations`                              |
| `slave.schedulerName`                      | Name of an alternate scheduler                                                                                 | `nil`                                                |
| `slave.securityContext.enabled`            | Enable security context (redis slave pod)                                                                      | `master.securityContext.enabled`                     |
| `slave.securityContext.fsGroup`            | Group ID for the container (redis slave pod)                                                                   | `master.securityContext.fsGroup`                     |
| `slave.securityContext.runAsUser`          | User ID for the container (redis slave pod)                                                                    | `master.securityContext.runAsUser`                   |
| `slave.resources`                          | Redis slave CPU/Memory resource requests/limits                                                                | `master.resources`                                   |
| `slave.affinity`                           | Enable node/pod affinity for slaves                                                                            | {}                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set password=secretpassword \
    stable/redis
```

The above command sets the Redis server password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/redis
```

> **Tip**: You can use the default [values.yaml](values.yaml)

> **Note for minikube users**: Current versions of minikube (v0.24.1 at the time of writing) provision `hostPath` persistent volumes that are only writable by root. Using chart defaults cause pod failure for the Redis pod as it attempts to write to the `/bitnami` directory. Consider installing Redis with `--set persistence.enabled=false`. See minikube issue [1990](https://github.com/kubernetes/minikube/issues/1990) for more information.

## NetworkPolicy

To enable network policy for Redis, install
[a networking plugin that implements the Kubernetes NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin),
and set `networkPolicy.enabled` to `true`.

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting
the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

    kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"

With NetworkPolicy enabled, only pods with the generated client label will be
able to connect to Redis. This label will be displayed in the output
after a successful install.

## Persistence

By default, the chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at the `/data` path. The volume is created using dynamic volume provisioning. If a Persistent Volume Claim already exists, specify it during installation.

### Existing PersistentVolumeClaim

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart

```bash
$ helm install --set persistence.existingClaim=PVC_NAME stable/redis
```

## Metrics

The chart optionally can start a metrics exporter for [prometheus](https://prometheus.io). The metrics endpoint (port 9121) is exposed in the service. Metrics can be scraped from within the cluster using something similar as the described in the [example Prometheus scrape configuration](https://github.com/prometheus/prometheus/blob/master/documentation/examples/prometheus-kubernetes.yml). If metrics are to be scraped from outside the cluster, the Kubernetes API proxy can be utilized to access the endpoint.
