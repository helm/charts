# Consul-Exporter

Prometheus exporter for Consul metrics.
Learn more: https://github.com/prometheus/consul_exporter

## TL:DR

```bash
$ helm install stable/prometheus-consul-exporter
```
```bash
$ helm install stable/prometheus-consul-exporter --set consulServer=my.consul.com:8500
```

## Introduction

This chart creates a prometheus-consul-exporter deployment on a
[Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:
```bash
$ helm install --name my-release stable/prometheus-consul-exporter
```
```bash
$ helm install --name my-release stable/prometheus-consul-exporter --set consulServer=my.consul.com --set consulPort=8500
```

The command deploys prometheus-consul-exporter on the Kubernetes cluster using the
default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Cloudwatch Exporter chart and their default values.

| Parameter                         | Description                                                             | Default                     |
| --------------------------------- | ----------------------------------------------------------------------- | --------------------------- |
| `image.repository`                | Image                                                                   | `prom/consul-exporter`      |
| `image.tag`                       | Image tag                                                               | `v0.5.0`                    |
| `image.pullPolicy`                | Image pull policy                                                       | `IfNotPresent`              |
| `service.type`                    | Service type                                                            | `ClusterIP`                 |
| `service.port`                    | The service port                                                        | `9107`                      |
| `service.annotations`             | Custom annotations for service                                          | `{}`                        |
| `resources`                       | Request and Limits resources to be used by the container                | `{}`                        |
| `rbac.create`                     | If true, create & use RBAC resources                                    | `true`                      |
| `serviceAccount.create`           | Specifies whether a service account should be created.                  | `true`                      |
| `serviceAccount.name`             | Name of the service account.                                            |                             |
| `tolerations`                     | Add tolerations                                                         | `[]`                        |
| `nodeSelector`                    | node labels for pod assignment                                          | `{}`                        |
| `affinity`                        | node/pod affinities                                                     | `{}`                        |
| `servicemonitor.enabled`          | Use servicemonitor from prometheus operator                             | `false`                     |
| `servicemonitor.namespace`        | Namespace thes Servicemonitor  is installed in                          |                             |
| `servicemonitor.interval`         | How frequently Prometheus should scrape                                 |                             |
| `servicemonitor.telemetryPath`    | path to cloudwatch-exporter telemtery-path                              |                             |
| `servicemonitor.labels`           | labels for the ServiceMonitor passed to Prometheus Operator             | `{}`                        |
| `servicemonitor.timeout`          | Timeout after which the scrape is ended                                 |                             |
| `ingress.enabled`                 | Enables Ingress                                                         | `false`                     |
| `ingress.annotations`             | Ingress annotations                                                     | `{}`                        |
| `ingress.labels`                  | Custom labels                                                           | `{}`                        |
| `ingress.hosts`                   | Ingress accepted hostnames                                              | `[]`                        |
| `ingress.tls`                     | Ingress TLS configuration                                               | `[]`                        |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

Check the [Flags](https://github.com/prometheus/consul_exporter#flags) list and add to the options block in your value overrides.

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`. For example,
```bash
$ helm install --name my-release \
    --set key_1=value_1,key_2=value_2 \
    stable/prometheus-consul-exporter
```
Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,
```bash
# example for staging
$ helm install --name my-release -f values.yaml stable/prometheus-consul-exporter
```
