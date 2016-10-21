# Apache Kafka Helm Chart

This is an implementation of Kafka PetSet found here:

 * https://github.com/Yolean/kubernetes-kafka

## Pre Requisites:

* Kubernetes 1.3 with alpha APIs enable

* PV support on underlying infrastructure

## PetSet Details

* http://kubernetes.io/docs/user-guide/petset/

## PetSet Caveats

* http://kubernetes.io/docs/user-guide/petset/#alpha-limitations

## Chart Details

This chart will do the following:

* Implement a dynamically scalable kafka cluster using Kubernetes
  PetSets

* Implement a dynamically scalable zookeeper cluster as another Kubernetes PetSet required for the Kafka cluster above

### Installing the Chart

To install the chart with the release name `my-release` in its own
namespace (recommended) called `kafka`

```
helm repo add incubator
http://storage.googleapis.com/kubernetes-charts-incubator

kubectl create namespace kafka

helm install --name my-release incubator/kafka
```

This chart includes a ZooKeeper chart as a dependency to the Kafka
cluster. Both the Kafka and ZooKeeper charts can be customized using the
following configurable parameters:

| Parameter               | Description                        | Default                                                    |
| ----------------------- | ---------------------------------- | ---------------------------------------------------------- |
| `Name`                  | Kafka master name                  | `zk`                                                       |
| `Image`                 | Kafka Container image name         | `solsson/kafka`                                            |
| `ImageTag`              | Kafka Container image tag          | `0.10.0.1`                                                 |
| `ImagePullPolicy`       | Kafka Container pull policy        | `Always`                                                   |
| `Replicas`              | Kafka Brokers                      | `3`                                                        |
| `Component`             | Kafka k8s selector key             | `kafka`                                                    |
| `Cpu`                   | Kafka container requested cpu      | `100m`                                                     |
| `Memory`                | Kafka container requested memory   | `512Mi`                                                    |
| `DataDirectory`         | Kafka data directory               | `/opt/kafka/data`                                          |
| `Storage`               | Kafka Persistent volume size       | `1Gi`                                                      |

Almost the same parameters are also available for the companion ZooKeeper cluster under the zookeeper namespace. Example: `.zookeeper.Memory`. See `values.yaml` for a full list.

The following global parameters apply to both the Kafka cluster and the ZooKeeper cluster:


| Parameter               | Description                        | Default                                                    |
| ----------------------- | ---------------------------------- | ---------------------------------------------------------- |
| `Namespace`             | K8s namespace for both clusters    | `kafka`                                                    |
| `ZooKeeperServiceName`  | The name for the ZooKeeper Service | `zookeeper`                                                |

Specify parameters using `--set key=value[,key=value]` argument to `helm install`

Alternatively a YAML file that specifies the values for the parameters can be provided like this:

```bash
$ helm install --name my-release -f values.yaml incubator/kafka
```

## Known Limitations

* Namespace creation is not automated
* Topic creation is not automated
* Only supports storage options that have backends for persistent volume claims (tested mostly on AWS)
