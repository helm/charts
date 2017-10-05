# NATS

[NATS](http://nats.io/) NATS is a family of open source products that are tightly integrated but can be deployed independently..

## TL;DR;

```bash
$ helm install stable/nats
```

## Introduction

This chart bootstraps a [NATS](https://github.com/pires/kubernetes-nats-cluster/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/nats
```

The command deploys NATS on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the NATS chart and their default values.

| Parameter                  | Description                           | Default                                                   |
| -------------------------- | ------------------------------------- | --------------------------------------------------------- |
| `image`                    | NATS image                           | `bitnami/nats:{VERSION}`                                 |
| `imagePullPolicy`          | Image pull policy                     | `IfNotPresent`                                            |


> **Tip**: You can use the default [values.yaml](values.yaml)
