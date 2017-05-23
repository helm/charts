# Mailhog

[Mailhog](http://iankent.uk/project/mailhog/) is an e-mail testing tool for developers.

## TL;DR;

```bash
$ helm install stable/mailhog
```

## Introduction

This chart creates a [Mailhog](http://iankent.uk/project/mailhog/) deployment on a [Kubernetes](http://kubernetes.io) 
cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.5+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/mailhog
```

The command deploys Mailhog on the Kubernetes cluster in the default configuration. The [configuration](#configuration) 
section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Mailhog chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.repository` | container image repository | `mailhog/mailhog`
`image.tag` | container image tag | `v1.0.0`
`image.pullPolicy` | container image pull policy | `IfNotPresent`
`auth.enabled` | specifies whether basic authentication is enabled, see [Auth.md](https://github.com/mailhog/MailHog/blob/master/docs/Auth.md) | `false`
`auth.existingSecret` | if auth is enabled, uses an existing secret with this name; otherwise a secret is created | `""`
`auth.fileName` | the name of the auth file | `auth.txt`
`auth.fileContents` | the contents of the auth file | `""`
`nodeSelector` | node labels for pod assignment | `{}`
`podAnnotations` | annotations to be added to pods | `{}`
`resources` | pod resource requests & limits | `{}`
`service.annotations` | annotations for the service | `{}`
`service.clusterIP` | internal cluster service IP | `""`
`service.externalIPs` | service external IP addresses | `[]`
`service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`service.type` | type of service to create | `ClusterIP`
`service.node.http` | http port of service | `""`
`service.node.smtp` | smtp port of service | `""`
`service.nodePort.http` | if `service.type` is `NodePort` and this is non-empty, sets the http node port of the service | `""`
`service.nodePort.smtp` | if `service.type` is `NodePort` and this is non-empty, sets the smtp node port of the service | `""`
`ingress.enabled` | if `true`, an ingress is created | `false`
`ingress.annotations` | annotations for the ingress | `{}`
`ingress.path` | if `true`, an ingress is created | `/`
`ingress.host` | the ingress host | `mailhog.example.com`
`ingress.tls.enabled` | if `true`, tls is enabled for the ingress | `false`
`ingress.tls.existingSecret` | if tls is enabled, uses an existing secret with this name; otherwise a secret is created | `false`
`ingress.tls.secretAnnotations` | annotations for the tls secret | `false`
`ingress.tls.secretContents` | YAML contents for the tls ingress | `false`

`env` | Mailhog environment variables, see [CONFIG.md](https://github.com/mailhog/MailHog/blob/master/docs/CONFIG.md) | `{}`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set env.MH_UI_WEB_PATH=mailhog \
    stable/mailhog
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/mailhog
```

## Limitations

* Disk storage not yet supported (`env.MH_STORAGE: maildir`)
* The `env` property allows Mailhog to be freely configured via environment variables, but not all settings may work,
  e. g. changing ports using `MH_SMTP_BIND_ADDR`, `MH_API_BIND_ADDR`, or `MH_UI_BIND_ADDR` does not make sense with the
  standard Docker image because it would also require exposing different ports.
