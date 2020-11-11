# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# **DEPRECATED** This repository has moved

With upcoming deprecation of `helm/charts` repository, the Node Problem Detector Helm Chart has moved to Delivery Hero's Helm Repository: https://github.com/deliveryhero/helm-charts

You can use this new Helm repository by doing:

```bash
helm repo add deliveryhero https://charts.deliveryhero.io/public
helm search repo deliveryhero
```

You can now use `deliveryhero/node-problem-detector` instead of `stable/node-problem-detector` in all your Helm commands, e.g.:

```bash
# New installation
helm install --name <RELEASE_NAME> deliveryhero/node-problem-detector
# Upgrade existing installation
helm upgrade --name <RELEASE_NAME> deliveryhero/node-problem-detector
```

# Kubernetes Node Problem Detector

This chart installs a [node-problem-detector](https://github.com/kubernetes/node-problem-detector) daemonset. This tool aims to make various node problems visible to the upstream layers in cluster management stack. It is a daemon which runs on each node, detects node problems and reports them to apiserver.

## TL;DR;

```console
$ helm install stable/node-problem-detector
```

## Prerequisites

- Kubernetes 1.9+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release` and default configuration:

```console
$ helm install my-release stable/node-problem-detector
```

To install the chart with the release name `my-release` and custom configuration with yaml a file in the kube-system namespace:

```console
$ helm install my-release stable/node-problem-detector --values values.yaml --namespace kube-system
```

## Uninstalling the Chart

To delete the chart:

```console
$ helm delete my-release
```

## Configuration

Custom System log monitor config files can be created, see [here](https://github.com/kubernetes/node-problem-detector/tree/master/config) for examples.

The following table lists the configurable parameters for this chart and their default values.

| Parameter                             | Description                                | Default                                                      |
|---------------------------------------|--------------------------------------------|--------------------------------------------------------------|
| `affinity`                            | Map of node/pod affinities                 | `{}`                                                         |
| `annotations`                         | Optional daemonset annotations             | `{}`                                                         |
| `fullnameOverride`                    | Override the fullname of the chart         | `nil`                                                        |
| `image.pullPolicy`                    | Image pull policy                          | `IfNotPresent`                                               |
| `image.repository`                    | Image                                      | `k8s.gcr.io/node-problem-detector`                           |
| `image.tag`                           | Image tag                                  | `v0.8.1`                                                     |
| `hostpath.logdir`                     | Log directory path on K8s host             | `/var/log`                                                   |
| `nameOverride`                        | Override the name of the chart             | `nil`                                                        |
| `rbac.create`                         | RBAC                                       | `true`                                                       |
| `rbac.pspEnabled`                     | PodSecuritypolicy                          | `false`                                                      |
| `hostNetwork`                         | Run pod on host network                    | `false`                                                      |
| `priorityClassName`                   | Priority class name                        | `""`                                                         |
| `securityContext`                     | Pod security context                       | `{privileged: true}`                                         |
| `resources`                           | Pod resource requests and limits           | `{}`                                                         |
| `settings.custom_monitor_definitions` | User-specified custom monitor definitions  | `{}`                                                         |
| `settings.log_monitors`               | System log monitor config files            | `[/config/kernel-monitor.json, /config/docker-monitor.json]` |
| `settings.custom_plugin_monitors`     | Custom plugin monitor config files         | `[]`                                                         |
| `settings.prometheus_address`         | Prometheus exporter address                | `0.0.0.0`                                                    |
| `settings.prometheus_port`            | Prometheus exporter port                   | `20257`                                                      |
| `settings.heartBeatPeriod`            | Syncing interval with API server           | `5m0s`                                                       |
| `serviceAccount.create`               | Whether a ServiceAccount should be created | `true`                                                       |
| `serviceAccount.name`                 | Name of the ServiceAccount to create       | Generated value from template                                |
| `tolerations`                         | Optional daemonset tolerations             | `[{effect: NoSchedule, operator: Exists}]`                   |
| `nodeSelector`                        | Optional daemonset nodeSelector            | `{}`                                                         |
| `env`                                 | Optional daemonset environment variables   | `[]`                                                         |
| `labels`                              | Optional daemonset labels                  | `{}`                                                         |
| `extraVolumes`                        | Optional daemonset volumes to add          | `[]`                                                         |
| `extraVolumeMounts`                   | Optional daemonset volumeMounts to add     | `[]`                                                         |
| `updateStrategy`                      | Manage the daemonset update strategy       | `RollingUpdate`                                              |
| `maxUnavailable`                      | The max pods unavailable during an update  | `1`                                                          |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install` or provide a YAML file containing the values for the above parameters.
