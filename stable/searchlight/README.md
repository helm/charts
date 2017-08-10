# Searchlight
[Searchlight by AppsCode](https://github.com/appscode/searchlight) is an alert manager for Kubernetes built around Icinga2.

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
The command deploys Searchlight controller on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release`:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Searchlight chart and their default values.


| Parameter             | Description                          | Default                |
| ----------------------| -------------------------------------| -----------------------|
| `operator.image`      | operator container image             | `appscode/searchlight` |
| `operator.tag`        | operator image tag                   | `1.5.9`                |
| `operator.pullPolicy` | operator container image pull policy | `IfNotPresent`         |
| `icinga.image`        | icinga container image               | `appscode/icinga`      |
| `icinga.tag`          | icinga container image tag           | `1.5.9-k8s`            |
| `icinga.pullPolicy`   | icinga container image pull policy   | `IfNotPresent`         |
| `ido.image`           | ido container image                  | `appscode/postgress`   |
| `ido.tag`             | ido container image tag              | `9.5-v3-db`            |
| `ido.pullPolicy`      | ido container image pull policy      | `IfNotPresent`         |
