# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# linkerd Chart

[linkerd](https://linkerd.io/) is a resilient service mesh for cloud native apps

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## Chart Details
This chart will do the following:

* Install a daemonset that provisions the linkerd [per-host architecture](https://linkerd.io/in-depth/deployment#per-host)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/linkerd
```

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/linkerd
```

> **Tip**: You can use the default [values.yaml](values.yaml)
