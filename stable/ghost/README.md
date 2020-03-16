# Ghost

[Ghost](https://ghost.org/) is one of the most versatile open source content management systems on the market.

## This Helm chart is deprecated

Given the [`stable` deprecation timeline](https://github.com/helm/charts#deprecation-timeline), the Bitnami maintained Ghost Helm chart is now located at [bitnami/charts](https://github.com/bitnami/charts/).

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
$ helm install my-release stable/ghost
```

## Introduction

This chart bootstraps a [Ghost](https://github.com/bitnami/bitnami-docker-ghost) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Ghost application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release stable/ghost
```

The command deploys Ghost on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the Ghost chart and their default values.

| Parameter                           | Description                                                   | Default                                                  |
|-------------------------------------|---------------------------------------------------------------|----------------------------------------------------------|
| `global.imageRegistry`              | Global Docker image registry                                  | `nil`                                                    |
| `global.imagePullSecrets`           | Global Docker registry secret names as an array               | `[]` (does not add image pull secrets to deployed pods)  |
| `global.storageClass`               | Global storage class for dynamic provisioning                 | `nil`                                                    |
| `image.registry`                    | Ghost image registry                                          | `docker.io`                                              |
| `image.repository`                  | Ghost Image name                                              | `bitnami/ghost`                                          |
| `image.tag`                         | Ghost Image tag                                               | `{TAG_NAME}`                                             |
| `image.pullPolicy`                  | Image pull policy                                             | `IfNotPresent`                                           |
| `image.pullSecrets`                 | Specify docker-registry secret names as an array              | `[]` (does not add image pull secrets to deployed pods)  |
| `nameOverride`                      | String to partially override ghost.fullname template with a string (will prepend the release name) | `nil`               |
| `fullnameOverride`                  | String to fully override ghost.fullname template with a string                                     | `nil`               |
| `volumePermissions.image.registry`  | Init container volume-permissions image registry              | `docker.io`                                              |
| `volumePermissions.image.repository`| Init container volume-permissions image name                  | `bitnami/minideb`                                        |
| `volumePermissions.image.tag`       | Init container volume-permissions image tag                   | `buster`                                                 |
| `volumePermissions.image.pullPolicy`| Init container volume-permissions image pull policy           | `Always`                                                 |
| `ghostHost`                         | Ghost host to create application URLs                         | `nil`                                                    |
| `ghostPort`                         | Ghost port to use in application URLs (defaults to `service.port` if `nil`) | `nil`                                      |
| `ghostProtocol`                     | Protocol (http or https) to use in the application URLs       | `http`                                                   |
| `ghostPath`                         | Ghost path to create application URLs                         | `nil`                                                    |
| `ghostUsername`                     | User of the application                                       | `user@example.com`                                       |
| `ghostPassword`                     | Application password                                          | Randomly generated                                       |
| `ghostEmail`                        | Admin email                                                   | `user@example.com`                                       |
| `ghostBlogTitle`                    | Ghost Blog name                                               | `User's Blog`                                            |
| `smtpHost`                          | SMTP host                                                     | `nil`                                                    |
| `smtpPort`                          | SMTP port                                                     | `nil`                                                    |
| `smtpUser`                          | SMTP user                                                     | `nil`                                                    |
| `smtpPassword`                      | SMTP password                                                 | `nil`                                                    |
| `smtpFromAddress`                   | SMTP from address                                             | `nil`                                                    |
| `smtpService`                       | SMTP service                                                  | `nil`                                                    |
| `allowEmptyPassword`                | Allow DB blank passwords                                      | `yes`                                                    |
| `livenessProbe.enabled`             | Would you like a livenessProbe to be enabled                  | `true`                                                   |
| `livenessProbe.initialDelaySeconds` | Delay before liveness probe is initiated                      | 120                                                      |
| `livenessProbe.periodSeconds`       | How often to perform the probe                                | 3                                                        |
| `livenessProbe.timeoutSeconds`      | When the probe times out                                      | 5                                                        |
| `livenessProbe.failureThreshold`    | Minimum consecutive failures to be considered failed          | 6                                                        |
| `livenessProbe.successThreshold`    | Minimum consecutive successes to be considered successful     | 1                                                        |
| `readinessProbe.enabled`            | Would you like a readinessProbe to be enabled                 | `true`                                                   |
| `readinessProbe.initialDelaySeconds`| Delay before readiness probe is initiated                     | 30                                                       |
| `readinessProbe.periodSeconds`      | How often to perform the probe                                | 3                                                        |
| `readinessProbe.timeoutSeconds`     | When the probe times out                                      | 5                                                        |
| `readinessProbe.failureThreshold`   |  Minimum consecutive failures to be considered failed         | 6                                                        |
| `readinessProbe.successThreshold`   | Minimum consecutive successes to be considered successful     | 1                                                        |
| `securityContext.enabled`           | Enable security context                                       | `true`                                                   |
| `securityContext.fsGroup`           | Group ID for the container                                    | `1001`                                                   |
| `securityContext.runAsUser`         | User ID for the container                                     | `1001`                                                   |
| `service.type`                      | Kubernetes Service type                                       | `LoadBalancer`                                           |
| `service.port`                      | Service HTTP port                                             | `80`                                                     |
| `service.nodePorts.http`            | Kubernetes http node port                                     | `""`                                                     |
| `service.externalTrafficPolicy`     | Enable client source IP preservation                          | `Cluster`                                                |
| `service.loadBalancerIP`            | LoadBalancerIP for the Ghost service                          | ``                                                       |
| `service.annotations`               | Service annotations                                           | ``                                                       |
| `ingress.enabled`                   | Enable ingress controller resource                            | `false`                                                  |
| `ingress.annotations`               | Ingress annotations                                           | `[]`                                                     |
| `ingress.certManager`               | Add annotations for cert-manager                              | `false`                                                  |
| `ingress.hosts[0].name`             | Hostname to your Ghost installation                           | `ghost.local`                                            |
| `ingress.hosts[0].path`             | Path within the url structure                                 | `/`                                                      |
| `ingress.hosts[0].tls`              | Utilize TLS backend in ingress                                | `false`                                                  |
| `ingress.hosts[0].tlsHosts`         | Array of TLS hosts for ingress record (defaults to `ingress.hosts[0].name` if `nil`)                               | `nil`                                                  |
| `ingress.hosts[0].tlsSecret`        | TLS Secret (certificates)                                     | `ghost.local-tls-secret`                                 |
| `ingress.secrets[0].name`           | TLS Secret Name                                               | `nil`                                                    |
| `ingress.secrets[0].certificate`    | TLS Secret Certificate                                        | `nil`                                                    |
| `ingress.secrets[0].key`            | TLS Secret Key                                                | `nil`                                                    |
| `externalDatabase.host`             | Host of the external database                                 | `localhost`                                              |
| `externalDatabase.port`             | Port of the external database                                 | `3306`                                                   |
| `externalDatabase.user`             | Existing username in the external db                          | `bn_ghost`                                               |
| `externalDatabase.password`         | Password for the above username                               | `""`                                                     |
| `externalDatabase.database`         | Name of the existing database                                 | `bitnami_ghost`                                          |
| `mariadb.enabled`                   | Whether or not to install MariaDB (disable if using external) | `true`                                                   |
| `mariadb.rootUser.password`         | MariaDB admin password                                        | `nil`                                                    |
| `mariadb.db.name`                   | MariaDB Database name to create                               | `bitnami_ghost`                                          |
| `mariadb.db.user`                   | MariaDB Database user to create                               | `bn_ghost`                                               |
| `mariadb.db.password`               | MariaDB Password for user                                     | _random 10 character long alphanumeric string_           |
| `persistence.enabled`               | Enable persistence using PVC                                  | `true`                                                   |
| `persistence.storageClass`          | PVC Storage Class for Ghost volume                            | `nil` (uses alpha storage annotation)                    |
| `persistence.accessMode`            | PVC Access Mode for Ghost volume                              | `ReadWriteOnce`                                          |
| `persistence.size`                  | PVC Storage Request for Ghost volume                          | `8Gi`                                                    |
| `persistence.path`                  | Path to mount the volume at, to use other images              | `/bitnami`                                               |
| `resources`                         | CPU/Memory resource requests/limits                           | Memory: `512Mi`, CPU: `300m`                             |
| `nodeSelector`                      | Node selector for pod assignment                              | `{}`                                                     |
| `affinity`                          | Map of node/pod affinities                                    | `{}`                                                     |

The above parameters map to the env variables defined in [bitnami/ghost](http://github.com/bitnami/bitnami-docker-ghost). For more information please refer to the [bitnami/ghost](http://github.com/bitnami/bitnami-docker-ghost) image documentation.

> **Note**:
>
> For the Ghost application function correctly, you should specify the `ghostHost` parameter to specify the FQDN (recommended) or the public IP address of the Ghost service.
>
> Optionally, you can specify the `ghostLoadBalancerIP` parameter to assign a reserved IP address to the Ghost service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create ghost-public-ip
> ```
>
> The reserved IP address can be assigned to the Ghost service by specifying it as the value of the `ghostLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set ghostUsername=admin,ghostPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/ghost
```

The above command sets the Ghost administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml stable/ghost
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Using an existing database

Sometimes you may want to have Ghost connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use run a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. For example using the following parameters:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
```

## Persistence

The [Bitnami Ghost](https://github.com/bitnami/bitnami-docker-ghost) image stores the Ghost data and configurations at the `/bitnami/ghost` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Upgrading

### To 9.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pulls/17297 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 5.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 5.0.0. The following example assumes that the release name is ghost:

```console
$ kubectl patch deployment ghost-ghost --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset ghost-mariadb --cascade=false
```
