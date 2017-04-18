# Zookeeper Helm Chart

 This helm chart provides an implementation of the ZooKeeper 
 [StatefulSet](http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/) found in Kubernetes Contrib 
 [Zookeeper StatefulSet](https://github.com/kubernetes/contrib/tree/master/statefulset/zookeeper).
  
## Prerequisites
* Kubernetes 1.5 
* If you use spreading, the cluster will require alpha features to be enabled.
* PersistentVolume support on the underlying infrastructure
* A dynamic provisioner for the PersistentVolumes
* A familiarity with [Apache ZooKeeper 3.4.x](https://zookeeper.apache.org/doc/current/)

## Chart Components
This chart will do the following:

* Create a fixed size ZooKeeper ensemble using a 
[StatefulSet](http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/).
* Create a [ConfigMap](http://kubernetes.io/docs/user-guide/configmap/) to provide configuration parameters to the Pods 
in the ensemble.
* Create a [PodDisruptionBudget](http://kubernetes.io/docs/admin/disruptions/) so kubectl drain will respect the Quorum 
size of the ensemble.
* Optionally, apply a [Pod Anti-Affinity](http://kubernetes.io/docs/user-guide/node-selection/) annotation to spread the 
ZooKeeper ensemble across nodes.

## Installing the Chart

You can install the chart with the release name `my-release` as below.

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/zookeeper
```

If you do not specify a name, helm will select a name for you.

## Configuration
You can specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. 
For example,

```bash
$ helm install --name my-release -f values.yaml incubator/zookeeper
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Resources
The configuration parameters in this section control the resources requested and utilized by the ZooKeeper ensemble.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `Servers` | The number of ZooKeeper servers. This should always be (1,3,5, or 7) | `3` |
| `MinAvailable` | The minimum number of servers that must be available during evictions. This should in the interval `[(Servers/2) + 1,(Servers - 1)]`. | `Servers-1` |
| `Cpu` | The amount of CPU to request. As ZooKeeper is not very CPU intensive, `2` is a good choice to start with for a production deployment. | `1` |
| `Heap` | The amount of JVM heap that the ZooKeeper servers will use. As ZooKeeper stores all of its data in memory, this value should reflect the size of your working set. The JVM -Xms/-Xmx format is used. |`2G` |
| `Memory` | The amount of memory to request. This value should be at least 2 GiB larger than `Heap` to avoid swapping. You many want to use `1.5 * Heap` for values larger than 2GiB. The Kubernetes format is used. |`2Gi` |
| `Storage` | The amount of Storage to request. Even though ZooKeeper keeps is working set in memory, it logs all transactions, and periodically snapshots, to storage media. The amount of storage required will vary with your workload, working memory size, and log and snapshot retention policy. Note that, on some cloud providers selecting a small volume size will result is sub-par I/O performance. 250 GiB is a good place to start for production workloads. | `50Gi`|
| `StorageClass` | The storage class of the storage allocated for the ensemble. If this value is present, it will add an annotation asking the PV Provisioner for that storage class. | `default` |

### Network 
These parameters control the network ports on which the ensemble communicates.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `ServerPort` | The port on which the ZooKeeper servers listen for requests from other servers in the ensemble. | `2888` |
| `LeaderElectionPort` | The port on which the ZooKeeper servers perform leader election. | `3888` |
| `ClientPort` | The port on which the ZooKeeper servers listen for client requests. | `2181` |
| `ClientCnxns` | The maximum number of simultaneous client connections that each server in the ensemble will allow. | `60` |

### Time
ZooKeeper uses the Zab protocol to replicate its state machine across the ensemble. The following parameters control 
the timeouts for the protocol.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `TicktimeMs` | The number of milliseconds in one ZooKeeper Tick. You might want to increase this value if the network latency is high or unpredictable in your environment. | `2000` |
| `InitTicks` | The amount of time, in Ticks, that a follower is allowed to connect to and sync with a leader. Increase this value if the amount of data stored on the servers is large. | `10` |
| `SyncTicks` | The amount of time, in Ticks, that a follower is allowed to lag behind a leader. If the follower is longer than SyncTicks behind the leader, the follower is dropped.  | `5` |

### Log Retention 
ZooKeeper writes its WAL (Write Ahead Log) and periodic snapshots to storage media. These parameters control the 
retention policy for snapshots and WAL segments. If you do not configure the ensemble to automatically periodically 
purge snapshots and logs, it is important to implement such a mechanism yourself. Otherwise, you will eventually exhaust 
all available storage media.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `SnapRetain` | The number of snapshots to retain on disk. If `PurgeHours` is set to 0 this parameter has no effect. | `3` |
| `PurgeHours` | The amount of time, in hours, between ZooKeeper snapshot and log purges. Setting this to 0 will disable purges.| `1` |

### Spreading 
Spreading allows you specify an anti-affinity between ZooKeeper servers in the ensemble. This will prevent the Pods from 
being scheduled on the same node.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `AntiAffinity` | If present it must take the values 'hard' or 'soft'. 'hard' will cause the Kubernetes scheduler to not schedule the Pods on the same physical node under any circumstances 'soft' will cause the Kubernetes scheduler to make a best effort to not co-locate the Pods, but, if the only available resources are on the same node, the scheduler will co-locate them. | `hard` |


### Logging 
In order to allow for the default installation to work well with the log rolling and retention policy of Kubernetes, 
all logs are written to stdout. This should also be compatible with logging integrations such as Google Cloud Logging 
and ELK.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `LogLevel` | The log level of the ZooKeeper applications. One of `ERROR`,`WARN`,`INFO`,`DEBUG`. | `INFO` |

### Liveness and Readiness
The servers in the ensemble have both liveness and readiness checks specified. These parameters can be used to tune 
the sensitivity of the liveness and readiness checks.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `ProbeInitialDelaySeconds` | The initial delay before the liveness and readiness probes will be invoked. | `15` |
| `ProbeTimeoutSeconds` | The amount of time before the probes are considered to be failed due to a timeout. | `5` |

### ImagePull
This parameter controls when the image is pulled from the repository.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `ImagePullPolicy` | The policy for pulling the image from the repository. | `Always` |

# Deep dive

## Image Details
The image used for this chart is based on Ubuntu 16.04 LTS. This image is larger than Alpine or BusyBox, but it 
provides glibc, rather than ulibc or mucl, and a JVM release that is built against it. You can easily convert this 
chart to run against a smaller image with a JVM that is build against that images libc. However, as far as we know, 
no Hadoop vendor supports, or has verified, ZooKeeper running on such a JVM.

## JVM Details
The Java Virtual Machine used for this chart is the OpenJDK JVM 8u111 JRE (headless).

## ZooKeeper Details
The ZooKeeper version is the latest stable version (3.4.9). The distribution is installed into /opt/zookeeper-3.4.9. This
directory is symbolically linked to /opt/zookeeper. Symlinks are created to simulate a rpm installation into /usr.

## Failover

You can test failover by killing the leader. Insert a key:
```console
$ kubectl exec <RELEASE-NAME>-0 -- /opt/zookeeper/bin/zkCli.sh create /foo bar;
$ kubectl exec <RELEASE-NAME>-2 -- /opt/zookeeper/bin/zkCli.sh get /foo;

Watch existing members:
```console
$ kubectl run --attach bbox --image=busybox --restart=Never -- sh -c 'while true; do for i in 0 1 2; do echo zk-$i $(echo stats | nc <pod-name>.<headless-service-name>:2181 | grep Mode); sleep 1; done; done';
zk-2 Mode: follower
zk-0 Mode: follower
zk-1 Mode: leader
zk-2 Mode: follower
```

Delete Pods and wait for the StatefulSet controller to bring them back up:
```console
$ kubectl delete po -l component=${RELEASE-NAME}
$ kubectl get po --watch-only
NAME      READY     STATUS     RESTARTS   AGE
zk-0     0/1       Init:0/2   0          16s
zk-0     0/1       Init:0/2   0         21s
zk-0     0/1       PodInitializing   0         23s
zk-0     1/1       Running   0         41s
zk-1     0/1       Pending   0         0s
zk-1     0/1       Init:0/2   0         0s
zk-1     0/1       Init:0/2   0         14s
zk-1     0/1       PodInitializing   0         17s
zk-1     0/1       Running   0         18s
zk-2     0/1       Pending   0         0s
zk-2     0/1       Init:0/2   0         0s
zk-2     0/1       Init:0/2   0         12s
zk-2     0/1       Init:0/2   0         28s
zk-2     0/1       PodInitializing   0         31s
zk-2     0/1       Running   0         32s
...

zk-0 Mode: follower
zk-1 Mode: leader
zk-2 Mode: follower
```

Check the previously inserted key:
```console
$ kubectl exec zk-1 -- /opt/zookeeper/bin/zkCli.sh get /foo
ionid = 0x354887858e80035, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
bar
```

## Scaling

ZooKeeper can not be safely scaled in versions prior to 3.5.x. There are manual procedures for scaling an ensemble, but 
as noted in the [ZooKeeper 3.5.2 documentation](https://zookeeper.apache.org/doc/r3.5.2-alpha/zookeeperReconfig.html) these 
procedures require a rolling restart, are known to be error prone, and often result in a data loss.

While ZooKeeper 3.5.x does allow for dynamic ensemble reconfiguration (including scaling membership), the current status 
of the release is still alpha, and it is not recommended for production use.

## Limitations
* StatefulSet and PodDisruptionBudget are beta resources.
* Only supports storage options that have backends for persistent volume claims
