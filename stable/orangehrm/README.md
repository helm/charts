# OrangeHRM

[OrangeHRM](https://www.orangehrm.com) is a free HR management system that offers a wealth of modules to suit the needs of your business. This widely-used system is feature-rich, intuitive and provides an essential HR management platform along with free documentation and access to a broad community of users.

## TL;DR;

```console
$ helm install stable/orangehrm
```

## Introduction

This chart bootstraps an [OrangeHRM](https://github.com/bitnami/bitnami-docker-orangehrm) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the OrangeHRM application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/orangehrm
```

The command deploys OrangeHRM on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the OrangeHRM chart and their default values.

|              Parameter               |               Description                |                    Default                              |
|--------------------------------------|------------------------------------------|-------------------------------------------------------- |
| `global.imageRegistry`               | Global Docker image registry             | `nil`                                                   |
| `image.registry`                     | OrangeHRM image registry                 | `docker.io`                                             |
| `image.repository`                   | OrangeHRM Image name                     | `bitnami/orangehrm`                                     |
| `image.tag`                          | OrangeHRM Image tag                      | `{VERSION}`                                             |
| `image.pullPolicy`                   | Image pull policy                        | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `image.pullSecrets`                  | Specify image pull secrets               | `nil`                                                   |
| `orangehrmUsername`                  | User of the application                  | `user`                                                  |
| `orangehrmPassword`                  | Application password                     | _random 10 character long alphanumeric string_          |
| `smtpHost`                           | SMTP host                                | `nil`                                                   |
| `smtpPort`                           | SMTP port                                | `nil`                                                   |
| `smtpUser`                           | SMTP user                                | `nil`                                                   |
| `smtpPassword`                       | SMTP password                            | `nil`                                                   |
| `smtpProtocol`                       | SMTP protocol [`ssl`, `none`]            | `nil`                                                   |
| `service.type`                    | Kubernetes Service type                    | `LoadBalancer`                                          |
| `service.port`                    | Service HTTP port                    | `80`                                          |
| `service.httpsPort`                    | Service HTTPS port                    | `443`                                          |
| `service.externalTrafficPolicy`   | Enable client source IP preservation       | `Cluster`                                               |
| `service.nodePorts.http`                 | Kubernetes http node port                  | `""`                                                    |
| `service.nodePorts.https`                | Kubernetes https node port                 | `""`                                                    |
| `resources`                          | CPU/Memory resource requests/limits      | Memory: `512Mi`, CPU: `300m`                            |
| `persistence.enabled`                | Enable persistence using PVC             | `true`                                                  |
| `persistence.apache.storageClass`    | PVC Storage Class for Apache volume      | `nil` (uses alpha storage class annotation)             |
| `persistence.apache.accessMode`      | PVC Access Mode for Apache volume        | `ReadWriteOnce`                                         |
| `persistence.apache.size`            | PVC Storage Request for Apache volume    | `1Gi`                                                   |
| `persistence.orangehrm.storageClass` | PVC Storage Class for OrangeHRM volume   | `nil` (uses alpha storage class annotation)             |
| `persistence.orangehrm.accessMode`   | PVC Access Mode for OrangeHRM volume     | `ReadWriteOnce`                                         |
| `persistence.orangehrm.size`         | PVC Storage Request for OrangeHRM volume | `8Gi`                                                   |
| `allowEmptyPassword`                 | Allow DB blank passwords                 | `yes`                                                   |
| `externalDatabase.host`              | Host of the external database            | `nil`                                                   |
| `externalDatabase.port`              | Port of the external database            | `3306`                                                  |
| `externalDatabase.user`              | Existing username in the external db     | `bn_orangehrm`                                          |
| `externalDatabase.password`          | Password for the above username          | `nil`                                                   |
| `externalDatabase.database`          | Name of the existing database            | `bitnami_orangehrm`                                     |
| `mariadb.enabled`                    | Whether to use the MariaDB chart         | `true`                                                  |
| `mariadb.db.name`            | Database name to create                  | `bitnami_orangehrm`                                     |
| `mariadb.db.user`                | Database user to create                  | `bn_orangehrm`                                          |
| `mariadb.db.password`            | Password for the database                | `nil`                                                   |
| `mariadb.rootUser.password`        | MariaDB admin password                   | `nil`                                                   |
| `mariadb.persistence.enabled`        | Enable MariaDB persistence using PVC     | `true`                                                  |
| `mariadb.persistence.storageClass`   | PVC Storage Class for MariaDB volume     | `nil` (uses alpha storage class annotation)             |
| `mariadb.persistence.accessMode`     | PVC Access Mode for MariaDB volume       | `ReadWriteOnce`                                         |
| `mariadb.persistence.size`           | PVC Storage Request for MariaDB volume   | `8Gi`                                                   |
| `podAnnotations`                | Pod annotations                                   | `{}`                                                       |
| `metrics.enabled`                          | Start a side-car prometheus exporter                                                                           | `false`                                              |
| `metrics.image.registry`                   | Apache exporter image registry                                                                                  | `docker.io`                                          |
| `metrics.image.repository`                 | Apache exporter image name                                                                                      | `lusotycoon/apache-exporter`                           |
| `metrics.image.tag`                        | Apache exporter image tag                                                                                       | `v0.5.0`                                            |
| `metrics.image.pullPolicy`                 | Image pull policy                                                                                              | `IfNotPresent`                                       |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                               | `nil`                                                |
| `metrics.podAnnotations`                   | Additional annotations for Metrics exporter pod                                                                | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}`                                                   |
| `metrics.resources`                        | Exporter resource requests/limit                                                                               | {}                        |

The above parameters map to the env variables defined in [bitnami/orangehrm](http://github.com/bitnami/bitnami-docker-orangehrm). For more information please refer to the [bitnami/orangehrm](http://github.com/bitnami/bitnami-docker-orangehrm) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set orangehrmUsername=admin,orangehrmPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/orangehrm
```

The above command sets the OrangeHRM administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/orangehrm
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami OrangeHRM](https://github.com/bitnami/bitnami-docker-orangehrm) image stores the OrangeHRM data and configurations at the `/bitnami/orangehrm` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. There is a [known issue](https://github.com/kubernetes/kubernetes/issues/39178) in Kubernetes Clusters with EBS in different availability zones. Ensure your cluster is configured properly to create Volumes in the same availability zone where the nodes are running. Kuberentes 1.12 solved this issue with the [Volume Binding Mode](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode).

See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is orangehrm:

```console
$ kubectl patch deployment orangehrm-orangehrm --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset orangehrm-mariadb --cascade=false
```
