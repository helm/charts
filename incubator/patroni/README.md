# Patroni Helm Chart

This directory contains a Kubernetes chart to deploy a five node patroni cluster using a statefulset.

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

* Implement a HA scalable PostgreSQL cluster using Kubernetes PetSets

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
$ helm dependency update
$ helm install --name my-release incubator/patroni
```

## Connecting to Postgres

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

|       Parameter         |           Description               |                         Default                     |
|-------------------------|-------------------------------------|-----------------------------------------------------|
| `Name`                  | Service name                        | `patroni`                                           |
| `Spilo.Image`           | Container image name                | `registry.opensource.zalan.do/acid/spilo-9.5`       |
| `Spilo.Version`         | Container image tag                 | `1.0-p5`                                            |
| `ImagePullPolicy`       | Container pull policy               | `IfNotPresent`                                      |
| `Replicas`              | k8s statefulset replicas            | `5`                                                 |
| `NodeSelector`          | nodeSelector map                    | Empty                                               |
| `Component`             | k8s selector key                    | `patroni`                                           |
| `Resources.Cpu`         | container requested cpu             | `100m`                                              |
| `Resources.Memory`      | container requested memory          | `512Mi`                                             |
| `Credentials.Superuser` | password for the superuser          | `tea`                                               |
| `Credentials.Admin`     | password for the admin user         | `cola`                                              |
| `Credentials.Standby`   | password for the replication user   | `pinacolada`                                        |
| `Etcd.Enable`           | using etcd as DCS                   | `true`                                              |
| `Etcd.DeployChart`      | deploy etcd chart                   | `true`                                              |
| `Etcd.Host`             | host name of etcd cluster           | not used (Etcd.Discovery is used instead)           |
| `Etcd.Discovery`        | domain name of etcd cluster         | `<release-name>-etcd.<namespace>.svc.cluster.local` |
| `Zookeeper.Enable`      | using zookeeper as DCS              | `false`                                             |
| `Zookeeper.DeployChart` | deploy zookeeper chart              | `false`                                             |
| `Zookeeper.Hosts`       | list of zookeeper cluster members   | 'host1:port1','host2:port2','etc...'                |
| `WalE.Enable`           | use of wal-e tool for base backup/restore | `false` |
| `WalE.Schedule_Cron_Job` | schedule of wal-e backups          | `00 01 * * *` |
| `WalE.Retain_Backups`   | number of backups to retain         | `2` |
| `WalE.S3_Bucket:`       | Amazon S3 bucket used for wal-e backups | `` |
| `WalE.GCS_Bucket`       | Google cloud plataform storage used for wal-e backups | `` |
| `WalE.Kubernetes_Secret` | kubernetes secret for provider bucket | `` |
| `WalE.Backup_Threshold_Megabytes` | maximum size of the WAL segments accumulated after the base backup to consider WAL-E restore instead of pg_basebackup | `1024` |
| `WalE.Backup_Threshold_Percentage` | maximum ratio (in percents) of the accumulated WAL files to the base backup to consider WAL-E restore instead of pg_basebackup | `30` |
| `persistentVolume.accessModes` | Persistent Volume access modes | `[ReadWriteOnce]` |
| `persistentVolume.annotations` | Annotations for Persistent Volume Claim` | `{}` |
| `persistentVolume.mountPath` | Persistent Volume mount root path | `/home/postgres/pgdata` |
| `persistentVolume.size` | Persistent Volume size | `2Gi` |
| `persistentVolume.storageClass` | Persistent Volume Storage Class | `volume.alpha.kubernetes.io/storage-class: default` |
| `persistentVolume.subPath` | Subdirectory of Persistent Volume to mount | `""` |

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

Patroni is responsible for electing a Postgres master pod by leveraging etcd.
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
