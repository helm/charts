# kubernetes-dashboard

## TL;DR

```console
helm install incubator/resource-quotas -f values.default.yaml -n resource-quotas-default --namespace default
helm install incubator/resource-quotas -f values.kube-system.yaml -n resource-quotas-kube-system --namespace kube-system
helm install incubator/resource-quotas -f values.your-namespace.yaml -n resource-quotas-your-namespace --namespace your-namespace
```

## Introduction

This Chart bootstraps resource quotas for a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.
The Chart helps Kubernetes administrators to configure resource limits and defaults.

## Warnings

1. Do NOT install the Chart until you read the following documentation:

- https://kubernetes.io/docs/tasks/administer-cluster/reserve-compute-resources/
- https://kubernetes.io/docs/concepts/policy/resource-quotas/
- https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/ and all other topics in the category
- https://kubernetes.io/docs/tasks/administer-cluster/limit-storage-consumption/
- https://docs.openshift.com/container-platform/3.11/dev_guide/compute_resources.html
- https://kubernetes.io/docs/tasks/administer-cluster/guaranteed-scheduling-critical-addon-pods/
- https://github.com/kubernetes/kubernetes/issues/67577
- https://github.com/kubernetes/kubernetes/issues/73628

2. Do NOT install the Chart with the provided default values and examples without reviewing them.

3. Limits can cause invisible problems. For example, if you have a DaemonSet and it will try to start a pod on a node
which doesn't have enough CPU, the pod will not appear in the list of pods. You should carefully monitor your cluster
to detect pods that can't start.

4. Because of [the issue #67577](https://github.com/kubernetes/kubernetes/issues/67577) maybe worth not 
to set CPU limits. In this case comment the following keys in your `values.yaml`:

- `limitrange-container > max > cpu`
- `limitrange-pod > max > cpu`
- `general > limits.cpu`
- `high > limits.cpu`
- `medium > limits.cpu`
- `low > limits.cpu`

5. Because of [the issue #73628](https://github.com/kubernetes/kubernetes/issues/73628) maybe worth not to throttle
NodePorts. In this case set the following keys in your `values.yaml` equal to the value of `services.loadbalancers`
in the same group:

- `general > services.nodeports`
- `high > services.nodeports`
- `medium > services.nodeports`
- `low > services.nodeports`

## Installing the Chart

To have configured quotas for each namespace in the cluster the Chart should be installed several times.
It is recommended to set the release name different for each namespace, for example:

```console
helm install incubator/resource-quotas  -n resource-quotas-default --namespace default
```

The command deploys [`ResourceQuota`](https://kubernetes.io/docs/concepts/policy/resource-quotas/) and 
[`LimitRange`](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/)
objects on the Kubernetes cluster in the default configuration.

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

Unfortunately, Helm does not guarantee that all resources created by this Chart will be removed together with the Chart.
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

The following table lists the configurable parameters of the kubernetes-dashboard Chart and their default values.

| Parameter                           | Description                                                                                                          | Default                                                                    |
|-------------------------------------|----------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------|
| `limitrange-container` | Settings for a LimitRange with the type "Container".                                                                              | request, limit, min, max                                                   |
| `limitrange-pod`       | Settings for a LimitRange with the type "Pod".                                                                                    | min, max                                                                   |
| `limitrange-pvc`       | Settings for a LimitRange with the type "PersistentVolumeClaim".                                                                  | min, max                                                                   |
| `general`              | Settings for the default ResourceQuota which doesn't have scope selectors and will be applied for all resources in the namespace. | see `values.yaml` to get the full predefined list                          |
| `high`                 | Settings for a ResourceQuota which will be applied to all pods with PriorityClass="high".                                         | see `values.yaml` to get the full predefined list                          |
| `medium`               | Settings for a ResourceQuota which will be applied to all pods with PriorityClass="medium".                                       | see `values.yaml` to get the full predefined list                          |
| `low`                  | Settings for a ResourceQuota which will be applied to all pods with PriorityClass="low".                                          | see `values.yaml` to get the full predefined list                          |

Make sure that your cluster supports necessary extentions. For example, to use `ResourceQuota`s for `PriorityClasses`
make sure you have enabled `ResourceQuotaScopeSelectors`:

https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/

You can add your own values to the each specific list if your cluster supports them.

> **Warning**: Do NOT install the Chart using the default [values.yaml](values.yaml).

Create a YAML file that specifies the values for the above parameters can be provided while installing the Chart. For example,
        
```console
helm install incubator/resource-quotas --name my-release -f values.yaml
```

Alternatively, you can specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install incubator/resource-quotas --name my-release \
  --set=namespaces.default.limitrange-container.request.cpu="100m",namespaces.default.general.pods=100
```

## Getting limits and ranges together

```console
kubectl describe namespace kube-system
```

## Getting installed quotas

```console
kubectl describe quota kube-system-general --namespace kube-system

Name:                         kube-system-general
Namespace:                    kube-system
Resource                      Used    Hard
--------                      ----    ----
count/configmaps              7       1k
count/cronjobs.batch          0       5
count/deployments.apps        5       20
count/ingresses.extensions    0       0
count/jobs.batch              0       20
count/persistentvolumeclaims  0       0
count/replicasets.apps        12      60
count/replicationcontrollers  0       0
count/secrets                 39      1k
count/services                4       10
count/statefulsets.apps       0       0
limits.cpu                    1200m   1
limits.ephemeral-storage      2816Mi  4Gi
limits.memory                 1876Mi  4Gi
pods                          12      200
requests.cpu                  700m    1
requests.ephemeral-storage    484Mi   4Gi
requests.memory               560Mi   4Gi
requests.storage              0       0
services.loadbalancers        1       5
services.nodeports            1       0
```

## Getting installed limit ranges

```console
kubectl describe limitrange kube-system-container kube-system-pod kube-system-pvc --namespace kube-system

Name:       kube-system-container
Namespace:  kube-system
Type        Resource           Min    Max   Default Request  Default Limit  Max Limit/Request Ratio
----        --------           ---    ---   ---------------  -------------  -----------------------
Container   memory             32Mi   1Gi   32Mi             1Gi            -
Container   cpu                10m    500m  10m              300m           -
Container   ephemeral-storage  100Mi  1Gi   100Mi            1Gi            -


Name:       kube-system-pod
Namespace:  kube-system
Type        Resource           Min    Max   Default Request  Default Limit  Max Limit/Request Ratio
----        --------           ---    ---   ---------------  -------------  -----------------------
Pod         ephemeral-storage  100Mi  5Gi   -                -              -
Pod         memory             32Mi   5Gi   -                -              -
Pod         cpu                10m    500m  -                -              -


Name:                  kube-system-pvc
Namespace:             kube-system
Type                   Resource  Min  Max  Default Request  Default Limit  Max Limit/Request Ratio
----                   --------  ---  ---  ---------------  -------------  -----------------------
PersistentVolumeClaim  storage   0    0    -                -              -
```

