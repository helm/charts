# k8s-event-logger

This chart runs a pod that simply watches Kubernetes Events and logs them to stdout in JSON to be collected and stored by your logging solution, e.g. [fluentd](https://github.com/helm/charts/tree/master/stable/fluentd) or [fluent-bit](https://github.com/helm/charts/tree/master/stable/fluent-bit).

https://github.com/max-rocket-internet/k8s-event-logger

Events in Kubernetes log very important information. If are trying to understand what happened in the past then these events show clearly what your Kubernetes cluster was thinking and doing. Some examples:

- Pod events like failed probes, crashes, scheduling related information like `TriggeredScaleUp` or `FailedScheduling`
- HorizontalPodAutoscaler events like scaling up and down
- Deployment events like scaling in and out of ReplicaSets
- Ingress events like create and update

The problem is that these events are simply API objects in Kubernetes and are only stored for about 1 hour. Without some way of storing these events, debugging a problem in the past very tricky.

## Prerequisites

- Kubernetes 1.8+

## Installing the Chart

To install the chart with the release name `my-release` and default configuration:

```shell
$ helm install --name my-release stable/k8s-event-logger
```

## Uninstalling the Chart

To delete the chart:

```shell
$ helm delete my-release
```

## Configuration

The following table lists the configurable parameters for this chart and their default values.

| Parameter                | Description                          | Default                                                |
| -------------------------|--------------------------------------|--------------------------------------------------------|
| `resources`              | Resources for the overprovision pods | `{}`                                                   |
| `image.repository`       | Image repository                     | `tools4k8s/k8s-event-logger`                           |
| `image.tag`              | Image tag                            | `1.2`                                                  |
| `image.pullPolicy`       | Container pull policy                | `IfNotPresent`                                         |
| `affinity`               | Map of node/pod affinities           | `{}`                                                   |
| `nodeSelector`           | Node labels for pod assignment       | `{}`                                                   |
| `annotations`            | Optional deployment annotations      | `{}`                                                   |
| `fullnameOverride`       | Override the fullname of the chart   | `nil`                                                  |
| `nameOverride`           | Override the name of the chart       | `nil`                                                  |
| `tolerations`            | Optional deployment tolerations      | `[]`                                                   |
| `podLabels`              | Additional labels to use for pods    | `{}`                                                   |
| `env.KUBERNETES_API_URL` | URL of the k8s API in your cluster   | `https://172.20.0.1:443`                               |
| `env.CA_FILE`            | Path to the service account CA file  | `/var/run/secrets/kubernetes.io/serviceaccount/ca.crt` |
| `podLabels`              | Additional labels to use for pods    | `{}`                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install` or provide a YAML file containing the values for the above parameters:

```shell
$ helm install --name my-release stable/k8s-event-logger --values values.yaml
```
