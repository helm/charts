# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Cerebro

Cerebro is an open source (MIT License) elasticsearch web admin tool built using Scala, Play Framework, AngularJS and Bootstrap.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## Introduction

This chart deploys Cerebro to your cluster via a Deployment and Service.
Optionally you can also enable ingress.
Optionally you can use cerebro provided auth by uploading a Secret with the needed env vars (don't forget to set `AUTH_TYPE`).

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
| `image.tag`                         | The image tag to pull               | `0.9.2`                                   |
| `image.pullPolicy`                  | Image pull policy                   | `IfNotPresent`                            |
| `image.pullSecrets`                 | Specify image pull secrets          | `nil` (does not add image pull secrets to deployed pods) |
| `init.image.repository`             | The image to run                    | `docker.io/busybox`                       |
| `init.image.tag`                    | The image tag to pull               | `musl`                                    |
| `init.image.pullPolicy`             | Image pull policy                   | `IfNotPresent`                            |
| `deployment.annotations`            | Annotations for deployment          | `{}`                                      |
| `deployment.podAnnotations`         | Additional pod annotations          | `{}`                                      |
| `deployment.labels`                 | Additional labels for deployment    | `{}`                                      |
| `deployment.podLabels`              | Additional pod labels               | `{}`                                      |
| `deployment.livenessProbe.enabled`  | Enable livenessProbe                | `true`                                    |
| `deployment.readinessProbe.enabled` | Enable readinessProbe               | `true`                                    |
| `service.type`                      | Type of Service                     | `ClusterIP`                               |
| `service.port`                      | Port for kubernetes service         | `80`                                      |
| `service.annotations`               | Annotations to add to the service   | `{}`                                      |
| `service.labels`                    | Labels to add to the service        | `{}`                                      |
| `resources.requests.cpu`            | CPU resource requests               |                                           |
| `resources.limits.cpu`              | CPU resource limits                 |                                           |
| `resources.requests.memory`         | Memory resource requests            |                                           |
| `resources.limits.memory`           | Memory resource limits              |                                           |
| `ingress`                           | Settings for ingress                | `{}`                                      |
| `ingress.labels`                    | Labels to add to the ingress        | `{}`                                      |
| `priorityClassName`                 | priorityClassName                   | `nil`                                     |
| `nodeSelector`                      | Settings for nodeselector           | `{}`                                      |
| `tolerations`                       | Settings for toleration             | `{}`                                      |
| `affinity`                          | Settings for affinity               | `{}`                                      |
| `env`                               | Map of env vars (key/value   )      | `{}`                                      |
| `envFromSecretRef`                  | Reference to Secret with env vars   |                                           |
| `config.basePath`                   | Application base path               | `/`                                       |
| `config.restHistorySize`            | Rest request history size per user  | `50`                                      |
| `config.hosts`                      | A list of known hosts               | `[]`                                      |
| `config.secret`                     | Secret used to sign session cookies | `(random alphanumeric 64 length string)`  |
| `config.tlsVerify`                  | Validate Elasticsearch cert         | `true`                                    |
| `config.tlsCaCert`                  | CA cert to use for cert validation  | `See values.yaml`                         |
| `securityContext`                   | Security context for pod            | `See values.yaml`                         |
| `volumes`                           | Volumes defintion                   | `See values.yaml`                         |
| `volumeMounts`                      | Volume mount defintion              | `See values.yaml`                         |



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
