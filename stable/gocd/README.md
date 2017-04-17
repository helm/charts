# GoCD Helm Chart

[GoCD](https://www.gocd.io/) GoCD is a continuous delivery server.

## TL;DR;

```console
$ helm install stable/gocd
```

## Introduction

This chart bootstraps a [GoCD](https://www.gocd.io) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites Details

* Kubernetes 1.5
* PV support on underlying infrastructure (if persistence is required)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/gocd
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes nearly all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the GoCD chart and their default values.

| Parameter               | Description                           | Default                                                    |
| ----------------------- | ----------------------------------    | ---------------------------------------------------------- |
| `server.image.repository` | GoCD server image | `gocd/gocd-server` |
| `server.image.tag` | GoCD server image version | `v17.3.0` |
| `server.image.pullPolicy` | GoCD server image pull policy | `IfNotPresent` |
| `server.resources.requests.cpu`    | GoCD server CPU resource requests              | none                                      |
| `server.resources.limits.cpu`      | GoCD server CPU resource limits                | none                                     |
| `server.resources.requests.memory` | GoCD server memory resource requests           | none                                      |
| `server.resources.limits.memory`   | GoCD server memory resource limits             | none                                      |
| `agent.image.repository` | GoCD agent image | `gocd/gocd-agent-ubuntu-16.04` |
| `agent.image.tag` | GoCD agent image version | `v17.3.0` |
| `agent.image.pullPolicy` | GoCD agent image pull policy | `IfNotPresent` |
| `agent.replicaCount` | Number of GoCD agents to create | `1` |
| `agent.resources.requests.cpu`    | GoCD agent CPU resource requests              | none                                      |
| `agent.resources.limits.cpu`      | GoCD agent CPU resource limits                | none                                     |
| `agent.resources.requests.memory` | GoCD agent memory resource requests           | none                                      |
| `agent.resources.limits.memory`   | GoCD agent memory resource limits             | none                                      |
| `service.name` | Name of GoCD service in Kubernetes | `gocd` |
| `service.type` | Type of Kubernetes service for GoCD server | `ClusterIP` |
| `service.externalPort` | GoCD server service port | `8080` |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/gocd
```

> **Tip**: You can use the default [values.yaml](values.yaml)
