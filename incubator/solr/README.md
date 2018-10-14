# Apache SOLR Cloud Helm Chart

This helm chart provides an implementation of Apache Solr [StatefulSet](http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/).

<!-- TOC -->

- [Apache SOLR Cloud Helm Chart](#apache-solr-cloud-helm-chart)
    - [Prerequisites](#prerequisites)
    - [Chart Components](#chart-components)
    - [Installing the Chart](#installing-the-chart)
        - [Installed Components](#installed-components)
    - [Configuration](#configuration)
    - [Default Values](#default-values)
    - [Deep Dive](#deep-dive)
        - [Images](#images)
            - [Zookeeper Image](#zookeeper-image)
            - [Solr Image](#solr-image)
        - [Scaling](#scaling)
            - [Solr](#solr)
            - [Zookeeper](#zookeeper)
        - [Access API and Client Searching](#access-api-and-client-searching)
        - [Create a Collection](#create-a-collection)
        - [Add Data to Collection](#add-data-to-collection)
        - [Search Data in Collection](#search-data-in-collection)

<!-- /TOC -->

## Prerequisites

- Kubernetes 1.8+
- PersistentVolume support
- A familiarity with [Apache Solr 7](http://lucene.apache.org/solr/)
- Helm Chart Zookeeper 1.2.0 see [requirements.yaml](requirements.yaml)

## Chart Components

This chart will do the following:

- Create three (3) Solr Cloud nodes in a Statefulset
- Create three (3) Zookeeper zNodes in an ensemble.
- Create a [Headless Service](https://kubernetes.io/docs/concepts/services-networking/service/) to control the Solr Cloud replicas.
- Create a Service configured to perform Admin functions and allow client connections

## Installing the Chart

You can install the chart with the release name `myrelease` as below.

```console
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm upgrade myrelease --install incubator/solr
```

>Note - If you do not specify a name, helm will select a name for you.

### Installed Components

You can use `kubectl get` to view all the installed components.

```console
kubectl get all -l release=myrelease
NAME                               DESIRED   CURRENT   AGE
statefulsets/myrelease-solr        3         3         4m
statefulsets/myrelease-zookeeper   3         3         4m

NAME                       READY     STATUS    RESTARTS   AGE
po/myrelease-solr-0        1/1       Running   0          4m
po/myrelease-solr-1        1/1       Running   0          3m
po/myrelease-solr-2        1/1       Running   0          2m
po/myrelease-zookeeper-0   1/1       Running   0          4m
po/myrelease-zookeeper-1   1/1       Running   0          4m
po/myrelease-zookeeper-2   1/1       Running   0          3m

NAME                               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
svc/myrelease-solr                 ClusterIP   10.110.148.187   <none>        80/TCP                       4m
svc/myrelease-solr-headless        ClusterIP   None             <none>        8983/TCP                     4m
svc/myrelease-zookeeper            ClusterIP   10.108.231.151   <none>        2181/TCP                     4m
svc/myrelease-zookeeper-headless   ClusterIP   None             <none>        2181/TCP,3888/TCP,2888/TCP   4m

```

## Configuration

You can specify each parameters using the `--set key=value` argument either in `helm install` or `helm upgrade`

Alternatively, a YAML file that specifics the values for the parameters can be provided while installing the chart.  For example,

```console
helm install --name myrelease -f values.yaml incubator/solr
```

```console
helm upgrade --install myrelease -f values.yaml incubator/solr
```

## Default Values

The configuration parameters in this section control the resources requested and utilized by the Apache SOLR Cloud Instance.

| Parameter                     | Description                                                                                    | Default           |
| ----------------------------- | ---------------------------------------------------------------------------------------------- | ----------------- |
| replicaCount                  | Number of SOLR Cloud Replicas to install or scale too                                          | `3`               |
| revisionHistoryLimit          | Number of Revision History to keep.  [See Docs](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#revision-history-limit)| `2`                        |
| updateStrategy.type           | updateStrategy for the StatefulSet                                                             | `RollingUpdate`   |
| podManagementPolicy           | Pod's Management Policy [See Docs](https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#pod-management-policy)
| terminationGracePeriodSeconds | Terminate the pod after x seconds if hook fails                                                | `1800`            |
| ports.client.containerPort    | Container port for SOLR Cloud                                                                  | `8983`            |
| heap                          | Apache SOLR Heap Settings                                                                      | `2g`              |
| timeZone                      | Apache SOLR TimeZone Settings                                                                  | `UTC`             |
| LogLevel                      | Apache SOLR Log Level Settings                                                                 | `INFO`            |
| image.repository              | Docker Hub Library Apache SOLR Image                                                           | `solr`            |
| image.tag                     | Docker Hub Library Apache Solr Image Tag                                                       | `7.5`             |
| image.pullPolicy              | Image Pull Policy                                                                              | `IfNotPresent`    |
| service.type                  | Client Service Type                                                                            | `ClusterIP`       |
| service.port                  | Client Service Port                                                                            | `80`              |
| ingress.enabled               | Ingress Enabled                                                                                | `true`            |
| ingress.annotations           | Ingress Annotations                                                                            | `nil`             |
| ingress.path                  | Ingress Path                                                                                   | `/`               |
| ingress.hosts                 | Hosts used for Ingress                                                                         | `solr-admin.local`|
| persistence.enabled           | Enabled Persistence                                                                            | `true`            |
| persistence.storageClass      | Storage Class to be used                                                                       | `Commented Out`   |
| persistence.accessMode        | Data Access Mode to be used for the Data Directory                                             | `ReadWriteOnce`   |
| persistence.size              | PVC Size for Data Directory                                                                    | `1Gi`             |

>Notes - Read through the [Zookeeper Default Values](https://github.com/helm/charts/tree/master/incubator/zookeeper#default-values) to customize the Zookeeper instance

## Deep Dive

### Images

#### Zookeeper Image

This chart requires a Zookeeper ensemble to start.  The image used for this is current in the [helm chart incubator](https://github.com/helm/charts/tree/master/incubator/zookeeper).

#### Solr Image

The image used for this chart is based on Apache Solr 7.5.0 in the [Docker Hub library for SOLR](https://hub.docker.com/_/solr/).

### Scaling

#### Solr

You can scale the number of replica for Solr by changing the `replicaCount` either in the `values.yaml` or the `set replicaCount` via the `helm install` or `helm upgrade` command.  Scaling the number of replicas DOES NOT add replicas to an existing collection.  This will have to be done manually via a CI/CD build process.

#### Zookeeper

Read the section on [Scaling Zookeeper](https://github.com/helm/charts/tree/master/incubator/zookeeper#scaling) in the Helm Chart Documentation for Zookeeper.  It is recommended that you set a fixed number of Zookeeper znodes using the `zookeeper.replicaCount` in the `values.yaml`.  We have found inconsistencies with Solr when scaling Zookeeper after the chart has been deployed.

### Access API and Client Searching

If you enabled ingress, users and administrators can search and perform administrative tasks on the SOLR Cloud replicas or collection(s).
You can access the instance via the host name you supplied in the `values.yaml`.  The default is `solr-admin.local`.  You will see information in the `NOTES.txt` on how to access the URL or after you install the chart.

>Note - If you are working locally you will need to edit your `/etc/hosts` file to include an entry for `solr-admin.local`.

- Example - Notes.txt output after install

```console raw
NOTES:
1. View the SOLR Cloud GUI via the url:
  http://solr-admin.local/
```

### Create a Collection

You can create a SOLR Collection using the following command.  This will create one (1) collection called `testcoll` and one (1) shard with a replicationFactor of three (3).

```console raw
kubectl run --attach adminbox --image=centos --restart=Never -- sh -c 'curl -X POST "http://myrelease-solr-headless:8983/solr/admin/collections?action=CREATE&name=testcoll&numShards=1&replicationFactor=3"';
If you don't see a command prompt, try pressing enter.
100   859  100   859    0     0    145      0  0:00:05  0:00:05 --:--:--   220
{
  "responseHeader":{
    "status":0,
    "QTime":5893},
  "success":{
    "myrelease-solr-1.myrelease-solr-headless:8983_solr":{
      "responseHeader":{
        "status":0,
        "QTime":3539},
      "core":"testcoll_shard1_replica_n4"},
    "myrelease-solr-2.myrelease-solr-headless:8983_solr":{
      "responseHeader":{
        "status":0,
        "QTime":3776},
      "core":"testcoll_shard1_replica_n3"},
    "myrelease-solr-0.myrelease-solr-headless:8983_solr":{
      "responseHeader":{
        "status":0,
        "QTime":3939},
      "core":"testcoll_shard1_replica_n1"}},
  "warning":"Using _default configset. Data driven schema functionality is enabled by default, which is NOT RECOMMENDED for production use. To turn it off: curl http://{host:port}/solr/testcoll/config -d '{\"set-user-property\": {\"update.autoCreateFields\":\"false\"}}'"}

```

### Add Data to Collection

You can add data to the collection via the ingress.

```console raw
curl http://solr-admin.local/solr/testcoll/update -H "Content-Type: text/xml" --data-binary '
<add>
  <doc>
    <field name="authors">Patrick Eagar</field>
    <field name="subject">Sports</field>
    <field name="dd">796.35</field>
    <field name="isbn">0002166313</field>
    <field name="yearpub">1982</field>
    <field name="publisher">Collins</field>
  </doc>
</add>'
```

```console raw
curl "http://solr-admin.local/solr/testcoll/update" --data '<commit/>'

```

### Search Data in Collection

You can search data in the collecation via ingress.

```console raw
curl "http://solr-admin.local/solr/testcoll/select?q=*:*"
```
