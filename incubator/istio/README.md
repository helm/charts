# Istio

[Istio](https://istio.io/), Istio is an open platform that provides a uniform way to connect, manage, and secure microservices. Istio supports managing traffic flows between microservices, enforcing access policies, and aggregating telemetry data, all without requiring changes to the microservice code.

## TL;DR;

> **Note**: Istio pilot currently looks for hardcoded configmap of name "istio" in the installed namespace which means that you can only install the chart once per namespace.

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/istio
```

## Introduction

This chart bootstraps a [Istio](https://istio.io/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.5+
- istioctl

### istioctl installation steps

Run
```console
curl -L https://git.io/getIstio | sh -
```
to download and extract the latest release automatically (on MacOS and Ubuntu), the `istioctl` client will be added to your PATH by the above shell command.

## RBAC
By default the chart is installed without associated RBAC roles and rolebindings. If you would like to install the provided roles and rolebindings please do the following:

```
$ helm install incubator/istio --set rbac.install=true
```

This will install the associated RBAC roles and rolebindings using beta annotations.

To determine if your cluster supports this running the following:

```console
$ kubectl api-versions | grep rbac
```

You also need to have the following parameter on the api server. See the following document for how to enable [RBAC](https://kubernetes.io/docs/admin/authorization/rbac/)

```
--authorization-mode=RBAC
```

If the output contains "beta" or both "alpha" and "beta" you can proceed with normal installation.

### Changing RBAC manifest apiVersion

By default the RBAC resources are generated with the "v1beta1" apiVersion. To use "v1alpha1" do the following:

```console
$ helm install --name my-release incubator/istio --set rbac.install=true,rbac.apiVersion=v1alpha1
```

If it does not. Follow the steps below to disable.

### Disable RBAC role/rolebinding creation

If you don't want the RBAC roles and bindings to be created by the installation of this chart simply install the default chart.

```console
$ helm install --name my-release incubator/istio
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/istio
```

The command deploys Istio on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Istio chart and their default values.

> **Tip**: You can use the default [values.yaml](values.yaml)

Parameter | Description | Default
--------- | ----------- | -------
 |  |  |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/istio --name my-release \
    --set auth.enabled=flase
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install incubator/istio --name my-release -f values.yaml
```

## Custom ConfigMap

When creating a new chart with this chart as a dependency, customConfigMap can be used to override the default config map provided. To use, set the value to true and provide the file `templates/configmap.yaml` for your use case. If you start by copying `configmap.yaml` from this chart and want to access values from this chart you must change all references from `.Values` to `.Values.istio`.

```
pilot:
  customConfigMap: true
```

### Addons
Istio ships with several preconfigured addons
* Grafana
* Prometheus
* ServiceGraph
* Zipkin

These addons can be selectively installed by setting `addons.<addon-name>.enabled=false` in values.yaml or by using the `--set` command
