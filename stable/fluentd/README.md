# fluentd

[Fluentd](https://www.fluentd.org/) collects events from various data sources and writes them to files, RDBMS, NoSQL, IaaS, SaaS, Hadoop and so on. Fluentd helps you unify your logging infrastructure (Learn more about the Unified Logging Layer).

## TL;DR;

```console
$ helm install stable/fluentd
```

## Introduction

This chart bootstraps an fluentd deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install stable/fluentd --name my-release
```

The command deploys fluentd on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the fluentd chart and their default values.

Parameter | Description | Default
--- | --- | ---
`affinity` | node/pod affinities | `{}`
`configMaps` | Fluentd configuration | See [values.yaml](values.yaml)
`output.host` | output host | `elasticsearch-client.default.svc.cluster.local`
`output.port` | output port | `9200`
`output.scheme` | output port | `http`
`output.sslVersion` | output ssl version | `TLSv1`
`output.buffer_chunk_limit` | output buffer chunk limit | `2M`
`output.buffer_queue_limit` | output buffer queue limit | `8`
`service.type` | type of service | `ClusterIP`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`image.repository` | Image repository | `gcr.io/google-containers/fluentd-elasticsearch`
`image.tag` | Image tag | `v2.4.0`
`imagePullSecrets` | Specify image pull secrets | `nil` (does not add image pull secrets to deployed pods)
`ingress.enabled` | enable ingress | `false`
`nodeSelector` | node labels for pod assignment | `{}`
`replicaCount` | desired number of pods | `1` ???
`resources` | pod resource requests & limits | `{}`
`priorityClassName` | priorityClassName | `nil`
`service.port` | port for the service | `80`
`service.type` | type of service | `ClusterIP`
`tolerations` | List of node taints to tolerate | `[]`
`persistence.enabled` | Enable buffer persistence | `false`
`persistence.accessMode` | Access mode for buffer persistence | `ReadWriteOnce`
`persistence.size` | Volume size for buffer persistence | `10Gi`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/fluentd --name my-release \
  --set=image.tag=v0.0.2,resources.limits.cpu=200m
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/fluentd --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
