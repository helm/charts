# Slackin

[Slackin](https://github.com/rauchg/slackin) is a little server that enables public access to a Slack server.

## TL;DR;

```console
$ helm install stable/slackin
```

## Introduction

This chart bootstraps a [Slackin](https://github.com/codeformuenster/slackin-docker) deployment.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release \
    --set slack.teamId=TEAM-ID-HERE,slack.apiToken=API-KEY-HERE \
    slackin
```

_Replace the `TEAM-ID-HERE` and `API-KEY-HERE` placeholders with the Slack team id and api access key respectively. [More Info](https://github.com/rauchg/slackin#tips)_

## Uninstalling the Chart

To completely uninstall/delete the `my-release` deployment:

```console
$ helm delete --purge my-release
```

## Configuration

The following tables lists the configurable parameters of the Slackin chart and their default values.

|     Parameter      |             Description             |                                  Default                                  |
|--------------------|-------------------------------------|---------------------------------------------------------------------------|
| `image.name`       | Slackin image                       | `bitnami/chk1/slackin`                                                    |
| `image.digest`     | Slackin image digest                | `sha256:476ae1beb981449c1b61794bb9ec52beeff1c312ff54fbcd3010946b991975f8` |
| `image.pullPolicy` | Image pull policy                   | `IfNotPresent`                                                            |
| `slack.teamId`     | Slack team id                       | `nil` (required) [more info](https://github.com/rauchg/slackin#tips)      |
| `slack.apiKey`     | Slack admin user api key            | `nil` (required) [more info](https://github.com/rauchg/slackin#tips)      |
| `ingress.hostname` | Ingress hostname of the Slackin     | `slackin.local`                                                           |
| `ingress.tls`      | Ingress TLS configuration           | `[]`                                                                      |
| `service.type`     | Kubernetes Service type             | `NodePort`                                                                |
| `resources`        | CPU/Memory resource requests/limits | Memory: `64Mi`, CPU: `20m`                                                |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
    --set slack.teamId=my-oss-team,slack.apiToken=admin-api-key-issued-by-slack \
    stable/slackin
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/slackin
```

> **Tip**: You can use the default [values.yaml](values.yaml)
