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
| `replicaCount` | The number of replias in the deployment | `1` |
| `image.repository`          | `kafka-connect` image repository           | `confluentinc/cp-kafka-connect`                                       |
| `image.tag`                 | `kafka-connect` image tag                  | `5.2.2`                                                   |
| `image.pullPolicy`          | Image pull policy                          | `IfNotPresent`    |
| `imagePullSecrets` | A list of any required image pull secrets | `[]` |
| `nameOverride` | A name override to use int he chart, if any | `""` |
| `fullNameOverride` | A full-name override to use int he chart, if any | `""` |
| `keyConverter` | The type of Kafka key converter which Kafka Connect should utilize. | `org.apache.kafka.connect.json.JsonConverter` |
| `keyConverterSchemasEnable` | If true, enable usage of schemas with the key converter. | `false` |
| `valueConverter` | The type of Kafka value converter which Kafka Connect should utilize | `org.apache.kafka.connect.json.JsonConverter` |
| `valueConverterSchemasEnable` | If true, enable usage of schemas with the value converter | `false` |
| `internalKeyConverter` | The type of Kafka Connect key converter to use internally | `org.apache.kafka.connect.json.JsonConverter` |
| `internalValueConverter` | The type of Kafka Connect value converter to use internally | `org.apache.kafka.connect.json.JsonConverter` |
| `pluginPath` | Where plugin JARs will be located on disk | `/usr/share/java` |
| `heapOpts` | Java Heap Options | `-Xmx512m -Xms512m` |
| `configStorageNameOverride` | If specified, use this config storage topic name | `""` |
| `configStorageReplicationFactory` | Kafka Replication for the config topic | `1` |
| `offsetStorageNameOverride` | If specified, use this offset storage topic name | `""` |
| `offsetStorageReplicationFactory` | Kafka Replication for the offset topic | `1` |
| `statusStorageNameOverride` | If specified, use this status storage topic name | `""` |
| `statusStorageReplicationFactory` | Kafka Replication for the status topic | `1` |
| `configurationOverrides` | Any additional Kafka Connect configuration overrides | `{}`
| `jmx.port` | What port to expose Kafka Connect JMX metrics on | `5555` |
| `prometheus.exporter.enabled` | If true, enable the prometheus operator exporter | `false` |
| `prometheus.exporter.selector.prometheus` | Name of the prometheus selector to be used | `""` |
| `prometheus.alerts.enabled` | If true, Kafka Connect AlertManager alerts are enabled | `false` |
| `prometheus.alerts.selector.prometheus` | Name of the prometheus selector to be used | `""` |
| `prometheus.servicemonitor.enabled` | If true, enable the prometheus service monitor | `false` |
| `prometheus.jmx.enabled` | If true, enable the Prometheus JMX exporter | `true` |
| `prometheus.jmx.image` | The JMX to Prometheus exporter image to use | `solsson/kafka-prometheus-jmx-exporter@sha256` |
| `prometheus.jmx.imageTag` | The JMX to Prometheus exporter image tag to use | `6f82e2b0464f50da8104acd7363fb9b995001ddff77d248379f8788e78946143` |
| `prometheus.jmx.portName` | The name of the JMX to Prometheus exporter image port | `jmx-prometheus` |
| `prometheus.jmx.port` | The port on which the Prometheus JMX metrics will be scraped | `5556` |
| `prometheus.jmx.resources` | The resources assigned to the JMX exporter | `{}` |
| `prometheus.jmx.rules` | A list of JMX to Prometheus exporter rules. By default all metrics are exported. | `[]`
| `schemaRegistry.enabled` | If `true`, install schema registry chart as a dependency | `true` |
| `schemaRegistry.overrideURL` | If schema registry install is disabled, the URL of schema registry. | `""` |
| `schemaRegistry.truststoreSecret` | The name of the Schema Registry Kafka truststore secret, if any | `""` |
| `schemaRegistry.keystoreSecret` | The name of the Schema Registry Kafka keystore secret, if any | `""` |
| `kafka.enabled` | If `true`, installs the kafka chart as a dependency (via schema registry chart) | `true` |
| `kafka.overrideBootstrapServers` | If kafka install is disabled, the broker URLs for Kafka, or the Kubernetes headless service address | `""` |
| `kafka.truststoreSecret` | The name of the Kafka truststore secret that Kafka Connect should use, if any | `""` |
| `kafka.keystoreSecret` | The name of the Kafka keystore secret that Kafka Connect should use, if any | `""` |
| `service.type` | The type of service to create | `ClusterIP` |
| `service.port` | The service port to expose | `80` |
| `service.annotations` | Any annotations to be added to the service | `{}` |
| `ingress.enabled` | Whether or not an ingress should be created | `false` |
| `ingress.hostname` | The hostname for the ingress | `""` |
| `ingress.annotations` | Any annotations to be added to the ingress | `{}` |
| `ingress.host` | The ingress hostname | `""|
| `ingress.path` | The ingress path | `""` |
| `resources` | Resource requests and limits | `{}` |
| `nodeSelector` | If defined, specific node selectors to provide to the deployment | `{}` |
| `tolerations` | If defined, any scheduling tolerations to be provided to the deployment | `[]` |
| `affinity` | If defined, any affinity rules to be provided to the deployment | `{}` |

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

