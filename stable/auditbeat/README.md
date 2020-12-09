# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Auditbeat

[Auditbeat](https://www.elastic.co/guide/en/beats/auditbeat/current/index.html) is a lightweight shipper to audit the activities of users and processes on your systems, so that you can identify potential security policy violations. You can use Auditbeat to collect audit events from the Linux Audit Framework. You can also use Auditbeat for file integrity check, that is to detect changes to critical files, like binaries and configuration files.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## Introduction

This chart deploys auditbeat agents to all the nodes in your cluster via a DaemonSet.

By default this chart only ships a single output to a file on the local system.  Users should set config.output.file.enabled=false and configure their own outputs as [documented](https://www.elastic.co/guide/en/beats/auditbeat/current/configuring-output.html)

## Prerequisites

-   Kubernetes 1.9+

## Installing the Chart

To install the chart with the release name `my-release`, run:

```bash
$ helm install --name my-release stable/auditbeat
```

After a few minutes, you should see service statuses being written to the configured output, which is a log file inside the auditbeat container.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the auditbeat chart and their default values.

| Parameter                           | Description                                                                                                                                                                                           | Default                             |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| `image.repository`                  | The image repository to pull from                                                                                                                                                                     | `docker.elastic.co/beats/auditbeat` |
| `image.tag`                         | The image tag to pull                                                                                                                                                                                 | `6.7.0`                             |
| `image.pullPolicy`                  | Image pull policy                                                                                                                                                                                     | `IfNotPresent`                      |
| `rbac.create`                       | If true, create & use RBAC resources                                                                                                                                                                  | `true`                              |
| `rbac.serviceAccount`               | existing ServiceAccount to use (ignored if rbac.create=true)                                                                                                                                          | `default`                           |
| `config`                            | The content of the configuration file consumed by auditbeat. See the [auditbeat documentation](https://www.elastic.co/guide/en/beats/auditbeat/current/auditbeat-reference-yml.html) for full details |                                     |
| `plugins`                           | List of beat plugins                                                                                                                                                                                  |                                     |
| `extraVars`                         | A map of additional environment variables                                                                                                                                                             |                                     |
| `extraVolumes`, `extraVolumeMounts` | Additional volumes and mounts, for example to provide other configuration files                                                                                                                       |                                     |
| `resources.requests.cpu`            | CPU resource requests                                                                                                                                                                                 |                                     |
| `resources.limits.cpu`              | CPU resource limits                                                                                                                                                                                   |                                     |
| `resources.requests.memory`         | Memory resource requests                                                                                                                                                                              |                                     |
| `resources.limits.memory`           | Memory resource limits                                                                                                                                                                                |                                     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set rbac.create=true \
    stable/auditbeat
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/auditbeat
```

> **Tip**: You can use the default [values.yaml](values.yaml)
