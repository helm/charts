# Cassandra Helm Chart

Credit to https://github.com/kubernetes/kubernetes/tree/master/examples/storage/cassandra. This is an implementation of that work

## Prerequisites Details
* Kubernetes 1.5 with alpha APIs enabled
* PV support on the underlying infrastructure

## StatefulSet Details
* https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/

## Chart Details
This chart will do the following:

* Implemented a dynamically scalable cassandra cluster using Kubernetes StatefulSets

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/cassandra
```

