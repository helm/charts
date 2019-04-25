# In Memory Provisioner for Knative Eventing

This chart installs In Memory Provisioner components for Knative Eventing.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This chart is a subchart of Knative Eventing. It installs In Memory Provisioner. Visit [Knative Eventing](https://github.com/knative/eventing/blob/master/README.md) to find out more about Knative Eventing.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- In Memory Provisioner for Knative Eventing:
    - Deployments: in-memory-channel-controller, in-memory-channel-dispatcher, eventing-controller, webhook
    - ServiceAccounts: in-memory-channel-controller, in-memory-channel-dispatcher, eventing-controller, eventing-webhook
    - Service: webhook

### Configuration

| Parameter                                  | Description                              | Default |
|--------------------------------------------|------------------------------------------|---------|
| `eventing.inMemoryProvisioner.enabled`     | Enable/Disable In-Memory Provisioner     | `false`   |
| `eventing.inMemoryProvisioner.inMemoryChannelController.controller.image` | Controller Image                    | gcr.io/knative-releases/github.com/knative/eventing/pkg/provisioners/inmemory/controller@sha256:3e4287fba1447d82b80b5fd87983609ba670850c4d28499fe7e60fb87d04cc53 |
| `eventing.inMemoryProvisioner.inMemoryChannelController.replicas`    | Controller Replicas           | 1         |
| `eventing.inMemoryProvisioner.inMemoryChannelDispatcher.dispatcher.image` | Dispatcher Image | gcr.io/knative-releases/github.com/knative/eventing/cmd/fanoutsidecar@sha256:f388c5226fb7f29b74038bef5591de05820bcbf7c13e7f5e202f1c5f9d9ab224 | 
| `eventing.inMemoryProvisioner.inMemoryChannelDispatcher.replicas` | Dispatcher Replicas | 1       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Additional Information
For further information see the top level Knative chart.