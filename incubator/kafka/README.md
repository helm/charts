# Apache Kafka Helm Chart

This is an implementation of Kafka StatefulSet found here:

 * https://github.com/Yolean/kubernetes-kafka

## Pre Requisites:

* Kubernetes 1.3 with alpha APIs enabled and support for storage classes

* PV support on underlying infrastructure

* Requires at least `v2.0.0-beta.1` version of helm to support
  dependency management with requirements.yaml

## StatefulSet Details

* https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/

## StatefulSet Caveats

* https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#limitations

## Chart Details

This chart will do the following:

* Implement a dynamically scalable kafka cluster using Kubernetes StatefulSets

* Implement a dynamically scalable zookeeper cluster as another Kubernetes StatefulSet required for the Kafka cluster above

### Installing the Chart

To install the chart with the release name `my-kafka` in the default
namespace:

```
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-kafka incubator/kafka
```

If using a dedicated namespace(recommended) then make sure the namespace
exists with:

```
$ kubectl create ns kafka
$ helm install --name my-kafka --set global.namespace=kafka incubator/kafka
```

This chart includes a ZooKeeper chart as a dependency to the Kafka
cluster in its `requirement.yaml`. The chart can be customized using the
following configurable parameters:

| Parameter               | Description                        | Default                                                    |
| ----------------------- | ---------------------------------- | ---------------------------------------------------------- |
| `Image`                 | Kafka Container image name         | `solsson/kafka`                                            |
| `ImageTag`              | Kafka Container image tag          | `0.11.0.0`                                                 |
| `ImagePullPolicy`       | Kafka Container pull policy        | `Always`                                                   |
| `Replicas`              | Kafka Brokers                      | `3`                                                        |
| `Component`             | Kafka k8s selector key             | `kafka`                                                    |
| `resources`             | Kafka resource requests and limits | `{}`                                                       |
| `DataDirectory`         | Kafka data directory               | `/opt/kafka/data`                                          |
| `Storage`               | Kafka Persistent volume size       | `1Gi`                                                      |

Specify parameters using `--set key=value[,key=value]` argument to `helm install`

Alternatively a YAML file that specifies the values for the parameters can be provided like this:

```bash
$ helm install --name my-kafka -f values.yaml incubator/kafka
```

### Connecting to Kafka

You can connect to Kafka by running a simple pod in the K8s cluster like this with a configuration like this:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: testclient
  namespace: kafka
spec:
  containers:
  - name: kafka
    image: solsson/kafka:0.11.0.0
    command:
      - sh
      - -c
      - "exec tail -f /dev/null"
```

Once you have the testclient pod above running, you can list all kafka
topics with:

` kubectl -n kafka exec -ti testclient -- ./bin/kafka-topics.sh --zookeeper
my-release-zookeeper:2181 --list`

Where `my-release` is the name of your helm release.

## Known Limitations

* Topic creation is not automated
* Only supports storage options that have backends for persistent volume claims (tested mostly on AWS)
* Kafka cluster is not accessible via an external endpoint
