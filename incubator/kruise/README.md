# Kruise
[Kruise](https://openkruise.io) is a set of controllers which extends and complements 
[Kubernetes core controllers](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/)
on application workload management.

## Introduction
This chart bootstraps kruise-manager and its CRDs on your cluster.

## Official Documentation
Official project documentation found [here](https://github.com/openkruise/kruise/tree/master/docs).

## Prerequisites
- With Kubernetes 1.10+ you can install Kruise and enjoy it.
- However, some features like **StatefulSet in-place update** require 1.12+.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/kruise
```

The command deploys Kruise on the Kubernetes cluster in the default configuration. 
The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Kruise chart and their default values.

| Parameter                                 | Description                                                        | Default                             |
|-------------------------------------------|--------------------------------------------------------------------|-------------------------------------|
| `log.level`                               | Log level that kruise-manager printed                              | `4`                                 |
| `replicaCount`                            | Number of replicas                                                 | `2`                                 |
| `revisionHistoryLimit`                    | Limit of revision history                                          | `3`                                 |
| `manager.image.repository`                | Name of kruise-manager image                                       | `openkruise/kruise-manager`         |
| `manager.image.tag`                       | Tag of kruise-manager image                                        | `v0.1.0-beta.1`                     |
| `manager.resources.limits.cpu`            | CPU resource limit of kruise-manager container                     |                                     |
| `manager.resources.limits.memory`         | Memory resource limit of kruise-manager container                  |                                     |
| `manager.resources.requests.cpu`          | CPU resource request of kruise-manager container                   |                                     |
| `manager.resources.requests.memory`       | Memory resource request of kruise-manager container                |                                     |
| `manager.metrics.addr`                    | Addr of metrics served                                             | `localhost`                         |
| `manager.metrics.port`                    | Port of metrics served                                             | `8080`                              |
| `spec.nodeAffinity`                       | Node affinity policy for kruise-manager pod                        | `{}`                                |
| `spec.nodeSelector`                       | Node labels for kruise-manager pod                                 | `{}`                                |
| `spec.tolerations`                        | Tolerations for kruise-manager pod                                 | `[]`                                |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install incubator/kruise --name=my-release --set resources.limits.memory=1Gi
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install incubator/kruise --name my-release -f my-values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
