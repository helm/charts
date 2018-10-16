# Moodle

[Moodle](https://www.moodle.org) is a learning platform designed to provide educators, administrators and learners with a single robust, secure and integrated system to create personalized learning environments

## TL;DR;

```console
$ helm install stable/moodle
```

## Introduction

This chart bootstraps a [Moodle](https://github.com/bitnami/bitnami-docker-moodle) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Moodle application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/moodle
```

The command deploys Moodle on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Moodle chart and their default values.

|              Parameter                |                                       Description                                            |                   Default                               |
|---------------------------------------|----------------------------------------------------------------------------------------------|-------------------------------------------------------- |
| `global.imageRegistry`                | Global Docker image registry                                                                 | `nil`                                                   |
| `image.registry`                      | Moodle image registry                                                                        | `docker.io`                                             |
| `image.repository`                    | Moodle Image name                                                                            | `bitnami/moodle`                                        |
| `image.tag`                           | Moodle Image tag                                                                             | `{VERSION}`                                             |
| `image.pullPolicy`                    | Image pull policy                                                                            | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `image.pullSecrets`                   | Specify image pull secrets                                                                   | `nil`                                                   |
| `moodleUsername`                      | User of the application                                                                      | `user`                                                  |
| `moodlePassword`                      | Application password                                                                         | _random 10 character alphanumeric string_               |
| `moodleEmail`                         | Admin email                                                                                  | `user@example.com`                                      |
| `smtpHost`                            | SMTP host                                                                                    | `nil`                                                   |
| `smtpPort`                            | SMTP port                                                                                    | `nil` (but moodle internal default is 25)               |
| `smtpProtocol`                        | SMTP Protocol (options: ssl,tls, nil)                                                        | `nil`                                                   |
| `smtpUser`                            | SMTP user                                                                                    | `nil`                                                   |
| `smtpPassword`                        | SMTP password                                                                                | `nil`                                                   |
| `serviceType`                         | Kubernetes Service type                                                                      | `LoadBalancer`                                          |
| `ingress.enabled`                     | Enable ingress controller resource                                                           | `false`                                                 |
| `ingress.hosts[0].name`               | Hostname to your Moodle installation                                                         | `moodle.local`                                          |
| `ingress.hosts[0].path`               | Path within the url structure                                                                | `/`                                                     |
| `ingress.hosts[0].tls`                | Utilize TLS backend in ingress                                                               | `false`                                                 |
| `ingress.hosts[0].certManager`        | Add annotations for cert-manager                                                             | `false`                                                 |
| `ingress.hosts[0].tlsSecret`          | TLS Secret (certificates)                                                                    | `moodle.local-tls-secret`                               |
| `ingress.hosts[0].annotations`        | Annotations for this host's ingress record                                                   | `[]`                                                    |
| `ingress.secrets[0].name`             | TLS Secret Name                                                                              | `nil`                                                   |
| `ingress.secrets[0].certificate`      | TLS Secret Certificate                                                                       | `nil`                                                   |
| `ingress.secrets[0].key`              | TLS Secret Key                                                                               | `nil`                                                   |
| `affinity`                            | Set affinity for the moodle pods                                                             | `nil`                                                   |
| `resources`                           | CPU/Memory resource requests/limits                                                          | Memory: `512Mi`, CPU: `300m`                            |
| `persistence.enabled`                 | Enable persistence using PVC                                                                 | `true`                                                  |
| `persistence.storageClass`            | PVC Storage Class for Moodle volume                                                          | `nil` (uses alpha storage class annotation)             |
| `persistence.accessMode`              | PVC Access Mode for Moodle volume                                                            | `ReadWriteOnce`                                         |
| `persistence.size`                    | PVC Storage Request for Moodle volume                                                        | `8Gi`                                                   |
| `persistence.existingClaim`           | If PVC exists&bounded for Moodle                                                             | `nil` (when nil, new one is requested)                  |
| `allowEmptyPassword`                  | Allow DB blank passwords                                                                     | `yes`                                                   |
| `externalDatabase.host`               | Host of the external database                                                                | `nil`                                                   |
| `externalDatabase.port`               | Port of the external database                                                                | `3306`                                                  |
| `externalDatabase.user`               | Existing username in the external db                                                         | `bn_moodle`                                             |
| `externalDatabase.password`           | Password for the above username                                                              | `nil`                                                   |
| `externalDatabase.database`           | Name of the existing database                                                                | `bitnami_moodle`                                        |
| `mariadb.enabled`                     | Whether to install the MariaDB chart                                                         | `true`                                                  |
| `mariadb.db.name`                     | Database name to create                                                                      | `bitnami_moodle`                                        |
| `mariadb.db.user`                     | Database user to create                                                                      | `bn_moodle`                                             |
| `mariadb.db.password`                 | Password for the database                                                                    | `nil`                                                   |
| `mariadb.rootUser.password`           | MariaDB admin password                                                                       | `nil`                                                   |
| `mariadb.persistence.enabled`         | Enable MariaDB persistence using PVC                                                         | `true`                                                  |
| `mariadb.persistence.storageClass`    | PVC Storage Class for MariaDB volume                                                         | `generic`                                               |
| `mariadb.persistence.accessMode`      | PVC Access Mode for MariaDB volume                                                           | `ReadWriteOnce`                                         |
| `mariadb.persistence.size`            | PVC Storage Request for MariaDB volume                                                       | `8Gi`                                                   |
| `mariadb.persistence.existingClaim`   | If PVC exists&bounded for MariaDB                                                            | `nil` (when nil, new one is requested)                  |
| `mariadb.affinity`                    | Set affinity for the MariaDB pods                                                            | `nil`                                                   |
| `mariadb.resources`                   | CPU/Memory resource requests/limits                                                          | Memory: `256Mi`, CPU: `250m`                            |
| `livenessProbe.initialDelaySeconds`   | Delay before liveness probe is initiated                                                     | 600                                                     |
| `livenessProbe.periodSeconds`         | How often to perform the probe                                                               | 3                                                       |
| `livenessProbe.timeoutSeconds`        | When the probe times out                                                                     | 5                                                       |
| `livenessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | 6                                                       |
| `livenessProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed. | 1                                                       |
| `readinessProbe.initialDelaySeconds`  | Delay before readiness probe is initiated                                                    | 30                                                      |
| `readinessProbe.periodSeconds`        | How often to perform the probe                                                               | 3                                                       |
| `readinessProbe.timeoutSeconds`       | When the probe times out                                                                     | 5                                                       |
| `readinessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | 6                                                       |
| `readinessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed. | 1                                                       |

The above parameters map to the env variables defined in [bitnami/moodle](http://github.com/bitnami/bitnami-docker-moodle). For more information please refer to the [bitnami/moodle](http://github.com/bitnami/bitnami-docker-moodle) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set moodleUsername=admin,moodlePassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/moodle
```

The above command sets the Moodle administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/moodle
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Ingress without TLS

For using ingress (example without TLS):

```console
$ helm install --name my-release \
  --set ingress.enabled=True,ingress.hosts[0]=moodle.domain.com,serviceType=ClusterIP,moodleUsername=admin,moodlePassword=password,mariadb.mariadbRootPassword=secretpassword stable/moodle
```

These are the *3 mandatory parameters* when *Ingress* is desired:
`ingress.enabled=True,ingress.hosts[0]=moodle.domain.com,serviceType=ClusterIP`

### Ingress TLS

If your cluster allows automatic creation/retrieval of TLS certificates (e.g. [kube-lego](https://github.com/jetstack/kube-lego)), please refer to the documentation for that mechanism.

To manually configure TLS, first create/retrieve a key & certificate pair for the address(es) you wish to protect. Then create a TLS secret in the namespace:

```console
$ kubectl create secret tls moodle-server-tls --cert=path/to/tls.cert --key=path/to/tls.key
```

Include the secret's name, along with the desired hostnames, in the Ingress TLS section of your custom `values.yaml` file:

```console
ingress:
  ## If true, Moodle server Ingress will be created
  ##
  enabled: true

  ## Moodle server Ingress annotations
  ##
  annotations: {}
  #   kubernetes.io/ingress.class: nginx
  #   kubernetes.io/tls-acme: 'true'

  ## Moodle server Ingress hostnames
  ## Must be provided if Ingress is enabled
  ##
  hosts:
    - moodle.domain.com

  ## Moodle server Ingress TLS configuration
  ## Secrets must be manually created in the namespace
  ##
  tls:
    - secretName: moodle-server-tls
      hosts:
        - moodle.domain.com
```

## Persistence

The [Bitnami Moodle](https://github.com/bitnami/bitnami-docker-moodle) image stores the Moodle data and configurations at the `/bitnami/moodle` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, vpshere, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.
You may want to review the [PV reclaim policy](https://kubernetes.io/docs/tasks/administer-cluster/change-pv-reclaim-policy/) and update as required. By default, it's set to delete, and when Moodle is uninstalled, data is also removed.

## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is moodle:

```console
$ kubectl patch deployment moodle-moodle --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset moodle-mariadb --cascade=false
```
