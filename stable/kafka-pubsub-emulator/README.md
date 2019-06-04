# Pub/Sub Emulator for Kafka

This chart packages the [Pub/Sub Emulator for Kafka](https://github.com/GoogleCloudPlatform/kafka-pubsub-emulator) which implements an emulation layer on top of an existing [Kafka](https://kafka.apache.org/) cluster.

## Prerequisites

* Kubernetes 1.4+ with Beta APIs enabled
* A Kafka cluster

## Chart Details

This chart will create:

1. A [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) with a single replica running the Pub/Sub Emulator for Kafka

2. A [Service](https://kubernetes.io/docs/concepts/services-networking/service/) exposing the Pub/Sub Emulator for Kafka

3. A [ConfigMap](https://kubernetes.io/docs/tutorials/configuration/) that holds the Server configuration for the Pub/Sub Emulator for Kafka that will be mounted by the Pods in the StatefulSet above

4. A [PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) that holds the projects layout (topics and subscriptions) configuration used by the Pub/Sub Emulator for Kafka

4. A [Kafka](https://github.com/helm/charts/tree/master/incubator/kafka) cluster (optional, enabled by default)

### Installation

```shell
helm install --name emulator stable/kafka-pubsub-emulator
```

### Configuration

|Parameter|Description|Default|
| - | - | - |
| `image.repository` | Image repository | `us.gcr.io/kafka-pubsub-emulator/kafka-pubsub-emulator`
| `image.tag` | Image tag | `0.1.0`
| `service.type` | Service type | `LoadBalancer`
| `service.port` | Service port | `80`
| `ingress.enabled` | Enable ingress controller resource | `false`
| `ingress.annotations` | Annotations for the ingress record | `[]`
| `ingress.hosts` | Hostname to Pub/Sub Emulator for Kafka installation | `[emulator.local]`
| `ingress.path` | Path within the url structure | `/`
| `ingress.tls ` | TLS configuration | `[]`
| `livenessProbe.tcpSocket.port`| Liveness probe target port | `8080`
| `kafka.enabled`| Define wether to install a Kafka cluster as part of the
release | `true`
| `readinessProbe.tcpSocket.port`| readiness probe target port | `8080`
| `readinessProbe.initialDelaySeconds`| readiness probe initial delay | `5`
| `server.port` | Port for the Emulator to listen on | `8080`
| `server.kafka.bootstrapServers` | Kafka bootstrap servers, if empty and
`kafka.enabled` is true it will be generated based on release name | `""`
| `server.kafka.consumerProperties.maxPollRecords` | `max.poll.records` value for each consumer | `1000`
| `server.kafka.consumersPerSubscription` | Number of consumers per subscription | `4`
| `server.kafka.producerExecutors` | Number of Kafka producer executors | `4`
| `server.kafka.producerProperties.lingerMs` | `linger.ms` value for each producer | `200`
| `server.kafka.producerProperties.batchSize` | `batch.size` value for each producer | `1000`
| `server.kafka.producerProperties.bufferMemory` | `buffer.memory` value for each producer | `32000000`
| `pubsub.projects` | Initial PubSub projects configuration | [Default PubSub Configuration](#markdown-header-default-pubsub-configuration)

#### Default PubSub Configuration
The following project layout configuration is generated when the PubSub emulator is first started:

```yaml
projects:
  - name: default
    topics:
      - name: topic1
        kafkaTopic: topic1
        subscriptions:
          - name: subscription-topic1
            ackDeadlineSeconds: 10
```

Since the PubSub emulator writes back changes to the project layout that happen at runtime (e.g. via `createTopic` or `createSubscription`) this configuration is applied only when the PubSub emulator is started the first time and no previous configuration exists.

## Use the Emulator

According to Google Cloud Pub/Sub
[documentation](https://cloud.google.com/pubsub/docs/emulator), [Google Cloud Client Libraries](https://cloud.google.com/pubsub/docs/reference/libraries#gcloud-libraries) support using a Pub/Sub emulator by setting the `PUBSUB_EMULATOR_HOST` environment variable, for example, on Linux:

```shell
export PUBSUB_EMULATOR_HOST=$SERVICE_IP:$SERVICE_PORT
./my_pubsub_application
```

Where `$SERVICE_IP` and `$SERVICE_PORT` depend on the way you expose the
service outside of your Kubernetes cluster.
