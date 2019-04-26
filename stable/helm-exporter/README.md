# helm-exporter

Installs [helm-exporter](https://github.com/sstarcher/helm-exporter) to export helm stats to prometheus.

## TL;DR;

```console
$ helm install stable/helm-exporter
```

## Introduction

This chart bootstraps a [helm-exporter](https://github.com/sstarcher/helm-exporter) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

The chart comes with a ServiceMonitor for use with the [Prometheus Operator](https://github.com/helm/charts/tree/master/stable/prometheus-operator).

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install stable/helm-exporter --name my-release
```

The command deploys helm-exporter on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the helm-exporter chart and their default values.

Parameter | Description | Default
--- | --- | ---
`affinity` | affinity configuration for pod assignment | `{}`
`image.repository` | Image | `sstarcher/helm-exporter`
`image.tag` | Image tag | `0.3.1`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`nodeSelector` | node labels for pod assignment | `{}`
`resources` | pod resource requests & limits | `{}`
`tolerations` | List of node taints to tolerate (requires Kubernetes 1.6+) | `[]`
`serviceMonitor.create` | Set to true if using the Prometheus Operator | `false`
`serviceMonitor.interval` | Interval at which metrics should be scraped | ``
`serviceMonitor.namespace` | The namespace where the Prometheus Operator is deployed | ``
`serviceMonitor.additionalLabels` | Additional labels to add to the ServiceMonitor | `{}`

```console
$ helm install stable/helm-exporter --name my-release
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/helm-exporter --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
