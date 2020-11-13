# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Etcd Helm Chart

Credit to https://github.com/ingvagabund. This is an implementation of that work

* https://github.com/kubernetes/contrib/pull/1295

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## Prerequisites Details
* Kubernetes 1.5 (for `StatefulSets` support)
* PV support on the underlying infrastructure
* ETCD version >= 3.0.0

## StatefulSet Details
* https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/

## StatefulSet Caveats
* https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/#limitations

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

The following table lists the configurable parameters of the etcd chart and their default values.

| Parameter                           | Description                          | Default                                            |
| ----------------------------------- | ------------------------------------ | -------------------------------------------------- |
| `image.repository`                  | Container image repository           | `k8s.gcr.io/etcd-amd64`                            |
| `image.tag`                         | Container image tag                  | `3.2.26`                                           |
| `image.pullPolicy`                  | Container pull policy                | `IfNotPresent`                                     |
| `replicas`                          | k8s statefulset replicas             | `3`                                                |
| `resources`                         | container required resources         | `{}`                                               |
| `clientPort`                        | k8s service port                     | `2379`                                             |
| `peerPorts`                         | Container listening port             | `2380`                                             |
| `storage`                           | Persistent volume size               | `1Gi`                                              |
| `storageClass`                      | Persistent volume storage class      | `anything`                                         |
| `affinity`                          | affinity settings for pod assignment | `{}`                                               |
| `nodeSelector`                      | Node labels for pod assignment       | `{}`                                               |
| `tolerations`                       | Toleration labels for pod assignment | `[]`                                               |
| `extraEnv`                          | Optional environment variables       | `[]`                                               |
| `memoryMode`                        | Using memory as backend storage      | `false`                                            |
| `auth.client.enableAuthentication`  | Enables host authentication using TLS certificates. Existing secret is required.    | `false` |
| `auth.client.secureTransport`       | Enables encryption of client communication using TLS certificates | `false` |
| `auth.peer.useAutoTLS`              | Automatically create the TLS certificates | `false` |
| `auth.peer.secureTransport`         | Enables encryption peer communication using TLS certificates **(At the moment works only with Auto TLS)** | `false` |
| `auth.peer.enableAuthentication`     | Enables host authentication using TLS certificates. Existing secret required | `false` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/etcd
```
> **Tip**: You can use the default [values.yaml](values.yaml)
# To install the chart with secure transport enabled
First you must create a secret which would contain the client certificates: cert, key and the CA which was to used to sign them.
Create the secret using this command:
```bash
$ kubectl create secret generic etcd-client-certs --from-file=ca.crt=path/to/ca.crt --from-file=cert.pem=path/to/cert.pem --from-file=key.pem=path/to/key.pem
```
Deploy the chart with the following flags enabled:
```bash
$ helm install --name my-release --set auth.client.secureTransport=true --set auth.client.enableAuthentication=true --set auth.client.existingSecret=etcd-client-certs --set auth.peer.useAutoTLS=true incubator/etcd
```
Reference to how to generate the needed certificate:
> Ref: https://coreos.com/os/docs/latest/generate-self-signed-certificates.html

# Deep dive

## Cluster Health

```
$ for i in <0..n>; do kubectl exec <release-podname-$i> -- sh -c 'etcdctl cluster-health'; done
```
eg.
```
$ for i in {0..9}; do kubectl exec named-lynx-etcd-$i --namespace=etcd -- sh -c 'etcdctl cluster-health'; done
member 7878c44dabe58db is healthy: got healthy result from http://named-lynx-etcd-7.named-lynx-etcd:2379
member 19d2ab7b415341cc is healthy: got healthy result from http://named-lynx-etcd-4.named-lynx-etcd:2379
member 6b627d1b92282322 is healthy: got healthy result from http://named-lynx-etcd-3.named-lynx-etcd:2379
member 6bb377156d9e3fb3 is healthy: got healthy result from http://named-lynx-etcd-0.named-lynx-etcd:2379
member 8ebbb00c312213d6 is healthy: got healthy result from http://named-lynx-etcd-8.named-lynx-etcd:2379
member a32e3e8a520ff75f is healthy: got healthy result from http://named-lynx-etcd-5.named-lynx-etcd:2379
member dc83003f0a226816 is healthy: got healthy result from http://named-lynx-etcd-2.named-lynx-etcd:2379
member e3dc94686f60465d is healthy: got healthy result from http://named-lynx-etcd-6.named-lynx-etcd:2379
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
$ kubectl get pods -l "release=${RELEASE-NAME},app=etcd"
NAME                 READY     STATUS        RESTARTS   AGE
etcd-0               1/1       Running       0          54s
etcd-2               1/1       Running       0          51s
```

After a while:

```shell
$ kubectl get pods -l "release=${RELEASE-NAME},app=etcd"
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

## Scaling using kubectl

This is for reference. Scaling should be managed by `helm upgrade`

The etcd cluster can be scale up by running ``kubectl patch`` or ``kubectl edit``. For instance,

```sh
$ kubectl get pods -l "release=${RELEASE-NAME},app=etcd"
NAME      READY     STATUS    RESTARTS   AGE
etcd-0    1/1       Running   0          7m
etcd-1    1/1       Running   0          7m
etcd-2    1/1       Running   0          6m

$ kubectl patch statefulset/etcd -p '{"spec":{"replicas": 5}}'
"etcd" patched

$ kubectl get pods -l "release=${RELEASE-NAME},app=etcd"
NAME      READY     STATUS    RESTARTS   AGE
etcd-0    1/1       Running   0          8m
etcd-1    1/1       Running   0          8m
etcd-2    1/1       Running   0          8m
etcd-3    1/1       Running   0          4s
etcd-4    1/1       Running   0          1s
```

Scaling-down is similar. For instance, changing the number of replicas to ``4``:

```sh
$ kubectl edit statefulset/etcd
statefulset "etcd" edited

$ kubectl get pods -l "release=${RELEASE-NAME},app=etcd"
NAME      READY     STATUS    RESTARTS   AGE
etcd-0    1/1       Running   0          8m
etcd-1    1/1       Running   0          8m
etcd-2    1/1       Running   0          8m
etcd-3    1/1       Running   0          4s
```

Once a replica is terminated (either by running ``kubectl delete pod etcd-ID`` or scaling down),
content of ``/var/run/etcd/`` directory is cleaned up.
If any of the etcd pods restarts (e.g. caused by etcd failure or any other),
the directory is kept untouched so the pod can recover from the failure.
