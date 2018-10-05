# JasperReports

[JasperReports](http://community.jaspersoft.com/project/jasperreports-server) The JasperReports server can be used as a stand-alone or embedded reporting and BI server that offers web-based reporting, analytic tools and visualization, and a dashboard feature for compiling multiple custom views

## TL;DR;

```console
$ helm install stable/jasperreports
```

## Introduction

This chart bootstraps a [JasperReports](https://github.com/bitnami/bitnami-docker-jasperreports) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which bootstraps a MariaDB deployment required by the JasperReports application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/jasperreports
```

The command deploys JasperReports on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the JasperReports chart and their default values.

|           Parameter           |                 Description                  |                         Default                          |
|-------------------------------|----------------------------------------------|----------------------------------------------------------|
| `image.registry`              | JasperReports image registry                 | `docker.io`                                              |
| `image.repository`            | JasperReports Image name                     | `bitnami/jasperreports`                                  |
| `image.tag`                   | JasperReports Image tag                      | `{VERSION}`                                              |
| `image.pullPolicy`            | Image pull policy                            | `Always` if `imageTag` is `latest`, else `IfNotPresent`  |
| `image.pullSecrets`           | Specify image pull secrets                   | `nil`                                                    |
| `jasperreportsUsername`       | User of the application                      | `user`                                                   |
| `jasperreportsPassword`       | Application password                         | _random 10 character long alphanumeric string_           |
| `jasperreportsEmail`          | User email                                   | `user@example.com`                                       |
| `smtpHost`                    | SMTP host                                    | `nil`                                                    |
| `smtpPort`                    | SMTP port                                    | `nil`                                                    |
| `smtpEmail`                   | SMTP email                                   | `nil`                                                    |
| `smtpUser`                    | SMTP user                                    | `nil`                                                    |
| `smtpPassword`                | SMTP password                                | `nil`                                                    |
| `smtpProtocol`                | SMTP protocol [`ssl`, `none`]                | `nil`                                                    |
| `allowEmptyPassword`          | Allow DB blank passwords                     | `yes`                                                    |
| `externalDatabase.host`       | Host of the external database                | `nil`                                                    |
| `externalDatabase.port`       | Port of the external database                | `3306`                                                   |
| `externalDatabase.user`       | Existing username in the external db         | `bn_jasperreports`                                       |
| `externalDatabase.password`   | Password for the above username              | `nil`                                                    |
| `externalDatabase.database`   | Name of the existing database                | `bitnami_jasperreports`                                  |
| `mariadb.enabled`             | Whether to use the MariaDB chart             | `true`                                                   |
| `mariadb.db.name`     | Database name to create                      | `bitnami_jasperreports`                                  |
| `mariadb.db.user`         | Database user to create                      | `bn_jasperreports`                                       |
| `mariadb.db.password`     | Password for the database                    | `nil`                                                    |
| `mariadb.rootUser.password` | MariaDB admin password                       | `nil`                                                    |
| `serviceType`                 | Kubernetes Service type                      | `LoadBalancer`                                           |
| `persistence.enabled`         | Enable persistence using PVC                 | `true`                                                   |
| `persistence.storageClass`    | PVC Storage Class for JasperReports volume   | `nil` (uses alpha storage annotation)                    |
| `persistence.accessMode`      | PVC Access Mode for JasperReports volume     | `ReadWriteOnce`                                          |
| `persistence.size`            | PVC Storage Request for JasperReports volume | `8Gi`                                                    |
| `resources`                   | CPU/Memory resource requests/limits          | Memory: `512Mi`, CPU: `300m`                             |

The above parameters map to the env variables defined in [bitnami/jasperreports](http://github.com/bitnami/bitnami-docker-jasperreports). For more information please refer to the [bitnami/jasperreports](http://github.com/bitnami/bitnami-docker-jasperreports) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set jasperreportsUsername=admin,jasperreportsPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/jasperreports
```

The above command sets the JasperReports administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/jasperreports
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami JasperReports](https://github.com/bitnami/bitnami-docker-jasperreports) image stores the JasperReports data and configurations at the `/bitnami/jasperreports` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is jasperreports:

```console
$ kubectl patch deployment jasperreports-jasperreports --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset jasperreports-mariadb --cascade=false
