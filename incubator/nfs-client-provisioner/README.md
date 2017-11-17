# nfs-client-provisioner

The [NFS client provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client) is an out-of-tree/external storage provisioner for kubernetes. It provides dynamic provisioning of Persistent Volumes from a single NFS mount point.

## TL;DR;

```console
$ helm install incubator/nfs-client-provisioner
```

## Introduction

This chart bootstraps a [Drupal](https://github.com/bitnami/bitnami-docker-drupal) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Drupal application.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- NFS Share

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
| `extraVars`                       | Extra environment variables           | `nil`                                                     |
| `ingress.annotations`             | Specify ingress class                 | `kubernetes.io/ingress.class: nginx`                      |
| `ingress.enabled`                 | Enable ingress controller resource    | `false`                                                   |
| `ingress.hostname`                | URL for your Drupal installation      | `drupal.local`                                            |
| `ingress.tls`                     | Ingress TLS configuration             | `[]`                                                      |
| `mariadb.mariadbRootPassword`     | MariaDB admin password                | `nil`                                                     |
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
