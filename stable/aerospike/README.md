# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Aerospike Helm Chart

This is an implementation of Aerospike StatefulSet found here:
* <https://github.com/aerospike/aerospike-kubernetes>

----------------------------------------
# Deprecation Warning
*As part of the [deprecation timeline](https://github.com/helm/charts/#deprecation-timeline), another repository has taken over the chart [here](hhttps://github.com/aerospike/aerospike-kubernetes/tree/master/helm)*

Note: this is the official repository.

Please make PRs / Issues here from now on.

----------------------------------------

## Pre Requisites
* Kubernetes 1.9+
* PV support on underlying infrastructure (only if you are provisioning persistent volume).
* Requires at least `v2.5.0` version of helm to support

## StatefulSet Details
* <https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/>

## StatefulSet Caveats
* <https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#limitations>

## Chart Details
This chart will do the following:
* Implement a dynamically scalable Aerospike cluster using Kubernetes StatefulSets

### Installing the Chart
To install the chart with the release name `my-aerospike` using a dedicated namespace(recommended):

```sh
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm install --name my-aerospike --namespace aerospike stable/aerospike
```

The chart can be customized using the following configurable parameters:

| Parameter                       | Description                                                     | Default                      |
| ------------------------------- | ----------------------------------------------------------------| -----------------------------|
| `image.repository`              | Aerospike Container image name                                  | `aerospike/aerospike-server` |
| `image.tag`                     | Aerospike Container image tag                                   | `4.5.0.5`                    |
| `image.pullPolicy`              | Aerospike Container pull policy                                 | `Always`                     |
| `image.pullSecret`              | Aerospike Pod pull secret                                       | ``                     |
| `replicaCount`                  | Aerospike Brokers                                               | `1`                          |
| `command`                       | Custom command (Docker Entrypoint)                              | `[]`                         |
| `args`                          | Custom args (Docker Cmd)                                        | `[]`                         |
| `labels`                        | Map of labels to add to the statefulset                         | `{}`                         |
| `annotations`                   | Map of annotations to add to the statefulset                    | `{}`                         |
| `tolerations`                   | List of node taints to tolerate                                 | `[]`                         |
| `persistentVolume`              | Config of persistent volumes for storage-engine                 | `{}`                         |
| `confFile`                      | Config filename. This file should be included in the chart path. If the config is updated, the statefulset will be redeployed with the new config | `aerospike.conf`             |
| `resources`                     | Resource requests and limits                                    | `{}`                         |
| `nodeSelector`                  | Labels for pod assignment                                       | `{}`                         |
| `terminationGracePeriodSeconds` | Wait time before forcefully terminating container               | `30`                         |
| `service.type`                  | Kubernetes Service type                                         | `ClusterIP`                  |
| `service.annotations`           | Kubernetes service annotations, evaluated as a template         | `{}`                         |
| `service.loadBalancerIP`        | Static IP Address to use for LoadBalancer service type          | `nil`                        |
| `service.clusterIP`             | Static clusterIP or None for headless services                  | `None`                       |
| `service.nodePort.enabled`       | Enable NodePort to make aerospike cluster available outside the Kubernetes cluster         | `false`                         |
| `service.nodePort.port`       | The NodePort port to expose         | `{}`                         |
| `metrics.enabled`       | Enabled the metric sidecar that scrapes Aerospike at `localhost:3000`. Needs to be provided a sidecar image/repo. [This]() is a good place to start: https://github.com/alicebob/asprom         | `false`                         |
| `metrics.image.repository`       | Metric sidecar image repository         | `{}`                         |
| `metrics.image.tag`       | Metric sidecar image tag         | `{}`                         |
| `metrics.serviceMonitor.enabled`       | Enable metrics service monitor. For more info, check [Prometheus Operator]([https://github.com/coreos/prometheus-operator](https://github.com/coreos/prometheus-operator))         | `false`                         |
| `metrics.serviceMonitor.targetLabels`       | Add these additional labels from your service to the service monitor.  For more info, check [Prometheus Operator]([https://github.com/coreos/prometheus-operator](https://github.com/coreos/prometheus-operator))         | `{}`                         |

Specify parameters using `--set key=value[,key=value]` argument to `helm install`

Alternatively a YAML file that specifies the values for the parameters can be provided like this:

```sh
helm install --name my-aerospike -f values.yaml stable/aerospike
```

### Conf files for Aerospike
There is one conf file added to each Aerospike release. This conf file can be replaced with a custom file and updating the `confFile` value.

If you modify the `aerospike.conf` (and you use more than 1 replica), you want to add the `#REPLACE_THIS_LINE_WITH_MESH_CONFIG` comment to the config file (see the default conf file). This will update your mesh to connect each replica.
