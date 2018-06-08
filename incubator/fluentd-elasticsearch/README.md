# Fluentd Elasticsearch

* Installs [Fluentd](https://www.fluentd.org/) log forwarder.

## TL;DR;

```console
$ helm install incubator/fluentd-elasticsearch
```

## Introduction

This chart bootstraps a [Fluentd](https://www.fluentd.org/) daemonset on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.
It's meant to be a drop in replacement for fluentd-gcp on GKE which sends logs to Google's Stackdriver service, but can also be used in other places where logging to ElasticSearch is required.
The used Docker image also contains Google's detect exceptions (for Java multiline stacktraces), Prometheus exporter, Kubernetes metadata filter & Systemd plugins.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/fluentd-elasticsearch
```

The command deploys fluentd-elasticsearch on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Fluentd elasticsearch chart and their default values.


=======
| Parameter                          | Description                                | Default                                                    |
| ---------------------------------- | ------------------------------------------ | ---------------------------------------------------------- |
| `annotations`                      | Optional daemonset annotations             | `NULL`                                                     |
| `configMaps`                       | Fluentd configmaps                         | `default conf files`                                       |
| `elasticsearch.host`               | Elstaicsearch Host                         | `elasticsearch-client`                                     |
| `elasticsearch.port`               | Elasticsearch Port                         | `9200`                                                     |
| `elasticsearch.buffer_chunk_limit` | Elasticsearch buffer chunk limit           | `2M`                                                       |
| `elasticsearch.buffer_queue_limit` | Elasticsearch buffer queue limit           | `8`                                                        |
| `extraVolumeMounts`                | Mount an extra volume, required to mount ssl certificates when elasticsearch has tls enabled |          |
| `extraVolume`                      | Extra volume                               |                                                            |
| `image.repository`                 | Image                                      | `gcr.io/google-containers/fluentd-elasticsearch`           |
| `image.tag`                        | Image tag                                  | `v2.0.4                                                    |
| `image.pullPolicy`                 | Image pull policy                          | `Always` if `image.tag` is `imagePullPolicy`               |
| `rbac.create`                      | RBAC                                       | `true`                                                     |
| `resources.limits.cpu`             | CPU limit                                  | `100m`                                                     |
| `resources.limits.memory`          | Memory limit                               | `500Mi`                                                    |
| `resources.requests.cpu`           | CPU request                                | `100m`                                                     |
| `resources.requests.memory`        | Memory request                             | `200Mi`                                                    |
| `service`                          | Service definition                         | `{}`                                                       |
| `serviceAccount.create`            | Specifies whether a service account should be created.| `true`                                          |
| `serviceAccount.name`              | Name of the service account.               |                                                            |   
| `livenessProbe.enabled`            | Wether to enable livenessProbe             | `true`                                                    |   
| `tolerations`                      | Optional daemonset tolerations             | `NULL`                                                     |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
    incubator/fluentd-elasticsearch
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/fluentd-elasticsearch
```
