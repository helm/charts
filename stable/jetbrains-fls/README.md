# Jetbrains Floating Licensing Server

[Jetbrains Floating License Server](https://www.jetbrains.com/license-server/) is an on-premise application that you can install in your company’s infrastructure to enable automatic distribution of JetBrains floating licenses. It requires an Internet connection to contact JetBrains Account every hour and obtain license information. To start using Floating License Server, you need to own more than 50 active product subscriptions.

## TL;DR;

```console
$ helm install stable/jetbrains-fls
```

## Introduction

This chart bootstraps a [Floating License Server](https://www.jetbrains.com/license-server/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9+ 
- PV provisioner support in the underlying infrastructure

## Configuration

The following table lists the configurable parameters of the `jetbrains-fls` chart and their default values.

|            Parameter              |                Description                 |                         Default                         |
|-----------------------------------|--------------------------------------------|---------------------------------------------------------|
| `image.repository`                | FLS image name                             | `crazymax/jetbrains-license-server`                     |
| `image.tag`                       | FLS image tag                              | `{VERSION}`                                             |
| `image.pullPolicy`                | Image pull policy                          | `IfNotPresent`                                          |
| `service.type`                    | Kubernetes service type                    | `ClusterIP`                                             |
| `service.port`                    | Service HTTP port                          | `8000`                                                  |
| `ingress.enabled`                 | Enable ingress controller resource         | `true`                                                  |
| `ingress.annotations`             | Ingress annotations                        | `[]`                                                    |
| `ingress.hosts[0].name`           | Hostname for the FLS installation          | `jetbrains-fls.local`                                   |
| `ingress.hosts[0].path`           | URL path                                   | `/`                                                     |
| `ingress.tls[0].hosts[0]`         | TLS hosts                                  |                                                         |
| `ingress.tls[0].secretName`       | TLS Secret (certificates)                  |                                                         |
| `persistence.enabled`             | Enable persistence using PVC               | `true`                                                  |
| `persistence.accessMode`          | PVC Access Mode                            | `ReadWriteOnce`                                         |
| `persistence.size`                | PVC Storage Request                        | `10Gi`                                                  |
| `nodeSelector`                    | Node labels for pod assignment             | `{}`                                                    |
| `tolerations`                     | List of node taints to tolerate            | `[]`                                                    |
| `affinity`                        | Map of node/pod affinities                 | `{}`                                                    |
| `flsTimezone`                     | The timezone assigned to the container     |                                                         |
| `flsVirtualHosts`                 | Virtual hosts for license server           |                                                         |
| `flsContext`                      | Context path for license server            |                                                         |
| `flsStatsRecipients`              | Report recipients                          |                                                         |
| `flsReportOutOfLicensePercentage` | Consumption threshold alert                |                                                         |
| `flsSMTPServer`                   | SMTP server host to use for sending stats  |                                                         |
| `flsSMTPPort`                     | SMTP server port                           |                                                         |
| `flsSMTPUsername`                 | SMTP username                              |                                                         |
| `flsSMTPPassword`                 | SMTP password                              |                                                         |
| `flsStatsFrom`                    | From address for stats emails              |                                                         |
| `flsStatsToken`                   | Auth token for /reportApi endpoint         |                                                         |
| `flsAccessConfig`                 | JSON file to configure user restrictions   |                                                         |

Parameters prefixed with `fls` will override env variables in the base image: [crazymax/jetbrains-license-server](https://github.com/crazy-max/docker-jetbrains-license-server#environment-variables). In most cases, `flsVirtualHosts` should match the list of ingress hosts.

## Production and horizontal scaling

The licensing server should not be scaled beyond one replica.
