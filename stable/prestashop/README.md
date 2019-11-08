# PrestaShop

[PrestaShop](https://prestashop.com/) is a popular open source e-commerce solution. Professional tools are easily accessible to increase online sales including instant guest checkout, abandoned cart reminders and automated Email marketing.

## TL;DR;

```console
$ helm install stable/prestashop
```

## Introduction

This chart bootstraps a [PrestaShop](https://github.com/bitnami/bitnami-docker-prestashop) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the PrestaShop application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/prestashop
```

The command deploys PrestaShop on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the PrestaShop chart and their default values.

| Parameter                            | Description                                                                                             | Default                                                      |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| `global.imageRegistry`               | Global Docker image registry                                                                            | `nil`                                                        |
| `global.imagePullSecrets`            | Global Docker registry secret names as an array                                                         | `[]` (does not add image pull secrets to deployed pods)      |
| `global.storageClass`                     | Global storage class for dynamic provisioning                                               | `nil`                                                        |
| `image.registry`                     | PrestaShop image registry                                                                               | `docker.io`                                                  |
| `image.repository`                   | PrestaShop image name                                                                                   | `bitnami/prestashop`                                         |
| `image.tag`                          | PrestaShop image tag                                                                                    | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                   | Image pull policy                                                                                       | `IfNotPresent`                                               |
| `image.pullSecrets`                  | Specify docker-registry secret names as an array                                                        | `[]` (does not add image pull secrets to deployed pods)      |
| `nameOverride`                       | String to partially override prestashop.fullname template with a string (will prepend the release name) | `nil`                                                        |
| `fullnameOverride`                   | String to fully override prestashop.fullname template with a string                                     | `nil`                                                        |
| `service.type`                       | Kubernetes Service type                                                                                 | `LoadBalancer`                                               |
| `service.port`                       | Service HTTP port                                                                                       | `80`                                                         |
| `service.httpsPort`                  | Service HTTPS port                                                                                      | `443`                                                        |
| `service.nodePorts.http`             | Kubernetes http node port                                                                               | `""`                                                         |
| `service.nodePorts.https`            | Kubernetes https node port                                                                              | `""`                                                         |
| `service.externalTrafficPolicy`      | Enable client source IP preservation                                                                    | `Cluster`                                                    |
| `service.loadBalancerIP          `   | LoadBalancer service IP address                                                                         | `""`                                                         |
| `ingress.enabled`                    | Enable ingress controller resource                                                                      | `false`                                                      |
| `ingress.certManager`                | Add annotations for cert-manager                                                                        | `false`                                                      |
| `ingress.annotations`                | Ingress annotations                                                                                     | `[]`                                                         |
| `ingress.hosts[0].name`              | Hostname to your PrestaShop installation                                                                | `prestashop.local`                                           |
| `ingress.hosts[0].path`              | Path within the url structure                                                                           | `/`                                                          |
| `ingress.hosts[0].tls`               | Utilize TLS backend in ingress                                                                          | `false`                                                      |
| `ingress.hosts[0].tlsSecret`         | TLS Secret (certificates)                                                                               | `prestashop.local-tls`                                       |
| `ingress.secrets[0].name`            | TLS Secret Name                                                                                         | `nil`                                                        |
| `ingress.secrets[0].certificate`     | TLS Secret Certificate                                                                                  | `nil`                                                        |
| `ingress.secrets[0].key`             | TLS Secret Key                                                                                          | `nil`                                                        |
| `prestashopHost`                     | PrestaShop host to create application URLs (when ingress, it will be ignored)                           | `nil`                                                        |
| `prestashopUsername`                 | User of the application                                                                                 | `user@example.com`                                           |
| `prestashopPassword`                 | Application password                                                                                    | _random 10 character long alphanumeric string_               |
| `prestashopEmail`                    | Admin email                                                                                             | `user@example.com`                                           |
| `prestashopFirstName`                | First Name                                                                                              | `Bitnami`                                                    |
| `prestashopLastName`                 | Last Name                                                                                               | `Name`                                                       |
| `prestashopCookieCheckIP`            | Whether to check the cookie's IP address or not                                                         | `no`                                                         |
| `prestashopCountry`                  | Default country of the store                                                                            | `us`                                                         |
| `prestashopLanguage`                 | Default language of the store (iso code)                                                                | `en`                                                         |
| `smtpHost`                           | SMTP host                                                                                               | `nil`                                                        |
| `smtpPort`                           | SMTP port                                                                                               | `nil`                                                        |
| `smtpUser`                           | SMTP user                                                                                               | `nil`                                                        |
| `smtpPassword`                       | SMTP password                                                                                           | `nil`                                                        |
| `smtpProtocol`                       | SMTP protocol [`ssl`, `tls`]                                                                            | `nil`                                                        |
| `allowEmptyPassword`                 | Allow DB blank passwords                                                                                | `yes`                                                        |
| `externalDatabase.host`              | Host of the external database                                                                           | `nil`                                                        |
| `externalDatabase.port`              | SMTP protocol [`ssl`, `none`]                                                                           | `3306`                                                       |
| `externalDatabase.user`              | Existing username in the external db                                                                    | `bn_prestashop`                                              |
| `externalDatabase.password`          | Password for the above username                                                                         | `nil`                                                        |
| `externalDatabase.database`          | Name of the existing database                                                                           | `bitnami_prestashop`                                         |
| `mariadb.enabled`                    | Whether to use the MariaDB chart                                                                        | `true`                                                       |
| `mariadb.image.registry`             | MariaDB image registry                                                                                  | `docker.io`                                                  |
| `mariadb.image.repository`           | MariaDB image name                                                                                      | `bitnami/mariadb`                                            |
| `mariadb.image.tag`                  | MariaDB image tag                                                                                       | `{TAG_NAME}`                                                 |
| `mariadb.db.name`                    | Database name to create                                                                                 | `bitnami_prestashop`                                         |
| `mariadb.db.user`                    | Database user to create                                                                                 | `bn_prestashop`                                              |
| `mariadb.db.password`                | Password for the database                                                                               | `nil`                                                        |
| `mariadb.rootUser.password`          | MariaDB admin password                                                                                  | `nil`                                                        |
| `sessionAffinity`                    | Configures the session affinity                                                                         | `None`                                                       |
| `persistence.enabled`                | Enable persistence using PVC                                                                            | `true`                                                       |
| `persistence.storageClass`           | PVC Storage Class for PrestaShop volume                                                                 | `nil` (uses alpha storage class annotation)                  |
| `persistence.existingClaim`          | An Existing PVC name for PrestaShop volume                                                              | `nil` (uses alpha storage class annotation)                  |
| `persistence.accessMode`             | PVC Access Mode for PrestaShop volume                                                                   | `ReadWriteOnce`                                              |
| `persistence.size`                   | PVC Storage Request for PrestaShop volume                                                               | `8Gi`                                                        |
| `resources`                          | CPU/Memory resource requests/limits                                                                     | Memory: `512Mi`, CPU: `300m`                                 |
| `livenessProbe.enabled`              | Would you like a livenessProbe to be enabled                                                                                                               | `true`                                                       |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                                | 600                                                          |
| `livenessProbe.periodSeconds`        | How often to perform the probe                                                                          | 3                                                            |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                                                                | 5                                                            |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.              | 6                                                            |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed.            | 1                                                            |
| `readinessProbe.enabled`             | Would you like a readinessProbe to be enabled                                                                                                               | `true`                                                       |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                                                               | 30                                                           |
| `readinessProbe.periodSeconds`       | How often to perform the probe                                                                          | 3                                                            |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                                                                | 5                                                            |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.              | 6                                                            |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed.            | 1                                                            |
| `podAnnotations`                     | Pod annotations                                                                                         | `{}`                                                         |
| `affinity`                           | Map of node/pod affinities                                                                              | `{}`                                                         |
| `metrics.enabled`                    | Start a side-car prometheus exporter                                                                    | `false`                                                      |
| `metrics.image.registry`             | Apache exporter image registry                                                                          | `docker.io`                                                  |
| `metrics.image.repository`           | Apache exporter image name                                                                              | `bitnami/apache-exporter`                                    |
| `metrics.image.tag`                  | Apache exporter image tag                                                                               | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`           | Image pull policy                                                                                       | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`          | Specify docker-registry secret names as an array                                                        | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`             | Additional annotations for Metrics exporter pod                                                         | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources`                  | Exporter resource requests/limit                                                                        | {}                                                           |

The above parameters map to the env variables defined in [bitnami/prestashop](http://github.com/bitnami/bitnami-docker-prestashop). For more information please refer to the [bitnami/prestashop](http://github.com/bitnami/bitnami-docker-prestashop) image documentation.

> **Note**:
>
> For PrestaShop to function correctly, you should specify the `prestashopHost` parameter to specify the FQDN (recommended) or the public IP address of the PrestaShop service.
>
> Optionally, you can specify the `prestashopLoadBalancerIP` parameter to assign a reserved IP address to the PrestaShop service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create prestashop-public-ip
> ```
>
> The reserved IP address can be associated to the PrestaShop service by specifying it as the value of the `prestashopLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set prestashopUsername=admin,prestashopPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/prestashop
```

The above command sets the PrestaShop administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/prestashop
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami PrestaShop](https://github.com/bitnami/bitnami-docker-prestashop) image stores the PrestaShop data and configurations at the `/bitnami/prestashop` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is prestashop:

```console
$ kubectl patch deployment prestashop-prestashop --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset prestashop-mariadb --cascade=false
```
