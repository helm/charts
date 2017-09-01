# PrestaShop

[PrestaShop](https://prestashop.com/) is a popular open source ecommerce solution. Professional tools are easily accessible to increase online sales including instant guest checkout, abandoned cart reminders and automated Email marketing.

## TL;DR;

```console
$ helm install stable/prestashop
```

## Introduction

This chart bootstraps a [PrestaShop](https://github.com/bitnami/bitnami-docker-prestashop) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the PrestaShop application.

## Prerequisites

- Kubernetes 1.5+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/prestashop
```

The command deploys PrestaShop on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the PrestaShop chart and their default values.

|               Parameter               |                 Description                 |                         Default                          |
|---------------------------------------|---------------------------------------------|----------------------------------------------------------|
| `image`                               | PrestaShop image                            | `bitnami/prestashop:{VERSION}`                           |
| `imagePullPolicy`                     | Image pull policy                           | `Always` if `image` tag is `latest`, else `IfNotPresent` |
| `prestashopHost`                      | PrestaShop host to create application URLs  | `nil`                                                    |
| `prestashopLoadBalancerIP`            | `loadBalancerIP` for the PrestaShop Service | `nil`                                                    |
| `prestashopUsername`                  | User of the application                     | `user@example.com`                                       |
| `prestashopPassword`                  | Application password                        | _random 10 character long alphanumeric string_           |
| `prestashopEmail`                     | Admin email                                 | `user@example.com`                                       |
| `prestashopFirstName`                 | First Name                                  | `Bitnami`                                                |
| `prestashopLastName`                  | Last Name                                   | `Name`                                                   |
| `smtpHost`                            | SMTP host                                   | `nil`                                                    |
| `smtpPort`                            | SMTP port                                   | `nil`                                                    |
| `smtpUser`                            | SMTP user                                   | `nil`                                                    |
| `smtpPassword`                        | SMTP password                               | `nil`                                                    |
| `smtpProtocol`                        | SMTP protocol [`ssl`, `tls`]                | `nil`                                                    |
| `mariadb.mariadbRootPassword`         | MariaDB admin password                      | `nil`                                                    |
| `serviceType`                         | Kubernetes Service type                     | `LoadBalancer`                                           |
| `persistence.enabled`                 | Enable persistence using PVC                | `true`                                                   |
| `persistence.apache.storageClass`     | PVC Storage Class for Apache volume         | `nil` (uses alpha storage class annotation)              |
| `persistence.apache.accessMode`       | PVC Access Mode for Apache volume           | `ReadWriteOnce`                                          |
| `persistence.apache.size`             | PVC Storage Request for Apache volume       | `1Gi`                                                    |
| `persistence.prestashop.storageClass` | PVC Storage Class for PrestaShop volume     | `nil` (uses alpha storage class annotation)              |
| `persistence.prestashop.accessMode`   | PVC Access Mode for PrestaShop volume       | `ReadWriteOnce`                                          |
| `persistence.prestashop.size`         | PVC Storage Request for PrestaShop volume   | `8Gi`                                                    |
| `resources`                           | CPU/Memory resource requests/limits         | Memory: `512Mi`, CPU: `300m`                             |

The above parameters map to the env variables defined in [bitnami/prestashop](http://github.com/bitnami/bitnami-docker-prestashop). For more information please refer to the [bitnami/prestashop](http://github.com/bitnami/bitnami-docker-prestashop) image documentation.

> **Note**:
>
> For PrestaShop to function correctly, you should specify the `prestashopHost` parameter to specify the FQDN (recommended) or the public IP address of the PrestaShop service.
>
> Optionally, you can specify the `prestashopLoadBalancerIP` parameter to assign a reserved IP address to the PrestaShop service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create prestashop-public-ip
> ```
>
> The reserved IP address can be associated to the PrestaShop service by specifying it as the value of the `prestashopLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set prestashopUsername=admin,prestashopPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/prestashop
```

The above command sets the PrestaShop administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/prestashop
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami PrestaShop](https://github.com/bitnami/bitnami-docker-prestashop) image stores the PrestaShop data and configurations at the `/bitnami/prestashop` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
