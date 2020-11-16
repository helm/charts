# Elasticsearch Exporter

DEPRECATED and moved to <https://github.com/prometheus-community/helm-charts>

Prometheus exporter for various metrics about ElasticSearch, written in Go.

Learn more: https://github.com/justwatchcom/elasticsearch_exporter

## TL;DR;

```bash
$ helm install stable/elasticsearch-exporter
```

## Introduction

This chart creates an Elasticsearch-Exporter deployment on a [Kubernetes](http://kubernetes.io)
cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.10+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/elasticsearch-exporter
```

The command deploys Elasticsearch-Exporter on the Kubernetes cluster using the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete --purge my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Upgrading an existing Release to a new major version

A major chart version change (like v1.2.3 -> v2.0.0) indicates that there is an incompatible breaking change needing manual actions.

### To 2.0.0

Some kubernetes apis used from 1.x have been deprecated. You need to update your claster to kubernetes 1.10+ to support new definitions used in 2.x.

## Configuration

The following table lists the configurable parameters of the Elasticsearch-Exporter chart and their default values.

Parameter | Description | Default
--- | --- | ---
`replicaCount` | desired number of pods | `1`
`restartPolicy` | container restart policy | `Always`
`image.repository` | container image repository | `justwatch/elasticsearch_exporter`
`image.tag` | container image tag | `1.1.0`
`image.pullPolicy` | container image pull policy | `IfNotPresent`
`image.pullSecret` | container image pull secret | `""`
`resources` | resource requests & limits | `{}`
`priorityClassName` | priorityClassName | `nil`
`nodeSelector` | Node labels for pod assignment | `{}`
`tolerations` | Node tolerations for pod assignment | `{}`
`podAnnotations` | Pod annotations | `{}` |
`podSecurityPolicies.enabled` | Enable/disable PodSecurityPolicy and associated Role/Rolebinding creation | `false`
`serviceAccount.create` | Create a ServiceAccount for the pod | `false`
`serviceAccount.name` | Name of a ServiceAccount to use that is not handled by this chart | `default`
`service.type` | type of service to create | `ClusterIP`
`service.httpPort` | port for the http service | `9108`
`service.metricsPort.name` | name for the http service | `http`
`service.annotations` | Annotations on the http service | `{}`
`service.labels` | Additional labels for the service definition | `{}`
`env` | Extra environment variables passed to pod | `{}`
`extraEnvSecrets` | Extra environment variables passed to the pod from k8s secrets - see `values.yaml` for an example | `{}` |
`envFromSecret` | The name of an existing secret in the same kubernetes namespace which contains values to be added to the environment | `nil`
`secretMounts` |  list of secrets and their paths to mount inside the pod | `[]`
`affinity` | Affinity rules | `{}`
`es.uri` | address of the Elasticsearch node to connect to | `localhost:9200`
`es.all` | if `true`, query stats for all nodes in the cluster, rather than just the node we connect to | `true`
`es.indices` | if true, query stats for all indices in the cluster | `true`
`es.indices_settings` | if true, query settings stats for all indices in the cluster | `true`
`es.shards` | if true, query stats for shards in the cluster | `true`
`es.cluster_settings` | if true, query stats for cluster settings | `true`
`es.snapshots` | if true, query stats for snapshots in the cluster | `true`
`es.timeout` | timeout for trying to get stats from Elasticsearch | `30s`
`es.ssl.enabled` | If true, a secure connection to Elasticsearch cluster is used | `false`
`es.ssl.useExistingSecrets` | If true, certs from secretMounts will be used | `false`
`es.ssl.ca.pem` | PEM that contains trusted CAs used for setting up secure Elasticsearch connection |
`es.ssl.ca.path` | Path of ca pem file which should match a secretMount path |
`es.ssl.client.enabled` | If true, use SSL client certificates for authentication | `true`
`es.ssl.client.pem` | PEM that contains the client cert to connect to Elasticsearch |
`es.ssl.client.pemPath` | Path of client pem file which should match a secretMount path |
`es.ssl.client.key` | Private key for client auth when connecting to Elasticsearch |
`es.ssl.client.keyPath` | Path of client key file which should match a secretMount path |
`web.path` | path under which to expose metrics | `/metrics`
`serviceMonitor.enabled` | If true, a ServiceMonitor CRD is created for a prometheus operator | `false`
`serviceMonitor.namespace` | If set, the ServiceMonitor will be installed in a different namespace  | `""`
`serviceMonitor.labels` | Labels for prometheus operator | `{}`
`serviceMonitor.interval` | Interval at which metrics should be scraped | `10s`
`serviceMonitor.scrapeTimeout` | Timeout after which the scrape is ended | `10s`
`serviceMonitor.scheme` | Scheme to use for scraping | `http`
`serviceMonitor.relabelings` | Relabel configuration for the metrics | `[]`
`serviceMonitor.targetLabels` | Set of labels to transfer on the Kubernetes Service onto the target. | `[]`
`serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion. | `[]`
`serviceMonitor.sampleLimit` | Number of samples that will fail the scrape if exceeded | `0`
`prometheusRule.enabled` | If true, a PrometheusRule CRD is created for a prometheus operator | `false`
`prometheusRule.namespace` | If set, the PrometheusRule will be installed in a different namespace  | `""`
`prometheusRule.labels` | Labels for prometheus operator | `{}`
`prometheusRule.rules` | List of [PrometheusRules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) to be created, check values for an example. | `[]`
`log.format` | Format used for the logs. Valid formats are `json` and `logfmt` | `logfmt`
`log.level` | Logging level to be used. Valid levels are `debug`, `info`, `warn`, `error` | `info`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set key_1=value_1,key_2=value_2 \
    stable/elasticsearch-exporter
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
# example for staging
$ helm install --name my-release -f values.yaml stable/elasticsearch-exporter
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Upgrading an existing Release to a new major version

A major chart version change (like v1.2.3 -> v2.0.0) indicates that there is an
incompatible breaking change needing manual actions.

### To 3.0.0

`prometheusRule.rules` are now processed as Helm template, allowing to set variables in them.
This means that if a rule contains a {{ $value }}, Helm will try replacing it and probably fail.

You now need to escape the rules (see `values.yaml`) for examples.
