# Mercure

[Mercure](https://mercure.rocks) is a protocol allowing to push data updates to web browsers and other HTTP clients in a convenient, fast, reliable and battery-efficient way.

## TL;DR;

```console
$ helm install stable/mercure
```

## Introduction

This chart bootstraps a [Mercure Hub](https://mercure.rocks) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/mercure
```

The command deploys the Mercure Hub on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Moodle chart and their default values.

| Parameter                 | Description                                                                                         | Default             |   |   |
|---------------------------|-----------------------------------------------------------------------------------------------------|---------------------|---|---|
| `allowAnonymous`          | set to `1` to allow subscribers with no valid JWT to connect                                        | `0`                 |   |   |
| `corsAllowedOrigins`      | a comma separated list of allowed CORS origins, can be `*` for all                                  | empty               |   |   |
| `debug`                   | set to `1` to enable the debug mode (prints recovery stack traces)                                  | `0`                 |   |   |
| `demo`                    | set to `1` to enable the demo mode (automatically enabled when `debug` is `1`)                      | `0`                 |   |   |
| `jwtKey`                  | the JWT key to use for both publishers and subscribers                                              | random string       |   |   |
| `logFormat`               | the log format                                                                                      | `FLUENTD`           |   |   |
| `publishAllowedOrigins`   | a comma separated list of origins allowed to publish (only applicable when using cookie-based auth) | empty               |   |   |
| `publisherJwtKey`         | must contain the secret key to valid publishers' JWT, can be omited in favor of `jwtKey`            | empty               |   |   |
| `subscriberJwtKey`        | must contain the secret key to valid subscribers' JWT, can be omited in favor of `jwtKey`           | empty               |   |   |
| `heartbeatInterval`       | interval between heartbeats (useful with some proxies, and old browsers)                            | `0s`                |   |   |
| `historyCleanupFrequency` | chances to trigger history cleanup when an update occurs (number between `0` and `1`)               | `0.3`               |   |   |
| `historySize`             | size of the history (`0` for no limits)                                                             | `0`                 |   |   |
| `readTimeout`             | maximum duration for reading the entire request, including the body                                 | `0s`                |   |   |
| `writeTimeout`            | maximum duration before timing out writes of the response                                           | `0s`                |   |   |
| `image.repository`        | controller container image repository                                                               | `dunglas/mercure`   |   |   |
| `image.tag`               | controller container image tag                                                                      | `v0.3.2`            |   |   |
| `image.pullPolicy`        | controller container image pull policy                                                              | `IfNotPresent`      |   |   |
| `nameOverride`            | Name override                                                                                       | empty               |   |   |
| `fullnameOverride`        | fullname override                                                                                   | `empty              |   |   |
| `service.type`            | Service type                                                                                        | `NodePort`          |   |   |
| `service.port`            | Service port                                                                                        | `80`                |   |   |
| `ingress.enabled`         | Enables Ingress                                                                                     | `false`             |   |   |
| `ingress.annotations`     | Ingress annotations                                                                                 | `{}`                |   |   |
| `ingress.paths`           | Ingress paths for all hostnames                                                                     | `["/"]`             |   |   |
| `ingress.hosts`           | Ingress accepted hostnames                                                                          | `["mercure.local"]` |   |   |
| `ingress.tls`             | Ingress TLS configuration                                                                           | `[]`                |   |   |
| `resources`               | controller pod resource requests & limits                                                           | `{}`                |   |   |
| `nodeSelector`            | node labels for controller pod assignment                                                           | `{}`                |   |   |
| `tolerations`             | controller pod toleration for taints                                                                | `{}`                |   |   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release --set jwtKey=FooBar,corsAllowedOrigins=example.com stable/mercure
```

The above command sets the JWT key to `FooBar`.
Additionally it allows pages served from `example.com` to connect to the hub.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/mercure
```

> **Tip**: You can use the default [values.yaml](values.yaml)
