# prometheus-to-sd

[prometheus-to-sd](https://github.com/GoogleCloudPlatform/k8s-stackdriver/tree/master/prometheus-to-sd) is a simple component that can scrape metrics stored in prometheus text format from one or multiple components and push them to the Stackdriver

## TL;DR;

```bash
$ helm install stable/prometheus-to-sd
```


## Prerequisites

- a service exposing metrics in prometheus format
- k8s cluster should run on GCE or GKE

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/prometheus-to-sd
```

The command deploys prometheus-to-sd on the Kubernetes cluster in the default configuration.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters and their default values.

| Parameter          | Description                                                                               | Default                                                    |
| ------------------ | ----------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| `image.repository` | prometheus-to-sd image repository                                                         | `gcr.io/google-containers/prometheus-to-sd`                |
| `image.tag`        | prometheus-to-sd image tag                                                                | `v0.5.2`                                                   |
| `image.pullPolicy` | Image pull policy                                                                         | `IfNotPresent`                                             |
| `resources`        | CPU/Memory resource requests/limits                                                       | `{}`                                                       |
| `port`             | Profiler port                                                                             | `6060`                                                     |
| `metricSources`    | Sources for metrics in the next format: component-name:http://host:port?whitelisted=a,b,c | `{"kube-state-metrics": "http://kube-state-metrics:8080"}` |
| `nodeSelector`     | node labels for pod assignment                                                            | `{}`                                                       |
| `tolerations`      | tolerations for node taints                                                               | `[]`                                                       |

For more information please refer to the [prometheus-to-sd](https://github.com/GoogleCloudPlatform/k8s-stackdriver/tree/master/prometheus-to-sd) documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set "metricsSources.kube-state-metrics=http://kube-state-metrics:8080" \
    stable/prometheus-to-sd
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/prometheus-to-sd
```

Multiple metrics sources can be defined.
