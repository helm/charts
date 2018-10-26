# kube-slack

Chart for [kube-slack](https://github.com/wongnai/kube-slack), a monitoring service for Kubernetes.

## Introduction

This chart adds a deployment, listening for cluster-wide pod failures and posting them to your slack channel. A cluster-wide [RBAC](https://kubernetes.io/docs/admin/authorization/rbac/) is created by default, but can also be specified.

## Installing the Chart

To install the chart with the release name `my-release`, configure an [Incoming Webhook](https://my.slack.com/apps/A0F7XDUAZ-incoming-webhooks) in Slack, note its url(`webhook-url` here) and run:

```console
$ helm install stable/kube-slack --set slackUrl=webhook-url --name my-release
```

## Uninstalling the Chart

To uninstall/delete the `my-release` release:

```console
$ helm delete my-release
```

## Configuration

The following table lists the configurable parameters of the kube-slack chart and their default values.

| Parameter               | Description                                                                                                                      | Default               |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `slackUrl`              | Slack Webhook URL to notify (required)                                                                                           | not set               |
| `notReadyMinTime`       | Time to wait after pod become not ready before notifying                                                                         | `60000`               |
| `tickRate`              | How often to update in milliseconds (Default to 15000 or 15s if not set)                                                         | not set               |
| `floodExpire`           | Repeat notification after this many milliseconds has passed after status returned to normal (Default to 60000 or 60s if not set) | not set               |
| `kubeUseKubeconfig`     | Read Kubernetes credentials from active context in `~/.kube/config` (default off if not set)                                     | not set               |
| `kubeUseCluster`        | Read Kubernetes credentials from pod (default on if not set)                                                                     | not set               |
| `kubeNamespacesOnly`    | Monitor a list of specific namespaces, specified either as json array or as a string of comma seperated values                   | not set               |
| `slackChannel`          | Override channel to send                                                                                                         | not set               |
| `slackProxy`            | URL of HTTP proxy used to connect to Slack                                                                                       | not set               |
| `image.repository`      | Container image name                                                                                                             | `willwill/kube-slack` |
| `image.tag`             | Container image tag                                                                                                              | `v3.5.0`              |
| `image.pullPolicy`      | Container pull policy                                                                                                            | `IfNotPresent`        |
| `rbac.create`           | If `true`, create and use RBAC resources                                                                                         | `true`                |
| `serviceAccount.create` | If `true`, create a new service account                                                                                          | `true`                |
| `serviceAccount.name`   | Service account to be used. If not set and `serviceAccount.create` is `true`, a name is generated using the fullname template    |                       |
| `resources`             | CPU/memory resource requests/limits                                                                                              | `{}`                  |
| `nodeSelector`          | Node labels for pod assignment                                                                                                   | `{}`                  |
| `affinity`              | Node affinity for pod assignment                                                                                                 | `{}`                  |
| `tolerations`           | Node tolerations for pod assignment                                                                                              | `[]`                  |

## RBAC
By default the chart will install the recommended RBAC roles and rolebindings.

To determine if your cluster supports this running the following:

```console
$ kubectl api-versions | grep rbac
```

Details on how to enable RBAC can be found in the [official documentation](https://kubernetes.io/docs/admin/authorization/rbac/).
