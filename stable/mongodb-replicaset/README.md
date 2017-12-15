# MongoDB Helm Chart

## Prerequisites Details
* Kubernetes 1.6+ with Beta APIs enabled.
* PV support on the underlying infrastructure.

## StatefulSet Details
* https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/

## StatefulSet Caveats
* https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/#limitations

## Chart Details

This chart implements a dynamically scalable [MongoDB replica set](https://docs.mongodb.com/manual/tutorial/deploy-replica-set/)
using Kubernetes StatefulSets and Init Containers.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add stable https://kubernetes-charts.storage.googleapis.com/
$ helm install --name my-release stable/mongodb-replicaset
```

## Configuration

The following tables lists the configurable parameters of the mongodb chart and their default values.

| Parameter                       | Description                                                               | Default                                             |
| ------------------------------- | ------------------------------------------------------------------------- | --------------------------------------------------- |
| `replicaSet`                    | Name of the replica set                                                   | rs0                                                 |
| `replicas`                      | Number of replicas in the replica set                                     | 3                                                   |
| `port`                          | MongoDB port                                                              | 27017                                               |
| `installImage.name`             | Image name for the init container that establishes the replica set        | gcr.io/google_containers/mongodb-install            |
| `installImage.tag`              | Image tag for the init container that establishes the replica set         | 0.3                                                 |
| `installImage.pullPolicy`       | Image pull policy for the init container that establishes the replica set | IfNotPresent                                        |
| `image.name`                    | MongoDB image name                                                        | mongo                                               |
| `image.tag`                     | MongoDB image tag                                                         | 3.4                                                 |
| `image.pullPolicy`              | MongoDB image pull policy                                                 | IfNotPresent                                        |
| `podAnnotations`                | Annotations to be added to MongoDB pods                                   | {}                                                  |
| `resources`                     | Pod resource requests and limits                                          | {}                                                  |
| `persistentVolume.enabled`      | If `true`, persistent volume claims are created                           | `true`                                              |
| `persistentVolume.storageClass` | Persistent volume storage class                                           | `volume.alpha.kubernetes.io/storage-class: default` |
| `persistentVolume.accessMode`   | Persistent volume access modes                                            | [ReadWriteOnce]                                     |
| `persistentVolume.size`         | Persistent volume size                                                    | 10Gi                                                |
| `persistentVolume.annotations`  | Persistent volume annotations                                             | {}                                                  |
| `tls.enabled`                   | Enable MongoDB TLS support including authentication                       | `false`                                             |
| `tls.cacert`                    | The CA certificate used for the members                                   | Our self signed CA certificate                      |
| `tls.cakey`                     | The CA key used for the members                                           | Our key for the self signed CA certificate          |
| `auth.enabled`                  | If `true`, keyfile access control is enabled                              | `false`                                             |
| `auth.key`                      | key for internal authentication                                           |                                                     |
| `auth.existingKeySecret`        | If set, an existing secret with this name for the key is used             |                                                     |
| `auth.adminUser`                | MongoDB admin user                                                        |                                                     |
| `auth.adminPassword`            | MongoDB admin password                                                    |                                                     |
| `auth.existingAdminSecret`      | If set, and existing secret with this name is used for the admin user     |                                                     |
| `serviceAnnotations`            | Annotations to be added to the service                                    | {}                                                  |
| `configmap`                     | Content of the MongoDB config file                                        | See below                                           |
| `nodeSelector`                  | Node labels for pod assignment                                            | {}                                                  |

*MongoDB config file*

The MongoDB config file `mongod.conf` is configured via the `configmap` configuration value. The defaults from 
`values.yaml` are the following:

```yaml
configmap:
  storage:
    dbPath: /data/db
  net:
    port: 27017
  replication:
    replSetName: rs0
```

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/mongodb-replicaset
```

> **Tip**: You can use the default [values.yaml](values.yaml)

Once you have all 3 nodes in running, you can run the "test.sh" script in this directory, which will insert a key into the primary and check the secondaries for output. This script requires that the `$RELEASE_NAME` environment variable be set, in order to access the pods.

## Authentication

By default, this chart creates a MongoDB replica set without authentication. Authentication can be enabled using the 
parameter `auth.enabled`. Once enabled, keyfile access control is set up and an admin user with root privileges
is created. User credentials and keyfile may be specified directly. Alternatively, existing secrets may be provided. 
The secret for the admin user must contain the keys `user` and `password`, that for the key file must contain `key.txt`.

## TLS support

To enable full TLS encryption set `tls.enabled` to `true`. It is recommended to create your own CA by executing:

```console
$ openssl genrsa -out ca.key 2048
$ openssl req -x509 -new -nodes -key ca.key -days 10000 -out ca.crt -subj "/CN=mydomain.com"
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
      CAFile: /ca/tls.crt
      PEMKeyFile: /work-dir/mongo.pem
  replication:
    replSetName: rs0
  security:
    authorization: enabled
    clusterAuthMode: x509
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
$ mongo --ssl --sslCAFile=ca.crt --sslPEMKeyFile=mongo.pem --eval "db.adminCommand('ping')"
```

## Deep dive

Because the pod names are dependent on the name chosen for it, the following examples use the
environment variable `RELEASENAME`. For example, if the helm release name is `messy-hydra`, one would need to set the following before proceeding. The example scripts below assume 3 pods only.

```console
export RELEASE_NAME=messy-hydra
```

### Cluster Health

```console
$ for i in 0 1 2; do kubectl exec $RELEASE_NAME-mongodb-replicaset-$i -- sh -c 'mongo --eval="printjson(db.serverStatus())"'; done
```

### Failover

One can check the roles being played by each node by using the following:
```console
$ for i in 0 1 2; do kubectl exec $RELEASE_NAME-mongodb-replicaset-$i -- sh -c 'mongo --eval="printjson(rs.isMaster())"'; done

MongoDB shell version: 3.4.5
connecting to: mongodb://127.0.0.1:27017
MongoDB server version: 3.4.5
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

MongoDB shell version: 3.4.5
connecting to: mongodb://127.0.0.1:27017
{ "nInserted" : 1 }
```

Watch existing members:
```console
$ kubectl run --attach bbox --image=mongo:3.4 --restart=Never --env="RELEASE_NAME=$RELEASE_NAME" -- sh -c 'while true; do for i in 0 1 2; do echo $RELEASE_NAME-mongodb-replicaset-$i $(mongo --host=$RELEASE_NAME-mongodb-replicaset-$i.$RELEASE_NAME-mongodb-replicaset --eval="printjson(rs.isMaster())" | grep primary); sleep 1; done; done';

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

MongoDB shell version: 3.4.5
connecting to: mongodb://127.0.0.1:27017
{ "_id" : ObjectId("57b180b1a7311d08f2bfb617"), "key1" : "value1" }
```

### Scaling

Scaling should be managed by `helm upgrade`, which is the recommended way.
