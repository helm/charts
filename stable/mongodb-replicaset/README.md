# MongoDB Helm Chart

## Prerequisites Details

* Kubernetes 1.9+
* Kubernetes beta APIs enabled only if `podDisruptionBudget` is enabled
* PV support on the underlying infrastructure

## StatefulSet Details

* https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/

## StatefulSet Caveats

* https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/#limitations

## Chart Details

This chart implements a dynamically scalable [MongoDB replica set](https://docs.mongodb.com/manual/tutorial/deploy-replica-set/)
using Kubernetes StatefulSets and Init Containers.

## Installing the Chart

To install the chart with the release name `my-release`:

``` console
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm install --name my-release stable/mongodb-replicaset
```

## Configuration

The following table lists the configurable parameters of the mongodb chart and their default values.

| Parameter                           | Description                                                               | Default                                             |
| ----------------------------------- | ------------------------------------------------------------------------- | --------------------------------------------------- |
| `replicas`                          | Number of replicas in the replica set                                     | `3`                                                 |
| `replicaSetName`                    | The name of the replica set                                               | `rs0`                                               |
| `podDisruptionBudget`               | Pod disruption budget                                                     | `{}`                                                |
| `port`                              | MongoDB port                                                              | `27017`                                             |
| `imagePullSecrets`                  | Image pull secrets                                                        | `[]`                                                |
| `installImage.repository`           | Image name for the install container                                      | `unguiculus/mongodb-install`                        |
| `installImage.tag`                  | Image tag for the install container                                       | `0.7`                                               |
| `installImage.pullPolicy`           | Image pull policy for the init container that establishes the replica set | `IfNotPresent`                                      |
| `copyConfigImage.repository`        | Image name for the copy config init container                             | `busybox`                                           |
| `copyConfigImage.tag`               | Image tag for the copy config init container                              | `1.29.3`                                            |
| `copyConfigImage.pullPolicy`        | Image pull policy for the copy config init container                      | `IfNotPresent`                                      |
| `image.repository`                  | MongoDB image name                                                        | `mongo`                                             |
| `image.tag`                         | MongoDB image tag                                                         | `3.6`                                               |
| `image.pullPolicy`                  | MongoDB image pull policy                                                 | `IfNotPresent`                                      |
| `podAnnotations`                    | Annotations to be added to MongoDB pods                                   | `{}`                                                |
| `securityContext.enabled`           | Enable security context                                                   | `true`                                              |
| `securityContext.fsGroup`           | Group ID for the container                                                | `999`                                               |
| `securityContext.runAsUser`         | User ID for the container                                                 | `999`                                               |
| `securityContext.runAsNonRoot`      |                                                                           | `true`                                              |
| `resources`                         | Pod resource requests and limits                                          | `{}`                                                |
| `persistentVolume.enabled`          | If `true`, persistent volume claims are created                           | `true`                                              |
| `persistentVolume.storageClass`     | Persistent volume storage class                                           | ``                                                  |
| `persistentVolume.accessModes`      | Persistent volume access modes                                            | `[ReadWriteOnce]`                                   |
| `persistentVolume.size`             | Persistent volume size                                                    | `10Gi`                                              |
| `persistentVolume.annotations`      | Persistent volume annotations                                             | `{}`                                                |
| `terminationGracePeriodSeconds`     | Duration in seconds the pod needs to terminate gracefully                 | `30`                                                |
| `tls.enabled`                       | Enable MongoDB TLS support including authentication                       | `false`                                             |
| `tls.cacert`                        | The CA certificate used for the members                                   | Our self signed CA certificate                      |
| `tls.cakey`                         | The CA key used for the members                                           | Our key for the self signed CA certificate          |
| `init.resources`                    | Pod resource requests and limits (for init containers)                    | `{}`                                                |
| `init.timeout`                      | The amount of time in seconds to wait for bootstrap to finish             | `900`                                               |
| `metrics.enabled`                   | Enable Prometheus compatible metrics for pods and replicasets             | `false`                                             |
| `metrics.image.repository`          | Image name for metrics exporter                                           | `bitnami/mongodb-exporter`                         |
| `metrics.image.tag`                 | Image tag for metrics exporter                                            | `0.6.1`                                             |
| `metrics.image.pullPolicy`          | Image pull policy for metrics exporter                                    | `IfNotPresent`                                      |
| `metrics.port`                      | Port for metrics exporter                                                 | `9216`                                              |
| `metrics.path`                      | URL Path to expose metics                                                 | `/metrics`                                          |
| `metrics.resources`                 | Metrics pod resource requests and limits                                  | `{}`                                                |
| `metrics.socketTimeout`             | Time to wait for a non-responding socket                                  | `3s`                                                |
| `metrics.syncTimeout`               | Time an operation with this session will wait before returning an error   | `1m`                                                |
| `metrics.prometheusServiceDiscovery`| Adds annotations for Prometheus ServiceDiscovery                          | `true`                                              |
| `auth.enabled`                      | If `true`, keyfile access control is enabled                              | `false`                                             |
| `auth.key`                          | Key for internal authentication                                           | ``                                                  |
| `auth.existingKeySecret`            | If set, an existing secret with this name for the key is used             | ``                                                  |
| `auth.adminUser`                    | MongoDB admin user                                                        | ``                                                  |
| `auth.adminPassword`                | MongoDB admin password                                                    | ``                                                  |
| `auth.metricsUser`                  | MongoDB clusterMonitor user                                               | ``                                                  |
| `auth.metricsPassword`              | MongoDB clusterMonitor password                                           | ``                                                  |
| `auth.existingMetricsSecret`        | If set, and existing secret with this name is used for the metrics user   | ``                                                  |
| `auth.existingAdminSecret`          | If set, and existing secret with this name is used for the admin user     | ``                                                  |
| `serviceAnnotations`                | Annotations to be added to the service                                    | `{}`                                                |
| `configmap`                         | Content of the MongoDB config file                                        | ``                                                  |
| `initMongodStandalone`              | If set, initContainer executes script in standalone mode                  | ``                                                  |
| `nodeSelector`                      | Node labels for pod assignment                                            | `{}`                                                |
| `affinity`                          | Node/pod affinities                                                       | `{}`                                                |
| `tolerations`                       | List of node taints to tolerate                                           | `[]`                                                |
| `priorityClassName`                 | Pod priority class name                                                   | ``                                                  |
| `livenessProbe.failureThreshold`    | Liveness probe failure threshold                                          | `3`                                                 |
| `livenessProbe.initialDelaySeconds` | Liveness probe initial delay seconds                                      | `30`                                                |
| `livenessProbe.periodSeconds`       | Liveness probe period seconds                                             | `10`                                                |
| `livenessProbe.successThreshold`    | Liveness probe success threshold                                          | `1`                                                 |
| `livenessProbe.timeoutSeconds`      | Liveness probe timeout seconds                                            | `5`                                                 |
| `readinessProbe.failureThreshold`   | Readiness probe failure threshold                                         | `3`                                                 |
| `readinessProbe.initialDelaySeconds`| Readiness probe initial delay seconds                                     | `5`                                                 |
| `readinessProbe.periodSeconds`      | Readiness probe period seconds                                            | `10`                                                |
| `readinessProbe.successThreshold`   | Readiness probe success threshold                                         | `1`                                                 |
| `readinessProbe.timeoutSeconds`     | Readiness probe timeout seconds                                           | `1`                                                 |
| `extraVars`                         | Set environment variables for the main container                          | `{}`                                                |
| `extraLabels`                       | Additional labels to add to resources                                     | `{}`                                                |

*MongoDB config file*

All options that depended on the chart configuration are supplied as command-line arguments to `mongod`. By default, the chart creates an empty config file. Entries may be added via  the `configmap` configuration value.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

``` console
helm install --name my-release -f values.yaml stable/mongodb-replicaset
```

> **Tip**: You can use the default [values.yaml](values.yaml)

Once you have all 3 nodes in running, you can run the "test.sh" script in this directory, which will insert a key into the primary and check the secondaries for output. This script requires that the `$RELEASE_NAME` environment variable be set, in order to access the pods.

## Authentication

By default, this chart creates a MongoDB replica set without authentication. Authentication can be
enabled using the parameter `auth.enabled`. Once enabled, keyfile access control is set up and an
admin user with root privileges is created. User credentials and keyfile may be specified directly.
Alternatively, existing secrets may be provided. The secret for the admin user must contain the
keys `user` and `password`, that for the key file must contain `key.txt`.  The user is created with
full `root` permissions but is restricted to the `admin` database for security purposes. It can be
used to create additional users with more specific permissions.

To connect to the mongo shell with authentication enabled, use a command similar to the following (substituting values as appropriate):

```shell
kubectl exec -it mongodb-replicaset-0 -- mongo mydb -u admin -p password --authenticationDatabase admin
```

## TLS support

To enable full TLS encryption set `tls.enabled` to `true`. It is recommended to create your own CA by executing:

```console
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -days 10000 -out ca.crt -subj "/CN=mydomain.com"
```

After that paste the base64 encoded (`cat ca.key | base64 -w0`) cert and key into the fields `tls.cacert` and
`tls.cakey`. Adapt the configmap for the replicaset as follows:

```yml
configmap:
  storage:
    dbPath: /data/db
  net:
    port: 27017
    ssl:
      mode: requireSSL
      CAFile: /data/configdb/tls.crt
      PEMKeyFile: /work-dir/mongo.pem
      # Set to false to require mutual TLS encryption
      allowConnectionsWithoutCertificates: true
  replication:
    replSetName: rs0
  security:
    authorization: enabled
    # # Uncomment to enable mutual TLS encryption
    # clusterAuthMode: x509
    keyFile: /keydir/key.txt
```

To access the cluster you need one of the certificates generated during cluster setup in `/work-dir/mongo.pem` of the
certain container or you generate your own one via:

```console
$ cat >openssl.cnf <<EOL
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $HOSTNAME1
DNS.1 = $HOSTNAME2
EOL
$ openssl genrsa -out mongo.key 2048
$ openssl req -new -key mongo.key -out mongo.csr -subj "/CN=$HOSTNAME" -config openssl.cnf
$ openssl x509 -req -in mongo.csr \
    -CA $MONGOCACRT -CAkey $MONGOCAKEY -CAcreateserial \
    -out mongo.crt -days 3650 -extensions v3_req -extfile openssl.cnf
$ rm mongo.csr
$ cat mongo.crt mongo.key > mongo.pem
$ rm mongo.key mongo.crt
```

Please ensure that you exchange the `$HOSTNAME` with your actual hostname and the `$HOSTNAME1`, `$HOSTNAME2`, etc. with
alternative hostnames you want to allow access to the MongoDB replicaset. You should now be able to authenticate to the
mongodb with your `mongo.pem` certificate:

```console
mongo --ssl --sslCAFile=ca.crt --sslPEMKeyFile=mongo.pem --eval "db.adminCommand('ping')"
```

## Promethus metrics

Enabling the metrics as follows will allow for each replicaset pod to export Prometheus compatible metrics
on server status, individual replicaset information, replication oplogs, and storage engine.

```yaml
metrics:
  enabled: true
  image:
    repository: ssalaues/mongodb-exporter
    tag: 0.6.1
    pullPolicy: IfNotPresent
  port: 9216
  path: "/metrics"
  socketTimeout: 3s
  syncTimeout: 1m
  prometheusServiceDiscovery: true
  resources: {}
```

More information on [MongoDB Exporter](https://github.com/percona/mongodb_exporter) metrics available.

## Deep dive

Because the pod names are dependent on the name chosen for it, the following examples use the
environment variable `RELEASENAME`. For example, if the helm release name is `messy-hydra`, one would need to set the following before proceeding. The example scripts below assume 3 pods only.

```console
export RELEASE_NAME=messy-hydra
```

### Cluster Health

```console
for i in 0 1 2; do kubectl exec $RELEASE_NAME-mongodb-replicaset-$i -- sh -c 'mongo --eval="printjson(db.serverStatus())"'; done
```

### Failover

One can check the roles being played by each node by using the following:

```console
$ for i in 0 1 2; do kubectl exec $RELEASE_NAME-mongodb-replicaset-$i -- sh -c 'mongo --eval="printjson(rs.isMaster())"'; done

MongoDB shell version: 3.6.3
connecting to: mongodb://127.0.0.1:27017
MongoDB server version: 3.6.3
{
  "hosts" : [
    "messy-hydra-mongodb-0.messy-hydra-mongodb.default.svc.cluster.local:27017",
    "messy-hydra-mongodb-1.messy-hydra-mongodb.default.svc.cluster.local:27017",
    "messy-hydra-mongodb-2.messy-hydra-mongodb.default.svc.cluster.local:27017"
  ],
  "setName" : "rs0",
  "setVersion" : 3,
  "ismaster" : true,
  "secondary" : false,
  "primary" : "messy-hydra-mongodb-0.messy-hydra-mongodb.default.svc.cluster.local:27017",
  "me" : "messy-hydra-mongodb-0.messy-hydra-mongodb.default.svc.cluster.local:27017",
  "electionId" : ObjectId("7fffffff0000000000000001"),
  "maxBsonObjectSize" : 16777216,
  "maxMessageSizeBytes" : 48000000,
  "maxWriteBatchSize" : 1000,
  "localTime" : ISODate("2016-09-13T01:10:12.680Z"),
  "maxWireVersion" : 4,
  "minWireVersion" : 0,
  "ok" : 1
}
```

This lets us see which member is primary.

Let us now test persistence and failover. First, we insert a key (in the below example, we assume pod 0 is the master):

```console
$ kubectl exec $RELEASE_NAME-mongodb-replicaset-0 -- mongo --eval="printjson(db.test.insert({key1: 'value1'}))"

MongoDB shell version: 3.6.3
connecting to: mongodb://127.0.0.1:27017
{ "nInserted" : 1 }
```

Watch existing members:

```console
$ kubectl run --attach bbox --image=mongo:3.6 --restart=Never --env="RELEASE_NAME=$RELEASE_NAME" -- sh -c 'while true; do for i in 0 1 2; do echo $RELEASE_NAME-mongodb-replicaset-$i $(mongo --host=$RELEASE_NAME-mongodb-replicaset-$i.$RELEASE_NAME-mongodb-replicaset --eval="printjson(rs.isMaster())" | grep primary); sleep 1; done; done';

Waiting for pod default/bbox2 to be running, status is Pending, pod ready: false
If you don't see a command prompt, try pressing enter.
messy-hydra-mongodb-2 "primary" : "messy-hydra-mongodb-0.messy-hydra-mongodb.default.svc.cluster.local:27017",
messy-hydra-mongodb-0 "primary" : "messy-hydra-mongodb-0.messy-hydra-mongodb.default.svc.cluster.local:27017",
messy-hydra-mongodb-1 "primary" : "messy-hydra-mongodb-0.messy-hydra-mongodb.default.svc.cluster.local:27017",
messy-hydra-mongodb-2 "primary" : "messy-hydra-mongodb-0.messy-hydra-mongodb.default.svc.cluster.local:27017",
messy-hydra-mongodb-0 "primary" : "messy-hydra-mongodb-0.messy-hydra-mongodb.default.svc.cluster.local:27017",

```

Kill the primary and watch as a new master getting elected.

```console
$ kubectl delete pod $RELEASE_NAME-mongodb-replicaset-0

pod "messy-hydra-mongodb-0" deleted
```

Delete all pods and let the statefulset controller bring it up.

```console
$ kubectl delete po -l "app=mongodb-replicaset,release=$RELEASE_NAME"
$ kubectl get po --watch-only
NAME                    READY     STATUS        RESTARTS   AGE
messy-hydra-mongodb-0   0/1       Pending   0         0s
messy-hydra-mongodb-0   0/1       Pending   0         0s
messy-hydra-mongodb-0   0/1       Pending   0         7s
messy-hydra-mongodb-0   0/1       Init:0/2   0         7s
messy-hydra-mongodb-0   0/1       Init:1/2   0         27s
messy-hydra-mongodb-0   0/1       Init:1/2   0         28s
messy-hydra-mongodb-0   0/1       PodInitializing   0         31s
messy-hydra-mongodb-0   0/1       Running   0         32s
messy-hydra-mongodb-0   1/1       Running   0         37s
messy-hydra-mongodb-1   0/1       Pending   0         0s
messy-hydra-mongodb-1   0/1       Pending   0         0s
messy-hydra-mongodb-1   0/1       Init:0/2   0         0s
messy-hydra-mongodb-1   0/1       Init:1/2   0         20s
messy-hydra-mongodb-1   0/1       Init:1/2   0         21s
messy-hydra-mongodb-1   0/1       PodInitializing   0         24s
messy-hydra-mongodb-1   0/1       Running   0         25s
messy-hydra-mongodb-1   1/1       Running   0         30s
messy-hydra-mongodb-2   0/1       Pending   0         0s
messy-hydra-mongodb-2   0/1       Pending   0         0s
messy-hydra-mongodb-2   0/1       Init:0/2   0         0s
messy-hydra-mongodb-2   0/1       Init:1/2   0         21s
messy-hydra-mongodb-2   0/1       Init:1/2   0         22s
messy-hydra-mongodb-2   0/1       PodInitializing   0         25s
messy-hydra-mongodb-2   0/1       Running   0         26s
messy-hydra-mongodb-2   1/1       Running   0         30s


...
messy-hydra-mongodb-0 "primary" : "messy-hydra-mongodb-0.messy-hydra-mongodb.default.svc.cluster.local:27017",
messy-hydra-mongodb-1 "primary" : "messy-hydra-mongodb-0.messy-hydra-mongodb.default.svc.cluster.local:27017",
messy-hydra-mongodb-2 "primary" : "messy-hydra-mongodb-0.messy-hydra-mongodb.default.svc.cluster.local:27017",
```

Check the previously inserted key:

```console
$ kubectl exec $RELEASE_NAME-mongodb-replicaset-1 -- mongo --eval="rs.slaveOk(); db.test.find({key1:{\$exists:true}}).forEach(printjson)"

MongoDB shell version: 3.6.3
connecting to: mongodb://127.0.0.1:27017
{ "_id" : ObjectId("57b180b1a7311d08f2bfb617"), "key1" : "value1" }
```

### Scaling

Scaling should be managed by `helm upgrade`, which is the recommended way.

### Indexes and Maintenance

You can run Mongo in standalone mode and execute Javascript code on each replica at initContainer time using `initMongodStandalone`.
This allows you to create indexes on replicasets following [best practices](https://docs.mongodb.com/manual/tutorial/build-indexes-on-replica-sets/).

#### Example: Creating Indexes

```js
initMongodStandalone: |+
  db = db.getSiblingDB("mydb")
  db.my_users.createIndex({email: 1})
```

Tail the logs to debug running indexes or to follow their progress

```sh
kubectl exec -it $RELEASE-mongodb-replicaset-0 -c bootstrap -- tail -f /work-dir/log.txt
```
