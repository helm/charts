# AlertManager Discord

[alertmanager-discord](https://github.com/EvertonFreire/alertmanager-discord) is an interceptor for discord messages like as slack messages.

## Introduction

This chart deploys alertmanager-discord agents to all the nodes in your cluster via a DaemonSet.

By default this works only when you set the environment variable DISCORD_WEBHOOK.

## Prerequisites

- Kubernetes 1.9+

## Installing the Chart

To install the chart with the release name `my-release`, run:

```bash
$ helm install --name my-release stable/alertmanager-discord
```

After a few minutes, you should see service statuses being written to the configured output, which is a log file inside the alertmanager-discord container.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the alertmanager-discord chart and their default values.

| Parameter                           | Description                                                                                                                                                                                           | Default                             |
| ----------------------------------- | --------------------------------------------------------- | ----------------------------------- |
| `image.repository`                  | The image repository to pull from                         | `evertonfreire/alertmanager-discord`|
| `image.tag`                         | The image tag to pull                                     | `latest`                            |
| `image.pullPolicy`                  | Image pull policy                                         | `IfNotPresent`                      |
| `resources.requests.cpu`            | CPU resource requests                                     | `300m`                              |
| `resources.limits.cpu`              | CPU resource limits                                       | `300m`                              |
| `resources.requests.memory`         | Memory resource requests                                  | `128Mi`                             |
| `resources.limits.memory`           | Memory resource limits                                    | `128Mi`                             |
| `readinessProbe.initialDelaySeconds`| Initial Delay Seconds                                     | `5`                                 |
| `readinessProbe.periodSeconds`      | Period Seconds                                            | `5`                                 |
| `readinessProbe.successThreshold`   | Success Threshold                                         | `2`                                 |
| `ipForwardInitContainer`            | Priority class name                                       | `false`                             |
| `service.type`                      | Service Type                                              | `LoadBalancer`                      |
| `service.externalPort`              | Service External Port                                     | `9094`                              |
| `service.internalPort`              | Service Internal Port                                     | `9094`                              |
| `service.nodePort`                  | Service Node Port                                         | `32085`                             |
| `service.externalIPs`               | Service External IPs                                      |                                     |
| `replicaCount`                      | Replica Count                                             | `1`                                 |
| `env.DISCORD_WEBHOOK`               | Priority class name                                       |                                     |
| `nodeSelector`                      | Node Selector                                             |                                     |
| `tolerations`                       | Pod's tolerations                                         |                                     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set rbac.create=true \
    stable/alertmanager-discord
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/alertmanager-discord
```

> **Tip**: You can use the default [values.yaml](values.yaml)

> **Tip**: Do you wanna see this working? Enter this discord channel: [channel-link](https://discord.gg/5bXMu3)
