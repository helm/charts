# CockroachDB Helm Chart

## Prerequisites Details
* Kubernetes 1.8
* PV support on the underlying infrastructure
* If you want to secure your cluster to use TLS certificates for all network
  communication, [Helm must be installed with RBAC
  privileges](https://github.com/kubernetes/helm/blob/master/docs/rbac.md)
  or else you will get an "attempt to grant extra privileges" error.

## StatefulSet Details
* http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/

## StatefulSet Caveats
* http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/#limitations

## Chart Details

This chart will do the following:

* Set up a dynamically scalable CockroachDB cluster using a Kubernetes StatefulSet

## Installing the Chart

To install the chart with the release name `my-release`:

```shell
helm install --name my-release stable/cockroachdb
```

Note that for a production cluster, you are very likely to want to modify the
`Storage` and `StorageClass` parameters. This chart defaults to just 1 GiB of
disk space per pod in order for it to work in small environments like Minikube,
and the default persistent volume `StorageClass` in your environment may not be
what you want for a database (e.g. on GCE the default is not SSD).

If you are running in secure mode (with configuration parameter `Secure.Enabled`
set to `true`), then you will have to manually approve the cluster's security
certificates as the pods are created. You can see the pending
certificate-signing requests by running `kubectl get csr`, and approve them by
running `kubectl certificate approve <csr-name>`. You'll have to approve one
certificate for each node (e.g.  `default.node.eerie-horse-cockroachdb-0` and
one client certificate for the job that initializes the cluster (e.g.
`default.node.root`).

## Upgrading
### To 2.0.0
Due to having no explicit selector set for the StatefulSet before version 2.0.0 of
this chart, upgrading from any version that uses a version of kubernetes that locks
the selector labels to any other version is impossible without deleting the StatefulSet.
Luckily there is a way to do it without actually deleting all the resources managed
by the StatefulSet. Use the workaround below to upgrade from versions previous to 2.0.0.
The following example assumes that the release name is crdb:

```console
$ kubectl delete statefulset crdb-cockroachdb --cascade=false
```

Verify that no pod is deleted and then upgrade as normal. A new StatefulSet will
be created taking over the management of the existing pods upgrading them if needed.

For more information about the upgrading bug see https://github.com/helm/charts/issues/7680.

## Configuration

The following table lists the configurable parameters of the CockroachDB chart and their default values.

| Parameter                      | Description                                      | Default                                   |
| ------------------------------ | ------------------------------------------------ | ----------------------------------------- |
| `Name`                         | Chart name                                       | `cockroachdb`                             |
| `Image`                        | Container image name                             | `cockroachdb/cockroach`                   |
| `ImageTag`                     | Container image tag                              | `v2.0.6`                                  |
| `ImagePullPolicy`              | Container pull policy                            | `Always`                                  |
| `Replicas`                     | k8s statefulset replicas                         | `3`                                       |
| `MaxUnavailable`               | k8s PodDisruptionBudget parameter                | `1`                                       |
| `Component`                    | k8s selector key                                 | `cockroachdb`                             |
| `ExternalGrpcPort`             | CockroachDB primary serving port                 | `26257`                                   |
| `ExternalGrpcName`             | CockroachDB primary serving port name            | `grpc`                                    |
| `InternalGrpcPort`             | CockroachDB inter-cockroachdb port               | `26257`                                   |
| `InternalGrpcName`             | CockroachDB inter-cockroachdb port name          | `grpc`                                    |
| `InternalHttpPort`             | CockroachDB HTTP port                            | `8080`                                    |
| `ExternalHttpPort`             | CockroachDB HTTP port on service                 | `8080`                                    |
| `HttpName`                     | Name given to the http service port              | `http`                                    |
| `Resources`                    | Resource requests and limits                     | `{}`                                      |
| `Storage`                      | Persistent volume size                           | `1Gi`                                     |
| `StorageClass`                 | Persistent volume class                          | `null`                                    |
| `CacheSize`                    | Size of CockroachDB's in-memory cache            | `25%`                                     |
| `MaxSQLMemory`                 | Max memory to use processing SQL queries         | `25%`                                     |
| `ClusterDomain`                | Cluster's default DNS domain                     | `cluster.local`                           |
| `NetworkPolicy.Enabled`        | Enable NetworkPolicy                             | `false`                                   |
| `NetworkPolicy.AllowExternal`  | Don't require client label for connections       | `true`                                    |
| `Service.Type`                 | Public service type                              | `ClusterIP`                               |
| `Service.Annotations`          | Annotations to apply to the service              | `{}`                                      |
| `PodManagementPolicy`          | `OrderedReady` or `Parallel` pod creation/deletion order | `Parallel`                        |
| `UpdateStrategy.type`          | allows setting of RollingUpdate strategy         | `RollingUpdate`                           |
| `NodeSelector`                 | Node labels for pod assignment                   | `{}`                                      |
| `Tolerations`                  | List of node taints to tolerate                  | `{}`                                      |
| `Secure.Enabled`               | Whether to run securely using TLS certificates   | `false`                                   |
| `Secure.RequestCertsImage`     | Image to use for requesting TLS certificates     | `cockroachdb/cockroach-k8s-request-cert`  |
| `Secure.RequestCertsImageTag`  | Image tag to use for requesting TLS certificates | `0.3`                                     |
| `Secure.ServiceAccount.Create` | Whether to create a new RBAC service account     | `true`                                    |
| `Secure.ServiceAccount.Name`   | Name of RBAC service account to use              | `""`                                      |
| `JoinExisting`                 | List of already-existing cockroach instances     | `[]`                                      |
| `Locality`                     | Locality attribute for this deployment           | `""`                                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```shell
helm install --name my-release -f values.yaml stable/cockroachdb
```

> **Tip**: You can use the default [values.yaml](values.yaml)

# Deep dive

## Connecting to the CockroachDB cluster

Once you've created the cluster, you can start talking to it by connecting
to its "public" service. CockroachDB is PostgreSQL wire protocol compatible so
there's a [wide variety of supported
clients](https://www.cockroachlabs.com/docs/install-client-drivers.html). For
the sake of example, we'll open up a SQL shell using CockroachDB's built-in
shell and play around with it a bit, like this (likely needing to replace
"my-release-cockroachdb-public" with the name of the "-public" service that
was created with your installed chart):

```console
$ kubectl run -it --rm cockroach-client \
    --image=cockroachdb/cockroach \
    --restart=Never \
    --command -- ./cockroach sql --insecure --host my-release-cockroachdb-public
Waiting for pod default/cockroach-client to be running, status is Pending,
pod ready: false
If you don't see a command prompt, try pressing enter.
root@my-release-cockroachdb-public:26257> SHOW DATABASES;
+--------------------+
|      Database      |
+--------------------+
| information_schema |
| pg_catalog         |
| system             |
+--------------------+
(3 rows)
root@my-release-cockroachdb-public:26257> CREATE DATABASE bank;
CREATE DATABASE
root@my-release-cockroachdb-public:26257> CREATE TABLE bank.accounts (id INT
PRIMARY KEY, balance DECIMAL);
CREATE TABLE
root@my-release-cockroachdb-public:26257> INSERT INTO bank.accounts VALUES
(1234, 10000.50);
INSERT 1
root@my-release-cockroachdb-public:26257> SELECT * FROM bank.accounts;
+------+---------+
|  id  | balance |
+------+---------+
| 1234 | 10000.5 |
+------+---------+
(1 row)
root@my-release-cockroachdb-public:26257> \q
Waiting for pod default/cockroach-client to terminate, status is Running
pod "cockroach-client" deleted
```

If you are running in secure mode, you will have to provide a client certificate
to the cluster in order to authenticate, so the above command will not work. See
[here](https://github.com/cockroachdb/cockroach/blob/master/cloud/kubernetes/client-secure.yaml)
for an example of how to set up an interactive SQL shell against a secure
cluster or
[here](https://github.com/cockroachdb/cockroach/blob/master/cloud/kubernetes/example-app-secure.yaml)
for an example application connecting to a secure cluster.

## Cluster health

Because our pod spec includes regular health checks of the CockroachDB processes,
simply running `kubectl get pods` and looking at the `STATUS` column is sufficient
to determine the health of each instance in the cluster.

If you want more detailed information about the cluster, the best place to look
is the admin UI.

## Accessing the admin UI

If you want to see information about how the cluster is doing, you can try
pulling up the CockroachDB admin UI by port-forwarding from your local machine
to one of the pods (replacing "my-release-cockroachdb-0" with one of your pods'
names):

```shell
kubectl port-forward my-release-cockroachdb-0 8080
```

Once you’ve done that, you should be able to access the admin UI by visiting
http://localhost:8080/ in your web browser.

## Failover

If any CockroachDB member fails it gets restarted or recreated automatically by
the Kubernetes infrastructure, and will rejoin the cluster automatically when
it comes back up. You can test this scenario by killing any of the pods:

```shell
kubectl delete pod my-release-cockroachdb-1
```

```shell
$ kubectl get pods -l "component=my-release-cockroachdb"
NAME                      READY     STATUS        RESTARTS   AGE
my-release-cockroachdb-0  1/1       Running       0          5m
my-release-cockroachdb-2  1/1       Running       0          5m
```

After a while:

```console
$ kubectl get pods -l "component=my-release-cockroachdb"
NAME                      READY     STATUS        RESTARTS   AGE
my-release-cockroachdb-0  1/1       Running       0          5m
my-release-cockroachdb-1  1/1       Running       0          20s
my-release-cockroachdb-2  1/1       Running       0          5m
```

You can check state of re-joining from the new pod's logs:

```console
$ kubectl logs my-release-cockroachdb-1
[...]
I161028 19:32:09.754026 1 server/node.go:586  [n1] node connected via gossip and
verified as part of cluster {"35ecbc27-3f67-4e7d-9b8f-27c31aae17d6"}
[...]
cockroachdb-0.my-release-cockroachdb.default.svc.cluster.local:26257
build:      beta-20161027-55-gd2d3c7f @ 2016/10/28 19:27:25 (go1.7.3)
admin:      http://0.0.0.0:8080
sql:
postgresql://root@my-release-cockroachdb-1.my-release-cockroachdb.default.svc.cluster.local:26257?sslmode=disable
logs:       cockroach-data/logs
store[0]:   path=cockroach-data
status:     restarted pre-existing node
clusterID:  {35ecbc27-3f67-4e7d-9b8f-27c31aae17d6}
nodeID:     2
[...]
```

## NetworkPolicy

To enable network policy for CockroachDB,
install [a networking plugin that implements the Kubernetes
NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin),
and set `NetworkPolicy.Enabled` to `true`.

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting
the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

    kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"

For more precise policy, set `networkPolicy.allowExternal=false`. This will
only allow pods with the generated client label to connect to CockroachDB.
This label will be displayed in the output of a successful install.

## Scaling

Scaling should typically be managed via the `helm upgrade` command, but StatefulSets
don't yet work with `helm upgrade`. In the meantime until `helm upgrade` works,
if you want to change the number of replicas, you can use the `kubectl scale`
as shown below:

```shell
kubectl scale statefulset my-release-cockroachdb --replicas=4
```

Note that if you are running in secure mode and increase the size of your
cluster, you will also have to approve the certificate-signing request of each
new node (using `kubectl get csr` and `kubectl certificate approve`).
