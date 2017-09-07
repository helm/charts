# Elasticsearch Helm Chart

This image is using Fabric8's great [kubernetes discovery
plugin](https://github.com/fabric8io/elasticsearch-cloud-kubernetes) for
elasticsearch and their
[image](https://hub.docker.com/r/jetstack/elasticsearch-pet/) as parent.

## Prerequisites Details

* Kubernetes 1.6+
* PV dynamic provisioning support on the underlying infrastructure

## StatefulSets Details
* https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/

## StatefulSets Caveats
* https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#limitations

## Todo

* Implement TLS/Auth/Security
* Smarter upscaling/downscaling
* Solution for memory locking

## Chart Details
This chart will do the following:

* Implemented a dynamically scalable elasticsearch cluster using Kubernetes StatefulSets/Deployments
* Multi-role deployment: master, client and data nodes
* Statefulset Supports scaling down without degrading the cluster

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/elasticsearch
```

## Deleting the Charts

Delete the Helm deployment as normal

```
$ helm delete my-release
```

Deletion of the StatefulSet doesn't cascade to deleting associated PVCs. To delete them:

```
$ kubectl delete pvc -l release=my-release,component=data
```

## Configuration

The following tables lists the configurable parameters of the elasticsearch chart and their default values.

| Parameter                            | Description                             | Default                             |
| ------------------------------------ | --------------------------------------- | ----------------------------------- |
| `image.repository`                   | Container image name                    | `jetstack/elasticsearch-pet`        |
| `image.tag`                          | Container image tag                     | `2.4.0`                             |
| `image.pullPolicy`                   | Container pull policy                   | `Always`                            |
| `cluster.name`                       | Cluster name          			         | `elasticsearch`                     |
| `cluster.config`                     | Additional cluster config appended      | `{}`                                |
| `client.name`                        | Client component name                   | `client`                            |
| `client.replicas`                    | Client node replicas (deployment)       | `2`                                 |
| `client.resources`                   | Client node resources requests & limits | `{} - cpu limit must be an integer` |
| `client.heapSize`                    | Client node heap size                   | `128m`                              |
| `client.serviceType`                 | Client service type                     | `ClusterIP`                         |
| `master.name`                        | Master component name                   | `master`                            |
| `master.replicas`                    | Master node replicas (deployment)       | `2`                                 |
| `master.resources`                   | Master node resources requests & limits | `{} - cpu limit must be an integer` |
| `master.heapSize`                    | Master node heap size                   | `128m`                              |
| `master.name`                        | Data component name                     | `data`                              |
| `data.replicas`                      | Data node replicas (statefulset)        | `3`                                 |
| `data.resources`                     | Data node resources requests & limits   | `{} - cpu limit must be an integer` |
| `data.heapSize`                      | Data node heap size                     | `1536m`                             |
| `data.storage`                       | Data persistent volume size             | `30Gi`                              |
| `data.storageClass`                  | Data persistent volume Class            | `nil`                               |
| `data.terminationGracePeriodSeconds` | Data termination grace period (seconds) | `3600`                              |
| `data.antiAffinity`                  | Data anti-affinity policy               | `soft`                              |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

In terms of Memory resources you should make sure that you follow that equation:

- `${role}HeapSize < ${role}MemoryRequests < ${role}MemoryLimits`

The YAML value of cluster.config is appended to elasticsearch.yml file for additional customization ("script.inline: on" for example to allow inline scripting)

# Deep dive

## Mlocking

This is a limitation in kubernetes right now. There is no way to raise the
limits of lockable memory, so that these memory areas won't be swapped. This
would degrade performance heavily. The issue is tracked in
[kubernetes/#3595](https://github.com/kubernetes/kubernetes/issues/3595).

```
[WARN ][bootstrap] Unable to lock JVM Memory: error=12,reason=Cannot allocate memory
[WARN ][bootstrap] This can result in part of the JVM being swapped out.
[WARN ][bootstrap] Increase RLIMIT_MEMLOCK, soft limit: 65536, hard limit: 65536
```

## Select right storage class for SSD volumes

### GCE + Kubernetes 1.5

Create StorageClass for SSD-PD

```
$ kubectl create -f - <<EOF
kind: StorageClass
apiVersion: extensions/v1beta1
metadata:
  name: ssd
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-ssd
EOF
```
Create cluster with Storage class `ssd` on Kubernetes 1.5+

```
$ helm install incubator/elasticsearch --name my-release --set data.storageClass=ssd,data.storage=100Gi
```
