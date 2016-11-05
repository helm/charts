# Prometheus

[Prometheus](https://prometheus.io/), a [Cloud Native Computing Foundation](https://cncf.io/) project, is a systems and service monitoring system. It collects metrics from configured targets at given intervals, evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true.

## TL;DR;

```console
$ helm install incubator/prometheus
```

## Introduction

This chart bootstraps a [Prometheus](https://prometheus.io/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.3+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/prometheus
```

The command deploys Prometheus on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Spartakus chart and their default values.

| Parameter                            | Description                              | Default                                                    |
| -------------------------------      | -------------------------------          | ---------------------------------------------------------- |
| `alertmanager.httpPort`                              | Alertmanager Service port                          | `80`                              |
| `alertmanager.httpPortName`                    | Alertmanager service port name                        | `http`   |
| `alertmanager.image`            | Alertmanager Docker image    | `prom/alertmanager:{VERSION}`                                                      |
| `alertmanager.ingress.enabled` | If true, Alertmanager Ingress will be created   | `false`                                                  |
| `alertmanager.ingress.annotations` | Alertmanager Ingress annotations (YAML)   | `{}`                                                  |
| `alertmanager.ingress.hosts` | Alertmanager Ingress hostnames (YAML)   | `[]`                                                  |
| `alertmanager.ingress.tls` | Alertmanager Ingress TLS configuration (YAML)   | `[]`                                                  |
| `alertmanager.persistentVolume.enabled` | If true, AlertManager will create a Persistent Volume Claim   | `false`                                                  |
| `alertmanager.persistentVolume.accessModes` | AlertManager data Persistent Volume access modes (YAML)   | `[]`                                                  |
| `alertmanager.persistentVolume.size` | AlertManager data Persistent Volume size   | none                                                 |
| `alertmanager.resources` | Alertmanager resource requests and limits (YAML)   |```requests: {cpu: 10m, memory: 32Mi}  ```                                                |
| `alertmanager.serviceType` | Alertmanager service type   | `ClusterIP`                                                  |
| `alertmanager.storagePath` | Alertmanager data storage path   | `/data`                                                  |
| `configmapReloadImage` | Configmap-reload Docker image   | `jimmidyson/configmap-reload:${VERSION}`                                                  |
| `imagePullPolicy` | Global image pull policy   | `Always` if image tag is latest, else `IfNotPresent`                                                  |
| `server.annotations` | Server Pod annotations (YAML)   | `{}`                                                  |
| `server.extraArgs` | Additional Server container arguments (YAML)   | `[]`                                                  |
| `server.httpPort` | Server service port   | `80`                                                  |
| `server.httpPortName` | Server service port name   | `http`                                                  |
| `server.image` | Server Docker image   | ` prom/prometheus:${VERSION}`                                                  |
| `server.ingress.enabled` | If true, Server Ingress will be created   | `false`                                                  |
| `server.ingress.annotations` | Server Ingress annotations (YAML)   | `{}`                                                  |
| `server.ingress.hosts` | Server Ingress hostnames (YAML)  | `[]`                                                  |
| `server.ingress.tls` | Server Ingress TLS configuration (YAML)   | `[]`                                                  |
| `server.persistentVolume.enabled` | If true, Server will create a Persistent Volume Claim   | `false`                                                  |
| `server.persistentVolume.accessModes` | Server data Persistent Volume access modes (YAML)   | `[]`                                                  |
| `server.persistentVolume.annotations` | Server data Persistent Volume annotations (YAML)   | `{}`                                                  |
| `server.persistentVolume.size` | Server data Persistent Volume size   | none                                                 |
| `server.resources` | Server resource requests and limits   | `requests: {cpu: 500m, memory: 512Mi}`                                                 |
| `server.serviceType` | Server service type   | `ClusterIP`                                                 |
| `server.storageLocalPath` | Server local data storage path   | `/data`                                                 |
| `server.terminationGracePeriodSeconds` | Server Pod termination grace period   | `300`                                                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set server.storageLocalPath=/prometheus \
    incubator/prometheus
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/prometheus
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### ConfigMap Files
AlertManager is configured through [alertmanager.yml](https://prometheus.io/docs/alerting/configuration/). This file (and any others listed in `alertmanagerFiles`) will be mounted into the `alertmanager` pod.

Prometheus is configured through [prometheus.yml](https://prometheus.io/docs/operating/configuration/). This file (and any others listed in `serverFiles`) will be mounted into the `prometheus` pod.

### Ingress TLS
