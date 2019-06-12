
# CassKop - Cassandra Kubernetes operator Helm chart

This Helm chart install CassKop the Orange's Cassandra Kubernetes operator to create/configure/manage Cassandra 
clusters in a Kubernetes Namespace.
It will uses a Custom Ressource Definition CRD: `cassandraclusters.db.orange.com`, 
which implements a `CassandraCluster` kubernetes custom ressource definition.


## Introduction


### Configuration

The following tables lists the configurable parameters of the Cassandra Operator Helm chart and their default values.


| Parameter                        | Description                                      | Default                                   |
|----------------------------------|--------------------------------------------------|-------------------------------------------|
| `image.repository`               | Image                                            | `orangeopensource/cassandra-k8s-operator` |
| `image.tag`                      | Image tag                                        | `0.3.1-master`                            |
| `image.pullPolicy`               | Image pull policy                                | `Always`                                  |
| `image.imagePullSecrets.enabled` | Enable tue use of secret for docker image        | `false`                                   |
| `image.imagePullSecrets.name`    | Name of the secret to connect to docker registry | -                                         |
| `rbacEnable`                     | If true, create & use RBAC resources             | `true`                                    |
| `resources`                      | Pod resource requests & limits                   | `{}`                                      |
| `metricService`                  | deploy service for metrics                       | `false`                                   |
| `debug.enabled`                  | activate DEBUG log level                         | `false`                                   |



Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name casskop incubator/cassandra-operator -f values.yaml
```

### Installing the Chart

You can make a dry run of the chart before deploying :

```console 
helm install --dry-run --debug.enabled incubator/cassandra-operator --set debug.enabled=true --name casskop
```

To install the chart with the release name my-release:

```console
$ helm install --name casskop incubator/cassandra-operator
```

We can surcharge default parameters using `--set` flag :

```console
$ helm install --replace --set image.tag=asyncronous --name casskop incubator/cassandra-operator
```

> the `-replace` flag allow you to reuses a charts release name


### Listing deployed charts

```
helm list
```

### Get Status for the helm deployment :

```
helm status casskop

```

## Uninstaling the Charts

If you want to delete the operator from your Kubernetes cluster, the operator deployment 
should be deleted.

```
$ helm delete casskop
```
The command removes all the Kubernetes components associated with the chart and deletes the helm release.

> The CRD created by the chart are not removed by default and should be manually cleaned up (if required)

Manually delete the CRD:
```
kubectl delete crd cassandraclusters.dfy.orange.com
```

> **!!!!!!!!WARNING!!!!!!!!**
>
> If you delete the CRD then **!!!!!!WAAAARRRRNNIIIIINNG!!!!!!**
>
> It will delete **ALL** Clusters that has been created using this CRD!!!
>
> Please never delete a CRD without very very good care


Helm always keeps records of what releases happened. Need to see the deleted releases? `helm list --deleted`
shows those, and `helm list --all` shows all of the releases (deleted and currently deployed, as well as releases that
failed):

Because Helm keeps records of deleted releases, a release name cannot be re-used. (If you really need to re-use a
release name, you can use the `--replace` flag, but it will simply re-use the existing release and replace its
resources.)

Note that because releases are preserved in this way, you can rollback a deleted resource, and have it re-activate.



To purge a release
```console
$ helm delete --purge casskop
```


## Troubleshooting

### Install of the CRD

By default, the chart will install via a helm hook the Casskop CRD, but this installation is global for the whole
cluster, and you may deploy a chart with an existing CRD already deployed.

In that case you can get an error like :


```
$ helm install --name casskop incubator/cassandra-operator
Error: customresourcedefinitions.apiextensions.k8s.io "cassandraclusters.db.orange.com" already exists
```

In this case there si a parameter to say to not uses the hook to install the CRD :

```
$ helm install --name casskop incubator/cassandra-operator --no-hooks
```
