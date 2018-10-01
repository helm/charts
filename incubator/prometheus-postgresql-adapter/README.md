# prometheus-postgresql-adapter

Installs [prometheus-postgresql-adapter](https://github.com/timescale/prometheus-postgresql-adapter), which provides a remote endpoint to connect a Prometheus service running in Kubernetes to a PostgreSQL endpoint for fast, scalable, long-term metrics storage.

## TL;DR;

```console
$ helm install incubator/prometheus-postgresql-adapter
```

## Introduction

This chart bootstraps a [prometheus-postgresql-adapter](https://github.com/timescale/prometheus-postgresql-adapter) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.8+ with Beta APIs enabled
  - Prometheus instance
  - [pg_prometheus](https://github.com/timescale/pg_prometheus). Using [TimescaleDB](https://github.com/timescale/timescaledb) is optional.

## Installing the Chart

You should _at least_ provide the parameter `pgHost`, since prometheus-postgresql-adapter serves as middleware between Prometheus, and a PostgreSQL database. More on that here: [Getting started with Prometheus and TimescaleDB](https://docs.timescale.com/v0.12/tutorials/prometheus-adapter)

To install the chart with the release name `prom-pg-adapter`:

```console
$ helm install incubator/prometheus-postgresql-adapter --name prom-pg-adapter
```

The command deploys prometheus-postgresql-adapter on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `prom-pg-adapter` deployment:

```console
$ helm delete --purge prom-pg-adapter
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the prometheus-postgresql-adapter chart and their default values.

Parameter | Description | Default
--- | --- | ---
`affinity` | Node affinity for pod assignment | `{}`
`extraArgs` | Additional server container arguments | `{}`
`extraEnv` | Additional container environment variables | `{}`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`image.pullSecrets` | Image pull secrets | None
`image.repository` | Image repository | `timescale/prometheus-postgresql-adapter`
`image.tag` | Image tag | `0.4`
`logLevel` | The log level to use [`error`, `warn`, `info`, `debug`] | `info`
`nodeSelector` | Node labels for pod assignment | `{}`
`pgDatabase` | The PostgreSQL database | `postgres`
`pgPassword` | The PostgreSQL password | None
`pgPort` | The PostgreSQL port | `5432`
`pgSchema` | The PostgreSQL schema | `postgres`
`pgTablePrefix` | Override prefix for internal tables. It is also a view name used for querying | `metrics`
`pgUser` | The PostgreSQL user | `postgres`
`resources.limits.cpu` | CPU resource limits | `200m` |
`resources.limits.memory` | Memory resource limits | `256Mi` |
`resources.requests.cpu` | CPU resource requests | `100m` |
`resources.requests.memory` | Memory resource requests | `128Mi` |
`service.annotations` | Kubernetes service annotations | `{}`
`service.clusterIP` | Cluster IP address to assign to service | None
`service.externalIP` | Service external IP addresses | `[]`
`service.externalTrafficPolicy` | Enable client source IP preservation | `Cluster`
`service.loadBalancerIP` | Kubernetes service LB Optional fixed external IP | None
`service.loadBalancerSourceRanges` | Kubernetes service LB allowed inbound IP addresses | `[]`
`service.nodePort` | Kubernetes service LB Optional fixed external IP | None
`service.port` | Kubernetes service LB Optional fixed external IP | `9201`
`service.type` | Kubernetes service type | `ClusterIP`
`tolerations` | Toleration labels for pod assignment | `[]`
`webListenAddress` | Address to listen on for web endpoints | `9201`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm upgrade \
  --install \
  --set=extraArgs."pg\.prometheus-chunk-interval"=24h0m0s \
  --set=pgSchema=timeseries \
prom-pg-adapter \
incubator/prometheus-postgresql-adapter
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install incubator/prometheus-postgresql-adapter --name prom-pg-adapter -f values.yaml
```
