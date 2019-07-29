# Sematext Agent

Sematext Agent collects metrics about hosts (CPU, memory, disk, network, processes), containers (both Docker and rkt) and orchestrator platforms and ships that to [Sematext Cloud](https://sematext.com/cloud). Sematext Cloud is available in the US and EU regions.

## Introduction

This chart installs the Sematext Agent to all nodes in your cluster via a `DaemonSet` resource.

## Prerequisites

- Kubernetes 1.9+
- You need to create [a new Docker app in Sematext Cloud](https://apps.sematext.com/ui/integrations/create/docker) to get relevant tokens

## Installation

To install the chart run the following command:

```bash
$ helm install --name release_name \
    --set containerToken=YOUR_CONTAINER_TOKEN,logsToken=YOUR_LOGS_TOKEN stable/sematext-agent
```

After a few minutes, you should see logs, metrics, and events reported in Sematext web UI.

**NOTE:** If you want to use Sematext in EU region set the region as well `--set region=EU`. Also, it is worth mentioning that the agent is running as a privileged container.

## Deleting

To uninstall the chart delete `release_name` deployment:

```bash
$ helm delete --purge release_name
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configuration parameters of the `sematext-agent` chart and default values.

|             Parameter            |            Description            |                  Default                  |
|----------------------------------|-----------------------------------|-------------------------------------------|
| `containerToken`                 | Sematext Container token          | `Nil` Provide your Container token        |
| `logsToken`                      | Sematext Logs token               | `Nil` Provide your Logs token             |
| `infraToken`                     | Sematext Infra token              | `Nil` Provide your Infra token            |
| `region`                         | Sematext region                   | `US` Sematext US or EU region             |
| `agent.image.repository`         | The image repository              | `sematext/agent`                          |
| `agent.image.tag`                | The image tag                     | `latest`                                  |
| `agent.image.pullPolicy`         | Image pull policy                 | `Always`                                  |
| `agent.service.port`             | Service port                      | `80`                                      |
| `agent.service.type`             | Service type                      | `ClusterIP`                               |
| `agent.resources`                | Agent resources                   | `{}`                                      |
| `logagent.image.repository`      | The image repository              | `sematext/logagent`                       |
| `logagent.image.tag`             | The image tag                     | `latest`                                  |
| `logagent.image.pullPolicy`      | Image pull policy                 | `Always`                                  |
| `logagent.resources`             | Logagent resources                | `{}`                                      |
| `logagent.customConfigs`         | Logagent custom configs           | `[]` Check `values.yaml`                  |
| `logagent.extraHostVolumeMounts` | Extra mounts                      | `{}`                                      |
| `customUrl.serverBaseUrl`        | Custom Base URL                   | `Nil`                                     |
| `customUrl.logsReceiverUrl`      | Custom Logs receiver URL          | `Nil`                                     |
| `customUrl.eventsRecieverUrl`    | Custom Event receiver URL         | `Nil`                                     |
| `serviceAccount.create`          | Create a service account          | `true`                                    |
| `serviceAccount.name`            | Service account name              | `Nil` Defaults to chart name              |
| `rbac.create`                    | RBAC enabled                      | `true`                                    |
| `tolerations`                    | Tolerations                       | `[]`                                      |
| `nodeSelector`                   | Node selector                     | `{}`                                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install --name release_name \
    --set containerToken=YOUR_CONTAINER_TOKEN \
    stable/sematext-agent
```

Alternatively, you can use a YAML file that specifies the values while installing the chart. For example:

```bash
$ helm install --name release_name -f custom_values.yaml stable/sematext-agent
```
