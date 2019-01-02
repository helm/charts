# Spartakus

[Spartakus](https://github.com/kubernetes-incubator/spartakus) aims to collect information about Kubernetes clusters. This information will help the Kubernetes development team to understand what people are doing with it, and to make it a better product.

## TL;DR;

```console
$ helm install stable/spartakus
```

## Introduction

This chart bootstraps a [Spartakus](https://github.com/kubernetes-incubator/spartakus) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.3+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install stable/spartakus --name my-release
```

The command deploys Spartakus on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Spartakus chart and their default values.

Parameter | Description | Default
--- | --- | ---
`extraArgs` | Additional container arguments | `{}`
`image.repository` | Image | `k8s.gcr.io/spartakus-amd64`
`image.tag` | Image tag | `v1.0.0`
`image.pullPolicy` | Image pull policy | `Always` if `image.tag` is `latest`, else `IfNotPresent`
`nodeSelector` | node labels for pod assignment | `{}`
`podAnnotations` | annotations to be added to pods | `{}`
`replicaCount` | desired number of pods | `1`
`resources` | pod resource requests & limits | `{}`
`uuid` | Unique cluster ID | Dynamically generated using `uuidv4` template function

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/spartakus --name my-release \
    --set uuid=19339C6E-FD73-4787-BFD8-F710C8D8364E
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/spartakus --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
