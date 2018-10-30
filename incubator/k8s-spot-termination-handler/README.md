# k8s-spot-termination-handler

The [K8s Spot Termination handler](https://github.com/pusher/k8s-spot-termination-handler) watches the AWS metadata service when running on Spot Instances.

When a Spot Instance is due to be terminated, precisely 2 minutes before it's termination a "termination notice" is issued. The K8s Spot Termination Handler watches for this and then gracefully drains the node it is running on before the node is taken away by AWS.

## TL;DR:

```console
$ helm install incubator/k8s-spot-termination-handler
```

## Introduction

This chart bootstraps a K8s Spot Termination handler](https://github.com/pusher/k8s-spot-termination-handler) daemon set on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release` and into the namespace `kube-system` (recommended):

```console
$ helm install incubator/k8s-spot-termination-handler --namespace kube-system --name my-release
```

The command deploys k8s-spot-termination-handler on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` daemon set:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Access control

It is critical for the Kubernetes cluster to correctly setup access control of Kubernetes Dashboard. See this [guide](https://github.com/kubernetes/dashboard/wiki/Access-control) for best practises.

It is highly recommended to use RBAC with minimal privileges needed for Spot Termination handler to run.

## Configuration

The following table lists the configurable parameters of the kubernetes-dashboard chart and their default values.

| Parameter               | Description                                                                                                                 | Default                                       |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------|
| `image.repository`      | Repository for container image                                                                                              | `quay.io/pusher/k8s-spot-termination-handler` |
| `image.tag`             | Image tag                                                                                                                   | `v0.1.0`                                      |
| `image.pullPolicy`      | Image pull policy                                                                                                           | `IfNotPresent`                                |
| `nodeSelector`          | node labels for pod assignment                                                                                              | `{}`                                          |
| `tolerations`           | List of node taints to tolerate (requires Kubernetes >= 1.6)                                                                | `[]`                                          |
| `resources`             | Pod resource requests & limits                                                                                              | `{}`                                          |
| `rbac.create`           | Create & use RBAC resources                                                                                                 | `true`                                        |
| `serviceAccount.create` | Whether a new service account name that the agent will use should be created.                                               | `true`                                        |
| `serviceAccount.name`   | Service account to be used. If not set and serviceAccount.create is `true` a name is generated using the fullname template. |                                               |
