# incubator/zookeeper

This helm chart provides an implementation of the ZooKeeper [StatefulSet](http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/) found in Kubernetes Contrib [Zookeeper StatefulSet](https://github.com/kubernetes/contrib/tree/master/statefulsets/zookeeper).

## Prerequisites
* Kubernetes 1.6+
* PersistentVolume support on the underlying infrastructure
* A dynamic provisioner for the PersistentVolumes
* A familiarity with [Apache ZooKeeper 3.4.x](https://zookeeper.apache.org/doc/current/)

## Chart Components
This chart will do the following:

* Create a fixed size ZooKeeper ensemble using a [StatefulSet](http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/).
* Create a [PodDisruptionBudget](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-disruption-budget/) so kubectl drain will respect the Quorum size of the ensemble.
* Create a [Headless Service](https://kubernetes.io/docs/concepts/services-networking/service/) to control the domain of the ZooKeeper ensemble.
* Create a Service configured to connect to the available ZooKeeper instance on the configured client port.
* Optionally apply a [Pod Anti-Affinity](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#inter-pod-affinity-and-anti-affinity-beta-feature) to spread the ZooKeeper ensemble across nodes.
* Optionally start JMX Exporter and Zookeeper Exporter containers inside Zookeeper pods.
* Optionally create a job which creates Zookeeper chroots (e.g. `/kafka1`).

## Installing the Chart
You can install the chart with the release name `zookeeper` as below.

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name zookeeper incubator/zookeeper
```

If you do not specify a name, helm will select a name for you.

### Installed Components
You can use `kubectl get` to view all of the installed components.

```console{%raw}
$ kubectl get all -l app=zookeeper
NAME:   zookeeper
LAST DEPLOYED: Wed Apr 11 17:09:48 2018
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1beta1/PodDisruptionBudget
NAME       MIN AVAILABLE  MAX UNAVAILABLE  ALLOWED DISRUPTIONS  AGE
zookeeper  N/A            1                1                    2m

==> v1/Service
NAME                TYPE       CLUSTER-IP     EXTERNAL-IP  PORT(S)                     AGE
zookeeper-headless  ClusterIP  None           <none>       2181/TCP,3888/TCP,2888/TCP  2m
zookeeper           ClusterIP  10.98.179.165  <none>       2181/TCP                    2m

==> v1beta1/StatefulSet
NAME       DESIRED  CURRENT  AGE
zookeeper  3        3        2m
```

1. `statefulsets/zookeeper` is the StatefulSet created by the chart.
1. `po/zookeeper-<0|1|2>` are the Pods created by the StatefulSet. Each Pod has a single container running a ZooKeeper server.
1. `svc/zookeeper-headless` is the Headless Service used to control the network domain of the ZooKeeper ensemble.
1. `svc/zookeeper` is a Service that can be used by clients to connect to an available ZooKeeper server.

## Configuration
You can specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/zookeeper
```

## Default Values

- You can find all user-configurable settings, their defaults and commentary about them in [values.yaml](values.yaml).

## Deep Dive

## Image Details
The image used for this chart is based on Ubuntu 16.04 LTS. This image is larger than Alpine or BusyBox, but it provides glibc, rather than ulibc or mucl, and a JVM release that is built against it. You can easily convert this chart to run against a smaller image with a JVM that is build against that images libc. However, as far as we know, no Hadoop vendor supports, or has verified, ZooKeeper running on such a JVM.

## JVM Details
The Java Virtual Machine used for this chart is the OpenJDK JVM 8u111 JRE (headless).

## ZooKeeper Details
The ZooKeeper version is the latest stable version (3.4.10). The distribution is installed into /opt/zookeeper-3.4.10. This directory is symbolically linked to /opt/zookeeper. Symlinks are created to simulate a rpm installation into /usr.

## Failover
You can test failover by killing the leader. Insert a key:
```console
$ kubectl exec zookeeper-0 -- /opt/zookeeper/bin/zkCli.sh create /foo bar;
$ kubectl exec zookeeper-2 -- /opt/zookeeper/bin/zkCli.sh get /foo;
```

Watch existing members:
```console
$ kubectl run --attach bbox --image=busybox --restart=Never -- sh -c 'while true; do for i in 0 1 2; do echo zk-${i} $(echo stats | nc <pod-name>-${i}.<headless-service-name>:2181 | grep Mode); sleep 1; done; done';

zk-2 Mode: follower
zk-0 Mode: follower
zk-1 Mode: leader
zk-2 Mode: follower
```

Delete Pods and wait for the StatefulSet controller to bring them back up:
```console
$ kubectl delete po -l app=zookeeper
$ kubectl get po --watch-only
NAME          READY     STATUS    RESTARTS   AGE
zookeeper-0   0/1       Running   0          35s
zookeeper-0   1/1       Running   0         50s
zookeeper-1   0/1       Pending   0         0s
zookeeper-1   0/1       Pending   0         0s
zookeeper-1   0/1       ContainerCreating   0         0s
zookeeper-1   0/1       Running   0         19s
zookeeper-1   1/1       Running   0         40s
zookeeper-2   0/1       Pending   0         0s
zookeeper-2   0/1       Pending   0         0s
zookeeper-2   0/1       ContainerCreating   0         0s
zookeeper-2   0/1       Running   0         19s
zookeeper-2   1/1       Running   0         41s
```

Check the previously inserted key:
```console
$ kubectl exec zookeeper-1 -- /opt/zookeeper/bin/zkCli.sh get /foo
ionid = 0x354887858e80035, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
bar
```

## Scaling
ZooKeeper can not be safely scaled in versions prior to 3.5.x. This chart currently uses 3.4.x. There are manual procedures for scaling a 3.4.x ensemble, but as noted in the [ZooKeeper 3.5.2 documentation](https://zookeeper.apache.org/doc/r3.5.2-alpha/zookeeperReconfig.html) these procedures require a rolling restart, are known to be error prone, and often result in a data loss.

While ZooKeeper 3.5.x does allow for dynamic ensemble reconfiguration (including scaling membership), the current status of the release is still alpha, and 3.5.x is therefore not recommended for production use.

## Limitations
* StatefulSet and PodDisruptionBudget are beta resources.
* Only supports storage options that have backends for persistent volume claims.
