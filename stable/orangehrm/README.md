# OrangeHRM

[OrangeHRM](https://www.orangehrm.com) is a free HR management system that offers a wealth of modules to suit the needs of your business. This widely-used system is feature-rich, intuitive and provides an essential HR management platform along with free documentation and access to a broad community of users.

## This Helm chart is deprecated

Given the [`stable` deprecation timeline](https://github.com/helm/charts#deprecation-timeline), the Bitnami maintained OrangeHRM Helm chart is now located at [bitnami/charts](https://github.com/bitnami/charts/).

The Bitnami repository is already included in the Hubs and we will continue providing the same cadence of updates, support, etc that we've been keeping here these years. Installation instructions are very similar, just adding the _bitnami_ repo and using it during the installation (`bitnami/<chart>` instead of `stable/<chart>`)

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/<chart>           # Helm 3
$ helm install --name my-release bitnami/<chart>    # Helm 2
```

To update an exisiting _stable_ deployment with a chart hosted in the bitnami repository you can execute

```bash
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm upgrade my-release bitnami/<chart>
```

Issues and PRs related to the chart itself will be redirected to `bitnami/charts` GitHub repository. In the same way, we'll be happy to answer questions related to this migration process in [this issue](https://github.com/helm/charts/issues/20969) created as a common place for discussion.

## TL;DR;

```console
$ helm install my-release stable/orangehrm
```

## Introduction

This chart bootstraps an [OrangeHRM](https://github.com/bitnami/bitnami-docker-orangehrm) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the OrangeHRM application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release stable/orangehrm
```

The command deploys OrangeHRM on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the OrangeHRM chart and their default values.

|              Parameter               |               Description                |                    Default                              |
|--------------------------------------|------------------------------------------|-------------------------------------------------------- |
| `global.imageRegistry`               | Global Docker image registry             | `nil`                                                   |
| `global.imagePullSecrets`            | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                     | Global storage class for dynamic provisioning                                               | `nil`                                                        |
| `image.registry`                     | OrangeHRM image registry                 | `docker.io`                                             |
| `image.repository`                   | OrangeHRM Image name                     | `bitnami/orangehrm`                                     |
| `image.tag`                          | OrangeHRM Image tag                      | `{TAG_NAME}`                                            |
| `image.pullPolicy`                   | Image pull policy                        | `IfNotPresent`                                          |
| `image.pullSecrets`                  | Specify docker-registry secret names as an array               | `[]` (does not add image pull secrets to deployed pods) |
| `nameOverride`                       | String to partially override orangehrm.fullname template with a string (will prepend the release name) | `nil` |
| `fullnameOverride`                   | String to fully override orangehrm.fullname template with a string                                     | `nil` |
| `orangehrmUsername`                  | User of the application                  | `user`                                                  |
| `orangehrmPassword`                  | Application password                     | _random 10 character long alphanumeric string_          |
| `smtpHost`                           | SMTP host                                | `nil`                                                   |
| `smtpPort`                           | SMTP port                                | `nil`                                                   |
| `smtpUser`                           | SMTP user                                | `nil`                                                   |
| `smtpPassword`                       | SMTP password                            | `nil`                                                   |
| `smtpProtocol`                       | SMTP protocol [`ssl`, `none`]            | `nil`                                                   |
| `service.type`                    | Kubernetes Service type                    | `LoadBalancer`                                          |
| `service.port`                    | Service HTTP port                    | `80`                                          |
| `service.httpsPort`                    | Service HTTPS port                    | `443`                                          |
| `service.externalTrafficPolicy`   | Enable client source IP preservation       | `Cluster`                                               |
| `service.nodePorts.http`                 | Kubernetes http node port                  | `""`                                                    |
| `service.nodePorts.https`                | Kubernetes https node port                 | `""`                                                    |
| `ingress.enabled`                   | Enable ingress controller resource                            | `false`                                                  |
| `ingress.annotations`               | Ingress annotations                                           | `[]`                                                     |
| `ingress.certManager`               | Add annotations for cert-manager                              | `false`                                                  |
| `ingress.hosts[0].name`             | Hostname to your OrangeHRM installation                           | `orangehrm.local`                                            |
| `ingress.hosts[0].path`             | Path within the url structure                                 | `/`                                                      |
| `ingress.hosts[0].tls`              | Utilize TLS backend in ingress                                | `false`                                                  |
| `ingress.hosts[0].tlsHosts`         | Array of TLS hosts for ingress record (defaults to `ingress.hosts[0].name` if `nil`)                               | `nil`                                                  |
| `ingress.hosts[0].tlsSecret`        | TLS Secret (certificates)                                     | `orangehrm.local-tls-secret`                                 |
| `ingress.secrets[0].name`           | TLS Secret Name                                               | `nil`                                                    |
| `ingress.secrets[0].certificate`    | TLS Secret Certificate                                        | `nil`                                                    |
| `ingress.secrets[0].key`            | TLS Secret Key                                                | `nil`                                                    |
| `resources`                          | CPU/Memory resource requests/limits      | Memory: `512Mi`, CPU: `300m`                            |
| `persistence.enabled`                | Enable persistence using PVC             | `true`                                                  |
| `persistence.orangehrm.storageClass` | PVC Storage Class for OrangeHRM volume   | `nil` (uses alpha storage class annotation)             |
| `persistence.orangehrm.accessMode`   | PVC Access Mode for OrangeHRM volume     | `ReadWriteOnce`                                         |
| `persistence.orangehrm.size`         | PVC Storage Request for OrangeHRM volume | `8Gi`                                                   |
| `allowEmptyPassword`                 | Allow DB blank passwords                 | `yes`                                                   |
| `externalDatabase.host`              | Host of the external database            | `nil`                                                   |
| `externalDatabase.port`              | Port of the external database            | `3306`                                                  |
| `externalDatabase.user`              | Existing username in the external db     | `bn_orangehrm`                                          |
| `externalDatabase.password`          | Password for the above username          | `nil`                                                   |
| `externalDatabase.database`          | Name of the existing database            | `bitnami_orangehrm`                                     |
| `mariadb.enabled`                    | Whether to use the MariaDB chart         | `true`                                                  |
| `mariadb.db.name`            | Database name to create                  | `bitnami_orangehrm`                                     |
| `mariadb.db.user`                | Database user to create                  | `bn_orangehrm`                                          |
| `mariadb.db.password`            | Password for the database                | `nil`                                                   |
| `mariadb.rootUser.password`        | MariaDB admin password                   | `nil`                                                   |
| `mariadb.persistence.enabled`        | Enable MariaDB persistence using PVC     | `true`                                                  |
| `mariadb.persistence.storageClass`   | PVC Storage Class for MariaDB volume     | `nil` (uses alpha storage class annotation)             |
| `mariadb.persistence.accessMode`     | PVC Access Mode for MariaDB volume       | `ReadWriteOnce`                                         |
| `mariadb.persistence.size`           | PVC Storage Request for MariaDB volume   | `8Gi`                                                   |
| `podAnnotations`                | Pod annotations                                   | `{}`                                                       |
| `affinity`                        | Map of node/pod affinities                 | `{}`                                                      |
| `metrics.enabled`                          | Start a side-car prometheus exporter                                                                           | `false`                                              |
| `metrics.image.registry`                   | Apache exporter image registry                                                                                  | `docker.io`                                         |
| `metrics.image.repository`                 | Apache exporter image name                                                                                      | `bitnami/apache-exporter`                           |
| `metrics.image.tag`                        | Apache exporter image tag                                                                                       | `{TAG_NAME}`                                        |
| `metrics.image.pullPolicy`                 | Image pull policy                                                                                              | `IfNotPresent`                                       |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                               | `[]` (does not add image pull secrets to deployed pods)                                                |
| `metrics.podAnnotations`                   | Additional annotations for Metrics exporter pod                                                                | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}`                                                   |
| `metrics.resources`                        | Exporter resource requests/limit                                                                               | {}                        |

The above parameters map to the env variables defined in [bitnami/orangehrm](http://github.com/bitnami/bitnami-docker-orangehrm). For more information please refer to the [bitnami/orangehrm](http://github.com/bitnami/bitnami-docker-orangehrm) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set orangehrmUsername=admin,orangehrmPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/orangehrm
```

The above command sets the OrangeHRM administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml stable/orangehrm
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami OrangeHRM](https://github.com/bitnami/bitnami-docker-orangehrm) image stores the OrangeHRM data and configurations at the `/bitnami/orangehrm` path of the container.

Persistent Volume Claims are used to keep the data across deployments. There is a [known issue](https://github.com/kubernetes/kubernetes/issues/39178) in Kubernetes Clusters with EBS in different availability zones. Ensure your cluster is configured properly to create Volumes in the same availability zone where the nodes are running. Kuberentes 1.12 solved this issue with the [Volume Binding Mode](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode).

See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Upgrading

### To 7.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In this version the `apiVersion` of the deployment resources is updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is orangehrm:

```console
$ kubectl patch deployment orangehrm-orangehrm --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset orangehrm-mariadb --cascade=false
```
