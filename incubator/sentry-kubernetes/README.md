# sentry-kubernetes

[sentry-kubernetes](https://github.com/getsentry/sentry-kubernetes) is a utility that pushes Kubernetes events to [Sentry](https://sentry.io).

# Installation:

```console
$ helm install incubator/sentry-kubernetes --name my-release --set sentry.dsn=<your-dsn>
```

## Configuration

The following table lists the configurable parameters of the sentry-kubernetes chart and their default values.

| Parameter               | Description                                                                                                                 | Default                       |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| `sentry.dsn`            | Sentry dsn                                                                                                                  | Empty                         |
| `existingSecret`        | Existing secret to read DSN from                                                                                           | Empty                         |
| `sentry.environment`    | Sentry environment                                                                                                          | Empty                         |
| `sentry.release`        | Sentry release                                                                                                              | Empty                         |
| `sentry.logLevel`       | Sentry log level                                                                                                            | Empty                         |
| `sentry.mangleNames`    | Comma-separated list of object kinds for which object name should be mangled                                                | Empty                         |
| `sentry.eventLevels`    | Comma-separated list of event levels for which events should be reported                                                    | Empty                         |
| `sentry.reasonFilter`   | Comma-separated list of reasons for which events should *not* be reported                                                   | Empty                         |
| `sentry.componentFilter`| Comma-separated list of components for which events should *not* be reported                                                | Empty                         |
| `sentry.eventNamespaces`| Comma-separated list of namespaces for which events should be reported                                                      | Empty                         |
| `image.repository`      | Container image name                                                                                                        | `getsentry/sentry-kubernetes` |
| `image.tag`             | Container image tag                                                                                                         | `latest`                      |
| `rbac.create`           | If `true`, create and use RBAC resources                                                                                    | `true`                        |
| `serviceAccount.name`   | Service account to be used. If not set and serviceAccount.create is `true`, a name is generated using the fullname template | ``                            |
| `serviceAccount.create` | If true, create a new service account                                                                                       | `true`                        |
