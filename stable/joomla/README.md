# Joomla!

[Joomla!](http://www.joomla.org/) is a PHP content management system (CMS) for publishing web content. It includes features such as page caching, RSS feeds, printable versions of pages, news flashes, blogs, search, and support for language international.

## TL;DR;

```console
$ helm install stable/joomla
```

## Introduction

This chart bootstraps a [Joomla!](https://github.com/bitnami/bitnami-docker-joomla) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Joomla! application.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/joomla
```

The command deploys Joomla! on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Joomla! chart and their default values.

| Parameter                         | Description                            | Default                                                   |
| --------------------------------- | -------------------------------------  | --------------------------------------------------------- |
| `image`                           | Joomla! image                          | `bitnami/joomla:{VERSION}`                                |
| `imagePullPolicy`                 | Image pull policy                      | `Always` if `image` tag is `latest`, else `IfNotPresent`  |
| `joomlaUsername`                  | User of the application                | `user`                                                    |
| `joomlaPassword`                  | Application password                   | Randomly generated                                        |
| `joomlaEmail`                     | Admin email                            | `user@example.com`                                        |
| `smtpHost`                        | SMTP host                              | `nil`                                                     |
| `smtpPort`                        | SMTP port                              | `nil`                                                     |
| `smtpUser`                        | SMTP user                              | `nil`                                                     |
| `smtpPassword`                    | SMTP password                          | `nil`                                                     |
| `smtpUsername`                    | User name for SMTP emails              | `nil`                                                     |
| `smtpProtocol`                    | SMTP protocol [`tls`, `ssl`]           | `nil`                                                     |
| `allowEmptyPassword`              | Allow DB blank passwords               | `yes`                                                     |
| `externalDatabase.host`           | Host of the external database          | `nil`                                                     |
| `externalDatabase.port`           | Port of the external database          | `3306`                                                    |
| `externalDatabase.user`           | Existing username in the external db   | `bn_joomla`                                               |
| `externalDatabase.password`       | Password for the above username        | `nil`                                                     |
| `externalDatabase.database`       | Name of the existing databse           | `bitnami_joomla`                                          |
| `mariadb.enabled`                 | Wheter to use or not the mariadb chart | `true`                                                    |
| `mariadb.mariadbDatabase`         | Database name to create                | `bitnami_joomla`                                          |
| `mariadb.mariadbUser`             | Database user to create                | `bn_joomla`                                               |
| `mariadb.mariadbPassword`         | Password for the database              | `nil`                                                     |
| `mariadb.mariadbRootPassword`     | MariaDB admin password                 | `nil`                                                     |
| `serviceType`                     | Kubernetes Service type                | `LoadBalancer`                                            |
| `persistence.enabled`             | Enable persistence using PVC           | `true`                                                    |
| `persistence.apache.storageClass` | PVC Storage Class for Apache volume    | `nil` (uses alpha storage annotation)                     |
| `persistence.apache.accessMode`   | PVC Access Mode for Apache volume      | `ReadWriteOnce`                                           |
| `persistence.apache.size`         | PVC Storage Request for Apache volume  | `1Gi`                                                     |
| `persistence.joomla.storageClass` | PVC Storage Class for Joomla! volume   | `nil` (uses alpha storage annotation)                     |
| `persistence.joomla.accessMode`   | PVC Access Mode for Joomla! volume     | `ReadWriteOnce`                                           |
| `persistence.joomla.size`         | PVC Storage Request for Joomla! volume | `8Gi`                                                     |
| `resources`                       | CPU/Memory resource requests/limits    | Memory: `512Mi`, CPU: `300m`                              |

The above parameters map to the env variables defined in [bitnami/joomla](http://github.com/bitnami/bitnami-docker-joomla). For more information please refer to the [bitnami/joomla](http://github.com/bitnami/bitnami-docker-joomla) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set joomlaUsername=admin,joomlaPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/joomla
```

The above command sets the Joomla! administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/joomla
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami Joomla!](https://github.com/bitnami/bitnami-docker-joomla) image stores the Joomla! data and configurations at the `/bitnami/joomla` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
