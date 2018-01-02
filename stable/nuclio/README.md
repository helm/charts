# Nuclio

##  High-Performance Serverless Event and Data Processing Platform

[Nuclio](https://nuclio.io) is a new "serverless" project, derived from [iguazio](https://iguazio.com)'s elastic data life-cycle management service for high-performance events and data processing

## QuickStart

```bash
$ helm install stable/nuclio --name foo --namespace bar
```

## Introduction

This chart bootstraps a Nuclio deployment (controller and playground) and service on a Kubernetes cluster using the Helm Package manager.

## Prerequisites

- Kubernetes 1.7+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/nuclio
```

The command deploys Nuclio on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration
The following tables lists the configurable parameters of the Traefik chart and their default values.

| Parameter                       | Description                                                          | Default                                   |
| ------------------------------- | -------------------------------------------------------------------- | ----------------------------------------- |
| `Nuclio.Version`                | Nuclio's version                                                     | `0.2.2`                                   |
| `Nuclio.Arch`                   | The version of the official Nuclio image architecture to use         | `amd64`                                   |
| `Controller.Name`               | Provide controller name                                              | `controller`                              |
| `Controller.Image`              | Nuclio's controller image                                            | `nuclio/controller`                       |
| `Controller.PullPolicy`         | Nuclio's controller image pull policy                                | `IfNotPresent`                            |
| `Playground.Enabled`            | Enable/Disable Nuclio's playground UI                                | `true`                                    |
| `Playground.Name`               | Provide playground name                                              | `playground`                              |
| `Playground.Image`              | Nuclio's playground image                                            | `nuclio/playground`                       |
| `Playground.PullPolicy`         | Nuclio's playground image pull policy                                | `IfNotPresent`                            |
| `Playground.Service.Type`       | If enabled, set the service type                                     | `NodePort`                                |
| `Playground.Service.NodePort`   | If enabled, and set service type to `NodePort`, choose the port      | `32050`                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set Playground.Enabled=true,Playground.Service.NodePort=42080 \
    stable/nuclio
```

The above command enables playground and changes the playground service `NodePort` to 42080

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/nuclio
```

> **Tip**: You can use the default [values.yaml](values.yaml)