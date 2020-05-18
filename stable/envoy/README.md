# stable/envoy

[Envoy](https://www.envoyproxy.io/) is an open source edge and service proxy, designed for cloud-native applications.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install stable/envoy --name my-release
```

The command deploys envoy on the Kubernetes cluster with the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the envoy chart and their default values.

Parameter | Description | Default
--- | --- | ---
`args` | Command-line args passed to Envoy | `["-l", "$loglevel", "-c", "/config/envoy.yaml"]`
`argsTemplate` | Golang template of command-line args passed to Envoy. Must be a string containing a template snippet rather than YAML array. Prefered over `args` if both are set | ``
`files.envoy\.yaml` | content of a full envoy configuration file as documented in https://www.envoyproxy.io/docs/envoy/latest/configuration/configuration | See [values.yaml](values.yaml)
`templates.envoy\.yaml` | golang template of a full configuration file. Use the `{{ .Values.foo.bar }}` syntax to embed chart values | See [values.yaml](values.yaml)
`serviceMonitor.enabled` | if `true`, creates a Prometheus Operator ServiceMonitor | `false`
`serviceMonitor.interval` | Interval that Prometheus scrapes Envoy metrics | `15s`
`serviceMonitor.namespace` | Namespace which the operated Prometheus is running in | ``
`serviceMonitor.additionalLabels` | Labels used by Prometheus Operator to discover your Service Monitor. Set according to your Prometheus setup | `{}`
`serviceMonitor.targetLabels` |  Labels to transfer from service onto the target | `[]`    
`serviceMonitor.podTargetLabels`       | Labels to transfor from pod onto the target         | `[]`
`prometheusRule.enabled` | If `true`, creates a Prometheus Operator PrometheusRule | `false`
`prometheusRule.groups` | Prometheus alerting rules | `{}`
`prometheusRule.additionalLabels` | Labels used by Prometheus Operator to discover your Prometheus Rule | `{}`| `volumes` | Additional volumes to be added to Envoy pods
`volumeMounts` | Additional volume mounts to be added to Envoy containers(Primary containers of Envoy pods) | ``
`initContainerTemplate` | Golang template of the init container added to Envoy pods| ``
`sidecarContainersTemplate` | Golang template of additional containers added after the primary container of Envoy pods | ``

All other user-configurable settings, default values and some commentary about them can be found in [values.yaml](values.yaml).

| `serviceMonitor.targetLabels`          | Labels to transfer from service onto the target     | `[]`                               |
| `serviceMonitor.podTargetLabels`       | Labels to transfor from pod onto the target         | `[]`                               |
