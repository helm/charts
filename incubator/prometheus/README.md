# Prometheus Helm Chart

* Installs the [Prometheus](https://prometheus.io/docs/introduction/overview/) monitoring system as well as AlertManager.

## Resource utilization

The default cpu and memory settings represent small installation. See [this documentation](https://prometheus.io/docs/operating/storage/#memory-usage) for details on estimating your memory utilziation needs.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/prometheus
```

## Configuration

### values.yaml

| Parameter                  | Description                                       | Default                  |
|----------------------------|---------------------------------------------------|--------------------------|
| `image`                    | Prometheus image to run                           | prom/prometheus          |
| `imageTag`                 | Prometheus image version to run                   | v1.1.0                   |
| `imageAlertManager`        | AlertManager image to run                         | prom/alertmanager        |
| `imageTagAlertManager`     | AlertManager image version to run                 | v0.4.2                   |
| `adminUser`                | Admin user username                               | admin                    |
| `adminPassword`            | Admin user password                               | admin                    |
| `persistence.enabled`      | Create a volume to store data                     | true                     |
| `persistence.size`         | Size of persistent volume claim                   | 1Gi RW                   |
| `persistence.storageClass` | Type of persistent volume claim                   | generic                  |
| `cpu`                      | Container requested cpu                           | 500m                     |
| `memory`                   | Container requested memory                        | 1G                       |
| `cpuAlertManager`          | Container requested cpu for AlertManager          | 100m                     |
| `memoryAlertManager`       | Container requested memory for AlertManager       | 50M                      |
| `cpuNodeExporter`          | Container requested cpu for NodeExporter          | 50m                      |
| `memoryNodeExporter`       | Container requested memory for NodeExporter       | 50M                      |

### Files

| File name                  | Description                                       |
|----------------------------|---------------------------------------------------|
| `alertmanager.yml`         | Main configuration file for AlertManager          |
| `alerts`                   | Alerting rules                                    |
| `prometheus.yml`           | Main configuration file for Prometheus            |
| `rules`                    | Prometheus rules file                             |
