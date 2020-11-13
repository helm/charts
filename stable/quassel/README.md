# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Quassel

[Quassel IRC](https://quassel-irc.org/) is a modern, cross-platform,
distributed IRC client, meaning that one (or multiple) client(s) can attach to
and detach from a central core.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## TL;DR;

```console
$ helm install stable/quassel
```

## Introduction

This chart bootstraps a [Quassel](https://quassel-irc.org/) deployment on a
[Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh)
package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install stable/quassel --name my-release
```

The command deploys Quassel on the Kubernetes cluster in the default
configuration. The [configuration](#configuration) section lists the parameters
that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following table lists the configurable parameters of the quassel chart and
their default values.

| Parameter                              | Description                                                                                      | Default                                                  |
|:---------------------------------------|:-------------------------------------------------------------------------------------------------|:---------------------------------------------------------|
| `imagePullSecrets`                     | Specify image pull secrets                                                                       | `nil` (does not add image pull secrets to deployed pods) |
| `image.repository`                     | The image repository to pull from                                                                | `linuxserver/quassel-core`                               |
| `image.tag`                            | The image tag to pull from                                                                       | `92`                                                     |
| `image.pullPolicy`                     | Image pull policy                                                                                | `IfNotPresent`                                           |
| `uid`                                  | User ID to run Quassel as                                                                        | `1000`                                                   |
| `gid`                                  | Group ID to run Quassel as                                                                       | `1000`                                                   |
| `service.port`                         | TCP port on which the Quassel service is exposed                                                 | `4242`                                                   |
| `service.type`                         | service type                                                                                     | `ClusterIP`                                              |
| `service.nodePort`                     | if `service.type` is `NodePort` and this is non-empty, sets the Quassel node port of the service | `nil`                                                    |
| `persistence.enabled`                  | Enable config persistence using PVC                                                              | `true`                                                   |
| `persistence.storageClass`             | PVC Storage Class for config volume                                                              | `nil`                                                    |
| `persistence.existingClaim`            | Name of an existing PVC to use for config                                                        | `nil`                                                    |
| `persistence.accessMode`               | PVC Access Mode for config volume                                                                | `ReadWriteOnce`                                          |
| `persistence.size`                     | PVC Storage Request for config volume                                                            | `1Gi`                                                    |
| `resources`                            | Resource limits for Quassel pod                                                                   | `{}`                                                     |
| `nodeSelector`                         | Map of node labels for pod assignment                                                            | `{}`                                                     |
| `tolerations`                          | List of node taints to tolerate                                                                  | `[]`                                                     |
| `affinity`                             | Map of node/pod affinities                                                                       | `{}`                                                     |
| `postgresql.enabled`                   | Enable PostgreSQL deployment                                                                     | `false`                                                  |
| `postgresql.postgresUser`              | PostgreSQL User to create                                                                        | `quassel`                                                |
| `postgresql.postgresPassword`          | PostgreSQL Password for the new user                                                             | `nil` (Password will be randomly generated)              |
| `postgresql.postgresDatabase`          | PostgreSQL Database to create                                                                    | `quassel`                                                |
| `postgresql.persistence.enabled`       | Enable PostgreSQL persistence using PVC                                                          | `true`                                                   |
| `postgresql.persistence.storageClass`  | PVC Storage Class for PostgreSQL volume                                                          | `nil`                                                    |
| `postgresql.persistence.existingClaim` | Name of an existing PVC to use for PostgreSQL                                                    | `nil`                                                    |
| `postgresql.persistence.accessMode`    | PVC Access Mode for PostgreSQL volume                                                            | `ReadWriteOnce`                                          |
| `postgresql.persistence.size`          | PVC Storage Request for PostgreSQL volume                                                        | `1Gi`                                                    |

> Additional PostgreSQL parameters are available - refer to the
[PostgreSQL chart](../../stable/postgresql) for more details.

```console
$ helm install stable/quassel --name my-release \
  --set=image.tag=86,resources.limits.cpu=200m
```

Alternatively, a YAML file that specifies the values for the above parameters
can be provided while installing the chart. For example,

```console
$ helm install stable/quassel --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml) as an example

## Persistence

The [quassel-core](https://hub.docker.com/r/linuxserver/quassel-core) image
stores its configuration data, and if using SQLite, its SQLite database at the
`/config` path of the container.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/)
at this location. The volume is created using dynamic volume provisioning.
If the PersistentVolumeClaim should not be managed by the chart, define
`persistence.existingClaim` or disable persistence with `persistence.enabled`.

### Existing PersistentVolumeClaims

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart
```bash
$ helm install stable/quassel --set persistence.existingClaim=PVC_NAME
```

> This process can be repeated for the PostgreSQL volume if desired
