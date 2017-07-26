# Neo4j

[Neo4j](https://neo4j.com/) is a highly scalable native graph database that leverages data relationships as first-class entities, helping enterprises build intelligent applications to meet today’s evolving data challenges.

## TL;DR;

```bash
$ git clone git@github.com:mneedham/charts.git
$ cd charts
```

```bash
$ helm install incubator/neo4j
```

## Introduction

This chart bootstraps a [Neo4j](https://github.com/neo4j/docker-neo4j) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `neo4j-helm`:

```bash
$ helm install --name neo4j-helm incubator/neo4j
```

The command deploys Neo4j on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `neo4j-helm` deployment:

```bash
$ helm delete neo4j-helm -- purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Neo4j chart and their default values.

|         Parameter          |             Description                 |                         Default                          |
|----------------------------|-----------------------------------------|----------------------------------------------------------|
| `Image`                    | Neo4j image                             | `neo4j`                                                  |
| `ImageTag`                 | Neo4j version                           | `{VERSION}`                                              |
| `ImagePullPolicy`          | Image pull policy                       | `Always` if `ImageTag` is `latest`, else `IfNotPresent`. |
| `NumberOfCores`            | Number of machines in CORE mode         | `3`                                                      |
| `NumberOfReadReplicas`     | Number of machines in READ_REPLICA mode | `0`                                                      |
| `StorageClass`             | Storage class of backing PVC            | `nil` (uses alpha storage class annotation)              |
| `Storage`                  | Size of data volume                     | `1Gi`                                                    |

The above parameters map to the env variables defined in the [Neo4j docker image](https://github.com/neo4j/docker-neo4j).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name neo4j-helm --set NumberOfCores=5,NumberOfReadReplicas=3 incubator/neo4j
```

The above command creates a cluster containing 5 core servers and 3 read replicas.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name neo4j-helm -f values.yaml incubator/neo4j
```

> **Tip**: You can use the default [values.yaml](values.yaml)
