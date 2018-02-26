# kanister-operator

[kanister-operator](https://github.com/kanisterio/kanister) is a Kubernetes operator for Kanister framework.

Kanister is a framework that enables application-level data management on Kubernetes. It allows domain experts to capture application specific data management tasks via blueprints, which can be easily shared and extended. The framework takes care of the tedious details surrounding execution on Kubernetes and presents a homogeneous operational experience across applications at scale.

## TL;DR;

```console
$ helm install stable/kanister-operator
```

## Introduction

This chart bootstraps a kanister-operator deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/kanister-operator
```

The command deploys kanister-operator on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the nginx-ingress chart and their default values.

Parameter | Description | Default
--- | --- | ---
`rbac.create` | all required roles and SA will be created | `true`
`serviceAccount.create`| specify if SA will be created | `true`
`serviceAccount.name`| porvided service account name will be used | `None`
`image.repository` | controller container image repository | `kanisterio/controller`
`image.tag` | controller container image tag | `v0.2.0`
`image.pullPolicy` | controller container image pull policy | `IfNotPresent`
`resources` | k8s pod resorces | `None`

Specify each parameter you'd like to override using a YAML file as described above in the [installation](#Installing the Chart) section.

You can also specify any non-array parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/kanister-operator --name my-release \
    --set rbac.create=false
```
