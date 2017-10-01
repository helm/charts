# WordPress

[WordPress](https://wordpress.org/) is one of the most versatile open source content management systems on the market. A publishing platform for building blogs and websites.

## TL;DR;

```console
$ helm install stable/wordpress
```

## Introduction

This chart bootstraps a [WordPress](https://github.com/bitnami/bitnami-docker-wordpress) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the WordPress application.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/wordpress
```

The command deploys WordPress on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the WordPress chart and their default values.

| Parameter                            | Description                                | Default                                                    |
| -------------------------------      | -------------------------------            | ---------------------------------------------------------- |
| `image`                              | WordPress image                            | `bitnami/wordpress:{VERSION}`                              |
| `imagePullPolicy`                    | Image pull policy                          | `IfNotPresent`                                             |
| `wordpressUsername`                  | User of the application                    | `user`                                                     |
| `wordpressPassword`                  | Application password                       | _random 10 character long alphanumeric string_             |
| `wordpressEmail`                     | Admin email                                | `user@example.com`                                         |
| `wordpressFirstName`                 | First name                                 | `FirstName`                                                |
| `wordpressLastName`                  | Last name                                  | `LastName`                                                 |
| `wordpressBlogName`                  | Blog name                                  | `User's Blog!`                                             |
| `allowEmptyPassword`                 | Allow DB blank passwords                   | `yes`                                          |
| `smtpHost`                           | SMTP host                                  | `nil`                                                      |
| `smtpPort`                           | SMTP port                                  | `nil`                                                      |
| `smtpUser`                           | SMTP user                                  | `nil`                                                      |
| `smtpPassword`                       | SMTP password                              | `nil`                                                      |
| `smtpUsername`                       | User name for SMTP emails                  | `nil`                                                      |
| `smtpProtocol`                       | SMTP protocol [`tls`, `ssl`]               | `nil`                                                      |
| `mariadb.mariadbRootPassword`        | MariaDB admin password                     | `nil`                                                      |
| `mariadb.mariadbDatabase`            | Database name to create                    | `bitnami_wordpress`                            |
| `mariadb.mariadbUser`                | Database user to create                    | `bn_wordpress`                                 |
| `mariadb.mariadbPassword`            | Password for the database                  | _random 10 character long alphanumeric string_ |
| `serviceType`                        | Kubernetes Service type                    | `LoadBalancer`                                             |
| `healthcheckHttps`                   | Use https for liveliness and readiness     | `false`                                             |
| `ingress.enabled`                    | Enable ingress controller resource         | `false`                                                    |
| `ingress.hostname`                   | URL to address your WordPress installation | `wordpress.local`                                          |
| `ingress.tls`                        | Ingress TLS configuration                  | `[]`                                          |
| `persistence.enabled`                | Enable persistence using PVC               | `true`                                                     |
| `persistence.storageClass`           | PVC Storage Class                          | `nil` (uses alpha storage class annotation)                |
| `persistence.accessMode`             | PVC Access Mode                            | `ReadWriteOnce`                                            |
| `persistence.size`                   | PVC Storage Request                        | `10Gi`                                                     |
| `nodeSelector`                       | Node labels for pod assignment             | `{}`                                                       |

The above parameters map to the env variables defined in [bitnami/wordpress](http://github.com/bitnami/bitnami-docker-wordpress). For more information please refer to the [bitnami/wordpress](http://github.com/bitnami/bitnami-docker-wordpress) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set wordpressUsername=admin,wordpressPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/wordpress
```

The above command sets the WordPress administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/wordpress
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami WordPress](https://github.com/bitnami/bitnami-docker-wordpress) image stores the WordPress data and configurations at the `/bitnami` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Ingress

This chart provides support for Ingress resource. If you have available an Ingress Controller such as Nginx or Traefik you maybe want to set up `ingress.enabled` to true and choose a `ingress.hostname` for the URL. Then, you should be able to access the installation using that address.
