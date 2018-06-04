# Graphite/Statsd Helm Chart

Please also see https://hub.docker.com/r/graphiteapp/graphite-statsd/

## Table of Content

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [Installation](#installation)
- [Uninstall](#uninstall)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->
 

## Prerequisites

* Kubernetes with extensions/v1beta1 available

## Configuration

This chart will not have persistent storage (though pull requests are welcome)

The following table lists common configurable parameters of the chart and
their default values. See values.yaml for all available options. 

|       Parameter                        |           Description                       |                         Default                     |
|----------------------------------------|---------------------------------------------|-----------------------------------------------------|
| `affinity`                             | Map of node/pod affinities                  | `{}`                                                |
| `image.pullPolicy`                     | Container pull policy                       | `IfNotPresent`                                      |
| `image.repository`                     | Container image to use                      | `chartmuseum/chartmuseum`                           |
| `image.tag`                            | Container image tag to deploy               | `v0.5.1`                                            |
| `ingress.annotations`                  | Map of annotations                          | `{}`                                                |
| `ingress.enabled`                      | Flag to enable ingress                      | `false`                                             |
| `ingress.hosts`                        | List of hosts to configure ingress with     | []                                                  |
| `ingress.path`                         | Ingress path to configure                   | `/`                                                 |
| `ingress.tls`                          | TLS for ingress                             | `[]`                                                |
| `nodeSelector`                         | Map of node labels for pod assignment       | `{}`                                                |
| `replicaCount`                         | k8s replicas                                | ``                                                  |
| `resources.limits.cpu`                 | Container maximum CPU                       | `100m`                                              |
| `resources.limits.memory`              | Container maximum memory                    | `128Mi`                                             |
| `resources.requests.cpu`               | Container requested CPU                     | `80m`                                               |
| `resources.requests.memory`            | Container requested memory                  | `64Mi`                                              |
| `service.port`                         | Port for graphite to listen on              | `80`                                                |
| `service.type`                         | Type of service                             | `ClusterIP`                                         |
| `tolerations`                          | Taints and tolerations                      | `[]`                                                |


Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`.

## Installation

```shell
helm install --name graphite-statsd -f custom.yaml incubator/graphite-statsd
```

## Uninstall 

```shell
helm delete graphite-statsd
```

To delete the deployment and its history:
```shell
helm delete --purge graphite-statsd
```
