# Running Buildkite agent - DEPRECATED

**This chart is deprecated! You can find the new chart in:**
- **Sources:** https://github.com/buildkite/charts
- **Charts repository:** https://buildkite.github.io/charts/

```bash
helm repo add buildkite https://buildkite.github.io/charts/
```

## Introduction

This chart bootstraps a [buildkite agent](https://github.com/buildkite/docker-buildkite-agent) builder on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.
As it sets `service account` it can be used to build Docker images and deploy them using `kubectl` and `helm` clients in the same cluster where agents run, without any extra setup.


## Installing the Chart

In order for the chart to configure the Buildkite Agent properly during the installation process, you must provide some minimal configuration which can't rely on defaults. This includes at least one element in the _agent_ list `token`:

To install the chart with the release name `bk-agent`:

```bash
$ helm install stable/buildkite --name bk-agent --namespace buildkite --set agent.token="BUILDKITE_AGENT_TOKEN"
```

To install the chart with the release name `bk-agent` and set Agent meta-data and git repo SSH key:
```console
$ helm install stable/buildkite --name bk-agent --namespace buildkite \
  --set agent.token="$(cat buildkite.token)",agent.meta="role=production",privateSshKey="$(cat buildkite.key)"
```

Where `--set` values contain:
```
agentToken: Buildkite token read from file
agentMeta: tagging agent with - role=production
privateSshKey: private SSH key read from file
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `bk-agent` release:

```bash
$ helm delete bk-agent
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `buildkite` chart and their default values.

Parameter | Description | Default
--- | --- | ---
`replicaCount` | Replicas count | 1
`image.repository` | Image | `buildkite/agent`
`image.tag` | Image tag | `3.0`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`agent.token` | Agent token | Must be specified
`agent.meta` | Agent meta-data | `role=agent`
`extraEnv` | Agent extra env vars | `nil`
`privateSshKey` | Agent ssh key for git access | `nil`
`registryCreds.gcrServiceAccountKey` | GCP Service account json key | `nil`
`registryCreds.dockerConfig` | Private registry docker config.json | `nil`
`resources` | pod resource requests & limits | `{}`
`nodeSelector` | node labels for pod assignment | `{}`

## Buildkite pipeline examples

Check for examples of `pipeline.yml` and `build/deploy` scripts [here](pipeline-examples).
