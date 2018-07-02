# ClickHouse

Run ClickHouse column-oriented database on kubernetes

## TL;DR;

## Introduction

This chart bootstraps a [ClickHouse](https://clickhouse.yandex/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Quick start with minikube

```bash
# start minikube and install tiller
minikube start
helm init
kubectl patch deployment tiller-deploy -p '{"spec": {"template": {"spec": {"automountServiceAccountToken": true}}}}'

# install chart
helm upgrade --install clickhouse incubator/clickhouse
```

### Seed the database manually
Terminal #1:
```
kubectl port-forward clickhouse-0 9000:9000
```
Terminal #2:
```
QUERY=$(cat initdb.sql)
docker run -ti --network=host \
    --rm yandex/clickhouse-client \
    --host=docker.for.mac.localhost \
    --multiquery \
    --query="${QUERY}"
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm install --name my-release incubator/clickhouse
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
helm delete my-release
```

## Configuration
The following table lists the configurable parameters of the clickhouse chart and their default values.

| Parameter                  | Description                                     | Default                                                    |
| -----------------------    | ---------------------------------------------   | ---------------------------------------------------------- |
| `replicas`                 | Number of nodes                                 | `1`                                                        |
| `image`                    | `clickhouse` image repository                   | `yandex/clickhouse-server`                                 |
| `imageTag`                 | `clickhouse` image tag                          | `latest`                                                   |
| `imagePullPolicy`          | Image pull policy                               | `Always`                                                   |
| `imagePullSecret`          | Image pull secrets                              | `nil`                                                      |
| `persistence.enabled`      | Use a PVC to persist data                       | `false`                                                    |
| `persistence.existingClaim`| Provide an existing PersistentVolumeClaim       | `nil`                                                      |
| `persistence.storageClass` | Storage class of backing PVC                    | `default`                                                  |
| `persistence.accessMode`   | Use volume as ReadOnly or ReadWrite             | `ReadWriteOnce`                                            |
| `persistence.annotations`  | Persistent Volume annotations                   | `{}`                                                       |
| `persistence.size`         | Size of data volume                             | `10Gi`                                                     |
| `resources.limits.cpu`     | CPU resource limit                              | `1`                                                        |
| `resources.limits.memory`  | Memory resource limit                           | `1Gi`                                                      |
| `resources.requests.cpu`   | CPU resource request                            | `1`                                                        |
| `resources.requests.memory`| Memory resource request                         | `1Gi`                                                      |
| `service.externalIPs`      | External IPs to listen on                       | `[]`                                                       |
| `service.port`             | TCP port                                        | `8123`                                                     |
| `service.type`             | k8s service type exposing ports, e.g. `NodePort`| `ClusterIP`                                                |
| `service.nodePort`         | NodePort value if service.type is `NodePort`    | `nil`                                                      |
| `service.annotations`      | Service annotations                             | `{}`                                                       |
| `service.labels`           | Service labels                                  | `{}`                                                       |
| `ingress.enabled`          | Enables Ingress                                 | `false`                                                    |
| `ingress.annotations`      | Ingress annotations                             | `{}`                                                       |
| `ingress.labels`           | Ingress labels                                  | `{}`                                                       |
| `ingress.hosts`            | Ingress accepted hostnames                      | `[]`                                                       |
| `ingress.tls`              | Ingress TLS configuration                       | `[]`                                                       |
| `nodeSelector`             | Node labels for pod assignment                  | `{}`                                                       |
| `tolerations`              | Toleration labels for pod assignment            | `{}`                                                       |
| `podAnnotations`           | Annotations for the clickhouse pod              | `{}`                                                       |
| `annotations`              | Annotations for the clickhouse statefulset      | `{}`                                                       |
| `initdb_args`              | Arguments for the clickhouse-clinet init query  | `['--user=default', '--database=default', '--multiquery']` |
| `initdb_sql`               | Bootstrap sql query file                        | `SQL query that create test db and table, see values.xml`  |
| `config_xml`               | Server config, XML                              | `XML with default server config`                           |
| `users_xml`                | Users config, XML                               | `XML with default users config`                            |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install --name my-release --set persistence.enabled=true incubator/clickhouse
```

### Configuration
Make a copy of `values.yaml` and `conf` dir:
```bash
cp values.yaml myconfig.yaml
cp -rf conf myconfig
```

To use the edited `myconfig.yaml`:
```bash
helm install --name my-release -f myconfig.yaml .
```

Edit `myconfig.yaml` `config_xml` and `users_xml` according to [server settings docs](https://clickhouse.yandex/docs/en/operations/server_settings/settings/)

User passwords can be generated:
```bash
echo -n "password" | sha256sum | tr -d '-' | tr -d ' '
# result: 5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8
```

#### Bootstrapping database
Edit `myconfig.yaml` `initdb_sql` boostrap script, to create tables and views you need according to [query docs](https://clickhouse.yandex/docs/en/query_language/queries/).

