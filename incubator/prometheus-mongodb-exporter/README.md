# Prometheus Postgres Exporter

* Installs prometheus [mongodb exporter](https://github.com/ananthunair/mongodb_exporter)

## TL;DR;

```console
$ helm install incubator/prometheus-mongodb-exporter
```

## Introduction

This chart bootstraps a prometheus [mongodb exporter](https://github.com/ananthunair/mongodb_exporter) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/prometheus-mongodb-exporter
```

The command deploys mongodb exporter on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the postgres Exporter chart and their default values.

| Parameter                       | Description                                | Default                                                    |
| ------------------------------- | ------------------------------------------ | ---------------------------------------------------------- |
| `image`                         | Image                                      | `ananthunair/mongodb_exporter`                      |
| `imageTag`                      | Image tag                                  | `v1.0.0`                                      |
| `imagePullPolicy`               | Image pull policy                          | `IfNotPresent` |
| `service.type`      | Service type |  `ClusterIP` |
| `service.port`                      | The service port                               | `9216`                                     |
| `service.targetPort`                      | The target port of the container                               | `9216`                                        |
| `resources`          |                                  |                    `{}`                                  |
| `config.datasource`                 | Mongodb datasource configuration                      |                           `mongodb://localhost:27017 `         |
| `annotations`                | pod annotations for easier discovery | `prometheus.io/scrape: "true"  prometheus.io/port: "9216"` |



Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set key=value[,key=value]  \
    incubator/prometheus-mongodb-exporter
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/prometheus-mongodb-exporter
```