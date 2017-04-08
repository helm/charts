# mastodon

Installs [mastodon](https://github.com/tootsuite/mastodon) A GNU Social-compatible microblogging server

## TL;DR;

```console
$ helm install incubator/mastodon
```

## Introduction

This chart bootstraps a [mastodon](https://github.com/tootsuite/mastodon) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install incubator/mastodon --name my-release
```

The command deploys mastodon on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the mastodon chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.repository` | Image | `gargron/mastodon`
`image.tag` | Image tag | `latest`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`environment` | environment for node and rails | `production`
`podAnnotations` | annotations to be added to pods | `{}`
`resources` | pod resource requests & limits | `{}`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install incubator/mastodon \
  --name dev \
  --namespace mastodon \
  --set=environment=development \
  --set=image.repository=ultrableedingedge/mastodon \
  --set=image.pullPolicy=Always
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install incubator/mastodon --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
