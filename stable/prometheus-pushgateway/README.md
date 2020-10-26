# Prometheus Pushgateway

DEPRECATED and moved to <https://github.com/prometheus-community/helm-charts>

* Installs prometheus [pushgateway](https://github.com/prometheus/pushgateway)

## TL;DR;

```console
$ helm install stable/prometheus-pushgateway
```

## Introduction

This chart bootstraps a prometheus [pushgateway](http://github.com/prometheus/pushgateway) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

An optional prometheus `ServiceMonitor` can be enabled, should you wish to use this gateway with a [Prometheus Operator](https://github.com/coreos/prometheus-operator).

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/prometheus-pushgateway
```

The command deploys pushgateway on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the pushgateway chart and their default values.

|        Parameter                  |                                                          Description                                                          |      Default                      |
| --------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `affinity`                        | Affinity settings for pod assignment                                                                                          | `{}`                              |
| `extraArgs`                       | Optional flags for pushgateway                                                                                                | `[]`                              |
| `extraVars`                       | Optional environment variables for pushgateway                                                                                | `[]`                              |
| `image.repository`                | Image repository                                                                                                              | `prom/pushgateway`                |
| `image.tag`                       | Image tag                                                                                                                     | `v1.2.0`                          |
| `image.pullPolicy`                | Image pull policy                                                                                                             | `IfNotPresent`                    |
| `ingress.enabled`                 | Enables Ingress for pushgateway                                                                                               | `false`                           |
| `ingress.annotations`             | Ingress annotations                                                                                                           | `{}`                              |
| `ingress.hosts`                   | Ingress accepted hostnames                                                                                                    | `nil`                             |
| `ingress.tls`                     | Ingress TLS configuration                                                                                                     | `[]`                              |
| `resources`                       | CPU/Memory resource requests/limits                                                                                           | `{}`                              |
| `replicaCount`                    | Number of replicas                                                                                                            | `1`                               |
| `strategy`                        | Deployment strategy                                                                                                           | `{ "type": "Recreate" }`          |
| `service.type`                    | Service type                                                                                                                  | `ClusterIP`                       |
| `service.port`                    | The service port                                                                                                              | `9091`                            |
| `service.nodePort`                | The optional service node port when `service.type` is `NodePort`                                                              | ``                                |
| `service.targetPort`              | The target port of the container                                                                                              | `9091`                            |
| `serviceAnnotations`              | Annotations for the service                                                                                                   | `{}`                              |
| `serviceLabels`                   | Labels for service                                                                                                            | `{}`                              |
| `serviceAccount.create`           | Specifies whether a service account should be created.                                                                        | `true`                            |
| `serviceAccount.name`             | Service account to be used. If not set and `serviceAccount.create` is `true`, a name is generated using the fullname template |                                   |
| `tolerations`                     | List of node taints to tolerate                                                                                               | `{}`                              |
| `nodeSelector`                    | Node labels for pod assignment                                                                                                | `{}`                              |
| `podAnnotations`                  | Annotations for pod                                                                                                           | `{}`                              |
| `podLabels`                       | Labels for pod                                                                                                                | `{}`                              |
| `serviceAccountLabels`            | Labels for service account                                                                                                    | `{}`                              |
| `persistentVolumeLabels`          | Labels for persistent volume                                                                                                  | `{}`                              |
| `serviceMonitor.enabled`          | if `true`, creates a Prometheus Operator ServiceMonitor                                                                       | `false`                           |
| `serviceMonitor.namespace`        | Namespace which Prometheus is running in                                                                                      | `monitoring`                      |
| `serviceMonitor.interval`         | How frequently to scrape metrics (use by default, falling back to Prometheus' default)                                        | `nil`                             |
| `serviceMonitor.scrapeTimeout`    | How long to scrape metrics before timing out. (use by default, falling back to Prometheus' default)                           | `nil`                             |
| `serviceMonitor.additionalLables` | Used to pass Labels that are required by the Installed Prometheus Operator                                                    | `{}`                              |
| `serviceMonitor.honorLabels`      | if `true`, label conflicts are resolved by keeping label values from the scraped data                                         | `true`                            |
| `podDisruptionBudget`             | If set, create a PodDisruptionBudget with the items in this map set in the spec                                               | ``                                |
| `networkPolicy.allowAll`          | Allow connectivity from all pods in the cluster                                                                               | ``                                |
| `networkPolicy.customSelectors`   | Allow connectivity from pods that match a list of podSelectors and namespaceSelectors                                         | ``                                |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set serviceAccount.name=pushgateway  \
    stable/prometheus-pushgateway
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/prometheus-pushgateway
```
