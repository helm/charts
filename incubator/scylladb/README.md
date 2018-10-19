# ScyllaDB

[ScyllaDB](https://www.scylladb.com) is an open-source NoSQL data store, compatible with Apache Cassandra.

## TL;DR;

```bash
$ helm install incubator/scylladb
```

## Introduction

This chart bootstraps a [ScyllaDB](https://www.scylladb.com) cluster deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.


## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/scylladb
```

The command deploys ScyllaDB on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


## Configuration

The following table lists the configurable parameters of the ScyllaDB chart and their default valuessdsdsd.

| Parameter                  | Description                                     | Default                                                    |
| -----------------------    | ---------------------------------------------   | ---------------------------------------------------------- |
| `config.cpu`               | Restricts Scylla to N logical cores (numeric)   | `nil`                                                      |
| `config.overprovisioned`   | If true, Scylla that the machine it is running on is used by other processes | `true`                        |
| `image.repository`         | Container image repository                      | `scylladb/scylla`                                          |
| `image.tag`                | Container image tag                             | `2.1.3`                                                    |
| `image.pullPolicy`         | Container image pull policy                     | `IfNotPresent`                                             |
| `persistence.accessMode`   | Persistent Volume access modes                  | `ReadWriteOnce`                                            |
| `persistence.size`         | Persistent Volume size                          | `15Gi`                                                     |
| `persistence.storageClass` | Persistent Volume Storage Class                 | `nil`                                                      |
| `podDisruptionBudget`      | Pod distruption budget                          | `{}`                                                       |
| `replicaCount`             | Number of replicas in the StatefulSet           | `3`                                                        |
| `resources`                | ScyllaDB StatefulSet pod resource requests & limits | `{}`                                                   |
| `service.cqlPort`          | CQL port                                        | `9042`                                                     |
| `service.internodePort`    | Inter-node communication port                   | `7000`                                                     |
| `service.sslinternodePort` | SSL inter-node communication port               | `7001`                                                     |
| `service.jmxPort`          | JMX management port                             | `7199`                                                     |
| `service.restPort`         | Scylla REST API port                            | `10000`                                                    |
| `service.prometheusPort`   | Prometheus API port                             | `9180`                                                     |
| `service.nodeExporterPort` | node_exporter port                              | `9100`                                                     |
| `service.type`             | k8s service type exposing ports, e.g. `NodePort`| `ClusterIP`                                                |
| `service.thriftPort`       | Scylla client (Thrift) port                     | `9160`                                                     |
| `statefulset.hostNetwork`  | If true, ScyllaDB pods share the host network namespace | `false`                                            |
| `nodeSelector`             | Node labels for ScyllaDB pod assignment         | `{}`                                                       |
| `tolerations`              | Node taints to tolerate (requires Kubernetes >=1.6) | `[]`                                                   |
| `affinity`                 | Pod affinity                                    | `{}`                                                       |
