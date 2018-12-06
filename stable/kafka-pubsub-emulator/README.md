# Pub/Sub Emulator for Kafka

This chart packages the [Pub/Sub Emulator for
Kafka](https://github.com/GoogleCloudPlatform/kafka-pubsub-emulator) which
implements an emulation layer on top of an existing
[Kafka](https://kafka.apache.org/) cluster.

## Prerequisites
* Kubernetes 1.4+ with Beta APIs enabled
* A Kafka cluster


## Chart Details
This chart will create:

1. A
   [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
   with a single replica running the Pub/Sub Emulator for Kafka

2. A
   [Service](https://kubernetes.io/docs/concepts/services-networking/service/)
   exposing the Pub/Sub Emulator for Kafka

3. A [ConfigMap](https://kubernetes.io/docs/tutorials/configuration/) that
   holds the configuration for the Pub/Sub Emulator for Kafka that will be
   mounted by the Pods in the Deployment above

### Installation

```
helm install --name emulator stable/kafka-pubsub-emulator
```

### Configuration

You can provide the configuration of the Pub/Sub Emulator for Kafka using the
`emulatorConfig` key in `values.yaml`. Refer to the [Configuration
Options](https://github.com/GoogleCloudPlatform/kafka-pubsub-emulator#configuration-options)
section in the original repository for details.

You will need to specify at least your Kafka Bootstrap Servers, for example:

```
helm install --name emulator \
    --set emulatorConfig.kafka.bootstrapServers='kafka1:9092\,kafka2:9092\,kafka3:9092'
```

|Parameter|Description|Default|
| - | - | - |
| `image.repository` | Image repository | `us.gcr.io/kafka-pubsub-emulator/kafka-pubsub-emulator`
| `image.tag` | Image tag | `1.0.0.0`
| `service.type` | Service type | `LoadBalancer`
| `service.port` | Service port | `80`
| `ingress.enabled` | Enable ingress controller resource | `false`
| `ingress.annotations` | Annotations for the ingress record | `[]`
| `ingress.hosts` | Hostname to Pub/Sub Emulator for Kafka installation | `[emulator.local]`
| `ingress.path` | Path within the url structure | `/`
| `ingress.tls ` | TLS configuration | `[]`
| `livenessProbe.tcpSocket.port`| Liveness probe target port | `8080`
| `livenessProbe.initialDelaySeconds`| Liveness probe initial delay | `5`
| `readinessProbe.tcpSocket.port`| readiness probe target port | `8080`
| `readinessProbe.initialDelaySeconds`| readiness probe initial delay | `5`
| `emulatorConfig.server.port` | Port for the Emulator to listen on | `8080`
| `emulatorConfig.kafka.bootstrapServers` | Kafka bootstrap servers | `[]`

## Use the Emulator

According to Google Cloud Pub/Sub
[documentation](https://cloud.google.com/pubsub/docs/emulator), [Google Cloud
Client
Libraries](https://cloud.google.com/pubsub/docs/reference/libraries#gcloud-libraries)
support using a Pub/Sub emulator by setting the `PUBSUB_EMULATOR_HOST`
environment variable, for example, on Linux:
```
export PUBSUB_EMULATOR_HOST=$SERVICE_IP:$SERVICE_PORT
./my_pubsub_application
```
Where `$SERVICE_IP` and `$SERVICE_PORT` depend on the way you expose the
service outside of your Kubernetes cluster.
