# fluentd

[Fluentd](https://www.fluentd.org/) collects events from various data sources and writes them to files, RDBMS, NoSQL, IaaS, SaaS, Hadoop and so on. Fluentd helps you unify your logging infrastructure (Learn more about the Unified Logging Layer).

## TL;DR;

```console
$ helm install stable/fluentd
```

## Introduction

This chart bootstraps an fluentd deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install stable/fluentd --name my-release
```

The command deploys fluentd on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Autoscaling

By enabling autoscaling the chart will use statefulset with hpa instead of ceployment with PVC.
Please be noted to [statefulset limitation](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#limitations)
The autoscaling is disabled by default for backward compatibility

## Configuration

The following table lists the configurable parameters of the fluentd chart and their default values.

Parameter | Description | Default
--- | --- | ---
`affinity` | node/pod affinities | `{}`
`configMaps` | Fluentd configuration | See [values.yaml](values.yaml)
`output.host` | output host | `elasticsearch-client.default.svc.cluster.local`
`output.port` | output port | `9200`
`output.scheme` | output port | `http`
`output.sslVersion` | output ssl version | `TLSv1`
`output.buffer_chunk_limit` | output buffer chunk limit | `2M`
`output.buffer_queue_limit` | output buffer queue limit | `8`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`image.repository` | Image repository | `gcr.io/google-containers/fluentd-elasticsearch`
`image.tag` | Image tag | `v2.4.0`
`imagePullSecrets` | Specify image pull secrets | `nil` (does not add image pull secrets to deployed pods)
`extraEnvVars` | Adds additional environment variables to the deployment (in yaml syntax) | `{}` See [values.yaml](values.yaml)
`ingress.enabled` | enable ingress | `false`
`ingress.labels` | list of labels for the ingress rule | See [values.yaml](values.yaml)
`ingress.annotations` | list of annotations for the ingress rule | `kubernetes.io/ingress.class: nginx` See [values.yaml](values.yaml)
`ingress.hosts` | host definition for ingress | See [values.yaml](values.yaml)
`ingress.tls` | tls rules for ingress | See [values.yaml](values.yaml)
`nodeSelector` | node labels for pod assignment | `{}`
`replicaCount` | desired number of pods | `1` ???
`resources` | pod resource requests & limits | `{}`
`priorityClassName` | priorityClassName | `nil`
`service.ports` | port definition for the service | See [values.yaml](values.yaml)
`service.type` | type of service | `ClusterIP`
`service.annotations` | list of annotations for the service | `{}`
`tolerations` | List of node taints to tolerate | `[]`
`persistence.enabled` | Enable buffer persistence | `false`
`persistence.accessMode` | Access mode for buffer persistence | `ReadWriteOnce`
`persistence.size` | Volume size for buffer persistence | `10Gi`
`autoscaling.enabled` | Set this to `true` to enable autoscaling | `false`
`autoscaling.minReplicas` | Set minimum number of replicas | `2`
`autoscaling.maxReplicas` | Set maximum number of replicas | `5`
`autoscaling.metrics` | metrics used for autoscaling | See [values.yaml](values.yaml)
`terminationGracePeriodSeconds` | Optional duration in seconds the pod needs to terminate gracefully | `30`
`metrics.enabled`                         | Set this to `true` to enable Prometheus metrics HTTP endpoint                         | `false`
`metrics.service.port`                    | Prometheus metrics HTTP endpoint port                                                 | `24231`
`metrics.serviceMonitor.enabled`          | Set this to `true` to create ServiceMonitor for Prometheus operator                   | `false`
`metrics.serviceMonitor.additionalLabels` | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `{}`
`metrics.serviceMonitor.namespace`        | Optional namespace in which to create ServiceMonitor                                  | `nil`
`metrics.serviceMonitor.interval`         | Scrape interval. If not set, the Prometheus default scrape interval is used           | `nil`
`metrics.serviceMonitor.scrapeTimeout`    | Scrape timeout. If not set, the Prometheus default scrape timeout is used             | `nil`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/fluentd --name my-release \
  --set=image.tag=v0.0.2,resources.limits.cpu=200m
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/fluentd --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
