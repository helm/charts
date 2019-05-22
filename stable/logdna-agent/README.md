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
- A LogDNA Ingestion Key

### Creating a Secret

The logdna-agent chart requires that you store your ingestion key inside a kubernetes secret using the key name logdna-agent-key. We suggest that you name the secret with the name of your release followed by logdna-agent, separated with a dash. For example if you plan to create a deployment with release name my-release then use this command (replaceing the X's with your ingestion key and substituting namespace_name with the namespace you want to use):

```
kubectl create secret generic my-release-logdna-agent \
  --from-literal='logdna-agent-key=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' \
  --namespace namespace_name
```
When installing the chart you must refer to the name of the secret you have created. In our previous example that name is `my-release-logdna-agent`.

## Installing the Chart

### Obtain LogDNA Ingestion Key from LogDNA server instance
Please follow directions from [LogDNA Instructions Page](https://app.logdna.com/pages/add-source) to obtain your LogDNA Ingestion Key.

### Install
To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release \
    --set logdna.key=LOGDNA_INGESTION_KEY,logdna.autoupdate=1 stable/logdna-agent
```

You should see logs in [LogDNA Console](https://app.logdna.com) in a few seconds.

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
`logdna.key` | LogDNA Ingestion Key (Required if no `secrets` provided) | None
`logdna.secrets` | Custom Template Having `logdna-agent-key` (Required if no `key` provided) | None
`logdna.tags` | Optional tags such as `production` | None
`logdna.autoupdate` | Optionally turn on autoupdate by setting to `"1"` (auto sets image.pullPolicy to always) | `"0"`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`image.tag` | Image tag | `latest`
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

## Support

### Connecting to LogDNA server instance
If you configure your agent to connect to LogDNA directly, you may contact LogDNA support through the [LogDNA web console](https://app.logdna.com/) if you experience issues connecting to LogDNA directly.

> **Tip**: You can use the default [values.yaml](values.yaml)
