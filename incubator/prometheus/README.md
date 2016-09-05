# Prometheus Helm Chart

* Installs the [Promethus](https://prometheus.io/docs/introduction/overview/) monitoring system as well as AlertManager.

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

### Files

| File name                  | Description                                       |
|----------------------------|---------------------------------------------------|
| `alertmanager.yml`         | Main configuration file for AlertManager          |
| `alerts`                   | Alerting rules                                    |
| `prometheus.yml`           | Main configuration file for Prometheus            |
| `rules`                    | Prometheus rules file                             |
