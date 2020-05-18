# Prometheus SNMP Exporter

Prometheus exporter for snmp monitoring

Learn more: [https://github.com/prometheus/snmp_exporter](https://github.com/prometheus/snmp_exporter)

## TL;DR;

```bash
$ helm install stable/prometheus-snmp-exporter
```

## Introduction

This chart creates a SNMP-Exporter deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/prometheus-snmp-exporter
```

The command deploys SNMP Exporter on the Kubernetes cluster using the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete --purge my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the SNMP-Exporter chart and their default values.

|               Parameter                |                   Description                   |            Default            |
| -------------------------------------- | ----------------------------------------------- | ----------------------------- |
| `config`                               | Prometheus SNMP configuration                   | {}                            |
| `configmapReload.name`                 | configmap-reload container name                 | `configmap-reload`            |
| `configmapReload.image.repository`     | configmap-reload container image repository     | `jimmidyson/configmap-reload` |
| `configmapReload.image.tag`            | configmap-reload container image tag            | `v0.2.2`                      |
| `configmapReload.image.pullPolicy`     | configmap-reload container image pull policy    | `IfNotPresent`                |
| `configmapReload.extraArgs`            | Additional configmap-reload container arguments | `{}`                          |
| `configmapReload.extraConfigmapMounts` | Additional configmap-reload configMap mounts    | `[]`                          |
| `configmapReload.resources`            | configmap-reload pod resource requests & limits | `{}`                          |
| `extraArgs`                            | Optional flags for exporter                     | `[]`                          |
| `image.repository`                     | container image repository                      | `prom/snmp-exporter`          |
| `image.tag`                            | container image tag                             | `v0.12.0`                     |
| `image.pullPolicy`                     | container image pull policy                     | `IfNotPresent`                |
| `ingress.annotations`                  | Ingress annotations                             | None                          |
| `ingress.enabled`                      | Enables Ingress                                 | `false`                       |
| `ingress.hosts`                        | Ingress accepted hostnames                      | None                          |
| `ingress.tls`                          | Ingress TLS configuration                       | None                          |
| `nodeSelector`                         | node labels for pod assignment                  | `{}`                          |
| `tolerations`                          | node tolerations for pod assignment             | `[]`                          |
| `affinity`                             | node affinity for pod assignment                | `{}`                          |
| `podAnnotations`                       | annotations to add to each pod                  | `{}`                          |
| `resources`                            | pod resource requests & limits                  | `{}`                          |
| `restartPolicy`                        | container restart policy                        | `Always`                      |
| `service.annotations`                  | annotations for the service                     | `{}`                          |
| `service.labels`                       | additional labels for the service               | None                          |
| `service.type`                         | type of service to create                       | `ClusterIP`                   |
| `service.port`                         | port for the snmp http service                  | `9116`                        |
| `service.externalIPs`                  | list of external ips                            | []                            |
| `rbac.create`                          | Use Role-based Access Control                   | `true`                        |
| `serviceAccount.create`                | Should we create a ServiceAccount               | `true`                        |
| `serviceAccount.name`                  | Name of the ServiceAccount to use               | `null`                        |
| `serviceMonitor.enabled`               | Enables ServiceMonitor                          | `false`                       |
| `serviceMonitor.params.enabled`        | Enables params for serviceMonitor               | `false`                       |
| `serviceMonitor.params.conf.module`    | Module to use for scrapes                       | `[]`                          |
| `serviceMonitor.params.conf.target`    | List of target(s) to scrape                     | `[]`                          |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set key_1=value_1,key_2=value_2 \
    stable/prometheus-snmp-exporter
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
# example for staging
$ helm install --name my-release -f values.yaml stable/prometheus-snmp-exporter
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Prometheus Configuration


The snmp exporter needs to be passed the address as a parameter, this can be done with relabelling.

Example config:

```
scrape_configs:
  - job_name: 'snmp'
    static_configs:
      - targets:
        - 192.168.1.2  # SNMP device.
    metrics_path: /snmp
    params:
      module: [if_mib]
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: my-service-name:9116  # The SNMP exporter's Service name and port.
```

See [prometheus/snmp_exporter/README.md](https://github.com/prometheus/snmp_exporter/) for further information.
