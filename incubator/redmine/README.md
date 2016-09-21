# Redmine

[Redmine](http://www.redmine.org) is a free and open source, web-based project management and issue tracking tool.

## TL;DR;

```bash
$ helm install redmine-x.x.x.tgz
```

## Introduction

This chart bootstraps a [Redmine](https://github.com/bitnami/bitnami-docker-redmine) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the Bitnami MariaDB chart which is required for bootstrapping a MariaDB deployment for the database requirements of the Redmine application.

## Prerequisites

- Kubernetes 1.3+ with Alpha APIs enabled
- PV provisioner support in the underlying infrastructure

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```bash
$ git clone https://github.com/kubernetes/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release redmine-x.x.x.tgz
```

*Replace the `x.x.x` placeholder with the chart release version.*

The command deploys Redmine on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Redmine chart and their default values.

| Parameter                       | Description                     | Default                                                   |
| ------------------------------- | ------------------------------- | --------------------------------------------------------- |
| `image`                         | Redmine image                   | `bitnami/redmine:{VERSION}`                               |
| `imagePullPolicy`               | Image pull policy               | `Always` if `image` tag is `latest`, else `IfNotPresent`  |
| `redmineUsername`               | User of the application         | `user`                                                    |
| `redminePassword`               | Application password            | `bitnami`                                                 |
| `redmineEmail`                  | Admin email                     | `user@example.com`                                        |
| `redmineLanguage`               | Redmine default data language   | `en`                                                      |
| `smtpHost`                      | SMTP host                       | `nil`                                                     |
| `smtpPort`                      | SMTP port                       | `nil`                                                     |
| `smtpUser`                      | SMTP user                       | `nil`                                                     |
| `smtpPassword`                  | SMTP password                   | `nil`                                                     |
| `smtpTls`                       | Use TLS encryption with SMTP    | `nil`                                                     |
| `mariadb.mariadbRootPassword`   | MariaDB admin password          | `nil`                                                     |
| `serviceType`                   | Kubernetes Service type         | `LoadBalancer`                                            |
| `persistence.enabled`           | Enable persistence using PVC    | `true`                                                    |
| `persistence.storageClass`      | PVC Storage Class               | `generic`                                                 |
| `persistence.accessMode`        | PVC Access Mode                 | `ReadWriteOnce`                                           |
| `persistence.size`              | PVC Storage Request             | `8Gi`                                                     |

The above parameters map to the env variables defined in [bitnami/redmine](http://github.com/bitnami/bitnami-docker-redmine). For more information please refer to the [bitnami/redmine](http://github.com/bitnami/bitnami-docker-redmine) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set redmineUsername=admin,redminePassword=password,mariadb.mariadbRootPassword=secretpassword \
    redmine-x.x.x.tgz
```

The above command sets the Redmine administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml redmine-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami Redmine](https://github.com/bitnami/bitnami-docker-redmine) image stores the Redmine data and configurations at the `/bitnami/redmine` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
