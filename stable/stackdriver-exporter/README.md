# Stackdriver Exporter

Prometheus exporter for Stackdriver, allowing for Google Cloud metrics.  You
must have appropriate IAM permissions for this exporter to work.  If you
are passing in an IAM key then you must have:

* monitoring.metricDescriptors.list
* monitoring.timeSeries.list

These are contained within `roles/monitoring.viewer`.  If you're using legacy
access scopes, then you must have
`https://www.googleapis.com/auth/monitoring.read`.

Learn more: https://github.com/frodenas/stackdriver_exporter

## TL;DR;

```bash
$ helm install stable/stackdriver-exporter --set stackdriver.projectId=google-project-name
```

## Introduction

This chart creates a Stackdriver-Exporter deployment on a
[Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh)
package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/stackdriver-exporter --set stackdriver.projectId=google-project-name
```

The command deploys Stackdriver-Exporter on the Kubernetes cluster using the
default configuration. The [configuration](#configuration) section lists the
parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete --purge my-release
```
The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following table lists the configurable parameters of the
Stackdriver-Exporter chart and their default values.

Parameter                           | Description                          | Default
----------------------------------- | ------------------------------------ | --------------------------------
`replicaCount`                      | Desired number of pods               | `1`
`restartPolicy`                     | Container restart policy             | `Always`
`image.repository`                  | Container image repository           | `justwatch/stackdriver_exporter`
`image.tag`                         | Container image tag                  | `1.0.2`
`image.pullPolicy`                  | Container image pull policy          | `IfNotPresent`
`resources`                         | Resource requests & limits           | `{}`
`service.type`                      | Type of service to create            | `ClusterIP`
`service.httpPort`                  | Port for the http service            | `9255`
`stackdriver.projectId`             | GCP Project ID                       | ``
`stackdriver.metrics.typePrefixes`  | Comma separated Metric Type prefixes | ``
`stackdriver.metrics.interval`      | Metrics interval to request from GCP | `5m`
`stackdriver.metrics.offset`        | Offset (into the past) to request    | `0s`
`web.listenAddress`                 | Port to listen on                    | `9255`
`web.path`                          | Path under which to expose metrics   | `/metrics`
`annoations`                        | Deployment annotations               | `{}`

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`. For example,


```bash
$ helm install --name my-release \
    --set key_1=value_1,key_2=value_2 \
    stable/stackdriver-exporter
```

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,

```bash
# example for staging
$ helm install --name my-release -f values.yaml stable/stackdriver-exporter
```

> **Tip**: You can use the default [values.yaml](values.yaml), as long as you provide a value for stackdriver.projectId

## Google Storage Metrics

In order to get metrics for GCS you need to ensure the metrics interval is >
24h.  You can read more information about this in [this bug
report](https://github.com/frodenas/stackdriver_exporter/issues/14).

The easiest way to do this is to create two separate exporters with different
prefixes and intervals, to ensure you gather all appropriate metrics.
