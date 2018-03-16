# Prometheus Postgres Exporter

* Installs prometheus [postgres exporter](https://github.com/wrouesnel/postgres_exporter)

## TL;DR;

```console
$ helm install stable/prometheus-postgres-exporter
```

## Introduction

This chart bootstraps a prometheus [postgres exporter](http://github.com/prometheus/postgres_exporter) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/prometheus-postgres-exporter
```

The command deploys postgres exporter on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the postgres Exporter chart and their default values.

| Parameter                       | Description                                | Default                                                    |
| ------------------------------- | ------------------------------------------ | ---------------------------------------------------------- |
| `image`                         | Image                                      | `wrouesnel/postgres_exporter`                      |
| `imageTag`                      | Image tag                                  | `v0.4.4`                                      |
| `imagePullPolicy`               | Image pull policy                          | `IfNotPresent` |
| `service.type`      | Service type |  `ClusterIP` | 
| `service.port`                      | The service port                               | `80`                                     |
| `service.targetPort`                      | The target port of the container                               | `9187`                                        |
| `resources`          |                                  |                    `{}`                                  |
| `config.datasource`                 | Postgresql datasource configuration                      |                                     |
| `config.queries`                | SQL queries that the exporter will run | [postgres exporter defaults](https://github.com/wrouesnel/postgres_exporter/blob/master/queries.yaml) | 
| `serviceAccount.create`         | Specifies whether a service account should be created.| `true` |
| `serviceAccount.name`           | Name of the service account.|        |
| `tolerations`                   | Add tolerations                            | `[]`  |
| `nodeSelector`                    | node labels for pod assignment | `{}`  |
| `affinity`                       |     node/pod affinities | `{}` |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set serviceAccount.name=postgres  \
    stable/prometheus-postgres-exporter
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/prometheus-postgres-exporter
```
