# Stack to Slack

[Stack to Slack](https://github.com/dunglas/stack2slack) is a Slack bot that monitors StackExchange tags and automatically
publishes new questions in configured Slack channels.

## Introduction

This chart adds a Stack to Slack deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh)
package manager.

## Prerequisites

- Kubernetes 1.2+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`, [retrieve a Slack API token for bot](https://my.slack.com/services/new/bot) and run:

```bash
$ helm install --name my-release \
    --set slackApiToken=<slackApiToken> \
    --set tagToChannel.stackExchangeTag=slackChannel stable/stack2slack
```

Then, from Slack, invite the bot in the channel: `/invite @theBotName`

After a few minutes, you should see all new questions posted on StackExchange appearing in the Slack channel.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Stack to Slack chart and their default values.

|      Parameter              |          Description                     |               Default               |
|-----------------------------|------------------------------------------|-------------------------------------|
| `slackApiToken`             | The Slack API token for the bot          | `Nil` You must provide your own key |
| `tagToChannel`              | StackExchange tags to Slack channels map | Empty                               |
| `debug`                     | Enable debug logs                        |  0                                  |
| `stackSite`                 | The StackExchange site to monitor        |  stackoverflow                      |
| `image.repository`          | The image repository to pull from        | `sysdig/agent`                      |
| `image.tag`                 | The image tag to pull                    | `latest`                            |
| `image.pullPolicy`          | The Image pull policy                    | `Always`                            |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set slackApiToken=YOUR-KEY-HERE,tagToChannel.mytag=mychan \
    stable/stack2slack
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/stack2slack
```

> **Tip**: You can use the default [values.yaml](values.yaml)
