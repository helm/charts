# Etcd Helm Chart

Credit to https://github.com/ingvagabund. This is an implementation of that work

* https://github.com/kubernetes/contrib/pull/1295

## Prerequisites Details
* Kubernetes 1.5 (for `StatefulSets` support)
* PV support on the underlying infrastructure

## StatefulSet Details
* https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/

## StatefulSet Caveats
* https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/#limitations

## Todo
* Implement SSL

## Chart Details
This chart will do the following:

* Implemented a dynamically scalable etcd cluster using Kubernetes StatefulSets

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/etcd
```

## Configuration

The following tables lists the configurable parameters of the etcd chart and their default values.

| Parameter               | Description                        | Default                                                    |
| ----------------------- | ---------------------------------- | ---------------------------------------------------------- |
| `Name`                  | Spark master name                  | `etcd`                                                     |
| `Image`                 | Container image name               | `nearform/etcd`                      |
| `ImageTag`              | Container image tag                | `2.3.11`                                                    |
| `ImagePullPolicy`       | Container pull policy              | `Always`                                                   |
| `Replicas`              | k8s statefulset replicas           | `3`                                                        |
| `Component`             | k8s selector key                   | `etcd`                                                     |
| `Cpu`                   | container requested cpu            | `100m`                                                     |
| `Memory`                | container requested memory         | `256Mi`                                                    |
| `ClientPort`            | k8s service port                   | `2379`                                                     |
| `PeerPorts`             | Container listening port           | `2380`                                                     |
| `PeerTLS`               | Encrypt peer trafic |               `true`                                                     |
| `Storage`               | Persistent volume size             | `1Gi`                                                      |
| `StorageClass`          | Persistent volume storage class    | `anything`                                                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/etcd
```

> **Tip**: You can use the default [values.yaml](values.yaml)

# Deep dive
This chart spins up 3 replicas by default, which means the Etcd cluster will have 3 members. However, the initial Etcd cluster size is 1, so the first pod that spins up forms the cluster by itself. The next 2 members are added to the cluster. Even with the default values you can come down to 1 member without the cluster failing.

This allows cluster size management by Helm and adds relisance to the cluster.

## Cluster Health

```
$ for i in <0..n>; do kubectl exec <release-podname-$i> -- sh -c 'etcdctl cluster-health'; done
```
eg.
```
$ for i in {0..2}; do kubectl exec <release name>-etcd-$i --namespace=etcd -- sh -c 'etcdctl cluster-health'; done
member 6bb377156d9e3fb3 is healthy: got healthy result from http://named-lynx-etcd-0.named-lynx-etcd:2379
member 8ebbb00c312213d6 is healthy: got healthy result from member dc83003f0a226816 is healthy: got healthy result from http://named-lynx-etcd-2.named-lynx-etcd:2379
member f5ee1ca177a88a58 is healthy: got healthy result from http://named-lynx-etcd-1.named-lynx-etcd:2379
cluster is healthy
```

## Failover

If any etcd member fails it gets re-joined eventually.
You can test the scenario by killing process of one of the replicas:

```shell
$ ps aux | grep etcd-1
$ kill -9 ETCD_1_PID
```

```shell
$ kubectl get pods -l "component=${RELEASE-NAME}-etcd"
NAME                 READY     STATUS        RESTARTS   AGE
etcd-0               1/1       Running       0          54s
etcd-2               1/1       Running       0          51s
```

After a while:

```shell
$ kubectl get pods -l "component=${RELEASE-NAME}-etcd"
NAME                 READY     STATUS    RESTARTS   AGE
etcd-0               1/1       Running   0          1m
etcd-1               1/1       Running   0          20s
etcd-2               1/1       Running   0          1m
```

You can check state of re-joining from ``etcd-1``'s logs:

```shell
$ kubectl logs etcd-1
Waiting for etcd-0.etcd to come up
Waiting for etcd-1.etcd to come up
ping: bad address 'etcd-1.etcd'
Waiting for etcd-1.etcd to come up
Waiting for etcd-2.etcd to come up
Re-joining etcd member
Updated member with ID 7fd61f3f79d97779 in cluster
2016-06-20 11:04:14.962169 I | etcdmain: etcd Version: 2.2.5
2016-06-20 11:04:14.962287 I | etcdmain: Git SHA: bc9ddf2
...
```

## Scaling using Helm

Scaling is managed by `helm upgrade`.

The etcd cluster can be scale up by chaning the number of replicas in the `values.yaml` or by specifying it as a parameter.

```sh
helm upgrade <release name> --set Replicas=5 incubator/etcd

$ kubectl get pods -l "component=${RELEASE-NAME}-etcd"
NAME      READY     STATUS    RESTARTS   AGE
etcd-0    1/1       Running   0          8m
etcd-1    1/1       Running   0          8m
etcd-2    1/1       Running   0          8m
etcd-3    1/1       Running   0          8s
etcd-4    1/1       Running   0          1s
```

Scaling-down is similar. For instance, changing the number of replicas to ``4``:

```sh
$ helm upgrade <release name> --set Replicas=4 incubator/etcd

$ kubectl get pods -l "component=${RELEASE-NAME}-etcd"
NAME      READY     STATUS    RESTARTS   AGE
etcd-0    1/1       Running   0          8m
etcd-1    1/1       Running   0          8m
etcd-2    1/1       Running   0          8m
etcd-3    1/1       Running   0          4s
```

Once a replica is terminated (either by running ``kubectl delete pod etcd-ID`` or scaling down), the data directory is cleaned up.
If any of the etcd pods restart (e.g. caused by etcd failure or other),
the data directory is kept untouched so the pod can recover from the failure. When for some reason a member is removed from the Etcd cluster, the restarting pod will detect this, remove the data directory and exit. It will join the Etcd cluster as a new member on next restart as if it were a brand new node.
