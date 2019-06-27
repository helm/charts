# LogDNA Kubernetes Agent

[LogDNA](https://logdna.com) - Easy, beautiful logging in the cloud.

## TL;DR;

```bash
$ helm install --set logdna.key=LOGDNA_INGESTION_KEY stable/logdna-agent
```

## Introduction

This chart deploys LogDNA collector agents to all nodes in your cluster. Logs will ship from all containers. We extract pertinent Kubernetes metadata: pod name, container name, container id, namespace, and labels. View your logs at https://app.logdna.com or live tail using our [CLI](https://github.com/logdna/logdna-cli).

## Prerequisites

- Kubernetes 1.2+

## Installing the Chart

To install the chart with the release name `my-release`, please follow directions from https://app.logdna.com/pages/add-source to obtain your LogDNA Ingestion Key:

```bash
$ helm install --name my-release \
    --set logdna.key=LOGDNA_INGESTION_KEY,logdna.autoupdate=1 stable/logdna-agent
```

You should see logs in https://app.logdna.com in a few seconds.

### Tags support:
```bash
$ helm install --name my-release \
    --set logdna.key=LOGDNA_INGESTION_KEY,logdna.tags=production,logdna.autoupdate=1 stable/logdna-agent
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the LogDNA Agent chart and their default values.

Parameter | Description | Default
--- | --- | ---
`logdna.key` | LogDNA Ingestion Key (Required) | None
`logdna.tags` | Optional tags such as `production` | None
`logdna.autoupdate` | Optionally turn on autoupdate by setting to 1 (auto sets image.pullPolicy to always) | `0`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`image.tag` | Image tag | `latest`
`priorityClassName` | (Optional) Set a PriorityClass on the Daemonset | `""`
`resources.limits.memory` | Memory resource limits | 500Mi                                      |
`tolerations` | List of node taints to tolerate | `[]`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set logdna.key=LOGDNA_INGESTION_KEY,logdna.tags=production,logdna.autoupdate=1 stable/logdna-agent
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/logdna-agent
```

> **Tip**: You can use the default [values.yaml](values.yaml)
