# prometheus-redis-exporter

[redis_exporter](https://github.com/oliver006/redis_exporter) is a Prometheus exporter for Redis metrics.

## TL;DR;

```bash
$ helm install stable/prometheus-redis-exporter
```

## Introduction

This chart bootstraps a [redis_exporter](https://github.com/oliver006/redis_exporter) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/prometheus-redis-exporter
```

The command deploys prometheus-redis-exporter on the Kubernetes cluster in the default configuration.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters and their default values.

| Parameter              | Description                                         | Default                   |
| ---------------------- | --------------------------------------------------- | ------------------------- |
| `replicaCount`         | desired number of prometheus-redis-exporter pods    | `1`                       |
| `image.repository`     | prometheus-redis-exporter image repository          | `oliver006/redis_exporter`|
| `image.tag`            | prometheus-redis-exporter image tag                 | `v0.28.0`                 |
| `image.pullPolicy`     | image pull policy                                   | `IfNotPresent`            |
| `image.pullSecrets`    | image pull secrets                                  | {}                        |
| `extraArgs`            | extra arguments for the binary; possible values [here](https://github.com/oliver006/redis_exporter#flags)| {}
| `env`                  | additional environment variables in YAML format. Can be used to pass credentials as env variables (via secret) as per the image readme [here](https://github.com/oliver006/redis_exporter#environment-variables) | {} |
| `resources`            | cpu/memory resource requests/limits                 | {}                        |
| `service.type`         | desired service type                                | `ClusterIP`               |
| `service.port`         | service external port                               | `9121`                    |
| `service.annotations`  | Custom annotations for service                      | `{}`                      |
| `service.labels`       | Additional custom labels for the service            | `{}`                      |
| `redisAddress`         | address of one or more redis nodes, comma separated | `redis://myredis:6379`    |
| `annotations`          | pod annotations for easier discovery                | {}                        |
| `rbac.create`           | Specifies whether RBAC resources should be created.| `true` |
| `rbac.pspEnabled`       | Specifies whether a PodSecurityPolicy should be created.| `true` |
| `serviceAccount.create` | Specifies whether a service account should be created.| `true` |
| `serviceAccount.name`   | Name of the service account.|        |
| `serviceMonitor.enabled`       | Use servicemonitor from prometheus operator            | `false`                    |
| `serviceMonitor.namespace`     | Namespace this servicemonitor is installed in          |                            |
| `serviceMonitor.interval`      | How frequently Prometheus should scrape                |                            |
| `serviceMonitor.telemetryPath` | Path to redis-exporter telemtery-path                  |                            |
| `serviceMonitor.labels`        | Labels for the servicemonitor passed to Prometheus Operator      |  `{}`            |
| `serviceMonitor.timeout`       | Timeout after which the scrape is ended                |                            |

For more information please refer to the [redis_exporter](https://github.com/oliver006/redis_exporter) documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set "redisAddress=redis://myredis:6379" \
    stable/prometheus-redis-exporter
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/prometheus-redis-exporter
```
