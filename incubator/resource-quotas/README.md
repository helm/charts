# kubernetes-dashboard

## TL;DR

```console
helm install incubator/resource-quotas -f myvalues.yaml
```

## Introduction

This chart bootstraps resource quotas for a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.
The chart helps Kubernetes administrators to configure resource limits and defaults.

## Warnings

1. Do NOT install the chart until you read the following documentation:

- https://kubernetes.io/docs/tasks/administer-cluster/reserve-compute-resources/
- https://kubernetes.io/docs/concepts/policy/resource-quotas/
- https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/ and all other topics in the category
- https://kubernetes.io/docs/tasks/administer-cluster/limit-storage-consumption/
- https://docs.openshift.com/container-platform/3.11/dev_guide/compute_resources.html

2. Do NOT install the chart with default values.

## Installing the Chart

To install the chart with the release name `my-release`:
Unlike many other charts this one should be installed without passing the `namespace` argument because it works
with several namespaces at once.

```console
helm install incubator/resource-quotas --name my-release
```

The command deploys ResourceQuota and LimitRange objects on the Kubernetes cluster in the default configuration.
The [configuration](#configuration) section lists the parameters that can be configured during installation.

Depending on the values you have passed to helm, you will get an output with the list of installed resources:

```console
RESOURCES:
==> v1/ResourceQuota
NAME
default-general
kube-system-general
your-namespace-general

==> v1/LimitRange
NAME
default-container
default-pod
default-pvc
kube-system-container
kube-system-pod
kube-system-pvc
your-namespace-container
your-namespace-pod
your-namespace-pvc
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release --purge
```

Unfortunately, Helm does not guarantee that all resources created by this chart will be removed together with the chart.
Delete artifacts manually using the commands:

```console
kubectl get limitranges --all-namespaces
kubectl delete limitranges -n default default-container default-pod default-pvc
kubectl delete limitranges -n kube-system kube-system-container kube-system-pod kube-system-pvc
kubectl delete limitranges -n your-namespace your-namespace-container your-namespace-pod your-namespace-pvc

kubectl get resourcequotas -n default
kubectl get resourcequotas -n kube-system
kubectl get resourcequotas -n your-namespace
```

## Configuration

The following table lists the configurable parameters of the kubernetes-dashboard chart and their default values.

| Parameter                           | Description                                                                                                                       | Default                                                                    |
|-------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------|
| `namespaces.*`                      | List of namespaces to generate Kubernetes resources.                                                                              | default, kube-system                                                       |
| `namespaces.*.limitrange-container` | Settings for a LimitRange with the type "Container".                                                                              | request, limit, min, max                                                   |
| `namespaces.*.limitrange-pod`       | Settings for a LimitRange with the type "Pod".                                                                                    | min, max                                                                   |
| `namespaces.*.limitrange-pvc`       | Settings for a LimitRange with the type "PersistentVolumeClaim".                                                                  | min, max                                                                   |
| `namespaces.*.general`              | Settings for the default ResourceQuota which doesn't have scope selectors and will be applied for all resources in the namespace. | see `values.yaml` to get the full predefined list                          |
| `namespaces.*.high`                 | Settings for a ResourceQuota which will be applied to all pods with PriorityClass="high".                                         | see `values.yaml` to get the full predefined list                          |
| `namespaces.*.medium`               | Settings for a ResourceQuota which will be applied to all pods with PriorityClass="medium".                                       | see `values.yaml` to get the full predefined list                          |
| `namespaces.*.low`                  | Settings for a ResourceQuota which will be applied to all pods with PriorityClass="low".                                          | see `values.yaml` to get the full predefined list                          |

Make sure that your cluster supports necessary extentions. For example, to use `ResourceQuota`s for `PriorityClasses`
make sure you have enabled `ResourceQuotaScopeSelectors`:

https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/

You can add your own values to the each specific list if your cluster supports them.

> **Warning**: Do NOT install the chart using the default [values.yaml](values.yaml).

Create a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,
        
```console
helm install incubator/resource-quotas --name my-release -f values.yaml
```

Alternatively, you can specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install incubator/resource-quotas --name my-release \
  --set=namespaces.default.limitrange-container.request.cpu="100m",namespaces.default.general.pods=100
```

## Getting installed quotas

```console
kubectl describe quota compute-resources --namespace kube-system
```
