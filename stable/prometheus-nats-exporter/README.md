# Prometheus NATS Exporter

DEPRECATED and moved to <https://github.com/prometheus-community/helm-charts>

* Installs prometheus [NATS exporter](https://github.com/nats-io/prometheus-nats-exporter)

## TL;DR;

```console
$ helm install incubator/prometheus-nats-exporter
```

## Introduction

This chart bootstraps a prometheus [NATS exporter](https://github.com/nats-io/prometheus-nats-exporter) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/prometheus-nats-exporter
```

The command deploys NATS exporter on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the postgres Exporter chart and their default values.

| Parameter                         | Description                                             | Default                                          |
| --------------------------------- | ------------------------------------------------------- | ------------------------------------------------ |
| `image`                           | Image                                                   | `synadia/prometheus-nats-exporter`               |
| `imageTag`                        | Image tag                                               | `0.6.2`                                          |
| `imagePullPolicy`                 | Image pull policy                                       | `IfNotPresent`                                   |
| `service.type`                    | Service type                                            | `ClusterIP`                                      |
| `service.port`                    | The service port                                        | `80`                                             |
| `service.targetPort`              | The target port of the container                        | `7777`                                           |
| `serviceMonitor.enabled`          | Set to true if using the Prometheus Operator            | `false`                                          |
| `serviceMonitor.interval`         | Interval at which metrics should be scraped             | ``                                               |
| `serviceMonitor.namespace`        | The namespace where the Prometheus Operator is deployed | ``                                               |
| `serviceMonitor.additionalLabels` | Additional labels to add to the ServiceMonitor          | `{}`                                             |
| `resources`                       |                                                         | `{}`                                             |
| `config.nats.service`             | NATS monitoring [service name][svc-name]                | `nats-nats-monitoring`                           |
| `config.nats.namespace`           | Namespace in which NATS deployed                        | `default`                                        |
| `config.nats.port`                | NATS monitoring service port                            | `8222`                                           |
| `config.metrics.varz`             | NATS varz metrics                                       | `true`                                           |
| `config.metrics.channelz`         | NATS channelz metrics                                   | `true`                                           |
| `config.metrics.connz`            | NATS connz metrics                                      | `true`                                           |
| `config.metrics.routez`           | NATS routez metrics                                     | `true`                                           |
| `config.metrics.serverz`          | NATS serverz metrics                                    | `true`                                           |
| `config.metrics.subz`             | NATS subz metrics                                       | `true`                                           |
| `config.metrics.gatewayz          | NATS gatewayz metrics                                   | `true`                                           |
| `tolerations`                     | Add tolerations                                         | `[]`                                             |
| `nodeSelector`                    | node labels for pod assignment                          | `{}`                                             |
| `affinity`                        | node/pod affinities                                     | `{}`                                             |
| `annotations`                     | Deployment annotations                                  | `{}`                                             |
| `extraContainers`                 | Additional sidecar containers                           | `""`                                             |
| `extraVolumes`                    | Additional volumes for use in extraContainers           | `""`                                             |

[svc-name]: https://github.com/helm/charts/blob/master/stable/nats/templates/monitoring-svc.yaml

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release stable/prometheus-nats-exporter \
  --set config.nats.service=nats-production-nats-monitoring \
  --set config.metrics.subz=false
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release stable/prometheus-nats-exporter -f values.yaml
```
