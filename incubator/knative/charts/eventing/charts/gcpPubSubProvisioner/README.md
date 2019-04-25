# GCP Pub Sub Provisioner for Knative Eventing

This chart installs GCP Pub Sub Provisioner components for Knative Eventing.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This chart is a subchart of Knative Eventing. It installs GCP Pub Sub Provisioner. Visit [Eventing](https://github.com/knative/eventing/blob/master/README.md) to find out more about Knative Eventing.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- GCP Pub Sub Provisioner for Knative Eventing:
    - Deployments: natss-controller, natss-dispatcher, eventing-controller, webhook
    - ServiceAccounts: in-memory-channel-controller, in-memory-channel-dispatcher, eventing-controller, eventing-webhook
    - Service: webhook

### Configuration

| Parameter                                  | Description                              | Default |
|--------------------------------------------|------------------------------------------|---------|
| `eventing.gcpPubSubProvisioner.enabled`    | Enable/Disable GCP PubSub Provisioner    | `false`   |
| `eventing.gcpPubSubProvisioner.gcpPubsubChannelController.controller.image` | Controller Image | gcr.io/knative-releases/github.com/knative/eventing/contrib/gcppubsub/pkg/controller/cmd@sha256:a37c64dc6cf6a22bd8a47766e3de1fb945dcec97d6fe768d675430f16ff011dd |
| `eventing.gcpPubSubProvisioner.gcpPubsubChannelController.replicas` | Controller Replicas | 1     |
| `eventing.gcpPubSubProvisioner.gcpPubsubChannelDispatcher.dispatcher.image` | Dispatcher Image | gcr.io/knative-releases/github.com/knative/eventing/contrib/gcppubsub/pkg/dispatcher/cmd@sha256:ffcc3319ca6b87075e6cac939c15d50862214ace4ff3d4bacb3853d43e9b0efb | 
| `eventing.gcpPubSubProvisioner.gcpPubsubChannelDispatcher.replicas` | Dispatcher Replicas | 1     |
| `eventing.gcpPubSubProvisioner.type`       | GCP PubSub Provisioner Ingress Type      | ClusterIP |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Additional Information
For further information see the top level Knative chart.