# Presto Chart

[Presto](http://prestodb.io/) is an open source distributed SQL query engine for running interactive analytic queries against data sources of all sizes ranging from gigabytes to petabytes.

## Chart Details

This chart will do the following:

* Install a single server which acts both as coordinator and worker
* Install a configmap for it
* Install a service

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/presto
```

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/presto
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Connectors

Presto can query across multiple data sources, and it currently supports [20 different connectors](https://prestodb.io/docs/current/connector). You can upload custom connectors as a [configMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) or as file [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/). 

In the default setup, two connectors are added through [configmap-connectors.yaml](templates/configmap-connectors.yaml) as a demo. 
These connectors provides a set of schemas to support the [TPC Benchmark™](http://www.tpc.org/information/benchmarks.asp). These connectors can be used to test the capabilities and query syntax of Presto without configuring access to an external data source. When you query a schema, the connector generates the data on the fly using a deterministic algorithm.

**configMap**

You can create a configMap with connector `properties` files, and launch your cluster with it.

```bash
kubectl create configmap my-presto-connectors \
	--from-file=/presto/connectors/directory/

helm install stable/presto --name my-presto-cluster \
	--set server.connectors.volumeMount.type=configMap,server.connectors.volumeMount.name=my-presto-connectors
```

**secret**

Alternatively, kubernetes secret is an excellent way to upload connectors to your presto cluster securely.

You can package your connector files into a secret, and launch your cluster with it.

```bash
kubectl create secret generic my-presto-connectors \
	--from-file=/presto/connectors/directory/

helm install stable/presto --name my-presto-cluster \
	--set server.connectors.volumeMount.type=secret,server.connectors.volumeMount.name=my-presto-connectors

```
