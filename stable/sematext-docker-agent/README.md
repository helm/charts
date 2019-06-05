**This chart is DEPRECATED, use [stable/sematext-agent](https://github.com/helm/charts/tree/master/stable/sematext-agent) instead!**

# Sematext Docker Agent

[Sematext](https://sematext.com/) Agent for Docker collects Metrics, Events, and Logs from the Docker API for SPM Docker Monitoring & Logsene / Hosted ELK Log Management.

## Introduction

This chart installs the Sematext Docker Agent to all nodes in your cluster via a `DaemonSet` resource.

## Prerequisites

- Kubernetes 1.2+

## Installation

To install the chart run the following command:

```bash
$ helm install --name release_name \
    --set sematext.spmToken=YOUR_SPM_TOKEN,sematext.logseneToken=YOUR_LOGS_TOKEN stable/sematext-docker-agent
```

After a few minutes, you should see logs, metrics and events being reported in Sematext web UI.

**NOTE:** If you want to use Sematext in EU region set the region as well `--set sematext.region=EU`.

## Deleting

To uninstall the chart delete `release_name` deployment:

```bash
$ helm delete release_name
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configuration parameters of the sematext-docker-agent chart and their default values.

|             Parameter         |            Description               |                    Default                |
|-------------------------------|--------------------------------------|-------------------------------------------|
| `sematext.spmToken`           | Sematext SPM token                   | `Nil` You must provide your SPM token     |
| `sematext.logseneToken`       | Sematext Logsene token               | `Nil` You must provide your Logsene token |
| `sematext.region`             | Sematext region                      | `US` Sematext US or EU region             |
| `image.repository`            | The image repository                 | `sematext/sematext-agent-docker`          |
| `image.tag`                   | The image tag                        | `1.31.48`                                 |
| `image.pullPolicy`            | Image pull policy                    | `IfNotPresent`                            |
| `resources.requests.cpu`      | CPU resource requests                | `Nil`                                     |
| `resources.limits.cpu`        | CPU resource limits                  | `Nil`                                     |
| `resources.requests.memory`   | Memory resource requests             | `Nil`                                     |
| `resources.limits.memory`     | Memory resource limits               | `Nil`                                     |
| `sematext.useHostNetwork`     | Use the host networking              | `false`                                   |
| `sematext.url.spmReceiver`    | Custom endpoint for SPM receiver     | `Nil`                                     |
| `sematext.url.logseneReceiver`| Custom endpoint for Logsene receiver | `Nil`                                     |
| `sematext.url.eventsReceiver` | Custom endpoint for Events receiver  | `Nil`                                     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install --name release_name \
    --set sematext.spmToken=YOUR_SPM_TOKEN,sematext.region=EU \
    stable/sematext-docker-agent
```

Alternatively, you can use a YAML file that specifies the values and it can be provided while installing the chart. For example:

```bash
$ helm install --name release_name -f custom_values.yaml stable/sematext-docker-agent
```
