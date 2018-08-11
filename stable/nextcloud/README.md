# nextcloud

[nextcloud](https://nextcloud.org/) is a file sharing server that puts the control and security of your own data back into your hands.

## TL;DR;

```console
$ helm install stable/nextcloud
```

## Introduction

This chart bootstraps an [nextcloud](https://hub.docker.com/_/nextcloud/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the nextcloud application.

## Prerequisites

- Kubernetes 1.9+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/nextcloud
```

The command deploys nextcloud on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the nextcloud chart and their default values.

|              Parameter              |                Description                |                   Default                               |
|-------------------------------------|-------------------------------------------|-------------------------------------------------------- |
| `image.registry`                    | nextcloud image registry                   | `docker.io`                                             |
| `image.repository`                  | nextcloud Image name                       | `nextcloud`                                      |
| `image.tag`                         | nextcloud Image tag                        | `{VERSION}`                                             |
| `image.pullPolicy`                  | Image pull policy                         | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `image.pullSecrets`                 | Specify image pull secrets                | `nil`                                                   |
| `ingress.enabled`                   | Enable use of ingress controllers         | `false`                                                 |
| `ingress.servicePort`               | Ingress' backend servicePort              | `http`                                                  |
| `ingress.annotations`               | An array of service annotations           | `nil`                                                   |
| `ingress.tls`                       | Ingress TLS configuration                 | `[]`                                                    |
| `networkPolicyApiVersion`           | The kubernetes network API version        | `extensions/v1beta1`                                    |
| `nextcloudHost`                     | nextcloud host to create application URLs  | `nil`                                                   |
| `nextcloudLoadBalancerIP`           | `loadBalancerIP` for the nextcloud Service | `nil`                                                   |
| `nextcloudUsername`                 | User of the application                   | `user`                                                  |
| `nextcloudPassword`                 | Application password                      | Randomly generated                                      |
| `nextcloudEmail`                    | Admin email                               | `user@example.com`                                      |
| `externalDatabase.host`             | Host of the external database             | `nil`                                                   |
| `allowEmptyPassword`                | Allow DB blank passwords                  | `yes`                                                   |
| `externalDatabase.host`             | Host of the external database             | `nil`                                                   |
| `externalDatabase.port`             | Port of the external database             | `3306`                                                  |
| `externalDatabase.database`         | Name of the existing database             | `nextcloud`                                      |
| `externalDatabase.user`             | Existing username in the external db      | `bn_nextcloud`                                           |
| `externalDatabase.password`         | Password for the above username           | `nil`                                                   |
| `mariadb.mariadbDatabase`           | Database name to create                   | `nextcloud`                                      |
| `mariadb.enabled`                   | Whether to use the MariaDB chart          | `true`                                                  |
| `mariadb.mariadbPassword`           | Password for the database                 | `nil`                                                   |
| `mariadb.mariadbUser`               | Database user to create                   | `bn_nextcloud`                                           |
| `mariadb.mariadbRootPassword`       | MariaDB admin password                    | `nil`                                                   |
| `serviceType`                       | Kubernetes Service type                   | `LoadBalancer`                                          |
| `persistence.apache.enabled`        | Enable persistence using PVC              | `true`                                                  |
| `persistence.apache.storageClass`   | PVC Storage Class for Apache volume       | `nil` (uses alpha storage class annotation)             |
| `persistence.apache.existingClaim`  | An Existing PVC name for Apache volume    | `nil` (uses alpha storage class annotation)             |
| `persistence.apache.accessMode`     | PVC Access Mode for Apache volume         | `ReadWriteOnce`                                         |
| `persistence.apache.size`           | PVC Storage Request for Apache volume     | `1Gi`                                                   |
| `persistence.nextcloud.enabled`     | Enable persistence using PVC              | `true`                                                  |
| `persistence.nextcloud.storageClass` | PVC Storage Class for nextcloud volume     | `nil` (uses alpha storage class annotation)             |
| `persistence.nextcloud.existingClaim`| An Existing PVC name for nextcloud volume  | `nil` (uses alpha storage class annotation)             |
| `persistence.nextcloud.accessMode`   | PVC Access Mode for nextcloud volume       | `ReadWriteOnce`                                         |
| `persistence.nextcloud.size`         | PVC Storage Request for nextcloud volume   | `8Gi`                                                   |
| `persistence.extraExistingClaimMounts | Optionally add multiple existing claims | `[]`                                                      |
| `resources`                         | CPU/Memory resource requests/limits       | Memory: `512Mi`, CPU: `300m`                            |

> **Note**:
>
> For nextcloud to function correctly, you should specify the `nextcloudHost` parameter to specify the FQDN (recommended) or the public IP address of the nextcloud service.
>
> Optionally, you can specify the `nextcloudLoadBalancerIP` parameter to assign a reserved IP address to the nextcloud service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create nextcloud-public-ip
> ```
>
> The reserved IP address can be associated to the nextcloud service by specifying it as the value of the `nextcloudLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set nextcloudUsername=admin,nextcloudPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/nextcloud
```

The above command sets the nextcloud administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/nextcloud
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Nextcloud](https://hub.docker.com/_/nextcloud/) image stores the nextcloud data and configurations at the `/var/www/html` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
