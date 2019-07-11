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

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

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

### To 8.0.18

For releases with `metrics.enabled: true` the default tag for the exporter image is now `v1.x.x`. This introduces many changes including metrics names. You'll want to use [this dashboard](https://github.com/oliver006/redis_exporter/blob/master/contrib/grafana_prometheus_redis_dashboard.json) now. Please see the [redis_exporter github page](https://github.com/oliver006/redis_exporter#upgrading-from-0x-to-1x) for more details.

### To 7.0.0

This version causes a change in the Redis Master StatefulSet definition, so the command helm upgrade would not work out of the box. As an alternative, one of the following could be done:

  - Recommended: Create a clone of the Redis Master PVC (for example, using projects like [this one](https://github.com/edseymour/pvc-transfer)). Then launch a fresh release reusing this cloned PVC.

   ```
   helm install stable/redis --set persistence.existingClaim=<NEW PVC>
   ```

  - Alternative (not recommended, do at your own risk): `helm delete --purge` does not remove the PVC assigned to the Redis Master StatefulSet. As a consequence, the following commands can be done to upgrade the release

   ```
   helm delete --purge <RELEASE>
   helm install stable/redis --name <RELEASE>
   ```

Previous versions of the chart were not using persistence in the slaves, so this upgrade would add it to them. Another important change is that no values are inherited from master to slaves. For example, in 6.0.0 `slaves.readinessProbe.periodSeconds`, if empty, would be set to `master.readinessProbe.periodSeconds`. This approach lacked transparency and was difficult to maintain. From now on, all the slave parameters must be configured just as it is done with the masters.

Some values have changed as well:

   - `master.port` and `slave.port` have been changed to `redisPort` (same value for both master and slaves)
   - `master.securityContext` and `slave.securityContext` have been changed to `securityContext`(same values for both master and slaves)

By default, the upgrade will not change the cluster topology. In case you want to use Redis Sentinel, you must explicitly set `sentinel.enabled` to `true`.

### To 6.0.0

Previous versions of the chart were using an init-container to change the permissions of the volumes. This was done in case the `securityContext` directive in the template was not enough for that (for example, with cephFS). In this new version of the chart, this container is disabled by default (which should not affect most of the deployments). If your installation still requires that init container, execute `helm upgrade` with the `--set volumePermissions.enabled=true`.

### To 5.0.0

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

| Parameter                                     | Description                                                                                                                                         | Default                                                 |
|-----------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                        | Global Docker image registry                                                                                                                        | `nil`                                                   |
| `global.imagePullSecrets`                     | Global Docker registry secret names as an array                                                                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`                              | Redis Image registry                                                                                                                                | `docker.io`                                             |
| `image.repository`                            | Redis Image name                                                                                                                                    | `bitnami/redis`                                         |
| `image.tag`                                   | Redis Image tag                                                                                                                                     | `{TAG_NAME}`                                            |
| `image.pullPolicy`                            | Image pull policy                                                                                                                                   | `IfNotPresent`                                          |
| `image.pullSecrets`                           | Specify docker-registry secret names as an array                                                                                                    | `nil`                                                   |
| `nameOverride`                                | String to partially override redis.fullname template with a string (will prepend the release name)                                                  | `nil`                                                   |
| `fullnameOverride`                            | String to fully override redis.fullname template with a string                                                                                      | `nil`                                                   |
| `cluster.enabled`                             | Use master-slave topology                                                                                                                           | `true`                                                  |
| `cluster.slaveCount`                          | Number of slaves                                                                                                                                    | `1`                                                     |
| `existingSecret`                              | Name of existing secret object (for password authentication)                                                                                        | `nil`                                                   |
| `usePassword`                                 | Use password                                                                                                                                        | `true`                                                  |
| `usePasswordFile`                             | Mount passwords as files instead of environment variables                                                                                           | `false`                                                 |
| `password`                                    | Redis password (ignored if existingSecret set)                                                                                                      | Randomly generated                                      |
| `configmap`                                   | Additional common Redis node configuration                                                                                                          | See values.yaml                                         |
| `clusterDomain`                               | Kubernetes DNS Domain name to use                                                                                                                   | `cluster.local`                                         |
| `networkPolicy.enabled`                       | Enable NetworkPolicy                                                                                                                                | `false`                                                 |
| `networkPolicy.allowExternal`                 | Don't require client label for connections                                                                                                          | `true`                                                  |
| `securityContext.enabled`                     | Enable security context (both redis master and slave pods)                                                                                          | `true`                                                  |
| `securityContext.fsGroup`                     | Group ID for the container (both redis master and slave pods)                                                                                       | `1001`                                                  |
| `securityContext.runAsUser`                   | User ID for the container (both redis master and slave pods)                                                                                        | `1001`                                                  |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                                                | `false`                                                 |
| `serviceAccount.name`                         | The name of the ServiceAccount to create                                                                                                            | Generated using the fullname template                   |
| `rbac.create`                                 | Specifies whether RBAC resources should be created                                                                                                  | `false`                                                 |
| `rbac.role.rules`                             | Rules to create                                                                                                                                     | `[]`                                                    |
| `metrics.enabled`                             | Start a side-car prometheus exporter                                                                                                                | `false`                                                 |
| `metrics.image.registry`                      | Redis exporter image registry                                                                                                                       | `docker.io`                                             |
| `metrics.image.repository`                    | Redis exporter image name                                                                                                                           | `oliver006/redis_exporter`                              |
| `metrics.image.tag`                           | Redis exporter image tag                                                                                                                            | `v1.0.3`                                               |
| `metrics.image.pullPolicy`                    | Image pull policy                                                                                                                                   | `IfNotPresent`                                          |
| `metrics.image.pullSecrets`                   | Specify docker-registry secret names as an array                                                                                                    | `nil`                                                   |
| `metrics.extraArgs`                           | Extra arguments for the binary; possible values [here](https://github.com/oliver006/redis_exporter#flags)                                           | {}                                                      |
| `metrics.podLabels`                           | Additional labels for Metrics exporter pod                                                                                                          | {}                                                      |
| `metrics.podAnnotations`                      | Additional annotations for Metrics exporter pod                                                                                                     | {}                                                      |
| `metrics.service.type`                        | Kubernetes Service type (redis metrics)                                                                                                             | `ClusterIP`                                             |
| `metrics.service.annotations`                 | Annotations for the services to monitor  (redis master and redis slave service)                                                                     | {}                                                      |
| `metrics.service.loadBalancerIP`              | loadBalancerIP if redis metrics service type is `LoadBalancer`                                                                                      | `nil`                                                   |
| `metrics.resources`                           | Exporter resource requests/limit                                                                                                                    | Memory: `256Mi`, CPU: `100m`                            |
| `metrics.serviceMonitor.enabled`              | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                              | `false`                                                 |
| `metrics.serviceMonitor.namespace`            | Optional namespace which Prometheus is running in                                                                                                   | `nil`                                                   |
| `metrics.serviceMonitor.interval`             | How frequently to scrape metrics (use by default, falling back to Prometheus' default)                                                              | `nil`                                                   |
| `metrics.serviceMonitor.selector`             | Default to kube-prometheus install (CoreOS recommended), but should be set according to Prometheus install                                          | `{ prometheus: kube-prometheus }`                       |
| `metrics.priorityClassName`                   | Metrics exporter pod priorityClassName                                                                                                              | {}                                                      |
| `persistence.existingClaim`                   | Provide an existing PersistentVolumeClaim                                                                                                           | `nil`                                                   |
| `master.persistence.enabled`                  | Use a PVC to persist data (master node)                                                                                                             | `true`                                                  |
| `master.persistence.path`                     | Path to mount the volume at, to use other images                                                                                                    | `/data`                                                 |
| `master.persistence.subPath`                  | Subdirectory of the volume to mount at                                                                                                              | `""`                                                    |
| `master.persistence.storageClass`             | Storage class of backing PVC                                                                                                                        | `generic`                                               |
| `master.persistence.accessModes`              | Persistent Volume Access Modes                                                                                                                      | `[ReadWriteOnce]`                                       |
| `master.persistence.size`                     | Size of data volume                                                                                                                                 | `8Gi`                                                   |
| `master.statefulset.updateStrategy`           | Update strategy for StatefulSet                                                                                                                     | onDelete                                                |
| `master.statefulset.rollingUpdatePartition`   | Partition update strategy                                                                                                                           | `nil`                                                   |
| `master.podLabels`                            | Additional labels for Redis master pod                                                                                                              | {}                                                      |
| `master.podAnnotations`                       | Additional annotations for Redis master pod                                                                                                         | {}                                                      |
| `redisPort`                                   | Redis port (in both master and slaves)                                                                                                              | `6379`                                                  |
| `master.command`                              | Redis master entrypoint string. The command `redis-server` is executed if this is not provided.                                                     | `/run.sh`                                               |
| `master.configmap`                            | Additional Redis configuration for the master nodes                                                                                                 | `nil`                                                   |
| `master.disableCommands`                      | Array of Redis commands to disable (master)                                                                                                         | `["FLUSHDB", "FLUSHALL"]`                               |
| `master.extraFlags`                           | Redis master additional command line flags                                                                                                          | []                                                      |
| `master.nodeSelector`                         | Redis master Node labels for pod assignment                                                                                                         | {"beta.kubernetes.io/arch": "amd64"}                    |
| `master.tolerations`                          | Toleration labels for Redis master pod assignment                                                                                                   | []                                                      |
| `master.affinity`                             | Affinity settings for Redis master pod assignment                                                                                                   | {}                                                      |
| `master.schedulerName`                        | Name of an alternate scheduler                                                                                                                      | `nil`                                                   |
| `master.service.type`                         | Kubernetes Service type (redis master)                                                                                                              | `ClusterIP`                                             |
| `master.service.port`                         | Kubernetes Service port (redis master)                                                                                                              | `6379`                                                  |
| `master.service.nodePort`                     | Kubernetes Service nodePort (redis master)                                                                                                          | `nil`                                                   |
| `master.service.annotations`                  | annotations for redis master service                                                                                                                | {}                                                      |
| `master.service.loadBalancerIP`               | loadBalancerIP if redis master service type is `LoadBalancer`                                                                                       | `nil`                                                   |
| `master.resources`                            | Redis master CPU/Memory resource requests/limits                                                                                                    | Memory: `256Mi`, CPU: `100m`                            |
| `master.livenessProbe.enabled`                | Turn on and off liveness probe (redis master pod)                                                                                                   | `true`                                                  |
| `master.livenessProbe.initialDelaySeconds`    | Delay before liveness probe is initiated (redis master pod)                                                                                         | `30`                                                    |
| `master.livenessProbe.periodSeconds`          | How often to perform the probe (redis master pod)                                                                                                   | `30`                                                    |
| `master.livenessProbe.timeoutSeconds`         | When the probe times out (redis master pod)                                                                                                         | `5`                                                     |
| `master.livenessProbe.successThreshold`       | Minimum consecutive successes for the probe to be considered successful after having failed (redis master pod)                                      | `1`                                                     |
| `master.livenessProbe.failureThreshold`       | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                          | `5`                                                     |
| `master.readinessProbe.enabled`               | Turn on and off readiness probe (redis master pod)                                                                                                  | `true`                                                  |
| `master.readinessProbe.initialDelaySeconds`   | Delay before readiness probe is initiated (redis master pod)                                                                                        | `5`                                                     |
| `master.readinessProbe.periodSeconds`         | How often to perform the probe (redis master pod)                                                                                                   | `10`                                                    |
| `master.readinessProbe.timeoutSeconds`        | When the probe times out (redis master pod)                                                                                                         | `1`                                                     |
| `master.readinessProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed (redis master pod)                                      | `1`                                                     |
| `master.readinessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                          | `5`                                                     |
| `master.priorityClassName`                    | Redis Master pod priorityClassName                                                                                                                  | {}                                                      |
| `volumePermissions.enabled`                   | Enable init container that changes volume permissions in the registry (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                 |
| `volumePermissions.image.registry`            | Init container volume-permissions image registry                                                                                                    | `docker.io`                                             |
| `volumePermissions.image.repository`          | Init container volume-permissions image name                                                                                                        | `bitnami/minideb`                                       |
| `volumePermissions.image.tag`                 | Init container volume-permissions image tag                                                                                                         | `latest`                                                |
| `volumePermissions.image.pullPolicy`          | Init container volume-permissions image pull policy                                                                                                 | `Always`                                                |
| `volumePermissions.resources       `          | Init container volume-permissions CPU/Memory resource requests/limits                                                                               | {}                                                      |
| `slave.service.type`                          | Kubernetes Service type (redis slave)                                                                                                               | `ClusterIP`                                             |
| `slave.service.nodePort`                      | Kubernetes Service nodePort (redis slave)                                                                                                           | `nil`                                                   |
| `slave.service.annotations`                   | annotations for redis slave service                                                                                                                 | {}                                                      |
| `slave.service.port`                          | Kubernetes Service port (redis slave)                                                                                                               | `6379`                                                  |
| `slave.service.loadBalancerIP`                | LoadBalancerIP if Redis slave service type is `LoadBalancer`                                                                                        | `nil`                                                   |
| `slave.command`                               | Redis slave entrypoint array. The docker image's ENTRYPOINT is used if this is not provided.                                                        | `/run.sh`                                               |
| `slave.configmap`                             | Additional Redis configuration for the slave nodes                                                                                                  | `nil`                                                   |
| `slave.disableCommands`                       | Array of Redis commands to disable (slave)                                                                                                          | `[FLUSHDB, FLUSHALL]`                                   |
| `slave.extraFlags`                            | Redis slave additional command line flags                                                                                                           | `[]`                                                    |
| `slave.livenessProbe.enabled`                 | Turn on and off liveness probe (redis slave pod)                                                                                                    | `true`                                                  |
| `slave.livenessProbe.initialDelaySeconds`     | Delay before liveness probe is initiated (redis slave pod)                                                                                          | `30`                                                    |
| `slave.livenessProbe.periodSeconds`           | How often to perform the probe (redis slave pod)                                                                                                    | `10`                                                    |
| `slave.livenessProbe.timeoutSeconds`          | When the probe times out (redis slave pod)                                                                                                          | `5`                                                     |
| `slave.livenessProbe.successThreshold`        | Minimum consecutive successes for the probe to be considered successful after having failed (redis slave pod)                                       | `1`                                                     |
| `slave.livenessProbe.failureThreshold`        | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                          | `5`                                                     |
| `slave.readinessProbe.enabled`                | Turn on and off slave.readiness probe (redis slave pod)                                                                                             | `true`                                                  |
| `slave.readinessProbe.initialDelaySeconds`    | Delay before slave.readiness probe is initiated (redis slave pod)                                                                                   | `5`                                                     |
| `slave.readinessProbe.periodSeconds`          | How often to perform the probe (redis slave pod)                                                                                                    | `10`                                                    |
| `slave.readinessProbe.timeoutSeconds`         | When the probe times out (redis slave pod)                                                                                                          | `10`                                                    |
| `slave.readinessProbe.successThreshold`       | Minimum consecutive successes for the probe to be considered successful after having failed (redis slave pod)                                       | `1`                                                     |
| `slave.readinessProbe.failureThreshold`       | Minimum consecutive failures for the probe to be considered failed after having succeeded. (redis slave pod)                                        | `5`                                                     |
| `slave.persistence.enabled`                   | Use a PVC to persist data (slave node)                                                                                                              | `true`                                                  |
| `slave.persistence.path`                      | Path to mount the volume at, to use other images                                                                                                    | `/data`                                                 |
| `slave.persistence.subPath`                   | Subdirectory of the volume to mount at                                                                                                              | `""`                                                    |
| `slave.persistence.storageClass`              | Storage class of backing PVC                                                                                                                        | `generic`                                               |
| `slave.persistence.accessModes`               | Persistent Volume Access Modes                                                                                                                      | `[ReadWriteOnce]`                                       |
| `slave.persistence.size`                      | Size of data volume                                                                                                                                 | `8Gi`                                                   |
| `slave.statefulset.updateStrategy`            | Update strategy for StatefulSet                                                                                                                     | onDelete                                                |
| `slave.statefulset.rollingUpdatePartition`    | Partition update strategy                                                                                                                           | `nil`                                                   |
| `slave.podLabels`                             | Additional labels for Redis slave pod                                                                                                               | `master.podLabels`                                      |
| `slave.podAnnotations`                        | Additional annotations for Redis slave pod                                                                                                          | `master.podAnnotations`                                 |
| `slave.schedulerName`                         | Name of an alternate scheduler                                                                                                                      | `nil`                                                   |
| `slave.resources`                             | Redis slave CPU/Memory resource requests/limits                                                                                                     | `{}`                                                    |
| `slave.affinity`                              | Enable node/pod affinity for slaves                                                                                                                 | {}                                                      |
| `slave.priorityClassName`                     | Redis Slave pod priorityClassName                                                                                                                   | {}                                                      |
| `sentinel.enabled`                            | Enable sentinel containers                                                                                                                          | `false`                                                 |
| `sentinel.masterSet`                          | Name of the sentinel master set                                                                                                                     | `mymaster`                                              |
| `sentinel.initialCheckTimeout`                | Timeout for querying the redis sentinel service for the active sentinel list                                                                        | `5`                                                     |
| `sentinel.quorum`                             | Quorum for electing a new master                                                                                                                    | `2`                                                     |
| `sentinel.downAfterMilliseconds`              | Timeout for detecting a Redis node is down                                                                                                          | `60000`                                                 |
| `sentinel.failoverTimeout`                    | Timeout for performing a election failover                                                                                                          | `18000`                                                 |
| `sentinel.parallelSyncs`                      | Number of parallel syncs in the cluster                                                                                                             | `1`                                                     |
| `sentinel.port`                               | Redis Sentinel port                                                                                                                                 | `26379`                                                 |
| `sentinel.configmap`                          | Additional Redis configuration for the sentinel nodes                                                                                               | `nil`                                                   |
| `sentinel.service.type`                       | Kubernetes Service type (redis sentinel)                                                                                                            | `ClusterIP`                                             |
| `sentinel.service.nodePort`                   | Kubernetes Service nodePort (redis sentinel)                                                                                                        | `nil`                                                   |
| `sentinel.service.annotations`                | annotations for redis sentinel service                                                                                                              | {}                                                      |
| `sentinel.service.redisPort`                  | Kubernetes Service port for Redis read only operations                                                                                              | `6379`                                                  |
| `sentinel.service.sentinelPort`               | Kubernetes Service port for Redis sentinel                                                                                                          | `26379`                                                 |
| `sentinel.service.redisNodePort`              | Kubernetes Service node port for Redis read only operations                                                                                         | ``                                                      |
| `sentinel.service.sentinelNodePort`           | Kubernetes Service node port for Redis sentinel                                                                                                     | ``                                                      |
| `sentinel.service.loadBalancerIP`             | LoadBalancerIP if Redis sentinel service type is `LoadBalancer`                                                                                     | `nil`                                                   |
| `sentinel.livenessProbe.enabled`              | Turn on and off liveness probe (redis sentinel pod)                                                                                                 | `true`                                                  |
| `sentinel.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated (redis sentinel pod)                                                                                       | `5`                                                     |
| `sentinel.livenessProbe.periodSeconds`        | How often to perform the probe (redis sentinel container)                                                                                           | `5`                                                     |
| `sentinel.livenessProbe.timeoutSeconds`       | When the probe times out (redis sentinel container)                                                                                                 | `5`                                                     |
| `sentinel.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed (redis sentinel container)                              | `1`                                                     |
| `sentinel.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                          | `5`                                                     |
| `sentinel.readinessProbe.enabled`             | Turn on and off sentinel.readiness probe (redis sentinel pod)                                                                                       | `true`                                                  |
| `sentinel.readinessProbe.initialDelaySeconds` | Delay before sentinel.readiness probe is initiated (redis sentinel pod)                                                                             | `5`                                                     |
| `sentinel.readinessProbe.periodSeconds`       | How often to perform the probe (redis sentinel pod)                                                                                                 | `5`                                                     |
| `sentinel.readinessProbe.timeoutSeconds`      | When the probe times out (redis sentinel container)                                                                                                 | `1`                                                     |
| `sentinel.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed (redis sentinel container)                              | `1`                                                     |
| `sentinel.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded. (redis sentinel container)                               | `5`                                                     |
| `sentinel.resources`                          | Redis sentinel CPU/Memory resource requests/limits                                                                                                  | `{}`                                                    |
| `sentinel.image.registry`                     | Redis Sentinel Image registry                                                                                                                       | `docker.io`                                             |
| `sentinel.image.repository`                   | Redis Sentinel Image name                                                                                                                           | `bitnami/redis-sentinel`                                |
| `sentinel.image.tag`                          | Redis Sentinel Image tag                                                                                                                            | `{TAG_NAME}`                                            |
| `sentinel.image.pullPolicy`                   | Image pull policy                                                                                                                                   | `IfNotPresent`                                          |
| `sentinel.image.pullSecrets`                  | Specify docker-registry secret names as an array                                                                                                    | `nil`                                                   |
| `sysctlImage.enabled`                         | Enable an init container to modify Kernel settings                                                                                                  | `false`                                                 |
| `sysctlImage.command`                         | sysctlImage command to execute                                                                                                                      | []                                                      |
| `sysctlImage.registry`                        | sysctlImage Init container registry                                                                                                                 | `docker.io`                                             |
| `sysctlImage.repository`                      | sysctlImage Init container name                                                                                                                     | `bitnami/minideb`                                       |
| `sysctlImage.tag`                             | sysctlImage Init container tag                                                                                                                      | `latest`                                                |
| `sysctlImage.pullPolicy`                      | sysctlImage Init container pull policy                                                                                                              | `Always`                                                |
| `sysctlImage.mountHostSys`                    | Mount the host `/sys` folder to `/host-sys`                                                                                                         | `false`                                                 |
| `sysctlImage.resources`                       | sysctlImage Init container CPU/Memory resource requests/limits                                                                                      | {}                                                      |

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

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`.

```console
$ helm install --name my-release -f ./values-production.yaml stable/redis
```

- Number of slaves:
```diff
- cluster.slaveCount: 2
+ cluster.slaveCount: 3
```

- Enable NetworkPolicy:
```diff
- networkPolicy.enabled: false
+ networkPolicy.enabled: true
```

- Start a side-car prometheus exporter:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

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

## Host Kernel Settings
Redis may require some changes in the kernel of the host machine to work as expected, in particular increasing the `somaxconn` value and disabling transparent huge pages.
To do so, you can set up a privileged initContainer with the `sysctlImage` config values, for example:
```
sysctlImage:
  enabled: true
  mountHostSys: true
  command:
    - /bin/sh
    - -c
    - |-
      install_packages systemd
      sysctl -w net.core.somaxconn=10000
      echo never > /host-sys/kernel/mm/transparent_hugepage/enabled
```
## Cluster topologies

### Default: Master-Slave

When installing the chart with `cluster.enabled=true`, it will deploy a Redis master StatefulSet (only one master node allowed) and a Redis slave StatefulSet. The slaves will be read-replicas of the master. Two services will be exposed:

   - Redis Master service: Points to the master, where read-write operations can be performed
   - Redis Slave service: Points to the slaves, where only read operations are allowed.

In case the master crashes, the slaves will wait until the master node is respawned again by the Kubernetes Controller Manager.

### Master-Slave with Sentinel

When installing the chart with `cluster.enabled=true` and `sentinel.enabled=true`, it will deploy a Redis master StatefulSet (only one master allowed) and a Redis slave StatefulSet. In this case, the pods will contain en extra container with Redis Sentinel. This container will form a cluster of Redis Sentinel nodes, which will promote a new master in case the actual one fails. In addition to this, only one service is exposed:

   - Redis service: Exposes port 6379 for Redis read-only operations and port 26379 for accesing Redis Sentinel.

For read-only operations, access the service using port 6379. For write operations, it's necessary to access the Redis Sentinel cluster and query the current master using the command below (using redis-cli or similar:

```
SENTINEL get-master-addr-by-name <name of your MasterSet. Example: mymaster>
```
This command will return the address of the current master, which can be accessed from inside the cluster.

In case the current master crashes, the Sentinel containers will elect a new master node.

## Notable changes

### 7.0.0
In order to improve the performance in case of slave failure, we added persistence to the read-only slaves. That means that we moved from Deployment to StatefulSets. This should not affect upgrades from previous versions of the chart, as the deployments did not contain any persistence at all.

This version also allows enabling Redis Sentinel containers inside of the Redis Pods (feature disabled by default). In case the master crashes, a new Redis node will be elected as master. In order to query the current master (no redis master service is exposed), you need to query first the Sentinel cluster. Find more information [in this section](#master-slave-with-sentinel).
