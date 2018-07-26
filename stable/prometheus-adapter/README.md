# Prometheus Adapter

* Installs [Prometheus-adapter](https://github.com/DirectXMan12/k8s-prometheus-adapter).

## TL;DR;

```console
$ helm install stable/prometheus-adapter
```

## Introduction

This charts install the [Prometheus Adapter](https://github.com/DirectXMan12/k8s-prometheus-adapter) on your kubernetes clutser using the [Helm](https://helm.sh) package manager.

## Prerequisites

Kubernetes 1.9+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/prometheus-adapter
```

This command deploys the prometheus operator with the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Prometheus Adapter chart and their default values.

| Parameter                       | Description                                                                     | Default                                     |
| ------------------------------- | ------------------------------------------------------------------------------- | --------------------------------------------|
| `image.repository`              | Image repository                                                                | `directxman12/k8s-prometheus-adapter-amd64` |
| `image.tag`                     | Image tag                                                                       | `latest`                                    |
| `image.pullPolicy`              | Image pull policy                                                               | `IfNotPresent`                              |
| `resources.limits.cpu`          | CPU limit                                                                       | `100m`                                      |
| `resources.limits.memory`       | Memory limit                                                                    | `128Mi`                                     |
| `resources.requests.cpu`        | CPU request                                                                     | `100m`                                      |
| `resources.requests.memory`     | Memory request                                                                  | `128Mi`                                     |
| `rbac.create`                   | If true, create & use RBAC resources                                            | `true`                                      |
| `serviceaccount.create`         | If true, create & use Serviceaccount                                            | `true`                                      |
| `serviceaccount.name`           | If not set and create is true, a name is generated using the fullname template  | ``                                          |
| `tls.enable`                    | If true, setup & use secret for TLS                                             | `false`                                     |
| `tls.ca`                        | Public CA file that signed the APIService (ignored if tls.enable=false)         | ``                                          |
| `tls.key`                       | Private key of the APIService (ignored if tls.enable=false)                     | ``                                          |
| `tls.certificate`               | Public key of the APIService (ignored if tls.enable=false)                      | ``                                          |
| `prometheus.url`                | Url of where we can find the Prometheus service                                 | `http://prometheus.default.svc`             |
| `prometheus.port`               | Port of where we can find the Prometheus service                                | `9090`                                      |
| `metricsRelistInterval`         | Interval at which to re-list the set of all available metrics from Prometheus   | `30s`                                       |
| `logLevel`                      | Log level                                                                       | `10`                                        |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set logLevel=1 \
 stable/prometheus-adapter
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/prometheus-adapter
```
