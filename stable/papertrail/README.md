# Papertrail

[Papertrail](https://papertrailapp.com) is a hosted log aggregation and viewing platform.

## Introduction

This chart deploys the agent (log collector) to your cluster as a daemonset. The daemonset will collect logs and send them to your Papertrail account.

The chart can run as a Syslog collector or as a Fluentd collector. For more information on these two modes, the Papertrail docs explain how to use them at https://help.papertrailapp.com/kb/configuration/configuring-centralized-logging-from-kubernetes/.

## Prerequisites

Kubernetes 1.6.

## Installing the Chart

To install the chart with the release name `my-release`, retrieve your Papertrail host and port from a new destination at [Papertrailapp.com](https://papertrailapp.com/account/destinations) and run:

```bash
$ helm install --name my-release \
    --set papertrail.host=YOUR-HOST \
    --set papertrail.port=YOUR-PORT \
    stable/papertrail
```

After a few minutes, you should see the logs showing up in your Papertrail dashboard.

**Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the SignalSciences chart and their default values.

| Parameter                                      | Description                                                                          | Default                                 |
|------------------------------------------------|--------------------------------------------------------------------------------------|-----------------------------------------|
| `papertrail.host`                              | Your Papertrail destination hostname                                                 | `Nil`                                   |
| `papertrail.port`                              | Your papertrail destination port                                                     | `Nil`                                   |
| `fluentdImage.repository`                      | The image repository to pull from when running the fluentd DaemonSet                 | `quay.io/solarwinds/fluentd-kubernetes` |
| `fluentdImage.tag`                             | The image tag to pull when running the fluentd DaemonSet                             | `v1.2-debian-papertrail-0.2.6`          |
| `fluentdImage.pullPolicy`                      | Image pull policy run running the fluentd DaemonSet                                  | `IfNotPresent`                          |
| `logspoutImage.repository`                     | The image repository to pull from when running the logspout DaemonSet                | `gliderlabs/logspout`                   |
| `logspoutImage.tag`                            | The image tag to pull when running the logspout DaemonSet                            | `master`                                |
| `logspoutImage.pullPolicy`                     | Image pull policy when running the logspout DeemonSet                                | `IfNotPresent`                          |
| `resources.requests.cpu`                       | CPU resource requests                                                                | `50m`                                  |
| `resources.limits.cpu`                         | CPU resource limits                                                                  | `100m`                                  |
| `resources.requests.memory`                    | Memory resource requests                                                             | `400Mi`                                 |
| `resources.limits.memory`                      | Memory resource limits                                                               | `400Mi`                                 |
| `daeamonset.type`                              | Type of DaemonSet to deploy (can be `logspout` or `fluentd`)                         | `logspout`                              |
| `daemonset.podAnnotations`                     | Annotations to add to the DaemonSet's Pods                                           | `nil`                                   |
| `daemonset.tolerations`                        | List of node taints to tolerate (requires Kubernetes >= 1.6)                         | `nil`                                   |
| `daemonset.nodeSelector`                       | Node selectors                                                                       | `nil`                                   |
| `daemonset.affinity`                           | Node affinities                                                                      | `nil`                                   |
| `daemonset.updateStrategy`                     | Update strategy                                                                      | `RollingUpdate`                         |
| `papertrail.logspout.dockerSockPath`           | Location of the docker.sock file, used when running the logspout DaemonSet           | `/var/run/docker.sock`                  |
| `papertrail.fluentd.varLogDir`                 | Location of the var/log directory, used when running the fluentd DaemonSet           | `/var/log`                              |
| `papertrail.fluentd.varLibDockerContainersDir` | Location of the docker containers directory, used when running the fluentd DaemonSet | `/var/lib/docker/containers`            |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set papertrail.host=YOUR-HOST,papertrail.port=YOUR-PORT \
    stable/papertrail
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f my-values.yaml stable/papertrail
```

**Tip**: You can copy and customize the default [values.yaml](values.yaml)

