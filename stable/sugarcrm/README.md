# SugarCRM

[SugarCRM](https://www.sugarcrm.com) Sugar offers the most innovative, flexible and affordable CRM in the market and delivers the best all-around value of any CRM.

## TL;DR;

```console
$ helm install stable/sugarcrm
```

## Introduction

This chart bootstraps a [SugarCRM](https://github.com/bitnami/bitnami-docker-sugarcrm) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the SugarCRM application.

## Prerequisites

- Kubernetes 1.5+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/sugarcrm
```

The command deploys SugarCRM on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the SugarCRM chart and their default values.

|              Parameter              |               Description               |                   Default                   |
|-------------------------------------|-----------------------------------------|---------------------------------------------|
| `image`                             | SugarCRM image                          | `bitnami/sugarcrm:{VERSION}`                |
| `imagePullPolicy`                   | Image pull policy                       | `IfNotPresent`                              |
| `sugarcrmUsername`                  | User of the application                 | `user`                                      |
| `sugarcrmPassword`                  | Application password                    | _random 10 character alphanumeric string_   |
| `sugarcrmEmail`                     | Admin email                             | `user@example.com`                          |
| `sugarcrmLastname`                  | Last name                               | `Name`                                      |
| `sugarcrmHost`                      | Host domain or IP                       | `nil`                                       |
| `sugarcrmLoadBalancerIP`            | `loadBalancerIP` of the application     | `nil`                                       |
| `sugarcrmSmtpHost`                  | SMTP host                               | `nil`                                       |
| `sugarcrmSmtpPort`                  | SMTP port                               | `nil`                                       |
| `sugarcrmSmtpProtocol`              | SMTP Protocol                           | `nil`                                       |
| `sugarcrmSmtpUser`                  | SMTP user                               | `nil`                                       |
| `sugarcrmSmtpPassword`              | SMTP password                           | `nil`                                       |
| `mariadb.mariadbRootPassword`       | MariaDB admin password                  | `nil`                                       |
| `serviceType`                       | Kubernetes Service type                 | `LoadBalancer`                              |
| `persistence.enabled`               | Enable persistence using PVC            | `true`                                      |
| `persistence.apache.storageClass`   | PVC Storage Class for apache volume     | `nil` (uses alpha storage class annotation) |
| `persistence.apache.accessMode`     | PVC Access Mode for apache volume       | `ReadWriteOnce`                             |
| `persistence.apache.size`           | PVC Storage Request for apache volume   | `1Gi`                                       |
| `persistence.sugarcrm.storageClass` | PVC Storage Class for SugarCRM volume   | `nil` (uses alpha storage class annotation) |
| `persistence.sugarcrm.accessMode`   | PVC Access Mode for SugarCRM volume     | `ReadWriteOnce`                             |
| `persistence.sugarcrm.size`         | PVC Storage Request for SugarCRM volume | `8Gi`                                       |
| `resources`                         | CPU/Memory resource requests/limits     | Memory: `512Mi`, CPU: `300m`                |

The above parameters map to the env variables defined in [bitnami/sugarcrm](http://github.com/bitnami/bitnami-docker-sugarcrm). For more information please refer to the [bitnami/sugarcrm](http://github.com/bitnami/bitnami-docker-sugarcrm) image documentation.

> **Note**:
>
> For SugarCRM to function correctly, you should specify the `sugarcrmHost` parameter to specify the FQDN (recommended) or the public IP address of the SugarCRM service.
>
> Optionally, you can specify the `sugarcrmLoadBalancerIP` parameter to assign a reserved IP address to the SugarCRM service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create sugarcrm-public-ip
> ```
>
> The reserved IP address can be associated to the SugarCRM service by specifying it as the value of the `sugarcrmLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set sugarcrmUsername=admin,sugarcrmPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/sugarcrm
```

The above command sets the SugarCRM administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/sugarcrm
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami SugarCRM](https://github.com/bitnami/bitnami-docker-sugarcrm) image stores the SugarCRM data and configurations at the `/bitnami/sugarcrm` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
