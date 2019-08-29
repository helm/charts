# Zookeeper chart

Apache ZooKeeper is an effort to develop and maintain an open-source server which enables highly reliable distributed coordination.

## Chart Details
This chart will provision a fully functional and fully featured Zookeeper installation
that can be used for a variety of tier 2/3 applications.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/zookeeper
```

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/zookeeper
```

## Docker image

The Docker image used for this chart resides [here](https://github.com/kow3ns/kubernetes-zookeeper/tree/master/docker)
