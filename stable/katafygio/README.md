# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Katafygio

[Katafygio](https://github.com/bpineau/katafygio) discovers Kubernetes objects (deployments, services, ...), and continuously saves them as YAML files in a Git repository. This provides real-time, continuous backups, and keeps detailed changes history.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## TL;DR;

```bash
$ helm install stable/katafygio
```

## Introduction

This chart installs a [Katafygio](https://github.com/bpineau/katafygio) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9+

## Chart Details

You may filter out irrelevant objects using the `excludeKind` and `excludeObject` options, to keep your backups' repository lean.

By default, the chart will dump (and version) the clusters content in /var/lib/katafygio/data (configurable with `localDir`).
This can be useful as is, to keep a local changes history. To benefit from long term, out of cluster, and centrally reachable persistence, you may provide the address of a remote Git repository (with `gitUrl`), where all changes will be pushed.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/katafygio
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Katafygio chart and their default values.

| Parameter               | Description                                                 | Default                              |
|-------------------------|-------------------------------------------------------------|--------------------------------------|
| `replicaCount`          | Desired number of pods                                      | `1`                                  |
| `image.repository`      | Katafygio container image name                              | `bpineau/katafygio`                  |
| `image.tag`             | Katafygio container image tag                               | `v0.8.1`                             |
| `image.pullPolicy`      | Katafygio container image pull policy                       | `IfNotPresent`                       |
| `localDir`              | Container's local path where Katafygio will dump and commit | `/tmp/kf-dump`                       |
| `gitUrl`                | Optional remote repository where changes will be pushed     | `nil`                                |
| `noGit`                 | Disable Git versioning                                      | `false`                              |
| `filter`                | Label selector to dump only matched objects                 | `nil`                                |
| `healthcheckPort`       | The port Katafygio will listen for health checks requests   | `8080`                               |
| `excludeKind`           | Object kinds to ignore                                      | `{"replicaset","endpoints","event"}` |
| `excludeObject`         | Specific objects to ignore (eg. "configmap:default/foo")    | `nil`                                |
| `rbac.create`           | Enable or disable RBAC roles and bindings                   | `true`                               |
| `serviceAccount.create` | Whether a ServiceAccount should be created                  | `true`                               |
| `serviceAccount.name`   | Service account to be used                                  | `nil`                                |
| `resyncInterval`        | Seconds between full catch-up resyncs. 0 to disable         | `300`                                |
| `logLevel`              | Log verbosity (ie. info, warning, error)                    | `warning`                            |
| `logOutput`             | Logs destination (stdout, stderr or syslog)                 | `stdout`                             |
| `logServer`             | Syslog server address (eg. "rsyslog:514")                   | `nil`                                |
| `resources`             | CPU/Memory resource requests/limits                         | `{}`                                 |
| `tolerations`           | List of node taints to tolerate                             | `[]`                                 |
| `affinity`              | Node affinity for pod assignment                            | `{}`                                 |
| `nodeSelector`          | Node labels for pod assignment                              | `{}`                                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/katafygio
```
> **Tip**: You can use the default [values.yaml](values.yaml)
