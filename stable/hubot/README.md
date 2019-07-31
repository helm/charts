# Hubot

Hubot 3 chatbot with the Slack adaptor

Learn more: https://hubot.github.com

## TL;DR;

```bash
helm install stable/hubot
```

## Introduction

This chart creates a Hubot deployment on a [Kubernetes](http://kubernetes.io)
cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm install --name my-release stable/hubot
```

The command deploys Hubot on the Kubernetes cluster using the default configuration.
The [configuration](#configuration) section lists the parameters that can be
configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
helm delete --purge my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Hubot chart and their default values.

Parameter | Description | Default
--- | --- | ---
`fullnameOverride` | Override the full resource names | `""`
`replicaCount` | Desired number of pods | `1`
`strategyType` | Type of deployment strategy (usually only one instance of Hubot needed at the time) | `Recreate`
`image.repository` | Container image repository | `decayofmind/hubot`
`image.tag` | Container image tag | `3.3.2`
`image.pullPolicy` | Container image pull policy | `IfNotPresent`
`service.type` | Type of service to create | `NodePort`
`service.port` | Port for the http service | `80`
`hubot.config` | Hubot configuration (environment variables) | `{}`
`hubot.extraArgs` | Additional arguments to Hubot binary | `[]`
`hubot.scripts` | Custom hubot scripts | `{}`
`hubot.scriptsRepo.enable` | Flag to checkout repo with scripts | `false`
`hubot.scriptsRepo.image` | Image with git-sync | `k8s.gcr.io/git-sync:v3.1.2`
`hubot.scriptsRepo.repository` | Git repository to checkout | `""`
`hubot.scriptsRepo.branch` | Branch in repository to checkout from | `master`
`hubot.scriptsRepo.username` | Git repo username | `null`
`hubot.scriptsRepo.password` | Password for git repo | `null`
`hubot.scriptsRepo.existingSecretName` | Set if your git credentials are stored in some existing Secret | `null`
`hubot.extraPackages` | List of additional npm packages to install on Hubot startup (usually, dependencies for scripts) | `[]`
`hubot.externalScripts` | Content for external-scripts.json file (all listed packages will be installed on startup) | `[hubot-diagnostics, hubot-health, hubot-help, hubot-redis-brain, hubot-rules, hubot-plusplus]`
`redis.enabled` | Install a dependency chart with Redis (needed for hubot-brain) | `true`
`ingress.enabled` | flag to add ingress functionality | `false`
`ingress.annotations` | ingress load balancer annotations | `Always`
`ingress.path` | proxied path | `/`
`ingress.hosts` | proxied hosts | `[ hubot.local ]`
`ingress.tls` | tls certificate secrets | `[]`
`resources` | resource requests & limits | `{}`
`extraConfigMapMounts` | Additional configMaps to be mounted (good for extra files, certs) | `[]`
`extraLabels` | Extra labels to add to the Resources | `{}`
`nodeSelector` | node selector logic | `{}`
`tolerations` | resource tolerations | `{}`
`affinity` | node affinity | `{}`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.
For example:

```bash
$ helm install --name my-release \
    --set key_1=value_1,key_2=value_2 \
    stable/hubot
```

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,

```bash
# example for staging
$ helm install --name my-release -f values.yaml stable/hubot
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Specific hubot settings

#### Config

With the `hubot.config` parameter you can provide a hash that will be used as
environment variables by hubot. These environment variables will be picked by
hubot's scripts.

For instance:

```yaml
hubot:
  config:
    HUBOT_STANDUP_PREPEND: '@channel'
```

A content of the hash will be stored as Secret.

#### Scripts

There are three ways of how to extend Hubot with scripts:

* Install via npm and enable in `external-scripts.json` file
* Use a git repository with scripts and set `hubot.scriptsRepo.enabled` to `true`.
  It's common for companies to have a dedicated repo with customized scripts.
* List scripts in `hubot.scripts` hash (good for small scripts).
In addition, you can add your own scripts, which will be created in the scripts
folder, with `.js` or `.coffee` format.
See [Hubot Scripting](https://hubot.github.com/docs/scripting/).

For example:

```yaml
hubot:
  scripts:
    hithere.coffee: |
      # Description
      #   A hubot script that is an example for this chart
      module.exports = (robot) ->
        robot.respond /hi my bot/i, (msg) ->
          msg.send 'Hi there my human'
```
