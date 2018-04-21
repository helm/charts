# SonarQube

[SonarQube](https://www.sonarqube.org/) is an open sourced code quality scanning tool.

## Introduction

This chart bootstraps a SonarQube instance with a PostgreSQL database.

## Prerequisites

- Kubernetes 1.6+

## Installing the chart:

To install the chart :

```bash
$ helm install stable/sonarqube
```

The above command deploys Sonarqube on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

The default login is admin/admin.

## Uninstalling the chart

To uninstall/delete the deployment:

```bash
$ helm list
NAME       	REVISION	UPDATED                 	STATUS  	CHART          	NAMESPACE
kindly-newt	1       	Mon Oct  2 15:05:44 2017	DEPLOYED	sonarqube-0.1.0	default
$ helm delete kindly-newt
```

## Configuration

The following table lists the configurable parameters of the Sonarqube chart and their default values.

| Parameter                                   | Description                               | Default                                    |
| ------------------------------------------  | ----------------------------------------  | -------------------------------------------|
| `image.tag`                                 | `sonarqube` image tag.                    | 6.5                                        |
| `image.pullPolicy`                          | Image pull policy                         | `IfNotPresent`                             |
| `ingress.enabled`                           | Flag for enabling ingress                 | false                                      |
| `service.type`                              | Kubernetes service type                   | `LoadBalancer`                             |
| `service.annotations`                       | Kubernetes service annotations            | None                                       |
| `persistence.enabled`                       | Flag for enabling persistent storage      | false                                      |
| `persistence.storageClass`                  | Storage class to be used                  | "-"                                        |
| `persistence.accessMode`                    | Volumes access mode to be set             | `ReadWriteOnce`                            |
| `persistence.size`                          | Size of the volume                        | `10Gi`                                     |
| `sonarProperties`                           | Custom `sonar.properties` file            | None                                       |
| `postgresql.enabled`                        | Set to `false` to use external server     | `true`                                     |
| `postgresql.postgresServer`                 | Hostname of the external Postgresql server| `null`                                     |
| `postgresql.postgresUser`                   | Postgresql database user                  | `sonarUser`                                |
| `postgresql.postgresPassword`               | Postgresql database password              | `sonarPass`                                |
| `postgresql.postgresDatabase`               | Postgresql database name                  | `sonarDB`                                  |
| `postgresql.service.port`                | Postgresql port                              | `5432`                                     |
| `resources`                                 | Sonarqube Pod resource requests & limits  | `{}`                                       |
| `affintiy`                                  | Node / Pod affinities                     | `{}`                                       |
| `nodeSelector`                              | Node labels for pod assignment            | `{}`                                       |
| `tolerations`                               | List of node taints to tolerate           | `[]`                                       |
| `plugins.install`                           | List of plugins to install                | `[]`                                       |
| `plugins.resources`                         | Plugin Pod resource requests & limits     | `{}`                                       |

You can also configure values for the PostgreSQL database via the Postgresql [README.md](https://github.com/kubernetes/charts/blob/master/stable/postgresql/README.md).

For overriding variables see: [Customizing the chart](https://docs.helm.sh/using_helm/#customizing-the-chart-before-installing)
