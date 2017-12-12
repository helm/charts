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
cluster in its `requirement.yaml` by default. The chart can be customized using the
following configurable parameters:

| Parameter                      | Description                                                                                                                                      | Default                                                    |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------- |
| `image`                        | Kafka Container image name                                                                                                                       | `solsson/kafka`                                            |
| `imageTag`                     | Kafka Container image tag                                                                                                                        | `1.0.0`                                                    |
| `imagePullPolicy`              | Kafka Container pull policy                                                                                                                      | `Always`                                                   |
| `kafkaAntiAffinityEnabled`     | If `true`, apply anti-affinity rules between kafka pods.                                                                                         | `true`                                                     |
| `kafkaAntiAffinity`            | If `hard` disallow colocation of Kafka pods, if `soft`, make a best effort-attempt to prevent colocation.                                        | `soft`                                                     |
| `replicas`                     | Kafka Brokers                                                                                                                                    | `3`                                                        |
| `component`                    | Kafka k8s selector key                                                                                                                           | `kafka`                                                    |
| `resources`                    | Kafka resource requests and limits                                                                                                               | `{}`                                                       |
| `dataDirectory`                | Kafka data directory                                                                                                                             | `/opt/kafka/data`                                          |
| `logSubPath`                   | Subpath under `dataDirectory` where kafka logs will be placed. `logs/`                                                                           | `logs`                                                     |
| `storage`                      | Kafka Persistent volume size                                                                                                                     | `1Gi`                                                      |
| `configurationOverrides`       | `Kafka ` [configuration setting](https://kafka.apache.org/documentation/#brokerconfigs) overrides in the dictionary format `setting.name: value` | `{}`                                                       |
| `schema-registry.enabled`      | If True, installs Schema Registry Chart                                                                                                          | `false`                                                    |
| `zookeeperAntiAffinityEnabled` | If `true`, apply anti-affinity rules between kafka and zookeeper pods.                                                                           | `true`                                                     |
| `zookeeperAntiAffinity`        | If `hard` disallow colocation of Kafka and Zookeeper pods, if `soft`, make a best effort-attempt to prevent colocation                           | `soft`                                                     |
| `zookeeperAntiAffinityPodName` | Pod Metadata app label of zookeeper pods for anti-affinity rules for use with `In` prefix of affinity rules.                                     | `zookeeper`                                                |
| `zookeeper.enabled`            | If True, installs Zookeeper Chart                                                                                                                | `true`                                                     |
| `zookeeper.url`                | URL of Zookeeper Cluster (unneeded if installing Zookeeper Chart)                                                                                | `""`                                                       |
| `zookeeper.port`               | Port of Zookeeper Cluster                                                                                                                        | `2181`                                                     |

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
