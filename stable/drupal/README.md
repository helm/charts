# Drupal

[Drupal](https://www.drupal.org/) is one of the most versatile open source content management systems on the market.

## TL;DR;

```console
$ helm install stable/drupal
```

## Introduction

This chart bootstraps a [Drupal](https://github.com/bitnami/bitnami-docker-drupal) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Drupal application.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/drupal
```

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
| `imagePullSecrets`                | Specify image pull secrets            | `nil` (does not add image pull secrets to deployed pods)  |
| `imagePullPolicy`                 | Image pull policy                     | `IfNotPresent`                                            |
| `drupalUsername`                  | User of the application               | `user`                                                    |
| `drupalPassword`                  | Application password                  | _random 10 character long alphanumeric string_            |
| `drupalEmail`                     | Admin email                           | `user@example.com`                                        |
| `allowEmptyPassword`              | Allow DB blank passwords              | `yes`                                                     |
| `extraVars`                       | Extra environment variables           | `nil`                                                     |
| `ingress.annotations`             | Specify ingress class                 | `kubernetes.io/ingress.class: nginx`                      |
| `ingress.enabled`                 | Enable ingress controller resource    | `false`                                                   |
| `ingress.hostname`                | URL for your Drupal installation      | `drupal.local`                                            |
| `ingress.tls`                     | Ingress TLS configuration             | `[]`                                                      |
| `externalDatabase.host`           | Host of the external database         | `nil`                                                     |
| `externalDatabase.user`           | Existing username in the external db  | `bn_drupal`                                               |
| `externalDatabase.password`       | Password for the above username       | `nil`                                                     |
| `externalDatabase.database`       | Name of the existing databse          | `bitnami_drupal`                                          |
| `mariadb.enabled`                 | Use or not the mariadb chart          | `true`                                                    |
| `mariadb.mariadbRootPassword`     | MariaDB admin password                | `nil`                                                     |
| `mariadb.mariadbDatabase`         | Database name to create               | `bitnami_drupal`                                          |
| `mariadb.mariadbUser`             | Database user to create               | `bn_drupal`                                               |
| `mariadb.mariadbPassword`         | Password for the database             | _random 10 character long alphanumeric string_            |
| `serviceType`                     | Kubernetes Service type               | `LoadBalancer`                                            |
| `persistence.enabled`             | Enable persistence using PVC          | `true`                                                    |
| `persistence.apache.storageClass` | PVC Storage Class for Apache volume   | `nil` (uses alpha storage class annotation)               |
| `persistence.apache.accessMode`   | PVC Access Mode for Apache volume     | `ReadWriteOnce`                                           |
| `persistence.apache.size`         | PVC Storage Request for Apache volume | `1Gi`                                                     |
| `persistence.drupal.storageClass` | PVC Storage Class for Drupal volume   | `nil` (uses alpha storage class annotation)               |
| `persistence.drupal.accessMode`   | PVC Access Mode for Drupal volume     | `ReadWriteOnce`                                           |
| `persistence.drupal.existingClaim`| An Existing PVC name                  | `nil`                                                     |
| `persistence.drupal.hostPath`     | Host mount path for Drupal volume     | `nil` (will not mount to a host path)                     |
| `persistence.drupal.size`         | PVC Storage Request for Drupal volume | `8Gi`                                                     |
| `resources`                       | CPU/Memory resource requests/limits   | Memory: `512Mi`, CPU: `300m`                              |
| `volumeMounts.drupal.mountPath`   | Drupal data volume mount path         | `/bitnami/drupal`                                         |
| `volumeMounts.apache.mountPath`   | Apache data volume mount path         | `/bitnami/apache`                                         |

The above parameters map to the env variables defined in [bitnami/drupal](http://github.com/bitnami/bitnami-docker-drupal). For more information please refer to the [bitnami/drupal](http://github.com/bitnami/bitnami-docker-drupal) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set drupalUsername=admin,drupalPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/drupal
```

The above command sets the Drupal administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/drupal
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Image

The `image` parameter allows specifying which image will be pulled for the chart.

### Private registry

If you configure the `image` value to one in a private registry, you will need to [specify an image pull secret](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod).

1. Manually create image pull secret(s) in the namespace. See [this YAML example reference](https://kubernetes.io/docs/concepts/containers/images/#creating-a-secret-with-a-docker-config). Consult your image registry's documentation about getting the appropriate secret.
1. Note that the `imagePullSecrets` configuration value cannot currently be passed to helm using the `--set` parameter, so you must supply these using a `values.yaml` file, such as:
```yaml
imagePullSecrets:
  - name: SECRET_NAME
```
1. Install the chart
```console
helm install --name my-release -f values.yaml stable/drupal
```

## Persistence
The configured image must store Drupal data and Apache configurations in separate paths of the container.

The [Bitnami Drupal](https://github.com/bitnami/bitnami-docker-drupal) image stores the Drupal data and Apache configurations at the `/bitnami/drupal` and `/bitnami/apache` paths of the container. If you wish to override the `image` value, and your image stores this data and configurations in different paths, you may specify these paths with `volumeMounts.drupal.mountPath` and `volumeMounts.apache.mountPath`.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

### Existing PersistentVolumeClaim

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart
```bash
$ helm install --name my-release --set persistence.drupal.existingClaim=PVC_NAME stable/drupal
```

### Host path

#### System compatibility
- The local filesystem accessibility to a container in a pod with `hostPath` has been tested on OSX/MacOS with xhyve, and Linux with VirtualBox.
- Windows has not been tested with the supported VM drivers. Minikube does however officially support [Mounting Host Folders](https://github.com/kubernetes/minikube/blob/master/docs/host_folder_mount.md) per pod. Or you may manually sync your container whenever host files are changed with tools like [docker-sync](https://github.com/EugenMayer/docker-sync) or [docker-bg-sync](https://github.com/cweagans/docker-bg-sync).

#### Mounting steps
1. The specified `hostPath` directory must already exist (create one if it does not).
1. Install the chart
    ```bash
    $ helm install --name my-release --set persistence.drupal.hostPath=/PATH/TO/HOST/MOUNT stable/drupal
    ```
    This will mount the `drupal-data` volume into the `hostPath` directory, if the site has not already been initialized. If it has, your host machine changes will persist.
1. Because the container can not control the host machine’s directory permissions, you must set the Drupal file directory permissions yourself and disable or clear Drupal cache. See Drupal Core’s [INSTALL.txt](http://cgit.drupalcode.org/drupal/tree/core/INSTALL.txt?h=8.3.x#n152) for setting file permissions, and see [Drupal handbook page](https://www.drupal.org/node/2598914) to disable cache, or [Drush handbook](https://drushcommands.com/drush-8x/cache/cache-rebuild/) to clear cache.
