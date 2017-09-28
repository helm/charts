# Scalyr

[Scalyr](https://www.scalyr.com/) is a hosted infrastructure logging platform.

## Introduction

This chart adds the Scalyr Agent to all nodes in your cluster via a DaemonSet.

## Prerequisites

- Kubernetes 1.2+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`, retrieve your Scalyr API key from your account and run:

```bash
$ helm install --name my-release \
    --set scalyr.apiKey=YOUR-KEY-HERE stable/scalyr
```

After a few minutes, you should see hosts and logs being reported in scalyr.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Datadog chart and their default values.

|      Parameter              |          Description               |                         Default           |
|-----------------------------|------------------------------------|-------------------------------------------|
| `scalyr.apiKey`             | Your Scalyr API key               |  `Nil` You must provide your own key      |
| `scalyr.config.reportContainerMetrics` | Report container metrics. | `false`                                 |
| `image.repository`          | The image repository to pull from  | `datadog/docker-dd-agent`                 |
| `image.tag`                 | The image tag to pull              | `latest`                                  |
| `imagePullPolicy`           | Image pull policy                  | `IfNotPresent`                            |
| `resources.requests.cpu`    | CPU resource requests              | 128M                                      |
| `resources.limits.cpu`      | CPU resource limits                | 512Mi                                     |
| `resources.requests.memory` | Memory resource requests           | 50m                                       |
| `resources.limits.memory`   | Memory resource limits             | 256m                                      |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set scalyr.apiKey=YOUR-KEY-HERE \
    stable/scalyr
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/scalyr
```

> **Tip**: You can use the default [values.yaml](values.yaml)
