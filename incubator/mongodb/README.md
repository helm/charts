# MongoDB Helm Chart

## Prerequisites Details
* Kubernetes 1.3 with alpha APIs enable
* PV support on the underlying infrastructure

## PetSet Details
* http://kubernetes.io/docs/user-guide/petset/

## PetSet Caveats
* http://kubernetes.io/docs/user-guide/petset/#alpha-limitations

# TODO
* Set up authorization between replicaset peers.
* Set up sharding.

## Chart Details

This chart implements a dynamically scalable mongoDB replicaset 
using Kubernetes PetSets.

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```bash
$ git clone https://github.com/kubernetes/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release mongodb-x.x.x.tgz
```

## Configuration

The following tables lists the configurable parameters of the etcd chart and their default values.

|       Parameter       |           Description            |                         Default                          |
|-----------------------|----------------------------------|----------------------------------------------------------|
| `Name`         | Name of the chart                | `etcd`                                           |
| `Image`        | Container image name             | `mongo`                         |
| `ImageTag`     | Container image tag              | `3.2`                                               |
| `ImagePullPolicy`     | Container pull policy     | `Always`                                               |
| `Replicas`     | k8s petset replicas          | `3`                                                      |
| `Component`    | k8s selector key                 | `mongodb`                                           |
| `Cpu`          | container requested cpu          | `100m`                                                   |
| `Memory`    |container requested memory                 | `512Mi`                                           |
| `ClientPort`  | k8s service port                 | `2379`                                                   |
| `PeerPorts`| Container listening port         | `27017`                                                   |
| `Storage`| Persistent volume size         | `10Gi`                                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml mongodb-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)

Once you have all 3 nodes in running, you can run the "test.sh" script in this directory, which will insert a key into the primary and check the secondaries for output.

# Deep dive

## Cluster Health

```
$ for i in <0..n>; do kubectl exec <release-podname-$i> -- sh -c '/usr/bin/mongo --eval="printjson(db.serverStatus())"'; done
```

## Failover

One can check the roles being played by each node by using the following:
```console
$ for i in <0..n>; do kubectl exec <release-podname-$i> -- sh -c '/usr/bin/mongo --eval="printjson(rs.isMaster())"'; done

MongoDB shell version: 3.2.9
connecting to: test
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
$ kubectl exec <$release-mongodb-0> -- /usr/bin/mongo --eval="printjson(db.test.insert({key1: 'value1'}))"

MongoDB shell version: 3.2.8
connecting to: test
{ "nInserted" : 1 }
```

Watch existing members:
```console
$ kubectl run --attach bbox --image=mongo:3.2 --restart=Never -- sh -c 'while true; do for i in 0 1 2; do echo <$release-podname-$i> $(mongo --host=<$release-mongodb-$i>.<$release-mongodb> --eval="printjson(rs.isMaster())" | grep primary); sleep 1; done; done';

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
$ kubectl delete pod <release-mongodb-0>

pod "messy-hydra-mongodb-0" deleted
```

Delete all pods and let the petset controller bring it up.
```console
$ kubectl delete po -l app=mongodb
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
$ kubectl exec $release-mongodb-1 -- /usr/bin/mongo --eval="rs.slaveOk(); db.test.find({key1:{\$exists:true}}).forEach(printjson)"

MongoDB shell version: 3.2.8
connecting to: test
{ "_id" : ObjectId("57b180b1a7311d08f2bfb617"), "key1" : "value1" }
```

## Scaling

Scaling should be managed by `helm upgrade`, which is the recommended way. 
You can also scale up by modifying the number of replicas on the PetSet using `kubectl patch` or `kubectl apply`.