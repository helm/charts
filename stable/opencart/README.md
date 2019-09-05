# OpenCart

[OpenCart](https://opencart.com/) is a free and open source e-commerce platform for online merchants. It provides a professional and reliable foundation for a successful online store.

## TL;DR;

```console
$ helm install stable/opencart
```

## Introduction

This chart bootstraps an [OpenCart](https://github.com/bitnami/bitnami-docker-opencart) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the OpenCart application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/opencart
```

The command deploys OpenCart on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the OpenCart chart and their default values.

|              Parameter              |                Description                |                         Default                          |
|-------------------------------------|-------------------------------------------|----------------------------------------------------------|
| `global.imageRegistry`              | Global Docker image registry              | `nil`                                                    |
| `global.imagePullSecrets`           | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                     | Global storage class for dynamic provisioning                                               | `nil`                                                        |
| `image.registry`                    | OpenCart image registry                   | `docker.io`                                              |
| `image.repository`                  | OpenCart Image name                       | `bitnami/opencart`                                       |
| `image.tag`                         | OpenCart Image tag                        | `{TAG_NAME}`                                             |
| `image.pullPolicy`                  | Image pull policy                         | `IfNotPresent`                                           |
| `image.pullSecrets`                 | Specify docker-registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `nameOverride`                      | String to partially override opencart.fullname template with a string (will prepend the release name) | `nil` |
| `fullnameOverride`                  | String to fully override opencart.fullname template with a string                                     | `nil` |
| `opencartHost`                      | OpenCart host to create application URLs  | `nil`                                                    |
| `service.type`                      | Kubernetes Service type                   | `LoadBalancer`                                           |
| `service.port`                      | Service HTTP port                         | `80`                                                     |
| `service.httpsPort`                 | Service HTTPS port                        | `443`                                                    |
| `service.externalTrafficPolicy`     | Enable client source IP preservation      | `Cluster`                                                |
| `service.nodePorts.http`            | Kubernetes http node port                 | `""`                                                     |
| `service.nodePorts.https`           | Kubernetes https node port                | `""`                                                     |
| `service.loadBalancerIP`            | `loadBalancerIP` for the OpenCart Service | `nil`                                                    |
| `opencartUsername`                  | User of the application                   | `user`                                                   |
| `opencartPassword`                  | Application password                      | _random 10 character long alphanumeric string_           |
| `opencartEmail`                     | Admin email                               | `user@example.com`                                       |
| `smtpHost`                          | SMTP host                                 | `nil`                                                    |
| `smtpPort`                          | SMTP port                                 | `nil`                                                    |
| `smtpUser`                          | SMTP user                                 | `nil`                                                    |
| `smtpPassword`                      | SMTP password                             | `nil`                                                    |
| `smtpProtocol`                      | SMTP protocol [`ssl`, `tls`]              | `nil`                                                    |
| `allowEmptyPassword`                | Allow DB blank passwords                  | `yes`                                                    |
| `ingress.enabled`                   | Enable ingress controller resource                            | `false`                                                  |
| `ingress.annotations`               | Ingress annotations                                           | `[]`                                                     |
| `ingress.certManager`               | Add annotations for cert-manager                              | `false`                                                  |
| `ingress.hosts[0].name`             | Hostname to your opencart installation                           | `opencart.local`                                            |
| `ingress.hosts[0].path`             | Path within the url structure                                 | `/`                                                      |
| `ingress.hosts[0].tls`              | Utilize TLS backend in ingress                                | `false`                                                  |
| `ingress.hosts[0].tlsHosts`         | Array of TLS hosts for ingress record (defaults to `ingress.hosts[0].name` if `nil`)                               | `nil`                                                  |
| `ingress.hosts[0].tlsSecret`        | TLS Secret (certificates)                                     | `opencart.local-tls-secret`                                 |
| `ingress.secrets[0].name`           | TLS Secret Name                                               | `nil`                                                    |
| `ingress.secrets[0].certificate`    | TLS Secret Certificate                                        | `nil`                                                    |
| `ingress.secrets[0].key`            | TLS Secret Key                                                | `nil`                                                    |
| `externalDatabase.host`             | Host of the external database             | `nil`                                                    |
| `externalDatabase.port`             | Port of the external database             | `3306`                                                   |
| `externalDatabase.user`             | Existing username in the external db      | `bn_opencart`                                            |
| `externalDatabase.password`         | Password for the above username           | `nil`                                                    |
| `externalDatabase.database`         | Name of the existing database             | `bitnami_opencart`                                       |
| `mariadb.enabled`                   | Whether to use MariaDB chart              | `true`                                                   |
| `mariadb.db.name`                   | Database name to create                   | `bitnami_opencart`                                       |
| `mariadb.db.user`                   | Database user to create                   | `bn_opencart`                                            |
| `mariadb.db.password`               | Password for the database                 | `nil`                                                    |
| `mariadb.rootUser.password`         | MariaDB admin password                    | `nil`                                                    |
| `serviceType`                       | Kubernetes Service type                   | `LoadBalancer`                                           |
| `persistence.enabled`               | Enable persistence using PVC              | `true`                                                   |
| `persistence.opencart.storageClass` | PVC Storage Class for OpenCart volume     | `nil` (uses alpha storage class annotation)              |
| `persistence.opencart.accessMode`   | PVC Access Mode for OpenCart volume       | `ReadWriteOnce`                                          |
| `persistence.opencart.size`         | PVC Storage Request for OpenCart volume   | `8Gi`                                                    |
| `resources`                         | CPU/Memory resource requests/limits       | Memory: `512Mi`, CPU: `300m`                             |
| `podAnnotations`                    | Pod annotations                           | `{}`                                                     |
| `affinity`                          | Map of node/pod affinities                | `{}`                                                      |
| `metrics.enabled`                   | Start a side-car prometheus exporter      | `false`                                                  |
| `metrics.image.registry`            | Apache exporter image registry            | `docker.io`                                              |
| `metrics.image.repository`          | Apache exporter image name                | `bitnami/apache-exporter`                                |
| `metrics.image.tag`                 | Apache exporter image tag                 | `{TAG_NAME}`                                             |
| `metrics.image.pullPolicy`          | Image pull policy                         | `IfNotPresent`                                           |
| `metrics.image.pullSecrets`         | Specify docker-registry secret names as an array | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`            | Additional annotations for Metrics exporter pod  | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources`                 | Exporter resource requests/limit          | {}                                                       |

The above parameters map to the env variables defined in [bitnami/opencart](http://github.com/bitnami/bitnami-docker-opencart). For more information please refer to the [bitnami/opencart](http://github.com/bitnami/bitnami-docker-opencart) image documentation.

> **Note**:
>
> For OpenCart to function correctly, you should specify the `opencartHost` parameter to specify the FQDN (recommended) or the public IP address of the OpenCart service.
>
> Optionally, you can specify the `opencartLoadBalancerIP` parameter to assign a reserved IP address to the OpenCart service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create opencart-public-ip
> ```
>
> The reserved IP address can be associated to the OpenCart service by specifying it as the value of the `opencartLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set opencartUsername=admin,opencartPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/opencart
```

The above command sets the OpenCart administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/opencart
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami OpenCart](https://github.com/bitnami/bitnami-docker-opencart) image stores the OpenCart data and configurations at the `/bitnami/opencart` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is opencart:

```console
$ kubectl patch deployment opencart-opencart --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset opencart-mariadb --cascade=false
```
