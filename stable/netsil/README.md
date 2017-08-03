# Netsil Chart

[Netsil](https://netsil.com/) provides universal observability.

## Chart Details

This Chart will: 

* Installs a deployment that provisions the Netsil AOC Console along with a DaemonSet for the AOC agent.
* Requires 2X Large sizes at AWS or equivalent.
* Requires the [kube-state-metrics chart](https://github.com/kubernetes/charts/tree/master/stable/kube-state-metrics).

## Prerequisites

- Kubernetes 1.5+
- 2X Large Instances used for hosts running the console

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/netsil
```

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/netsil
```

> **Tip**: You can use the default [values.yaml](values.yaml)