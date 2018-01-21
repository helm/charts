# Redis

[Redis](http://redis.io/) is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

[Redis Cluster](https://redis.io/topics/cluster-tutorial) is an active-passive cluster implementation that consists of master and slave nodes. The cluster uses hash partitioning to split the key space into 16,384 key slots, with each master responsible for a subset of those slots. Each slave replicates a specific master and can be reassigned to replicate another master or be elected to a master node as needed. Replication is completely asynchronous and does not block the master or the slave. Masters receive all read and write requests for their slots; slaves never have communication with clients.


# Introduction

This chart bootstraps a [Redis](https://github.com/ofaraggi/Helm-Charts/rediscluster) stateFul set on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV support in the underlying infrastructure

## Installing the Chart

```bash
$ helm install . --name=redisc --debug
```
The command deploys Redis on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `redisc` deployment:

```bash
$ helm delete redisc --purge
```
The command removes all the Kubernetes components associated with the chart and deletes the release except for PVs and PVCs

## Configuration

The following tables lists the configurable parameters of the Redis chart and their default values.

|           Parameter           |                Description                       |           Default            |
|-------------------------------|--------------------------------------------------|------------------------------|
| `replicaCount`                | Number of redis replicas                         | `6`                          |
| `registry`                    | Custom registry address   (must end with a \)    | `empty`                      |
| `image.repository`            | custom repository (must end with a \)            | `empty`                      |
| `image.tag`                   | Image to use                                     | `redis:4.0.6`                |
| `image.pullPolicy`            | Logic on image replacement when pulling          | `Always`                     |
| `service.type`                | The type of kubernetes service                   | `NodePort`                   |
| `service.client.externalPort` | The external service port for client communication| `6379`                      |
| `service.client.internalPort` | The internal service port for client communication| `6379`                      |
| `service.gossip.externalPort` | The external service port for cluster communication| `16379`                    |
| `service.gossip.internalPort` | The internal service port for cluster communication| `16379`                    |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name redisc -f values.yaml .
```
## Persistence

This stateFul set stores the Redis data and configurations at the `/data` path of the container.

By default, the chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using volumeClaimTemplates.

## TBD

 - [ ] Export config map to values file
 - [ ] Add complete map of values file to readme file (probes, etc')
 - [ ] Check pv usage on k8s cluster, currently tested only on minikube
 - [ ] Add prometheus exporter to the pod.
 - [ ] Cluster creation automation.
 - [ ] Cluster scaling automation.
 - [ ] Test [persistance](https://redis.io/topics/persistence) , currently AOF & RDB
 - [ ] Set name space from values.yaml

## Redis Cluster comments

* Redis Cluster does not support multiple databases like the stand alone version of Redis. There is just database 0 and the SELECT command is not allowed.
* You don't need additional fail over handling when using Redis Cluster and you should definitely not point Sentinel instances at any of the Cluster nodes. You also want to use a smart client library that knows about Redis Cluster, so it can automatically redirect you to the right nodes when accessing data.
* PubSub channels are not hashed the way normal keys are, but every message is automatically published to every node. There is some discussion going on about this and it might be solved in the future, but until then there is no good way of combining PubSub with Redis Cluster if you have a lot of messages going through

## [Cluster Initialization](https://redis.io/topics/cluster-tutorial#creating-and-using-a-redis-cluster) 
* The [Home directory](https://github.com/ofaraggi/rediscluster) contains a docker file that can be used in order to build an image that contains the redis-trib script for cluster set up or download the [docker image](https://hub.docker.com/r/ofaraggi/rediscluster/).
  The .utils/init.sh script can be run inside one of the containers for the same purpose. When using this method all commands must be run with `/bin/bash -l -c "${command}"`

* Must be run manually in order to set up the cluster


### This will spin up 6 `redisc` pods one by one. After all pods are in a running state, you can initialize the cluster using the `redis-trib` command in any of the pods. After the initialization, you will end up with 3 master and 3 slave nodes.

```bash
kubectl exec -it redisc-0 -- /bin/bash -l -c "redis-trib create --replicas 1 \
$(kubectl get pods -l app=redisc -o jsonpath='{range.items[*]}{.status.podIP}:6379 ')"
```
### Add new nodes to the cluster

```bash
kubectl exec redisc-0 -- /bin/bash -l -c "redis-trib add-node \
$(kubectl get pod redisc-6 -o jsonpath='{.status.podIP}'):6379 \
$(kubectl get pod redisc-0 -o jsonpath='{.status.podIP}'):6379"
```

### Resharding must be preformed after addition of a master node.

```bash
kubectl exec -it redisc-0 -- /bin/bash -l -c "redis-trib reshard --from <node-id> --to <node-id> --slots <number of slots> --yes <host>:<port>"
```


## Referenced 

 - https://github.com/bitnami/bitnami-docker-redis
 - https://github.com/sanderploegsma/redis-cluster
