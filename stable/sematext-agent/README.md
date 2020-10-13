## This Helm chart is deprecated

Given the [deprecation of `stable`](https://github.com/helm/charts#deprecation-timeline), future Sematext Agent charts will be located at [sematext/helm-charts](https://github.com/sematext/helm-charts/).

To update an existing _stable_ deployment with the chart hosted in the Sematext Agent repository, you should run:

```bash
$ helm repo add sematext https://cdn.sematext.com/helm-charts/
$ helm upgrade st-agent sematext/sematext-agent
```

# Sematext Agent

Sematext Agent collects logs, metrics, events and more info for hosts (CPU, memory, disk, network, processes, ...), containers and orchestrator platforms and ships that to [Sematext Cloud](https://sematext.com/cloud). Sematext Cloud is available in the US and EU regions.

## Introduction

This chart installs the Sematext Agent to all nodes in your cluster via a `DaemonSet` resource.

## Prerequisites

- Kubernetes 1.13+
- You need to create [a new Docker app in Sematext Cloud](https://apps.sematext.com/ui/integrations/create/docker) to get relevant tokens

## Installation

To install the chart to ship logs run the following command:

```bash
$ helm install st-logagent  \
    --set logsToken=YOUR_LOGS_TOKEN \
    --set region=US \
    stable/sematext-agent
```

To install the chart for monitoring run the following command:

```bash
$ helm install st-agent \
    --set containerToken=YOUR_CONTAINER_TOKEN \
    --set infraToken=YOUR_INFRA_TOKEN \
    --set region=US \
    stable/sematext-agent
```

To install the chart for both logs and monitoring run the following command:

```bash
$ helm install st-agent \
    --set logsToken=YOUR_LOGS_TOKEN \
    --set containerToken=YOUR_CONTAINER_TOKEN \
    --set infraToken=YOUR_INFRA_TOKEN \
    --set region=US \
    stable/sematext-agent
```

After a few minutes, you should see logs, metrics, and events reported in Sematext web UI.

**NOTE:** If you want to use Sematext hosted in the EU region set the region parameter to `--set region=EU`. Also, it is worth mentioning that the agent is running as a privileged container.

## Removal

To uninstall the chart use:

```bash
$ helm uninstall st-logagent
```

or

```bash
$ helm uninstall st-agent
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
| `serviceAccount.create`          | Create a service account          | `true`                                    |
| `serviceAccount.name`            | Service account name              | `Nil` Defaults to chart name              |
| `priorityClassName`              | Priority class name               | `Nil`                                     |
| `rbac.create`                    | RBAC enabled                      | `true`                                    |
| `tolerations`                    | Tolerations                       | `[]`                                      |
| `nodeSelector`                   | Node selector                     | `{}`                                      |
| `serverBaseUrl`                  | Custom Base URL                   | `Nil`                                     |
| `logsReceiverUrl`                | Custom Logs receiver URL          | `Nil`                                     |
| `eventsReceiverUrl`              | Custom Event receiver URL         | `Nil`                                     |

Specify each parameter using the `--set key=value` argument to `helm install`. For example:

```bash
$ helm install st-agent \
    --set containerToken=YOUR_CONTAINER_TOKEN \
    --set infraToken=YOUR_INFRA_TOKEN \
    --set region=US \
    --set agent.image.tag=0.18.3 \
    --set agent.image.pullPolicy=IfNotPresent \
    stable/sematext-agent
```

Alternatively, you can use a YAML file that specifies the values while installing the chart. For example:

```bash
$ helm install st-agent -f custom_values.yaml stable/sematext-agent
```
