# Knative

This chart installs knative components(Build, Serving and Eventing).
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.


## Introduction

This chart bootstraps a [Knative](https://github.com/knative/) components deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.10+


### knative installation requirement

Run
```console
helm init --service-account tiller --canary-image
```
to init your cluster with helm package manager using using the canary image.

## RBAC
By default the chart is installed with associated RBAC roles and rolebindings.

## Installing the Chart

To install the chart with the release name `knative` into your current namespace:

```console
$ helm install --name knative incubator/knative
```


The command deploys Knative on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `knative` deployment:

```console
$ helm delete --purge knative
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
