# Knative Monitoring

This chart installs Knative components for Monitoring.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This is a helm chart for installing Knative Monitoring which provides tracing, logging and metrics. More info about Knative Monitoring can be found in the [Serving documentation](https://github.com/knative/docs/tree/master/serving#setting-up-logging-and-metrics).

## Chart Details

- Internal Services:
    - elasticsearch-logging, fluentd-ds, node-exporter, prometheus-system, kibana-logging, grafana, kube-controller-manager, kube-state-metrics, prometheus-system-discovery, prometheus-system-np, zipkin

- Knative Monitoring Pods:
    - Deployments: kube-state-metrics
    - DaemonSet: node-exporter, fluentd-ds
    - ServiceAccounts: elasticsearch-logging, fluentd-ds, kube-state-metrics, node-exporter, prometheus-system
    - metric: revisionrequestcount, revisionrequestduration, revisionrequestsize, revisionresponsesize

- Custom Resource Definitions:
    - elasticsearch-logging
    - fluentd-ds
    - node-exporter
    - prometheus-system

## Prerequisites

- Requires kubectl v1.10+.
- Knative requires a Kubernetes cluster v1.10 or newer with the
[MutatingAdmissionWebhook admission controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#how-do-i-turn-on-an-admission-controller)
enabled.
- Create a namespace called `knative-monitoring`.
- Istio - You should have Istio installed on your Kubernetes cluster. If you do not have it installed already you can do so by running the following command:
```bash
$ kubectl apply --filename https://raw.githubusercontent.com/knative/serving/v0.2.3/third_party/istio-1.0.2/istio.yaml
```
or following these steps:
[Installing istio](https://github.com/knative/docs/blob/master/install/Knative-with-any-k8s.md#installing-istio)

## Installing the Chart

Please ensure that you have reviewed the [prerequisites](#prerequisites).
In its default configuration this chart will install elasticsearch-logging, prometheus-metrics and zipkin-tracing in memory. Change the [Values.yaml](./values.yaml) by enabling or disabling what you want to be installed.

To install the chart using helm cli:

Install Knative Monitoring
```
$ helm install ./knative/charts/serving/charts/monitoring
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

You must use `knative-monitoring` namespace to install Knative Monitoring.

## Documentation

To learn more about Knative in general, see the [Overview](https://github.com/knative/docs/blob/master/README.md).

# Support

If you're a developer, operator, or contributor trying to use Knative, the
following resources are available for you:

- [Knative Users](https://groups.google.com/forum/#!forum/knative-users)
- [Knative Developers](https://groups.google.com/forum/#!forum/knative-dev)

For contributors to Knative, we also have [Knative Slack](https://slack.knative.dev).