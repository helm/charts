# JasperReports

[JasperReports](http://community.jaspersoft.com/project/jasperreports-server) The JasperReports server can be used as a stand-alone or embedded reporting and BI server that offers web-based reporting, analytic tools and visualization, and a dashboard feature for compiling multiple custom views

## TL;DR;

```console
$ helm install stable/jasperreports
```

## Introduction

This chart bootstraps a [JasperReports](https://github.com/bitnami/bitnami-docker-jasperreports) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which bootstraps a MariaDB deployment required by the JasperReports application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/jasperreports
```

The command deploys JasperReports on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the JasperReports chart and their default values.

|           Parameter              |                 Description                  |                         Default                          |
|----------------------------------|----------------------------------------------|----------------------------------------------------------|
| `global.imageRegistry`           | Global Docker image registry                 | `nil`                                                    |
| `global.imagePullSecrets`        | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                     | Global storage class for dynamic provisioning                                               | `nil`                                                        |
| `image.registry`                 | JasperReports image registry                 | `docker.io`                                              |
| `image.repository`               | JasperReports Image name                     | `bitnami/jasperreports`                                  |
| `image.tag`                      | JasperReports Image tag                      | `{TAG_NAME}`                                             |
| `image.pullPolicy`               | Image pull policy                            | `IfNotPresent`                                           |
| `image.pullSecrets`              | Specify docker-registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `nameOverride`                   | String to partially override jasperreports.fullname template with a string (will prepend the release name) | `nil` |
| `fullnameOverride`               | String to fully override jasperreports.fullname template with a string                                     | `nil` |
| `jasperreportsUsername`          | User of the application                      | `user`                                                   |
| `jasperreportsPassword`          | Application password                         | _random 10 character long alphanumeric string_           |
| `jasperreportsEmail`             | User email                                   | `user@example.com`                                       |
| `smtpHost`                       | SMTP host                                    | `nil`                                                    |
| `smtpPort`                       | SMTP port                                    | `nil`                                                    |
| `smtpEmail`                      | SMTP email                                   | `nil`                                                    |
| `smtpUser`                       | SMTP user                                    | `nil`                                                    |
| `smtpPassword`                   | SMTP password                                | `nil`                                                    |
| `smtpProtocol`                   | SMTP protocol [`ssl`, `none`]                | `nil`                                                    |
| `allowEmptyPassword`             | Allow DB blank passwords                     | `yes`                                                    |
| `ingress.enabled`                | Enable ingress controller resource           | `false`                                                  |
| `ingress.annotations`            | Ingress annotations                          | `[]`                                                     |
| `ingress.certManager`            | Add annotations for cert-manager             | `false`                                                  |
| `ingress.hosts[0].name`          | Hostname to your JasperReports installation  | `jasperreports.local`                                    |
| `ingress.hosts[0].path`          | Path within the url structure                | `/`                                                      |
| `ingress.hosts[0].tls`           | Utilize TLS backend in ingress               | `false`                                                  |
| `ingress.hosts[0].tlsHosts`      | Array of TLS hosts for ingress record (defaults to `ingress.hosts[0].name` if `nil`) | `nil`            |
| `ingress.hosts[0].tlsSecret`     | TLS Secret (certificates)                    | `jasperreports.local-tls-secret`                         |
| `ingress.secrets[0].name`        | TLS Secret Name                              | `nil`                                                    |
| `ingress.secrets[0].certificate` | TLS Secret Certificate                       | `nil`                                                    |
| `ingress.secrets[0].key`         | TLS Secret Key                               | `nil`                                                    |
| `externalDatabase.host`          | Host of the external database                | `nil`                                                    |
| `externalDatabase.port`          | Port of the external database                | `3306`                                                   |
| `externalDatabase.user`          | Existing username in the external db         | `bn_jasperreports`                                       |
| `externalDatabase.password`      | Password for the above username              | `nil`                                                    |
| `externalDatabase.database`      | Name of the existing database                | `bitnami_jasperreports`                                  |
| `mariadb.enabled`                | Whether to use the MariaDB chart             | `true`                                                   |
| `mariadb.db.name`                | Database name to create                      | `bitnami_jasperreports`                                  |
| `mariadb.db.user`                | Database user to create                      | `bn_jasperreports`                                       |
| `mariadb.db.password`            | Password for the database                    | `nil`                                                    |
| `mariadb.rootUser.password`      | MariaDB admin password                       | `nil`                                                    |
| `service.type`                   | Kubernetes Service type                      | `LoadBalancer`                                           |
| `service.externalTrafficPolicy`  | Enable client source IP preservation         | `Cluster`                                                |
| `service.port`                   | Service HTTP port                            | `80`                                                     |
| `service.nodePorts.http`         | Kubernetes http node port                    | `""`                                                     |
| `persistence.enabled`            | Enable persistence using PVC                 | `true`                                                   |
| `persistence.storageClass`       | PVC Storage Class for JasperReports volume   | `nil` (uses alpha storage annotation)                    |
| `persistence.accessMode`         | PVC Access Mode for JasperReports volume     | `ReadWriteOnce`                                          |
| `persistence.size`               | PVC Storage Request for JasperReports volume | `8Gi`                                                    |
| `resources`                      | CPU/Memory resource requests/limits          | `{Memory: 512Mi, CPU: 300m}`                             |
| `affinity`                       | Map of node/pod affinities                   | `{}`                                                     |

The above parameters map to the env variables defined in [bitnami/jasperreports](http://github.com/bitnami/bitnami-docker-jasperreports). For more information please refer to the [bitnami/jasperreports](http://github.com/bitnami/bitnami-docker-jasperreports) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set jasperreportsUsername=admin,jasperreportsPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/jasperreports
```

The above command sets the JasperReports administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/jasperreports
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami JasperReports](https://github.com/bitnami/bitnami-docker-jasperreports) image stores the JasperReports data and configurations at the `/bitnami/jasperreports` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is jasperreports:

```console
$ kubectl patch deployment jasperreports-jasperreports --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset jasperreports-mariadb --cascade=false
