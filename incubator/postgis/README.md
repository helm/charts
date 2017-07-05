# Stolon Helm Chart

## Prerequisites Details
* Kubernetes 1.5 (for `StatefulSets` support)
* PV support on the underlying infrastructure

## StatefulSet Details
* https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/

## StatefulSet Caveats
* https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/#limitations


## Chart dependencies
* etcd from http://storage.googleapis.com/kubernetes-charts-incubator


## Chart Details
This chart will do the following:

* Implemented a dynamically scalable Stolon-based PostgreSQL cluster using Kubernetes StatefulSetss

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ git clone https://github.com/lwolf/stolon-chart
$ cd stolon-chart
$ helm dep build
$ helm install --name my-release .
```

## Configuration

The following tables lists the configurable parameters of the helm chart and their default values.

| Parameter                  | Description                                | Default                                                    |
| -----------------------    | ----------------------------------         | ---------------------------------------------------------- |
| `image`                    | `stolon` image repository                  | `sorintlab/stolon`                                         |
| `imageTag`                 | `stolon` image tag                         | `v0.5.0-pg9.6`                                             |
| `imagePullPolicy`          | Image pull policy                          | `Always` if `imageTag` is `latest`, else `IfNotPresent`    |
| `clusterName`              | Name of the cluster                        | `kube-stolon`                                              |
| `debug`                    | Debug mode                                 | `false`                                                    |
| `store.backend`            | Store backend to use (etcd/consul)         | `etcd`                                                     |
| `pgReplUsername`           | Repl username                              | `repluser`                                                 |
| `pgReplPassword`           | Repl password                              | `replPassword`                                             |
| `pgSuperuserName`          | Postgres Superuser name                    | `stolon`                                                   |
| `pgSuperuserPasword`       | Postgres Superuser password                | random 10 characters                                       |
| `sentinel.replicas`        | Sentinel number of replicas                | `2`                                                        |
| `sentinel.resources`       | Sentinel resource requests/limit           | Memory: `256Mi`, CPU: `100m`                               |
| `proxy.replicas`           | Proxy number of replicas                   | `2`                                                        |
| `proxy.resources`          | Proxy resource requests/limit              | Memory: `256Mi`, CPU: `100m`                               |
| `proxy.serviceType`        | Proxy service type                         | `nil`                                                        |
| `keeper.replicas`          | Keeper number of replicas                  | `2`                                                        |
| `keeper.resources`         | Keeper resource requests/limit             | Memory: `256Mi`, CPU: `100m`                               |
| `persistence.enabled`      | Use a PVC to persist data                  | `false`                                                     |
| `persistence.storageClass` | Storage class of backing PVC               | `nil` (uses alpha storage class annotation)                |
| `persistence.accessMode`   | Use volume as ReadOnly or ReadWrite        | `ReadWriteOnce`                                            |
| `persistence.size`         | Size of data volume                        | `10Gi`                                                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml .
```

## Persistence

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning.