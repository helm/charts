# Redis

[Redis](http://redis.io/) is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

## TL;DR;

```bash
$ helm install stable/redis-ha
```

By default this chart install 3 pods total:
 * one pod containing a redis master and sentinel container (optional prometheus metrics exporter sidecar available)
 * two pods each containing a redis slave and sentinel containers (optional prometheus metrics exporter sidecars available)

## Introduction

This chart bootstraps a [Redis](https://redis.io) highly available master/slave statefulset in a [Kubernetes](http://kubernetes.io) cluster using the Helm package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Upgrading the Chart

Please note that there have been a number of changes simplifying the redis management strategy (for better failover and elections) in the 3.x version of this chart. These changes allow the use of official [redis](https://hub.docker.com/_/redis/) images that do not require special RBAC or ServiceAccount roles. As a result when upgrading from version >=2.0.1 to >=3.0.0 of this chart, `Role`, `RoleBinding`, and `ServiceAccount` resources should be deleted manually.

### Upgrading the chart from 3.x to 4.x

Starting from version `4.x` HAProxy sidecar prometheus-exporter removed and replaced by by the embedded [HAProxy metrics endpoint](https://github.com/haproxy/haproxy/tree/master/contrib/prometheus-exporter), as a result when upgrading from version 3.x to 4.x section `haproxy.exporter` should be removed and the `haproxy.metrics` need to be configured for fit your needs.

## Installing the Chart

To install the chart

```bash
$ helm install stable/redis-ha
```

The command deploys Redis on the Kubernetes cluster in the default configuration. By default this chart install one master pod containing redis master container and sentinel container along with 2 redis slave pods each containing their own sentinel sidecars. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the deployment:

```bash
$ helm delete <chart-name>
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Redis chart and their default values.

| Parameter                 | Description                                                                                                                                                                                              | Default                                                                                    |
|:--------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------|
| `image`                   | Redis image                                                                                                                                                                                              | `redis`                                                                                    |
| `tag`                     | Redis tag                                                                                                                                                                                                | `5.0.6-alpine`                                                                             |
| `replicas`                | Number of redis master/slave pods                                                                                                                                                                        | `3`                                                                                        |
| `serviceAccount.create`   | Specifies whether a ServiceAccount should be created                                                                                                                                                     | `true`                                                                                     |
| `serviceAccount.name`     | The name of the ServiceAccount to create                                                                                                                                                                 | Generated using the redis-ha.fullname template                                             |
| `rbac.create`             | Create and use RBAC resources                                                                                                                                                                            | `true`                                                                                     |
| `redis.port`              | Port to access the redis service                                                                                                                                                                         | `6379`                                                                                     |
| `redis.masterGroupName`   | Redis convention for naming the cluster group: must match `^[\\w-\\.]+$` and can be templated                                                                                                            | `mymaster`                                                                                 |
| `redis.config`            | Any valid redis config options in this section will be applied to each server (see below)                                                                                                                | see values.yaml                                                                            |
| `redis.customConfig`      | Allows for custom redis.conf files to be applied. If this is used then `redis.config` is ignored                                                                                                         | ``                                                                                         |
| `redis.resources`         | CPU/Memory for master/slave nodes resource requests/limits                                                                                                                                               | `{}`                                                                                       |
| `sentinel.port`           | Port to access the sentinel service                                                                                                                                                                      | `26379`                                                                                    |
| `sentinel.quorum`         | Minimum number of servers necessary to maintain quorum                                                                                                                                                   | `2`                                                                                        |
| `sentinel.config`         | Valid sentinel config options in this section will be applied as config options to each sentinel (see below)                                                                                             | see values.yaml                                                                            |
| `sentinel.customConfig`   | Allows for custom sentinel.conf files to be applied. If this is used then `sentinel.config` is ignored                                                                                                   | ``                                                                                         |
| `sentinel.resources`      | CPU/Memory for sentinel node resource requests/limits                                                                                                                                                    | `{}`                                                                                       |
| `init.resources`          | CPU/Memory for init Container node resource requests/limits                                                                                                                                              | `{}`                                                                                       |
| `auth`                    | Enables or disables redis AUTH (Requires `redisPassword` to be set)                                                                                                                                      | `false`                                                                                    |
| `redisPassword`           | A password that configures a `requirepass` and `masterauth` in the conf parameters (Requires `auth: enabled`)                                                                                            | ``                                                                                         |
| `authKey`                 | The key holding the redis password in an existing secret.                                                                                                                                                | `auth`                                                                                     |
| `existingSecret`          | An existing secret containing a key defined by `authKey` that configures `requirepass` and `masterauth` in the conf parameters (Requires `auth: enabled`, cannot be used in conjunction with `.Values.redisPassword`) | ``                                                                            |
| `nodeSelector`            | Node labels for pod assignment                                                                                                                                                                           | `{}`                                                                                       |
| `tolerations`             | Toleration labels for pod assignment                                                                                                                                                                     | `[]`                                                                                       |
| `hardAntiAffinity`        | Whether the Redis server pods should be forced to run on separate nodes.                                                                                                                                 | `true`                                                                                     |
| `additionalAffinities`    | Additional affinities to add to the Redis server pods.                                                                                                                                                   | `{}`                                                                                       |
| `securityContext`    | Security context to be added to the Redis server pods.                                                                                                                                                        | `{runAsUser: 1000, fsGroup: 1000, runAsNonRoot: true}`                                     |
| `affinity`                | Override all other affinity settings with a string.                                                                                                                                                      | `""`                                                                                       |
| `exporter.enabled`        | If `true`, the prometheus exporter sidecar is enabled                                                                                                                                                    | `false`                                                                                    |
| `exporter.image`          | Exporter image                                                                                                                                                                                           | `oliver006/redis_exporter`                                                                 |
| `exporter.tag`            | Exporter tag                                                                                                                                                                                             | `v0.31.0`                                                                                  |
| `exporter.port`           | Exporter port                                                                                                                                                                                            | `9121`                                                                                     |
| `exporter.annotations`    | Prometheus scrape annotations                                                                                                                                                                            | `{prometheus.io/path: /metrics, prometheus.io/port: "9121", prometheus.io/scrape: "true"}` |
| `exporter.extraArgs`      | Additional args for the exporter                                                                                                                                                                         | `{}`                                                                                       |
| `exporter.serviceMonitor.enabled`       | Use servicemonitor from prometheus operator                                                                                                                                                         | `false`                                                                                    |
| `exporter.serviceMonitor.namespace`     | Namespace the service monitor is created in                                                                                                                                                         | `default`                                                                                  |
| `exporter.serviceMonitor.interval`      | Scrape interval, If not set, the Prometheus default scrape interval is used                                                                                                                         | `nil`                                                                                      |
| `exporter.serviceMonitor.telemetryPath` | Path to redis-exporter telemetry-path                                                                                                                                                               | `/metrics`                                                                                 |
| `exporter.serviceMonitor.labels`        | Labels for the servicemonitor passed to Prometheus Operator                                                                                                                                         | `{}`                                                                                       |
| `exporter.serviceMonitor.timeout`       | How long until a scrape request times out. If not set, the Prometheus default scape timeout is used                                                                                                 | `nil`                                                                                      |
| `haproxy.enabled`         | Enabled HAProxy LoadBalancing/Proxy                                                                                                                                                                      | `false`                                                                                    |
| `haproxy.replicas`        | Number of HAProxy instances                                                                                                                                                                              | `3`                                                                                        |
| `haproxy.image.repository`| HAProxy Image Repository                                                                                                                                                                                 | `haproxy`                                                                                  |
| `haproxy.image.tag`       | HAProxy Image Tag                                                                                                                                                                                        | `2.0.1`                                                                                    |
| `haproxy.image.pullPolicy`| HAProxy Image PullPolicy                                                                                                                                                                                 | `IfNotPresent`                                                                             |
| `haproxy.annotations`     | HAProxy template annotations                                                                                                                                                                             | `{}`                                                                                       |
| `haproxy.customConfig`    | Allows for custom config-haproxy.cfg file to be applied. If this is used then default config will be overwriten                                                                                          | ``                                                                                        |
| `haproxy.extraConfig`     | Allows to place any additional configuration section to add to the default config-haproxy.cfg                                                                                                            | ``                                                                                        |
| `haproxy.resources`       | HAProxy resources                                                                                                                                                                                        | `{}`                                                                                       |
| `haproxy.service.type`    | HAProxy service type "ClusterIP", "LoadBalancer" or "NodePort"                                                                                                                                           | `ClusterIP`                                                                                |
| `haproxy.service.nodePort`    | HAProxy service nodePort value (haproxy.service.type must be NodePort)                                                                                                                               | not set                                                                                    |
| `haproxy.service.annotations` | HAProxy service annotations                                                                                                                                                                          | `{}`                                                                                       |
| `haproxy.hapreadport.enable`  | Enable a read only port for redis slaves                                                                                                                                                                           | `false`                                                                        |
| `haproxy.hapreadport.port`    | Haproxy port for read only redis slaves                                                                                                                                                                          | `6380`                                                                           |
| `haproxy.metrics.enabled`     | HAProxy enable prometheus metric scraping                                                                                                                                                            | `false`                                                                                       |
| `haproxy.metrics.port`        | HAProxy prometheus metrics scraping port                                                                                                                                                             | `9101`                                                                                       |
| `haproxy.metrics.portName`    | HAProxy metrics scraping port name                                                                                                                                                                   | `exporter-port`                                                                                       |
| `haproxy.metrics.scrapePath`  | HAProxy prometheus metrics scraping port                                                                                                                                                             | `/metrics`                                                                                       |
| `haproxy.metrics.serviceMonitor.enabled`       | Use servicemonitor from prometheus operator for HAProxy metrics                                                                                                                                                        | `false`                                                                                    |
| `haproxy.metrics.serviceMonitor.namespace`     | Namespace the service monitor for HAProxy metrics is created in                                                                                                                                                         | `default`                                                                                  |
| `haproxy.metrics.serviceMonitor.interval`      | Scrape interval, If not set, the Prometheus default scrape interval is used                                                                                                                         | `nil`                                                                                      |
| `haproxy.metrics.serviceMonitor.telemetryPath` | Path to HAProxy metrics telemetry-path                                                                                                                                                               | `/metrics`                                                                                 |
| `haproxy.metrics.serviceMonitor.labels`        | Labels for the HAProxy metrics servicemonitor passed to Prometheus Operator                                                                                                                                         | `{}`                                                                                       |
| `haproxy.metrics.serviceMonitor.timeout`       | How long until a scrape request times out. If not set, the Prometheus default scape timeout is used                                                                                                 | `nil`                                                                                      |
| `haproxy.init.resources`  | Extra init resources                                                                                                                                                                                     | `{}`                                                                                       |
| `haproxy.timeout.connect` | haproxy.cfg `timeout connect` setting                                                                                                                                                                    | `4s`                                                                                       |
| `haproxy.timeout.server`  | haproxy.cfg `timeout server` setting                                                                                                                                                                     | `30s`                                                                                      |
| `haproxy.timeout.client`  | haproxy.cfg `timeout client` setting                                                                                                                                                                     | `30s`                                                                                      |
| `haproxy.priorityClassName` | priorityClassName for `haproxy` deployment                                                                                                                                                             | not set                                                                                    |
| `haproxy.securityContext`    | Security context to be added to the HAProxy deployment.                                                                                                                                               | `{runAsUser: 1000, fsGroup: 1000, runAsNonRoot: true}`                                     |
| `haproxy.hardAntiAffinity`        | Whether the haproxy pods should be forced to run on separate nodes.                                                                                                                                 | `true`                                                                                     |
| `haproxy.affinity`                | Override all other haproxy affinity settings with a string.                                                                                                                                                      | `""`                                                                                       |
| `haproxy.additionalAffinities`    | Additional affinities to add to the haproxy server pods.                                                                                                                                                   | `{}`                                                                                       |
| `podDisruptionBudget`     | Pod Disruption Budget rules                                                                                                                                                                              | `{}`                                                                                       |
| `priorityClassName`       | priorityClassName for `redis-ha-statefulset`                                                                                                                                                             | not set                                                                                    |
| `hostPath.path`           | Use this path on the host for data storage                                                                                                                                                               | not set                                                                                    |
| `hostPath.chown`          | Run an init-container as root to set ownership on the hostPath                                                                                                                                           | `true`                                                                                     |
| `sysctlImage.enabled`     | Enable an init container to modify Kernel settings                                                                                                                                                       | `false`                                                                                    |
| `sysctlImage.command`     | sysctlImage command to execute                                                                                                                                                                           | []                                                                                         |
| `sysctlImage.registry`    | sysctlImage Init container registry                                                                                                                                                                      | `docker.io`                                                                                |
| `sysctlImage.repository`  | sysctlImage Init container name                                                                                                                                                                          | `busybox`                                                                                  |
| `sysctlImage.tag`         | sysctlImage Init container tag                                                                                                                                                                           | `1.31.1`                                                                                   |
| `sysctlImage.pullPolicy`  | sysctlImage Init container pull policy                                                                                                                                                                   | `Always`                                                                                   |
| `sysctlImage.mountHostSys`| Mount the host `/sys` folder to `/host-sys`                                                                                                                                                              | `false`                                                                                    |
| `schedulerName`           | Alternate scheduler name                                                                                                                                                                                 | `nil`                                                                                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install \
  --set image=redis \
  --set tag=5.0.5-alpine \
    stable/redis-ha
```

The above command sets the Redis server within `default` namespace.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install -f values.yaml stable/redis-ha
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Custom Redis and Sentinel config options

This chart allows for most redis or sentinel config options to be passed as a key value pair through the `values.yaml` under `redis.config` and `sentinel.config`. See links below for all available options.

[Example redis.conf](http://download.redis.io/redis-stable/redis.conf)
[Example sentinel.conf](http://download.redis.io/redis-stable/sentinel.conf)

For example `repl-timeout 60` would be added to the `redis.config` section of the `values.yaml` as:

```yml
    repl-timeout: "60"
```

Note:

1. Some config options should be renamed by redis version，e.g.:

   ```
   # In redis 5.x，see https://raw.githubusercontent.com/antirez/redis/5.0/redis.conf
   min-replicas-to-write: 1
   min-replicas-max-lag: 5

   # In redis 4.x and redis 3.x，see https://raw.githubusercontent.com/antirez/redis/4.0/redis.conf and https://raw.githubusercontent.com/antirez/redis/3.0/redis.conf
   min-slaves-to-write 1
   min-slaves-max-lag 5
   ```

Sentinel options supported must be in the the `sentinel <option> <master-group-name> <value>` format. For example, `sentinel down-after-milliseconds 30000` would be added to the `sentinel.config` section of the `values.yaml` as:

```yml
    down-after-milliseconds: 30000
```

If more control is needed from either the redis or sentinel config then an entire config can be defined under `redis.customConfig` or `sentinel.customConfig`. Please note that these values will override any configuration options under their respective section. For example, if you define `sentinel.customConfig` then the `sentinel.config` is ignored.

## Host Kernel Settings
Redis may require some changes in the kernel of the host machine to work as expected, in particular increasing the `somaxconn` value and disabling transparent huge pages.
To do so, you can set up a privileged initContainer with the `sysctlImage` config values, for example:
```
sysctlImage:
  enabled: true
  mountHostSys: true
  command:
    - /bin/sh
    - -xc
    - |-
      sysctl -w net.core.somaxconn=10000
      echo never > /host-sys/kernel/mm/transparent_hugepage/enabled
```

## HAProxy startup

When HAProxy is enabled, it will attempt to connect to each announce-service of each redis replica instance in its init container before starting.
It will fail if announce-service IP is not available fast enough (10 seconds max by announce-service).
A such case could happen if the orchestator is pending the nomination of redis pods.
Risk is limited because announce-service is using `publishNotReadyAddresses: true`, although, in such case, HAProxy pod will be rescheduled afterward by the orchestrator.
