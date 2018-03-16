# Fluentd Elasticsearch

* Installs [Fluentd](https://www.fluentd.org/) log forwarder.

## TL;DR;

```console
$ helm install incubator/fluentd-elasticsearch
```

## Introduction

This chart bootstraps a [Fluentd](https://www.fluentd.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/fluentd-elasticsearch
```

The command deploys Fluentd elasticsearch on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Fluentd elasticsearch chart and their default values.

| Parameter                       | Description                                | Default                                                    |
| ------------------------------- | ------------------------------------------ | ---------------------------------------------------------- |
| `image`                         | Image                                      | `gcr.io/google-containers/fluentd-elasticsearch`           |
| `imageTag`                      | Image tag                                  | `v2.0.3                                                    |
| `imagePullPolicy`               | Image pull policy                          | `Always` if `imageTag` is `imagePullPolicy`                |
| `resources.limits.cpu`          | CPU limit                                  | `100m`                                                     |
| `resources.limits.memory`       | Memory limit                               | `500Mi`                                                    |
| `resources.requests.cpu`        | CPU request                                | `100m`                                                     |
| `resources.requests.memory`     | Memory request                             | `200Mi`                                                    |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
    incubator/fluentd-elasticsearch
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/fluentd-elasticsearch
```
