# sentry-kubernetes

[sentry-kubernetes](https://github.com/getsentry/sentry-kubernetes) is a utility that pushes Kubernetes events to [Sentry](https://sentry.io).

Installation:

```console
$ helm install incubator/sentry-kubernetes --name my-release --set sentry.dsn=<your-dsn>
```
