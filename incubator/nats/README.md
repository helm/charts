# NATS

[NATS](https://nats.io/) is a simple, high performance open source messaging system for cloud native applications, IoT messaging, and microservices architectures.

## TL;DR;

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/nats
```

## Introduction

This chart bootstraps a [NATS](https://nats.io/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.5+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/nats
```

The command deploys NATS on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the NATS chart and their default values.

> **Tip**: You can use the default [values.yaml](values.yaml)

Parameter                   | Description                              | Default            |
--------------------------- | ---------------------------------------- | -------------------
`replicaCount`              | Number of StatefulSet replicas           | `3`                |
`image.repository`          | Path to Docker image repository          | `gabrtv/nats`      |
`image.tag`                 | Docker image tag                         | `0.9.6`            |
`image.pullPolicy`          | Pull policy for Docker image             | `IfNotPresent`     |
`service.client.type`       | Kubernetes service type (client)         | `ClusterIP`        |
`service.client.port`       | Kubernetes service port (client)         | `4222`             |
`service.client.name`       | Kubernetes service name (client)         | `nats`             |
`service.cluster.type`      | Kubernetes service type (cluster)        | `None`             |
`service.cluster.port`      | Kubernetes service port (cluster)        | `6222`             |
`service.cluster.name`      | Kubernetes service name (cluster)        | `nats-cluster`     |
`service.management.type`   | Kubernetes service type (management)     | `ClusterIP`        |
`service.management.port`   | Kubernetes service port (management)     | `8222`             |
`service.management.name`   | Kubernetes service name (management)     | `nats-mgmt`        |
`ingress.enabled`           | Enable ingress for web management        | `false`            |
`ingress.hosts[N]`          | Ingress hostnames for web management     | `nats.example.com` |
`ingress.annotations`       | Ingress annotations (used for ACME)      | empty              |
`ingress.tls`               | Ingress TLS configuration                | empty              |
`resources.limits.cpu`      | CPU resource limits                      | `100m`             |
`resources.requests.cpu`    | CPU resource requests                    | `100m`             |
`resources.limits.memory`   | Memory resource limits                   | `128Mi`            |
`resources.requests.memory` | Memory resource requests                 | `128Mi`            |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/nats --name my-release --set ingress.enabled=true,ingress.hosts[0]=nats.gabrtv.io
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install incubator/nats --name my-release -f values.yaml
```
