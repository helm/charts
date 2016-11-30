# Zookeeper Helm Chart

 This is an implementation of Zookeeper PetSet found under kubernetes/contrib

* https://github.com/kubernetes/contrib/tree/master/pets/zookeeper

## Prerequisites Details
* Kubernetes 1.3 with alpha APIs enable
* PV support on the underlying infrastructure

## PetSet Details
* http://kubernetes.io/docs/user-guide/petset/

## PetSet Caveats
* http://kubernetes.io/docs/user-guide/petset/#alpha-limitations

## Chart Details
This chart will do the following:

* Implemented a dynamically scalable zookeeper cluster using Kubernetes PetSets

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/zookeeper
```

## Configuration

The following tables lists the configurable parameters of the zookeeper chart and their default values.

| Parameter               | Description                        | Default                                                    |
| ----------------------- | ---------------------------------- | ---------------------------------------------------------- |
| `Name`                  | Spark master name                  | `zk`                                                       |
| `Image`                 | Container image name               | `java`                                                     |
| `ImageTag`              | Container image tag                | `openjdk-8-jre`                                            |
| `ImagePullPolicy`       | Container pull policy              | `Always`                                                   |
| `Replicas`              | k8s petset replicas                | `3`                                                        |
| `Component`             | k8s selector key                   | `zk`                                                       |
| `Cpu`                   | container requested cpu            | `100m`                                                     |
| `Memory`                | container requested memory         | `512Mi`                                                    |
| `PeerPort`              | k8s service port                   | `2888`                                                     |
| `LeaderElectionPort`    | Container listening port           | `3888`                                                     |
| `Storage`               | Persistent volume size             | `1Gi`                                                      |
| `StorageClass`          | Persistent volume class            | `volume.alpha.kubernetes.io/storage-class: default`        |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/zookeeper
```

> **Tip**: You can use the default [values.yaml](values.yaml)

# Deep dive


## Failover

You can test failover by killing the leader. Insert a key:
```console
$ kubectl exec $RELEASE-NAME-zoo-0 -- /opt/zookeeper/bin/zkCli.sh create /foo bar;
$ kubectl exec $RELEASE-NAME-zoo-2 -- /opt/zookeeper/bin/zkCli.sh get /foo;

Watch existing members:
```console
$ kubectl run --attach bbox --image=busybox --restart=Never -- sh -c 'while true; do for i in 0 1 2; do echo zoo-$i $(echo stats | nc <pod-name>.<petset-name>:2181 | grep Mode); sleep 1; done; done';
zoo-2 Mode: follower
zoo-0 Mode: follower
zoo-1 Mode: leader
zoo-2 Mode: follower
```

Delete pets and wait for the petset controller to bring the back up:
```console
$ kubectl delete po -l component=${RELEASE-NAME}-zk
$ kubectl get po --watch-only
NAME      READY     STATUS     RESTARTS   AGE
zoo-0     0/1       Init:0/2   0          16s
zoo-0     0/1       Init:0/2   0         21s
zoo-0     0/1       PodInitializing   0         23s
zoo-0     1/1       Running   0         41s
zoo-1     0/1       Pending   0         0s
zoo-1     0/1       Init:0/2   0         0s
zoo-1     0/1       Init:0/2   0         14s
zoo-1     0/1       PodInitializing   0         17s
zoo-1     0/1       Running   0         18s
zoo-2     0/1       Pending   0         0s
zoo-2     0/1       Init:0/2   0         0s
zoo-2     0/1       Init:0/2   0         12s
zoo-2     0/1       Init:0/2   0         28s
zoo-2     0/1       PodInitializing   0         31s
zoo-2     0/1       Running   0         32s
...

zoo-0 Mode: follower
zoo-1 Mode: leader
zoo-2 Mode: follower
```

Check the previously inserted key:
```console
$ kubectl exec zoo-1 -- /opt/zookeeper/bin/zkCli.sh get /foo
ionid = 0x354887858e80035, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
bar
```

## Scaling using kubectl

This is for reference. Scaling should be managed by `helm upgrade`

The zookeeper cluster can be scale up by running ``kubectl patch`` or ``kubectl edit``. For instance,

```sh
$ kubectl patch petset/zk -p '{"spec":{"replicas": 5}}'
"zk" patched
```



# Zookeeper

This example runs zookeeper through a petset.

## Bootstrap

Create the petset in this directory
```
$ kubetl create -f zookeeper.yaml
```

Once you have all 3 nodes in Running, you can run the "test.sh" script in this directory.



## Scaling

You can scale up by modifying the number of replicas on the PetSet.

## Image Upgrade

TODO: Add details

## Maintenance

TODO: Add details

## Limitations
* Both petset and init containers are in alpha
* Look through the on-start and on-change scripts for TODOs
* Doesn't support the addition of observers through the petset
* Only supports storage options that have backends for persistent volume claims
