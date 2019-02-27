# Gitlab-CI Pipeline exporter

* Installs [gitlab-ci pipeline exporter](https://github.com/Labbs/gitlab-ci-pipelines-exporter)

## TL;DR;

```console
$ helm install stable/prometheus-gitlab-pipeline-exporter
```

## Introduction

This chart bootstraps a [gitlab-ci pipeline exporter](https://github.com/Labbs/gitlab-ci-pipelines-exporter) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- [Gitlab token](https://gitlab.com/profile/personal_access_tokens) with API scope

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/prometheus-gitlab-pipeline-exporter --set gitlab.token=my-token

# If you have an on-premise Gitlab instance
$ helm install --name my-release stable/prometheus-gitlab-pipeline-exporter \
--set gitlab.token=my-token,gitlab.url=https://gitlab.test.com
```

The command deploys gitlab-ci pipeline exporter on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Cloudwatch Exporter chart and their default values.

|          Parameter          |                      Description                       |          Default          |
| --------------------------- | ------------------------------------------------------ | --------------------------|
| `gitlab.url`                | Gitlab instance (http/https)                           | `https://gitlab.com`      |
| `gitlab.token`              | API Acees token                                        |                           |
| `gitlab.refresh`            | Refresh every x seconds projects and pipelines status  | `30`                      |
| `gitlab.owned`              | Only get yours repos and pipelines                     | `true`                   |
| `image.tag`                 | Image tag                                              | `v1.1`                    |
| `image.pullPolicy`          | Image pull policy                                      | `IfNotPresent`            |
| `service.type`              | Service type                                           | `ClusterIP`               |
| `service.port`              | The service port                                       | `9999`                    |
| `resources`                 |                                                        | `{}`                      |
| `tolerations`               | Add tolerations                                        | `[]`                      |
| `nodeSelector`              | node labels for pod assignment                         | `{}`                      |
| `affinity`                  | node/pod affinities                                    | `{}`                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
    --set gitlab.token=my-token \
    stable/prometheus-gitlab-pipeline-exporter
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/prometheus-gitlab-pipeline-exporter
```
