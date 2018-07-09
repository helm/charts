**This chart is DEPRECATED and moved to https://github.com/appscode/charts**

# Voyager
[Voyager by AppsCode](https://github.com/appscode/voyager) - Secure Ingress Controller for Kubernetes

## TL;DR;

```console
$ helm install stable/voyager
```

## Introduction

This chart bootstraps an [ingress controller](https://github.com/appscode/voyager) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.


## Prerequisites

- Kubernetes 1.8+

## Installing the Chart
To install the chart with the release name `my-release`:
```console
$ helm install --name my-release stable/voyager
```
The command deploys Voyager Controller on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release`:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Voyager chart and their default values.


| Parameter                          | Description                                                   | Default               |
| -----------------------------------| ------------------------------------------------------------- | ----------------------|
| `dockerRegistry`                   | Docker registry used to pull Voyager related images           | `appscode`            |
| `imageTags.voyager`                | Tag of Voyager operator image                                 | `6.0.0`       |
| `imageTags.haproxy`                | Tag of HAProxy container image                                | `1.7.10-6.0.0` |
| `imagePullSecrets`                 | Specify image pull secrets                                    | `nil` (does not add image pull secrets to deployed pods) |
| `imagePullPolicy`                  | Image pull policy                                             | `IfNotPresent`        |
| `cloudProvider`                    | Name of cloud provider                                        | `nil`                 |
| `cloudConfig`                      | Path to cloud config                                          | ``                    |
| `criticalAddon`                    | If true, installs Voyager operator as critical addon          | `false`               |
| `logLevel`                         | Log level for operator                                        | `3`                   |
| `persistence.enabled`              | Enable mounting cloud config                                  | `false`               |
| `persistence.hostPath`             | Host mount path for cloud config                              | `/etc/kubernetes`     |
| `nodeSelector`                     | Node labels for pod assignment                                | `{}`                  |
| `rbac.create`                      | If `true`, create and use RBAC resources                      | `true`                |
| `serviceAccount.create`            | If `true`, create a new service account                       | `true`                |
| `serviceAccount.name`              | Service account to be used. If not set and `serviceAccount.create` is `true`, a name is generated using the fullname template | `` |
| `ingressClass`                     | Ingress class to watch for. If empty, it handles all ingress  | ``                    |
| `apiserver.groupPriorityMinimum`   | The minimum priority the group should have.                   | 10000                 |
| `apiserver.versionPriority`        | The ordering of this API inside of the group.                 | 15                    |
| `apiserver.enableAdmissionWebhook` | Configure apiserver as admission webhooks for Voyager CRDs     | false                 |
| `apiserver.ca`                     | CA certificate used by main Kubernetes api server             | ``                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install --name my-release --set image.tag=v0.2.1 stable/voyager
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```console
$ helm install --name my-release --values values.yaml stable/voyager
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
$ helm install --name my-release stable/voyager --set rbac.create=true
```
