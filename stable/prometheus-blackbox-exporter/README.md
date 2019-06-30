# Prometheus Blackbox Exporter

Prometheus exporter for blackbox testing

Learn more: [https://github.com/prometheus/blackbox_exporter](https://github.com/prometheus/blackbox_exporter)

## TL;DR;

```bash
$ helm install stable/prometheus-blackbox-exporter
```

## Introduction

This chart creates a Blackbox-Exporter deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/prometheus-blackbox-exporter
```

The command deploys Blackbox Exporter on the Kubernetes cluster using the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete --purge my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Blackbox-Exporter chart and their default values.

|               Parameter                |                    Description                    |            Default            |
| -------------------------------------- | ------------------------------------------------- | ----------------------------- |
| `config`                               | Prometheus blackbox configuration                 | {}                            |
| `secretConfig`                         | Whether to treat blackbox configuration as secret | `false`                       |
| `configmapReload.name`                 | configmap-reload container name                   | `configmap-reload`            |
| `configmapReload.image.repository`     | configmap-reload container image repository       | `jimmidyson/configmap-reload` |
| `configmapReload.image.tag`            | configmap-reload container image tag              | `v0.2.2`                      |
| `configmapReload.image.pullPolicy`     | configmap-reload container image pull policy      | `IfNotPresent`                |
| `configmapReload.extraArgs`            | Additional configmap-reload container arguments   | `{}`                          |
| `configmapReload.extraConfigmapMounts` | Additional configmap-reload configMap mounts      | `[]`                          |
| `configmapReload.resources`            | configmap-reload pod resource requests & limits   | `{}`                          |
| `extraArgs`                            | Optional flags for blackbox                       | `[]`                          |
| `image.repository`                     | container image repository                        | `prom/blackbox-exporter`      |
| `image.tag`                            | container image tag                               | `v0.14.0`                     |
| `image.pullPolicy`                     | container image pull policy                       | `IfNotPresent`                |
| `image.pullSecrets`                    | container image pull secrets                      | `[]`                          |
| `ingress.annotations`                  | Ingress annotations                               | None                          |
| `ingress.enabled`                      | Enables Ingress                                   | `false`                       |
| `ingress.hosts`                        | Ingress accepted hostnames                        | None                          |
| `ingress.tls`                          | Ingress TLS configuration                         | None                          |
| `nodeSelector`                         | node labels for pod assignment                    | `{}`                          |
| `tolerations`                          | node tolerations for pod assignment               | `[]`                          |
| `affinity`                             | node affinity for pod assignment                  | `{}`                          |
| `podAnnotations`                       | annotations to add to each pod                    | `{}`                          |
| `resources`                            | pod resource requests & limits                    | `{}`                          |
| `restartPolicy`                        | container restart policy                          | `Always`                      |
| `service.annotations`                  | annotations for the service                       | `{}`                          |
| `service.labels`                       | additional labels for the service                 | None                          |
| `service.type`                         | type of service to create                         | `ClusterIP`                   |
| `service.port`                         | port for the blackbox http service                | `9115`                        |
| `service.externalIPs`                  | list of external ips                              | []                            |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set key_1=value_1,key_2=value_2 \
    stable/prometheus-blackbox-exporter
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
# example for staging
$ helm install --name my-release -f values.yaml stable/prometheus-blackbox-exporter
```

> **Tip**: You can use the default [values.yaml](values.yaml)
