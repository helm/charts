# Kubernetes Node Problem Detector

This chart installs a [node-problem-detector](https://github.com/kubernetes/node-problem-detector) daemonset. This tool aims to make various node problems visible to the upstream layers in cluster management stack. It is a daemon which runs on each node, detects node problems and reports them to apiserver.

## TL;DR;

```console
$ helm install stable/node-problem-detector
```

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release` and default configuration:

```console
$ helm install --name my-release stable/node-problem-detector
```

## Uninstalling the Chart

To delete the chart:

```console
$ helm delete my-release
```

## Configuration

Custom System log monitor config files can be created, see [here](https://github.com/kubernetes/node-problem-detector/tree/master/config) for examples.

The following table lists the configurable parameters for this chart and their default values.

| Parameter                          | Description                     | Default                                                     |
| ---------------------------------- | --------------------------------|-------------------------------------------------------------|
| `annotations`                      | Optional daemonset annotations  | `NULL`                                                      |
| `affinity`                         | Map of node/pod affinities      | `{}`                                                        |
| `settings.log_monitors`            | System log monitor config files | `/config/kernel-monitor.json`,`/config/docker-monitor.json` |
| `image.repository`                 | Image                           | `k8s.gcr.io/node-problem-detector`                          |
| `image.tag`                        | Image tag                       | `v0.5.0`                                                    |
| `image.pullPolicy`                 | Image pull policy               | `IfNotPresent`                                              |
| `rbac.create`                      | RBAC                            | `true`                                                      |
| `resources.limits.cpu`             | CPU limit                       | `200m`                                                      |
| `resources.limits.memory`          | Memory limit                    | `100Mi`                                                     |
| `resources.requests.cpu`           | CPU request                     | `20m`                                                       |
| `resources.requests.memory`        | Memory request                  | `20Mi`                                                      |
| `tolerations`                      | Optional daemonset tolerations  | `NULL`                                                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install` or provide a YAML file containing the values for the above parameters:

```console
$ helm install --name my-release stable/node-problem-detector --values values.yaml
```
