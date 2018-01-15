# Magento

[Magento](https://magento.org/) is a feature-rich flexible e-commerce solution. It includes transaction options, multi-store functionality, loyalty programs, product categorization and shopper filtering, promotion rules, and more.

## TL;DR;

```console
$ helm install stable/magento
```

## Introduction

This chart bootstraps a [Magento](https://github.com/bitnami/bitnami-docker-magento) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Magento application.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/magento
```

The command deploys Magento on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Magento chart and their default values.

|             Parameter              |               Description                |                         Default                          |
|------------------------------------|------------------------------------------|----------------------------------------------------------|
| `image`                            | Magento image                            | `bitnami/magento:{VERSION}`                              |
| `imagePullPolicy`                  | Image pull policy                        | `Always` if `image` tag is `latest`, else `IfNotPresent` |
| `magentoHost`                      | Magento host to create application URLs  | `nil`                                                    |
| `magentoLoadBalancerIP`            | `loadBalancerIP` for the magento Service | `nil`                                                    |
| `magentoUsername`                  | User of the application                  | `user`                                                   |
| `magentoPassword`                  | Application password                     | _random 10 character long alphanumeric string_           |
| `magentoEmail`                     | Admin email                              | `user@example.com`                                       |
| `magentoFirstName`                 | Magento Admin First Name                 | `FirstName`                                              |
| `magentoLastName`                  | Magento Admin Last Name                  | `LastName`                                               |
| `magentoMode`                      | Magento mode                             | `developer`                                              |
| `magentoAdminUri`                  | Magento prefix to access Magento Admin   | `admin`                                                  |
| `allowEmptyPassword`               | Allow DB blank passwords                 | `yes`                                                    |
| `externalDatabase.host`            | Host of the external database            | `nil`                                                    |
| `externalDatabase.port`            | Port of the external database            | `3306`                                                   |
| `externalDatabase.user`            | Existing username in the external db     | `bn_magento`                                             |
| `externalDatabase.password`        | Password for the above username          | `nil`                                                    |
| `externalDatabase.database`        | Name of the existing databse             | `bitnami_magento`                                        |
| `mariadb.enabled`                  | Use or not the mariadb chart             | `true`                                                   |
| `mariadb.mariadbRootPassword`      | MariaDB admin password                   | `nil`                                                    |
| `mariadb.mariadbDatabase`          | Database name to create                  | `bitnami_magento`                                        |
| `mariadb.mariadbUser`              | Database user to create                  | `bn_magento`                                             |
| `mariadb.mariadbPassword`          | Password for the database                | _random 10 character long alphanumeric string_           |
| `serviceType`                      | Kubernetes Service type                  | `LoadBalancer`                                           |
| `persistence.enabled`              | Enable persistence using PVC             | `true`                                                   |
| `persistence.apache.storageClass`  | PVC Storage Class for Apache volume      | `nil`  (uses alpha storage annotation)                   |
| `persistence.apache.accessMode`    | PVC Access Mode for Apache volume        | `ReadWriteOnce`                                          |
| `persistence.apache.size`          | PVC Storage Request for Apache volume    | `1Gi`                                                    |
| `persistence.magento.storageClass` | PVC Storage Class for Magento volume     | `nil`  (uses alpha storage annotation)                   |
| `persistence.magento.accessMode`   | PVC Access Mode for Magento volume       | `ReadWriteOnce`                                          |
| `persistence.magento.size`         | PVC Storage Request for Magento volume   | `8Gi`                                                    |
| `resources`                        | CPU/Memory resource requests/limits      | Memory: `512Mi`, CPU: `300m`                             |

The above parameters map to the env variables defined in [bitnami/magento](http://github.com/bitnami/bitnami-docker-magento). For more information please refer to the [bitnami/magento](http://github.com/bitnami/bitnami-docker-magento) image documentation.

> **Note**:
>
> For Magento to function correctly, you should specify the `magentoHost` parameter to specify the FQDN (recommended) or the public IP address of the Magento service.
>
> Optionally, you can specify the `magentoLoadBalancerIP` parameter to assign a reserved IP address to the Magento service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create magento-public-ip
> ```
>
> The reserved IP address can be associated to the Magento service by specifying it as the value of the `magentoLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set magentoUsername=admin,magentoPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/magento
```

The above command sets the Magento administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/magento
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami Magento](https://github.com/bitnami/bitnami-docker-magento) image stores the Magento data and configurations at the `/bitnami/magento` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
