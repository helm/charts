# Patroni Helm Chart

This directory contains a Kubernetes chart to deploy a five node [Patroni](https://github.com/zalando/patroni/) cluster using a [Spilo](https://github.com/zalando/spilo) and a StatefulSet.

## Prerequisites Details
* Kubernetes 1.5
* PV support on the underlying infrastructure

## Statefulset Details
* https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/

## Statefulset Caveats
* https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#limitations

## Todo
* Make namespace configurable

## Chart Details
This chart will do the following:

* Implement a HA scalable PostgreSQL 10 cluster using a Kubernetes StatefulSet.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
$ helm dependency update
$ helm install --name my-release incubator/patroni
```

## Connecting to PostgreSQL

Your access point is a cluster IP. In order to access it spin up another pod:

```console
$ kubectl run -i --tty ubuntu --image=ubuntu:16.04 --restart=Never -- bash -il
```

Then, from inside the pod, connect to postgres:

```console
$ apt-get update && apt-get install postgresql-client -y
$ psql -U admin -h my-release-patroni.default.svc.cluster.local postgres
<admin password from values.yaml>
postgres=>
```

## Configuration

The following tables lists the configurable parameters of the patroni chart and their default values.

|       Parameter                   |           Description                     |                         Default                     |
|-----------------------------------|-------------------------------------------|-----------------------------------------------------|
| `name`                            | Service name                              | `patroni`                                           |
| `spilo.image`                     | Container image name                      | `registry.opensource.zalan.do/acid/spilo-10`        |
| `spilo.version`                   | Container image tag                       | `1.4-p4`                                            |
| `imagePullPolicy`                 | Container pull policy                     | `IfNotPresent`                                      |
| `replicas`                        | k8s statefulset replicas                  | `5`                                                 |
| `nodeSelector`                    | NodeSelector map                          | Empty                                               |
| `component`                       | k8s selector key                          | `patroni`                                           |
| `resources.cpu`                   | Container requested CPU                   | `100m`                                              |
| `resources.memory`                | Container requested memory                | `512Mi`                                             |
| `credentials.superuser`           | Password for the superuser                | `tea`                                               |
| `credentials.standby`             | password for the replication user         | `pinacolada`                                        |
| `etcd.enable`                     | Using etcd as DCS                         | `true`                                              |
| `etcd.deployChart`                | Deploy etcd chart                         | `true`                                              |
| `etcd.host`                       | Host name of etcd cluster                 | not used (`etcd.discovery`) is used instead)        |
| `etcd.discovery`                  | Domain name of etcd cluster               | `<release-name>-etcd.<namespace>.svc.cluster.local` |
| `zookeeper.enable`                | Using ZooKeeper as DCS                    | `false`                                             |
| `zookeeper.deployChart`           | Deploy ZooKeeper chart                    | `false`                                             |
| `zookeeper.hosts`                 | List of ZooKeeper cluster members         | 'host1:port1','host2:port2','etc...'                |
| `walE.enable`                     | Use of Wal-E tool for base backup/restore | `false`                                             |
| `walE.scheduleCronJob`            | Schedule of Wal-E backups                 | `00 01 * * *`                                       |
| `walE.retainBackups`              | Number of base backups to retain          | `2`                                                 |
| `walE.s3Bucket:`                  | Amazon S3 bucket used for wal-e backups   | ``                                                  |
| `walE.gcsBucket`                  | GCS storage used for Wal-E backups        | ``                                                  |
| `walE.kubernetesSecret`           | K8s secret name for provider bucket       | ``                                                  |
| `walE.backupThresholdMegabytes`   | Maximum size of the WAL segments accumulated after the base backup to consider WAL-E restore instead of pg_basebackup | `1024` |
| `walE.backupThresholdPercentage`  | Maximum ratio (in percents) of the accumulated WAL files to the base backup to consider WAL-E restore instead of pg_basebackup | `30` |
| `persistentVolume.accessModes`    | Persistent Volume access modes            | `[ReadWriteOnce]`                                   |
| `persistentVolume.annotations`    | Annotations for Persistent Volume Claim`  | `{}`                                                |
| `persistentVolume.mountPath`      | Persistent Volume mount root path         | `/home/postgres/pgdata`                             |
| `persistentVolume.size`           | Persistent Volume size                    | `2Gi`                                               |
| `persistentVolume.storageClass`   | Persistent Volume Storage Class           | `volume.alpha.kubernetes.io/storage-class: default` |
| `persistentVolume.subPath`        | Subdirectory of Persistent Volume to mount | `""` |
| `rbac.create`                     | Create required role and rolebindings     | `true`                                              |
| `serviceAccount.create`           | If true, create a new service account	    | `true`                                              |
| `serviceAccount.name`             | Service account to be used. If not set and serviceAccount.create is `true`, a name is generated using the fullname template | ``  

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/patroni
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Cleanup

In order to remove everything you created a simple `helm delete <release-name>` isn't enough (as of now), but you can do the following:

```console
$ release=<release-name>
$ helm delete $release
$ grace=$(kubectl get po $release-patroni-0 --template '{{.spec.terminationGracePeriodSeconds}}')
$ kubectl delete statefulset,po -l release=$release
$ sleep $grace
$ kubectl delete pvc -l release=$release
```

## Internals

Patroni is responsible for electing a PostgreSQL master pod by leveraging etcd.
It then exports this master via a Kubernetes service and a label query that filters for `spilo-role=master`.
This label is dynamically set on the pod that acts as the master and removed from all other pods.
Consequently, the service endpoint will point to the current master.

```console
$ kubectl get pods -l spilo-role -L spilo-role
NAME                   READY     STATUS    RESTARTS   AGE       SPILO-ROLE
my-release-patroni-0   1/1       Running   0          9m        replica
my-release-patroni-1   1/1       Running   0          9m        master
my-release-patroni-2   1/1       Running   0          8m        replica
my-release-patroni-3   1/1       Running   0          8m        replica
my-release-patroni-4   1/1       Running   0          8m        replica
```
