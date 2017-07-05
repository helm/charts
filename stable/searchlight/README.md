# Searchlight
[Searchlight](https://github.com/appscode/searchlight) Searchlight is an Alert Management project. It has a Controller to watch Kubernetes Objects. Alert objects are consumed by Searchlight Controller to create Icinga2 hosts, services and notifications.
## TL;DR;

```bash
$ helm install stable/searchlight
```

## Introduction

This chart bootstraps a [Searchlight controller](https://github.com/appscode/searchlight) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.5+

## Installing the Chart
To install the chart with the release name `my-release`:
```bash
$ helm install --name my-release stable/searchlight
```
The command deploys Searchlight Controller on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release`:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Searchlight chart and their default values.


| Parameter                     | Description                          | Default                   |
| -----------------------       | ----------------------------------   | --------------------------|
| `icinga.icinga.image`         |  Icinga container image to run       | `appscode/icinga`         |
| `icinga.icinga.imageTag`      |  Icinga container image tag to run   | `1.5.6-k8s`               |
| `icinga.icinga.apiPort`       |  api port for Icinga container       | `5665`                    |
| `icinga.icinga.webPort`       |  web port for Icinga container       | `60006`                   |
| `icinga.ido.image`            |  ido container image to run          | `appscode/postgress`      |
| `icinga.ido.imageTag`         |  ido container image tag to run      | `9.5-v3-db`               |
| `icinga.ido.idoPort`          |  ido port for ido container          | `5432`                    |
| `icinga.type`                 |  Icinga secret type                  | `Opaque`                  |
| `icinga.apiTargetPort`        |  Icinga service target port for api  | `5665`                    |
| `icinga.webTargetPort`        |  Icinga service target port for web  | `80`                      |
| `searchlight.image`           |  Searchlight image to run            | `appscode/searchlight`    |
| `searchlight.imageTag`        |  Searchlight image tag to run        | `1.5.6`                   |
