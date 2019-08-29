# Cluster overprovisioner

This chart provide a buffer for cluster autoscaling to allow overprovisioning of cluster nodes. This is desired when you have work loads that need to scale up quickly without waiting for the new cluster nodes to be created and join the cluster.

It works but creating a deployment that creates pods of a lower than default `PriorityClass`. These pods request resources from the cluster but don't actually consume any resources. These pods are then evicted allowing other normal pods are created while also triggering a scale-up by the [cluster-autoscaler](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler).

This approach is the [current recommended method to achieve overprovisioning](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md#how-can-i-configure-overprovisioning-with-cluster-autoscaler).

## Prerequisites

- Kubernetes 1.11+ with Beta APIs enabled or 1.8-1.10 with alpha APIs enabled
- [Pod priority and preemption](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md#how-can-i-configure-overprovisioning-with-cluster-autoscaler) enabled in your cluster.  Pod priority and preemption is enabled by default in Kubernetes >= 1.11.
- `cluster-autoscaler` installed in your cluster with [`--expendable-pods-priority-cutoff=-10` ](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md#how-does-cluster-autoscaler-work-with-pod-priority-and-preemption).  Priority cutoff has a default of `-10` in `cluster-autoscaler` >= 1.12.

## Installing the Chart

To install the chart with the release name `my-release` and default configuration:

```shell
$ helm install --name my-release stable/cluster-overprovisioner
```

## Uninstalling the Chart

To delete the chart:

```shell
$ helm delete my-release
```

## Configuration

Some thought or experimentation is required to set `deployment.resources` and `deployment.replicaCount` correctly. Aspects such as cluster size, costs and size of buffer required should be considered.

The following table lists the configurable parameters for this chart and their default values.

| Parameter                                      | Description                                       | Default           |
| -----------------------------------------------|---------------------------------------------------|-------------------|
| `priorityClassOverprovision.name`              | Name of the overprovision priorityClass           | `overprovision`   |
| `priorityClassOverprovision.value`             | Priority value of the overprovision priorityClass | `-1`              |
| `priorityClassDefault.enabled`                 | If true, enable default priorityClass             | `true`            |
| `priorityClassDefault.name`                    | Name of the default priorityClass                 | `default`         |
| `priorityClassDefault.value`                   | Priority value of the default priorityClass       | `0`               |
| `replicaCount`                                 | Number of replicas                                | `1`               |
| `resources`                                    | Resources for the overprovision pods              | `{}`              |
| `image.repository`                             | Image repository                                  | `k8s.gcr.io/pause`|
| `image.tag`                                    | Image tag                                         | `3.1`             |
| `image.pullPolicy`                             | Container pull policy                             | `IfNotPresent`    |
| `affinity`                                     | Map of node/pod affinities                        | `{}`              |
| `nodeSelector`                                 | Node labels for pod assignment                    | `{}`              |
| `annotations`                                  | Optional deployment annotations                   | `{}`              |
| `fullnameOverride`                             | Override the fullname of the chart                | `nil`             |
| `nameOverride`                                 | Override the name of the chart                    | `nil`             |
| `tolerations`                                  | Optional deployment tolerations                   | `[]`              |
| `additionalDeployments`                        | Define optional additional deployments            | `[]`              |
| `additionalDeployments[].name`                 | Name for additional deployments                   | ``                |
| `additionalDeployments[].replicaCount`         | Number of replicas                                | `1`               |
| `additionalDeployments[].resources`            | Resources for the overprovision pods              | `{}`              |
| `additionalDeployments[].affinity`             | Map of node/pod affinities                        | `{}`              |
| `additionalDeployments[].nodeSelector`         | Node labels for pod assignment                    | `{}`              |
| `additionalDeployments[].tolerations`          | Optional deployment tolerations                   | `[]`              |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install` or provide a YAML file containing the values for the above parameters:

```shell
$ helm install --name my-release stable/cluster-overprovisioner --values values.yaml
```
