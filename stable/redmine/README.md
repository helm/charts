# Redmine

[Redmine](http://www.redmine.org) is a free and open source, web-based project management and issue tracking tool.

## TL;DR;

```bash
$ helm install stable/redmine
```

## Introduction

This chart bootstraps a [Redmine](https://github.com/bitnami/bitnami-docker-redmine) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) and the [PostgreSQL chart](https://github.com/kubernetes/charts/tree/master/stable/postgresql) which are required for bootstrapping a MariaDB/PostgreSQL deployment for the database requirements of the Redmine application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/redmine
```

The command deploys Redmine on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Using PostgreSQL instead of MariaDB

This chart includes the option to use a PostgreSQL database for Redmine instead of MariaDB. To use this, MariaDB must be explicitly disabled and PostgreSQL enabled:

```
helm install --name my-release stable/redmine --set databaseType.mariadb=false,databaseType.postgresql=true
```

## Configuration

The following table lists the configurable parameters of the Redmine chart and their default values.

|            Parameter              |              Description                 |                          Default                        |
| --------------------------------- | ---------------------------------------- | ------------------------------------------------------- |
| `global.imageRegistry`            | Global Docker image registry             | `nil`                                                   |
| `image.registry`                  | Redmine image registry                   | `docker.io`                                             |
| `image.repository`                | Redmine image name                       | `bitnami/redmine`                                       |
| `image.tag`                       | Redmine image tag                        | `{VERSION}`                                             |
| `image.pullPolicy`                | Image pull policy                        | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `image.pullSecrets`               | Specify image pull secrets               | `nil`                                                   |
| `redmineUsername`                 | User of the application                  | `user`                                                  |
| `redminePassword`                 | Application password                     | _random 10 character long alphanumeric string_          |
| `redmineEmail`                    | Admin email                              | `user@example.com`                                      |
| `redmineLanguage`                 | Redmine default data language            | `en`                                                    |
| `extraVars`                       | Environment variables, passed to redmine | `nil`                                                   |
| `smtpHost`                        | SMTP host                                | `nil`                                                   |
| `smtpPort`                        | SMTP port                                | `nil`                                                   |
| `smtpUser`                        | SMTP user                                | `nil`                                                   |
| `smtpPassword`                    | SMTP password                            | `nil`                                                   |
| `smtpTls`                         | Use TLS encryption with SMTP             | `nil`                                                   |
| `databaseType.postgresql`         | Select postgresql database               | `false`                                                 |
| `databaseType.mariadb`            | Select mariadb database                  | `true`                                                  |
| `mariadb.rootUser.password`     | MariaDB admin password                   | `nil`                                                   |
| `postgresql.postgresqlPassword`   | PostgreSQL admin password                | `nil`                                                   |
| `serviceType`                     | Kubernetes Service type                  | `LoadBalancer`                                          |
| `serviceLoadBalancerSourceRanges` | An array of load balancer sources        | `0.0.0.0/0`                                             |
| `ingress.enabled`                 | Enable or disable the ingress            | `false`                                                 |
| `ingress.hostname`                | The virtual host name                    | `redmine.cluster.local`                                 |
| `ingress.annotations`             | An array of service annotations          | `nil`                                                   |
| `ingress.tls[i].secretName`       | The secret kubernetes.io/tls             | `nil`                                                   |
| `ingress.tls[i].hosts[j]`         | The virtual host name                    | `nil`                                                   |
| `networkPolicyApiVersion`         | The kubernetes network API version       | `extensions/v1beta1`                                    |
| `persistence.enabled`             | Enable persistence using PVC             | `true`                                                  |
| `persistence.existingClaim`       | The name of an existing PVC              | `nil`                                                   |
| `persistence.storageClass`        | PVC Storage Class                        | `nil` (uses alpha storage class annotation)             |
| `persistence.accessMode`          | PVC Access Mode                          | `ReadWriteOnce`                                         |
| `persistence.size`                | PVC Storage Request                      | `8Gi`                                                   |
| `podDisruptionBudget.enabled`     | Pod Disruption Budget toggle             | `false`                                                 |
| `podDisruptionBudget.minAvailable`| Minimum available pods                   | `nil`                                                     |
| `podDisruptionBudget.maxUnavailable`| Maximum unavailable pods               | `nil`                                                     |
| `replicas`                        | The number of pod replicas (See [Replicas](#replicas)) | `1`                                                     |
| `resources`                       | Resources allocation (Requests and Limits) | `{}` |

The above parameters map to the env variables defined in [bitnami/redmine](http://github.com/bitnami/bitnami-docker-redmine). For more information please refer to the [bitnami/redmine](http://github.com/bitnami/bitnami-docker-redmine) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set redmineUsername=admin,redminePassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/redmine
```

The above command sets the Redmine administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/redmine
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Replicas

Redmine writes uploaded files to a persistent volume. By default that volume
cannot be shared between pods (RWO). In such a configuration the `replicas` option
must be set to `1`. If the persistent volume supports more than one writer
(RWX), ie NFS, `replicas` can be greater than `1`.

## Persistence

The [Bitnami Redmine](https://github.com/bitnami/bitnami-docker-redmine) image stores the Redmine data and configurations at the `/bitnami/redmine` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube. The volume is created using dynamic volume provisioning. Clusters configured with NFS mounts require manually managed volumes and claims.

See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

### Existing PersistentVolumeClaims

The following example includes two PVCs, one for Redmine and another for MariaDB.

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Create the directory, on a worker
1. Install the chart

```bash
$ helm install --name test --set persistence.existingClaim=PVC_REDMINE,mariadb.persistence.existingClaim=PVC_MARIADB  redmine
```

## Upgrading

### To 5.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 5.0.0. The following example assumes that the release name is redmine:

```console
$ kubectl patch deployment redmine-redmine --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
# If using postgresql as database
$ kubectl patch deployment redmine-postgresql --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
# If using mariadb as database
$ kubectl delete statefulset redmine-mariadb --cascade=false
```
