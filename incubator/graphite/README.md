# Graphite

[Graphite](https://graphiteapp.org/) is a monitoring tool.

## Introduction

This chart uses hopsoft/graphite-statsd container to run Graphite inside Kubernetes.

## Prerequisites

- Has been tested on Kubernetes 1.7+

## Installing the Chart

To install the chart with the release name `graphite`, run the following command:

```bash
$ helm install incubator/graphite --name graphite
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

|             Parameter                    |            Description              |                  Default               |
|------------------------------------------|-------------------------------------|----------------------------------------|
| `image.repository`                       | Docker image repo                   | hopsoft/graphite-statsd                |
| `image.tag`                              | Docker image                        | v0.9.15-phusion0.9.18                  |
| `image.pullPolicy`                       | Docker image pull policy            | IfNotPresent                           |
| `service.type`                           | Service type                        | ClusterIP                              |
| `ingress.enabled`                        | Ingress enabled                     | false                                  |
| `ingress.annotations`                    | Ingress annotations                 | `{}`                                   |
| `ingress.path`                           | Ingress path                        |  /                                     |
| `ingress.hosts`                          | Ingress hosts                       | `[]`                                   |
| `ingress.tls`                            | Ingress TLS                         | `[]`                                   |
| `resources`                              | Resources                           | `{}`                                   |
| `nodeSelector`                           | NodeSelector                        | `{}`                                   |
| `tolerations`                            | Tolerations                         | `[]`                                   |
| `affinity`                               | Affinity                            | `{}`                                   |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install --name graphite --set ingress.enabled=false incubator/graphite
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart.

### Storage persistence

Graphite itself is a stateful application that stores all related data in its own database. Therefore it uses a PVC to store data.

### Help

For more information about Graphite visit the official [webiste](https://graphiteapp.org/) and the [docs](http://graphite.readthedocs.io/en/latest/).

To find infos about the Docker container visit [Github](https://github.com/hopsoft/docker-graphite-statsd) or [Dockerhub](https://hub.docker.com/r/hopsoft/graphite-statsd/).
