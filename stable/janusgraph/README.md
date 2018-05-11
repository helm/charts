# JanusGraph

[JanusGraph](http://janusgraph.org/) is a scalable graph database capable of handling an extremely large number of vertices and edges. It has a pluggable architecture that allows for choice of storage and indexing backends.

## Introduction

This chart bootstraps a JanusGraph deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites Details
* Kubernetes 1.7


## Installing the Chart
To install the chart with the release name `my-release`:

```shell
helm install --name my-release stable/janusgraph
```


## Deleting the Chart
To delete the chart with the release name `my-release`:

```shell
helm delete janusgraph --purge
```



## Configuration

Use the default [values.yaml](values.yaml) to gain an understanding of the ways in which you can customize this chart.

Some common properties and their usage have been referenced in the values.yaml file.

Specify your own parameters using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, your own YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```shell
helm install --name my-release -f values.yaml stable/janusgraph
```

JanusGraph specific properties are nested under the properties key.

A full list of JanusGraph properties are defined provided in the [JanusGraph configuration reference](http://docs.janusgraph.org/latest/config-ref.html).



## Persistence

When deployed with local storage, the JanusGraph image stores the graph and index data at the `/db` path of the container.

By default, the chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning and will be cleaned up when the chart is deleted. To persist data outside of this lifecycle of this chart, choose a remote [storage backend](http://docs.janusgraph.org/0.2.0/storage-backends.html) or bring your own [Persistent Volume Claim](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage#create-a-persistentvolumeclaim):

### Existing PersistentVolumeClaim

```bash
$ helm install --set persistence.existingClaim=<your-persistent-volume-claim> stable/janusgraph
```
