# Telegraf

[Telegraf](https://github.com/influxdata/telegraf) is a plugin-driven server agent written by the folks over at [InfluxData](https://influxdata.com) for collecting & reporting metrics.

## TL;DR

```console
$ helm install stable/telegraf
```

## Introduction

This chart bootstraps a `telegraf` deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `telegraf`:

```console
$ helm install --name telegraf --namespace monitoring stable/telegraf
```

The command deploys Telegraf on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `telegraf` deployment:

```console
$ helm delete telegraf
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The default configuration parameters are listed in `values.yaml`.

```console
$ helm install --name telegraf stable/telegraf
```

Outputs and inputs are configured as arrays of key/value dictionaries. Additional examples and defaults can be found in [values.yaml](values.yaml)
Example:
```
outputs:
  - influxdb:
      urls: []
        # - "http://influxdb.monitoring:8086"
      database: "telegraf"
inputs:
  - cpu:
      percpu: false
      totalcpu: true
  - system:
```

> **Tip**: You can use the default [values.yaml](values.yaml)

Please see https://github.com/influxdata/telegraf/tree/master/plugins/ and checkout the contents of the `inputs` and `outputs` folders.
