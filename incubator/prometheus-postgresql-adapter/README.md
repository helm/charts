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
  - A Prometheus instance
  - A [pg_prometheus](https://github.com/timescale/pg_prometheus) instance. Using [TimescaleDB](https://github.com/timescale/timescaledb) is optional.

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

## Adapter configuration

The following table lists the configurable parameters of the `adapter` portion of the `prometheus-postgresql-adapter` chart, and its default values.

Parameter | Description | Default
--- | --- | ---
`adapter.affinity` | Node affinity for pod assignment | `{}`
`adapter.deploymentAnnotations` | Deployment annotations | `{}`
`adapter.extraArgs` | Additional server container arguments | `{}`
`adapter.extraEnv` | Additional container environment variables | `{}`
`adapter.image.pullPolicy` | Image pull policy | `IfNotPresent`
`adapter.image.pullSecrets` | Image pull secrets | None
`adapter.image.repository` | Image repository | `timescale/prometheus-postgresql-adapter`
`adapter.image.tag` | Image tag | `0.4.1`
`adapter.livenessProbe.enabled` | Enable liveness checks | `true`
`adapter.livenessProbe.failureThreshold` | Liveness check failure threshold | `3`
`adapter.livenessProbe.initialDelaySeconds` | Liveness check initial delay (sec) | `15`
`adapter.livenessProbe.periodSeconds` | Liveness check interval (sec) | `20`
`adapter.livenessProbe.successThreshold` | Liveness check success threshold | `1`
`adapter.livenessProbe.timeoutSeconds` | Liveness check timeout (sec) | `2`
`adapter.logLevel` | The log level to use [`error`, `warn`, `info`, `debug`] | `debug`
`adapter.nodeSelector` | Node labels for pod assignment | `{}`
`adapter.pgDatabase` | The PostgreSQL database | `postgres`
`adapter.pgHost` | The PostgreSQL hostname | `localhost`
`adapter.pgPassword` | The PostgreSQL password | None
`adapter.pgPort` | The PostgreSQL port | `5432`
`adapter.pgSchema` | The PostgreSQL schema | None
`adapter.pgTablePrefix` | Override prefix for internal tables. It is also a view name used for querying | `metrics`
`adapter.pgUser` | The PostgreSQL user | `postgres`
`adapter.podAnnotations` | Pod annotations | `{}`
`adapter.prometheus.exporter.enabled` | Enable / disable the Prometheus exporter annotations | `true`
`adapter.prometheus.exporter.probe` | Enable / disable Prometheus probe | `true`
`adapter.prometheus.exporter.scrape` | Enable / disable Prometheus scrape | `true`
`adapter.prometheus.operator.enabled` | Enable / disable Prometheus operator support via `servicemonitor.yaml` | `false`
`adapter.prometheus.operator.honorLabels` | Prometheus operator honorLabels | `true`
`adapter.prometheus.operator.interval` | Prometheus operator scrape interval | `20s`
`adapter.prometheus.operator.labels` | Prometheus operator additional labels | `{}`
`adapter.prometheus.operator.namespace` | Prometheus operator namespace | `{{ .Release.Namespace }}`
`adapter.readinessProbe.enabled` | Enable readiness checks | `true`
`adapter.readinessProbe.failureThreshold` | Liveness check failure threshold | `3`
`adapter.readinessProbe.initialDelaySeconds` | Readiness check initial delay (sec) | `15`
`adapter.readinessProbe.periodSeconds` | Readiness check interval (sec) | `20`
`adapter.readinessProbe.successThreshold` | Liveness check success threshold | `1`
`adapter.readinessProbe.timeoutSeconds` | Readiness check timeout (sec) | `1`
`adapter.replicaCount` | Number of pods for deployment | `1`
`adapter.resources.limits.cpu` | CPU resource limits | `200m`
`adapter.resources.limits.memory` | Memory resource limits | `256Mi`
`adapter.resources.requests.cpu` | CPU resource requests | `100m`
`adapter.resources.requests.memory` | Memory resource requests | `128Mi`
`adapter.service.annotations` | Service annotations | `{}`
`adapter.service.clusterIP` | Cluster IP address to assign to service | None
`adapter.service.externalIP` | Service external IP addresses | `[]`
`adapter.service.externalTrafficPolicy` | Enable client source IP preservation | `Cluster`
`adapter.service.loadBalancerIP` | Kubernetes service LB Optional fixed external IP | None
`adapter.service.loadBalancerSourceRanges` | Kubernetes service LB allowed inbound IP addresses | `[]`
`adapter.service.nodePort` | Kubernetes service LB Optional fixed external IP | None
`adapter.service.type` | Kubernetes service type | `ClusterIP`
`adapter.tolerations` | Toleration labels for pod assignment | `[]`
`adapter.webListenAddress` | Address to listen on for web endpoints | `9201`
`adapter.webTelemetryPath` | Path to use for scraping Prometheus metrics | `/metrics`

## CronJob configuration

The following table lists the configurable parameters of the `cronjob` portion of the `prometheus-postgresql-adapter` chart, and its default values. The CronJob manages data retention in TimescaleDB, which you can find here: https://docs.timescale.com/v1.0/using-timescaledb/data-retention

Parameter | Description | Default
--- | --- | ---
`cronjob.affinity` | Node affinity for pod assignment | `{}`
`cronjob.annotations` | Cronjob annotations | `{}`
`cronjob.cleanQuery` | Query to run for data retention cleanup | `"SELECT drop_chunks(interval '24 hours');"`
`cronjob.enabled` | Enable / disable cronjob data retention job | `false`
`cronjob.extraEnv` | Additional container environment variables | `{}`
`cronjob.failedJobsHistoryLimit` | Number of failed jobs to keep in history | `5`
`cronjob.image.pullPolicy` | Image pull policy | `IfNotPresent`
`cronjob.image.pullSecrets` | Image pull secrets | None
`cronjob.image.repository` | Image repository | `postgres`
`cronjob.image.tag` | Image tag | `alpine`
`cronjob.nodeSelector` | Node labels for pod assignment | `{}`
`cronjob.resources.limits.cpu` | CPU resource limits | `200m`
`cronjob.resources.limits.memory` | Memory resource limits | `256Mi`
`cronjob.resources.requests.cpu` | CPU resource requests | `100m`
`cronjob.resources.requests.memory` | Memory resource requests | `128Mi`
`cronjob.restartPolicy` | Cron job restart policy | `OnFailure`
`cronjob.schedule` | Cron job schedule | `*/5 * * * *`
`cronjob.successfulJobsHistoryLimit` | Number of successful jobs to keep in history | `5`
`cronjob.tolerations` | Toleration labels for pod assignment | `[]`

## Using `--set`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm upgrade \
  --install \
  --set=adapter.extraArgs."pg\.prometheus-chunk-interval"=24h0m0s \
  --set=adapter.pgSchema=timeseries \
prom-pg-adapter \
incubator/prometheus-postgresql-adapter
```

## Using `--values`

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install incubator/prometheus-postgresql-adapter --name prom-pg-adapter -f values.yaml
```
