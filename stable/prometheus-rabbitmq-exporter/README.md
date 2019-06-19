# prometheus-rabbitmq-exporter

[rabbitmq_exporter](https://github.com/kbudde/rabbitmq_exporter) is a Prometheus exporter for rabbitmq metrics.

## TL;DR;

```bash
$ helm install stable/prometheus-rabbitmq-exporter
```

## Introduction

This chart bootstraps a [rabbitmq_exporter](https://github.com/kbudde/rabbitmq_exporter) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/prometheus-rabbitmq-exporter
```

The command deploys prometheus-rabbitmq-exporter on the Kubernetes cluster in the default configuration.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters and their default values.

| Parameter                | Description                                                            | Default                   |
| ------------------------ | ---------------------------------------------------------------------- | ------------------------- |
| `replicaCount`           | desired number of prometheus-rabbitmq-exporter pods                    | `1`                       |
| `image.repository`       | prometheus-rabbitmq-exporter image repository                          | `kbudde/rabbitmq-exporter`|
| `image.tag`              | prometheus-rabbitmq-exporter image tag                                 | `v0.29.0`                 |
| `image.pullPolicy`       | image pull policy                                                      | `IfNotPresent`            |
| `service.type`           | desired service type                                                   | `ClusterIP`               |
| `service.internalport`   | service listening port                                                 | `9419`                    |
| `service.externalPort`   | public service port                                                    | `9419`                    |
| `resources`              | cpu/memory resource requests/limits                                    | {}                        |
| `loglevel`               | exporter log level                                                     | {}                        |
| `rabbitmq.url`           | rabbitmq management url                                                | `http://myrabbit:15672`   |
| `rabbitmq.user`          | rabbitmq user login                                                    | `guest`                   |
| `rabbitmq.password`      | rabbitmq password login                                                | `guest`                   |
| `rabbitmq.capabilities`  | comma-separated list of capabilities supported by the RabbitMQ server  | `bert,no_sort`            |
| `rabbitmq.include_queues`| regex queue filter. just matching names are exported                   | `.*`                      |
| `rabbitmq.skip_queues`   | regex, matching queue names are not exported                           | `^$`                      |
| `rabbitmq.include_vhost` | regex vhost filter. Only queues in matching vhosts are exported        | `.*`                      |
| `rabbitmq.skip_vhost`    | regex, matching vhost names are not exported. First performs include_vhost, then skip_vhost | `^$` |
| `rabbitmq.skip_verify`   | true/0 will ignore certificate errors of the management plugin         | `false`                   |
| `rabbitmq.exporters`     | List of enabled modules. Just "connections" is not enabled by default  | `exchange,node,overview,queue` |
| `rabbitmq.output_format` | Log ouput format. TTY and JSON are suported                            | `TTY`                     |
| `rabbitmq.timeout`       | timeout in seconds for retrieving data from management plugin          | `30`                      |
| `rabbitmq.max_queues`    | max number of queues before we drop metrics (disabled if set to 0)     | `0`                       |
| `annotations`            | pod annotations for easier discovery                                   | {}                        |
| `prometheus.monitor.enabled` | Set this to `true` to create ServiceMonitor for Prometheus operator | `false` | 
| `prometheus.monitor.additionalLabels` | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | {} | 
| `prometheus.monitor.interval` | Interval at which Prometheus Operator scrapes exporter | `15s` | 
| `prometheus.monitor.namespace` | 	Selector to select which namespaces the Endpoints objects are discovered from. | [] | 

For more information please refer to the [rabbitmq_exporter](https://github.com/kbudde/rabbitmq_exporter) documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set "rabbitmq.url=http://myrabbit:15672" \
    stable/prometheus-rabbitmq-exporter
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/prometheus-rabbitmq-exporter
```
