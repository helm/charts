# namerd Chart

[namerd](https://linkerd.io/in-depth/namerd/) is a service that manages routing for multiple [linkerd](https://github.com/kubernetes/charts/tree/master/stable/linkerd) instances.

## Chart Details
This chart will do the following:

* Install a deployment that provisions namerd with a default configuration and three replicas for HA.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/namerd
```

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/namerd
```

> **Tip**: You can use the default [values.yaml](values.yaml)
