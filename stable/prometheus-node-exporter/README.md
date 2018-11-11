# Prometheus Node Exporter

* Installs prometheus [node exporter](https://github.com/prometheus/node_exporter)

## TL;DR;

```console
$ helm install stable/prometheus-node-exporter
```

## Introduction

This chart bootstraps a prometheus [node exporter](http://github.com/prometheus/node_exporter) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/prometheus-node-exporter
```

The command deploys node exporter on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Node Exporter chart and their default values.

|             Parameter             |                                                          Description                                                          |                 Default                 |     |
| --------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | --------------------------------------- | --- |
| `image.repository`                | Image repository                                                                                                              | `quay.io/prometheus/node-exporter`      |     |
| `image.tag`                       | Image tag                                                                                                                     | `v0.16.0`                               |     |
| `image.pullPolicy`                | Image pull policy                                                                                                             | `IfNotPresent`                          |     |
| `extraArgs`                       | Additional container arguments                                                                                                | `[]`                                    |     |
| `extraHostVolumeMounts`           | Additional host volume mounts                                                                                                 | {}                                      |     |
| `podLabels`                       | Additional labels to be added to pods                                                                                         | {}                                      |     |
| `rbac.create`                     | If true, create & use RBAC resources                                                                                          | `true`                                  |     |
| `rbac.pspEnabled`                 | Specifies whether a PodSecurityPolicy should be created.                                                                      | `true`                                  |     |
| `resources`                       | CPU/Memory resource requests/limits                                                                                           | `{}`                                    |     |
| `service.type`                    | Service type                                                                                                                  | `ClusterIP`                             |     |
| `service.port`                    | The service port                                                                                                              | `9100`                                  |     |
| `service.targetPort`              | The target port of the container                                                                                              | `9100`                                  |     |
| `service.annotations`             | Kubernetes service annotations | `{prometheus.io/scrape: "true"}` |
| `serviceAccount.create`           | Specifies whether a service account should be created.                                                                        | `true`                                  |     |
| `serviceAccount.name`             | Service account to be used. If not set and `serviceAccount.create` is `true`, a name is generated using the fullname template |                                         |     |
| `serviceAccount.imagePullSecrets` | Specify image pull secrets                                                                                                    | `[]`                                    |     |
| `tolerations`                     | List of node taints to tolerate                                                                                               | `- effect: NoSchedule operator: Exists` |     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set serviceAccount.name=node-exporter  \
    stable/prometheus-node-exporter
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/prometheus-node-exporter
```
