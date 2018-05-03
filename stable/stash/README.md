**This chart is DEPRECATED and moved to https://github.com/appscode/charts**

# Stash
[Stash by AppsCode](https://github.com/appscode/stash) - Backup your Kubernetes Volumes
## TL;DR;

```console
$ helm install stable/stash
```

## Introduction

This chart bootstraps a [Stash controller](https://github.com/appscode/stash) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+

## Installing the Chart
To install the chart with the release name `my-release`:
```console
$ helm install stable/stash --name my-release
```
The command deploys Stash operator on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release`:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Stash chart and their default values.


| Parameter                           | Description                                                       | Default            |
| ----------------------------------- | ----------------------------------------------------------------- | ------------------ |
| `replicaCount`                      | Number of Stash operator replicas to create (only 1 is supported) | `1`                |
| `operator.image`                    | operator container image                                          | `appscode/stash`   |
| `operator.tag`                      | operator container image tag                                      | `0.7.0-rc.1`       |
| `operator.pullPolicy`               | operator container image pull policy                              | `IfNotPresent`     |
| `pushgateway.image`                 | Prometheus pushgateway container image                            | `prom/pushgateway` |
| `pushgateway.tag`                   | Prometheus pushgateway container image tag                        | `v0.4.0`           |
| `pushgateway.pullPolicy`            | Prometheus pushgateway container image pull policy                | `IfNotPresent`     |
| `criticalAddon`                     | If true, installs Stash operator as critical addon                | `false`            |
| `rbac.create`                       | If `true`, create and use RBAC resources                          | `true`             |
| `serviceAccount.create`             | If `true`, create a new service account                           | `true`             |
| `serviceAccount.name`               | Service account to be used. If not set and `serviceAccount.create` is `true`, a name is generated using the fullname template | `` |
| `apiserver.groupPriorityMinimum`    | The minimum priority the group should have                       | 10000              |
| `apiserver.versionPriority`         | The ordering of this API inside of the group                     | 15                 |
| `apiserver.enableValidatingWebhook` | Enable validating webhooks for Stash CRDs                         | false              |
| `apiserver.enableMutatingWebhook`   | Enable mutating webhooks for Kubernetes workloads                 | false              |
| `apiserver.ca`                      | CA certificate used by main Kubernetes api server                 | ``                 |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install --name my-release --set image.tag=v0.2.1 stable/stash
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```console
$ helm install --name my-release --values values.yaml stable/stash
```

## RBAC
By default the chart will not install the recommended RBAC roles and rolebindings.

You need to have the flag `--authorization-mode=RBAC` on the api server. See the following document for how to enable [RBAC](https://kubernetes.io/docs/admin/authorization/rbac/).

To determine if your cluster supports RBAC, run the following command:

```console
$ kubectl api-versions | grep rbac
```

If the output contains "beta", you may install the chart with RBAC enabled (see below).

### Enable RBAC role/rolebinding creation

To enable the creation of RBAC resources (On clusters with RBAC). Do the following:

```console
$ helm install --name my-release stable/stash --set rbac.create=true
```
