# prometheus-operator

Installs [prometheus-operator](https://github.com/coreos/prometheus-operator) to create/configure/manage Prometheus clusters atop Kubernetes.

## TL;DR;

```console
$ helm install coreos/prometheus-operator
```

## Introduction

This chart bootstraps a [prometheus-operator](https://github.com/coreos/prometheus-operator) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.8+ with Beta APIs

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/prometheus-operator
```

The command deploys prometheus-operator on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the prometheus-operator chart and their default values.

|               Parameter               |                                                         Description                                                         |                   Default                   |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| `affinity`                            | node/pod affinities                                                                                                         | None                                        |
| `configmapReload.repository`          | configmap-reload image                                                                                                      | `quay.io/coreos/configmap-reload`           |
| `configmapReload.tag`                 | configmap-reload tag                                                                                                        | `v0.0.1`                                    |
| `image.repository`                    | Image                                                                                                                       | `quay.io/coreos/prometheus-operator`        |
| `image.tag`                           | Image tag                                                                                                                   | `v0.22.0`                                   |
| `image.pullPolicy`                    | Image pull policy                                                                                                           | `IfNotPresent`                              |
| `kubeletService.enable`               | If true, the operator will create a service for scraping kubelets                                                           | `true`                                      |
| `kubeletService.namespace`            | The namespace in which the kubelet service should be created                                                                | `kube-system`                               |
| `kubeletService.name`                 | The name of the kubelet service to be created                                                                               | `kubelet`                                   |
| `nodeSelector`                        | Node labels for pod assignment                                                                                              | `{}`                                        |
| `prometheusConfigReloader.repository` | prometheus-config-reloader image                                                                                            | `quay.io/coreos/prometheus-config-reloader` |
| `prometheusConfigReloader.tag`        | prometheus-config-reloader tag                                                                                              | `v0.0.4`                                    |
| `rbac.create`                         | If true, create & use RBAC resources                                                                                        | `true`                                      |
| `rbac.pspEnabled`                     | Specifies whether a PodSecurityPolicy should be created.                                                                    | `true`                                      |
| `resources`                           | Pod resource requests & limits                                                                                              | `{}`                                        |
| `serviceAccount.name`                 | Service account to be used. If not set and serviceAccount.create is `true`, a name is generated using the fullname template |                                          |
| `serviceAccount.create`               | If true, create a new service account                                                                                       | `true`                                      |
| `tolerations`                         | List of node taints to tolerate                                                                                             | `[]`                                        |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release incubator/prometheus-operator --set sendAnalytics=true
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release incubator/prometheus-operator -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
