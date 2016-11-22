# Datadog

[Datadog](https://www.datadoghq.com/) is a hosted infrastructure monitoring platform.

## Introduction

This chart adds the DataDog Agent to all nodes in your cluster via a DaemonSet.

## Prerequisites

- Kubernetes 1.2+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`, retrieve your DataDog API key from your [Agent Installation Instructions](https://app.datadoghq.com/account/settings#agent/kubernetes) and run:

```bash
$ helm install --name my-release \
    --set datadog.apiKey=YOUR-KEY-HERE stable/datadog
```

After a few minutes, you should see hosts and metrics being reported in DataDog.

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
| `datadog.apiKey`            | Your Datadog API key               |  `Nil` You must provide your own key      |
| `image.repository`          | The image repository to pull from  | `datadog/docker-dd-agent`                 |
| `image.tag`                 | The image tag to pull              | `latest`                                  |
| `imagePullPolicy`           | Image pull policy                  | `IfNotPresent`                            |
| `resources.requests.cpu`    | CPU resource requests              | 128M                                      |
| `resources.limits.cpu`      | CPU resource limits                | 512Mi                                     |
| `resources.requests.memory` | Memory resource requests           | 100m                                      |
| `resources.limits.memory`   | Memory resource limits             | 256m                                      |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set datadog.apiKey=YOUR-KEY-HERE,datadog.logLevel=DEBUG \
    stable/datadog
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/datadog
```

> **Tip**: You can use the default [values.yaml](values.yaml)
