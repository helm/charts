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
| `tag`                     | Redis tag                                                                                                                                                                                                | `5.0.5-alpine`                                                                             |
| `replicas`                | Number of redis master/slave pods                                                                                                                                                                        | `3`                                                                                        |
| `serviceAccount.create`   | Specifies whether a ServiceAccount should be created                                                                                                                                                     | `true`                                                                                     |
| `serviceAccount.name`     | The name of the ServiceAccount to create                                                                                                                                                                 | Generated using the redis-ha.fullname template                                             |
| `rbac.create`             | Create and use RBAC resources                                                                                                                                                                            | `true`                                                                                     |
| `redis.port`              | Port to access the redis service                                                                                                                                                                         | `6379`                                                                                     |
| `redis.masterGroupName`   | Redis convention for naming the cluster group                                                                                                                                                            | `mymaster`                                                                                 |
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
| `existingSecret`          | An existing secret containing a key defined by `authKey` that configures `requirepass` and `masterauth` in the conf parameters (Requires `auth: enabled`, cannot be used in conjunction with `.Values.redisPassword`) | ``                                                                                         |
| `nodeSelector`            | Node labels for pod assignment                                                                                                                                                                           | `{}`                                                                                       |
| `tolerations`             | Toleration labels for pod assignment                                                                                                                                                                     | `[]`                                                                                       |
| `hardAntiAffinity`        | Whether the Redis server pods should be forced to run on separate nodes.                                                                                                                                  | `true`                                                                                     |
| `additionalAffinities`    | Additional affinities to add to the Redis server pods.                                                                                                                                                    | `{}`                                                                                       |
| `affinity`                | Override all other affinity settings with a string.                                                                                                                                                      | `""`                                                                                       |
| `exporter.enabled`        | If `true`, the prometheus exporter sidecar is enabled                                                                                                                                                    | `false`                                                                                    |
| `exporter.image`          | Exporter image                                                                                                                                                                                           | `oliver006/redis_exporter`                                                                 |
| `exporter.tag`            | Exporter tag                                                                                                                                                                                             | `v1.1.0`                                                                                  |
| `exporter.annotations`    | Prometheus scrape annotations                                                                                                                                                                            | `{prometheus.io/path: /metrics, prometheus.io/port: "9121", prometheus.io/scrape: "true"}` |
| `exporter.extraArgs`      | Additional args for the exporter                                                                                                                                                                         | `{}`                                                                                       |
| `haproxy.enabled`         | Enabled HAProxy LoadBalancing/Proxy                                                                                                                                                                      | `false`                                                                                       |
| `haproxy.replicas`        | Number of HAProxy instances                                                                                                                                                                              | `1`                                                                                       |
| `haproxy.image.repository`| HAProxy Image Repository                                                                                                                                                                                 | `haproxy`                                                                                       |
| `haproxy.image.tag`       | HAProxy Image Tag                                                                                                                                                                                        | `2.0.1`                                                                                       |
| `haproxy.image.pullPolicy`| HAProxy Image PullPolicy                                                                                                                                                                                 | `IfNotPresent`                                                                                       |
| `haproxy.annotations`     | HAProxy template annotations                                                                                                                                                                             | `{}`                                                                                       |
| `haproxy.resources`       | HAProxy resources                                                                                                                                                                                        | `{}`                                                                                       |
| `haproxy.service.type`    | HAProxy service type "ClusterIP" or "LoadBalancer"                                                                                                                                                       | `ClusterIP`                                                                                       |
| `haproxy.service.annotations` | HAProxy service annotations                                                                                                                                                                          | `{}`                                                                                       |
| `haproxy.exporter.enabled`| Enable Prometheus metric scraping                                                                                                                                                                        | `false`                                                                                       |
| `haproxy.exporter.port`   | Prometheus metric scraping port                                                                                                                                                                          | `9101`                                                                                       |
| `haproxy.init.resources`  | Extra init resources                                                                                                                                                                                     | `{}`                                                                                       |
| `podDisruptionBudget`     | Pod Disruption Budget rules                                                                                                                                                                              | `{}`                                                                                       |
| `hostPath.path`           | Use this path on the host for data storage                                                                                                                                                               | not set                                                                                    |
| `hostPath.chown`          | Run an init-container as root to set ownership on the hostPath                                                                                                                                           | `true`                                                                                       |
| `sysctlImage.enabled`     | Enable an init container to modify Kernel settings                                                             | `false`                                              |
| `sysctlImage.command`     | sysctlImage command to execute                                                                                 | []                                                   |
| `sysctlImage.registry`    | sysctlImage Init container registry                                                                            | `docker.io`                                          |
| `sysctlImage.repository`  | sysctlImage Init container name                                                                                | `bitnami/minideb`                                    |
| `sysctlImage.tag`         | sysctlImage Init container tag                                                                                 | `latest`                                             |
| `sysctlImage.pullPolicy`  | sysctlImage Init container pull policy                                                                         | `Always`                                             |
| `sysctlImage.mountHostSys`| Mount the host `/sys` folder to `/host-sys`                                                                    | `false`                                              |
| `schedulerName`           | Alternate scheduler name                                                                                       | `nil`                                                |

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
    - -c
    - |-
      install_packages systemd
      sysctl -w net.core.somaxconn=10000
      echo never > /host-sys/kernel/mm/transparent_hugepage/enabled
```
