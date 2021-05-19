# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Mercure

[Mercure](https://mercure.rocks) is a protocol allowing to push data updates to web browsers and other HTTP clients in a convenient, fast, reliable and battery-efficient way.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

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

The following table lists the configurable parameters of the Mercure chart and their default values.

| Parameter               | Description                                                                                                                                                                                                                                                                                                                                                                               | Default                                          |   |   |
|-------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------|---|---|
| `transportUrl`          | URL representation of the history database, see [the dedicated documentation](https://mercure.rocks/docs/hub/config#bolt-adapter)                                                                                                                                                                                                                                                         | `bolt://updates.db?size=0&cleanup_frequency=0.3` |   |   |
| `allowAnonymous`        | set to `true` to allow subscribers with no valid JWT to connect                                                                                                                                                                                                                                                                                                                           | `false`                                          |   |   |
| `subscriptions`         | set to `true` to expose the subscription web API and dispatch private updates when a subscription between the Hub and a subscriber is established or closed                                                                                                                                                                                                                               | `false`                                          |   |   |
| `metrics`               | set to `true` to enable the `/metrics` HTTP endpoint. Provide metrics for Hub monitoring in the OpenMetrics (Prometheus) format                                                                                                                                                                                                                                                           | `mercure`                                        |   |   |
| `metricsLogin`          | if metrics are enabled, the login of the allowed user to access the `/metrics` endpoint                                                                                                                                                                                                                                                                                                   | `mercure`                                        |   |   |
| `metricsPassword`       | if metrics are enabled, the password of the allowed user to access the `/metrics` endpoint                                                                                                                                                                                                                                                                                                | random string                                    |   |   |
| `corsAllowedOrigins`    | a list of allowed CORS origins, can contain `*` for all                                                                                                                                                                                                                                                                                                                                   | `[]`                                             |   |   |
| `debug`                 | set to `true` to enable the debug mode (prints recovery stack traces)                                                                                                                                                                                                                                                                                                                     | `false`                                          |   |   |
| `demo`                  | set to `true` to enable the demo mode (automatically enabled when `debug` is `true`)                                                                                                                                                                                                                                                                                                      | `false`                                          |   |   |
| `jwtAlgorithm`          | the JWT verification algorithm to use for both publishers and subscribers, e.g. `HS256` (default) or `RS512`                                                                                                                                                                                                                                                                              | `HS256`                                          |   |   |
| `jwtKey`                | the JWT key to use for both publishers and subscribers                                                                                                                                                                                                                                                                                                                                    | random string                                    |   |   |
| `logFormat`             | the log format                                                                                                                                                                                                                                                                                                                                                                            | `FLUENTD`                                        |   |   |
| `publishAllowedOrigins` | a list of origins allowed to publish (only applicable when using cookie-based auth)                                                                                                                                                                                                                                                                                                       | `[]`                                             |   |   |
| `publisherJwtKey`       | must contain the secret key to valid publishers' JWT, can be omitted in favor of `jwtKey`                                                                                                                                                                                                                                                                                                 | empty                                            |   |   |
| `subscriberJwtKey`      | must contain the secret key to valid subscribers' JWT, can be omitted in favor of `jwtKey`                                                                                                                                                                                                                                                                                                | empty                                            |   |   |
| `heartbeatInterval`     | interval between heartbeats (useful with some proxies, and old browsers)                                                                                                                                                                                                                                                                                                                  | `0s`                                             |   |   |
| `readTimeout`           | maximum duration for reading the entire request, including the body, set to `0s` to disable                                                                                                                                                                                                                                                                                               | `5s`                                             |   |   |
| `writeTimeout`          | maximum duration before timing out writes of the response, set to `0s` to disable                                                                                                                                                                                                                                                                                                         | `60s`                                            |   |   |
| `dispatchTimeout`       | maximum duration of the dispatch of a single update, set to `0s` to disable response                                                                                                                                                                                                                                                                                                      | `5s`                                             |   |   |
| `useForwardedHeaders`   | use the `X-Forwarded-For`, and `X-Real-IP` for the remote (client) IP address, `X-Forwarded-Proto` or `X-Forwarded-Scheme` for the scheme (http or https), `X-Forwarded-Host` for the host and the RFC 7239 `Forwarded` header, which may include both client IPs and schemes. If this option is enabled, the reverse proxy must override or remove these headers or you will be at risk. | `false`                                          |   |   |
| `compress`              | set to `false` to disable HTTP compression support                                                                                                                                                                                                                                                                                                                                        | `true`                                           |   |   |
| `license`               | the license to use (only useful for HA versions)                                                                                                                                                                                                                                                                                                                                          | empty                                            |   |   |
| `image.repository`      | controller container image repository                                                                                                                                                                                                                                                                                                                                                     | `dunglas/mercure`                                |   |   |
| `image.tag`             | controller container image tag                                                                                                                                                                                                                                                                                                                                                            | `v0.3.2`                                         |   |   |
| `image.pullPolicy`      | controller container image pull policy                                                                                                                                                                                                                                                                                                                                                    | `IfNotPresent`                                   |   |   |
| `nameOverride`          | Name override                                                                                                                                                                                                                                                                                                                                                                             | empty                                            |   |   |
| `fullnameOverride`      | fullname override                                                                                                                                                                                                                                                                                                                                                                         | `empty                                           |   |   |
| `service.type`          | Service type                                                                                                                                                                                                                                                                                                                                                                              | `NodePort`                                       |   |   |
| `service.port`          | Service port                                                                                                                                                                                                                                                                                                                                                                              | `80`                                             |   |   |
| `ingress.enabled`       | Enables Ingress                                                                                                                                                                                                                                                                                                                                                                           | `false`                                          |   |   |
| `ingress.annotations`   | Ingress annotations                                                                                                                                                                                                                                                                                                                                                                       | `{}`                                             |   |   |
| `ingress.hosts`         | Ingress accepted hostnames                                                                                                                                                                                                                                                                                                                                                                | `[{ host: chart-example.local, paths: [] }]`     |   |   |
| `ingress.tls`           | Ingress TLS configuration                                                                                                                                                                                                                                                                                                                                                                 | `[]`                                             |   |   |
| `serviceAccount.create` | Whether or not to create dedicated serviceAccount for ignite                                                                                                                                                                                                                                                                                                                              | `true`                                           |   |   |
| `serviceAccount.name`   | If `serviceAccount.create` is enabled, what should the `serviceAccount` name be - otherwise randomly generated                                                                                                                                                                                                                                                                            | `nil`                                            |   |   |
| `podSecurityContext`    | Pod Security Context                                                                                                                                                                                                                                                                                                                                                                      | `{}`                                             |   |   |
| `securityContext`       | Container Security Context                                                                                                                                                                                                                                                                                                                                                                | `{}`                                             |   |   |
| `resources`             | controller pod resource requests & limits                                                                                                                                                                                                                                                                                                                                                 | `{}`                                             |   |   |
| `nodeSelector`          | node labels for controller pod assignment                                                                                                                                                                                                                                                                                                                                                 | `{}`                                             |   |   |
| `tolerations`           | controller pod toleration for taints                                                                                                                                                                                                                                                                                                                                                      | `{}`                                             |   |   |

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
