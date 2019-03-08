# Cadence

[Cadence](https://cadenceworkflow.io/) Cadence is a distributed, scalable, durable, and highly available orchestration engine to execute asynchronous long-running business logic in a scalable and resilient way.

## TL;DR;

```bash
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
$ helm install --namespace kubeless incubator/cadence
```

## Introduction

This chart bootstraps a [Cadence](https://github.com/uber/cadence) and a [Cadence-UI](https://github.com/uber/cadence-web) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.7+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release --namespace cadence incubator/cadence
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


## Configuration

The following table lists the configurable parameters of the Kubeless chart and their default values.

| Parameter                               | Description                                   | Default                                   |
| ----------------------------------------| --------------------------------------------- | ----------------------------------------- |
| `server.image.pullPolicy`               | Server Container pull policy                  | `IfNotPresent`                            |
| `server.image.repository`               | Image repository for cadence Server           | `ubercadence/server`                      |
| `server.image.tag`                      | Image Tag for cadence Server                  | `0.5.2`                                   |
| `server.logLevel`                       | Server Log level                              | `debug,info`                              |
| `server.nameOverride`                   | Override name of app                          | ``                                        |
| `server.fullnameOverride`               | Override full name of app                     | ``                                        |
| `server.bindOnLocalHost`                | Server bind on local host                     | `false`                                   |
| `server.cassandraVisibilityKeyspace`    | Cassandra Visibility Keyspace                 | `cadence`                                 |
| `server.replicaCount`                   | Number of Server Replicas                     | `1`                                       |
| `server.frontend.enabled`               | Enable server frontend service                | `true`                                    |
| `server.frontend.bindOnIP`              | Server frontend bind IP                       | `0.0.0.0`                                 |
| `server.frontend.service.type`          | Server frontend service type                  | `ClusterIP`                               |
| `server.frontend.service.port`          | Server frontend service port                  | `7933`                                    |
| `server.matching.enabled`               | Enable server matching service                | `true`                                    |
| `server.matching.bindOnIP`              | Server matching bind IP                       | `0.0.0.0`                                 |
| `server.matching.service.type`          | Server matching service type                  | `ClusterIP`                               |
| `server.matching.service.port`          | Server matching service port                  | `7935`                                    |
| `server.history.enabled`                | Enable server history service                 | `true`                                    |
| `server.history.bindOnIP`               | Server history bind IP                        | `0.0.0.0`                                 |
| `server.history.numHistoryShards`       | Server history shards number                  | `4`                                       |
| `server.history.service.type`           | Server history service type                   | `ClusterIP`                               |
| `server.history.service.port`           | Server history service port                   | `7934`                                    |
| `server.worker.enabled`                 | Enable server worker service                  | `true`                                    |
| `server.worker.bindOnIP`                | Server worker bind IP                         | `0.0.0.0`                                 |
| `server.worker.service.type`            | Server worker service type                    | `ClusterIP`                               |
| `server.worker.service.port`            | Server worker service port                    | `7939`                                    |
| `server.resources`                      | Server CPU/Memory resource requests/limits    | `{}`                                      |
| `server.nodeSelector`                   | Node labels for pod assignment                | `{}`                                      |
| `server.tolerations`                    | Toleration labels for pod assignment          | `[]`                                      |
| `server.affinity`                       | Affinity settings for pod assignment          | `{}`                                      |
| `web.enabled`                           | Enable WebUI service                          | `true`                                    |
| `web.replicaCount`                      | Number of WebUI service Replicas              | `1`                                       |
| `web.image.pullPolicy`                  | WebUI service Container pull policy           | `IfNotPresent`                            |
| `web.image.repository`                  | Image repository for cadence WebUI            | `ubercadence/web`                         |
| `web.image.tag`                         | Image Tag for cadence WebUI                   | `3.1.2`                                   |
| `web.cadenceTchannelPeers`              | Cadence TChannel Peers                        | `cadence:7933`                            |
| `web.nameOverride`                      | Override name of app                          | ``                                        |
| `web.fullnameOverride`                  | Override full name of app                     | ``                                        |
| `web.service.type`                      | WebUI service type                            | `ClusterIP`                               |
| `web.service.port`                      | WebUI service port                            | `80`                                      |
| `web.ingress.enabled`                   | Enables WebUI Ingress                         | `false`                                   |
| `web.ingress.annotations`               | WebUI Ingress annotations                     | `{}`                                      |
| `web.ingress.hosts`                     | WebUI Ingress hosts                           | `/`                                       |
| `web.ingress.tls`                       | WebUI Ingress tls config                      | `[]`                                      |
| `web.resources`                         | WebUI CPU/Memory resource requests/limits     | `{}`                                      |
| `web.nodeSelector`                      | Node labels for pod assignment                | `{}`                                      |
| `web.tolerations`                       | Toleration labels for pod assignment          | `[]`                                      |
| `web.affinity`                          | Affinity settings for pod assignment          | `{}`                                      |
| `cassandra.enabled`                     | Enable Cassandra cluster install              | `true`                                    |
| `cassandra.config.cluster_size`         | Cassandra cluster node number                 | `1`                                       |
| `cassandra.seeds`                       | Cassandra Seeds                               | `cassandra`                               |
| `cassandra.consistency`                 | Cassandra Consistency                         | `One`                                     |
| `cassandra.keyspace`                    | Cassandra keyspace name                       | `cadence`                                 |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```console
$ helm install --name my-release --set server.image.tag=0.5.2 incubator/cadence
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```console
$ helm install --name my-release --values values.yaml incubator/cadence
```
