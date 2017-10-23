# Odoo

[Odoo](https://www.odoo.com/) is a suite of web based open source business apps. The main Odoo Apps include an Open Source CRM, Website Builder, eCommerce, Project Management, Billing & Accounting, Point of Sale, Human Resources, Marketing, Manufacturing, Purchase Management, ...

Odoo Apps can be used as stand-alone applications, but they also integrate seamlessly so you get a full-featured Open Source ERP when you install several Apps.

## TL;DR;

```console
$ helm install stable/odoo
```

## Introduction

This chart bootstraps a [Odoo](https://github.com/bitnami/bitnami-docker-odoo) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/odoo
```

The command deploys Odoo on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Odoo chart and their default values.

|               Parameter               |                Description                |                   Default                   |
|---------------------------------------|-------------------------------------------|---------------------------------------------|
| `imageTag`                            | `bitnami/odoo` image tag                  | Odoo image version                          |
| `imagePullPolicy`                     | Image pull policy                         | `IfNotPresent`                              |
| `odooUsername`                        | User of the application                   | `user@example.com`                          |
| `odooPassword`                        | Admin account password                    | `bitnami`                                   |
| `odooEmail`                           | Admin account email                       | `user@example.com`                          |
| `smtpHost`                            | SMTP host                                 | `nil`                                       |
| `smtpPort`                            | SMTP port                                 | `nil`                                       |
| `smtpUser`                            | SMTP user                                 | `nil`                                       |
| `smtpPassword`                        | SMTP password                             | `nil`                                       |
| `smtpProtocol`                        | SMTP protocol [`ssl`, `tls`]              | `nil`                                       |
| `serviceType`                         | Kubernetes Service type                   | `LoadBalancer`                              |
| `resources`                           | CPU/Memory resource requests/limits       | Memory: `512Mi`, CPU: `300m`                |
| `persistence.storageClass`            | PVC Storage Class                         | `nil` (uses alpha storage class annotation) |
| `persistence.accessMode`              | PVC Access Mode                           | `ReadWriteOnce`                             |
| `persistence.size`                    | PVC Storage Request                       | `8Gi`                                       |
| `postgresql.postgresqlPassword`       | PostgreSQL password                       | `nil`                                       |
| `postgresql.persistence.enabled`      | Enable PostgreSQL persistence using PVC   | `true`                                      |
| `postgresql.persistence.storageClass` | PVC Storage Class for PostgreSQL volume   | `nil` (uses alpha storage class annotation) |
| `postgresql.persistence.accessMode`   | PVC Access Mode for PostgreSQL volume     | `ReadWriteOnce`                             |
| `postgresql.persistence.size`         | PVC Storage Request for PostgreSQL volume | `8Gi`                                       |

The above parameters map to the env variables defined in [bitnami/odoo](http://github.com/bitnami/bitnami-docker-odoo). For more information please refer to the [bitnami/odoo](http://github.com/bitnami/bitnami-docker-odoo) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set odooPassword=password,postgresql.postgresPassword=secretpassword \
    stable/odoo
```

The above command sets the Odoo administrator account password to `password` and the PostgreSQL `postgres` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/odoo
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami Odoo](https://github.com/bitnami/bitnami-docker-odoo) image stores the Odoo data and configurations at the `/bitnami/odoo` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
