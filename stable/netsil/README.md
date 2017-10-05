# Netsil Chart

[Netsil](https://netsil.com/) provides universal observability.

## Chart Details

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

The following tables lists the configurable parameters of the Netsil chart and their default values.

|      Parameter                            |          Description            |                         Default                         |
|-------------------------------------------|---------------------------------|---------------------------------------------------------|
| `streamProcessor.image.tag`               | The image tag 		          | A recent official Netsil tag                            |
| `streamProcessor.image.repository`        | Streamprocessor Image repository| A recent official Netsil repo                           |
| `streamProcessor.service.type`     		| Service type					  | NodePort                                                |
| `streamProcessor.image.pullPolicy`        | 							      | IfNotPresent                                            |
| `collector.image.tag`                     | The collector image tag 		  | A recent official Netsil tag                            |
| `collector.image.repository`              | The collector image             | A recent official Netsil repo                           |
| `collector.image.pullPolicy`              | 							      | IfNotPresent                                            |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/netsil
```

> **Tip**: You can use the default [values.yaml](values.yaml)