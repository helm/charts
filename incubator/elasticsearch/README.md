# Elasticsearch Helm Chart

This image is using Fabric8's great [kubernetes discovery
plugin](https://github.com/fabric8io/elasticsearch-cloud-kubernetes) for
elasticsearch and their
[image](https://hub.docker.com/r/fabric8/elasticsearch-k8s/) as parent.

## Prerequisites Details

* Kubernetes 1.3 with alpha APIs enabled
* PV dynamic provisioning support on the underlying infrastructure

## PetSet Details
* http://kubernetes.io/docs/user-guide/petset/

## PetSet Caveats
* http://kubernetes.io/docs/user-guide/petset/#alpha-limitations

## Todo

* Implement TLS/Auth/Security
* Smarter upscaling/downscaling
* Solution for memory locking

## Chart Details
This chart will do the following:

* Implemented a dynamically scalable elasticsearch cluster using Kubernetes PetSets/Deployments
* Multi-role deployment: master, client and data nodes
* PetSet Supports scaling down without degrading the cluster 

## Get this chart

```bash
$ git clone https://github.com/kubernetes/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release charts/incubator/elasticsearch
```

## Deleting the Charts

Deletion of the PetSet doesn't cascade to deleting associated Pods and PVCs. To delete them:

```
$ kubectl delete pods -l release=my-release,type=data
$ kubectl delete pvcs -l release=my-release,type=data

```

## Configuration

The following tables lists the configurable parameters of the elasticsearch chart and their default values.

|         Parameter         |           Description             |                         Default                          |
|---------------------------|-----------------------------------|----------------------------------------------------------|
| `Image`                   | Container image name              | `jetstack/elasticsearch-pet`                             |
| `ImageTag`                | Container image tag               | `2.3.4`                                                  |
| `ImagePullPolicy`         | Container pull policy             | `Always`                                                 |
| `ClientReplicas`          | Client node replicas (deployment) | `2`                                                      |
| `ClientCpuRequests`       | Client node requested cpu         | `25m`                                                    |
| `ClientMemoryRequests`    | Client node requested memory      | `256Mi`                                                  |
| `ClientCpuLimits`         | Client node requested cpu         | `100m`                                                   |
| `ClientMemoryLimits`      | Client node requested memory      | `512Mi`                                                  |
| `ClientHeapSize`          | Client node heap size             | `128m`                                                   |
| `MasterReplicas`          | Master node replicas (deployment) | `2`                                                      |
| `MasterCpuRequests`       | Master node requested cpu         | `25m`                                                    |
| `MasterMemoryRequests`    | Master node requested memory      | `256Mi`                                                  |
| `MasterCpuLimits`         | Master node requested cpu         | `100m`                                                   |
| `MasterMemoryLimits`      | Master node requested memory      | `512Mi`                                                  |
| `MasterHeapSize`          | Master node heap size             | `128m`                                                   |
| `DataReplicas`            | Data node replicas (petset)       | `3`                                                      |
| `DataCpuRequests`         | Data node requested cpu           | `250m`                                                   |
| `DataMemoryRequests`      | Data node requested memory        | `2Gi`                                                    |
| `DataCpuLimits`           | Data node requested cpu           | `1`                                                      |
| `DataMemoryLimits`        | Data node requested memory        | `4Gi`                                                    |
| `DataHeapSize`            | Data node heap size               | `1536m`                                                  |
| `DataStorage`             | Data persistent volume size       | `30Gi`                                                   |
| `DataStorageClass`        | Data persistent volume Class      | `anything`                                               |
| `DataStorageClassVersion` | Version of StorageClass           | `alpha`                                                  |
| `Component`               | Selector Key                      | `elasticsearch`                                          |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

In terms of Memory resources you should make sure that you follow that equation:

- `${role}HeapSize < ${role}MemoryRequests < ${role}MemoryLimits`

# Deep dive

## Mlocking

This is a limitation in kubernetes right now. There is no way to raise the
limits of lockable memory, so that these memory areas won't be swapped. This
would degrade performance heaviliy. The issue is tracked in
[kubernetes/#3595](https://github.com/kubernetes/kubernetes/issues/3595).

```
[WARN ][bootstrap] Unable to lock JVM Memory: error=12,reason=Cannot allocate memory
[WARN ][bootstrap] This can result in part of the JVM being swapped out.
[WARN ][bootstrap] Increase RLIMIT_MEMLOCK, soft limit: 65536, hard limit: 65536
```

## Select right storage class for SSD volumes

### GCE + Kubernetes 1.4

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
Create cluster with Storage class `ssd` on Kubernetes 1.4+

```
$ helm install . --name my-release --set DataStorageClass=ssd,DataStorageClassVersion=beta

```
