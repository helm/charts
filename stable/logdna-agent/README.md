# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# LogDNA Kubernetes Agent

[LogDNA](https://logdna.com) - Easy, beautiful logging in the cloud.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## TL;DR;

```bash
$ helm install --set logdna.key=LOGDNA_INGESTION_KEY --namespace logdna-agent --create-namespace myrelease stable/logdna-agent
```

## Introduction

This chart deploys LogDNA collector agents to all nodes in your cluster. Logs will ship from all containers. We extract pertinent Kubernetes metadata: pod name, container name, container id, namespace, labels, and annotations. View your logs at https://app.logdna.com or live tail using our [CLI](https://github.com/logdna/logdna-cli).

## Prerequisites

- Kubernetes 1.11.10+

## Installing the Chart

Please follow directions from https://app.logdna.com/pages/add-source to obtain your LogDNA Ingestion Key.

To install the chart with the release name `myrelease` and namespace `logdna-agent`:
```bash
$ helm install --set logdna.key=LOGDNA_INGESTION_KEY --namespace logdna-agent --create-namespace myrelease stable/logdna-agent
```

You should see logs in https://app.logdna.com in a few seconds.

> **Note**: If you're running helm 3.0+ then you might need to run the following first (as described in the [helm/charts readme](https://github.com/helm/charts#how-do-i-enable-the-stable-repository-for-helm-3)):
>
> ```bash
> $ helm repo add stable https://kubernetes-charts.storage.googleapis.com
> ```

### Tags support:
```bash
$ helm install --set logdna.key=LOGDNA_INGESTION_KEY,logdna.tags=production --namespace logdna-agent --create-namespace myrelease stable/logdna-agent
```

## Uninstalling the Chart

To uninstall/delete the `myrelease` deployment:

```bash
$ helm --namespace logdna-agent uninstall myrelease
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the LogDNA Agent chart and their default values.

Parameter | Description | Default
--- | --- | ---
`daemonset.tolerations` | List of node taints to tolerate | `[]`
`daemonset.updateStrategy` | Optionally set an update strategy on the daemonset. | None
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`logdna.key` | LogDNA Ingestion Key (Required) | None
`logdna.tags` | Optional tags such as `production` | None
`priorityClassName` | (Optional) Set a PriorityClass on the Daemonset | `""`
`resources.limits.memory` | Memory resource limits | 75Mi
`updateOnSecretChange` | Optionally set annotation on daemonset to cause deploy when secret changes | None
`extraEnv` | Additional environment variables | `{}`
`extraVolumeMounts` | Additional Volume mounts | `[]`
`extraVolumes` | Additional Volumes | `[]`
`serviceAccount.create` | Whether to create a service account for this release | `true`
`serviceAccount.name` | The name of the service account. Defaults to `logdna-agent` unless `serviceAccount.create=false` in which case it defaults to `default` | None

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --set logdna.key=LOGDNA_INGESTION_KEY,logdna.tags=production --namespace logdna-agent --create-namespace myrelease stable/logdna-agent
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install -f values.yaml --namespace logdna-agent --create-namespace myrelease stable/logdna-agent
```

> **Tip**: You can use the default [values.yaml](values.yaml)
