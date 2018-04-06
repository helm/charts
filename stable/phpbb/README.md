# phpBB

[phpBB](https://www.phpbb.com/) is an Internet forum package written in the PHP scripting language. The name "phpBB" is an abbreviation of PHP Bulletin Board.

## TL;DR;

```console
$ helm install stable/phpbb
```

## Introduction

This chart bootstraps a [phpBB](https://github.com/bitnami/bitnami-docker-phpbb) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the phpBB application.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/phpbb
```

The command deploys phpBB on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the phpBB chart and their default values.

|             Parameter             |              Description              |                         Default                         |
|-----------------------------------|---------------------------------------|---------------------------------------------------------|
| `image.registry`                  | phpBB image registry                  | `docker.io`                                             |
| `image.repository`                | phpBB image name                      | `bitnami/phpbb`                                         |
| `image.tag`                       | phpBB image tag                       | `{VERSION}`                                             |
| `image.pullPolicy`                | Image pull policy                     | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `image.pullSecrets`               | Specify image pull secrets            | `nil`                                                   |
| `phpbbUser`                       | User of the application               | `user`                                                  |
| `phpbbPassword`                   | Application password                  | _random 10 character long alphanumeric string_          |
| `phpbbEmail`                      | Admin email                           | `user@example.com`                                      |
| `allowEmptyPassword`              | Allow DB blank passwords              | `yes`                                                   |
| `smtpHost`                        | SMTP host                             | `nil`                                                   |
| `smtpPort`                        | SMTP port                             | `nil`                                                   |
| `smtpUser`                        | SMTP user                             | `nil`                                                   |
| `smtpPassword`                    | SMTP password                         | `nil`                                                   |
| `externalDatabase.host`           | Host of the external database         | `nil`                                                   |
| `externalDatabase.user`           | Existing username in the external db  | `bn_phpbb`                                              |
| `externalDatabase.password`       | Password for the above username       | `nil`                                                   |
| `externalDatabase.database`       | Name of the existing database         | `bitnami_phpbb`                                         |
| `mariadb.enabled`                 | Use or not the mariadb chart          | `true`                                                  |
| `mariadb.mariadbRootPassword`     | MariaDB admin password                | `nil`                                                   |
| `mariadb.mariadbDatabase`         | Database name to create               | `bitnami_phpbb`                                         |
| `mariadb.mariadbUser`             | Database user to create               | `bn_phpbb`                                              |
| `mariadb.mariadbPassword`         | Password for the database             | _random 10 character long alphanumeric string_          |
| `serviceType`                     | Kubernetes Service type               | `LoadBalancer`                                          |
| `persistence.enabled`             | Enable persistence using PVC          | `true`                                                  |
| `persistence.apache.storageClass` | PVC Storage Class for Apache volume   | `nil` (uses alpha storage class annotation)             |
| `persistence.apache.accessMode`   | PVC Access Mode for Apache volume     | `ReadWriteOnce`                                         |
| `persistence.apache.size`         | PVC Storage Request for Apache volume | `1Gi`                                                   |
| `persistence.phpbb.storageClass`  | PVC Storage Class for phpBB volume    | `nil` (uses alpha storage class annotation)             |
| `persistence.phpbb.accessMode`    | PVC Access Mode for phpBB volume      | `ReadWriteOnce`                                         |
| `persistence.phpbb.size`          | PVC Storage Request for phpBB volume  | `8Gi`                                                   |
| `resources`                       | CPU/Memory resource requests/limits   | Memory: `512Mi`, CPU: `300m`                            |

The above parameters map to the env variables defined in [bitnami/phpbb](http://github.com/bitnami/bitnami-docker-phpbb). For more information please refer to the [bitnami/phpbb](http://github.com/bitnami/bitnami-docker-phpbb) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set phpbbUser=admin,phpbbPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/phpbb
```

The above command sets the phpBB administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/phpbb
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami phpBB](https://github.com/bitnami/bitnami-docker-phpbb) image stores the phpBB data and configurations at the `/bitnami/phpbb` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
