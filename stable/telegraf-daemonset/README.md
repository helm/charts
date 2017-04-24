# Telegraf-DS

[Telegraf](https://github.com/influxdata/telegraf) is a plugin-driven server agent written by the folks over at [InfluxData](https://influxdata.com) for collecting & reporting metrics. This chart runs a DaemonSet of Telegraf instances to collect host level metrics for your cluster. If you need to poll individual instances of infrastructure or APIs there is a `stable/telegraf-s` chart that is more suited to that usecase.

## TL;DR

```console
$ helm install stable/telegraf-ds
```

## Introduction

This chart bootstraps a `telegraf-ds` deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/telegraf-ds
```

The command deploys a Telegraf daemonset on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section as well as the [values.yaml](/values.yaml) file lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
 
## Configuration

The default configuration parameters are listed in `values.yaml`. To change the defaults, specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set config.outputs.influxdb.url=http://foo.bar:8086 \
    stable/telegraf-ds
```

The above command allows the chart to deploy by setting the InfluxDB URL for telegraf to write to.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/telegraf-ds
```

## Telegraf Configuration

This chart deploys the following by default:

- `telegraf` (`telegraf-ds`) running in a daemonset with the following plugins enabled
  * [`cpu`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/system)
  * [`disk`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/system)
  * [`docker`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/docker)
  * [`diskio`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/system)
  * [`kernel`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/system)
  * [`kubernetes`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/kubernetes)
  * [`mem`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/system)
  * [`processes`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/system)
  * [`swap`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/system)
  * [`system`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/system)
  