# Osclass

[Osclass](https://osclass.org/) is a PHP script that allows you to quickly create and manage your own free classifieds site. Using this script, you can provide free advertising for items for sale, real estate, jobs, cars... Hundreds of free classified advertising sites are using Osclass.

## TL;DR;

```console
$ helm install stable/osclass
```

## Introduction

This chart bootstraps an [Osclass](https://github.com/bitnami/bitnami-docker-osclass) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Osclass application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/osclass
```

The command deploys Osclass on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Osclass chart and their default values.

|             Parameter              |               Description                |                   Default                               |
|------------------------------------|------------------------------------------|-------------------------------------------------------- |
| `global.imageRegistry`             | Global Docker image registry             | `nil`                                                   |
| `global.imagePullSecrets`          | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                     | Global storage class for dynamic provisioning                                               | `nil`                                                        |
| `image.registry`                   | Osclass image registry                   | `docker.io`                                             |
| `image.repository`                 | Osclass Image name                       | `bitnami/osclass`                                       |
| `image.tag`                        | Osclass Image tag                        | `{TAG_NAME}`                                            |
| `image.pullPolicy`                 | Image pull policy                        | `IfNotPresent`                                          |
| `image.pullSecrets`                | Specify docker-registry secret names as an array               | `[]` (does not add image pull secrets to deployed pods) |
| `nameOverride`                     | String to partially override osclass.fullname template with a string (will prepend the release name) | `nil` |
| `fullnameOverride`                 | String to fully override osclass.fullname template with a string                                     | `nil` |
| `osclassHost`                      | Osclass host to create application URLs  | `nil`                                                   |
| `osclassLoadBalancerIP`            | `loadBalancerIP` for the Osclass Service | `nil`                                                   |
| `osclassUsername`                  | User of the application                  | `user`                                                  |
| `osclassPassword`                  | Application password                     | `bitnami`                                               |
| `osclassEmail`                     | Admin email                              | `user@example.com`                                      |
| `osclassWebTitle`                  | Application tittle                       | `Sample Web Page`                                       |
| `osclassPingEngines`               | Allow site to appear in search engines   | `1`                                                     |
| `osclassSaveStats`                 | Send statistics and reports to Osclass   | `1`                                                     |
| `smtpHost`                         | SMTP host                                | `nil`                                                   |
| `smtpPort`                         | SMTP port                                | `nil`                                                   |
| `smtpUser`                         | SMTP user                                | `nil`                                                   |
| `smtpPassword`                     | SMTP password                            | `nil`                                                   |
| `smtpProtocol`                     | SMTP protocol [`ssl`, `tls`]             | `nil`                                                   |
| `serviceType`                      | Kubernetes Service type                  | `LoadBalancer`                                          |
| `resources`                        | CPU/Memory resource requests/limits      | Memory: `512Mi`, CPU: `300m`                            |
| `persistence.enabled`              | Enable persistence using PVC             | `true`                                                  |
| `persistence.moodle.storageClass`  | PVC Storage Class for OSClass volume     | `nil` (uses alpha storage class annotation)             |
| `persistence.moodle.accessMode`    | PVC Access Mode for OSClass volume       | `ReadWriteOnce`                                         |
| `persistence.moodle.size`          | PVC Storage Request for OSClass volume   | `8Gi`                                                   |
| `allowEmptyPassword`               | Allow DB blank passwords                 | `yes`                                                   |
| `externalDatabase.host`            | Host of the external database            | `nil`                                                   |
| `externalDatabase.port`            | Port of the external database            | `3306`                                                  |
| `externalDatabase.user`            | Existing username in the external db     | `bn_osclass`                                            |
| `externalDatabase.password`        | Password for the above username          | `nil`                                                   |
| `externalDatabase.database`        | Name of the existing database            | `bitnami_osclass`                                       |
| `ingress.enabled`                   | Enable ingress controller resource                            | `false`                                                  |
| `ingress.annotations`               | Ingress annotations                                           | `[]`                                                     |
| `ingress.certManager`               | Add annotations for cert-manager                              | `false`                                                  |
| `ingress.hosts[0].name`             | Hostname to your osclass installation                           | `osclass.local`                                            |
| `ingress.hosts[0].path`             | Path within the url structure                                 | `/`                                                      |
| `ingress.hosts[0].tls`              | Utilize TLS backend in ingress                                | `false`                                                  |
| `ingress.hosts[0].tlsHosts`         | Array of TLS hosts for ingress record (defaults to `ingress.hosts[0].name` if `nil`)                               | `nil`                                                  |
| `ingress.hosts[0].tlsSecret`        | TLS Secret (certificates)                                     | `osclass.local-tls-secret`                                 |
| `ingress.secrets[0].name`           | TLS Secret Name                                               | `nil`                                                    |
| `ingress.secrets[0].certificate`    | TLS Secret Certificate                                        | `nil`                                                    |
| `ingress.secrets[0].key`            | TLS Secret Key                                                | `nil`                                                    |
| `mariadb.enabled`                  | Whether to use the MariaDB chart         | `true`                                                  |
| `mariadb.db.name`          | Database name to create                  | `bitnami_osclass`                                       |
| `mariadb.db.user`              | Database user to create                  | `bn_osclass`                                            |
| `mariadb.mariadbPassword`          | Password for the database                | `nil`                                                   |
| `mariadb.mariadbRootPassword`      | MariaDB admin password                   | `nil`                                                   |
| `mariadb.persistence.enabled`      | Enable MariaDB persistence using PVC     | `true`                                                  |
| `mariadb.persistence.storageClass` | PVC Storage Class for MariaDB volume     | `generic`                                               |
| `mariadb.persistence.accessMode`   | PVC Access Mode for MariaDB volume       | `ReadWriteOnce`                                         |
| `mariadb.persistence.size`         | PVC Storage Request for MariaDB volume   | `8Gi`                                                   |
| `podAnnotations`                | Pod annotations                                   | `{}`                                                       |
| `affinity`                        | Map of node/pod affinities                 | `{}`                                                      |
| `metrics.enabled`                          | Start a side-car prometheus exporter                                                                           | `false`                                              |
| `metrics.image.registry`                   | Apache exporter image registry                                                                                  | `docker.io`                                         |
| `metrics.image.repository`                 | Apache exporter image name                                                                                      | `bitnami/apache-exporter`                           |
| `metrics.image.tag`                        | Apache exporter image tag                                                                                       | `{TAG_NAME}`                                        |
| `metrics.image.pullPolicy`                 | Image pull policy                                                                                              | `IfNotPresent`                                       |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                               | `[]` (does not add image pull secrets to deployed pods)  |
| `metrics.podAnnotations`                   | Additional annotations for Metrics exporter pod                                                                | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}`                                                   |
| `metrics.resources`                        | Exporter resource requests/limit                                                                               | {}                        |

The above parameters map to the env variables defined in [bitnami/osclass](http://github.com/bitnami/bitnami-docker-osclass). For more information please refer to the [bitnami/osclass](http://github.com/bitnami/bitnami-docker-osclass) image documentation.

> **Note**:
>
> For Osclass to function correctly, you should specify the `osclassHost` parameter to specify the FQDN (recommended) or the public IP address of the Osclass service.
>
> Optionally, you can specify the `osclassLoadBalancerIP` parameter to assign a reserved IP address to the Osclass service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create osclass-public-ip
> ```
>
> The reserved IP address can be associated to the Osclass service by specifying it as the value of the `osclassLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set osclassUsername=admin,osclassPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/osclass
```

The above command sets the Osclass administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/osclass
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami Osclass](https://github.com/bitnami/bitnami-docker-osclass) image stores the Osclass data and configurations at the `/bitnami/osclass` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is osclass:

```console
$ kubectl patch deployment osclass-osclass --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset osclass-mariadb --cascade=false
