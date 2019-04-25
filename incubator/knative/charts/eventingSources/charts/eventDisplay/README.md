# Event Display Component for Knative Eventing Sources

This chart installs Event Display Component for Knative Eventing Sources.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This is a helm chart for installing Knative Eventing Sources which provides loosely coupled services that can be developed and deployed on independently on Kubernetes. Visit [Knative Eventing Sources](https://github.com/knative/eventing-sources/blob/master/README.md) for more information.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- Event Display Components for Knative Eventing Sources:
    - StatefulSet: controller-manager
    - ServiceAccount: controller-manager
    - Service: controller, event-display

### Configuration

| Parameter                                  | Description                              | Default |
|--------------------------------------------|------------------------------------------|---------|
| `eventingSources.eventDisplay.enabled`     | Enable/Disable A Knative Service that logs events received for use in samples and debugging. | `false`   |
| `eventingSources.eventDisplay.eventDisplay.image`        | Event Display Image for Event Display | gcr.io/knative-releases/github.com/knative/eventing-sources/cmd/event_display@sha256:bf45b3eb1e7fc4cb63d6a5a6416cf696295484a7662e0cf9ccdf5c080542c21d   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Additional Information
For further information see the top level Knative chart.