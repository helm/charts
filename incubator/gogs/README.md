# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# ⚠️ Chart Deprecated

# Gogs Helm Chart

[Gogs][] is a painless self-hosted Git service.

## TL;DR;

```console
$ helm install incubator/gogs
```

## Introduction

This chart bootstraps a [Gogs][] deployment on a [Kubernetes][] cluster using
the [Helm][] package manager.

## Prerequisites Details

* PV support on underlying infrastructure (if persistence is required)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/gogs
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes nearly all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

The following table lists some of the configurable parameters of the Gogs
chart and their default values.

| Parameter                        | Description                                                  | Default                                                    |
| -----------------------          | ----------------------------------                           | ---------------------------------------------------------- |
| `image.repository`                | Gogs image                                                   | `gogs/gogs`                                                |
| `image.tag`                       | Gogs image tag                                           | `0.11.86`                                                  |
| `image.pullPolicy`                | Gogs image pull policy                                       | `Always` if `imageTag` is `latest`, else `IfNotPresent`    |
| `postgresql.install`             | Weather or not to install PostgreSQL dependency              | `true`                                                     |
| `postgresql.postgresHost`        | PostgreSQL host (if `postgresql.install == false`)           | `nil`                                                      |
| `postgresql.postgresUser`        | PostgreSQL User to create                                    | `gogs`                                                     |
| `postgresql.postgresPassword`    | PostgreSQL Password for the new user                         | `gogs`                                                     |
| `postgresql.postgresDatabase`    | PostgreSQL Database to create                                | `gogs`                                                     |
| `postgresql.postgresSSLMode`     | PostgreSQL SSL Mode                                          | `disable`                                                  |
| `postgresql.persistence.enabled` | Enable PostgreSQL persistence using Persistent Volume Claims | `true`                                                     |
| `serviceType`                    | The type of service to create (`ClusterIP`, `NodePort`, `LoadBalancer`) | `NodePort`                                      |
| `service.loadBalancerIP`         | The IP address to use when using serviceType `LoadBalancer`  | `nil`                                                      |
| `service.httpNodePort`           | Enable a static port where the Gogs http service is exposed on each Node’s IP | `nil`                                     |
| `service.sshNodePort`            | Enable a static port where the Gogs ssh service is exposed on each Node’s IP | `nil`                                      |

See [values.yaml](values.yaml) for a more complete list, and links to the Gogs documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/gogs
```

> **Tip**: You can use the default [values.yaml](values.yaml)

[Gogs]: https://github.com/gogits/gogs
[Kubernetes]: https://kubernetes.io
[Helm]: https://helm.sh
