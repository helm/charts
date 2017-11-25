# ownCloud

[ownCloud](https://owncloud.org/) is a file sharing server that puts the control and security of your own data back into your hands.

## TL;DR;

```console
$ helm install stable/owncloud
```

## Introduction

This chart bootstraps a [ownCloud](https://github.com/bitnami/bitnami-docker-owncloud) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the ownCloud application.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/owncloud
```

The command deploys ownCloud on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the ownCloud chart and their default values.

|              Parameter              |                Description                |                   Default                   |
|-------------------------------------|-------------------------------------------|---------------------------------------------|
| `image`                             | ownCloud image                            | `bitnami/owncloud:{VERSION}`                |
| `imagePullPolicy`                   | Image pull policy                         | `IfNotPresent`                              |
| `ingress.enabled`                   | Enable use of ingress controllers         | `false`                                     |
| `ingress.servicePort`               | Ingress' backend servicePort              | `http`                                      |
| `owncloudHost`                      | ownCloud host to create application URLs  | `nil`                                       |
| `owncloudLoadBalancerIP`            | `loadBalancerIP` for the owncloud Service | `nil`                                       |
| `owncloudUsername`                  | User of the application                   | `user`                                      |
| `owncloudPassword`                  | Application password                      | Randomly generated                          |
| `owncloudEmail`                     | Admin email                               | `user@example.com`                          |
| `mariadb.mariadbRootPassword`       | MariaDB admin password                    | `nil`                                       |
| `serviceType`                       | Kubernetes Service type                   | `LoadBalancer`                              |
| `persistence.enabled`               | Enable persistence using PVC              | `true`                                      |
| `persistence.apache.storageClass`   | PVC Storage Class for Apache volume       | `nil` (uses alpha storage class annotation) |
| `persistence.apache.accessMode`     | PVC Access Mode for Apache volume         | `ReadWriteOnce`                             |
| `persistence.apache.size`           | PVC Storage Request for Apache volume     | `1Gi`                                       |
| `persistence.owncloud.storageClass` | PVC Storage Class for ownCloud volume     | `nil` (uses alpha storage class annotation) |
| `persistence.owncloud.accessMode`   | PVC Access Mode for ownCloud volume       | `ReadWriteOnce`                             |
| `persistence.owncloud.size`         | PVC Storage Request for ownCloud volume   | `8Gi`                                       |
| `resources`                         | CPU/Memory resource requests/limits       | Memory: `512Mi`, CPU: `300m`                |


The above parameters map to the env variables defined in [bitnami/owncloud](http://github.com/bitnami/bitnami-docker-owncloud). For more information please refer to the [bitnami/owncloud](http://github.com/bitnami/bitnami-docker-owncloud) image documentation.

> **Note**:
>
> For ownCloud to function correctly, you should specify the `owncloudHost` parameter to specify the FQDN (recommended) or the public IP address of the ownCloud service.
>
> Optionally, you can specify the `owncloudLoadBalancerIP` parameter to assign a reserved IP address to the ownCloud service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create owncloud-public-ip
> ```
>
> The reserved IP address can be associated to the ownCloud service by specifying it as the value of the `owncloudLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set owncloudUsername=admin,owncloudPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/owncloud
```

The above command sets the ownCloud administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/owncloud
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami ownCloud](https://github.com/bitnami/bitnami-docker-owncloud) image stores the ownCloud data and configurations at the `/bitnami/owncloud` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
