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
| `clusterName`                           | `stolon` cluster name                          | `nil`                                                |
| `image.repository`                      | `stolon` image repository                      | `sorintlab/stolon`                                           |
| `image.tag`                             | `stolon` image tag                             | `v0.13.0-pg10`                                               |
| `image.pullPolicy`                      | `stolon` image pull policy                     | `IfNotPresent`                                               |
| `etcdImage.repository`                  | `etcd` image repository                        | `k8s.gcr.io/etcd-amd64`                                      |
| `etcdImage.tag`                         | `etcd` image tag                               | `2.3.7`                                                      |
| `etcdImage.pullPolicy`                  | `etcd` image pull policy                       | `IfNotPresent`                                               |
| `debug`                                 | Debug mode                                     | `false`                                                      |
| `persistence.enabled`                   | Use a PVC to persist data                      | `true`                                                       |
| `persistence.storageClassName`          | Storage class name of backing PVC              | `""`                                                         |
| `persistence.accessModes`               | Persistent volumes access modes                | `["ReadWriteOnce"]`                                          |
| `persistence.size`                      | Size of data volume                            | `10Gi`                                                       |
| `rbac.create`                           | Specifies if RBAC resources should be created  | `true`                                                       |
| `serviceAccount.create`                 | Specifies if ServiceAccount should be created  | `true`                                                       |
| `serviceAccount.name`                   | Name of the generated ServiceAccount           | Defaults to fullname template                                |
| `superuserSecret.name`                  | Postgres superuser credential secret name      | `""`                                                         |
| `superuserSecret.usernameKey`           | Username key of Postgres superuser in secret   | `pg_su_username`                                             |
| `superuserSecret.passwordKey`           | Password key of Postgres superuser in secret   | `pg_su_password`                                             |
| `superuserUsername`                     | Postgres superuser username                    | `stolon`                                                     |
| `superuserPassword`                     | Postgres superuser password                    | (Required if `superuserSecret.name` is not set)              |
| `replicationSecret.name`                | Postgres replication credential secret name    | `""`                                                         |
| `replicationSecret.usernameKey`         | Username key of Postgres replication in secret | `pg_repl_username`                                           |
| `replicationSecret.passwordKey`         | Password key of Postgres replication in secret | `pg_repl_password`                                           |
| `replicationUsername`                   | Replication username                           | `repluser`                                                   |
| `replicationPassword`                   | Replication password                           | (Required if `replicationSecret.name` is not set)            |
| `store.backend`                         | Store backend (kubernetes/consul/etcd)         | `kubernetes`                                                 |
| `store.endpoints`                       | Store backend endpoints                        | `nil`                                                        |
| `store.kubeResourceKind`                | Kubernetes resource kind (only for kubernetes) | `configmap`                                                  |
| `pgParameters`                          | [`postgresql.conf`][pgconf] options used during cluster creation | `{}`                                       |
| `ports`                                 | Ports to expose on pods                        | `{"stolon":{"containerPort": 5432},"metrics":{"containerPort": 8080}}`|
| `job.autoCreateCluster`                 | Set to `false` to force-disable auto-cluster-creation which may clear pre-existing postgres db data | `true`  |
| `job.autoUpdateClusterSpec`             | Set to `false` to force-disable auto-cluster-spec-update | `true`                                             |
| `clusterSpec`                           | Stolon cluster spec [reference](https://github.com/sorintlab/stolon/blob/master/doc/cluster_spec.md) | `{}`   |
| `tls.enabled`                           | Enable tls support to postgresql               | `false`                                                      |
| `tls.rootCa`                            | Ca ceertificate                                | `""`                                                         |
| `tls.serverCrt`                         | Server Cerfificate                             | `""`                                                         |
| `tls.serverKey`                         | Server key                                     | `""`                                                         |
| `keeper.uid_prefix`                     | Keeper prefix name                             | `keeper`                                                     |
| `keeper.replicaCount`                   | Number of keeper nodes                         | `2`                                                          |
| `keeper.resources`                      | Keeper resource requests/limit                 | `{}`                                                         |
| `keeper.priorityClassName`              | Keeper priorityClassName                       | `nil`                                                        |
| `keeper.nodeSelector`                   | Node labels for keeper pod assignment          | `{}`                                                         |
| `keeper.affinity`                       | Affinity settings for keeper pod assignment    | `{}`                                                         |
| `keeper.tolerations`                    | Toleration labels for keeper pod assignment    | `[]`                                                         |
| `keeper.volumes`                        | Additional volumes                             | `[]`                                                         |
| `keeper.volumeMounts`                   | Mount paths for `keeper.volumes`               | `[]`                                                         |
| `keeper.hooks.failKeeper.enabled`       | Enable failkeeper pre-stop hook                | `false`                                                      |
| `keeper.podDisruptionBudget.enabled`    | If true, create a pod disruption budget for keeper pods. | `false`                                            |
| `keeper.podDisruptionBudget.minAvailable` | Minimum number / percentage of pods that should remain scheduled | `""`                                     |
| `keeper.podDisruptionBudget.maxUnavailable` | Maximum number / percentage of pods that may be made unavailable | `""`                                   |
| `proxy.replicaCount`                    | Number of proxy nodes                          | `2`                                                          |
| `proxy.resources`                       | Proxy resource requests/limit                  | `{}`                                                         |
| `proxy.priorityClassName`               | Proxy priorityClassName                        | `nil`                                                        |
| `proxy.nodeSelector`                    | Node labels for proxy pod assignment           | `{}`                                                         |
| `proxy.affinity`                        | Affinity settings for proxy pod assignment     | `{}`                                                         |
| `proxy.tolerations`                     | Toleration labels for proxy pod assignment     | `[]`                                                         |
| `proxy.podDisruptionBudget.enabled`     | If true, create a pod disruption budget for proxy pods. | `false`                                             |
| `proxy.podDisruptionBudget.minAvailable` | Minimum number / percentage of pods that should remain scheduled | `""`                                      |
| `proxy.podDisruptionBudget.maxUnavailable` | Maximum number / percentage of pods that may be made unavailable | `""`                                    |
| `sentinel.replicaCount`                 | Number of sentinel nodes                       | `2`                                                          |
| `sentinel.resources`                    | Sentinel resource requests/limit               | `{}`                                                         |
| `sentinel.priorityClassName`            | Sentinel priorityClassName                     | `nil`                                                        |
| `sentinel.nodeSelector`                 | Node labels for sentinel pod assignment        | `{}`                                                         |
| `sentinel.affinity`                     | Affinity settings for sentinel pod assignment  | `{}`                                                         |
| `sentinel.tolerations`                  | Toleration labels for sentinel pod assignment  | `[]`                                                         |
| `sentinel.podDisruptionBudget.enabled`  | If true, create a pod disruption budget for sentinel pods. | `false`                                          |
| `sentinel.podDisruptionBudget.minAvailable` | Minimum number / percentage of pods that should remain scheduled | `""`                                   |
| `sentinel.podDisruptionBudget.maxUnavailable` | Maximum number / percentage of pods that may be made unavailable | `""`                                 |


[pgconf]: https://github.com/postgres/postgres/blob/master/src/backend/utils/misc/postgresql.conf.sample
