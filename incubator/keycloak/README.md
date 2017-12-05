# Keycloak

[Keycloak](http://www.keycloak.org/) is an open source identity and access management for modern applications and services.

## TL;DR;

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/keycloak
```

## Introduction

This chart bootstraps a [Keycloak](http://www.keycloak.org/) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites Details

* PV support on underlying infrastructure (if persistence is required)

## Installing the Chart

To install the chart with the release name `keycloak` into the namespace keycloak-system:

```console
$ helm install --name keycloak incubator/keycloak --namespace keycloak-system
```

## Uninstalling the Chart

To uninstall/delete the `keycloak` deployment:

```console
$ helm delete keycloak
```

## Chart Details
This chart will provision a fully functional and fully featured Keycloak installation.
For more information on Keycloak and its capabilities, see it's [documentation](http://www.keycloak.org/documentation.html).

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name keycloak -f values.yaml incubator/keycloak
```

> **Tip**: You can use the default [values.yaml](values.yaml)
