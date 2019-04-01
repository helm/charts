# DEPRECATED - Graphite

This chart is depreacated as its maintained in the following repo now:

https://github.com/kiwigrid/helm-charts/tree/master/charts/graphite

You can add the repo via:
* helm add repo kiwigrid https://kiwigrid.github.io





[Graphite](https://graphiteapp.org/) is a monitoring tool.

## Introduction

This chart uses graphiteapp/graphite-statsd container to run Graphite inside Kubernetes.

## Prerequisites

- Has been tested on Kubernetes 1.9+

## Installing the Chart

To install the chart with the release name `graphite`, run the following command:

```bash
$ helm install stable/graphite --name graphite
```

## Uninstalling the Chart

To uninstall/delete the `graphite` deployment:

```bash
$ helm delete graphite
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Tip**: To completely remove the release, run `helm delete --purge graphite`

## Configuration

The following table lists the configurable parameters of the Graphite chart and their default values.

|             Parameter          |            Description                       |                  Default               |
|--------------------------------|----------------------------------------------|----------------------------------------|
| `image.repository`             | Docker image repo                            | `graphiteapp/graphite-statsd`          |
| `image.tag`                    | Docker image                                 | `1.1.5-3`                                |
| `image.pullPolicy`             | Docker image pull policy                     | `IfNotPresent`                         |
| `service.type`                 | Service type                                 | `ClusterIP`                            |
| `service.port`                 | Service port of Graphite UI                  | `8080`                                 |
| `service.annotations`          | Service annotations                          | `{}`                                   |
| `service.labels`               | Service labels                               | `{}`                                   |
| `persistence.enabled`          | Enable config persistence using PVC          | `true`                                 |
| `persistence.storageClass`     | PVC Storage Class for config volume          | `nil`                                  |
| `persistence.existingClaim`    | Name of an existing PVC to use for config    | `nil`                                  |
| `persistence.accessMode`       | PVC Access Mode for config volume            | `ReadWriteOnce`                        |
| `persistence.size`             | PVC Storage Request for config volume        | `10Gi`                                 |
| `resources`                    | Resource limits for Graphite pod             | `{}`                                   |
| `ingress.enabled`              | Ingress enabled                              | `false`                                |
| `ingress.annotations`          | Ingress annotations                          | `{}`                                   |
| `ingress.path`                 | Ingress path                                 | `/`                                    |
| `ingress.hosts`                | Ingress hosts                                | `[]`                                   |
| `ingress.tls`                  | Ingress TLS                                  | `[]`                                   |
| `resources`                    | Resources                                    | `{}`                                   |
| `nodeSelector`                 | NodeSelector                                 | `{}`                                   |
| `tolerations`                  | Tolerations                                  | `[]`                                   |
| `affinity`                     | Affinity                                     | `{}`                                   |
| `configMaps`                   | Graphite Config files                        | see values.yaml                        |
| `statsdConfigMaps`             | StatsD Config files                          | see values.yaml                        |
| `statsd.interface`             | StatsD server interface, `TCP` or `UDP`      | `UDP`                                  |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install --name graphite --set ingress.enabled=false stable/graphite
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart.

### Storage persistence

Graphite itself is a stateful application that stores all related data in its own database. Therefore it uses a PVC to store data.

### Help

For more information about Graphite visit the official [website](https://graphiteapp.org/) and the [docs](http://graphite.readthedocs.io/en/latest/).

To find infos about the Docker container visit [Github](https://github.com/graphite-project/docker-graphite-statsd) or [Dockerhub](https://hub.docker.com/r/graphiteapp/graphite-statsd/).
