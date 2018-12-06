# SuiteCRM

[SuiteCRM](https://www.suitecrm.com) is a completely open source enterprise-grade Customer Relationship Management (CRM) application. SuiteCRM is a software fork of the popular customer relationship management (CRM) system SugarCRM.

## TL;DR;

```console
$ helm install stable/suitecrm
```

## Introduction

This chart bootstraps a [SuiteCRM](https://github.com/bitnami/bitnami-docker-suitecrm) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the SuiteCRM application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.5+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/suitecrm
```

The command deploys SuiteCRM on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the SuiteCRM chart and their default values.

|              Parameter              |                   Description                   |                         Default                         |
|-------------------------------------|-------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`              | Global Docker image registry                    | `nil`                                                   |
| `image.registry`                    | SuiteCRM image registry                         | `docker.io`                                             |
| `image.repository`                  | SuiteCRM image name                             | `bitnami/suitecrm`                                      |
| `image.tag`                         | SuiteCRM image tag                              | `{VERSION}`                                             |
| `image.pullPolicy`                  | Image pull policy                               | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `image.pullSecrets`                 | Specify image pull secrets                      | `nil`                                                   |
| `suitecrmHost`                      | SuiteCRM host to create application URLs        | `nil`                                                   |
| `suitecrmUsername`                  | User of the application                         | `user`                                                  |
| `suitecrmPassword`                  | Application password                            | _random 10 character alphanumeric string_               |
| `suitecrmEmail`                     | Admin email                                     | `user@example.com`                                      |
| `suitecrmLastName`                  | Last name                                       | `Last`                                                  |
| `suitecrmSmtpHost`                  | SMTP host                                       | `nil`                                                   |
| `suitecrmSmtpPort`                  | SMTP port                                       | `nil`                                                   |
| `suitecrmSmtpUser`                  | SMTP user                                       | `nil`                                                   |
| `suitecrmSmtpPassword`              | SMTP password                                   | `nil`                                                   |
| `suitecrmSmtpProtocol`              | SMTP protocol [`ssl`, `tls`]                    | `nil`                                                   |
| `suitecrmValidateUserIP`            | Whether to validate the user IP address or not  | `no`                                                    |
| `allowEmptyPassword`                | Allow DB blank passwords                        | `yes`                                                   |
| `externalDatabase.host`             | Host of the external database                   | `nil`                                                   |
| `externalDatabase.port`             | Port of the external database                   | `3306`                                                  |
| `externalDatabase.user`             | Existing username in the external db            | `bn_suitecrm`                                           |
| `externalDatabase.password`         | Password for the above username                 | `nil`                                                   |
| `externalDatabase.database`         | Name of the existing database                   | `bitnami_suitecrm`                                      |
| `mariadb.enabled`                   | Whether to use the MariaDB chart                | `true`                                                  |
| `mariadb.db.name`                   | Database name to create                         | `bitnami_suitecrm`                                      |
| `mariadb.db.user`                   | Database user to create                         | `bn_suitecrm`                                           |
| `mariadb.db.password`               | Password for the database                       | `nil`                                                   |
| `mariadb.rootUser.password`         | MariaDB admin password                          | `nil`                                                   |
| `service.type`                    | Kubernetes Service type                    | `LoadBalancer`                                          |
| `service.port`                    | Service HTTP port                  | `80`                                          |
| `service.httpsPort`                    | Service HTTPS port                   | `443`                                          |
| `service.nodePorts.http`                 | Kubernetes http node port                  | `""`                                                    |
| `service.nodePorts.https`                | Kubernetes https node port                 | `""`                                                    |
| `service.externalTrafficPolicy`   | Enable client source IP preservation       | `Cluster`                                               |
| `service.loadBalancerIP`            | `loadBalancerIP` for the SuiteCRM Service       | `nil`                                                   |
| `persistence.enabled`               | Enable persistence using PVC                    | `true`                                                  |
| `persistence.storageClass`          | PVC Storage Class for SuiteCRM volume           | `nil` (uses alpha storage class annotation)             |
| `persistence.existingClaim`         | An Existing PVC name for SuiteCRM volume        | `nil` (uses alpha storage class annotation)             |
| `persistence.accessMode`            | PVC Access Mode for SuiteCRM volume             | `ReadWriteOnce`                                         |
| `persistence.size`                  | PVC Storage Request for SuiteCRM volume         | `8Gi`                                                   |
| `resources`                         | CPU/Memory resource requests/limits             | Memory: `512Mi`, CPU: `300m`                            |
| `podAnnotations`                | Pod annotations                                   | `{}`                                                       |
| `metrics.enabled`                          | Start a side-car prometheus exporter                                                                           | `false`                                              |
| `metrics.image.registry`                   | Apache exporter image registry                                                                                  | `docker.io`                                          |
| `metrics.image.repository`                 | Apache exporter image name                                                                                      | `lusotycoon/apache-exporter`                           |
| `metrics.image.tag`                        | Apache exporter image tag                                                                                       | `v0.5.0`                                            |
| `metrics.image.pullPolicy`                 | Image pull policy                                                                                              | `IfNotPresent`                                       |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                               | `nil`                                                |
| `metrics.podAnnotations`                   | Additional annotations for Metrics exporter pod                                                                | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}`                                                   |
| `metrics.resources`                        | Exporter resource requests/limit                                                                               | {}                        |

The above parameters map to the env variables defined in [bitnami/suitecrm](http://github.com/bitnami/bitnami-docker-suitecrm). For more information please refer to the [bitnami/suitecrm](http://github.com/bitnami/bitnami-docker-suitecrm) image documentation.

> **Note**:
>
> For SuiteCRM to function correctly, you should specify the `suitecrmHost` parameter to specify the FQDN (recommended) or the public IP address of the SuiteCRM service.
>
> Optionally, you can specify the `suitecrmLoadBalancerIP` parameter to assign a reserved IP address to the SuiteCRM service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create suitecrm-public-ip
> ```
>
> The reserved IP address can be associated to the SuiteCRM service by specifying it as the value of the `suitecrmLoadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set suitecrmUsername=admin,suitecrmPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/suitecrm
```

The above command sets the SuiteCRM administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/suitecrm
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami SuiteCRM](https://github.com/bitnami/bitnami-docker-suitecrm) image stores the SuiteCRM data and configurations at the `/bitnami/suitecrm` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is suitecrm:

```console
$ kubectl patch deployment suitecrm-suitecrm --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset suitecrm-mariadb --cascade=false
```
