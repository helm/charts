# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

## Hubot

Hubot 3 chatbot with the Slack adaptor

Learn more: https://hubot.github.com

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

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
`strategyType` | Type of deployment strategy | `RollingUpdate`
`image.repository` | Container image repository | `minddocdev/hubot`
`image.tag` | Container image tag | `3.3.2`
`image.pullPolicy` | Container image pull policy | `IfNotPresent`
`service.type` | Type of service to create | `NodePort`
`service.port` | Port for the http service | `80`
`config` | Hubot configuration (environment variables) | `{}`
`secretConfig` | Sensitive environment variables passed to Hubot as Secret | `{}`
`existingSecretConfigName` |  Reference to an existing Secret with sensitive env vars | `""`
`args` | Arguments passed to Hubot binary | `["--name", "${HUBOT_NAME}", "--adapter", "--slack"]`
`extraArgs` | Additional arguments to Hubot binary | `[]`
`scripts` | Custom hubot scripts | `{}`
`scriptsRepo.enable` | Flag to checkout repo with scripts | `false`
`scriptsRepo.image` | Image with git-sync | `k8s.gcr.io/git-sync:v3.1.2`
`scriptsRepo.repository` | Git repository to checkout | `""`
`scriptsRepo.branch` | Branch in repository to checkout from | `master`
`scriptsRepo.username` | Git repo username | `null`
`scriptsRepo.password` | Password for git repo | `null`
`scriptsRepo.existingSecretName` | Set if your git credentials are stored in some existing Secret | `null`
`extraPackages` | List of additional npm packages to install on Hubot startup (usually, dependencies for scripts) | `[]`
`externalScripts` | Content for external-scripts.json file (all listed packages will be installed on startup) | `[]`
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

The chart provides you with two dictionaries: `config` and `secretConfig`.
Hashes in both of these variables will be exposed to the Hubot process
as environment variables and may be picked by scripts.

The difference between them is that the `config` dictionary will be saved as
ConfigMap object, but the value of `secretConfig` will be saved as a Secret object.

For instance:

```yaml
config:
  HUBOT_STANDUP_PREPEND: '@channel'

secretConfig:
  HUBOT_SLACK_TOKEN: 'xxx-secret-token-xxx'
```

#### Redis

By default, this chart will deploy a [Redis chart](https://github.com/helm/charts/tree/master/stable/redis)
as a dependency. It's required by "hubot-redis-brain" script, which provides persistent
storage for Hubot.
In this case, the value of `REDIS_URL` environment variable will be set automatically.

If you want Hubot to use an already existing Redis instance, you need to have
`redis.enabled` set to `false` and then set `REDIS_URL` variable, pointing to that
instance in `config` or `secretConfig` dictionaries.

For instance:

```
redis:
  enabled: false

secretConfig:
  REDIS_URL: "redis://:password@mycompany.redis:6379/prefix"

```


#### Scripts

There are three ways of how to extend Hubot with scripts:

* Install via npm and enable in `external-scripts.json` file
* Use a git repository with scripts and set `scriptsRepo.enabled` to `true`.
  It's common for companies to have a dedicated repo with customized scripts.
* List scripts in `scripts` hash (good for small scripts).
In addition, you can add your own scripts, which will be created in the scripts
folder, with `.js` or `.coffee` format.
See [Hubot Scripting](https://hubot.github.com/docs/scripting/).

For example:

```yaml
scripts:
  hithere.coffee: |
    # Description
    #   A hubot script that is an example for this chart
    module.exports = (robot) ->
      robot.respond /hi my bot/i, (msg) ->
        msg.send 'Hi there my human'
```
