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
| `image.tag`                             | `stolon` image tag                             | `v0.11.0-pg10`                                               |
| `image.pullPolicy`                      | `stolon` image pull policy                     | `IfNotPresent`                                               |
| `etcdImage.repository`                  | `etcd` image repository                        | `k8s.gcr.io/etcd-amd64`                                      |
| `etcdImage.tag`                         | `etcd` image tag                               | `2.2.5`                                                      |
| `etcdImage.pullPolicy`                  | `etcd` image pull policy                       | `IfNotPresent`                                               |
| `debug`                                 | Debug mode                                     | `false`                                                      |
| `persistence.enabled`                   | Use a PVC to persist data                      | `true`                                                       |
| `persistence.storageClassName`          | Storage class name of backing PVC              | `""`                                                         |
| `persistence.accessModes`               | Perisistent volumes access modes               | `["ReadWriteOnce"]`                                          |
| `persistence.size`                      | Size of data volume                            | `10Gi`                                                       |
| `rbac.create`                           | Specifies if RBAC resources should be created  | `true`                                                       |
| `serviceAccount.create`                 | Specifies if ServiceAccount should be created  | `true`                                                       |
| `serviceAccount.name`                   | Name of the generated serviceAccount           | Defaults to fullname template                                |
| `superuserUsername`                     | Postgres superuser username                    | `stolon`                                                     |
| `superuserPassword`                     | Postgres superuser password                    | random 40 characters                                         |
| `replicationUsername`                   | Replication username                           | `repluser`                                                   |
| `replicationPassword`                   | Replication password                           | random 40 characters                                         |
| `store.backend`                         | Store backend (kubernetes/consul/etcd)         | `kubernetes`                                                 |
| `store.endpoints`                       | Store backend endpoints                        | `nil`                                                        |
| `store.kubeResourceKind`                | Kubernetes resource kind (only for kubernetes) | `configmap`                                                  |
| `pgParameters`                          | [`postgresql.conf`][pgconf] options used during cluster creation | `{}`                                       |
| `ports`                                 | Ports to expose on pods                        | `{"stolon":{"containerPort": 5432},"metrics":{"containerPort": 8080}}`|
| `keeper.replicaCount`                   | Number of keeper nodes                         | `2`                                                          |
| `keeper.resources`                      | Keeper resource requests/limit                 | `{}`                                                         |
| `keeper.nodeSelector`                   | Node labels for keeper pod assignment          | `{}`                                                         |
| `keeper.affinity`                       | Affinity settings for keeper pod assignment    | `{}`                                                         |
| `keeper.tolerations`                    | Toleration labels for keeper pod assignment    | `[]`                                                         |
| `proxy.replicaCount`                    | Number of proxy nodes                          | `2`                                                          |
| `proxy.resources`                       | Proxy resource requests/limit                  | `{}`                                                         |
| `proxy.nodeSelector`                    | Node labels for proxy pod assignment           | `{}`                                                         |
| `proxy.affinity`                        | Affinity settings for proxy pod assignment     | `{}`                                                         |
| `proxy.tolerations`                     | Toleration labels for proxy pod assignment     | `[]`                                                         |
| `sentinel.replicaCount`                 | Number of sentinel nodes                       | `2`                                                          |
| `sentinel.resources`                    | Sentinel resource requests/limit               | `{}`                                                         |
| `sentinel.nodeSelector`                 | Node labels for sentinel pod assignment        | `{}`                                                         |
| `sentinel.affinity`                     | Affinity settings for sentinel pod assignment  | `{}`                                                         |
| `sentinel.tolerations`                  | Toleration labels for sentinel pod assignment  | `[]`                                                         |


[pgconf]: https://github.com/postgres/postgres/blob/master/src/backend/utils/misc/postgresql.conf.sample
