# GCP Pub Sub Component for Knative Eventing Sources

This chart installs GCP Pub Sub Component for Knative Eventing Sources.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This is a helm chart for installing Knative Eventing Sources which provides loosely coupled services that can be developed and deployed on independently on Kubernetes. Visit [Knative Eventing Sources](https://github.com/knative/eventing-sources/blob/master/README.md) for more information.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- GCP Pub Sub Component for Knative Eventing Sources:
    - StatefulSet: gcppubsub-controller-manager, controller-manager
    - ServiceAccount: gcppubsub-controller-manager, controller-manager
    - Service: gcppubsub-controller, controller

### Configuration

| Parameter                                  | Description                              | Default |
|--------------------------------------------|------------------------------------------|---------|
| `eventingSources.gcpPubSub.enabled`        | Enable/Disable GCP Event Source          | `false`   |
| `eventingSources.gcpPubSub.gcppubsubControllerManager.manager.image`        | Google Cloud Platform Pub Sub Controller Manager Image | gcr.io/knative-releases/github.com/knative/eventing-sources/contrib/gcppubsub/cmd/controller@sha256:cde83a9f10c3c1340c93a9a9fd5ba76c9f7c33196fdab98a4c525f9cd5d3bb1f   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Additional Information
For further information see the top level Knative chart.