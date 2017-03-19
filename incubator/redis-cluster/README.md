## Reliable, Multi-Node Redis on Kubernetes

The following document describes the deployment of a reliable, multi-node Redis on Kubernetes.  It deploys a master with replicated slaves, as well as replicated redis sentinels which are use for health checking and failover.

## Introduction

This chart bootstraps a Redis cluster deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. This work is largely based upon deploying a Redis cluster documented in this [tutorial](https://github.com/kubernetes/kubernetes/tree/master/examples/storage/redis).

## Prerequisites

- Kubernetes 1.5+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

This example assumes that you have a Kubernetes cluster installed and running, and that you have installed the ```kubectl``` command line tool somewhere in your path.  Please see the [getting started](../../../docs/getting-started-guides/) for installation instructions for your platform.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/redis-cluster
```

The command deploys a Redis cluster on the Kubernetes cluster using the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

### Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

It should be noted, that the installation of the chart installs a persistent volume claim per Redis nodes deployed.  These volumes are not deleted by the `helm delete` command.  They can be managed using the `kubectl delete` command for Persistent Volume Claim resources.

## Configuration

The following tables lists the configurable parameters of the Redis chart and their default values.

| Parameter                  | Description                                | Default                             |
| -----------------------    | ------------------------------------------ | ----------------------------------- |
| `image`                    | `redis` image.                             | gcr.io/google_containers/redis:v1   |
| `imagePullPolicy`          | Image pull policy                          | IfNotPresent                        |
| `slaveReplicaCount`        | Number of `redis` slave instances to run   | 3                                   |
| `sentinelReplicaCount`     | Number of `redis` sentinel instances to run| 2                                   |
| `persistence.enabled`      | Create a volume to store data              | true                                |
| `persistence.size`         | Size of persistent volume claim            | 1Gi                                 |
| `persistence.storageClass` | Type of persistent volume claim            | default                             |
| `persistence.accessMode`   | ReadWriteOnce or ReadOnly                  | ReadWriteOnce                       |
| `resources`                | CPU/Memory resource requests/limits        | Memory: `100Mi`, CPU: `100m`        |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

## Persistence

The deployment of the Redis cluster can use persistent storage.  A PersistentVolumeClaim is created and mounted in the directory `/redis-master-data` on a per Redis instance.

By default, the chart will uses the default StorageClass for the provider where Kubernetes is running.  If `default` isn't supported, or if one wants to use a specifc StorageClass, for instance premium storage on Azure, one would need to define the appropriate StorageClass and update the values.yaml file or use the `--set key=persistence.storageClass=<value>` flag to specify such.  To specify a Premium Storage disk (SSD) on Azure, the yaml file for the StorageClass definition would resemble:

```
# https://kubernetes.io/docs/user-guide/persistent-volumes/#azure-disk
apiVersion: storage.k8s.io/v1beta1
kind: StorageClass
metadata:
  name: fast
  annotations:
    storageclass.beta.kubernetes.io/is-default-class: "true"
provisioner: kubernetes.io/azure-disk
parameters:
  skuName: Premium_LRS
  location: westus
```

In order to disable this functionality you can change the values.yaml to disable persistence and use an emptyDir instead.

## How it works

### Turning up an initial master/sentinel pod and sentinel service.

A [_Pod_](../../../docs/user-guide/pods.md) is one or more containers that _must_ be scheduled onto the same host.  All containers in a pod share a network namespace, and may optionally share mounted volumes.

We will use the shared network namespace to bootstrap our Redis cluster.  In particular, the very first sentinel needs to know how to find the master (subsequent sentinels just ask the first sentinel).  Because all containers in a Pod share a network namespace, the sentinel can simply look at ```$(hostname -i):6379```.

In Kubernetes a [_Service_](../../../docs/user-guide/services.md) describes a set of Pods that perform the same task.  For example, the set of nodes in a Cassandra cluster, or even the single node we created above.  An important use for a Service is to create a load balancer which distributes traffic across members of the set.  But a _Service_ can also be used as a standing query which makes a dynamically changing set of Pods (or the single Pod we've already created) available via the Kubernetes API.

In Redis, we will use a Kubernetes Service to provide a discoverable endpoints for the Redis sentinels in the cluster.  From the sentinels Redis clients can find the master, and then the slaves and other relevant info for the cluster.  This enables new members to join the cluster when failures occur.


### Turning up replicated redis servers

So far, what we have done is pretty manual, and not very fault-tolerant.  If the ```redis-master``` pod that we previously created is destroyed for some reason (e.g. a machine dying) our Redis service goes away with it.

In Kubernetes a [_Replication Controller_](../../../docs/user-guide/replication-controller.md) is responsible for replicating sets of identical pods.  Like a _Service_ it has a selector query which identifies the members of it's set.  Unlike a _Service_ it also has a desired number of replicas, and it will create or delete _Pods_ to ensure that the number of _Pods_ matches up with it's desired state.

Let's create two Replication Controllers with 3 replica each for sentinel and redis servers.

The bulk of the controller configs are actually identical to the redis-master pod definition above.  It forms the template or "cookie cutter" that defines what it means to be a member of this set.

The redis-sentinel Relication Controller will "adopt" the existing master/sentinel pod and create 2 more sentinel replicas. The redis Replication Controller will create 3 replicas of redis server.

Unlike our original redis-master pod, these pods exist independently, and they use the ```redis-sentinel-service``` that we defined above to discover and join the cluster.

After the replicas join the cluster, the redis cluster will have 1 master + 3 slaves + 3 sentinels.

### How client use the redis cluster

To access the redis cluster, the client can get the redis master IP address (the port number is 6379) by below command:

```sh
master=$(redis-cli -h ${REDIS_SENTINEL_SERVICE_HOST} -p ${REDIS_SENTINEL_SERVICE_PORT} --csv SENTINEL get-master-addr-by-name mymaster | tr ',' ' ' | cut -d' ' -f1)
```

### How fault-tolerant works

As a reliable redis cluster, it can automatically recover when any of the pod is down. Now let's take a close look at how this works.

If one of the redis server pod is down:

  1. The redis replication controller notices that it's desired state is 3 replicas, but there are currently only 2 replicas, and so it creates a new redis server to bring the replica count back up to 3
  2. The newly created redis server pod can use the ```redis-sentinel-service``` to get master information and join the cluster as slave.

If one of the sentinel pod is down:

  1. The redis-sentinel replication controller notices that it's desired state is 3 replicas, but there are currently only 2 replicas, and so it creates a new redis sentinel to bring the replica count back up to 3
  2. The newly created sentinel pod can use the ```redis-sentinel-service``` to get master information and join the cluster as sentinel.

If the master/sentinel pod is down:

  1. The redis-sentinel replication controller notices that it's desired state is 3 replicas, but there are currently only 2 replicas, and so it creates a new sentinel to bring the replica count back up to 3
  2. The newly created sentinel pod can use the ```redis-sentinel-service``` to get master information. But since the master is also down, it cannot connect to the master. In this case, the new sentinel will enter a loop to repeatedly get the master information and try to connect...
  3. The existing redis sentinels themselves, realize that the master has disappeared from the cluster, and begin the election procedure for selecting a new master.  They perform this election and selection, and choose one of the existing redis server replicas to be the new master.
  4. Once the newly master is selected, the new created sentinel pod can get it's information and joins the cluster as a sentinel.

## Credit

Credit to https://github.com/kubernetes/kubernetes/tree/master/examples/storage/redis. This is an implementation of that work as a Helm Chart.

