# kibana

[kibana](https://github.com/elastic/kibana) is your window into the Elastic Stack. Specifically, it's an open source (Apache Licensed), browser-based analytics and search dashboard for Elasticsearch.

## TL;DR;

```console
$ helm install incubator/kibana
```

## Introduction

This chart bootstraps a kibana deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install incubator/kibana --name my-release
```

The command deploys kibana on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

There is an additional authorization feature which leverages oauth-proxy. See more information below on how to run Kibana within the cluster behind an oauth-proxy used for easy authentication of selected users.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the kibana chart and their default values.

Parameter | Description | Default
--- | --- | ---
`affinity` | node/pod affinities | None
`env` | Environment variables to configure Kibana | `{}`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`image.repository` | Image repository | `a5huynh/oauth2_proxy`
`image.tag` | Image tag | `2.2`
`ingress.auth.annotations` | annotations to add to the auth ingress resource | `{}`
`ingress.auth.authPath` | http path to redirect to the oauth-proxy service | `/oauth2`
`ingress.auth.enabled` | enable authentication on ingress using oauth-proxy | `false`
`ingress.auth.serviceName` | name of the oauth-proxy service to utilize for authentication and login | `""`
`ingress.auth.servicePort` | port for the oauth-proxy service | `4180`
`ingress.enabled` | enable ingress | `false`
`nodeSelector` | node labels for pod assignment | `{}`
`podAnnotations` | annotations to add to each pod | `{}`
`podLabels` | additional labesl to add to each pod | `{}`
`replicaCount` | desired number of pods | `1`
`resources` | pod resource requests & limits | `{}`
`service.externalPort` | external port for the service | `443`
`service.internalPort` | internal port for the service | `4180`
`service.type` | type of service | `ClusterIP`
`tolerations` | List of node taints to tolerate | `[]`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install incubator/kibana --name my-release \
  --set=image.tag=v0.0.2,resources.limits.cpu=200m
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install incubator/kibana --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
