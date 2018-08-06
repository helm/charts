# kafka-connect

[kafka-connect](https://www.confluent.io/product/connectors/) is an application which allows Kafka
to integrate with other data sources. These integrations may act as either a _source_ or a _sink_
to Kafka. Supported Kafka Connectors [included with the default Confluent Kafka Connect Docker image](https://docs.confluent.io/current/connect/connectors.html) include:

  * JDBC
  * HDFS
  * Amazon S3
  * GCS
  * Elasticsearch
  * Replicator
  * JMS
  * IBM MQ
  * ActiveMQ
  * Kafka FileStream

Kafka-Connect is managed via its [HTTP API](https://docs.confluent.io/current/connect/references/restapi.html).
A common strategy in a Kubernetes deployment would be to use a super-chart which uses this chart as
a dependency and uses a post-installation hook or a Git-Sync sidecar to manage Kafka Connect.

[Additional Connectors](https://www.confluent.io/product/connectors/) may be added or removed by modifying the default image for this Chart.

## TL;DR;

```bash
$ helm install incubator/kafka-connect
```

## Introduction

This chart bootstraps a [kafka-connect](https://www.confluent.io/product/connectors/)
deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh)
package manager.

## Prerequisites

* Kubernetes 1.6+ with Beta APIs enabled
* Requires at least `v2.0.0-beta.1` version of helm to support
  dependency management with requirements.yaml


## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/kafka-connect
```

The command deploys kafka-connect on the Kubernetes cluster in the default configuration. The
[configuration](#configuration) section lists the parameters that can be configured during
installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the
release.

## Configuration

The following tables lists the configurable parameters of the kafka-connect chart and their
default values.

| Parameter                  | Description                                | Default
| -----------------------    | ----------------------------------         | ---------------------------------------------------------- |
| `imageRepository`          | `kafka-connect` image repository           | `confluentinc/cp-kafka-connect`                                       |
| `imageTag`                 | `kafka-connect` image tag                  | `4.1.1`                                                   |
| `imagePullPolicy`          | Image pull policy                          | `IfNotPresent`    |
| `resources` | Resource requests and limits | `{}` |
| `replicaCount` | The number of replias in the deployment | `1` |
| `serviceType` | The type of service to create | `ClusterIP` |
| `serviceExternalPort` | The service port to expose | `80` |
| `serviceAnnotations` | Any annotations to be added to the service | `{}` |
| `ingressEnabled` | Whether or not an ingress should be created | `false` |
| `ingressHostname` | The hostname for the ingress | `""` |
| `ingressAnnotations` | Any annotations to be added to the ingress | `{}` |
| `hpaCpuEnabled` | Whether or not to autoscale the pod on CPU usage | `{}` |
| `hpaMemoryEnabled` | Whether or not to autoscale the pod on Memory usage | `{}` |
| `hpaMinReplicas` | The minimum number of pods in the HPA replicaset | `1` |
| `hpaMaxReplicas` | The maximum number of pods in the HPA replicaset | `3` |
| `hpaCPUPercent` | The CPU percent to scale at | `80` |
| `hpaMemPercent` | The Memory percent to scale at | `80` |
| `affinity` | Pod affinity rules, if any | `{}` |
| `tolerations` | Pod tolerations, if any | `{}` |
| `schemaRegistryUrl` | The URL of the schema registry installation | `""` |
| `connectRestPort` | The port on which kafka connect should be exposed | `28082` |
| `connectGroupName` | The name of the Kafka Connect group | "" |
| `connectConfigStorageTopic` | The Kafka topic name for Kafka Connect config storage | "connect-config" |
| `connectOffsetStorageTopic` | The Kafka topic name for Kafka Connect offset storage | "connect-offset" |
| `connectStatusStorageTopic` | The Kafka topic name for Kafka Connect status storage | "connect-status" |
| `connectKeyConverter` | The type of Kafka Connect Key converter to use | "org.apache.kafka.connect.json.JsonConverter" |
| `connectKeyConverterSchemasEnable` | Whether or not to enable key conversions for schemas | `false` |
| `connectValueConverter` | The type of Kafka Connect Value converter to use | `"io.confluent.connect.avro.AvroConverter"` |
| `connectInternalKeyConverter` | The type of Kafka Connect Value converter to use internally | `"org.apache.kafka.connect.json.JsonConverter"` |
| `connectInternalValueConverter` | The type of Kafka Connect key converter to use internally | `"org.apache.kafka.connect.json.JsonConverter"` |
| `connectRestAdvertisedHostName` |  The advertised hostname for Kafka Connect | `"localhost"` |
| `connectLog4jLoggers` | The log level for Kafka Connect | `"org.reflections=ERROR"` |
| `connectPluginPath` | The location of Kafka Connect plugins | `"/usr/share/java"` |
| `connectJavaHeap` | The size of the Java Heap that Kafka Connect should use | `512m` |
| `schemaRegistry.enabled` | If `true`, install schema registry chart as a dependency | `true` |
| `schemaRegsitry.overrideURL` | If schema registry install is disabled, the URL of schema registry. | `""` |
| `kafka.enabled` | If `true`, installs the kafka chart as a dependency (via schema registry chart) | `true` |
| `kafka.overrideBootstrapServers` | If kafka install is disabled, the broker URLs for Kafka, or the Kubernetes headless service address | `""` |

The above parameters map to the env variables defined in
[kafka-connect](https://www.confluent.io/product/connectors/). For more information please
refer to the [kafka-connect](https://www.confluent.io/product/connectors/) documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For
example,

```bash
$ helm install --name my-release --set yourVar=donuts,imageTag=1.1-rc1 incubator/kafka-connect
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/kafka-connect
```

> **Tip**: You can use the default [values.yaml](values.yaml)
