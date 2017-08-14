# Node-Exporter
This is a chart made for the node-exporter, that is used with prometheus.   

[Prometheus](https://prometheus.io/), a [Cloud Native Computing Foundation](https://cncf.io/) project, is a systems and service monitoring system. It collects metrics from configured targets at given intervals, evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true.

## TL;DR;

```console
$ helm install ./node-exporter
```

## Introduction

This chart deploys the node exporter that prometheus provides to collect metrics to each machine in the cluster using helm.

## Prerequisites

- Kubernetes 1.5+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/prometheus
```

The command deploys node exporters on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the node-exporter chart and their default values.

Parameter | Description | Default
--------- | ----------- | -------
`nodeExporter.enabled` | If true, create node-exporter | `true`
`nodeExporter.name` | node-exporter container name | `node-exporter`
`nodeExporter.image.repository` | node-exporter container image repository| `prom/node-exporter`
`nodeExporter.image.tag` | node-exporter container image tag | `v0.13.0`
`nodeExporter.image.pullPolicy` | node-exporter container image pull policy | `IfNotPresent`
`nodeExporter.extraArgs` | Additional node-exporter container arguments | `{}`
`nodeExporter.extraHostPathMounts` | Additional node-exporter hostPath mounts | `[]`
`nodeExporter.nodeSelector` | node labels for node-exporter pod assignment | `{}`
`nodeExporter.podAnnotations` | annotations to be added to node-exporter pods | `{}`
`nodeExporter.resources` | node-exporter resource requests and limits (YAML) | `{}`
`nodeExporter.service.annotations` | annotations for node-exporter service | `{prometheus.io/scrape: "true"}`
`nodeExporter.service.clusterIP` | internal node-exporter cluster service IP | `None`
`nodeExporter.service.externalIPs` | node-exporter service external IP addresses | `[]`
`nodeExporter.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`nodeExporter.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`nodeExporter.service.servicePort` | node-exporter service port | `9100`
`nodeExporter.service.type` | type of node-exporter service to create | `ClusterIP`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install ./node-exporter --name my-release \
    --set nodeExporter.service.servicePort=8000
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install ./node-exporter --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
