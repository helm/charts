# Camel Components for Knative Eventing Sources

This chart installs Camel Components for Knative Eventing Sources.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This is a helm chart for installing Knative Eventing Sources which provides loosely coupled services that can be developed and deployed on independently on Kubernetes. Visit [Knative Eventing Sources](https://github.com/knative/eventing-sources/blob/master/README.md) for more information.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- Camel Components for Knative Eventing Sources:
    - StatefulSet: camel-controller-manager, controller-manager
    - ServiceAccount:camel-controller-manager, controller-manager
    - Service: camel-controller-manager, controller

### Configuration

| Parameter                                  | Description                              | Default |
|--------------------------------------------|------------------------------------------|---------|
| `eventingSources.camel.enabled`            | Enable/Disable Apache Camel Event Source | `false`   |
| `eventingSources.camel.camelControllerManager.manager.image`        | Manager Image for Camel Controller Manager | gcr.io/knative-releases/github.com/knative/eventing-sources/contrib/camel/cmd/controller@sha256:1c4631019f85cf63b7d6362a99483fbaae65277a68ac004de15168a79e90be73   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Additional Information
For further information see the top level Knative chart.