# phpBB

[phpBB](https://www.phpbb.com/) is an Internet forum package written in the PHP scripting language. The name "phpBB" is an abbreviation of PHP Bulletin Board.

## TL;DR;

```console
$ helm install stable/phpbb
```

## Introduction

This chart bootstraps a [phpBB](https://github.com/bitnami/bitnami-docker-phpbb) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the phpBB application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/phpbb
```

The command deploys phpBB on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the phpBB chart and their default values.

|             Parameter             |              Description              |                         Default                         |
|-----------------------------------|---------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`            | Global Docker image registry          | `nil`                                                   |
| `global.imagePullSecrets`         | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                     | Global storage class for dynamic provisioning                                               | `nil`                                                        |
| `image.registry`                  | phpBB image registry                  | `docker.io`                                             |
| `image.repository`                | phpBB image name                      | `bitnami/phpbb`                                         |
| `image.tag`                       | phpBB image tag                       | `{TAG_NAME}`                                            |
| `image.pullPolicy`                | Image pull policy                     | `IfNotPresent`                                          |
| `image.pullSecrets`               | Specify docker-registry secret names as an array  | `[]` (does not add image pull secrets to deployed pods)    |
| `nameOverride`                    | String to partially override phpbb.fullname template with a string (will prepend the release name) | `nil`     |
| `fullnameOverride`                | String to fully override phpbb.fullname template with a string                                     | `nil`     |
| `phpbbUser`                       | User of the application               | `user`                                                  |
| `phpbbPassword`                   | Application password                  | _random 10 character long alphanumeric string_          |
| `phpbbEmail`                      | Admin email                           | `user@example.com`                                      |
| `allowEmptyPassword`              | Allow DB blank passwords              | `yes`                                                   |
| `smtpHost`                        | SMTP host                             | `nil`                                                   |
| `smtpPort`                        | SMTP port                             | `nil`                                                   |
| `smtpUser`                        | SMTP user                             | `nil`                                                   |
| `smtpPassword`                    | SMTP password                         | `nil`                                                   |
| `externalDatabase.host`           | Host of the external database         | `nil`                                                   |
| `externalDatabase.user`           | Existing username in the external db  | `bn_phpbb`                                              |
| `externalDatabase.password`       | Password for the above username       | `nil`                                                   |
| `externalDatabase.database`       | Name of the existing database         | `bitnami_phpbb`                                         |
| `ingress.enabled`                 | Enable ingress controller resource    | `false`                                                 |
| `ingress.annotations`             | Ingress annotations                   | `[]`                                                    |
| `ingress.certManager`             | Add annotations for cert-manager      | `false`                                                 |
| `ingress.hosts[0].name`           | Hostname to your phpbb installation   | `phpbb.local`                                           |
| `ingress.hosts[0].path`           | Path within the url structure         | `/`                                                     |
| `ingress.hosts[0].tls`            | Utilize TLS backend in ingress        | `false`                                                 |
| `ingress.hosts[0].tlsHosts`       | Array of TLS hosts for ingress record (defaults to `ingress.hosts[0].name` if `nil`) | `nil`    |
| `ingress.hosts[0].tlsSecret`      | TLS Secret (certificates)             | `phpbb.local-tls-secret`                                |
| `ingress.secrets[0].name`         | TLS Secret Name                       | `nil`                                                   |
| `ingress.secrets[0].certificate`  | TLS Secret Certificate                | `nil`                                                   |
| `ingress.secrets[0].key`          | TLS Secret Key                        | `nil`                                                   |
| `mariadb.enabled`                 | Use or not the MariaDB chart          | `true`                                                  |
| `mariadb.rootUser.password`       | MariaDB admin password                | `nil`                                                   |
| `mariadb.db.name`                 | Database name to create               | `bitnami_phpbb`                                         |
| `mariadb.db.user`                 | Database user to create               | `bn_phpbb`                                              |
| `mariadb.db.password`             | Password for the database             | _random 10 character long alphanumeric string_          |
| `service.type`                    | Kubernetes Service type               | `LoadBalancer`                                          |
| `service.port`                    | Service HTTP port (Dashboard)         | `80`                                                    |
| `nodePorts.http`                  | Kubernetes http node port             | `""`                                                    |
| `nodePorts.https`                 | Kubernetes https node port            | `""`                                                    |
| `service.externalTrafficPolicy`   | Enable client source IP preservation  | `Cluster`                                               |
| `service.nodePorts.http`          | Kubernetes http node port             | `""`                                                    |
| `service.nodePorts.https`         | Kubernetes https node port            | `""`                                                    |
| `service.loadBalancerIP`          | LoadBalancer service IP               | `""`                                                    |
| `persistence.enabled`             | Enable persistence using PVC          | `true`                                                  |
| `persistence.phpbb.storageClass`  | PVC Storage Class for phpBB volume    | `nil` (uses alpha storage class annotation)             |
| `persistence.phpbb.accessMode`    | PVC Access Mode for phpBB volume      | `ReadWriteOnce`                                         |
| `persistence.phpbb.size`          | PVC Storage Request for phpBB volume  | `8Gi`                                                   |
| `resources`                       | CPU/Memory resource requests/limits   | Memory: `512Mi`, CPU: `300m`                            |
| `podAnnotations`                  | Pod annotations                       | `{}`                                                    |
| `affinity`                        | Map of node/pod affinities            | `{}`                                                    |
| `metrics.enabled`                 | Start a side-car prometheus exporter  | `false`                                                 |
| `metrics.image.registry`          | Apache exporter image registry        | `docker.io`                                             |
| `metrics.image.repository`        | Apache exporter image name            | `bitnami/apache-exporter`                               |
| `metrics.image.tag`               | Apache exporter image tag             | `{TAG_NAME}`                                            |
| `metrics.image.pullPolicy`        | Image pull policy                     | `IfNotPresent`                                          |
| `metrics.image.pullSecrets`       | Specify docker-registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `metrics.podAnnotations`          | Additional annotations for Metrics exporter pod | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}`|
| `metrics.resources`               | Exporter resource requests/limit      | {}                                                       |

The above parameters map to the env variables defined in [bitnami/phpbb](http://github.com/bitnami/bitnami-docker-phpbb). For more information please refer to the [bitnami/phpbb](http://github.com/bitnami/bitnami-docker-phpbb) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set phpbbUser=admin,phpbbPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/phpbb
```

The above command sets the phpBB administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/phpbb
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami phpBB](https://github.com/bitnami/bitnami-docker-phpbb) image stores the phpBB data and configurations at the `/bitnami/phpbb` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is phpbb:

```console
$ kubectl patch deployment phpbb-phpbb --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset phpbb-mariadb --cascade=false
```
