# Stolon Helm Chart

* Installs [Stolon](https://github.com/sorintlab/stolon) (HA PostgreSQL cluster)
* Inspired by [this](https://github.com/lwolf/stolon-chart) and [stolon examples](https://github.com/sorintlab/stolon/tree/master/examples/kubernetes/statefulset)

## TL;DR;

```console
$ helm install stable/stolon
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/stolon
```

## Configuration

| Parameter                               | Description                                    | Default                                                      |
| --------------------------------------- | ---------------------------------------------- | ------------------------------------------------------------ |
| `image.repository`                      | `stolon` image repository                      | `sorintlab/stolon`                                           |
| `image.tag`                             | `stolon` image tag                             | `v0.10.0-pg9.6`                                              |
| `image.pullPolicy`                      | Image pull policy                              | `Always`                                                     |
| `debug`                                 | Debug mode                                     | `false`                                                      |
| `persistence.enabled`                   | Use a PVC to persist data                      | `false`                                                      |
| `persistence.storageClassName`          | Storage class name of backing PVC              | `default`                                                    |
| `persistence.accessMode`                | Use volume as ReadOnly or ReadWrite            | `["ReadWriteOnce"]`                                          |
| `persistence.size`                      | Size of data volume                            | `10Gi`                                                       |
| `rbac.create`                           | Specifies if RBAC resources should be created  | `true`                                                       |
| `serviceAccount.create`                 | Specifies if ServiceAccount should be created  | `true`                                                       |
| `serviceAccount.name  `                 | Name of the generated serviceAccount           | Defaults to fullname template                                |
| `replicationUsername`                   | Repl username                                  | `repluser`                                                   |
| `replicationPassword`                   | Repl password                                  | random 40 characters                                         |
| `superuserUsername`                     | Postgres Superuser name                        | `stolon`                                                     |
| `superuserPassword`                     | Postgres Superuser password                    | random 40 characters                                         |
| `store.backend`                         | Store backend to use (etcd/consul/kubernetes)  | `etcd`                                                       |
| `store.endpoints`                       | Store backend endpoints                        | `http://etcd-0:2379,http://etcd-1:2379,http://etcd-2:2379`   |
| `store.kubeResourceKind`                | Kubernetes resource kind (only for kubernetes) | `configmap`                                                  |
| `sentinel.replicaCount`                 | Number of sentinel nodes                       | `2`                                                          |
| `sentinel.resources`                    | Sentinel resource requests/limit               | Memory: `256Mi`, CPU: `100m`                                 |
| `sentinel.affinity`                     | Affinity settings for sentinel pod assignment  | `{}`                                                         |
| `sentinel.nodeSelector`                 | Node labels for sentinel pod assignment        | `{}`                                                         |
| `sentinel.tolerations`                  | Toleration labels for sentinel pod assignment  | `[]`                                                         |
| `proxy.replicaCount`                    | Number of proxy nodes                          | `2`                                                          |
| `proxy.resources`                       | Proxy resource requests/limit                  | Memory: `256Mi`, CPU: `100m`                                 |
| `proxy.affinity`                        | Affinity settings for proxy pod assignment     | `{}`                                                         |
| `proxy.nodeSelector`                    | Node labels for proxy pod assignment           | `{}`                                                         |
| `proxy.tolerations`                     | Toleration labels for proxy pod assignment     | `[]`                                                         |
| `keeper.replicaCount`                   | Number of keeper nodes                         | `2`                                                          |
| `keeper.resources`                      | Keeper resource requests/limit                 | Memory: `256Mi`, CPU: `100m`                                 |
| `keeper.affinity`                       | Affinity settings for keeper pod assignment    | `{}`                                                         |
| `keeper.nodeSelector`                   | Node labels for keeper pod assignment          | `{}`                                                         |
| `keeper.tolerations`                    | Toleration labels for keeper pod assignment    | `[]`                                                         |
| `keeper.client_ssl.enabled`             | Enable ssl encryption                          | `false`                                                      |
| `keeper.client_ssl.certs_secret_name`   | The secret for server.crt and server.key       | `pg-cert-secret`                                             |

