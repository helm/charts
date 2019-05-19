# Faktory Helm Chart

[Faktory](https://github.com/contribsys/faktory) is an open-source background jobs server written on Golang. It have got clients for different programming languages.

## TL;DR;

```console
$ helm install incubator/faktory
```

## Introduction

This chart bootstraps a [Faktory](https://github.com/contribsys/faktory) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/faktory
```

The command above deploys Faktory on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command above removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Faktory chart and their default values.

Parameter | Description | Default
--------- | ----------- | -------
`image.repository` | faktory image repository | `contribsys/faktory`
`image.tag` | faktory image tag | `1.0.0`
`image.pullPolicy` | faktory image pullPolicy | `IfNotPresent`
`service.type` | service type | `ClusterIP`
`service.ui_port` | service port for WebUI | `80`
`service.commands_port` | service port for commands | `80`
`ingress.enabled` | If true, an ingress will be created for the api | `false`
`ingress.annotations` | ingress annotations | `{}`
`ingress.path` | ingress path | `/`
`ingress.hosts` | ingress hostnames | `[]`
`ingress.tls` | ingress TLS configuration | `[]`
`resources` | resource requests and limits | `{}`
`nodeSelector` | node selector labels for pod assignment | `{}`
`tolerations` | toleration for pod assignment | `[]`
`affinity` | affinity for pod assignment | `{}`
`password` | WebUI Password | `password`
`persistentVolume.enabled` | If true, create a Persistent Volume Claim | `true`
`persistentVolume.accessModes` | Persistent Volume access modes | `ReadWriteOnce`
`persistentVolume.annotations` | Annotations for Persistent Volume Claim | `{}`
`persistentVolume.existingClaim` | Persistent Volume existing claim name | `""`
`persistentVolume.size` | Persistent Volume size | `1Gi`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install incubator/faktory --name my-release \
    --set api.replicaCount=5
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install incubator/faktory --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
