# Rendertron Helm Chart



## Chart Details

This chart will do the following:

* 1 x Rendertron pod with port 3000 exposed on an external LoadBalancer
* All using Kubernetes Deployments

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/rendertron
```

## Configuration

The following tables list the configurable parameters of the Rendertron chart and their default values.

| Parameter                         | Description                          | Default                                                                      |
| --------------------------------- | ------------------------------------ | ---------------------------------------------------------------------------- |
| `nameOverride`                    | Override the resource name prefix    | `jenkins`                                                                    |
| `fullnameOverride`                | Override the full resource names     | `jenkins-{release-name}` (or `jenkins` if release-name is `jenkins`)         |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/rendertron
```

> **Tip**: You can use the default [values.yaml](values.yaml)
