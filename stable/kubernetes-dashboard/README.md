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

## Access control
It is critical for the Kubernetes custer to correctly setup access control of Kubernetes Dashboard. See this [guide](https://github.com/kubernetes/dashboard/wiki/Access-control) for best practises.

It is highly recommended to use RBAC with minimal privileges needed for Dashboard to run.

## Configuration

The following table lists the configurable parameters of the kubernetes-dashboard chart and their default values.

| Parameter                 | Description                                                                                                                 | Default                                                                  |
|---------------------------|-----------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------|
| `image.repository`        | Repository for container image                                                                                              | `k8s.gcr.io/kubernetes-dashboard-amd64`                                  |
| `image.tag`               | Image tag                                                                                                                   | `v1.8.3`                                                                 |
| `image.pullPolicy`        | Image pull policy                                                                                                           | `IfNotPresent`                                                           |
| `extraArgs`               | Additional container arguments                                                                                              | `[]`                                                                     |
| `nodeSelector`            | node labels for pod assignment                                                                                              | `{}`                                                                     |
| `tolerations`             | List of node taints to tolerate (requires Kubernetes >= 1.6)                                                                | `[]`                                                                     |
| `service.externalPort`    | Dashboard external port                                                                                                     | 443                                                                      |
| `service.internalPort`    | Dashboard internal port                                                                                                     | 443                                                                      |
| `ingress.annotations`     | Specify ingress class                                                                                                       | `kubernetes.io/ingress.class: nginx`                                     |
| `ingress.enabled`         | Enable ingress controller resource                                                                                          | `false`                                                                  |
| `ingress.hosts`           | Dashboard Hostnames                                                                                                         | `nil`                                                                    |
| `ingress.tls`             | Ingress TLS configuration                                                                                                   | `[]`                                                                     |
| `resources`               | Pod resource requests & limits                                                                                              | `limits: {cpu: 100m, memory: 50Mi}, requests: {cpu: 100m, memory: 50Mi}` |
| `rbac.create`             | Create & use RBAC resources                                                                                                 | `true`                                                                   |
| `rbac.clusterAdminRole`   | "cluster-admin" ClusterRole will be used for dashboard ServiceAccount ([NOT RECOMMENDED](#access-control))                  | `false`                                                                  |
| `serviceAccount.create`   | Whether a new service account name that the agent will use should be created.                                               | `true`                                                                   |
| `serviceAccount.name`     | Service account to be used. If not set and serviceAccount.create is `true` a name is generated using the fullname template. |                                                                          |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/kubernetes-dashboard --name my-release \
  --set=service.externalPort=8080,resources.limits.cpu=200m
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/kubernetes-dashboard --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
