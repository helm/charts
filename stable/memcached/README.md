# Memcached

> [Memcached](https://memcached.org/) is an in-memory key-value store for small chunks of arbitrary data (strings, objects) from results of database calls, API calls, or page rendering.

Based on the [memcached](https://github.com/bitnami/charts/tree/master/incubator/memcached) chart from the [Bitnami Charts](https://github.com/bitnami/charts) repository.

## TL;DR;

```bash
$ helm install stable/memcached
```

## Introduction

This chart bootstraps a [Memcached](https://hub.docker.com/_/memcached/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/memcached
```

The command deploys Memcached on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Memcached chart and their default values.

|      Parameter             |          Description            |                         Default                         |
|----------------------------|---------------------------------|---------------------------------------------------------|
| `image`                    | The image to pull and run       | A recent official memcached tag                         |
| `imagePullPolicy`          | Image pull policy               | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `memcached.verbosity`      | Verbosity level (v, vv, or vvv) | Un-set.                                                 |
| `memcached.maxItemMemory`  | Max memory for items (in MB)    | `64`                                                    |
| `memcached.extraArgs`      | Additional memcached arguments  | `[]`                                                    |
| `metrics.enabled`          | Expose metrics in prometheus format | false                                               |
| `metrics.image`            | The image to pull and run for the metrics exporter | A recent official memcached tag      |
| `metrics.imagePullPolicy`  | Image pull policy               | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `metrics.resources`        | CPU/Memory resource requests/limits for the metrics exporter | `{}`                       |
| `extraContainers`          | Container sidecar definition(s) as string | Un-set                                        |
| `extraVolumes`             | Volume definitions to add as string | Un-set                                              |
| `kind`                     | Install as StatefulSet or Deployment | StatefulSet                                        |
| `podAnnotations`           | Map of annotations to add to the pod(s) | `{}`                                            |
| `podLabels`                | Custom Labels to be applied to statefulset | Un-set                                       |
| `nodeSelector`             | Simple pod scheduling control | `{}`                                                      |
| `tolerations`              | Allow or deny specific node taints | `{}`                                                 |
| `affinity`                 | Advanced pod scheduling control | `{}`                                                    |
| `securityContext.enabled`  | Enable security context    | `true`                                                       |
| `securityContext.fsGroup`  | Group ID for the container | `1001`                                                       |
| `securityContext.runAsUser`| User ID for the container  | `1001`                                                       |
| `updateStrategy.type`      | Update strategy for the StatefulSet/Deployment | `RollingUpdate`                          |
| `priorityClassName  `      | Specifies the pod's priority class name        | Un-set                                   |

The above parameters map to `memcached` params. For more information please refer to the [Memcached documentation](https://github.com/memcached/memcached/wiki/ConfiguringServer).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set memcached.verbosity=v \
    stable/memcached
```

The above command sets the Memcached verbosity to `v`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/memcached
```

> **Tip**: You can use the default [values.yaml](values.yaml)
