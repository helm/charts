# CockroachDB Helm Chart




## Documentation

Below is a brief overview of operating the CockroachDB Helm Chart and some specific implementation details. For additional information, please see:
> https://www.cockroachlabs.com/docs/v19.2/orchestrate-cockroachdb-with-kubernetes-insecure.html




## Prerequisites Details

* Kubernetes 1.8
* PV support on the underlying infrastructure (only if using `storage.persistentVolume`). [Docker for windows hostpath provisioner is not supported](https://github.com/cockroachdb/docs/issues/3184).
* If you want to secure your cluster to use TLS certificates for all network communication, [Helm must be installed with RBAC privileges](https://github.com/kubernetes/helm/blob/master/docs/rbac.md) or else you will get an "attempt to grant extra privileges" error.




## StatefulSet Details

* http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/




## StatefulSet Caveats

* http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/#limitations




## Chart Details

This chart will do the following:

* Set up a dynamically scalable CockroachDB cluster using a Kubernetes StatefulSet.




## Installing the Chart

To install the chart with the release name `my-release`:

```shell
helm install --name my-release stable/cockroachdb
```

Note that for a production cluster, you are very likely to want to modify the `storage.persistentVolume.size` and `storage.persistentVolume.storageClass` parameters. This chart defaults to `100 GiB` of disk space per Pod, but you may want more or less depending on your use case, and the default PersistentVolume `storageClass` in your environment may not be what you want for a database (e.g. on GCE and Azure the default is not SSD).

If you are running in secure mode (with configuration parameter `tls.enabled` set to `yes`/`true`), then you will have to manually approve the cluster's security certificates as the Pods are created. You can see the pending CSRs (certificate-signing requests) by running `kubectl get csr`, and approve them by running `kubectl certificate approve <csr-name>`. You'll have to approve one certificate for each Node (e.g. `default.node.eerie-horse-cockroachdb-0` and one client certificate for the Job that initializes the cluster (e.g. `default.node.root`).

Confirm that all Pods are `Running` successfully and init has been completed:
```shell
kubectl get pods
```
```
NAME                                READY     STATUS      RESTARTS   AGE
my-release-cockroachdb-0            1/1       Running     0          1m
my-release-cockroachdb-1            1/1       Running     0          1m
my-release-cockroachdb-2            1/1       Running     0          1m
my-release-cockroachdb-init-k6jcr   0/1       Completed   0          1m
```

Confirm that PersistentVolumes are created and claimed for each Pod:
```shell
kubectl get persistentvolumes
```
```
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS    CLAIM                                      STORAGECLASS   REASON    AGE
pvc-64878ebf-f3f0-11e8-ab5b-42010a8e0035   100Gi      RWO            Delete           Bound     default/datadir-my-release-cockroachdb-0   standard                 51s
pvc-64945b4f-f3f0-11e8-ab5b-42010a8e0035   100Gi      RWO            Delete           Bound     default/datadir-my-release-cockroachdb-1   standard                 51s
pvc-649d920d-f3f0-11e8-ab5b-42010a8e0035   100Gi      RWO            Delete           Bound     default/datadir-my-release-cockroachdb-2   standard                 51s
```




## Upgrading


### From 3.0.0 on

Launch a temporary interactive Pod and start the built-in SQL client:
```shell
kubectl run cockroachdb --rm -it \
--image=cockroachdb/cockroach \
--restart=Never \
-- sql --insecure --host=my-release-cockroachdb-public
```

Set the `cluster.preserve_downgrade_option` cluster setting, where `$current_version` is the version of CockroachDB currently running (e.g. `2.1`):
```sql
> SET CLUSTER SETTING cluster.preserve_downgrade_option = '$current_version';
```

Exit the shell and delete the temp Pod:
```sql
> \q 
```

Kick off the upgrade process by changing to the new Docker image, where `$new_version` is the version being upgraded to:
```shell
kubectl delete job my-release-cockroachdb-init
```
```shell
helm upgrade my-release stable/cockroachdb \
--set image.tag=$new_version \
--reuse-values
```

Monitor the cluster's Pods until all have been successfully restarted:
```shell
kubectl get pods
```
```
NAME                                READY     STATUS              RESTARTS   AGE
my-release-cockroachdb-0            1/1       Running             0          2m
my-release-cockroachdb-1            1/1       Running             0          3m
my-release-cockroachdb-2            1/1       Running             0          3m
my-release-cockroachdb-3            0/1       ContainerCreating   0          25s
my-release-cockroachdb-init-nwjkh   0/1       ContainerCreating   0          6s
```
```shell
kubectl get pods \
-o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[0].image}{"\n"}'
```
```
my-release-cockroachdb-0    cockroachdb/cockroach:v19.2.1
my-release-cockroachdb-1    cockroachdb/cockroach:v19.2.1
my-release-cockroachdb-2    cockroachdb/cockroach:v19.2.1
my-release-cockroachdb-3    cockroachdb/cockroach:v19.2.1
```

Resume normal operations. Once you are comfortable that the stability and performance of the cluster is what you'd expect post upgrade, finalize it by running the following:
```shell
kubectl run cockroachdb --rm -it \
--image=cockroachdb/cockroach \
--restart=Never \
-- sql --insecure --host=my-release-cockroachdb-public
```
```sql
> RESET CLUSTER SETTING cluster.preserve_downgrade_option;
> \q
```


### To 2.0.0

Due to having no explicit selector set for the StatefulSet before version 2.0.0 of this chart, upgrading from any version that uses a version of Kubernetes that locks the selector labels to any other version is impossible without deleting the StatefulSet. Luckily there is a way to do it without actually deleting all the resources managed by the StatefulSet. Use the workaround below to upgrade from charts versions previous to 2.0.0:
```shell
kubectl delete statefulset my-release-cockroachdb --cascade=false
```

Verify that no Pod is deleted and then upgrade as normal. A new StatefulSet will be created taking over the management of the existing Pods upgrading them if needed.

For more information about the upgrading bug see https://github.com/helm/charts/issues/7680.


### To 3.0.0

Due changing in labels format in 3.0.0 version of this chart, upgrading requires deleting the StatefulSet. Luckily there is a way to do it without actually deleting all the resources managed by the StatefulSet. Use the workaround below to upgrade from charts versions previous to 3.0.0:

Get the new labels from specs rendered by Helm:
```shell
helm template -f deploy.vals.yml stable/cockroachdb -x templates/statefulset.yaml \
| yq r - spec.template.metadata.labels
```
```
app.kubernetes.io/name: cockroachdb
app.kubernetes.io/instance: my-release
app.kubernetes.io/component: cockroachdb
```

Place the new labels to all Pods of the StatefulSet (change `my-release-cockroachdb-0` with each Pod's name):
```shell
kubectl label pods my-release-cockroachdb-0 \
app.kubernetes.io/name=cockroachdb \
app.kubernetes.io/instance=my-release \
app.kubernetes.io/component=cockroachdb
```

Delete the StatefulSet without deleting Pods:
```shell
kubectl delete statefulset my-release-cockroachdb --cascade=false
```

Verify that no Pod is deleted and then upgrade as normal. A new StatefulSet will be created taking over the management of the existing Pods upgrading them if needed.




## Configuration

The following table lists the configurable parameters of the CockroachDB chart and their default values.
For details see the `values.yml` file.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `clusterDomain` | Cluster's default DNS domain | `cluster.local` |
| `conf.attrs`                 | CockroachDB node attributes                      | `[]`    |
| `conf.cache`                 | Size of CockroachDB's in-memory cache            | `25%`   |
| `conf.cluster-name`          | Name of CockroachDB cluster                      | `""`    |
| `conf.disable-cluster-name-verification` | Disable CockroachDB cluster name verification | `no` |
| `conf.join`                  | List of already-existing CockroachDB instances   | `[]`    |
| `conf.max-disk-temp-storage` | Max storage capacity for temp data               | `0`     |
| `conf.max-offset`            | Max allowed clock offset for CockroachDB cluster | `500ms` |
| `conf.max-sql-memory`        | Max memory to use processing SQL querie          | `25%`   |
| `conf.locality`              | Locality attribute for this deployment           | `""`    |
| `conf.single-node`           | Disable CockroachDB clustering (standalone mode) | `no`    |
| `conf.sql-audit-dir`         | Directory for SQL audit log                      | `""`    |
| `conf.port`                  | CockroachDB primary serving port in Pods         | `26257` |
| `conf.http-port`             | CockroachDB HTTP port in Pods                    | `8080`  |
| `image.repository`  | Container image name  | `cockroachdb/cockroach` |
| `image.tag`         | Container image tag   | `v19.2.1`               |
| `image.pullPolicy`  | Container pull policy | `IfNotPresent`          |
| `image.credentials` | `registry`, `user` and `pass` credentials to pull private image | `{}` |
| `statefulset.replicas`              | StatefulSet replicas number                            | `3`        |
| `statefulset.updateStrategy`        | Update strategy for StatefulSet Pods                   | `{"type": "RollingUpdate"}` |
| `statefulset.podManagementPolicy`   | `OrderedReady`/`Parallel` Pods creation/deletion order | `Parallel` |
| `statefulset.budget.maxUnavailable` | k8s PodDisruptionBudget parameter                      | `1`        |
| `statefulset.args`                | Extra command-line arguments                   | `[]` |
| `statefulset.env`                 | Extra env vars                                 | `[]` |
| `statefulset.secretMounts`        | Additional Secrets to mount at cluster members | `[]` |
| `statefulset.labels`      | Additional labels of StatefulSet and its Pods | `{"app.kubernetes.io/component": "cockroachdb"}` |
| `statefulset.annotations` | Additional annotations of StatefulSet Pods    | `{}` |
| `statefulset.nodeAffinity`           | [Node affinity rules][2] of StatefulSet Pods      | `{}`   |
| `statefulset.podAffinity`            | [Inter-Pod affinity rules][1] of StatefulSet Pods | `{}`   |
| `statefulset.podAntiAffinity`        | [Anti-affinity rules][1] of StatefulSet Pods      | auto   |
| `statefulset.podAntiAffinity.type`   | Type of auto [anti-affinity rules][1]             | `soft` |
| `statefulset.podAntiAffinity.weight` | Weight for `soft` auto [anti-affinity rules][1]   | `100`  |
| `statefulset.nodeSelector`           | Node labels for StatefulSet Pods assignment       | `{}`   |
| `statefulset.tolerations`            | Node taints to tolerate by StatefulSet Pods       | `[]`   |
| `statefulset.resources`              | Resource requests and limits for StatefulSet Pods | `{}`   |
| `service.ports.grpc.external.port` | CockroachDB primary serving port in Services          | `26257`         |
| `service.ports.grpc.external.name` | CockroachDB primary serving port name in Services     | `grpc`          |
| `service.ports.grpc.internal.port` | CockroachDB inter-communication port in Services      | `26257`         |
| `service.ports.grpc.internal.name` | CockroachDB inter-communication port name in Services | `grpc-internal` |
| `service.ports.http.port`          | CockroachDB HTTP port in Services                     | `8080`          |
| `service.ports.http.name`          | CockroachDB HTTP port name in Services                | `http`          |
| `service.public.type`        | Public Service type                      | `ClusterIP` |
| `service.public.labels`      | Additional labels of public Service      | `{"app.kubernetes.io/component": "cockroachdb"}` |
| `service.public.annotations` | Additional annotations of public Service | `{}`        |
| `service.discovery.labels`      | Additional labels of discovery Service      | `{"app.kubernetes.io/component": "cockroachdb"}` |
| `service.discovery.annotations` | Additional annotations of discovery Service | `{}` |
| `storage.hostPath`                      | Absolute path on host to store data             | `""`    |
| `storage.persistentVolume.enabled`      | Whether to use PersistentVolume to store data   | `yes`   |
| `storage.persistentVolume.size`         | PersistentVolume size                           | `100Gi` |
| `storage.persistentVolume.storageClass` | PersistentVolume class                          | `""`    |
| `storage.persistentVolume.labels`       | Additional labels of PersistentVolumeClaim      | `{}`    |
| `storage.persistentVolume.annotations`  | Additional annotations of PersistentVolumeClaim | `{}`    |
| `init.labels`       | Additional labels of init Job and its Pod            | `{"app.kubernetes.io/component": "init"}` |
| `init.annotations`  | Additional labels of the Pod of init Job             | `{}` |
| `init.affinity`     | [Affinity rules][2] of init Job Pod                  | `{}` |
| `init.nodeSelector` | Node labels for init Job Pod assignment              | `{}` |
| `init.tolerations`  | Node taints to tolerate by init Job Pod              | `[]` |
| `init.resources`    | Resource requests and limits for the Pod of init Job | `{}` |
| `tls.enabled`                | Whether to run securely using TLS certificates    | `no`  |
| `tls.serviceAccount.create`  | Whether to create a new RBAC service account      | `yes` |
| `tls.serviceAccount.name`    | Name of RBAC service account to use               | `""`  |
| `tls.init.image.repository`  | Image to use for requesting TLS certificates      | `cockroachdb/cockroach-k8s-request-cert` |
| `tls.init.image.tag`         | Image tag to use for requesting TLS certificates  | `0.4`          |
| `tls.init.image.pullPolicy`  | Requesting TLS certificates container pull policy | `IfNotPresent` |
| `tls.init.image.credentials` | `registry`, `user` and `pass` credentials to pull private image | `{}` |
| `networkPolicy.enabled`      | Enable NetworkPolicy for CockroachDB's Pods                   | `no` |
| `networkPolicy.ingress.grpc` | Whitelist resources to access gRPC port of CockroachDB's Pods | `[]` |
| `networkPolicy.ingress.http` | Whitelist resources to access gRPC port of CockroachDB's Pods | `[]` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example:
```shell
helm install --name my-release -f values.yaml stable/cockroachdb
```

> **Tip**: You can use the default [values.yaml](values.yaml)




## Deep dive


### Connecting to the CockroachDB cluster

Once you've created the cluster, you can start talking to it by connecting to its `-public` Service. CockroachDB is PostgreSQL wire protocol compatible, so there's a [wide variety of supported clients](https://www.cockroachlabs.com/docs/install-client-drivers.html). For the sake of example, we'll open up a SQL shell using CockroachDB's built-in shell and play around with it a bit, like this (likely needing to replace `my-release-cockroachdb-public` with the name of the `-public` Service that was created with your installed chart):
```shell
kubectl run cockroach-client --rm -it \
--image=cockroachdb/cockroach \
--restart=Never \
-- sql --insecure --host my-release-cockroachdb-public
```
```
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

If you are running in secure mode, you will have to provide a client certificate to the cluster in order to authenticate, so the above command will not work. See [here](https://github.com/cockroachdb/cockroach/blob/master/cloud/kubernetes/client-secure.yaml) for an example of how to set up an interactive SQL shell against a secure cluster or [here](https://github.com/cockroachdb/cockroach/blob/master/cloud/kubernetes/example-app-secure.yaml) for an example application connecting to a secure cluster.


### Cluster health

Because our Pod spec includes regular health checks of the CockroachDB processes, simply running `kubectl get pods` and looking at the `STATUS` column is sufficient to determine the health of each instance in the cluster.

If you want more detailed information about the cluster, the best place to look is the admin UI.


### Accessing the admin UI

If you want to see information about how the cluster is doing, you can try pulling up the CockroachDB admin UI by port-forwarding from your local machine to one of the Pods (replacing `my-release-cockroachdb-0` with one of your Pods'
names):
```shell
kubectl port-forward my-release-cockroachdb-0 8080
```

Once you’ve done that, you should be able to access the admin UI by visiting http://localhost:8080/ in your web browser.


### Failover

If any CockroachDB member fails it gets restarted or recreated automatically by the Kubernetes infrastructure, and will re-join the cluster automatically when it comes back up. You can test this scenario by killing any of the Pods:
```shell
kubectl delete pod my-release-cockroachdb-1
```
```shell
kubectl get pods -l "app.kubernetes.io/instance=my-release,app.kubernetes.io/component=cockroachdb"
```
```
NAME                      READY     STATUS        RESTARTS   AGE
my-release-cockroachdb-0  1/1       Running       0          5m
my-release-cockroachdb-2  1/1       Running       0          5m
```

After a while:
```shell
kubectl get pods -l "app.kubernetes.io/instance=my-release,app.kubernetes.io/component=cockroachdb"
```
```
NAME                      READY     STATUS        RESTARTS   AGE
my-release-cockroachdb-0  1/1       Running       0          5m
my-release-cockroachdb-1  1/1       Running       0          20s
my-release-cockroachdb-2  1/1       Running       0          5m
```

You can check state of re-joining from the new Pod's logs:
```shell
kubectl logs my-release-cockroachdb-1
```
```
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


### NetworkPolicy

To enable NetworkPolicy for CockroachDB, install [a networking plugin that implements the Kubernetes NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin), and set `networkPolicy.enabled` to `yes`/`true`.

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting the `DefaultDeny` Namespace annotation. Note: this will enforce policy for _all_ Pods in the Namespace:
```shell
kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"
```

For more precise policy, set `networkPolicy.ingress.grpc` and `networkPolicy.ingress.http` rules. This will only allow Pods which match the provided rules to connect to CockroachDB.


### Scaling

Scaling should typically be managed via the `helm upgrade` command, but StatefulSets don't yet work with `helm upgrade`. In the meantime until `helm upgrade` works, if you want to change the number of replicas, you can use the `kubectl scale` as shown below:
```shell
kubectl scale statefulset my-release-cockroachdb --replicas=4
```

Note, that if you are running in secure mode (`tls.enabled` is `yes`/`true`) and increase the size of your cluster, you will also have to approve the CSR (certificate-signing request) of each new node (using `kubectl get csr` and `kubectl certificate approve`).





[1]: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#inter-pod-affinity-and-anti-affinity
[2]: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#node-affinity
