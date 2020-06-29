# CockroachDB Helm Chart


## This Helm chart is deprecated

Given the [deprecation of `stable`](https://github.com/helm/charts#deprecation-timeline), future CockroachDB Helm charts are now located at [cockroachdb/charts](https://github.com/cockroachdb/helm-charts/).

The CockroachDB charts repository is already included in the Hubs. Updated installation instructions are included in the new [source code repository README](https://github.com/cockroachdb/helm-charts/blob/master/README.md).

To update an exisiting _stable_ deployment with a chart hosted in the CockroachDB repository, you can run:

```bash
$ helm repo add cockroachdb https://charts.cockroachdb.com/
$ helm upgrade my-release cockroachdb/cockroachdb
```


## Documentation

Below is a brief overview of operating the CockroachDB Helm Chart and some specific implementation details. For additional information on deploying CockroachDB, please see:
> https://www.cockroachlabs.com/docs/stable/orchestrate-cockroachdb-with-kubernetes.html

Note that the documentation requires Helm 3.0 or higher.


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
helm install my-release stable/cockroachdb
```

Note that for a production cluster, you will likely want to override the following parameters in [`values.yaml`](values.yaml) with your own values.

- `statefulset.resources.requests.memory` and `statefulset.resources.limits.memory` allocate memory resources to CockroachDB pods in your cluster.
- `conf.cache` and `conf.max-sql-memory` are memory limits that we recommend setting to 1/4 of the above resource allocation. When running CockroachDB, you must set these limits explicitly to avoid running out of memory.
- `storage.persistentVolume.size` defaults to `100Gi` of disk space per pod, which you may increase or decrease for your use case.
- `storage.persistentVolume.storageClass` uses the default storage class for your environment. We strongly recommend that you specify a storage class which uses an SSD.
- `tls.enabled` must be set to `yes`/`true` to deploy in secure mode.

For more information on overriding the `values.yaml` parameters, please see:
> https://www.cockroachlabs.com/docs/stable/orchestrate-cockroachdb-with-kubernetes.html#step-2-start-cockroachdb

If you are running in secure mode (with configuration parameter `tls.enabled` set to `yes`/`true`) and `tls.certs.provided` set to `no`/`false`), then you will have to manually approve the cluster's security certificates as the pods are created. You can see the pending CSRs (certificate signing requests) by running `kubectl get csr`, and approve them by running `kubectl certificate approve <csr-name>`. You'll have to approve one certificate for each CockroachDB node (e.g., `default.node.my-release-cockroachdb-0` and one client certificate for the job that initializes the cluster (e.g., `default.node.root`).

When `tls.certs.provided` is set to `yes`/`true`, this chart will use certificates created outside of Kubernetes. You may want to use this if you want to use a different certificate authority from the one being used by Kubernetes or if your Kubernetes cluster doesn't fully support certificate-signing requests. To use this, first set up your certificates and load them into your Kubernetes cluster as Secrets using the commands below:
```
mkdir certs
mkdir my-safe-directory
cockroach cert create-ca --certs-dir=certs --ca-key=my-safe-directory/ca.key
cockroach cert create-client root --certs-dir=certs --ca-key=my-safe-directory/ca.key
kubectl create secret generic cockroachdb-root --from-file=certs
cockroach cert create-node --certs-dir=certs --ca-key=my-safe-directory/ca.key localhost 127.0.0.1 eerie-horse-cockroachdb-public eerie-horse-cockroachdb-public.default eerie-horse-cockroachdb-public.default.svc.cluster.local *.eerie-horse-cockroachdb *.eerie-horse-cockroachdb.default *.eerie-horse-cockroachdb.default.svc.cluster.local
kubectl create secret generic cockroachdb-node --from-file=certs
```

Set `tls.certs.tlsSecret` to `yes/true` if you make use of [cert-manager][3] in your cluster.

[cert-manager][3] stores generated certificates in dedicated TLS secrets. Thus, they are always named:
* `ca.crt`
* `tls.crt`
* `tls.key`

On the other hand, CockroachDB also demands dedicated certificate filenames:
* `ca.crt`
* `node.crt`
* `node.key`
* `client.root.crt`
* `client.root.key`

By activating `tls.certs.tlsSecret` we benefit from projected secrets and convert the TLS secret filenames to their according CockroachDB filenames.

If you are running in secure mode, then you will have to manually approve the cluster's security certificates as the pods are created. You can see the pending CSRs (certificate signing requests) by running `kubectl get csr`, and approve them by running `kubectl certificate approve <csr-name>`. You'll have to approve one certificate for each CockroachDB node (e.g., `default.node.my-release-cockroachdb-0` and one client certificate for the job that initializes the cluster (e.g., `default.node.root`).

Confirm that all pods are `Running` successfully and init has been completed:
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

Confirm that persistent volumes are created and claimed for each pod:
```shell
kubectl get pv
```
```
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS    CLAIM                                      STORAGECLASS   REASON    AGE
pvc-64878ebf-f3f0-11e8-ab5b-42010a8e0035   100Gi      RWO            Delete           Bound     default/datadir-my-release-cockroachdb-0   standard                 51s
pvc-64945b4f-f3f0-11e8-ab5b-42010a8e0035   100Gi      RWO            Delete           Bound     default/datadir-my-release-cockroachdb-1   standard                 51s
pvc-649d920d-f3f0-11e8-ab5b-42010a8e0035   100Gi      RWO            Delete           Bound     default/datadir-my-release-cockroachdb-2   standard                 51s
```




## Upgrading the cluster


### Chart version 3.0.0 and after

Launch a temporary interactive pod and start the built-in SQL client:
```shell
kubectl run cockroachdb --rm -it \
--image=cockroachdb/cockroach \
--restart=Never \
-- sql --insecure --host=my-release-cockroachdb-public
```

> If you are running in secure mode, you will have to provide a client certificate to the cluster in order to authenticate, so the above command will not work. See [here](https://github.com/cockroachdb/cockroach/blob/master/cloud/kubernetes/client-secure.yaml) for an example of how to set up an interactive SQL shell against a secure cluster or [here](https://github.com/cockroachdb/cockroach/blob/master/cloud/kubernetes/example-app-secure.yaml) for an example application connecting to a secure cluster.

Set `cluster.preserve_downgrade_option`, where `$current_version` is the CockroachDB version currently running (e.g., `19.2`):
```sql
> SET CLUSTER SETTING cluster.preserve_downgrade_option = '$current_version';
```

Exit the shell and delete the temporary pod:
```sql
> \q
```

Kick off the upgrade process by changing the new Docker image, where `$new_version` is the CockroachDB version to which you are upgrading:
```shell
kubectl delete job my-release-cockroachdb-init
```
```shell
helm upgrade my-release stable/cockroachdb \
--set image.tag=$new_version \
--reuse-values
```

Kubernetes will carry out a safe [rolling upgrade](https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#updating-statefulsets) of your CockroachDB nodes one-by-one. Monitor the cluster's pods until all have been successfully restarted:
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
my-release-cockroachdb-0    cockroachdb/cockroach:v19.2.5
my-release-cockroachdb-1    cockroachdb/cockroach:v19.2.5
my-release-cockroachdb-2    cockroachdb/cockroach:v19.2.5
my-release-cockroachdb-3    cockroachdb/cockroach:v19.2.5
```

Resume normal operations. Once you are comfortable that the stability and performance of the cluster is what you'd expect post-upgrade, finalize the upgrade:
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

### Chart versions prior to 3.0.0

Due to a change in the label format in version 3.0.0 of this chart, upgrading requires that you delete the StatefulSet. Luckily there is a way to do it without actually deleting all the resources managed by the StatefulSet. Use the workaround below to upgrade from charts versions previous to 3.0.0:

Get the new labels from the specs rendered by Helm:
```shell
helm template -f deploy.vals.yml stable/cockroachdb -x templates/statefulset.yaml \
| yq r - spec.template.metadata.labels
```
```
app.kubernetes.io/name: cockroachdb
app.kubernetes.io/instance: my-release
app.kubernetes.io/component: cockroachdb
```

Place the new labels on all pods of the StatefulSet (change `my-release-cockroachdb-0` to the name of each pod):
```shell
kubectl label pods my-release-cockroachdb-0 \
app.kubernetes.io/name=cockroachdb \
app.kubernetes.io/instance=my-release \
app.kubernetes.io/component=cockroachdb
```

Delete the StatefulSet without deleting pods:
```shell
kubectl delete statefulset my-release-cockroachdb --cascade=false
```

Verify that no pod is deleted and then upgrade as normal. A new StatefulSet will be created, taking over the management of the existing pods and upgrading them if needed.




## Configuration

The following table lists the configurable parameters of the CockroachDB chart and their default values.
For details see the [`values.yaml`](values.yaml) file.

| Parameter                                | Description                                                     | Default                                          |
| ---------                                | -----------                                                     | -------                                          |
| `clusterDomain`                          | Cluster's default DNS domain                                    | `cluster.local`                                  |
| `conf.attrs`                             | CockroachDB node attributes                                     | `[]`                                             |
| `conf.cache`                             | Size of CockroachDB's in-memory cache                           | `25%`                                            |
| `conf.cluster-name`                      | Name of CockroachDB cluster                                     | `""`                                             |
| `conf.disable-cluster-name-verification` | Disable CockroachDB cluster name verification                   | `no`                                             |
| `conf.join`                              | List of already-existing CockroachDB instances                  | `[]`                                             |
| `conf.max-disk-temp-storage`             | Max storage capacity for temp data                              | `0`                                              |
| `conf.max-offset`                        | Max allowed clock offset for CockroachDB cluster                | `500ms`                                          |
| `conf.max-sql-memory`                    | Max memory to use processing SQL querie                         | `25%`                                            |
| `conf.locality`                          | Locality attribute for this deployment                          | `""`                                             |
| `conf.single-node`                       | Disable CockroachDB clustering (standalone mode)                | `no`                                             |
| `conf.sql-audit-dir`                     | Directory for SQL audit log                                     | `""`                                             |
| `conf.port`                              | CockroachDB primary serving port in Pods                        | `26257`                                          |
| `conf.http-port`                         | CockroachDB HTTP port in Pods                                   | `8080`                                           |
| `image.repository`                       | Container image name                                            | `cockroachdb/cockroach`                          |
| `image.tag`                              | Container image tag                                             | `v19.2.5`                                        |
| `image.pullPolicy`                       | Container pull policy                                           | `IfNotPresent`                                   |
| `image.credentials`                      | `registry`, `user` and `pass` credentials to pull private image | `{}`                                             |
| `statefulset.replicas`                   | StatefulSet replicas number                                     | `3`                                              |
| `statefulset.updateStrategy`             | Update strategy for StatefulSet Pods                            | `{"type": "RollingUpdate"}`                      |
| `statefulset.podManagementPolicy`        | `OrderedReady`/`Parallel` Pods creation/deletion order          | `Parallel`                                       |
| `statefulset.budget.maxUnavailable`      | k8s PodDisruptionBudget parameter                               | `1`                                              |
| `statefulset.args`                       | Extra command-line arguments                                    | `[]`                                             |
| `statefulset.env`                        | Extra env vars                                                  | `[]`                                             |
| `statefulset.secretMounts`               | Additional Secrets to mount at cluster members                  | `[]`                                             |
| `statefulset.labels`                     | Additional labels of StatefulSet and its Pods                   | `{"app.kubernetes.io/component": "cockroachdb"}` |
| `statefulset.annotations`                | Additional annotations of StatefulSet Pods                      | `{}`                                             |
| `statefulset.nodeAffinity`               | [Node affinity rules][2] of StatefulSet Pods                    | `{}`                                             |
| `statefulset.podAffinity`                | [Inter-Pod affinity rules][1] of StatefulSet Pods               | `{}`                                             |
| `statefulset.podAntiAffinity`            | [Anti-affinity rules][1] of StatefulSet Pods                    | auto                                             |
| `statefulset.podAntiAffinity.type`       | Type of auto [anti-affinity rules][1]                           | `soft`                                           |
| `statefulset.podAntiAffinity.weight`     | Weight for `soft` auto [anti-affinity rules][1]                 | `100`                                            |
| `statefulset.nodeSelector`               | Node labels for StatefulSet Pods assignment                     | `{}`                                             |
| `statefulset.tolerations`                | Node taints to tolerate by StatefulSet Pods                     | `[]`                                             |
| `statefulset.resources`                  | Resource requests and limits for StatefulSet Pods               | `{}`                                             |
| `service.ports.grpc.external.port`       | CockroachDB primary serving port in Services                    | `26257`                                          |
| `service.ports.grpc.external.name`       | CockroachDB primary serving port name in Services               | `grpc`                                           |
| `service.ports.grpc.internal.port`       | CockroachDB inter-communication port in Services                | `26257`                                          |
| `service.ports.grpc.internal.name`       | CockroachDB inter-communication port name in Services           | `grpc-internal`                                  |
| `service.ports.http.port`                | CockroachDB HTTP port in Services                               | `8080`                                           |
| `service.ports.http.name`                | CockroachDB HTTP port name in Services                          | `http`                                           |
| `service.public.type`                    | Public Service type                                             | `ClusterIP`                                      |
| `service.public.labels`                  | Additional labels of public Service                             | `{"app.kubernetes.io/component": "cockroachdb"}` |
| `service.public.annotations`             | Additional annotations of public Service                        | `{}`                                             |
| `service.discovery.labels`               | Additional labels of discovery Service                          | `{"app.kubernetes.io/component": "cockroachdb"}` |
| `service.discovery.annotations`          | Additional annotations of discovery Service                     | `{}`                                             |
| `storage.hostPath`                       | Absolute path on host to store data                             | `""`                                             |
| `storage.persistentVolume.enabled`       | Whether to use PersistentVolume to store data                   | `yes`                                            |
| `storage.persistentVolume.size`          | PersistentVolume size                                           | `100Gi`                                          |
| `storage.persistentVolume.storageClass`  | PersistentVolume class                                          | `""`                                             |
| `storage.persistentVolume.labels`        | Additional labels of PersistentVolumeClaim                      | `{}`                                             |
| `storage.persistentVolume.annotations`   | Additional annotations of PersistentVolumeClaim                 | `{}`                                             |
| `init.labels`                            | Additional labels of init Job and its Pod                       | `{"app.kubernetes.io/component": "init"}`        |
| `init.annotations`                       | Additional labels of the Pod of init Job                        | `{}`                                             |
| `init.affinity`                          | [Affinity rules][2] of init Job Pod                             | `{}`                                             |
| `init.nodeSelector`                      | Node labels for init Job Pod assignment                         | `{}`                                             |
| `init.tolerations`                       | Node taints to tolerate by init Job Pod                         | `[]`                                             |
| `init.resources`                         | Resource requests and limits for the Pod of init Job            | `{}`                                             |
| `tls.enabled`                            | Whether to run securely using TLS certificates                  | `no`                                             |
| `tls.serviceAccount.create`              | Whether to create a new RBAC service account                    | `yes`                                            |
| `tls.serviceAccount.name`                | Name of RBAC service account to use                             | `""`                                             |
| `tls.certs.provided`                     | Bring your own certs scenario, i.e certificates are provided    | `no`                                             |
| `tls.certs.clientRootSecret`             | If certs are provided, secret name for client root cert         | `cockroachdb-root`                               |
| `tls.certs.nodeSecret`                   | If certs are provided, secret name for node cert                | `cockroachdb-node`                               |
| `tls.certs.tlsSecret`                    | Own certs are stored in TLS secret                              | `no`                                             |
| `tls.init.image.repository`              | Image to use for requesting TLS certificates                    | `cockroachdb/cockroach-k8s-request-cert`         |
| `tls.init.image.tag`                     | Image tag to use for requesting TLS certificates                | `0.4`                                            |
| `tls.init.image.pullPolicy`              | Requesting TLS certificates container pull policy               | `IfNotPresent`                                   |
| `tls.init.image.credentials`             | `registry`, `user` and `pass` credentials to pull private image | `{}`                                             |
| `networkPolicy.enabled`                  | Enable NetworkPolicy for CockroachDB's Pods                     | `no`                                             |
| `networkPolicy.ingress.grpc`             | Whitelist resources to access gRPC port of CockroachDB's Pods   | `[]`                                             |
| `networkPolicy.ingress.http`             | Whitelist resources to access gRPC port of CockroachDB's Pods   | `[]`                                             |

Override the default parameters using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies custom values for the parameters can be provided while installing the chart. For example:
```shell
helm install my-release -f my-values.yaml stable/cockroachdb
```

> **Tip**: You can use the default [values.yaml](values.yaml)




## Deep dive


### Connecting to the CockroachDB cluster

Once you've created the cluster, you can start talking to it by connecting to its `-public` Service. CockroachDB is PostgreSQL wire protocol compatible, so there's a [wide variety of supported clients](https://www.cockroachlabs.com/docs/install-client-drivers.html). As an example, we'll open up a SQL shell using CockroachDB's built-in shell and play around with it a bit, like this (likely needing to replace `my-release-cockroachdb-public` with the name of the `-public` Service that was created with your installed chart):
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

> If you are running in secure mode, you will have to provide a client certificate to the cluster in order to authenticate, so the above command will not work. See [here](https://github.com/cockroachdb/cockroach/blob/master/cloud/kubernetes/client-secure.yaml) for an example of how to set up an interactive SQL shell against a secure cluster or [here](https://github.com/cockroachdb/cockroach/blob/master/cloud/kubernetes/example-app-secure.yaml) for an example application connecting to a secure cluster.


### Cluster health

Because our pod spec includes regular health checks of the CockroachDB processes, simply running `kubectl get pods` and looking at the `STATUS` column is sufficient to determine the health of each instance in the cluster.

If you want more detailed information about the cluster, the best place to look is the Admin UI.


### Accessing the Admin UI

If you want to see information about how the cluster is doing, you can try pulling up the CockroachDB Admin UI by port-forwarding from your local machine to one of the pods (replacing `my-release-cockroachdb-0` with the name of one of your pods:
```shell
kubectl port-forward my-release-cockroachdb-0 8080
```

You should then be able to access the Admin UI by visiting http://localhost:8080/ in your web browser.


### Failover

If any CockroachDB member fails, it is restarted or recreated automatically by the Kubernetes infrastructure, and will re-join the cluster automatically when it comes back up. You can test this scenario by killing any of the CockroachDB pods:
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

You can check the state of re-joining from the new pod's logs:
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

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting the `DefaultDeny` Namespace annotation. Note: this will enforce policy for _all_ pods in the Namespace:
```shell
kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"
```

For more precise policy, set `networkPolicy.ingress.grpc` and `networkPolicy.ingress.http` rules. This will only allow pods that match the provided rules to connect to CockroachDB.


### Scaling

Scaling should be managed via the `helm upgrade` command. After resizing your cluster on your cloud environment (e.g., GKE or EKS), run the following command to add a pod. This assumes you scaled from 3 to 4 nodes:

```shell
helm upgrade \
my-release \
stable/cockroachdb \
--set statefulset.replicas=4 \
--reuse-values
```

Note, that if you are running in secure mode (`tls.enabled` is `yes`/`true`) and increase the size of your cluster, you will also have to approve the CSR (certificate-signing request) of each new node (using `kubectl get csr` and `kubectl certificate approve`).





[1]: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#inter-pod-affinity-and-anti-affinity
[2]: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#node-affinity
[3]: https://cert-manager.io/
