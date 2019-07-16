# Patroni Helm Chart

This directory contains a Kubernetes chart to deploy a five node [Patroni](https://github.com/zalando/patroni/) cluster using a [Spilo](https://github.com/zalando/spilo) and a StatefulSet.

## Prerequisites Details
* Kubernetes 1.5+
* PV support on the underlying infrastructure

## StatefulSet Details
* https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/

## StatefulSet Caveats
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

To install the chart with randomly generated passwords:

```console
$ helm install --name my-release incubator/patroni \
  --set credentials.superuser="$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32)",credentials.admin="$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32)",credentials.standby="$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32)"
```

## Connecting to PostgreSQL

Your access point is a cluster IP. In order to access it spin up another pod:

```console
$ kubectl run -i --tty --rm psql --image=postgres --restart=Never -- bash -il
```

Then, from inside the pod, connect to PostgreSQL:

```console
$ psql -U admin -h my-release-patroni.default.svc.cluster.local postgres
<admin password from values.yaml>
postgres=>
```

## Configuration

The following table lists the configurable parameters of the patroni chart and their default values.

|       Parameter                   |           Description                       |                         Default                     |
|-----------------------------------|---------------------------------------------|-----------------------------------------------------|
| `nameOverride`                    | Override the name of the chart              | `nil`                                               |
| `fullnameOverride`                | Override the fullname of the chart          | `nil`                                               |
| `replicaCount`                    | Amount of pods to spawn                     | `5`                                                 |
| `image.repository`                | The image to pull                           | `registry.opensource.zalan.do/acid/spilo-10`        |
| `image.tag`                       | The version of the image to pull            | `1.4-p16`                                           |
| `image.pullPolicy`                | The pull policy                             | `IfNotPresent`                                      |
| `credentials.superuser`           | Password of the superuser                   | `tea`                                               |
| `credentials.admin`               | Password of the admin                       | `cola`                                              |
| `credentials.standby`             | Password of the replication user            | `pinacolada`                                        |
| `kubernetes.dcs.enable`           | Using Kubernetes as DCS                     | `true`                                              |
| `kubernetes.configmaps.enable`    | Using Kubernetes configmaps instead of endpoints | `false`                                        |
| `etcd.enable`                     | Using etcd as DCS                           | `false`                                             |
| `etcd.deployChart`                | Deploy etcd chart                           | `false`                                             |
| `etcd.host`                       | Host name of etcd cluster                   | `nil`                                               |
| `etcd.discovery`                  | Domain name of etcd cluster                 | `nil`                                               |
| `zookeeper.enable`                | Using ZooKeeper as DCS                      | `false`                                             |
| `zookeeper.deployChart`           | Deploy ZooKeeper chart                      | `false`                                             |
| `zookeeper.hosts`                 | List of ZooKeeper cluster members           | `host1:port1,host2:port,etc...`                     |
| `walE.enable`                     | Use of Wal-E tool for base backup/restore   | `false`                                             |
| `walE.scheduleCronJob`            | Schedule of Wal-E backups                   | `00 01 * * *`                                       |
| `walE.retainBackups`              | Number of base backups to retain            | `2`                                                 |
| `walE.s3Bucket:`                  | Amazon S3 bucket used for wal-e backups     | `nil`                                               |
| `walE.gcsBucket`                  | GCS storage used for Wal-E backups          | `nil`                                               |
| `walE.kubernetesSecret`           | K8s secret name for provider bucket         | `nil`                                               |
| `walE.backupThresholdMegabytes`   | Maximum size of the WAL segments accumulated after the base backup to consider WAL-E restore instead of pg_basebackup | `1024` |
| `walE.backupThresholdPercentage`  | Maximum ratio (in percents) of the accumulated WAL files to the base backup to consider WAL-E restore instead of pg_basebackup | `30` |
| `resources`                       | Any resources you wish to assign to the pod | `{}`                                                |
| `nodeSelector`                    | Node label to use for scheduling            | `{}`                                                |
| `tolerations`                     | List of node taints to tolerate             | `[]`                                                |
| `affinityTemplate`                | A template string to use to generate the affinity settings | Anti-affinity preferred on hostname  |
| `affinity`                        | Affinity settings. Overrides `affinityTemplate` if set. | `{}`                                    |
| `persistentVolume.accessModes`    | Persistent Volume access modes              | `[ReadWriteOnce]`                                   |
| `persistentVolume.annotations`    | Annotations for Persistent Volume Claim`    | `{}`                                                |
| `persistentVolume.mountPath`      | Persistent Volume mount root path           | `/home/postgres/pgdata`                             |
| `persistentVolume.size`           | Persistent Volume size                      | `2Gi`                                               |
| `persistentVolume.storageClass`   | Persistent Volume Storage Class             | `volume.alpha.kubernetes.io/storage-class: default` |
| `persistentVolume.subPath`        | Subdirectory of Persistent Volume to mount  | `""`                                                |
| `rbac.create`                     | Create required role and rolebindings       | `true`                                              |
| `serviceAccount.create`           | If true, create a new service account	      | `true`                                              |
| `serviceAccount.name`             | Service account to be used. If not set and `serviceAccount.create` is `true`, a name is generated using the fullname template | `nil` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/patroni
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Cleanup

To remove the spawned pods you can run a simple `helm delete <release-name>`.

Helm will however preserve created persistent volume claims,
to also remove them execute the commands below.

```console
$ release=<release-name>
$ helm delete $release
$ kubectl delete pvc -l release=$release
```

## Internals

Patroni is responsible for electing a PostgreSQL master pod by leveraging the
DCS of your choice. After election it adds a `spilo-role=master` label to the
elected master and set the label to `spilo-role=replica` for all replicas.
Simultaneously it will update the `<release-name>-patroni` endpoint to let the
service route traffic to the elected master.

```console
$ kubectl get pods -l spilo-role -L spilo-role
NAME                   READY     STATUS    RESTARTS   AGE       SPILO-ROLE
my-release-patroni-0   1/1       Running   0          9m        replica
my-release-patroni-1   1/1       Running   0          9m        master
my-release-patroni-2   1/1       Running   0          8m        replica
my-release-patroni-3   1/1       Running   0          8m        replica
my-release-patroni-4   1/1       Running   0          8m        replica
```
