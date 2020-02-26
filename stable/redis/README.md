
# Redis

[Redis](http://redis.io/) is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

## TL;DR;

```bash
# Testing configuration
$ helm install my-release stable/redis
```

```bash
# Production configuration
$ helm install my-release stable/redis --values values-production.yaml
```

## Introduction

This chart bootstraps a [Redis](https://github.com/bitnami/bitnami-docker-redis) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release stable/redis
```

The command deploys Redis on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the Redis chart and their default values.

| Parameter                                     | Description                                                                                                                                         | Default                                                 |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `global.imageRegistry`                        | Global Docker image registry                                                                                                                        | `nil`                                                   |
| `global.imagePullSecrets`                     | Global Docker registry secret names as an array                                                                                                     | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                         | Global storage class for dynamic provisioning                                                                                                       | `nil`                                                   |
| `global.redis.password`                       | Redis password (overrides `password`)                                                                                                               | `nil`                                                   |
| `image.registry`                              | Redis Image registry                                                                                                                                | `docker.io`                                             |
| `image.repository`                            | Redis Image name                                                                                                                                    | `bitnami/redis`                                         |
| `image.tag`                                   | Redis Image tag                                                                                                                                     | `{TAG_NAME}`                                            |
| `image.pullPolicy`                            | Image pull policy                                                                                                                                   | `IfNotPresent`                                          |
| `image.pullSecrets`                           | Specify docker-registry secret names as an array                                                                                                    | `nil`                                                   |
| `nameOverride`                                | String to partially override redis.fullname template with a string (will prepend the release name)                                                  | `nil`                                                   |
| `fullnameOverride`                            | String to fully override redis.fullname template with a string                                                                                      | `nil`                                                   |
| `cluster.enabled`                             | Use master-slave topology                                                                                                                           | `true`                                                  |
| `cluster.nodes`                               | Number of nodes in the Redis cluster                                                                                                                | `6`                                                     |
| `cluster.replicas`                            | Number of replicas for every master in the cluster                                                                                                  | `1`                                                     |
| `cluster.busPort`                             | Port for the Redis gossip protocol                                                                                                                  | `16379`                                                 |
| `cluster.externalAccess.enabled`              | Enable access to the Redis cluster from Outside the Kubernetes Cluster                                                                              | `false`                                                 |
| `cluster.externalAccess.service.type`         | Type for the services used to expose every Pod                                                                                                      | `LoadBalancer`                                          |
| `cluster.externalAccess.service.port`         | Port for the services used to expose every Pod                                                                                                      | `6379`                                                  |
| `cluster.externalAccess.service.loadBalancerIP` | Array of LoadBalancer IPs used to expose every Pod of the Redis cluster when `cluster.externalAccess.service.type` is `LoadBalancer`              | `[]`                                                    |
| `cluster.externalAccess.service.annotations`  | Annotations to add to the services used to expose every Pod of the Redis Cluster                                                                    | `{}`                                                    |
| `existingSecret`                              | Name of existing secret object (for password authentication)                                                                                        | `nil`                                                   |
| `existingSecretPasswordKey`                   | Name of key containing password to be retrieved from the existing secret                                                                            | `nil`                                                   |
| `usePassword`                                 | Use password                                                                                                                                        | `true`                                                  |
| `usePasswordFile`                             | Mount passwords as files instead of environment variables                                                                                           | `false`                                                 |
| `password`                                    | Redis password (ignored if existingSecret set)                                                                                                      | Randomly generated                                      |
| `configmap`                                   | Additional common Redis node configuration (this value is evaluated as a template)                                                                  | See values.yaml                                         |
| `clusterDomain`                               | Kubernetes DNS Domain name to use                                                                                                                   | `cluster.local`                                         |
| `networkPolicy.enabled`                       | Enable NetworkPolicy                                                                                                                                | `false`                                                 |
| `networkPolicy.allowExternal`                 | Don't require client label for connections                                                                                                          | `true`                                                  |
| `networkPolicy.ingressNSMatchLabels`          | Allow connections from other namespaces                                                                                                             | `{}`                                                    |
| `networkPolicy.ingressNSPodMatchLabels`       | For other namespaces match by pod labels and namespace labels                                                                                       | `{}`                                                    |
| `securityContext.enabled`                     | Enable security context.                                                                                                                            | `true`                                                  |
| `securityContext.fsGroup`                     | Group ID for the container.                                                                                                                         | `1001`                                                  |
| `securityContext.runAsUser`                   | User ID for the container.                                                                                                                          | `1001`                                                  |
| `securityContext.sysctls`                     | Set namespaced sysctls for the container.                                                                                                           | `nil`                                                   |
| `serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                                                | `false`                                                 |
| `serviceAccount.name`                         | The name of the ServiceAccount to create                                                                                                            | Generated using the fullname template                   |
| `rbac.create`                                 | Specifies whether RBAC resources should be created                                                                                                  | `false`                                                 |
| `rbac.role.rules`                             | Rules to create                                                                                                                                     | `[]`                                                    |
| `metrics.enabled`                             | Start a side-car prometheus exporter                                                                                                                | `false`                                                 |
| `metrics.image.registry`                      | Redis exporter image registry                                                                                                                       | `docker.io`                                             |
| `metrics.image.repository`                    | Redis exporter image name                                                                                                                           | `bitnami/redis-exporter`                                |
| `metrics.image.tag`                           | Redis exporter image tag                                                                                                                            | `{TAG_NAME}`                                            |
| `metrics.image.pullPolicy`                    | Image pull policy                                                                                                                                   | `IfNotPresent`                                          |
| `metrics.image.pullSecrets`                   | Specify docker-registry secret names as an array                                                                                                    | `nil`                                                   |
| `metrics.extraArgs`                           | Extra arguments for the binary; possible values [here](https://github.com/oliver006/redis_exporter#flags)                                           | {}                                                      |
| `metrics.podLabels`                           | Additional labels for Metrics exporter pod                                                                                                          | {}                                                      |
| `metrics.podAnnotations`                      | Additional annotations for Metrics exporter pod                                                                                                     | {}                                                      |
| `metrics.resources`                           | Exporter resource requests/limit                                                                                                                    | Memory: `256Mi`, CPU: `100m`                            |
| `metrics.serviceMonitor.enabled`              | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                              | `false`                                                 |
| `metrics.serviceMonitor.namespace`            | Optional namespace which Prometheus is running in                                                                                                   | `nil`                                                   |
| `metrics.serviceMonitor.interval`             | How frequently to scrape metrics (use by default, falling back to Prometheus' default)                                                              | `nil`                                                   |
| `metrics.serviceMonitor.selector`             | Default to kube-prometheus install (CoreOS recommended), but should be set according to Prometheus install                                          | `{ prometheus: kube-prometheus }`                       |
| `metrics.service.type`                        | Kubernetes Service type (redis metrics)                                                                                                             | `ClusterIP`                                             |
| `metrics.service.annotations`                 | Annotations for the services to monitor.                                                                                                            | {}                                                      |
| `metrics.service.labels`                      | Additional labels for the metrics service                                                                                                           | {}                                                      |
| `metrics.service.loadBalancerIP`              | loadBalancerIP if redis metrics service type is `LoadBalancer`                                                                                      | `nil`                                                   |
| `metrics.priorityClassName`                   | Metrics exporter pod priorityClassName                                                                                                              | {}                                                      |
| `metrics.prometheusRule.enabled`              | Set this to true to create prometheusRules for Prometheus operator                                                                                  | `false`                                                 |
| `metrics.prometheusRule.additionalLabels`     | Additional labels that can be used so prometheusRules will be discovered by Prometheus                                                              | `{}`                                                    |
| `metrics.prometheusRule.namespace`            | namespace where prometheusRules resource should be created                                                                                          | Same namespace as redis                                 |
| `metrics.prometheusRule.rules`                | [rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) to be created, check values for an example.                     | `[]`                                                    |
| `persistence.existingClaim`                   | Provide an existing PersistentVolumeClaim                                                                                                           | `nil`                                                   |
| `persistence.enabled`                         | Use a PVC to persist data.                                                                                                                          | `true`                                                  |
| `persistence.path`                            | Path to mount the volume at, to use other images                                                                                                    | `/data`                                                 |
| `persistence.subPath`                         | Subdirectory of the volume to mount at                                                                                                              | `""`                                                    |
| `persistence.storageClass`                    | Storage class of backing PVC                                                                                                                        | `generic`                                               |
| `persistence.accessModes`                     | Persistent Volume Access Modes                                                                                                                      | `[ReadWriteOnce]`                                       |
| `persistence.size`                            | Size of data volume                                                                                                                                 | `8Gi`                                                   |
| `persistence.matchLabels`                     | matchLabels persistent volume selector                                                                                                              | `{}`                                                    |
| `persistence.matchExpressions`                | matchExpressions persistent volume selector                                                                                                         | `{}`                                                    |
| `statefulset.updateStrategy`                  | Update strategy for StatefulSet                                                                                                                     | onDelete                                                |
| `statefulset.rollingUpdatePartition`          | Partition update strategy                                                                                                                           | `nil`                                                   |
| `podLabels`                                   | Additional labels for Redis pod                                                                                                                     | {}                                                      |
| `podAnnotations`                              | Additional annotations for Redis pod                                                                                                                | {}                                                      |
| `redisPort`                                   | Redis port.                                                                                                                                         | `6379`                                                  |
| `command`                                     | Redis entrypoint string. The command `redis-server` is executed if this is not provided.                                                            | `/run.sh`                                               |
| `configmap`                                   | Additional Redis configuration for the nodes (this value is evaluated as a template)                                                                | `nil`                                                   |
| `extraFlags`                                  | Redis additional command line flags                                                                                                                 | []                                                      |
| `nodeSelector`                                | Redis Node labels for pod assignment                                                                                                                | {"beta.kubernetes.io/arch": "amd64"}                    |
| `tolerations`                                 | Toleration labels for Redis pod assignment                                                                                                          | []                                                      |
| `affinity`                                    | Affinity settings for Redis pod assignment                                                                                                          | {}                                                      |
| `schedulerName`                               | Name of an alternate scheduler                                                                                                                      | `nil`                                                   |
| `service.type`                                | Kubernetes Service type.                                                                                                                            | `ClusterIP`                                             |
| `service.port`                                | Kubernetes Service port.                                                                                                                            | `6379`                                                  |
| `service.nodePort`                            | Kubernetes Service nodePort.                                                                                                                        | `nil`                                                   |
| `service.annotations`                         | annotations for redis service                                                                                                                       | {}                                                      |
| `service.labels`                              | Additional labels for redis service                                                                                                                 | {}                                                      |
| `service.loadBalancerIP`                      | loadBalancerIP if redis service type is `LoadBalancer`                                                                                              | `nil`                                                   |
| `service.loadBalancerSourceRanges`            | loadBalancerSourceRanges if redis service type is `LoadBalancer`                                                                                    | `nil`                                                   |
| `resources`                                   | Redis CPU/Memory resource requests/limits                                                                                                           | Memory: `256Mi`, CPU: `100m`                            |
| `livenessProbe.enabled`                       | Turn on and off liveness probe.                                                                                                                     | `true`                                                  |
| `livenessProbe.initialDelaySeconds`           | Delay before liveness probe is initiated.                                                                                                           | `30`                                                    |
| `livenessProbe.periodSeconds`                 | How often to perform the probe.                                                                                                                     | `30`                                                    |
| `livenessProbe.timeoutSeconds`                | When the probe times out.                                                                                                                           | `5`                                                     |
| `livenessProbe.successThreshold`              | Minimum consecutive successes for the probe to be considered successful after having failed.                                                        | `1`                                                     |
| `livenessProbe.failureThreshold`              | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                          | `5`                                                     |
| `readinessProbe.enabled`                      | Turn on and off readiness probe.                                                                                                                    | `true`                                                  |
| `readinessProbe.initialDelaySeconds`          | Delay before readiness probe is initiated.                                                                                                          | `5`                                                     |
| `readinessProbe.periodSeconds`                | How often to perform the probe.                                                                                                                     | `10`                                                    |
| `readinessProbe.timeoutSeconds`               | When the probe times out.                                                                                                                           | `1`                                                     |
| `readinessProbe.successThreshold`             | Minimum consecutive successes for the probe to be considered successful after having failed.                                                        | `1`                                                     |
| `readinessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                          | `5`                                                     |
| `priorityClassName`                           | Redis Master pod priorityClassName                                                                                                                  | {}                                                      |
| `volumePermissions.enabled`                   | Enable init container that changes volume permissions in the registry (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                 |
| `volumePermissions.image.registry`            | Init container volume-permissions image registry                                                                                                    | `docker.io`                                             |
| `volumePermissions.image.repository`          | Init container volume-permissions image name                                                                                                        | `bitnami/minideb`                                       |
| `volumePermissions.image.tag`                 | Init container volume-permissions image tag                                                                                                         | `buster`                                                |
| `volumePermissions.image.pullPolicy`          | Init container volume-permissions image pull policy                                                                                                 | `Always`                                                |
| `volumePermissions.resources`                 | Init container volume-permissions CPU/Memory resource requests/limits                                                                               | {}                                                      |
| `sysctlImage.enabled`                         | Enable an init container to modify Kernel settings                                                                                                  | `false`                                                 |
| `sysctlImage.command`                         | sysctlImage command to execute                                                                                                                      | []                                                      |
| `sysctlImage.registry`                        | sysctlImage Init container registry                                                                                                                 | `docker.io`                                             |
| `sysctlImage.repository`                      | sysctlImage Init container name                                                                                                                     | `bitnami/minideb`                                       |
| `sysctlImage.tag`                             | sysctlImage Init container tag                                                                                                                      | `buster`                                                |
| `sysctlImage.pullPolicy`                      | sysctlImage Init container pull policy                                                                                                              | `Always`                                                |
| `sysctlImage.mountHostSys`                    | Mount the host `/sys` folder to `/host-sys`                                                                                                         | `false`                                                 |
| `sysctlImage.resources`                       | sysctlImage Init container CPU/Memory resource requests/limits                                                                                      | {}                                                      |
| `podSecurityPolicy.create`                    | Specifies whether a PodSecurityPolicy should be created                                                                                             | `false`                                                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set password=secretpassword \
    stable/redis
```

The above command sets the Redis server password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml stable/redis
```

> **Tip**: You can use the default [values.yaml](values.yaml)

> **Note for minikube users**: Current versions of minikube (v0.24.1 at the time of writing) provision `hostPath` persistent volumes that are only writable by root. Using chart defaults cause pod failure for the Redis pod as it attempts to write to the `/bitnami` directory. Consider installing Redis with `--set persistence.enabled=false`. See minikube issue [1990](https://github.com/kubernetes/minikube/issues/1990) for more information.

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

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

### Cluster topologies

#### Default: Master-Slave

When installing the chart with `cluster.enabled=true`, it will deploy by default 3 redis masters and 3 replicas. By default the Redis Cluster is not accessible from outside the Kubernetes cluster, to the Redis cluster to the outside set `cluster.externalAccess.enabled=true`, it will create in the first installation only 6 LoadBalancer services, one for each Redis node, once you have the external IPs of each service you will need to perform an upgrade passing those IPs to the `cluster.externalAccess.service.loadbalancerIP` array.

The replicas will be read-only replicas of the masters. By default only one service is exposed (when not using the external access mode). You will connect your client to the exposed service, regardless you need to read or write. When a write operation arrives to a replica it will redirect the client to the master node. For example, using `redis-cli` you will need to provide the `-c` flag for `redis-cli` to follow the redirection automatically.

Using the external access mode, you can connect to any of the pods and the slaves will redirect the client in the same way as exaplined before, but the all the IPs will be public.

In case the master crashes, one of his slaves will be promoted to master. The slots stored by the crashed master will be unavailable until the slave finish the promotion. If a master and all his slaves crash, the cluster will be down until one of them is up again. To avoid downtime, it is possible to configure the number of Redis nodes with `cluster.nodes` and the number of replicas that will be assigned to each master with `cluster.replicas`. For example:
  - `cluster.nodes=9` ( 3 master plus 2 replicas for each master)
  - `cluster.replicas=2`

Providing the values above, the cluster will have 3 masters and, each master, will have 2 replicas.

### Using password file
To use a password file for Redis you need to create a secret containing the password.

> *NOTE*: It is important that the file with the password must be called `redis-password`

And then deploy the Helm Chart using the secret name as parameter:

```console
usePassword=true
usePasswordFile=true
existingSecret=redis-password-secret
metrics.enabled=true
```

### Metrics

The chart optionally can start a metrics exporter for [prometheus](https://prometheus.io). The metrics endpoint (port 9121) is exposed in the service. Metrics can be scraped from within the cluster using something similar as the described in the [example Prometheus scrape configuration](https://github.com/prometheus/prometheus/blob/master/documentation/examples/prometheus-kubernetes.yml). If metrics are to be scraped from outside the cluster, the Kubernetes API proxy can be utilized to access the endpoint.

### Host Kernel Settings
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
      install_packages procps
      sysctl -w net.core.somaxconn=10000
      echo never > /host-sys/kernel/mm/transparent_hugepage/enabled
```

Alternatively, for Kubernetes 1.12+ you can set `securityContext.sysctls` which will configure sysctls for master and slave pods. Example:

```yaml
securityContext:
  sysctls:
  - name: net.core.somaxconn
    value: "10000"
```

Note that this will not disable transparent huge tables.

## Persistence

By default, the chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at the `/data` path. The volume is created using dynamic volume provisioning. If a Persistent Volume Claim already exists, specify it during installation.

### Existing PersistentVolumeClaim

1. Create the PersistentVolume
2. Create the PersistentVolumeClaim
3. Install the chart

```bash
$ helm install my-release --set persistence.existingClaim=PVC_NAME stable/redis
```

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

With `networkPolicy.ingressNSMatchLabels` pods from other namespaces can connect to redis. Set `networkPolicy.ingressNSPodMatchLabels` to match pod labels in matched namespace. For example, for a namespace labeled `redis=external` and pods in that namespace labeled `redis-client=true` the fields should be set:

```
networkPolicy:
  enabled: true
  ingressNSMatchLabels:
    redis: external
  ingressNSPodMatchLabels:
    redis-client: true
```

## Upgrading an existing Release to a new major version

A major chart version change (like v1.2.3 -> v2.0.0) indicates that there is an
incompatible breaking change needing manual actions.

### To 11.0.0

**Major refactor of the complete Helm Chart**
Using the master/slave topology it will create by default a 6 nodes Redis Cluster containing 3 masters and 3 slaves.
Redis Sentinel is no more necessary as the Redis Cluster topology manages the failover.
Only one statefulset will be deployed without previous knowledge of which pods will be masters and which ones will be slaves.
For external access, it is needed to provide a LoadBalancerIP for each redis node.

### To 10.0.0

For releases with `usePassword: true`, the value `sentinel.usePassword` controls whether the password authentication also applies to the sentinel port. This defaults to `true` for a secure configuration, however it is possible to disable to account for the following cases:
* Using a version of redis-sentinel prior to `5.0.1` where the authentication feature was introduced.
* Where redis clients need to be updated to support sentinel authentication.

If using a master/slave topology, or with `usePassword: false`, no action is required.

### To 8.0.18

For releases with `metrics.enabled: true` the default tag for the exporter image is now `v1.x.x`. This introduces many changes including metrics names. You'll want to use [this dashboard](https://github.com/oliver006/redis_exporter/blob/master/contrib/grafana_prometheus_redis_dashboard.json) now. Please see the [redis_exporter github page](https://github.com/oliver006/redis_exporter#upgrading-from-0x-to-1x) for more details.

### To 7.0.0

This version causes a change in the Redis Master StatefulSet definition, so the command helm upgrade would not work out of the box. As an alternative, one of the following could be done:

  - Recommended: Create a clone of the Redis Master PVC (for example, using projects like [this one](https://github.com/edseymour/pvc-transfer)). Then launch a fresh release reusing this cloned PVC.

   ```
   helm install my-release stable/redis --set persistence.existingClaim=<NEW PVC>
   ```

  - Alternative (not recommended, do at your own risk): `helm delete --purge` does not remove the PVC assigned to the Redis Master StatefulSet. As a consequence, the following commands can be done to upgrade the release

   ```
   helm delete --purge <RELEASE>
   helm install <RELEASE> stable/redis
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

## Notable changes

### 9.0.0
The metrics exporter has been changed from a separate deployment to a sidecar container, due to the latest changes in the Redis exporter code. Check the [official page](https://github.com/oliver006/redis_exporter/) for more information. The metrics container image was changed from oliver006/redis_exporter to bitnami/redis-exporter (Bitnami's maintained package of oliver006/redis_exporter).

### 7.0.0
In order to improve the performance in case of slave failure, we added persistence to the read-only slaves. That means that we moved from Deployment to StatefulSets. This should not affect upgrades from previous versions of the chart, as the deployments did not contain any persistence at all.

This version also allows enabling Redis Sentinel containers inside of the Redis Pods (feature disabled by default). In case the master crashes, a new Redis node will be elected as master. In order to query the current master (no redis master service is exposed), you need to query first the Sentinel cluster. Find more information [in this section](#master-slave-with-sentinel).
