# kube-downscaler

[kube-downscaler](https://github.com/hjacobs/kube-downscaler) Scale down Kubernetes deployments and/or statefulsets during non-work hours.

## TL;DR:
```bash
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm install incubator/kube-downscaler
```

## Introduction

This chart bootstraps an kube-downscaler deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Enable helm incubator repository
```bash
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
```

## Installing the Chart
To install the chart with the release name `my-release` into `kube-system`:

```bash
helm install incubator/kube-downscaler --name my-release --namespace kube-system
```

The command deploys kube-downscaler on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the kube-downscaler chart and their default values.

| Parameter                 | Description                                                                                          | Default                   |
| ------------------------- | ---------------------------------------------------------------------------------------------------- | ------------------------- |
| `debug.enable`            | Do you want to start the downscaler in debug mode                                                    | False                     |
| `namespace.active_in`     | Which namespace does the downscaler scans for deployment/statefulsets to downscale (`''` equals all) | ''                        |
| `interval`                | interval for the scans                                                                               | false                     |
| `image.repository`        | downscaler container image repository                                                                | `hjacobs/kube-downscaler` |
| `image.tag`               | downscaler container image tag                                                                       | `0.6`                     |
| `image.pullPolicy`        | downscaler container image pull policy                                                               | `IfNotPresent`            |
| `nodeSelector`            | node labels for downscaler pod assignment                                                            | `{}`                      |
| `tolerations`             | downscaler pod toleration for taints                                                                 | `{}`                      |
| `podAnnotations`          | annotations to be added to downscaler pod                                                            | `{}`                      |
| `podLabels`               | labels to be added to downscaler pod                                                                 | `{}`                      |
| `resources`               | downscaler pod resource requests & limits                                                            | `{}`                      |
| `rbac.create`             | If true, create & use RBAC resources                                                                 | `false`                   |
| `rbac.serviceAccountName` | ServiceAccount downscaler will use (ignored if rbac.create=true)                                     | `default`                 |

> **Tip**: You can use the default [values.yaml](values.yaml)

> **Tip**: If you use `kube-downscaler` as releaseName, the generated pod name will be shorter.(e.g. `kube-downscaler-66cc9fb67c-7mg4w` instead of `my-release-kube-downscaler-66cc9fb67c-7mg4w`)