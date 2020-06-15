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
| `metrics.serviceMonitor.enabled`          | Expose serviceMonitor to be scraped in prometheus-operator target | false                                               |
| `metrics.serviceMonitor.interval`          | Default frequency to scrap metrics | 15s                                               |
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

## Upgrading to 3.x from a previous major version
Version 3.0.0 of this chart makes an incompatible change to the way StatefulSet/Deployment selectors are configured. If you try to upgrade from a previous major version, you will see an error like this:

```
Error: UPGRADE FAILED: Deployment.apps "mc-test-memcached" is invalid: spec.template.metadata.labels: Invalid value: map[string]string{"app":"mc-test-memcached", "chart":"memcached-3.0.0", "custom":"value", "heritage":"Tiller", "release":"mc-test"}: `selector` does not match template `labels`
```

To upgrade from a previous major version, you'll either need to perform a small manual fix or delete and reinstall the chart.

### Upgrading with `kind: StatefulSet`
If you're using a StatefulSet, you'll have to manually delete it and allow Helm to re-create it. Run `kubectl delete --cascade=false sts name-goes-here` to delete the StatefulSet without deleting the pods. Once you've done this, upgrade the chart as normal, and the newly-created StatefulSet will adopt the old pods.

### Upgrading with `kind: Deployment`
If you're using a Deployment, the manual fix is to remove all selectors from the spec except `app` and `release`.  Run `kubectl edit deploy name-goes-here`, and you should see a part like this in your editor about 20 lines down:

```yaml
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 2
  selector:
    matchLabels:
      app: mc-test-memcached
      chart: memcached-2.10.2
      heritage: Tiller
      release: mc-test
```

Remove the lines under `matchLabels` except `app: ...` and `release: ...`, and don't change any other lines. The part from above should look like this when you're done:

```yaml
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 2
  selector:
    matchLabels:
      app: mc-test-memcached
      release: mc-test
```

Once you've done this, you can upgrade to 3.x with Helm as normal.

If you want prometheus-operator scrap all serviceMonitors in your cluster you need to set:
```yaml
prometheus:
  prometheusSpec:
    serviceMonitorSelectorNilUsesHelmValues: false
```
If you want to be specific:
```yaml
prometheus:
  prometheusSpec:
    serviceMonitorSelector:
      matchLabels:
        app: memcached
```
You can have more intel in prometheus-operator values and here [github](https://github.com/helm/charts/issues/11310#issuecomment-463486706)
