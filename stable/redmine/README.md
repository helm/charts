# Redmine

[Redmine](http://www.redmine.org) is a free and open source, web-based project management and issue tracking tool.

## TL;DR;

```bash
$ helm install stable/redmine
```

## Introduction

This chart bootstraps a [Redmine](https://github.com/bitnami/bitnami-docker-redmine) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) and the [PostgreSQL chart](https://github.com/kubernetes/charts/tree/master/stable/postgresql) which are required for bootstrapping a MariaDB/PostgreSQL deployment for the database requirements of the Redmine application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

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

|            Parameter                |              Description                   |                          Default                        |
| ----------------------------------- | ------------------------------------------ | ------------------------------------------------------- |
| `global.imageRegistry`              | Global Docker image registr  y             | `nil`                                                   |
| `global.imagePullSecrets`           | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`                    | Redmine image registry                     | `docker.io`                                             |
| `image.repository`                  | Redmine image name                         | `bitnami/redmine`                                       |
| `image.tag`                         | Redmine image tag                          | `{TAG_NAME}`                                            |
| `image.pullPolicy`                  | Image pull policy                          | `IfNotPresent`                                          |
| `image.pullSecrets`                 | Specify docker-registry secret names as an array                 | `[]` (does not add image pull secrets to deployed pods)   |
| `redmineUsername`                   | User of the application                    | `user`                                                  |
| `redminePassword`                   | Application password                       | _random 10 character long alphanumeric string_          |
| `redmineEmail`                      | Admin email                                | `user@example.com`                                      |
| `redmineLanguage`                   | Redmine default data language              | `en`                                                    |
| `extraVars`                         | Environment variables, passed to redmine   | `nil`                                                   |
| `smtpHost`                          | SMTP host                                  | `nil`                                                   |
| `smtpPort`                          | SMTP port                                  | `nil`                                                   |
| `smtpUser`                          | SMTP user                                  | `nil`                                                   |
| `smtpPassword`                      | SMTP password                              | `nil`                                                   |
| `smtpTls`                           | Use TLS encryption with SMTP               | `nil`                                                   |
| `databaseType.postgresql`           | Select PostgreSQL as database              | `false`                                                 |
| `databaseType.mariadb`              | Select MariaDB as database                 | `true`                                                  |
| `mariadb.enabled`                   | Whether to deploy a MariaDB server to satisfy the applications database requirements     | `true`    |
| `mariadb.rootUser.password`         | MariaDB admin password                     | `nil`                                                   |
| `postgresql.enabled`                | Whether to deploy a PostgreSQL server to satisfy the applications database requirements  | `false`   |
| `postgresql.postgresqlPassword`     | PostgreSQL admin password                  | `nil`                                                   |
| `externalDatabase.host`             | Host of the external database              | `localhost`                                             |
| `externalDatabase.user`             | External db admin user                     | `root`                                                  |
| `externalDatabase.password`         | Password for the admin user                | `""`                                                    |
| `externalDatabase.port`             | Database port number                       | `3306`                                                  |
| `service.type`                      | Kubernetes Service type                    | `LoadBalancer`                                          |
| `service.port`                      | Service HTTP port                          | `80`                                                    |
| `service.nodePorts.http`            | Kubernetes http node port                  | `""`                                                    |
| `service.externalTrafficPolicy`     | Enable client source IP preservation       | `Cluster`                                               |
| `service.loadBalancerIP`            | LoadBalancer service IP address            | `""`                                                    |
| `service.loadBalancerSourceRanges`  | An array of load balancer sources          | `0.0.0.0/0`                                             |
| `ingress.enabled`                   | Enable or disable the ingress              | `false`                                                 |
| `ingress.hosts[0].name`             | Hostname to your Redmine installation      | `redmine.local  `                                       |
| `ingress.hosts[0].path`             | Path within the url structure              | `/`                                                     |
| `ingress.hosts[0].tls`              | Utilize TLS backend in ingress             | `false`                                                 |
| `ingress.hosts[0].certManager`      | Add annotations for cert-manager           | `false`                                                 |
| `ingress.hosts[0].tlsSecret`        | TLS Secret (certificates)                  | `redmine.local-tls-secret`                              |
| `ingress.hosts[0].annotations`      | Annotations for this host's ingress record | `[]`                                                    |
| `ingress.secrets[0].name`           | TLS Secret Name                            | `nil`                                                   |
| `ingress.secrets[0].certificate`    | TLS Secret Certificate                     | `nil`                                                   |
| `ingress.secrets[0].key`            | TLS Secret Key                             | `nil`                                                   |
| `nodeSelector`                      | Node labels for pod assignment             | `{}`                                                    |
| `tolerations`                       | List of node taints to tolerate            | `{}`                                                    |
| `affinity`                          | Map of node/pod affinities                 | `{}`                                                    |
| `podAnnotations`                    | Pod annotations                            | `{}`                                                    |
| `persistence.enabled`               | Enable persistence using PVC               | `true`                                                  |
| `persistence.existingClaim`         | The name of an existing PVC                | `nil`                                                   |
| `persistence.storageClass`          | PVC Storage Class                          | `nil` (uses alpha storage class annotation)             |
| `persistence.accessMode`            | PVC Access Mode                            | `ReadWriteOnce`                                         |
| `persistence.size`                  | PVC Storage Request                        | `8Gi`                                                   |
| `podDisruptionBudget.enabled`       | Pod Disruption Budget toggle               | `false`                                                 |
| `podDisruptionBudget.minAvailable`  | Minimum available pods                     | `nil`                                                   |
| `podDisruptionBudget.maxUnavailable`| Maximum unavailable pods                   | `nil`                                                   |
| `replicas`                          | The number of pod replicas                 | `1`                                                     |
| `resources`                         | Resources allocation (Requests and Limits) | `{}`                                                    |

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

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

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
