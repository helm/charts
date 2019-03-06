# prometheus-es-exporter

[prometheus-es-exporter](https://github.com/braedon/prometheus-es-exporter) is a
prometheus exporter that collects metrics from queries run on an Elasticsearch
cluster's data, and metrics about the cluster itself.

## TL;DR;

```bash
helm install stable/prometheus-es-explorer --set elasticsearch.url="http://elasticsearch:9200"
```

## Introduction

This chart bootstraps a prometheus elasticsearch queries exporter deployment on a
[Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh)
package manager.

## Prerequisites
  - Kubernetes 1.9+
  - Prometheus operator (if you want to use the ServiceMonitor)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm install --name my-release stable/prometheus-es-exporter --set elasticsearch.url="http://elasticsearch:9200"
```

The command deploys nginx-ingress on the Kubernetes cluster in the default
configuration. The [configuration](#configuration) section lists the parameters
that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following table lists the configurable parameters of the nginx-ingress chart and their default values.

Parameter | Description | Default
--- | --- | ---
`elasticsearch.url` | elasticsearch endpoint, with the port included | none
`elasticsearch.queries` | elasticsearch queries to make | none
`prometheus.serviceMonitor` | if set to `true`, will create a ServiceMonitor | `false`
`prometheus.name` | label name of the prometheus instance used | none
`image.repository` | prometheus-es-exporter container image repository | `braedon/prometheus-es-exporter`
`image.tag` | prometheus-es-exporter container image tag | `0.5.1`
`image.pullPolicy` | prometheus-es-exporter container image pull policy | `IfNotPresent`
`tolerations` | node taints to tolerate (requires Kubernetes >=1.6) | `[]`
`affinity` | node/pod affinities (requires Kubernetes >=1.6) | `{}`
`nodeSelector` | node labels for pod assignment | `{}`
`resources` | controller pod resource requests & limits | `{}`
`service.type` | type of controller service to create | `ClusterIp`
`service.port` | port in which the service will be listening | `9206`

```bash
helm install stable/prometheus-es-exporter --name my-release \
    --set elasticsearch.url="http://elasticsearch:9200"
```

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example:

```bash
helm install stable/prometheus-es-exporter --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Tests
### Integration tests
Two tests will be run. One will test that the service is really pointing to the
pod and the other will only be run if `prometheus.serviceMonitor` is enabled,
and will test if there's metrics in prometheus. You may execute them like this:

```bash
helm test my-release --cleanup
```

```console
RUNNING: my-release-servicemonitor-test
PASSED: my-release-servicemonitor-test
RUNNING: my-release-service-test
PASSED: my-release-service-test
```

### Unittests
There's some unittests done with the
![helm-unittests](https://github.com/lrills/helm-unittest) plugin. You may check
it's page to install the plugin. You may execute them like this:

```bash
helm unittest -f templates/tests/unittest-deployment.yaml -f \
    `templates/tests/unittest-servicemonitor.yaml .
```

```console
### Chart [ prometheus-es-exporter ] .

 PASS  test deployment	templates/tests/unittest-deployment.yaml
 PASS  test servicemonitor	templates/tests/unittest-servicemonitor.yaml

Charts:      1 passed, 1 total
Test Suites: 2 passed, 2 total
Tests:       11 passed, 11 total
Snapshot:    0 passed, 0 total
Time:        14.940903ms
```
