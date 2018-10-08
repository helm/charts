# phpMyAdmin

[phpMyAdmin](https://www.phpmyadmin.net/) is a free and open source administration tool for MySQL and MariaDB. As a portable web application written primarily in PHP, it has become one of the most popular MySQL administration tools, especially for web hosting services.

## TL;DR

```console
$ helm install stable/phpmyadmin
```

## Introduction

This chart bootstraps a [phpMyAdmin](https://github.com/bitnami/bitnami-docker-phpmyadmin) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/phpmyadmin
```

The command deploys phpMyAdmin on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the phpMyAdmin chart and their default values.

|              Parameter               |               Description                |                         Default                         |
|--------------------------------------|------------------------------------------|---------------------------------------------------------|
| `image.registry`                     | phpMyAdmin image registry                 | `docker.io`                                             |
| `image.repository`                   | phpMyAdmin Image name                     | `bitnami/phpmyadmin`                                     |
| `image.tag`                          | phpMyAdmin Image tag                      | `{VERSION}`                                             |
| `image.pullPolicy`                   | Image pull policy                        |   `IfNotPresent` |
| `image.pullSecrets`                  | Specify image pull secrets               | `nil`                                                   |
| `service.type`            | type of service for phpMyAdmin frontend             | `ClusterIP`                                                  |
| `service.port`        | port to expose service                   | `80`                                                   |
| `db.port`            | database port to use to connect                  | `3306`                                     |
| `db.chartName`                | Database suffix if included in the same release                  | `nil`                                          |
| `db.host`            | database host to connect to               | `nil`          |
| `ingress.enabled`            | ingress resource to be added              | `false`          |
| `ingress.annotations`            | ingress annotations              | `{ingress.kubernetes.io/rewrite-target: /,    nginx.ingress.kubernetes.io/rewrite-target: /}`          |
| `ingress.path`            | path to access frontend               | `/`          |
| `ingress.host`            | ingress host               | `nil`          |
| `ingress.tls`            | tls for ingress               | `[]`          |
| `resources`                          | CPU/Memory resource requests/limits      | `{}`      |
| `nodeSelector`                   | Node labels for pod assignment             | `{}`                                                    |
| `tolerations`                    | List of node taints to tolerate            | `[]`                                                    |
| `affinity`                       | Map of node/pod affinities                 | `{}`                                                    |

For more information please refer to the [bitnami/phpmyadmin](http://github.com/bitnami/bitnami-docker-Phpmyadmin) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set db.host=mymariadb,db.port=3306 stable/phpmyadmin
```

The above command sets the phpMyAdmin to connect to a database in `mymariadb` host and `3306` port respectively.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/phpmyadmin
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Upgrading

### To 1.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to `1.0.0`. The following example assumes that the release name is `phpmyadmin`:

```console
$ kubectl patch deployment phpmyadmin-phpmyadmin --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
