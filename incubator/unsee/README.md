# unsee

Alert dashboard for Prometheus Alertmanager.

> Alertmanager UI is useful for browsing alerts and managing silences, but it's lacking as a dashboard tool - unsee aims to fill this gap.

Learn more about the application in the official github repo: https://github.com/cloudflare/unsee

## TL;DR;

```bash
$ helm install .
```

## Introduction

This chart creates an unsee deployment on a [Kubernetes](http://kubernetes.io) 
cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.5+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release .
```

The command deploys unsee on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete --purge my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the unsee chart and their default values.

Parameter | Description | Default
--- | --- | ---
`restartPolicy` | container restart policy | `Always`
`image.repository` | container image repository | `cloudflare/unsee`
`image.tag` | container image tag | `latest`
`image.pullPolicy` | container image pull policy | `IfNotPresent`
`ingress.enabled` | if true, ingress will be created | `false`
`ingress.annotations` | ingress annotations | `{}`
`resources` | resource requests & limits | requests: `cpu: 100m, memory: 100Mi`, limits: `cpu: 150m, memory: 120Mi`
`service.replicas` | desired number of pods | `1`
`service.type` | type of service to create | `ClusterIP`
`envs.alertmanager.timeout` | Timeout for requests send to Alertmanager API. | `40s`
`envs.alertmanager.ttl` | Interval for refreshing alerts and silences using Alertmanager API. | `1m`
`envs.alertmanager.uris` | List of Alertmanager instances URI (<name>:<uri>). Required. |
`envs.annotations.defaultHidden` | Enabling this option will hide all annotations in the UI, except for those that are listed in the `envs.annotation.visible option`. | `false`
`envs.annotations.hidden` | List of annotation names that should be hidden in the UI. | `[]`
`envs.annotations.visible` | List of annotation names that should be visible in the UI. This option is only useful when `envs.annotation.defaultHidden` is set. | `[]`
`envs.debug` | Will enable debug mode. | `false`
`envs.color.labelsStatic` | List of label names that will all have the same color applied. | `[]`
`envs.color.labelsUnique` | List of label names that should have unique colors generated in the UI. | `[]`
`envs.filterDefault` | Default alert filter to apply when user loads unsee UI without any filter specified. | ` `
`envs.jiraRegex` | Replace JIRA issue IDs in the comment text with links to those issues. | ` `
`envs.keepLabels` | List of label names to show on the UI, all other labels will be stripped. | `[]`
`envs.sentry.dsn` | DSN for Sentry integration in Go. | ` `
`envs.sentry.publicDsn` | DSN for Sentry integration in javascript. | ` `
`envs.stripLabels` | List of label names that should not be shown on the UI. | `[]`
`envs.webPrefix` | URL path for application. | `/`



Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set key_1=value_1,key_2=value_2 \
    .
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
# example for staging
$ helm install --name my-release -f values.yaml .
```

> **Tip**: You can use the default [values.yaml](values.yaml)
