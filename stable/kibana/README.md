# kibana

[kibana](https://github.com/elastic/kibana) is your window into the Elastic Stack. Specifically, it's an open source (Apache Licensed), browser-based analytics and search dashboard for Elasticsearch.

## TL;DR;

```console
$ helm install stable/kibana
```

## Introduction

This chart bootstraps a kibana deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install stable/kibana --name my-release
```

The command deploys kibana on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the kibana chart and their default values.

Parameter | Description | Default
--- | --- | ---
`replicaCount` | desired number of pods | `1`
`image.repository` | Image repository | `docker.elastic.co/kibana/kibana-oss"`
`image.tag` | Image tag | `6.2.4`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`image.pullSecrets` |Specify image pull secrets | `nil`
`ingress.enabled` | Enables Ingress | `false`
`ingress.annotations` | Ingress annotations | `{}`
`ingress.hosts` | Ingress accepted hostnames | `[]`
`ingress.tls` | Ingress TLS configuration | `[]`
`nodeSelector` | node labels for pod assignment | `{}`
`tolerations` | tolerations pod assignment | `{}`
`affinity` | node/pod affinities | `{}`
`annotations` | annotations to add to each pod | `{}`
`env` | Environment variables to configure Kibana | `{}`
`args` | add additional commandline args | `nil`
`plugins`| plugins that should be installed | `[]`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/kibana --name my-release \
  --set=image.tag=v0.0.2,resources.limits.cpu=200m
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/kibana --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
