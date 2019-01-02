# Stolon Helm Chart

* Installs [Stolon](https://github.com/sorintlab/stolon) (HA PostgreSQL cluster)
* Based on [lwolf/stolon-chart](https://github.com/lwolf/stolon-chart) and [stolon examples](https://github.com/sorintlab/stolon/tree/master/examples/kubernetes/statefulset)

## TL;DR;

```console
$ helm install stable/stolon
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/stolon
```

## Backend

Kubernetes is the default store backend. `consul`, `etcdv2` or `etcdv3` can also be used as the store backend.

## Configuration

| Parameter                               | Description                                    | Default                                                      |
| --------------------------------------- | ---------------------------------------------- | ------------------------------------------------------------ |
| `image.repository`                      | `stolon` image repository                      | `sorintlab/stolon`                                           |
| `image.tag`                             | `stolon` image tag                             | `v0.12.0-pg10`                                               |
| `image.pullPolicy`                      | `stolon` image pull policy                     | `IfNotPresent`                                               |
| `etcdImage.repository`                  | `etcd` image repository                        | `k8s.gcr.io/etcd-amd64`                                      |
| `etcdImage.tag`                         | `etcd` image tag                               | `2.3.7`                                                      |
| `etcdImage.pullPolicy`                  | `etcd` image pull policy                       | `IfNotPresent`                                               |
| `debug`                                 | Debug mode                                     | `false`                                                      |
| `persistence.enabled`                   | Use a PVC to persist data                      | `true`                                                       |
| `persistence.storageClassName`          | Storage class name of backing PVC              | `""`                                                         |
| `persistence.accessModes`               | Persistent volumes access modes               | `["ReadWriteOnce"]`                                          |
| `persistence.size`                      | Size of data volume                            | `10Gi`                                                       |
| `rbac.create`                           | Specifies if RBAC resources should be created  | `true`                                                       |
| `serviceAccount.create`                 | Specifies if ServiceAccount should be created  | `true`                                                       |
| `serviceAccount.name`                   | Name of the generated ServiceAccount           | Defaults to fullname template                                |
| `superuserUsername`                     | Postgres superuser username                    | `stolon`                                                     |
| `superuserPassword`                     | Postgres superuser password                    | (Required)                                         |
| `replicationUsername`                   | Replication username                           | `repluser`                                                   |
| `replicationPassword`                   | Replication password                           | (Required)                                         |
| `store.backend`                         | Store backend (kubernetes/consul/etcd)         | `kubernetes`                                                 |
| `store.endpoints`                       | Store backend endpoints                        | `nil`                                                        |
| `store.kubeResourceKind`                | Kubernetes resource kind (only for kubernetes) | `configmap`                                                  |
| `pgParameters`                          | [`postgresql.conf`][pgconf] options used during cluster creation | `{}`                                       |
| `ports`                                 | Ports to expose on pods                        | `{"stolon":{"containerPort": 5432},"metrics":{"containerPort": 8080}}`|
| `job.autoCreateCluster`                 | Set to `false` to force-disable auto-cluster-creation which may clear pre-existing postgres db data | `true`  |
| `keeper.replicaCount`                   | Number of keeper nodes                         | `2`                                                          |
| `keeper.resources`                      | Keeper resource requests/limit                 | `{}`                                                         |
| `keeper.priorityClassName`              | Keeper priorityClassName                       | `nil`                                                        |
| `keeper.nodeSelector`                   | Node labels for keeper pod assignment          | `{}`                                                         |
| `keeper.affinity`                       | Affinity settings for keeper pod assignment    | `{}`                                                         |
| `keeper.tolerations`                    | Toleration labels for keeper pod assignment    | `[]`                                                         |
| `keeper.volumes`                        | Additional volumes                             | `[]`                                                         |
| `keeper.volumeMounts`                   | Mount paths for `keeper.volumes`               | `[]`                                                         |
| `proxy.replicaCount`                    | Number of proxy nodes                          | `2`                                                          |
| `proxy.resources`                       | Proxy resource requests/limit                  | `{}`                                                         |
| `proxy.priorityClassName`               | Proxy priorityClassName                        | `nil`                                                        |
| `proxy.nodeSelector`                    | Node labels for proxy pod assignment           | `{}`                                                         |
| `proxy.affinity`                        | Affinity settings for proxy pod assignment     | `{}`                                                         |
| `proxy.tolerations`                     | Toleration labels for proxy pod assignment     | `[]`                                                         |
| `sentinel.replicaCount`                 | Number of sentinel nodes                       | `2`                                                          |
| `sentinel.resources`                    | Sentinel resource requests/limit               | `{}`                                                         |
| `sentinel.priorityClassName`            | Sentinel priorityClassName                     | `nil`                                                        |
| `sentinel.nodeSelector`                 | Node labels for sentinel pod assignment        | `{}`                                                         |
| `sentinel.affinity`                     | Affinity settings for sentinel pod assignment  | `{}`                                                         |
| `sentinel.tolerations`                  | Toleration labels for sentinel pod assignment  | `[]`                                                         |


[pgconf]: https://github.com/postgres/postgres/blob/master/src/backend/utils/misc/postgresql.conf.sample
