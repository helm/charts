# Knative Eventing

This chart installs Knative components for Eventing.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This is a helm chart for installing Knative Eventing which provides loosely coupled services that can be developed and deployed on independently on Kubernetes. Visit [knative eventing](https://github.com/knative/eventing/blob/master/README.md) for more information.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- Internal Services:
    - in-memory-channel-controller, in-memory-channel-dispatcher, eventing-controller, webhook
    - eventing-controller-admin

- Knative Eventing Pods:
    - Deployments: in-memory-channel-controller, in-memory-channel-dispatcher, eventing-controller, webhook

- Custom Resource Definitions:
    - subscriptions.eventing.knative.dev
    - channels.eventing.knative.dev
    - images.caching.internal.knative.dev

## Prerequisites

- Requires kubectl v1.10+.
- Knative requires a Kubernetes cluster v1.10 or newer with the
[MutatingAdmissionWebhook admission controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#how-do-i-turn-on-an-admission-controller)
enabled.
- CRD's, for Knative Eventing to run standalone, you must install the crds that are kept in the Knative level of this chart, run the command to install the crds:
```bash
$ kubectl apply --filename ./knative/templates/crds.yaml

customresourcedefinition.apiextensions.k8s.io "images.caching.internal.knative.dev" created
```
- Istio - You should have Istio installed on your Kubernetes cluster. If you do not have it installed already you can do so by running the following command:
```bash
$ kubectl apply --filename https://raw.githubusercontent.com/knative/serving/v0.2.3/third_party/istio-1.0.2/istio.yaml
```
or by following these steps:
[Installing Istio](https://github.com/knative/docs/blob/master/install/Knative-with-any-k8s.md#installing-istio)

## Installing the Chart

Please ensure that you have reviewed the [prerequisites](#prerequisites).

To install the chart using helm cli:

Knative eventing provides you with an option to choose between Kafka or In memory provisioner.

For in-memory-provisioner in [Values.yaml](./values.yaml) set:
```bash
in-memory-provisioner:
    enabled: true
kafka-provisioner:
    enabled: false
```
For kafka-provisioner in [Values.yaml](./values.yaml) set:
```bash
in-memory-provisioner:
    enabled: false
kafka-provisioner:
    enabled: true
```

Install eventing:
```bash
$ helm install ./knative/eventing
```

### Configuration

If your installing Knative Eventing with a Kafka provisioner you must change `bootstrapServers: " "` to point towards an existing Kafka Broker in the [Values.yaml](./charts/kafka-provisioner/values.yaml).

[Values.yaml](./values.yaml) outlines the configuration options that are supported by this chart.

### Verifying the Chart

To verify all Pods are running, try:
```bash
$ helm status <my-release> [--tls]
```

## Uninstalling the Chart

To uninstall/delete the deployment:
```bash
$ helm delete <my-release> --purge [--tls]
```

To uninstall/delete the crds:
```bash
$ kubectl delete -f knative/all-crds.yaml
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Limitations

You must use `knative-eventing` namespace to install Knative eventing.

## Documentation

Documentation of the Knative eventing system can be found on the [Knative Eventing Docs](https://github.com/knative/eventing/blob/master/README.md).

To learn more about Knative in general, see the [Overview](https://github.com/knative/docs/blob/master/README.md).

# Support

If you're a developer, operator, or contributor trying to use Knative, the
following resources are available for you:

- [Knative Users](https://groups.google.com/forum/#!forum/knative-users)
- [Knative Developers](https://groups.google.com/forum/#!forum/knative-dev)

For contributors to Knative, we also have [Knative Slack](https://slack.knative.dev).