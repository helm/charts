# Sysdig

[Sysdig](https://www.sysdig.com/) is a unified platform for container and microservices monitoring, troubleshooting, security and forensics. Sysdig platform has been built on top of [Sysdig tool](https://sysdig.com/opensource/sysdig/) and [Sysdig Inspect](https://sysdig.com/blog/sysdig-inspect/) open-source technologies.

## Introduction

This chart adds the Sysdig agent for [Sysdig Monitor](https://sysdig.com/product/monitor/) and [Sysdig Secure](https://sysdig.com/product/secure/) to all nodes in your cluster via a DaemonSet.

## Prerequisites

- Kubernetes 1.2+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`, retrieve your Sysdig Monitor Access Key from your [Account Settings](https://app.sysdigcloud.com/#/settings/user) and run:

```bash
$ helm install --name my-release \
    --set sysdig.accessKey=YOUR-KEY-HERE stable/sysdig
```

After a few seconds, you should see hosts and containers appearing in Sysdig Monitor and Sysdig Secure.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```
> **Tip**: Use helm delete --purge my-release to completely remove the release from Helm internal storage

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Sysdig chart and their default values.

| Parameter               | Description                             | Default                                     |
| ---                     | ---                                     | ---                                         |
| `image.repository`      | The image repository to pull from       | `sysdig/agent`                              |
| `image.tag`             | The image tag to pull                   | `latest`                                    |
| `image.pullPolicy`      | The Image pull policy                   | `Always`                                    |
| `rbac.create`           | If true, create & use RBAC resources    | `true`                                      |
| `serviceAccount.create` | Create serviceAccount                   | `true`                                      |
| `serviceAccount.name`   | Use this value as serviceAccountName    | ` `                                         |
| `sysdig.accessKey`      | Your Sysdig Monitor Access Key          | `Nil` You must provide your own key         |
| `sysdig.settings`       | Settings for agent's configuration file | `{}`                                        |
| `secure.enabled`        | Enable Sysdig Secure                    | `false`                                     |
| `tolerations`           | The tolerations for scheduling          | `node-role.kubernetes.io/master:NoSchedule` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set sysdig.accessKey=YOUR-KEY-HERE,sysdig.AgentTags="role:webserver,location:europe" \
    stable/sysdig
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/sysdig
```

> **Tip**: You can use the default [values.yaml](values.yaml)
