# OpenCart

[OpenCart](https://opencart.com/) is a free and open source e-commerce platform for online merchants. It provides a professional and reliable foundation for a successful online store.

## TL;DR;

```console
$ helm install stable/opencart
```

## Introduction

This chart bootstraps an [OpenCart](https://github.com/bitnami/bitnami-docker-opencart) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the OpenCart application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/opencart
```

The command deploys OpenCart on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the OpenCart chart and their default values.

|              Parameter              |                Description                |                         Default                          |
|-------------------------------------|-------------------------------------------|----------------------------------------------------------|
| `image.registry`                    | OpenCart image registry                   | `docker.io`                                              |
| `image.repository`                  | OpenCart Image name                       | `bitnami/opencart`                                       |
| `image.tag`                         | OpenCart Image tag                        | `{VERSION}`                                              |
| `image.pullPolicy`                  | Image pull policy                         | `Always` if `imageTag` is `latest`, else `IfNotPresent`  |
| `image.pullSecrets`                 | Specify image pull secrets                | `nil`                                                    |
| `opencartHost`                      | OpenCart host to create application URLs  | `nil`                                                    |
| `opencartLoadBalancerIP`            | `loadBalancerIP` for the OpenCart Service | `nil`                                                    |
| `opencartUsername`                  | User of the application                   | `user`                                                   |
| `opencartPassword`                  | Application password                      | _random 10 character long alphanumeric string_           |
| `opencartEmail`                     | Admin email                               | `user@example.com`                                       |
| `smtpHost`                          | SMTP host                                 | `nil`                                                    |
| `smtpPort`                          | SMTP port                                 | `nil`                                                    |
| `smtpUser`                          | SMTP user                                 | `nil`                                                    |
| `smtpPassword`                      | SMTP password                             | `nil`                                                    |
| `smtpProtocol`                      | SMTP protocol [`ssl`, `tls`]              | `nil`                                                    |
| `allowEmptyPassword`                | Allow DB blank passwords                  | `yes`                                                    |
| `externalDatabase.host`             | Host of the external database             | `nil`                                                    |
| `externalDatabase.port`             | Port of the external database             | `3306`                                                   |
| `externalDatabase.user`             | Existing username in the external db      | `bn_opencart`                                            |
| `externalDatabase.password`         | Password for the above username           | `nil`                                                    |
| `externalDatabase.database`         | Name of the existing database             | `bitnami_opencart`                                       |
| `mariadb.enabled`                   | Whether to use MariaDB chart              | `true`                                                   |
| `mariadb.db.name`           | Database name to create                   | `bitnami_opencart`                                       |
| `mariadb.db.user`               | Database user to create                   | `bn_opencart`                                            | 
| `mariadb.db.password`           | Password for the database                 | `nil`                                                    |
| `mariadb.rootUser.password`       | MariaDB admin password                    | `nil`                                                    |
| `serviceType`                       | Kubernetes Service type                   | `LoadBalancer`                                           |
| `persistence.enabled`               | Enable persistence using PVC              | `true`                                                   |
| `persistence.apache.storageClass`   | PVC Storage Class for Apache volume       | `nil` (uses alpha storage class annotation)              |
| `persistence.apache.accessMode`     | PVC Access Mode for Apache volume         | `ReadWriteOnce`                                          |
| `persistence.apache.size`           | PVC Storage Request for Apache volume     | `1Gi`                                                    |
| `persistence.opencart.storageClass` | PVC Storage Class for OpenCart volume     | `nil` (uses alpha storage class annotation)              |
| `persistence.opencart.accessMode`   | PVC Access Mode for OpenCart volume       | `ReadWriteOnce`                                          |
| `persistence.opencart.size`         | PVC Storage Request for OpenCart volume   | `8Gi`                                                    |
| `resources`                         | CPU/Memory resource requests/limits       | Memory: `512Mi`, CPU: `300m`                             |

The above parameters map to the env variables defined in [bitnami/opencart](http://github.com/bitnami/bitnami-docker-opencart). For more information please refer to the [bitnami/opencart](http://github.com/bitnami/bitnami-docker-opencart) image documentation.

> **Note**:
>
> For OpenCart to function correctly, you should specify the `opencartHost` parameter to specify the FQDN (recommended) or the public IP address of the OpenCart service.
>
> Optionally, you can specify the `opencartLoadBalancerIP` parameter to assign a reserved IP address to the OpenCart service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create opencart-public-ip
> ```
>
> The reserved IP address can be associated to the OpenCart service by specifying it as the value of the `opencartLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set opencartUsername=admin,opencartPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/opencart
```

The above command sets the OpenCart administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/opencart
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami OpenCart](https://github.com/bitnami/bitnami-docker-opencart) image stores the OpenCart data and configurations at the `/bitnami/opencart` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is opencart:

```console
$ kubectl patch deployment opencart-opencart --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset opencart-mariadb --cascade=false
```
