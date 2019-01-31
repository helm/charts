# Zipkin Tracing for Knative Monitoring

This chart installs Zipkin Tracing components for Knative Monitoring.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This chart is a subchart of Knative Monitoring. It installs Zipkin tracing. Visit [accessing traces](https://github.com/knative/docs/blob/master/serving/accessing-traces.md) to find out more.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- Knative Serving Pods:
    - Deployments: zipkin

## Prerequisites

- Requires kubectl v1.10+.
- Create a namespace called `knative-monitoring`.
- Knative requires a Kubernetes cluster v1.10 or newer with the
[MutatingAdmissionWebhook admission controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#how-do-i-turn-on-an-admission-controller)
enabled.
- Istio - You should have Istio installed on your Kubernetes cluster. If you do not have it installed already you can do so by running the following command:
```bash
$ kubectl apply --filename https://raw.githubusercontent.com/knative/serving/v0.2.3/third_party/istio-1.0.2/istio.yaml
```

## Installing the Chart

Please ensure that you have reviewed the [prerequisites](#prerequisites).

To install the chart using helm cli:

Install Zipkin
```
$ helm install ./knative/serving/charts/monitoring/charts/zipkin
```

### Configuration

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

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Limitations

You must use `knative-monitoring` namespace to install Knative monitoring.

## Documentation

To learn more about Knative in general, see the [Overview](https://github.com/knative/docs/blob/master/README.md).

# Support

If you're a developer, operator, or contributor trying to use Knative, the
following resources are available for you:

- [Knative Users](https://groups.google.com/forum/#!forum/knative-users)
- [Knative Developers](https://groups.google.com/forum/#!forum/knative-dev)

For contributors to Knative, we also have [Knative Slack](https://slack.knative.dev).
