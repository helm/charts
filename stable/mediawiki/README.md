# MediaWiki

[MediaWiki](https://www.mediawiki.org) is an extremely powerful, scalable software and a feature-rich wiki implementation that uses PHP to process and display data stored in a database, such as MySQL.

## TL;DR;

```console
$ helm install stable/mediawiki
```

## Introduction

This chart bootstraps a [MediaWiki](https://github.com/bitnami/bitnami-docker-mediawiki) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the MediaWiki application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/mediawiki
```

The command deploys MediaWiki on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the MediaWiki chart and their default values.

|              Parameter               |               Description                                   |                         Default                         |
|--------------------------------------|-------------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`               | Global Docker image registry                                | `nil`                                                   |
| `global.imagePullSecrets`            | Global Docker registry secret names as an array             | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                     | Global storage class for dynamic provisioning                                               | `nil`                                                        |
| `image.registry`                     | MediaWiki image registry                                    | `docker.io`                                             |
| `image.repository`                   | MediaWiki Image name                                        | `bitnami/mediawiki`                                     |
| `image.tag`                          | MediaWiki Image tag                                         | `{TAG_NAME}`                                            |
| `image.pullPolicy`                   | Image pull policy                                           | `IfNotPresent`                                          |
| `image.pullSecrets`                  | Specify docker-registry secret names as an array            | `[]` (does not add image pull secrets to deployed pods) |
| `nameOverride`                       | String to partially override mediawiki.fullname template with a string (will prepend the release name)    | `nil`     |
| `fullnameOverride`                   | String to fully override mediawiki.fullname template with a string                                        | `nil`     |
| `mediawikiUser`                      | User of the application                                     | `user`                                                  |
| `mediawikiPassword`                  | Application password                                        | _random 10 character long alphanumeric string_          |
| `mediawikiEmail`                     | Admin email                                                 | `user@example.com`                                      |
| `mediawikiName`                      | Name for the wiki                                           | `My Wiki`                                               |
| `mediawikiHost`                      | Mediawiki host to create application URLs                   | `nil`                                                   |
| `allowEmptyPassword`                 | Allow DB blank passwords                                    | `yes`                                                   |
| `smtpHost`                           | SMTP host                                                   | `nil`                                                   |
| `smtpPort`                           | SMTP port                                                   | `nil`                                                   |
| `smtpHostID`                         | SMTP host ID                                                | `nil`                                                   |
| `smtpUser`                           | SMTP user                                                   | `nil`                                                   |
| `smtpPassword`                       | SMTP password                                               | `nil`                                                   |
| `externalDatabase.host`              | Host of the external database                               | `nil`                                                   |
| `externalDatabase.user`              | Existing username in the external db                        | `bn_mediawiki`                                          |
| `externalDatabase.password`          | Password for the above username                             | `nil`                                                   |
| `externalDatabase.database`          | Name of the existing database                               | `bitnami_mediawiki`                                     |
| `mariadb.enabled`                    | Use or not the mariadb chart                                | `true`                                                  |
| `mariadb.rootUser.password`          | MariaDB admin password                                      | `nil`                                                   |
| `mariadb.db.name`                    | Database name to create                                     | `bitnami_mediawiki`                                     |
| `mariadb.db.user`                    | Database user to create                                     | `bn_mediawiki`                                          |
| `mariadb.db.password`                | Password for the database                                   | _random 10 character long alphanumeric string_          |
| `service.type`                       | Kubernetes Service type                                     | `LoadBalancer`                                          |
| `service.loadBalancer`               | Kubernetes LoadBalancerIP to request                        | `nil`                                                   |
| `service.port`                       | Service HTTP port                                           | `80`                                                    |
| `service.httpsPort`                  | Service HTTPS port                                          | `""`                                                    |
| `service.externalTrafficPolicy`      | Enable client source IP preservation                        | `Cluster`                                               |
| `service.nodePorts.http`             | Kubernetes http node port                                   | `""`                                                    |
| `service.nodePorts.https`            | Kubernetes https node port                                  | `""`                                                    |
| `ingress.enabled`                    | Enable ingress controller resource                          | `false`                                                 |
| `ingress.hosts[0].name`              | Hostname to your Mediawiki installation                     | `mediawiki.local`                                       |
| `ingress.hosts[0].path`              | Path within the url structure                               | `/`                                                     |
| `ingress.hosts[0].tls`               | Utilize TLS backend in ingress                              | `false`                                                 |
| `ingress.hosts[0].certManager`       | Add annotations for cert-manager                            | `false`                                                 |
| `ingress.hosts[0].tlsSecret`         | TLS Secret (certificates)                                   | `mediawiki.local-tls-secret`                            |
| `ingress.hosts[0].annotations`       | Annotations for this host's ingress record                  | `[]`                                                    |
| `ingress.secrets[0].name`            | TLS Secret Name                                             | `nil`                                                   |
| `ingress.secrets[0].certificate`     | TLS Secret Certificate                                      | `nil`                                                   |
| `ingress.secrets[0].key`             | TLS Secret Key                                              | `nil`                                                   |
| `persistence.enabled`                | Enable persistence using PVC                                | `true`                                                  |
| `persistence.storageClass`           | PVC Storage Class for MediaWiki volume                      | `nil` (uses alpha storage class annotation)             |
| `persistence.existingClaim`          | An Existing PVC name for MediaWiki volume                   | `nil` (uses alpha storage class annotation)             |
| `persistence.accessMode`             | PVC Access Mode for MediaWiki volume                        | `ReadWriteOnce`                                         |
| `persistence.size`                   | PVC Storage Request for MediaWiki volume                    | `8Gi`                                                   |
| `resources`                          | CPU/Memory resource requests/limits                         | Memory: `512Mi`, CPU: `300m`                            |
| `livenessProbe.enabled`              | Enable/disable the liveness probe (ingest nodes pod)        | `true`                                                  |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated (ingest nodes pod) | 120                                                     |
| `livenessProbe.periodSeconds`        | How often to perform the probe (ingest nodes pod)           | 10                                                      |
| `livenessProbe.timeoutSeconds`       | When the probe times out (ingest nodes pod)                 | 5                                                       |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures to be considered failed        | 6                                                       |
| `livenessProbe.successThreshold`     | Minimum consecutive successes to be considered successful   | 1                                                       |
| `readinessProbe.enabled`             | would you like a readinessProbe to be enabled               | `true`                                                  |
| `readinessProbe.initialDelaySeconds` | Delay before readinessProbe is initiated (ingest nodes pod) | 30                                                      |
| `readinessProbe.periodSeconds   `    | How often to perform the probe (ingest nodes pod)           | 10                                                      |
| `readinessProbe.timeoutSeconds`      | When the probe times out (ingest nodes pod)                 | 5                                                       |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures to be considered failed        | 6                                                       |
| `readinessProbe.successThreshold`    | Minimum consecutive successes to be considered successful   | 1                                                       |
| `podAnnotations`                     | Pod annotations                                             | `{}`                                                    |
| `affinity`                           | Map of node/pod affinities                                  | `{}`                                                    |
| `metrics.enabled`                    | Start a side-car prometheus exporter                        | `false`                                                 |
| `metrics.image.registry`             | Apache exporter image registry                              | `docker.io`                                             |
| `metrics.image.repository`           | Apache exporter image name                                  | `bitnami/apache-exporter`                               |
| `metrics.image.tag`                  | Apache exporter image tag                                   | `{TAG_NAME}`                                            |
| `metrics.image.pullPolicy`           | Image pull policy                                           | `IfNotPresent`                                          |
| `metrics.image.pullSecrets`          | Specify docker-registry secret names as an array            | `[]` (does not add image pull secrets to deployed pods) |
| `metrics.podAnnotations`             | Additional annotations for Metrics exporter pod             | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources`                  | Exporter resource requests/limit                            | {}                                                      |

The above parameters map to the env variables defined in [bitnami/mediawiki](http://github.com/bitnami/bitnami-docker-mediawiki). For more information please refer to the [bitnami/mediawiki](http://github.com/bitnami/bitnami-docker-mediawiki) image documentation.

> **Note**:
>
> For Mediawiki to function correctly, you should specify the `mediawikiHost` parameter to specify the FQDN (recommended) or the public IP address of the Mediawiki service.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set mediawikiUser=admin,mediawikiPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/mediawiki
```

The above command sets the MediaWiki administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/mediawiki
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami MediaWiki](https://github.com/bitnami/bitnami-docker-mediawiki) image stores the MediaWiki data and configurations at the `/bitnami/mediawiki` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Upgrading

### To 9.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17300 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 4.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 4.0.0. The following example assumes that the release name is mediawiki:

```console
$ kubectl patch deployment mediawiki-mediawiki --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset mediawiki-mariadb --cascade=false
```
