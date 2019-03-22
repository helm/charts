# Kafka provisioner for Knative Eventing

This chart installs Kafka provisioner components for Knative Eventing.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This chart is a subchart of Knative Eventing. It installs Kafka Provisioner. Visit [Eventing](https://github.com/knative/eventing/blob/master/README.md) to find out more about Knative Eventing.

## Chart Details

- Internal Services:
    - kafka-channel-dispatcher, kafka-channel-controller

- Knative Kafka provisioner Pods:
    - Deployments: kafka-channel-controller
    - StatefulSet: kafka-channel-dispatcher

## Prerequisites

- Requires kubectl v1.10+.
- Knative requires a Kubernetes cluster v1.10 or newer with the
[MutatingAdmissionWebhook admission controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#how-do-i-turn-on-an-admission-controller)
enabled.
- CRD's, for Knative Eventing to run standalone, you must install the crds that are kept in the Eventing level of this chart, run the command to install the crds:
```bash
$ kubectl apply --filename ./knative/charts/eventing/templates/crds.yaml
```
- Create a namespace called `knative-eventing`.
- Istio - You should have Istio installed on your Kubernetes cluster. If you do not have it installed already you can do so by running the following command:
```bash
$ kubectl apply --filename https://raw.githubusercontent.com/knative/serving/v0.2.3/third_party/istio-1.0.2/istio.yaml
```
or following these steps:
[Installing istio](https://github.com/knative/docs/blob/master/install/Knative-with-any-k8s.md#installing-istio)

## Installing the Chart

Please ensure that you have reviewed the [prerequisites](#prerequisites).
To install the chart using helm cli:

Install kafka provisioner for eventing
```
$ helm install ./knative/charts/eventing/charts/kafka-provisioner
```

### Configuration

[Values.yaml](./values.yaml) outlines the configuration options that are supported by this chart.

If your installing Knative Eventing with a Kafka provisioner you must change `bootstrapServers: " "` to point towards an existing Kafka Broker in the [Values.yaml](./values.yaml).

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

You must use `knative-eventing` namespace to install Knative Eventing.

## Documentation

To learn more about Knative in general, see the [Overview](https://github.com/knative/docs/blob/master/README.md).

# Support

If you're a developer, operator, or contributor trying to use Knative, the
following resources are available for you:

- [Knative Users](https://groups.google.com/forum/#!forum/knative-users)
- [Knative Developers](https://groups.google.com/forum/#!forum/knative-dev)

For contributors to Knative, we also have [Knative Slack](https://slack.knative.dev).
