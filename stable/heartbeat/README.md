# heartbeat

[heartbeat](https://www.elastic.co/guide/en/beats/heartbeat/current/index.html) is a lightweight daemon that periodically check the status of your services and determine whether they are available.

## Introduction

This chart deploys heartbeat agents to all the nodes in your cluster via a DaemonSet.

By default this chart only ships a single output to a file on the local system.  Users should set config.output.file.enabled=false and configure their own outputs as [documented](https://www.elastic.co/guide/en/beats/heartbeat/current/configuring-output.html)

## Prerequisites

-   Kubernetes 1.9+

## Installing the Chart

To install the chart with the release name `my-release`, run:

```bash
$ helm install --name my-release stable/heartbeat
```

After a few minutes, you should see service statuses being written to the configured output, which is a log file inside the heartbeat container.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the heartbeat chart and their default values.

| Parameter                           | Description                                                                                                                                                                                           | Default                             |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| `image.repository`                  | The image repository to pull from                                                                                                                                                                     | `docker.elastic.co/beats/heartbeat` |
| `image.tag`                         | The image tag to pull                                                                                                                                                                                 | `6.6.1`                             |
| `image.pullPolicy`                  | Image pull policy                                                                                                                                                                                     | `IfNotPresent`                      |
| `rbac.create`                       | If true, create & use RBAC resources                                                                                                                                                                  | `true`                              |
| `rbac.serviceAccount`               | existing ServiceAccount to use (ignored if rbac.create=true)                                                                                                                                          | `default`                           |
| `config`                            | The content of the configuration file consumed by heartbeat. See the [heartbeat documentation](https://www.elastic.co/guide/en/beats/heartbeat/current/heartbeat-reference-yml.html) for full details |                                     |
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
    stable/heartbeat
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/heartbeat
```

> **Tip**: You can use the default [values.yaml](values.yaml)
