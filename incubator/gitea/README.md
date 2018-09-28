# Gitea Helm Chart

[Gitea][] is a painless self-hosted Git service.

## TL;DR;

```console
$ helm install incubator/gitea
```

## Introduction

This chart bootstraps a [Gitea][] deployment on a [Kubernetes][] cluster using
the [Helm][] package manager.

## Prerequisites Details

* PV support on underlying infrastructure (if persistence is required)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/gitea
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes nearly all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

The following tables lists some of the configurable parameters of the Gitea
chart and their default values.

| Parameter                        | Description                                                  | Default                                                 |
|----------------------------------|--------------------------------------------------------------|---------------------------------------------------------|
| `imageRepository`                | Gitea image                                                  | `gitea/gitea`                                           |
| `imageTag`                       | Gitea image version                                          | `1.3.2`                                               |
| `imagePullPolicy`                | Gitea image pull policy                                      | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `postgresql.install`             | Weather or not to install PostgreSQL dependency              | `true`                                                  |
| `postgresql.postgresHost`        | PostgreSQL host (if `postgresql.install == false`)           | `nil`                                                   |
| `postgresql.postgresUser`        | PostgreSQL User to create                                    | `gitea`                                                 |
| `postgresql.postgresPassword`    | PostgreSQL Password for the new user                         | `gitea`                                                 |
| `postgresql.postgresDatabase`    | PostgreSQL Database to create                                | `gitea`                                                 |
| `postgresql.persistence.enabled` | Enable PostgreSQL persistence using Persistent Volume Claims | `true`                                                  |

See [values.yaml](values.yaml) for a more complete list, and links to the Gitea documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/gitea
```

> **Tip**: You can use the default [values.yaml](values.yaml)

[Gitea]: https://github.com/go-gitea/gitea
[Kubernetes]: https://kubernetes.io
[Helm]: https://helm.sh
