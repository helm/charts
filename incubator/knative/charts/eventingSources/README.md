# Knative Eventing Sources

This chart installs Knative components for Eventing Sources.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This is a helm chart for installing Knative Eventing Sources which provides loosely coupled services that can be developed and deployed on independently on Kubernetes. Visit [Knative Eventing Sources](https://github.com/knative/eventing-sources/blob/master/README.md) for more information.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- Knative Eventing Sources:
    - StatefulSet: controller-manager
    - ServiceAccount: controller-manager
    - Service: controller

### Configuration

| Parameter                                  | Description                              | Default |
|--------------------------------------------|------------------------------------------|---------|
| `eventingSources.enabled`                  | Enable/Disable Knative Eventing Sources  | `false`   |
| `eventingSources.controllerManager.manager.image`        | Manager Image for Controller Manager | gcr.io/knative-releases/github.com/knative/eventing-sources/cmd/manager@sha256:deb40ead1bd4eedda8384d1e6d535cf75f1820ac723fdaa0c4670636ca94cf2e   |
| `eventingSources.camel.enabled`            | Enable/Disable Apache Camel Event Source | `false`   |
| `eventingSources.camel.camelControllerManager.manager.image`        | Manager Image for Camel Controller Manager | gcr.io/knative-releases/github.com/knative/eventing-sources/contrib/camel/cmd/controller@sha256:1c4631019f85cf63b7d6362a99483fbaae65277a68ac004de15168a79e90be73   |
| `eventingSources.eventDisplay.enabled`     | Enable/Disable A Knative Service that logs events received for use in samples and debugging. | `false`   |
| `eventingSources.eventDisplay.eventDisplay.image`        | Event Display Image for Event Display | gcr.io/knative-releases/github.com/knative/eventing-sources/cmd/event_display@sha256:bf45b3eb1e7fc4cb63d6a5a6416cf696295484a7662e0cf9ccdf5c080542c21d   |
| `eventingSources.gcpPubSub.enabled`        | Enable/Disable GCP Event Source          | `false`   |
| `eventingSources.gcpPubSub.gcppubsubControllerManager.manager.image`        | Google Cloud Platform Pub Sub Controller Manager Image | gcr.io/knative-releases/github.com/knative/eventing-sources/contrib/gcppubsub/cmd/controller@sha256:cde83a9f10c3c1340c93a9a9fd5ba76c9f7c33196fdab98a4c525f9cd5d3bb1f   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Additional Information
For further information see the top level Knative chart.