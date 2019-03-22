# Knative Build

This chart installs Knative components for Build.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This is a helm chart for installing Knative build which provides you a standard, portable, reusable, and performance optimized method for defining and running Knative builds on a kubernetes cluster. Visit [knative build](https://github.com/knative/build/blob/master/README.md) for more information.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- Internal Services
    - controller, webhook

- Knative Build Pods:
    - Deployments: controller, webhook

- Custom Resource Definitions:
    - buildtemplates.build.knative.dev
    - builds.build.knative.dev
    - clusterbuildtemplates.build.knative.dev
    - images.caching.internal.knative.dev

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

## Installing the Chart

Please ensure that you have reviewed the [prerequisites](#prerequisites).

To install the chart using helm cli:

Install Knative Build
```bash
$ helm install ./knative/charts/build --name <my-release> [--tls]
```

The command deploys Knative Build on the Kubernetes cluster in the default configuration.  The [configuration](#configuration) section lists the parameters that can be configured during installation.

You can use the command ```helm status <my-release> [--tls]``` to get a summary of the various Kubernetes artifacts that make up your Knative Build deployment.

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
$ kubectl delete -f knative/all-crds.yaml
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Limitations

You must use `knative-build` namespace to install Knative build.

## Documentation

Documentation of the Knative build system can be found on the [Knative Build Docs](https://github.com/knative/build/blob/master/README.md).

To learn more about Knative in general, see the [Overview](https://github.com/knative/docs/blob/master/README.md).

# Support

If you're a developer, operator, or contributor trying to use Knative, the
following resources are available for you:

- [Knative Users](https://groups.google.com/forum/#!forum/knative-users)
- [Knative Developers](https://groups.google.com/forum/#!forum/knative-dev)

For contributors to Knative, we also have [Knative Slack](https://slack.knative.dev).
