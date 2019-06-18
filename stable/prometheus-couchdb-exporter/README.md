# prometheus-couchdb-exporter

[couchdb-prometheus-exporter](https://github.com/gesellix/couchdb-prometheus-exporter) is a Prometheus exporter for CouchDB metrics.

## TL;DR;

```bash
$ helm install stable/prometheus-couchdb-exporter
```

## Introduction

This chart bootstraps a [couchdb-exporter](https://github.com/gesellix/couchdb-prometheus-exporter) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/prometheus-couchdb-exporter
```

The command deploys prometheus-couchdb-exporter on the Kubernetes cluster in the default configuration.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters and their default values.

| Parameter              | Description                                         | Default                                 |
| ---------------------- | --------------------------------------------------- | --------------------------------------- |
| `replicaCount`         | desired number of prometheus-couchdb-exporter pods  | `1`                                     |
| `image.repository`     | prometheus-couchdb-exporter image repository        | `gesellix/couchdb-prometheus-exporter`  |
| `image.tag`            | prometheus-couchdb-exporter image tag               | `16`                                    |
| `image.pullPolicy`     | image pull policy                                   | `IfNotPresent`                          |
| `service.type`         | desired service type                                | `ClusterIP`                             |
| `service.port`         | service external port                               | `9984`                                  |
| `ingress.enabled`      | enable ingress controller resource                  | `false`                                 |
| `ingress.annotations`  | annotations for the host's ingress records          | `false`                                 |
| `ingress.path`         | path for the ingress route                          | `/`                                     |
| `ingress.hosts`        | list of host address for ingress creation           |                                         |
| `ingress.tls`          | utilize TLS backend in ingress                      |                                         |
| `resources`            | cpu/memory resource requests/limits                 | {}                                      |
| `nodeSelector`         | node labels for pod assignment                      | {}                                      |
| `tolerations`          | tolerations for pod assignment                      | {}                                      |
| `affinity`             | affinity settings for proxy pod assignments         | {}                                      |
| `couchdb.uri`          | address of the couchdb                              | `http://couchdb.default.svc:5984`       |
| `couchdb.databases`    | comma separated databases to monitor                | `_all_dbs`                              |
| `couchdb.username`     | username for couchdb                                |                                         |
| `couchdb.password`     | password for couchdb                                |                                         |


For more information please refer to the [couchdb-prometheus-exporter]https://github.com/gesellix/couchdb-prometheus-exporter) documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set "couchdb.uri=http://mycouchdb:5984" \
    stable/prometheus-couchdb-exporter
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/prometheus-couchdb-exporter
```
