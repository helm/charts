# Status Pages

Open source service uptime monitoring and reporting pages.

- [Cachet](https://github.com/CachetHQ/Cachet)
- [Statping](https://github.com/hunterlong/statping)
- [Staytus](https://github.com/adamcooke/staytus)

## Introduction

This chart bootstraps the chosen status page on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installation

To install the chart with the release name `my-release`, run:

```bash
helm install --name my-release incubator/status
```

The [configuration](#configuration) section below lists all possible parameters that can be configured.

## Uninstall

To uninstall/delete the `my-release` deployment:

```bash
helm delete my-release
```

## Configuration

The following table lists the configurable parameters of the Status chart and its default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `cachethq.enabled` | enable [cachet](https://github.com/CachetHQ/Cachet) | `true` |
| `cachethq.prometheus` | link it to prometheus alertmanager | `false` |
| `cachethq.monitor` | ping website for stats | `false` |
| `cachethq.image.repository` | - | `"cachethq/docker"` |
| `cachethq.image.tag` | - | `"2.3.14"` |
| `cachethq.image.pullPolicy` | - | `"IfNotPresent"` |
| `cachethq.apiKey` | - | `""` |
| `statping.enabled` | enable [statping](https://github.com/hunterlong/statping) | `false` |
| `statping.image.repository` | - | `"hunterlong/statping"` |
| `statping.image.tag` | - | `"latest"` |
| `statping.image.pullPolicy` | - | `"IfNotPresent"` |
| `staytus.enabled` | enable [staytus](https://github.com/adamcooke/staytus) | `false` |
| `staytus.image.repository` | - | `"quay.io/galexrt/staytus"` |
| `staytus.image.tag` | - | `"latest"` |
| `staytus.image.pullPolicy` | - | `"IfNotPresent"` |
| `environment.APP_KEY` | environment variable | `""` |
| `environment.VIRTUAL_HOST` | environment variable | `"localhost"` |
| `environment.VIRTUAL_PORT` | environment variable | `8080` |
| `environment.NAME` | environment variable | `"Company"` |
| `environment.DESCRIPTION` | environment variable | `"Service Uptime Reporting"` |
| `environment.DOMAIN` | environment variable | `"https://status.page"` |
| `environment.ADMIN_USER` | environment variable | `"username"` |
| `environment.ADMIN_PASS` | environment variable | `"password"` |
| `environment.ADMIN_EMAIL` | environment variable | `"company@example.com"` |
| `postgresql.enabled` | database | `true` |
| `postgresql.postgresqlDatabase` | database | `"status_page"` |
| `postgresql.postgresqlUsername` | database | `"status_page"` |
| `postgresql.postgresqlPassword` | database | `"password"` |
| `postgresql.image.tag` | database | `"9.6"` |
| `postgresql.persistence.annotations.resourcePolicy` | database | `"keep"` |
| `mariadb.enabled` | database | `false` |
| `mariadb.db.name` | database | `"status_page"` |
| `mariadb.db.user` | database | `"status_page"` |
| `mariadb.db.password` | database | `"password"` |
| `mariadb.rootUser.password` | database | `"password"` |
| `mariadb.replication.enabled` | database | `false` |
| `email.type` | email | `"smtp"` |
| `email.host` | email | `"smtp.sendgrid.net"` |
| `email.port` | email | `587` |
| `email.userName` | email | `"apikey"` |
| `email.fromName` | email | `"company"` |
| `email.fromEmail` | email | `"company@example.com"` |
| `email.sendgrid.credentialsSecretName` | email | `"sendgrid-credentials"` |
| `replicaCount` | - | `1` |
| `service.type` | - | `"ClusterIP"` |
| `service.externalPort` | - | `80` |
| `service.internalPort` | - | `8000` |
| `ingress.enabled` | - | `false` |
| `ingress.path` | - | `"/"` |
| `ingress.hosts` | - | `["status.page"]` |
| `ingress.tls` | - | `[]` |
