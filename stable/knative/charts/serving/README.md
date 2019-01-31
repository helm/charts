# Knative Serving

This chart installs Knative components for Serving.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This is a helm chart for installing Knative serving which provides provides middleware primitives that enable rapid deployment of serverless containers, automatic scaling up and down to zero, routing and network programming for Istio components and point-in-time snapshots of deployed code and configurations. Visit [knative serving](https://github.com/knative/serving/blob/master/README.md) for more information.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- Internal Services:
    - kube-state-metrics, knative-ingressgateway, elasticsearch-logging, fluentd-ds, kibana-logging, grafana, kube-controller-manager
    - node-exporter, prometheus-system-discovery prometheus-system-np, zipkin, activator, autoscaler, controller, webhook

- Knative Serving Pods:
    - Deployments: kube-state-metrics, knative-ingressgateway
    - DaemonSet: fluent-ds  
    - ServiceAccounts: elasticsearch-logging, fluentd-ds, kube-state-metrics, node-exporter, prometheus-system, autoscaler, controller
    - metric: revisionrequestcount, revisionrequestduration, revisionrequestsize, revisionresponsesize

- Custom Resource Definitions:
    - revisions.serving.knative.dev
    - clusteringresses.networking.internal.knative.dev
    - configurations.serving.knative.dev
    - services.serving.knative.dev
    - podautoscalers.autoscaling.internal.knative.dev
    - routes.serving.knative.dev
    - images.caching.internal.knative.dev

- HorizontalPodAutoscaler:
    - knative-ingressgateway

## Prerequisites

- Requires kubectl v1.10+.
- Knative requires a Kubernetes cluster v1.10 or newer with the
[MutatingAdmissionWebhook admission controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#how-do-i-turn-on-an-admission-controller)
enabled.
- CRD's - If you are installing this chart without installing the top level Knative chart, you must install the crds that are kept in the Knative level of this chart. Run the following command to install the needed crds.
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

## Installing the Charts

Please ensure that you have reviewed the [prerequisites](#prerequisites).

To install the chart using helm cli:

Install Knative Serving
```
$ helm install ./knative/serving
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

To uninstall/delete the crds:
```bash
$ kubectl delete -f knative/templates/crds.yaml
$ kubectl delete -f knative/charts/serving/templates/crds.yaml
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Limitations

You must use `knative-serving` namespace to install Knative serving.

## Documentation

Documentation of the Knative serving system can be found on the [Knative Serving Docs](https://github.com/knative/serving/blob/master/README.md).

To learn more about Knative in general, see the [Overview](https://github.com/knative/docs/blob/master/README.md).

# Support

If you're a developer, operator, or contributor trying to use Knative, the
following resources are available for you:

- [Knative Users](https://groups.google.com/forum/#!forum/knative-users)
- [Knative Developers](https://groups.google.com/forum/#!forum/knative-dev)

For contributors to Knative, we also have [Knative Slack](https://slack.knative.dev).