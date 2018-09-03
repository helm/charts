# prometheus-statsd-exporter

The [prometheus-statsd-exporter](https://github.com/prometheus/statsd_exporter) receives StatsD metrics and exports them as Prometheus metrics.

## Introduction

This chart creates a `prometheus-statsd-exporter` deployment using the [Helm](https://helm.sh) package manager.


## Prerequisites

- Kubernetes 1.9
- `prometheus-statsd-exporter` `v0.7.0`


## Installing the Chart

To install the chart with the release name `my-release` and default values:

```sh
$ helm install --name my-release stable/prometheus-statsd-exporter
```


## Uninstalling the Chart

To uninstall/delete `my-release`:

```sh
$ helm delete --purge my-release
```


## Configuration

The following table lists the configurable parameters of the `prometheus-statsd-exporter` chart and their default values.


|             Parameter               |            Description                   |                    Default                |
|-------------------------------------|------------------------------------------|-------------------------------------------|
| `replicaCount`                      | Number of pods to run                    | `1`                                       |
| `image.repository`                  | The docker image to run                  | `prom/statsd-exporter`                    |
| `image.tag`                         | The image tag to pull                    | `v0.7.0`                                  |
| `image.pullPolicy`                  | Image pull policy                        | `IfNotPresent`                            |
| `service.type`                      | Type of kubernetes service               | `ClusterIP`                               |
| `webPort`                           | Web port for metrics endpoint            | `9102`                                    |
| `udpPort`                           | UDP port to receive statsd metrics       | `9125`                                    |
| `tcpPort`                           | TCP port to receive statsd metrics       | `9125`                                    |
| `podAnnotations`                    | Annotations to add to pods               | `{}`                                      |
| `priorityClassName`                 | Priority class name                      | `""`                                      |
| `resources`                         | Pod resource requests & limits           | `{}`                                      |
| `nodeSelector`                      | Node labels for pod assignment           | `{}`                                      |
| `affinity`                          | Node affinity for pod assignment         | `{}`                                      |
| `tolerations`                       | Node tolerations for pod assignment      | `[]`                                      |
| `statsdMappingConfig`               | `statsd-exporter` mappings               | `""`                                      |


Specify each parameter you'd like to override using a YAML file.

```sh
$ helm install --name my-release stable/prometheus-statsd-exporter -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

You can also override specific values by using the `--set key=value[,key=value]` argument to `helm install`. For example, to change the `udpPort` to `8125`:

```sh
$ helm install stable/prometheus-statsd-exporter --name my-release --set udpPort=8125
```
