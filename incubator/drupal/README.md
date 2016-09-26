# Drupal

[Drupal](https://www.drupal.org/) is one of the most versatile open source content management systems on the market.

## TL;DR;

```console
$ helm install drupal-x.x.x.tgz
```

## Introduction

This chart bootstraps a [Drupal](https://github.com/bitnami/bitnami-docker-drupal) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the Bitnami MariaDB chart which is required for bootstrapping a MariaDB deployment for the database requirements of the Drupal application.

## Prerequisites

- Kubernetes 1.3+ with Alpha APIs enabled
- PV provisioner support in the underlying infrastructure

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```console
$ git clone https://github.com/kubernetes/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release drupal-x.x.x.tgz
```

*Replace the `x.x.x` placeholder with the chart release version.*

The command deploys Drupal on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Drupal chart and their default values.

| Parameter                         | Description                           | Default                                                   |
| --------------------------------- | ------------------------------------- | --------------------------------------------------------- |
| `image`                           | Drupal image                          | `bitnami/drupal:{VERSION}`                                |
| `imagePullPolicy`                 | Image pull policy                     | `Always` if `image` tag is `latest`, else `IfNotPresent`  |
| `drupalUsername`                  | User of the application               | `user`                                                    |
| `drupalPassword`                  | Application password                  | `bitnami`                                                 |
| `drupalEmail`                     | Admin email                           | `user@example.com`                                        |
| `mariadb.mariadbRootPassword`     | MariaDB admin password                | `nil`                                                     |
| `serviceType`                     | Kubernetes Service type               | `LoadBalancer`                                            |
| `persistence.enabled`             | Enable persistence using PVC          | `true`                                                    |
| `persistence.apache.storageClass` | PVC Storage Class for Apache volume   | `generic`                                                 |
| `persistence.apache.accessMode`   | PVC Access Mode for Apache volume     | `ReadWriteOnce`                                           |
| `persistence.apache.size`         | PVC Storage Request for Apache volume | `1Gi`                                                     |
| `persistence.drupal.storageClass` | PVC Storage Class for Drupal volume   | `generic`                                                 |
| `persistence.drupal.accessMode`   | PVC Access Mode for Drupal volume     | `ReadWriteOnce`                                           |
| `persistence.drupal.size`         | PVC Storage Request for Drupal volume | `8Gi`                                                     |
| `resources`                       | CPU/Memory resource requests/limits   | Memory: `512Mi`, CPU: `300m`                              |

The above parameters map to the env variables defined in [bitnami/drupal](http://github.com/bitnami/bitnami-docker-drupal). For more information please refer to the [bitnami/drupal](http://github.com/bitnami/bitnami-docker-drupal) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set drupalUsername=admin,drupalPassword=password,mariadb.mariadbRootPassword=secretpassword \
    drupal-x.x.x.tgz
```

The above command sets the Drupal administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml drupal-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami Drupal](https://github.com/bitnami/bitnami-docker-drupal) image stores the Drupal data and configurations at the `/bitnami/drupal` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
