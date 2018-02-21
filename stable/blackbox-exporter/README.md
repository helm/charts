# Prometheus Blackbox Exporter

Prometheus exporter for blackbox testing

Learn more: https://github.com/prometheus/blackbox_exporter

## TL;DR;

```bash
$ helm install stable/blackbox-exporter
```

## Introduction

This chart creates a Blackbox-Exporter deployment on a [Kubernetes](http://kubernetes.io) 
cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/blackbox-exporter
```

The command deploys Blackbox Exporter on the Kubernetes cluster using the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete --purge my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Blackbox-Exporter chart and their default values.

Parameter | Description | Default
--- | --- | ---
`restartPolicy` | container restart policy | `Always`
`image.repository` | container image repository | `justwatch/elasticsearch_exporter`
`image.tag` | container image tag | `1.0.2`
`image.pullPolicy` | container image pull policy | `IfNotPresent`
`resources` | resource requests & limits | `{}`
`service.type` | type of service to create | `ClusterIP`
`service.httpPort` | port for the http service | `9108`
`service.externalIPs` | list of external ips | []
 apiVersion: | specify api version | apps/v1
 user | if authentication is enabled, username | prometheus
 password | if specified, basicauth will be enabled |
`proxyImage.tag` | proxy container image tag | `1.13.8-alpine
`proxyImage.pullPolicy` | proxy container image pull policy | IfNotPresent`
 config | yaml to pass directly into the blackbox config file | {}

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set key_1=value_1,key_2=value_2 \
    stable/blackbox-exporter
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
# example for staging
$ helm install --name my-release -f values.yaml stable/blackbox-exporter
```

> **Tip**: You can use the default [values.yaml](values.yaml)
