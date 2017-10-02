# kubernetes-dashboard

[Kubernetes Dashboard](https://github.com/kubernetes/dashboard) is a general purpose, web-based UI for Kubernetes clusters. It allows users to manage applications running in the cluster and troubleshoot them, as well as manage the cluster itself.


## TL;DR;

```console
$ helm install stable/kubernetes-dashboard
```

## Introduction

This chart bootstraps a [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install stable/kubernetes-dashboard --name my-release
```

The command deploys kubernetes-dashboard on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the kubernetes-dashboard chart and their default values.

| Parameter             | Description                        | Default                                                                  |
|-----------------------|------------------------------------|--------------------------------------------------------------------------|
| `image`               | Image                              | `gcr.io/google_containers/kubernetes-dashboard-amd64`                    |
| `imageTag`            | Image tag                          | `v1.7.0`                                                                 |
| `imagePullPolicy`     | Image pull policy                  | `IfNotPresent`                                                           |
| `nodeSelector`        | node labels for pod assignment     | `{}`                                                                     |
| `httpPort`            | Dashboard port                     | 80                                                                       |
| `resources`           | Pod resource requests & limits     | `limits: {cpu: 100m, memory: 50Mi}, requests: {cpu: 100m, memory: 50Mi}` |
| `ingress.annotations` | Specify ingress class              | `kubernetes.io/ingress.class: nginx`                                     |
| `ingress.enabled`     | Enable ingress controller resource | `false`                                                                  |
| `ingress.hosts`       | Dashboard Hostnames                | `nil`                                                                    |
| `ingress.tls`         | Ingress TLS configuration          | `[]`                                                                     |
| `rbac.create`         | Create & use RBAC resources        | `false`                                                                  |
| `rbac.serviceAccountName` |  ServiceAccount kubernetes-dashboard will use (ignored if rbac.create=true) | `default`        |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/kubernetes-dashboard --name my-release \
  --set=httpPort=8080,resources.limits.cpu=200m
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/kubernetes-dashboard --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
