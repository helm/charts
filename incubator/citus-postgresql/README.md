# Citus Postgresql Helm Chart

This chart bootstraps a [Citus Postgresql Cluster](https://www.citusdata.com/). Citus is a Postgres extension (not a fork) that intelligently distributes data and queries across nodes so that the database can scale and execute queries fast. The Citus Membership Manager adds automated scaling as well as provisioning functionality.

## Prerequisites

* Kubernetes 1.10.0+
* Helm 2.10.0+

## Docker Image Source

* [Citus](https://github.com/citusdata/docker)
* [Citus Membership Manager](https://github.com/bakdata/citus-k8s-membership-manager)
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
==> v1/ServiceAccount
citus-manager-sa  2m

==> v1/Role
pods-list  2m

==> v1/RoleBinding
NAME       AGE
pods-list  2m

==> v1/Secret
NAME                   AGE
citus-postgresql-pgpass  2m
citus-postgresql-ssl     2m
citus-postgresql-secret  2m

==> v1/ConfigMap
NAME                          AGE
citus-postgres-ssl-settings     2m
setup-config                    2m

==> v1/Service
citus-postgresql-master  2m
citus-postgresql-worker  2m
citus-postgresql         2m

==> v1/Deployment
citus-manager

==> v1/StatefulSet
citus-postgresql-master  2m
citus-postgresql-worker  2m

==> v1/Pod(related)

NAME                     READY  STATUS   RESTARTS  AGE
citus-manager-container    1/1    Running  0         2m
citus-postgresql-master-0  2/2    Running  0         2m
citus-postgresql-worker-0  2/2    Running  1         2m
citus-postgresql-worker-1  1/2    Running  1         23s


NOTES:
[...]
```


There are
1. A [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) `citus-postgresql-worker` which contains n (determined by replication factor) [Pods](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/) with a Citus Postgresql Worker and a Prometheus sidecar container each. After the first worker pod has been started, Kubernetes waits until all containers in this pod become "ready" before launching further pods.
1. A [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) `citus-postgresql-master` which contains a [Pod](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/) with a Citus Postgresql Master and a Prometheus sidecar container.
1. A [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) `citus-manager` which contains a [Pod](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/) with the Citus Membership Manager container.
1. A [Service](https://kubernetes.io/docs/concepts/services-networking/service) `citus-postgresql` which serves as Cluster internal endpoint to reach the Citus master.
1. A headless [Service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) `citus-postgresql-worker` which serves as cluster internal endpoint to a specific Citus worker node.
1. A headless [Service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) `citus-postgresql-master` which serves as cluster internal endpoint to the Citus master node.
1. A [ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) `setup-config` which contains SQL scripts for provisioning master and worker nodes.
1. A [ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) `citus-postresql-ssl-settings` with SSL configuration for Citus nodes.
1. A [ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) `citus-postresql-metric-exporter-queries` with list of queries for custom Prometheus metrics.
1. A [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) `citus-postgresql-secret` that holds credentials for the superuser.
1. A [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) `citus-postgresql-pgpass` that deploys credentials for all nodes in the cluster as a [.pgpass](https://www.postgresql.org/docs/11/libpq-pgpass.html) file.
1. A [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) `citus-postgresql-ssl` that holds the SSL cert and key files.  
1. A [ServiceAccount](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/) `citus-manager-sa` for the Citus Membership Manager deployment.
1. A [Role](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) `pods-list` to query Kubernetes API for pod details and status.
1. A [RoleBinding](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) `pods-list` to map the Role to the ServiceAccount.

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
| `image` | Docker Image of Citus. | `citusdata/citus` |
| `imageTag` | Docker Image Tag of Citus. | `8.1.1` |
| `imagePullPolicy` | [Image pull policy](https://kubernetes.io/docs/concepts/configuration/overview/#container-images) | `IfNotPresent` |
| `readiness.enabled` | Enabled by default. Only disable if port other than 5432 as [Citus healthcheck](https://github.com/citusdata/docker/blob/master/pg_healthcheck) has got static port. | `true` |


### Worker StatefulSet Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `worker.replicaCount` | Replica Count of worker pod in statefulset | `2` |
| `worker.updateStrategy` | [StatefulSet Update Strategy](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies)  | `type: RollingUpdate` |
| `worker.citusType` | Label to detect worker pods | `citus-worker` |
| `worker.extraConfigs` | Add [command-line parameters](https://www.postgresql.org/docs/11/config-setting.html#id-1.6.6.4.5) in form of `-c log_connections=yes -c log_destination='syslog'` | - |
| `worker.resources.requests.cpu` | The amount of CPU to request. | - |
| `worker.resources.requests.memory` | The amount of memory to request. | - |
| `worker.resources.limit.cpu` | The upper limit CPU usage for a worker. | - |
| `worker.resources.limit.memory` | The upper limit memory usage for a worker. | - |
| `worker.pvc.size` | The size of the persistence volume claim. Uses default storage class. | `50Gi` |


### Master Deployment Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `master.citusType` | Label to detect master pods | `citus-master` |
| `master.extraConfigs` | Add [command-line parameters](https://www.postgresql.org/docs/11/config-setting.html#id-1.6.6.4.5) in form of `-c log_connections=yes -c log_destination='syslog'` | - |
| `master.resources.requests.cpu` | The amount of CPU to request. | - |
| `master.resources.requests.memory` | The amount of memory to request. | - |
| `master.resources.limit.cpu` | The upper limit CPU usage for the master. | - |
| `master.resources.limit.memory` | The upper limit memory usage for the master. | - |
| `master.pvc.size` | The size of the persistence volume claim. Uses default storage class. | `10Gi`  |


### Manager Deployment Configuration

The [Citus Membership Mamanger](https://github.com/bakdata/citus-k8s-membership-manager) aims to provide a service which helps running PostgreSQL with the Citus extension on kubernetes. It manages the membership of Citus worker nodes and provisions SQL scripts on pod startup.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `manager.image` | Docker Image for citus-k8s-membership-manager | `bakdata/citus-k8s-membership-manager` |
| `manager.imageTag` | Docker Image for citus-k8s-membership-manager | `v0.3` |
| `manager.resources` | Pod resource configuration | {} |
| `manager.namespace` | Namespace in which the citus cluster is supposed to be. | `default` |
| `manager.shortUrl` | If set {pod\_name}.{service\_name} is used as host pattern instead of {pod\_name}.{service\_name}.{namespace}.svc.cluster.local | `true` |
| `manager.minimumWorkers` | Worker threshold until the manager waits with node provisioning | `2` |
| `manager.serviceAccount.create` | Create new service account with expected privileges. Including Role and RoleBinding | `true` |
| `manager.serviceAccount.name` | Service account allowing the manager to retrieve pod information. | `citus-manager-sa` |
| `manager.ssl.mode` | Supports PostgreSQL [sslmodes](https://www.postgresql.org/docs/current/libpq-ssl.html) | `prefer` |
| `manager.provision.masterQueries` | Queries used to provision the master nodes.\* | - |
| `manager.provision.workerQueries` | Queries used to provision the worker nodes.\* | - |

\*Currently, it is only supported to have per line exactly one query. Please reformat all multi-line statements. In addition, the queries need to be separated by a newline in between to ensure skipping of failing queries.


### Master Service Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `service.externalPort` | The port on which the Citus master will be available and serving requests. | `5432` |
| `service.type` | The type of service for Citus master service | `ClusterIP` |
| `service.annotations` | Annotations for the service. Can be used with [Ambassador](https://www.getambassador.io/reference/mappings).  | {} |


### SSL encryption of TCP/IP connections

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `ssl.enabled` | Whether or not to JDBC connections to Citus PostgreSQL must be SSL encrypted. | `false` |
| `ssl.cert` | Content of SSL Certificate file. For details, see [PostgreSQL documentation](https://www.postgresql.org/docs/10/ssl-tcp.html). Must be base64 encoded. | - |
| `ssl.key` | Content of SSL Key file. For details, see [PostgreSQL documentation](https://www.postgresql.org/docs/10/ssl-tcp.html). Must be base64 encoded. | - |


### Prometheus Exporter Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `prometheus.enabled` | Whether or not to install Prometheus Exporter as a sidecar container and expose metrics to Prometheus. | `true` |
| `prometheus.image` | Docker Image for Prometheus Exporter container. | `wrouesnel/postgres_exporter` |
| `prometheus.imageTag` | Docker Image Tag for Prometheus Exporter container. | `v0.4.7` |
| `prometheus.port` | Exporter Port which exposes metrics in Prometheus format for scraping. | `9187` |
| `prometheus.logLevel` | Logging level. Can be one of debug, info, warn, error, fatal | `info` |
| `prometheus.disableDefaultMetrics` | If yes, only metrics supplied from queries.yaml via --extend.query-path will be reported. | `false` |
| `prometheus.queries` | Queries for custom metrics | see [here](https://github.com/wrouesnel/postgres_exporter/blob/master/queries.yaml) for an example |


### Secret Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `superuser.username` | Username of the superuser. | `"postgres"` |
| `superuser.password` | Password of the superuser. | `"0987654321"` |
| `superuser.database` | Database name for PostgreSQL. | `"postgres"` |
| `superuser.port` | Database port for PostgreSQL. | `5432` |
