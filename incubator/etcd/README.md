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

## Chart Details
This chart will do the following:

* Implemented a dynamically scalable etcd cluster using Kubernetes StatefulSets

## Installing the Chart

To install the chart with the release name `my-release`:

```shell
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/etcd
```

## Configuration

The following table lists the configurable parameters of the etcd chart and their default values.

| Parameter                       | Description                          | Default                                                |
| ------------------------------- | ------------------------------------ | ------------------------------------------------------ |
| `replicaCount`                  | Number of replicas                   | `3`                                                    |
| `image.pullPolicy`              | Image pull policy                    | `Always` if `image.tag` is latest, else `IfNotPresent` |
| `image.repository`              | Etcd container image repository      | `k8s.gcr.io/etcd-amd64`                                |
| `image.tag`                     | Etcd container image tag             | `3.2.14`                                               |
| `etcd.peerTLS`                  | Encrypt peer traffic                 | `false`                                                |
| `resources`                     | CPU/memory resource requests/limits  | `{}`                                                   |
| `persistentVolume.size`         | Persistent volume size               | `1Gi`                                                  |
| `persistentVolume.storageClass` | Persistent volume storage class      | `""`                                                   |
| `persistentVolume.annotations`  | Persistent volume annotations        | `{}`                                                   |
| `persistentVolume.accessMode`   | Persistent volume access modes       | `[ReadWriteOnce]`                                      |
| `nodeSelector`                  | Node labels for pod assignment       | `{}`                                                   |
| `tolerations`                   | Toleration labels for pod assignment | `[]`                                                   |
| `antiAffinity`                  | Pod anti affinity, `hard` or `soft`  | `soft`                                                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,

```shell
$ helm install --name my-release -f values.yaml incubator/etcd
```

> **Tip**: You can use the default [values.yaml](values.yaml)

# Deep dive

This chart spins up 3 replicas by default, which means the Etcd cluster will have
3 members. However, the initial Etcd cluster size is 1, so the first pod that spins
up forms the cluster by itself. The next 2 members are added to the cluster. Even
with the default values you can come down to 1 member without the cluster failing.

This allows cluster size management by Helm and adds relisance to the cluster.

## Cluster Health

```shell
$ for i in <0..n>; do kubectl exec ${RELEASE_NAME}-etcd-$i> -- sh -c 'etcdctl cluster-health'; done
```

eg.

```shell
$ for i in {0..3}; do kubectl exec ${RELEASE_NAME}-etcd-$i --namespace=etcd -- sh -c 'etcdctl cluster-health'; done
member cd9eb4cab7519c is healthy: got healthy result from http://my-release-etcd-2.my-release-etcd.etcd:2379
member 46b6c09837a46428 is healthy: got healthy result from http://my-release-etcd-0.my-release-etcd.etcd:2379
member 8a44757850964d58 is healthy: got healthy result from http://my-release-etcd-1.my-release-etcd.etcd:2379
member c7249fde4c0e6cda is healthy: got healthy result from http://my-release-etcd-3.my-release-etcd.etcd:2379
cluster is healthy
...
```

## Failover

If any etcd member fails it gets re-joined eventually.
You can test the scenario by killing process of one of the replicas:

```shell
$ ps aux | grep etcd-1
$ kill -9 ETCD_1_PID
```

```shell
$ kubectl get pods -l app=etcd,release=${RELEASE_NAME}
NAME                READY     STATUS    RESTARTS   AGE
my-release-etcd-0   1/1       Running   0          3m
my-release-etcd-2   1/1       Running   0          2m
```

After a while:

```shell
$ kubectl get pods -l app=etcd,release=${RELEASE_NAME}
NAME                READY     STATUS    RESTARTS   AGE
my-release-etcd-0   1/1       Running   0          3m
my-release-etcd-1   1/1       Running   1          20s
my-release-etcd-2   1/1       Running   0          2m
```

You can check state of re-joining from ``my-release-etcd-1``'s logs:

```shell
$ kubectl logs my-release-etcd-1
+ hostname
+ HOSTNAME=my-release-etcd-1
+ export 'ETCD_DATA_DIR=/etcd/default.etcd'
+ ip+  r get 1
awk '{print $NF;exit}'
+ IP=172.17.0.6
+ PROTO=http
+ SET_ID=1
+ '[' -e /etcd/member_id ]
Adding an extra member..
+ '[' 1 -ge 1 ]
+ echo 'Adding an extra member..'
+ wait_member my-release-etcd-1.my-release-etcd.default
+ echo -n 'Waiting for my-release-etcd-1.my-release-etcd.default to come up '
+ true
+ echo -n .
+ ping -W 1 -c 1 my-release-etcd-1.my-release-etcd.default
ping: bad address 'my-release-etcd-1.my-release-etcd.default'
+ sleep 1s
+ true
+ echo -n .
+ ping -W 1 -c 1 my-release-etcd-1.my-release-etcd.default
+ break
+ echo ' done'
+ add_to_cluster
...
```

## Scaling using Helm

Scaling is managed by `helm upgrade`.

The etcd cluster can be scale up by chaning the number of replicas in the
`values.yaml` or by specifying it as a parameter.

```shell
$ helm upgrade <release-name> --set replicaCount=5 incubator/etcd

$ kubectl get pods -l app=etcd,release=${RELEASE-NAME}
NAME               READY  STATUS             RESTARTS  AGE
my-release-etcd-0  1/1    Running            0         9m
my-release-etcd-1  1/1    Running            0         9m
my-release-etcd-2  1/1    Running            0         9m
my-release-etcd-3  1/1    Running            0         13s
my-release-etcd-4  1/1    Running            0         9s
```

Scaling-down is similar. For instance, changing the number of replicas to ``4``:

```shell
$ helm upgrade <release-name> --set replicaCount=4 incubator/etcd

$ kubectl get pods -l app=etcd,release=${RELEASE-NAME}
NAME               READY  STATUS             RESTARTS  AGE
my-release-etcd-0  1/1    Running            0         9m
my-release-etcd-1  1/1    Running            0         9m
my-release-etcd-2  1/1    Running            0         9m
my-release-etcd-3  1/1    Running            0         1m
```

Once a replica is terminated (either by running `kubectl delete pod my-release-etcd-${ID}`
or scaling down), the data directory is cleaned up. If any of the etcd pods restart
(e.g. caused by etcd failure or other), the data directory is kept untouched so the
pod can recover from the failure. When for some reason a member is removed from the
Etcd cluster, the restarting pod will detect this, remove the data directory and
exit. It will join the Etcd cluster as a new member on next restart as if it were
a brand new node.
