# Prometheus statsd-exporter

## TL;DR;

```console
$ helm install incubator/prometheus-statsd-exporter
```

## Introduction

This chart bootstraps a prometheus-statsd-exporter deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install incubator/prometheus-statsd-exporter --name my-release
```


The command deploys prometheus-statsd-exporter on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

|Parameter                   | Description                                          | Default                                |
|`extraArgs`                 | key:value list of extra arguments to give the binary | `{}`                                   |
|`image.pullPolicy`          | Image pull policy                                    | `IfNotPresent`                         |
|`image.repository`          | Image repository                                     | `prom/statsd-exporter`                 |
|`image.tag`                 | Image tag                                            | `v0.8.0`                               |
|`ingress.enabled`           | enable ingress                                       | `false`                                |
|`ingress.path`              | ingress base path                                    | `/`                                    |
|`ingress.host`              | Ingress accepted hostnames                           | `nil`                                  |
|`ingress.tls`               | Ingress TLS configuration                            | `[]`                                   |
|`ingress.annotations`       | Ingress annotations                                  | `{}`                                   |
|`service.type`              | type of service                                      | `ClusterIP`                            |
|`tolerations`               | List of node taints to tolerate                      | `[]`                                   |
|`resources`                 | pod resource requests & limits                       | `{}`                                   |   
| `persistence.enabled`      | Create a volume to store data                        | true                                   |

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install incubator/prometheus-statsd-exporter --name my-release -f values.yaml
```
> **Tip**: You can use the default [values.yaml](values.yaml)