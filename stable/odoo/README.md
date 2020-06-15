# Odoo

[Odoo](https://www.odoo.com/) is a suite of web-based open source business apps. The main Odoo Apps include an Open Source CRM, Website Builder, eCommerce, Project Management, Billing & Accounting, Point of Sale, Human Resources, Marketing, Manufacturing, Purchase Management, ...

Odoo Apps can be used as stand-alone applications, but they also integrate seamlessly so you get a full-featured Open Source ERP when you install several Apps.

## This Helm chart is deprecated

Given the [`stable` deprecation timeline](https://github.com/helm/charts#deprecation-timeline), the Bitnami maintained Odoo Helm chart is now located at [bitnami/charts](https://github.com/bitnami/charts/).

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
$ helm install my-release stable/odoo
```

## Introduction

This chart bootstraps a [Odoo](https://github.com/bitnami/bitnami-docker-odoo) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release stable/odoo
```

The command deploys Odoo on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the Odoo chart and their default values.

| Parameter                             | Description                                               | Default                                                 |
|---------------------------------------|-----------------------------------------------------------|---------------------------------------------------------|
| `global.imageRegistry`                | Global Docker image registry                              | `nil`                                                   |
| `global.imagePullSecrets`             | Global Docker registry secret names as an array           | `[]` (does not add image pull secrets to deployed pods) |
| `global.storageClass`                     | Global storage class for dynamic provisioning                                               | `nil`                                                        |
| `image.registry`                      | Odoo image registry                                       | `docker.io`                                             |
| `image.repository`                    | Odoo Image name                                           | `bitnami/odoo`                                          |
| `image.tag`                           | Odoo Image tag                                            | `{TAG_NAME}`                                            |
| `image.pullPolicy`                    | Image pull policy                                         | `Always`                                                |
| `image.pullSecrets`                   | Specify docker-registry secret names as an array          | `[]` (does not add image pull secrets to deployed pods) |
| `nameOverride`                        | String to partially override odoo.fullname template with a string (will prepend the release name) | `nil`           |
| `fullnameOverride`                    | String to fully override odoo.fullname template with a string                                     | `nil`           |
| `odooUsername`                        | User of the application                                   | `user@example.com`                                      |
| `odooPassword`                        | Admin account password                                    | _random 10 character long alphanumeric string_          |
| `odooEmail`                           | Admin account email                                       | `user@example.com`                                      |
| `smtpHost`                            | SMTP host                                                 | `nil`                                                   |
| `smtpPort`                            | SMTP port                                                 | `nil`                                                   |
| `smtpUser`                            | SMTP user                                                 | `nil`                                                   |
| `smtpPassword`                        | SMTP password                                             | `nil`                                                   |
| `smtpProtocol`                        | SMTP protocol [`ssl`, `tls`]                              | `nil`                                                   |
| `service.type`                        | Kubernetes Service type                                   | `LoadBalancer`                                          |
| `service.port`                        | Service HTTP port                                         | `80`                                                    |
| `service.loadBalancer`                | Kubernetes LoadBalancerIP to request                      | `nil`                                                   |
| `service.externalTrafficPolicy`       | Enable client source IP preservation                      | `Cluster`                                               |
| `service.nodePort`                    | Kubernetes http node port                                 | `""`                                                    |
| `externalDatabase.host`               | Host of the external database                             | `localhost`                                             |
| `externalDatabase.user`               | Existing username in the external db                      | `postgres`                                              |
| `externalDatabase.password`           | Password for the above username                           | `nil`                                                   |
| `externalDatabase.database`           | Name of the existing database                             | `bitnami_odoo`                                          |
| `externalDatabase.port`               | Database port number                                      | `5432`                                                  |
| `ingress.enabled`                     | Enable ingress controller resource                        | `false`                                                 |
| `ingress.certManager`                 | Add annotations for cert-manager                          | `false`                                                 |
| `ingress.annotations`                 | Annotations for the ingress                               | `[]`                                                    |
| `ingress.hosts[0].name`               | Hostname to your Odoo installation                        | `odoo.local`                                            |
| `ingress.hosts[0].path`               | Path within the url structure                             | `/`                                                     |
| `ingress.hosts[0].tls`                | Utilize TLS backend in ingress                            | `false`                                                 |
| `ingress.hosts[0].tlsSecret`          | TLS Secret (certificates)                                 | `odoo.local-tls-secret`                                 |
| `ingress.secrets[0].name`             | TLS Secret Name                                           | `nil`                                                   |
| `ingress.secrets[0].certificate`      | TLS Secret Certificate                                    | `nil`                                                   |
| `ingress.secrets[0].key`              | TLS Secret Key                                            | `nil`                                                   |
| `resources`                           | CPU/Memory resource requests/limits                       | Memory: `512Mi`, CPU: `300m`                            |
| `persistence.enabled`                 | Enable persistence using PVC                              | `true`                                                  |
| `persistence.existingClaim`           | Enable persistence using an existing PVC                  | `nil`                                                   |
| `persistence.storageClass`            | PVC Storage Class                                         | `nil` (uses alpha storage class annotation)             |
| `persistence.accessMode`              | PVC Access Mode                                           | `ReadWriteOnce`                                         |
| `persistence.size`                    | PVC Storage Request                                       | `8Gi`                                                   |
| `postgresql.enabled`                  | Deploy PostgreSQL container(s)                            | `true`                                                  |
| `postgresql.postgresqlPassword`       | PostgreSQL password                                       | `nil`                                                   |
| `postgresql.persistence.enabled`      | Enable PostgreSQL persistence using PVC                   | `true`                                                  |
| `postgresql.persistence.storageClass` | PVC Storage Class for PostgreSQL volume                   | `nil` (uses alpha storage class annotation)             |
| `postgresql.persistence.accessMode`   | PVC Access Mode for PostgreSQL volume                     | `ReadWriteOnce`                                         |
| `postgresql.persistence.size`         | PVC Storage Request for PostgreSQL volume                 | `8Gi`                                                   |
| `livenessProbe.enabled`               | Enable/disable the liveness probe                         | `true`                                                  |
| `livenessProbe.initialDelaySeconds`   | Delay before liveness probe is initiated                  | 300                                                     |
| `livenessProbe.periodSeconds`         | How often to perform the probe                            | 30                                                      |
| `livenessProbe.timeoutSeconds`        | When the probe times out                                  | 5                                                       |
| `livenessProbe.failureThreshold`      | Minimum consecutive failures to be considered failed      | 6                                                       |
| `livenessProbe.successThreshold`      | Minimum consecutive successes to be considered successful | 1                                                       |
| `readinessProbe.enabled`              | Enable/disable the readiness probe                        | `true`                                                  |
| `readinessProbe.initialDelaySeconds`  | Delay before readinessProbe is initiated                  | 30                                                      |
| `readinessProbe.periodSeconds   `     | How often to perform the probe                            | 10                                                      |
| `readinessProbe.timeoutSeconds`       | When the probe times out                                  | 5                                                       |
| `readinessProbe.failureThreshold`     | Minimum consecutive failures to be considered failed      | 6                                                       |
| `readinessProbe.successThreshold`     | Minimum consecutive successes to be considered successful | 1                                                       |
| `affinity`                            | Map of node/pod affinities                                | `{}`                                                    |

The above parameters map to the env variables defined in [bitnami/odoo](http://github.com/bitnami/bitnami-docker-odoo). For more information please refer to the [bitnami/odoo](http://github.com/bitnami/bitnami-docker-odoo) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set odooPassword=password,postgresql.postgresPassword=secretpassword \
    stable/odoo
```

The above command sets the Odoo administrator account password to `password` and the PostgreSQL `postgres` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml stable/odoo
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Using an external database

Sometimes you may want to have Odoo connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#parameters). You should also disable the PostgreSQL installation with the `postgresql.enabled` option. For example using the following parameters:

```console
postgresql.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.port=3306
```

Note also if you disable PostgreSQL per above you MUST supply values for the `externalDatabase` connection.

## Persistence

The [Bitnami Odoo](https://github.com/bitnami/bitnami-docker-odoo) image stores the Odoo data and configurations at the `/bitnami/odoo` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Upgrading

### To 12.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pull/17352 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is odoo:

```console
$ kubectl patch deployment odoo-odoo --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl patch deployment odoo-postgresql --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
