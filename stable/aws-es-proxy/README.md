# aws-es-proxy

[aws-es-proxy](https://github.com/abutaha/aws-es-proxy) is a small web server application sitting between your HTTP client (browser, curl, etc...) and Amazon Elasticsearch service.

## TL;DR;

```console
$ helm install stable/aws-es-proxy --set config.endpoint=https://dummy-host.ap-southeast-2.es.amazonaws.com
```

## Introduction

This chart bootstraps an aws-es-proxy deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install stable/aws-es-proxy --name my-release --set config.endpoint=https://dummy-host.ap-southeast-2.es.amazonaws.com
```

The command deploys aws-es-proxy on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the aws-es-proxy chart and their default values.

Parameter | Description | Default
--- | --- | ---
`affinity` | node/pod affinities | None
`config.awsSecretAccessKey` | value of AWS_ACCESS_KEY_ID envvar. This is required when you don't specify a pod annotation for [kube2iam](https://github.com/jtblin/kube2iam) or [kiam](https://github.com/uswitch/kiam) to provide pods an AWS IAM role | None
`config.awsAccessKeyID` | value of AWS_SECRET_ACCESS_KEY envvar. This is required when you don't specify a pod annotation for [kube2iam](https://github.com/jtblin/kube2iam) or [kiam](https://github.com/uswitch/kiam) to provide pods an AWS IAM role | None
`config.endpoint` | Amazon ElasticSearch Endpoint (e.g: https://dummy-host.eu-west-1.es.amazonaws.com) | None, but required
`config.pretty` | Prettify verbose and file output | `false`
`config.verbose` | Print user requests | `false`
`extraArgs` | key:value list of extra arguments to give the binary | `{}`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`image.repository` | Image repository | `abutaha/aws-es-proxy`
`image.tag` | Image tag | `0.8`
`imagePullSecrets` | Specify image pull secrets | `nil` (does not add image pull secrets to deployed pods)
`ingress.enabled` | enable ingress | `false`
`nodeSelector` | node labels for pod assignment | `{}`
`podAnnotations` | annotations to add to each pod. Include `iam.amazonaws.com/role: ROLE_ARN` to provide pods an AWS IAM role via kube2iam or kiam  | `{}`
`podLabels` | additional labesl to add to each pod | `{}`
`replicaCount` | desired number of pods | `1`
`resources` | pod resource requests & limits | `{}`
`service.port` | port for the service | `9200`
`service.type` | type of service | `ClusterIP`
`tolerations` | List of node taints to tolerate | `[]`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/aws-es-proxy --name my-release \
  --set=image.tag=v0.8,resources.limits.cpu=200m
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/aws-es-proxy --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
