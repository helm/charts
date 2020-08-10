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

| Parameter                 | Description                                                                                          | Default                                                           |
| ------------------------- | ---------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| `replicaCount`            | Number of replicas to run                                                                            | `1`                                                               |
| `name`                    | How to name resources created by this chart                                                          | `kube-downscaler`                                                 |
| `debug.enable`            | Do you want to start the downscaler in debug mode                                                    | `false`                                                           |
| `namespace.active_in`     | Which namespace does the downscaler scans for deployment/statefulsets to downscale (`''` equals all) | `''`                                                              |
| `interval`                | Interval between scans, in seconds                                                                   | `60`                                                              |
| `image.repository`        | Downscaler container image repository                                                                | `hjacobs/kube-downscaler`                                         |
| `image.tag`               | Downscaler container image tag                                                                       | `20.5.0`                                                          |
| `image.pullPolicy`        | Downscaler container image pull policy                                                               | `IfNotPresent`                                                    |
| `nodeSelector`            | Node labels for downscaler pod assignment                                                            | `{}`                                                              |
| `tolerations`             | Downscaler pod toleration for taints                                                                 | `[]`                                                              |
| `affinity`                | Downscaler pod affinity                                                                              | `{}`                                                              |
| `podAnnotations`          | Annotations to be added to downscaler pod                                                            | `{}`                                                              |
| `podLabels`               | Labels to be added to downscaler pod                                                                 | `{}`                                                              |
| `resources`               | Downscaler pod resource requests & limits                                                            | `{}`                                                              |
| `securityContext`         | SecurityContext to apply to the downscaler pod                                                       | `{}`                                                              |
| `rbac.create`             | If true, create & use RBAC resources                                                                 | `true`                                                            |
| `rbac.serviceAccountName` | ServiceAccount downscaler will use (ignored if rbac.create=true)                                     | `default`                                                         |
| `downscaleResources`      | Resources the downscaler is allowed to manage                                                        | `[deployments, statefulsets, horizontalpodautoscalers, cronjobs]` |
| `excludedDeployments`     | Deployments to exclude from the downscaler                                                           | `[]`                                                              |
| `excludedNamespaces`      | Namespaces to exclude from the downscaler                                                            | `[]`                                                              |
| `extraArgs`               | Add extra args to docker command                                                                     | `[]`                                                              |

> **Tip**: You can use the default [values.yaml](values.yaml)

> **Tip**: If you use `kube-downscaler` as releaseName, the generated pod name will be shorter.(e.g. `kube-downscaler-66cc9fb67c-7mg4w` instead of `my-release-kube-downscaler-66cc9fb67c-7mg4w`)
