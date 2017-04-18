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
| `agent.image.repository` | GoCD agent image | `gocd/gocd-agent-ubuntu-16.04` |
| `agent.image.tag` | GoCD agent image version | `v17.3.0` |
| `agent.image.pullPolicy` | GoCD agent image pull policy | `IfNotPresent` |
| `agent.replicaCount` | Number of GoCD agents to create | `1` |
| `service.name` | Name of GoCD service in Kubernetes | `gocd` |
| `service.type` | Type of Kubernetes service for GoCD server | `ClusterIP` |
| `service.externalPort` | GoCD server service port | `8080` |
| `persistence.enabled`                | Enable persistence using PVC             | `true` |
| `persistence.godata.storageClass`    | PVC Storage Class for /godata volume      | `nil` (uses alpha storage class annotation)  |
| `persistence.godata.accessMode`      | PVC Access Mode for /godata volume        | `ReadWriteOnce`|
| `persistence.godata.size`            | PVC Storage Request for /godata volume    | `1Gi` |
| `persistence.gohome.storageClass` | PVC Storage Class for /home/go volume   | `nil` (uses alpha storage class annotation)   |
| `persistence.gohome.accessMode`   | PVC Access Mode for /home/go volume     | `ReadWriteOnce`   |
| `persistence.gohome.size`         | PVC Storage Request for /home/go volume | `8Gi`  |
| `agent.resources`                          | CPU/Memory resource requests/limits      | Memory: `512Mi`, CPU: `300m`|
| `server.resources`                          | CPU/Memory resource requests/limits      | Memory: `512Mi`, CPU: `300m`|


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/gocd
```

> **Tip**: You can use the default [values.yaml](values.yaml)
