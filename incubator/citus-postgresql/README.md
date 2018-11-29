# Citus Postgresql Helm Chart

This chart bootstraps a deployment of a Citus Postgresql Cluster. The current scope of the helm chart is setting up a cluster once and not being able to scale up or down the number of Worker nodes without manual steps. This will be added in future.

## Prerequisites

* Kubernetes 1.10.0+
* Helm 2.10.0+

## Docker Image Source

* [Citus](https://github.com/citusdata/docker)
* [Prometheus sidecar](https://github.com/wrouesnel/postgres_exporter)

## Installed Components

You can use `helm status <release name>` to view all of the installed components.

For example:

```console{%raw}
$ helm status citus-postgresql
LAST DEPLOYED: Thu Nov  1 10:56:12 2018
NAMESPACE: development
STATUS: DEPLOYED

RESOURCES:
==> v1/Secret
NAME                   AGE
citus-postgresql-secret  2m
citus-postgresql-pgpass  2m

==> v1/Service
citus-postgresql-master  2m
citus-postgresql-worker  2m
citus-postgresql         2m

==> v1/StatefulSet
citus-postgresql-master  2m
citus-postgresql-worker  2m

==> v1/Pod(related)

NAME                     READY  STATUS   RESTARTS  AGE
citus-postgresql-master-0  2/2    Running  0         2m
citus-postgresql-worker-0  2/2    Running  1         2m
citus-postgresql-worker-1  1/2    Running  1         23s


NOTES:
[...]
```


There are
1. A [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) `citus-postgresql-worker` which contains n Citus Postgresql Worker [Pod](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/)s: `citus-postgresql-worker-n`. 
After the first worker pod has been started, Kubernetes waits until all containers in this pod become "ready" before launching further pods. The readiness probe of the prometheus sidecar takes approx. two minutes.
1. A [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) `citus-postgresql` which contains a Citus Postgresql Master [Pod](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/): `citus-postgresql-master`. 
   1. Future idea: add a container similar [citus-membership-manager](https://github.com/citusdata/membership-manager) or [atomicdb's docker container](https://github.com/jberkus/atomicdb/blob/master/citus_petset/citus-docker/scripts/entrypoint.py) to the pod to auto-integrate new worker nodes to better facilitate scaling.
1. A [Service](https://kubernetes.io/docs/concepts/services-networking/service) `citus-postgresql` which serves as Cluster internal endpoint to reach the Citus master.
1. A headless [Service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) `citus-postgresql-worker` which serves as cluster internal endpoint to a specific Citus worker node.
1. A headless [Service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) `citus-postgresql-master` which serves as cluster internal endpoint to the Citus master node.
1. A [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) that holds credentials for the superuser.
1. A [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) that deploys credentials for all nodes in the cluster as a [.pgpass](https://www.postgresql.org/docs/11/libpq-pgpass.html) file.

## Configuration

You can specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install incubator/citus-postgresql --name citus-postgresql -f <cluster-name>/citus-postgresql-values.yaml
```

> **Tip**: A default [values.yaml](values.yaml) is provided and lists all available variables. The default database is `postgres`.

### General Citus Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `fullNameOverride` | Override default Citus name | - |
| `imagePullSecrets` | Secrets to be used for private registries. | - |
| `image` | Docker Image of Citus. | citusdata/citus |
| `imageTag` | Docker Image Tag of Citus. | 7.5.1 |
| `imagePullPolicy` | [Image pull policy](https://kubernetes.io/docs/concepts/configuration/overview/#container-images) | `IfNotPresent` |

### Worker StatefulSet Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `worker.port` | The port on which the Citus worker will be available and serving requests. | `5432` |
| `worker.replicaCount` | Replica Count of worker pod in statefulset | 2 |
| `worker.resources.requests.cpu` | The amount of CPU to request. | 250m |
| `worker.resources.requests.memory` | The amount of memory to request. | 1Gi |
| `worker.resources.limit.cpu` | The upper limit CPU usage for a worker. | 1 |
| `worker.resources.limit.memory` | The upper limit memory usage for a worker. | 15Gi |
| `worker.pvc.size` | The size of the persistence volume claim. | 50Gi |

### Master Deployment Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `master.port` | The port on which the Citus master will be available and serving requests. | `5432` |
| `master.resources.requests.cpu` | The amount of CPU to request. | 500m |
| `master.resources.requests.memory` | The amount of memory to request. | 1Gi  |
| `master.resources.limit.cpu` | The upper limit CPU usage for the master. | 4 |
| `master.resources.limit.memory` | The upper limit memory usage for the master. | 15Gi |
| `master.pvc.size` | The size of the persistence volume claim. | 10Gi  |

### Master Service Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `service.externalPort` | The port on which the Citus master will be available and serving requests. | `5432` |
| `service.type` | The type of service for Citus master service | `ClusterIP` |
| `service.annotations` | Annotations for the service. Mostly used by [Ambassador](https://www.getambassador.io/reference/mappings).  | {} |


### SSL encryption of TCP/IP connections
| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `ssl.enabled` | Whether or not to JDBC connections to Citus PostgreSQL must be SSL encrypted. | `false` |
| `ssl.cert` | SSL Certificate file. For details, see [PostgreSQL documentation](https://www.postgresql.org/docs/10/ssl-tcp.html). Must be base64 encoded. | - |
| `ssl.key` | SSL Key file. For details, see [PostgreSQL documentation](https://www.postgresql.org/docs/10/ssl-tcp.html). Must be base64 encoded. | - |


### Prometheus Exporter Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `prometheus.enabled` | Whether or not to install Prometheus Exporter as a sidecar container and expose metrics to Prometheus. | `true` |
| `prometheus.image` | Docker Image for Prometheus Exporter container. | `wrouesnel/postgres_exporter` |
| `prometheus.imageTag` | Docker Image Tag for Prometheus Exporter container. | `v0.4.6` |
| `prometheus.port` | Exporter Port which exposes metrics in Prometheus format for scraping. | `9187` |

### Secret Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `superuser.username` | Username of the superuser. | `"postgres"` |
| `superuser.password` | Password of the superuser. | `"0987654321"` |