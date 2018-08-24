# Beamium

[Beamium](https://github.com/ovh/beamium) Beamium collect metrics from HTTP endpoints and supports Prometheus and Warp10/Sensision format. Once scraped, Beamium can filter and forward data to a Warp10 Time Series platform. While acquiring metrics, Beamium uses DFO (Disk Fail Over) to prevent metrics loss due to eventual network issues or unavailable service.

## TL;DR;

```console
$ helm install incubator/beamium
```

## Introduction

This chart bootstraps a [beamium](https://github.com/ovh/beamium) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

For beamium installation as sidecar of a prometheus server, first install the prometheus chart with a name:

```console
$ helm install --name dummy stable/prometheus
```



Then install the chart after setting the [configuration](#configuration) (especially `config.wrap.url`, `config.wrap.token` and `config.scrapers.scraper-prometheus.url`):

```console
$ helm install stable/beamium
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Drupal chart and their default values.

| Parameter                         | Description                           | Default            |
| --------------------------------- | ------------------------------------- | ------------------ |
| `image.repository`                | Beamium Image name                    | `kartoch/beamium`  |
| `image.tag`                       | Beamium Image tag                     | `{VERSION}`        |
| `image.pullPolicy`                | Beamium image pull policy             | `IfNotPresent`     |
| `resources`                       | CPU/Memory resource requests/limits   | Not set            |
| `replicaCount`                    | Number of replicas                    | 1                  |
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `tolerations` | List of node taints to tolerate (requires Kubernetes >= 1.6) | `[]` |
| `affinity` | Affinity settings for pod assignment | `{}` |
| `config.wrap.url` | URL of the metrics server to push | "https://warp10.gra1.metrics.ovh.net/api/v0/update" |
| `config.wrap.token` | Metric write token | |
| `config.scrapers` | Metrics scrapers configuration | (see below) |
| `config.labels` | Metrics labels configuration | (see below) |
| `config.parameters` | Metrics parameters | (see below) |

## default values for Metrics configuration

```yaml
config:
  warp:
    url: "https://warp10.gra1.metrics.ovh.net/api/v0/update"
    token: "YOUR_WRITE_WARP10_TOKEN"
  scrapers:
    scraper-prometheus:
      url: "http://PROMETHEUS_SERVER_ADDRESS:80/metrics"
      period: 10000
      format: "prometheus"
  labels:
    host: "tmp"
  parameters:
    source-dir: sources
    sink-dir: sinks
    scan-period: 1000
    batch-count: 250
    batch-size: 200000
    log-file: beamium.log
    log-level: 4
    timeout: 500
```    