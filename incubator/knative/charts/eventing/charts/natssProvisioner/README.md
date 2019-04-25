# Natss Provisioner for Knative Eventing

This chart installs Natss Provisioner components for Knative Eventing.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This chart is a subchart of Knative Eventing. It installs Natss Provisioner. Visit [Eventing](https://github.com/knative/eventing/blob/master/README.md) to find out more about Knative Eventing.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- Natss Provisioner for Knative Eventing:
    - Deployments: natss-controller, natss-dispatcher, eventing-controller, webhook
    - ServiceAccounts: in-memory-channel-controller, in-memory-channel-dispatcher, eventing-controller, eventing-webhook
    - Service: webhook

### Configuration

| Parameter                                  | Description                              | Default |
|--------------------------------------------|------------------------------------------|---------|
| `eventing.natssProvisioner.enabled`        | Enable/Disable NATS Provisioner          | `false`   |
| `eventing.natssProvisioner.natssController.controller.image` | Controller Image | gcr.io/knative-releases/github.com/knative/eventing/contrib/natss/pkg/controller@sha256:c0ee52280ba652fa42d6a60ad5e51d7650244043b05e7fd6d693dfbfceb8abd6 |
| `eventing.natssProvisioner.natssController.replicas` | Controller Replicas            | 1         | 
| `eventing.natssProvisioner.natssDispatcher.dispatcher.image` | Dispatcher Image       | gcr.io/knative-releases/github.com/knative/eventing/contrib/natss/pkg/dispatcher@sha256:2de14f9876d0288060bae5266e663f9d77c130a8d491680438552b70cf394ca5 |
| `eventing.natssProvisioner.natssDispatcher.replicas` | Dispatcher Replicas            | 1         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Additional Information
For further information see the top level Knative chart.