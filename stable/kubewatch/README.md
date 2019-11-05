# kubewatch

[kubewatch](https://github.com/bitnami-labs/kubewatch) is a Kubernetes watcher that currently publishes notification to Slack. Run it in your k8s cluster, and you will get event notifications in a slack channel.


## TL;DR;

```console
$ helm install stable/kubewatch
```

## Introduction

This chart bootstraps a kubewatch deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install stable/kubewatch --name my-release
```

The command deploys kubewatch on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the kubewatch chart and their default values.

|               Parameter                  |        Description                                                                                         |              Default              |
| ---------------------------------------- | ---------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `global.imageRegistry`                   | Global Docker image registry                                                                               | `nil`                             |
| `global.imagePullSecrets`                | Global Docker registry secret names as an array                                                            | `[]` (does not add image pull secrets to deployed pods) |
| `affinity`                               | node/pod affinities                                                                                        | None                              |
| `image.registry`                         | Image registry                                                                                             | `docker.io`                       |
| `image.repository`                       | Image repository                                                                                           | `bitnami/kubewatch`               |
| `image.tag`                              | Image tag                                                                                                  | `{VERSION}`                       |
| `image.pullPolicy`                       | Image pull policy                                                                                          | `Always`                          |
| `nameOverride`                           | String to partially override kubewatch.fullname template with a string (will prepend the release name)     | `nil`                             |
| `fullnameOverride`                       | String to fully override kubewatch.fullname template with a string                                         | `nil`                             |
| `nodeSelector`                           | node labels for pod assignment                                                                             | `{}`                              |
| `podAnnotations`                         | annotations to add to each pod                                                                             | `{}`                              |
| `podLabels`                              | additional labesl to add to each pod                                                                       | `{}`                              |
| `replicaCount`                           | desired number of pods                                                                                     | `1`                               |
| `rbac.create`                            | If true, create & use RBAC resources                                                                       | `true`                            |
| `serviceAccount.create`                  | If true, create a serviceAccount                                                                           | `true`                            |
| `serviceAccount.name`                    | existing ServiceAccount to use (ignored if rbac.create=true)                                               | ``                                |
| `resources`                              | pod resource requests & limits                                                                             | `{}`                              |
| `slack.enabled`                          | Enable Slack notifications                                                                                 | `true`                            |
| `slack.channel`                          | Slack channel to notify                                                                                    | `""`                              |
| `slack.token`                            | Slack API token                                                                                            | `""`                              |
| `hipchat.enabled`                        | Enable HipChat notifications                                                                               | `false`                           |
| `hipchat.url`                            | HipChat URL                                                                                                | `""`                              |
| `hipchat.room`                           | HipChat room to notify                                                                                     | `""`                              |
| `hipchat.token`                          | HipChat token                                                                                              | `""`                              |
| `mattermost.enabled`                     | Enable Mattermost notifications                                                                            | `false`                           |
| `mattermost.channel`                     | Mattermost channel to notify                                                                               | `""`                              |
| `mattermost.username`                    | Mattermost user to notify                                                                                  | `""`                              |
| `mattermost.url`                         | Mattermost URL                                                                                             | `""`                              |
| `flock.enabled`                          | Enable Flock notifications                                                                                 | `false`                           |
| `flock.url`                              | Flock URL                                                                                                  | `""`                              |
| `webhook.enabled`                        | Enable Webhook notifications                                                                               | `false`                           |
| `webhook.url`                            | Webhook URL                                                                                                | `""`                              |
| `tolerations`                            | List of node taints to tolerate (requires Kubernetes >= 1.6)                                               | `[]`                              |
| `namespaceToWatch`                       | namespace to watch, leave it empty for watching all                                                        | `""`                              |
| `resourcesToWatch`                       | list of resources which kubewatch should watch and notify slack                                            | `{pod: true, deployment: true}`   |
| `resourcesToWatch.pod`                   | watch changes to [Pods](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/)                  | `true`                            |
| `resourcesToWatch.deployment`            | watch changes to [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)      | `true`                            |
| `resourcesToWatch.replicationcontroller` | watch changes to [ReplicationControllers](https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller/) | `false`          |
| `resourcesToWatch.replicaset`            | watch changes to [ReplicaSets](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)      | `false`                           |
| `resourcesToWatch.daemonset`             | watch changes to [DaemonSets](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)        | `false`                           |
| `resourcesToWatch.services`              | watch changes to [Services](https://kubernetes.io/docs/concepts/services-networking/service/)              | `false`                           |
| `resourcesToWatch.job`                   | watch changes to [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/) | `false`                           |
| `resourcesToWatch.persistentvolume`      | watch changes to [PersistentVolumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)      | `false`                           |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/kubewatch --name my-release \
  --set=slack.channel="#bots",slack.token="XXXX-XXXX-XXXX"
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/kubewatch --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Create a Slack bot

Open [https://my.slack.com/services/new/bot](https://my.slack.com/services/new/bot) to create a new Slack bot.
The API token can be found on the edit page (it starts with `xoxb-`).

Invite the Bot to your channel by typing `/join @name_of_your_bot` in the Slack message area.
