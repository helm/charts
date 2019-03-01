# kubernetes-replicator

[kubernetes-replicator](https://github.com/mittwald/kubernetes-replicator) is an open source (Apache 2.0 License) custom Kubernetes controller that can be used to make secrets and config maps available in multiple namespaces.

## Introduction

This chart deploys kubernetes-replicator to your cluster via a Deployment.

# Prerequisites

- Kubernetes 1.9+

## Installing the Chart

To install the chart with the release name `my-release`, run:

```bash
$ helm install --name my-release stable/kubernetes-replicator
```

After a few seconds, you should see service statuses being written to the configured output.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the kubernetes-replicator chart and their default values.

|             Parameter               |            Description              |                    Default                |
|-------------------------------------|-------------------------------------|-------------------------------------------|
| `image.repository`                  | The image to run                    | `quay.io/mittwald/kubernetes-replicator`  |
| `image.tag`                         | The image tag to pull               | `v1.0.0-alpha1`                           |
| `image.pullPolicy`                  | Image pull policy                   | `IfNotPresent`                            |
| `resources.requests.cpu`            | CPU resource requests               |                                           |
| `resources.limits.cpu`              | CPU resource limits                 |                                           |
| `resources.requests.memory`         | Memory resource requests            |                                           |
| `resources.limits.memory`           | Memory resource limits              |                                           |
| `nodeSelector`                      | Settings for nodeselector           | `{}`                                      |
| `tolerations`                       | Settings for toleration             | `{}`                                      |
| `affinity`                          | Settings for affinity               | `{}`                                      |



Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    stable/kubernetes-replicator --set image.tag=1.0.0
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/kubernetes-replicator
```

> **Tip**: You can use the default [values.yaml](values.yaml)


