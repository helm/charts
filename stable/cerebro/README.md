# Cerebro

Cerebro is an open source (MIT License) elasticsearch web admin tool built using Scala, Play Framework, AngularJS and Bootstrap.

## Introduction

This chart deploys Cerebro to your cluster via a Deployment and Service.
Optionally you can also enable ingress.

# Prerequisites

- Kubernetes 1.9+

## Installing the Chart

To install the chart with the release name `my-release`, run:

```bash
$ helm install --name my-release stable/cerebro
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

The following table lists the configurable parameters of the cerebro chart and their default values.

|             Parameter               |            Description              |                    Default                |
|-------------------------------------|-------------------------------------|-------------------------------------------|
| `replicaCount`                      | Number of replicas                  | `1`                                       |
| `image.repository`                  | The image to run                    | `lmenezes/cerebro`                        |
| `image.tag`                         | The image tag to pull               | `0.8.3`                                   |
| `image.pullPolicy`                  | Image pull policy                   | `IfNotPresent`                            |
| `image.pullSecrets`                 | Specify image pull secrets          | `nil` (does not add image pull secrets to deployed pods) |
| `init.image.repository`             | The image to run                    | `docker.io/busybox`                       |
| `init.image.tag`                    | The image tag to pull               | `musl`                                    |
| `init.image.pullPolicy`             | Image pull policy                   | `IfNotPresent`                            |
| `deployment.annotations`            | Annotations for deployment          | `{}`                                      |
| `service.type`                      | Type of Service                     | `ClusterIP`                               |
| `service.port`                      | Port for kubernetes service         | `80`                                      |
| `service.annotations`               | Annotations to add to the service   | `{}`                                      |
| `service.labels`                    | Labels to add to the service        | `{}`                                      |
| `resources.requests.cpu`            | CPU resource requests               |                                           |
| `resources.limits.cpu`              | CPU resource limits                 |                                           |
| `resources.requests.memory`         | Memory resource requests            |                                           |
| `resources.limits.memory`           | Memory resource limits              |                                           |
| `ingress`                           | Settings for ingress                | `{}`                                      |
| `nodeSelector`                      | Settings for nodeselector           | `{}`                                      |
| `tolerations`                       | Settings for toleration             | `{}`                                      |
| `affinity`                          | Settings for affinity               | `{}`                                      |
| `config.basePath`                   | Application base path               | `/`                                       |
| `config.restHistorySize`            | Rest request history size per user  | `50`                                      |
| `config.hosts`                      | A list of known hosts               | `[]`                                      |
| `config.secret`                     | Secret used to sign session cookies | `(random alphanumeric 64 length string)`  |



Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    stable/cerebro
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/cerebro
```

> **Tip**: You can use the default [values.yaml](values.yaml)
