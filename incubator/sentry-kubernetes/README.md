# sentry-kubernetes

[sentry-kubernetes](https://github.com/getsentry/sentry-kubernetes) is a utility that pushes Kubernetes events to [Sentry](https://sentry.io).

# Installation:

```console
$ helm install incubator/sentry-kubernetes --name my-release --set sentry.dsn=<your-dsn>
```

## Configuration

The following tables lists the configurable parameters of the sentry-kubernetes chart and their default values.

|       Parameter         |           Description               |                         Default                     |
|-------------------------|-------------------------------------|-----------------------------------------------------|
| `sentry.dsn`            | Sentry dsn                          | Empty                                               |
| `image.repository`      | Container image name                | `getsentry/sentry-kubernetes`                       |
| `image.tag    `         | Container image tag                 | `latest`                                            |
| `rbac.create`                        | Create service account and ClusterRoleBinding for sentry | `true`|
| `rbac.serviceAccountName` | Existing ServiceAccount to use (ignored if rbac.create=true)| `default`    