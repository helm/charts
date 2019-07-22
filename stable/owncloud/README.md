# ownCloud

[ownCloud](https://owncloud.org/) is a file sharing server that puts the control and security of your own data back into your hands.

## TL;DR;

```console
$ helm install stable/owncloud
```

## Introduction

This chart bootstraps an [ownCloud](https://github.com/bitnami/bitnami-docker-owncloud) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the ownCloud application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

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

The following table lists the configurable parameters of the ownCloud chart and their default values.

|              Parameter              |                Description                 |                   Default                               |
|-------------------------------------|--------------------------------------------|-------------------------------------------------------- |
| `global.imageRegistry`              | Global Docker image registry               | `nil`                                                   |
| `global.imagePullSecrets`           | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`                    | ownCloud image registry                    | `docker.io`                                             |
| `image.repository`                  | ownCloud Image name                        | `bitnami/owncloud`                                      |
| `image.tag`                         | ownCloud Image tag                         | `{TAG_NAME}`                                            |
| `image.pullPolicy`                  | Image pull policy                          | `IfNotPresent`                                          |
| `image.pullSecrets`                 | Specify docker-registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `nameOverride`                      | String to partially override owncloud.fullname template with a string (will prepend the release name) | `nil` |
| `fullnameOverride`                  | String to fully override owncloud.fullname template with a string                                     | `nil` |
| `ingress.enabled`                   | Enable ingress controller resource         | `false`                                                 |
| `ingress.hosts[0].name`             | Hostname to your ownCloud installation     | `owncloud.local`                                        |
| `ingress.hosts[0].path`             | Path within the url structure              | `/`                                                     |
| `ingress.hosts[0].tls`              | Utilize TLS backend in ingress             | `false`                                                 |
| `ingress.hosts[0].certManager`      | Add annotations for cert-manager           | `false`                                                 |
| `ingress.hosts[0].tlsSecret`        | TLS Secret (certificates)                  | `owncloud.local-tls-secret`                             |
| `ingress.hosts[0].annotations`      | Annotations for this host's ingress record | `[]`                                                    |
| `ingress.secrets[0].name`           | TLS Secret Name                            | `nil`                                                   |
| `ingress.secrets[0].certificate`    | TLS Secret Certificate                     | `nil`                                                   |
| `ingress.secrets[0].key`            | TLS Secret Key                             | `nil`                                                   |
| `networkPolicyApiVersion`           | The kubernetes network API version         | `extensions/v1beta1`                                    |
| `owncloudHost`                      | ownCloud host to create application URLs   | `nil`                                                   |
| `owncloudLoadBalancerIP`            | `loadBalancerIP` for the owncloud Service  | `nil`                                                   |
| `owncloudUsername`                  | User of the application                    | `user`                                                  |
| `owncloudPassword`                  | Application password                       | Randomly generated                                      |
| `owncloudEmail`                     | Admin email                                | `user@example.com`                                      |
| `externalDatabase.host`             | Host of the external database              | `nil`                                                   |
| `allowEmptyPassword`                | Allow DB blank passwords                   | `yes`                                                   |
| `externalDatabase.host`             | Host of the external database              | `nil`                                                   |
| `externalDatabase.port`             | Port of the external database              | `3306`                                                  |
| `externalDatabase.database`         | Name of the existing database              | `bitnami_owncloud`                                      |
| `externalDatabase.user`             | Existing username in the external db       | `bn_owncloud`                                           |
| `externalDatabase.password`         | Password for the above username            | `nil`                                                   |
| `mariadb.db.name`                   | Database name to create                    | `bitnami_owncloud`                                      |
| `mariadb.enabled`                   | Whether to use the MariaDB chart           | `true`                                                  |
| `mariadb.db.password`               | Password for the database                  | `nil`                                                   |
| `mariadb.db.user`                   | Database user to create                    | `bn_owncloud`                                           |
| `mariadb.rootUser.password`         | MariaDB admin password                     | `nil`                                                   |
| `serviceType`                       | Kubernetes Service type                    | `LoadBalancer`                                          |
| `persistence.enabled`               | Enable persistence using PVC               | `true`                                                  |
| `persistence.owncloud.storageClass` | PVC Storage Class for ownCloud volume      | `nil` (uses alpha storage class annotation)             |
| `persistence.owncloud.existingClaim`| An Existing PVC name for ownCloud volume   | `nil` (uses alpha storage class annotation)             |
| `persistence.owncloud.accessMode`   | PVC Access Mode for ownCloud volume        | `ReadWriteOnce`                                         |
| `persistence.owncloud.size`         | PVC Storage Request for ownCloud volume    | `8Gi`                                                   |
| `resources`                         | CPU/Memory resource requests/limits        | Memory: `512Mi`, CPU: `300m`                            |
| `podAnnotations`                    | Pod annotations                            | `{}`                                                    |
| `metrics.enabled`                   | Start a side-car prometheus exporter       | `false`                                                 |
| `metrics.image.registry`            | Apache exporter image registry             | `docker.io`                                             |
| `metrics.image.repository`          | Apache exporter image name                 | `lusotycoon/apache-exporter`                            |
| `metrics.image.tag`                 | Apache exporter image tag                  | `v0.5.0`                                                |
| `metrics.image.pullPolicy`          | Image pull policy                          | `IfNotPresent`                                          |
| `metrics.image.pullSecrets`         | Specify docker-registry secret names as an array | `[]` (does not add image pull secrets to deployed pods)  |
| `metrics.podAnnotations`            | Additional annotations for Metrics exporter pod  | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources`                 | Exporter resource requests/limit           | {}                                                      |

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

The above command sets the ownCloud administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/owncloud
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami ownCloud](https://github.com/bitnami/bitnami-docker-owncloud) image stores the ownCloud data and configurations at the `/bitnami/owncloud` path of the container.

Persistent Volume Claims are used to keep the data across deployments. There is a [known issue](https://github.com/kubernetes/kubernetes/issues/39178) in Kubernetes Clusters with EBS in different availability zones. Ensure your cluster is configured properly to create Volumes in the same availability zone where the nodes are running. Kuberentes 1.12 solved this issue with the [Volume Binding Mode](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode).

See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is owncloud:

```console
$ kubectl patch deployment owncloud-owncloud --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset owncloud-mariadb --cascade=false
```
