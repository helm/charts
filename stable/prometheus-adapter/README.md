# Prometheus Adapter

Installs the [Prometheus Adapter](https://github.com/DirectXMan12/k8s-prometheus-adapter) for the Custom Metrics API. Custom metrics are used in Kubernetes by [Horizontal Pod Autoscalers](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) to scale workloads based upon your own metric pulled from an external metrics provider like Prometheus. This chart complements the [metrics-server](https://github.com/helm/charts/tree/master/stable/metrics-server) chart that provides resource only metrics.

## Prerequisites

Kubernetes 1.11+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/prometheus-adapter
```

This command deploys the prometheus adapter with the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Using the Chart

To use the chart, ensure the `prometheus.url` and `prometheus.port` are configured with the correct Prometheus service endpoint. Additionally, the chart comes with a set of default rules out of the box but they may pull in too many metrics or not map them correctly for your needs. Therefore, it is recommended to populate `rules.custom` with a list of rules (see the [config document](https://github.com/DirectXMan12/k8s-prometheus-adapter/blob/master/docs/config.md) for the proper format). Finally, to configure your Horizontal Pod Autoscaler to use the custom metric, see the custom metrics section of the [HPA walkthrough](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/#autoscaling-on-multiple-metrics-and-custom-metrics).

The Prometheus Adapter can serve three different [metrics APIs](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#support-for-metrics-apis):

### Custom Metrics

Enabling this option will cause custom metrics to be served at `/apis/custom.metrics.k8s.io/v1beta1`. Enabled by default when `rules.default` is true, but can be customized by populating `rules.custom`:

```
rules:
  custom:
  - seriesQuery: '{__name__=~"^some_metric_count$"}'
    resources:
      template: <<.Resource>>
    name:
      matches: ""
      as: "my_custom_metric"
    metricsQuery: sum(<<.Series>>{<<.LabelMatchers>>}) by (<<.GroupBy>>)
```

### External Metrics

Enabling this option will cause external metrics to be served at `/apis/external.metrics.k8s.io/v1beta1`. Can be enabled by populating `rules.external`:

```
rules:
  external:
  - seriesQuery: '{__name__=~"^some_metric_count$"}'
    resources:
      template: <<.Resource>>
    name:
      matches: ""
      as: "my_external_metric"
    metricsQuery: sum(<<.Series>>{<<.LabelMatchers>>}) by (<<.GroupBy>>)
```

### Resource Metrics

Enabling this option will cause resource metrics to be served at `/apis/metrics.k8s.io/v1beta1`. Resource metrics will allow pod CPU and Memory metrics to be used in [Horizontal Pod Autoscalers](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) as well as the `kubectl top` command. Can be enabled by populating `rules.resource`:

```
rules:
  resource:
    cpu:
      containerQuery: sum(rate(container_cpu_usage_seconds_total{<<.LabelMatchers>>}[3m])) by (<<.GroupBy>>)
      nodeQuery: sum(rate(container_cpu_usage_seconds_total{<<.LabelMatchers>>, id='/'}[3m])) by (<<.GroupBy>>)
      resources:
        overrides:
          instance:
            resource: node
          namespace:
            resource: namespace
          pod_name:
            resource: pod
      containerLabel: container_name
    memory:
      containerQuery: sum(container_memory_working_set_bytes{<<.LabelMatchers>>}) by (<<.GroupBy>>)
      nodeQuery: sum(container_memory_working_set_bytes{<<.LabelMatchers>>,id='/'}) by (<<.GroupBy>>)
      resources:
        overrides:
          instance:
            resource: node
          namespace:
            resource: namespace
          pod_name:
            resource: pod
      containerLabel: container_name
    window: 3m
```

**NOTE:** Setting a value for `rules.resource` will also deploy the resource metrics API service, providing the same functionality as [metrics-server](https://github.com/helm/charts/tree/master/stable/metrics-server). As such it is not possible to deploy them both in the same cluster.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Prometheus Adapter chart and their default values.

| Parameter                       | Description                                                                     | Default                                     |
| ------------------------------- | ------------------------------------------------------------------------------- | --------------------------------------------|
| `affinity`                      | Node affinity                                                                   | `{}`                                        |
| `image.repository`              | Image repository                                                                | `directxman12/k8s-prometheus-adapter-amd64` |
| `image.tag`                     | Image tag                                                                       | `v0.5.0`                                    |
| `image.pullPolicy`              | Image pull policy                                                               | `IfNotPresent`                              |
| `image.pullSecrets`             | Image pull secrets                                                              | `{}`                                        |
| `logLevel`                      | Log level                                                                       | `4`                                         |
| `metricsRelistInterval`         | Interval at which to re-list the set of all available metrics from Prometheus   | `1m`                                        |
| `nodeSelector`                  | Node labels for pod assignment                                                  | `{}`                                        |
| `priorityClassName`             | Pod priority                                                                    | ``                                          |
| `prometheus.url`                | Url of where we can find the Prometheus service                                 | `http://prometheus.default.svc`             |
| `prometheus.port`               | Port of where we can find the Prometheus service, zero to omit this option      | `9090`                                      |
| `rbac.create`                   | If true, create & use RBAC resources                                            | `true`                                      |
| `resources`                     | CPU/Memory resource requests/limits                                             | `{}`                                        |
| `rules.default`                 | If `true`, enable a set of default rules in the configmap                       | `true`                                      |
| `rules.custom`                  | A list of custom configmap rules                                                | `[]`                                        |
| `rules.existing`                | The name of an existing configMap with rules. Overrides default, custom and external. | ``                                    |
| `rules.external`                | A list of custom rules for external metrics API                                 | `[]`                                        |
| `rules.resource`                | `resourceRules` to set in configmap rules                                       | `{}`                                        |
| `service.annotations`           | Annotations to add to the service                                               | `{}`                                        |
| `service.port`                  | Service port to expose                                                          | `443`                                       |
| `service.type`                  | Type of service to create                                                       | `ClusterIP`                                 |
| `serviceAccount.create`         | If true, create & use Serviceaccount                                            | `true`                                      |
| `serviceAccount.name`           | If not set and create is true, a name is generated using the fullname template  | ``                                          |
| `tls.enable`                    | If true, use the provided certificates. If false, generate self-signed certs    | `false`                                     |
| `tls.ca`                        | Public CA file that signed the APIService (ignored if tls.enable=false)         | ``                                          |
| `tls.key`                       | Private key of the APIService (ignored if tls.enable=false)                     | ``                                          |
| `tls.certificate`               | Public key of the APIService (ignored if tls.enable=false)                      | ``                                          |
| `tolerations`                   | List of node taints to tolerate                                                 | `[]`                                        |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set logLevel=1 \
 stable/prometheus-adapter
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/prometheus-adapter
```
