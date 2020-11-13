# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# sentry-kubernetes

[sentry-kubernetes](https://github.com/getsentry/sentry-kubernetes) is a utility that pushes Kubernetes events to [Sentry](https://sentry.io).

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

# Installation:

```console
$ helm install incubator/sentry-kubernetes --name my-release --set sentry.dsn=<your-dsn>
```

## Configuration

The following table lists the configurable parameters of the sentry-kubernetes chart and their default values.

| Parameter               | Description                                                                                                                 | Default                       |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| `sentry.dsn`            | Sentry dsn                                                                                                                  | Empty                         |
| `existingSecret`        | Existing secret to read DSN from                                                                                            | Empty                         |
| `sentry.environment`    | Sentry environment                                                                                                          | Empty                         |
| `sentry.release`        | Sentry release                                                                                                              | Empty                         |
| `sentry.logLevel`       | Sentry log level                                                                                                            | Empty                         |
| `sentry.eventLevels`    | Sentry event levels                                                                                                         | Empty                         |
| `image.repository`      | Container image name                                                                                                        | `getsentry/sentry-kubernetes` |
| `image.tag`             | Container image tag                                                                                                         | `latest`                      |
| `rbac.create`           | If `true`, create and use RBAC resources                                                                                    | `true`                        |
| `serviceAccount.name`   | Service account to be used. If not set and serviceAccount.create is `true`, a name is generated using the fullname template | ``                            |
| `serviceAccount.create` | If true, create a new service account                                                                                       | `true`                        |
| `priorityClassName`     | pod priorityClassName                                                                                                       | Empty                         |
