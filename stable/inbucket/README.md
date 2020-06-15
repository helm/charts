# Inbucket

[Inbucket](https://www.inbucket.org/) is an e-mail testing tool.

## TL;DR;

```bash
$ helm install stable/inbucket
```

## Introduction

This chart creates a [Inbucket](https://www.inbucket.org/) deployment on a [Kubernetes](http://kubernetes.io)
cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/inbucket
```

The command deploys Inbucket on the Kubernetes cluster in the default configuration. The [configuration](#configuration)
section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Inbucket chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.repository` | container image repository | `jhillyerd/inbucket`
`image.tag` | container image tag | `release-1.2.0`
`image.pullPolicy` | container image pull policy | `IfNotPresent`
`nodeSelector` | node labels for pod assignment | `{}`
`podAnnotations` | annotations to be added to pods | `{}`
`resources` | pod resource requests & limits | `{}`
`service.annotations` | annotations for the service | `{}`
`service.clusterIP` | internal cluster service IP | `""`
`service.externalIPs` | service external IP addresses | `[]`
`service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`service.type` | type of service to create | `ClusterIP`
`service.node.http` | http port of service. Should be the same you set in INBUCKET_WEB_ADDR | `""`
`service.node.smtp` | smtp port of service. Should be the same you set in INBUCKET_SMTP_ADDR | `""`
`service.node.pop3` | pop3 port of service. Should be the same you set in INBUCKET_POP3_ADDR | `""`
`service.nodePort.http` | if `service.type` is `NodePort` and this is non-empty, sets the http node port of the service | `""`
`service.nodePort.smtp` | if `service.type` is `NodePort` and this is non-empty, sets the smtp node port of the service | `""`
`service.nodePort.pop3` | if `service.type` is `NodePort` and this is non-empty, sets the pop3 node port of the service | `""`
`ingress.enabled` | if `true`, an ingress is created | `false`
`ingress.annotations` | annotations for the ingress | `{}`
`ingress.path` | if `true`, an ingress is created | `/`
`ingress.hosts` | a list of ingress hosts | `[inbucket.example.com]`
`ingress.tls` | a list of [IngressTLS](https://v1-8.docs.kubernetes.io/docs/api-reference/v1.8/#ingresstls-v1beta1-extensions) items | `[]`
`config` | The inbucket config you can use [this configurator](http://www.inbucket.org/configurator/) to adjust you config.| set to defaults

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set image.tag=release-1.2.0 \
    stable/inbucket
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/inbucket
```

## Limitations


## Thanks

This chart was inspired in the Mailhog tool, which is another testing email tool, for more [Mailhog](https://github.com/kubernetes/charts/tree/master/stable/mailhog).
