# Kafka Provisioner for Knative Eventing

This chart installs Kafka provisioner components for Knative Eventing.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This chart is a subchart of Knative Eventing. It installs Kafka Provisioner. Visit [Knative Eventing](https://github.com/knative/eventing/blob/master/README.md) to find out more about Knative Eventing.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- Kafka Provisioner for Knative Eventing:
    - Deployments: kafka-channel-controller, eventing-controller, webhook
    - ServiceAccounts: kafka-channel-dispatcher, kafka-channel-controller, eventing-controller, eventing-webhook
    - StatefulSet: kafka-channel-dispatcher

### Configuration

| Parameter                                  | Description                              | Default |
|--------------------------------------------|------------------------------------------|---------|
| `eventing.kafkaProvisioner.enabled`        | Enable/Disable Kafka Provisioner         | `false`   |
| `eventing.kafkaProvisioner.kafkaChannelController.kafkaChannelControllerController.image` | Controller Image | gcr.io/knative-releases/github.com/knative/eventing/contrib/kafka/cmd/controller@sha256:5fa8b57594949b7e6d9d99d0dfba5109d0a57c497d34f0d8d84569cb9f2ad19e | 
| `eventing.kafkaProvisioner.kafkaChannelController.replicas` | Controller Replicas     | 1         | 
| `eventing.kafkaProvisioner.kafkaChannelDispatcher.dispatcher.image` | Dispatcher Image | gcr.io/knative-releases/github.com/knative/eventing/contrib/kafka/cmd/dispatcher@sha256:94d0f74892ce19e7f909bc0063b89ba68f85e2d12188f6bf918321542adcec05 |
| `eventing.kafkaProvisioner.kafkaChannelDispatcher.replicas` | Dispatcher Replicas     | 1         | 

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Additional Information
For further information see the top level Knative chart.