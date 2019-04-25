# Knative Eventing

This chart installs Knative components for Eventing.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This is a helm chart for installing Knative Eventing which provides loosely coupled services that can be developed and deployed on independently on Kubernetes. Visit [Knative Eventing](https://github.com/knative/eventing/blob/master/README.md) for more information.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- Knative Eventing:
    - Deployments: eventing-controller, webhook
    - ServiceAccount: default, eventing-controller, eventing-webhook
    - Service: webhook

### Configuration

| Parameter                                  | Description                              | Default |
|--------------------------------------------|------------------------------------------|---------|
| `eventing.enabled`                         | Enable/Disable Knative Eventing          | `false`   |
| `eventing.eventingController.image`        | Controller Image                         | gcr.io/knative-releases/github.com/knative/eventing/cmd/controller@sha256:de1727c9969d369f2c3c7d628c7b8c46937315ffaaf9fe3ca242ae2a1965f744 | 
| `eventing.eventingController.replicas`                        | Controller Replicas                      | 1         |
| `eventing.webhook.image`                   | Webhook Image                            | gcr.io/knative-releases/github.com/knative/eventing/cmd/webhook@sha256:3c0f22b9f9bd9608f804c6b3b8cbef9cc8ebc54bb67d966d3e047f377feb4ccb |
| `eventing.webhook.replicas`                | Webhook Replicas                         | 1         |
| `eventing.gcpPubSubProvisioner.enabled`    | Enable/Disable GCP PubSub Provisioner    | `false`   |
| `eventing.gcpPubSubProvisioner.gcpPubsubChannelController.controller.image` | Controller Image | gcr.io/knative-releases/github.com/knative/eventing/contrib/gcppubsub/pkg/controller/cmd@sha256:a37c64dc6cf6a22bd8a47766e3de1fb945dcec97d6fe768d675430f16ff011dd |
| `eventing.gcpPubSubProvisioner.gcpPubsubChannelController.replicas` | Controller Replicas | 1     |
| `eventing.gcpPubSubProvisioner.gcpPubsubChannelDispatcher.dispatcher.image` | Dispatcher Image | gcr.io/knative-releases/github.com/knative/eventing/contrib/gcppubsub/pkg/dispatcher/cmd@sha256:ffcc3319ca6b87075e6cac939c15d50862214ace4ff3d4bacb3853d43e9b0efb | 
| `eventing.gcpPubSubProvisioner.gcpPubsubChannelDispatcher.replicas` | Dispatcher Replicas | 1     |
| `eventing.gcpPubSubProvisioner.type`       | GCP PubSub Provisioner Ingress Type      | ClusterIP |
| `eventing.inMemoryProvisioner.enabled`     | Enable/Disable In-Memory Provisioner     | `false`   |
| `eventing.inMemoryProvisioner.inMemoryChannelController.controller.image` | Controller Image                    | gcr.io/knative-releases/github.com/knative/eventing/pkg/provisioners/inmemory/controller@sha256:3e4287fba1447d82b80b5fd87983609ba670850c4d28499fe7e60fb87d04cc53 |
| `eventing.inMemoryProvisioner.inMemoryChannelController.replicas`    | Controller Replicas           | 1         |
| `eventing.inMemoryProvisioner.inMemoryChannelDispatcher.dispatcher.image` | Dispatcher Image | gcr.io/knative-releases/github.com/knative/eventing/cmd/fanoutsidecar@sha256:f388c5226fb7f29b74038bef5591de05820bcbf7c13e7f5e202f1c5f9d9ab224 | 
| `eventing.inMemoryProvisioner.inMemoryChannelDispatcher.replicas` | Dispatcher Replicas | 1       |
| `eventing.kafkaProvisioner.enabled`        | Enable/Disable Kafka Provisioner         | `false`   |
| `eventing.kafkaProvisioner.kafkaChannelController.kafkaChannelControllerController.image` | Controller Image | gcr.io/knative-releases/github.com/knative/eventing/contrib/kafka/cmd/controller@sha256:5fa8b57594949b7e6d9d99d0dfba5109d0a57c497d34f0d8d84569cb9f2ad19e | 
| `eventing.kafkaProvisioner.kafkaChannelController.replicas` | Controller Replicas     | 1         | 
| `eventing.kafkaProvisioner.kafkaChannelDispatcher.dispatcher.image` | Dispatcher Image | gcr.io/knative-releases/github.com/knative/eventing/contrib/kafka/cmd/dispatcher@sha256:94d0f74892ce19e7f909bc0063b89ba68f85e2d12188f6bf918321542adcec05 |
| `eventing.kafkaProvisioner.kafkaChannelDispatcher.replicas` | Dispatcher Replicas     | 1         | 
| `eventing.natssProvisioner.enabled`        | Enable/Disable NATS Provisioner          | `false`   |
| `eventing.natssProvisioner.natssController.controller.image` | Controller Image | gcr.io/knative-releases/github.com/knative/eventing/contrib/natss/pkg/controller@sha256:c0ee52280ba652fa42d6a60ad5e51d7650244043b05e7fd6d693dfbfceb8abd6 |
| `eventing.natssProvisioner.natssController.replicas` | Controller Replicas            | 1         | 
| `eventing.natssProvisioner.natssDispatcher.dispatcher.image` | Dispatcher Image       | gcr.io/knative-releases/github.com/knative/eventing/contrib/natss/pkg/dispatcher@sha256:2de14f9876d0288060bae5266e663f9d77c130a8d491680438552b70cf394ca5 |
| `eventing.natssProvisioner.natssDispatcher.replicas` | Dispatcher Replicas            | 1         |
Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Additional Information
For further information see the top level Knative chart.