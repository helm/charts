# dogstatsd

[dogstatsd](https://github.com/DataDog/datadog-agent/blob/master/cmd/dogstatsd/README.md) accepts custom application metric points and periodically aggregates and forwards them to Datadog, where they can be graphed on dashboards. DogStatsD implements the [StatsD](https://github.com/etsy/statsd) protocol, along with a few extensions for special Datadog features.

## Introduction

This chart adds the dogstatsd Agent to all nodes in your cluster via a DaemonSet.


## Installing the Chart

To install the chart with the release name `my-release`, retrieve your datadog API key from your [Agent Installation Instructions](https://app.dogstatsdhq.com/account/settings#agent/kubernetes) and run:

```bash
$ helm install --name my-release \
    --set apiKey=YOUR-KEY-HERE stable/dogstatsd
```

After a few minutes, you should see hosts and metrics being reported in dogstatsd.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the dogstatsd chart and their default values.

|          Parameter          |             Description              |               Default               |
| --------------------------- | ------------------------------------ | ----------------------------------- |
| `apiKey`                    | Your dogstatsd API key               | `Nil` You must provide your own key |
| `socket.enable`             | enable socket protocol               | `false`                             |
| `socket.path`               | socket path                          | `/socket/statsd.socket`             |
| `image.repository`          | The image repository to pull from    | `datadog/dogstatsd`                 |
| `image.tag`                 | The image tag to pull                | `beta`                              |
| `image.pullPolicy`          | Image pull policy                    | `IfNotPresent`                      |
| `resources.requests.cpu`    | CPU resource requests                | `50m`                               |
| `resources.limits.cpu`      | CPU resource limits                  | `100m`                              |
| `resources.requests.memory` | Memory resource requests             | `64Mi`                              |
| `resources.limits.memory`   | Memory resource limits               | `128Mi`                             |
| `updateStrategy`            | `OnDelete` or `RollingUpdate`        | `nRollingUpdateil`                  |
| `service.name`              | Service name definition              | `dogstatsd`                         |
| `service.type`              | Which kubernetes service type to use | `ClusterIP`                         |
| `service.port`              | Default listen port                  | `8125`                              |
| `service.protocol`          | Network protocol to use              | `UDP`                               |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set apiKey=YOUR-KEY-HERE \
    stable/dogstatsd
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/dogstatsd
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Image tags

dogstatsd offers a multitude of [tags](https://hub.docker.com/r/datadog/dogstatsd/tags/)
