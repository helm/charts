# Prometheus Operator Helm Chart

[prometheus-operator](https://github.com/coreos/prometheus-operator) The Prometheus Operator makes the Prometheus configuration Kubernetes native and manages and operates Prometheus and Alertmanager clusters. It is a piece of the puzzle regarding full end-to-end monitoring.

## TL;DR;

```console
$ helm install stable/prometheus-operator
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/prometheus-operator
```

The command deploys the prometheus operator on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

| Parameter                         | Description                                           | Default                           |
|-----------------------------------|-----------------------------------------------------|-------------------------------------|
| `operator.image.repository`       | operator image                                      | quay.io/coreos/prometheus-operator  |
| `operator.image.tag`              | operator image tag                                  | latest                              |
| `configReloader.image.repository` | config reloader image                               | quay.io/coreos/configmap-reload     |
| `configReloader.image.tag`        | config reloader image tag                           | latest                              |
| `rbac.create`                     | create RBAC resources for operator to use           | true                                |
| `rbac.serviceAccountName`         | service account name to use                         | default                             |
| `resources`                       |  Container resource requests and limits             | {}                                  |

