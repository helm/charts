# Elastic-stack Helm Chart

**Note - this chart has been deprecated and [moved to stable](../../stable/elastic-stack)**.

This chart installs an elasticsearch cluster with kibana and logstash by default.
You can optionally disable logstash and install Fluentd if you prefer. It also optionally installs filebeat, nginx-ldapauth-proxy and elasticsearch-curator.

## Prerequisites Details

* Kubernetes 1.8+
* PV dynamic provisioning support on the underlying infrastructure

## Chart Details
This chart will do the following:

* Implemented a dynamically scalable elasticsearch cluster using Kubernetes StatefulSets/Deployments
* Multi-role deployment: master, client (coordinating) and data nodes
* Statefulset Supports scaling down without degrading the cluster

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/elastic-stack
```

## Deleting the Charts

Delete the Helm deployment as normal

```
$ helm delete my-release
```

Deletion of the StatefulSet doesn't cascade to deleting associated PVCs. To delete them:

```
$ kubectl delete pvc -l release=my-release,component=data
```

## Configuration

Each requirement is configured with the options provided by that Chart.
Please consult the relevant charts for their configuration options.
