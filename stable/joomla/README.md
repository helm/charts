# Joomla!

[Joomla!](http://www.joomla.org/) is a PHP content management system (CMS) for publishing web content. It includes features such as page caching, RSS feeds, printable versions of pages, news flashes, blogs, search, and support for language international.

## TL;DR;

```console
$ helm install stable/joomla
```

## Introduction

This chart bootstraps a [Joomla!](https://github.com/bitnami/bitnami-docker-joomla) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which bootstraps a MariaDB deployment required by the Joomla! application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/joomla
```

The command deploys Joomla! on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Joomla! chart and their default values.

| Parameter                            | Description                                                 | Default                                        |
| ------------------------------------ | ----------------------------------------------------------- | ---------------------------------------------- |
| `global.imageRegistry`               | Global Docker image registry                                | `nil`                                          |
| `global.imagePullSecrets`            | Global Docker registry secret names as an array             | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`                     | Joomla! image registry                                      | `docker.io`                                    |
| `image.repository`                   | Joomla! Image name                                          | `bitnami/joomla`                               |
| `image.tag`                          | Joomla! Image tag                                           | `{TAG_NAME}`                                   |
| `image.pullPolicy`                   | Image pull policy                                           | `Always`                                       |
| `image.pullSecrets`                  | Specify docker-registry secret names as an array            | `[]` (does not add image pull secrets to deployed pods) |
| `joomlaUsername`                     | User of the application                                     | `user`                                         |
| `joomlaPassword`                     | Application password                                        | _random 10 character long alphanumeric string_ |
| `joomlaEmail`                        | Admin email                                                 | `user@example.com`                             |
| `smtpHost`                           | SMTP host                                                   | `nil`                                          |
| `smtpPort`                           | SMTP port                                                   | `nil`                                          |
| `smtpUser`                           | SMTP user                                                   | `nil`                                          |
| `smtpPassword`                       | SMTP password                                               | `nil`                                          |
| `smtpUsername`                       | User name for SMTP emails                                   | `nil`                                          |
| `smtpProtocol`                       | SMTP protocol [`tls`, `ssl`]                                | `nil`                                          |
| `allowEmptyPassword`                 | Allow DB blank passwords                                    | `yes`                                          |
| `externalDatabase.host`              | Host of the external database                               | `nil`                                          |
| `externalDatabase.port`              | Port of the external database                               | `3306`                                         |
| `externalDatabase.user`              | Existing username in the external db                        | `bn_joomla`                                    |
| `externalDatabase.password`          | Password for the above username                             | `nil`                                          |
| `externalDatabase.database`          | Name of the existing database                               | `bitnami_joomla`                               |
| `mariadb.enabled`                    | Whether to use the MariaDB chart                            | `true`                                         |
| `mariadb.replication.enabled`        | Whether to use MariaDB master and slave                     | `false`                                        |
| `mariadb.db.name`                    | Database name to create                                     | `bitnami_joomla`                               |
| `mariadb.db.user`                    | Database user to create                                     | `bn_joomla`                                    |
| `mariadb.db.password`                | Password for the database                                   | `nil`                                          |
| `mariadb.root.password`              | MariaDB admin password                                      | `nil`                                          |
| `service.type`                       | Kubernetes Service type                                     | `LoadBalancer`                                 |
| `service.port`                       | Service HTTP port                                           | `80`                                           |
| `service.httpsPort`                  | Service HTTPS port                                          | `443`                                          |
| `service.loadBalancer`               | Kubernetes LoadBalancerIP to request                        | `nil`                                          |
| `service.externalTrafficPolicy`      | Enable client source IP preservation                        | `Cluster`                                      |
| `service.nodePorts.http`             | Kubernetes http node port                                   | `""`                                           |
| `service.nodePorts.https`            | Kubernetes https node port                                  | `""`                                           |
| `ingress.enabled`                    | Enable ingress controller resource                          | `false`                                        |
| `ingress.hosts[0].name`              | Hostname to your Joomla! installation                       | `joomla.local`                                 |
| `ingress.hosts[0].path`              | Path within the url structure                               | `/`                                            |
| `ingress.hosts[0].tls`               | Utilize TLS backend in ingress                              | `false`                                        |
| `ingress.hosts[0].certManager `      | Add annotations for cert-manager                            | `false`                                        |
| `ingress.hosts[0].tlsSecret`         | TLS Secret (certificates)                                   | `joomla.local-tls-secret`                      |
| `ingress.hosts[0].annotations`       | Annotations for this host's ingress record                  | `[]`                                           |
| `ingress.secrets[0].name`            | TLS Secret Name                                             | `nil`                                          |
| `ingress.secrets[0].certificate`     | TLS Secret Certificate                                      | `nil`                                          |
| `ingress.secrets[0].key`             | TLS Secret Key                                              | `nil`                                          |
| `persistence.enabled`                | Enable persistence using PVC                                | `true`                                         |
| `persistence.apache.storageClass`    | PVC Storage Class for Apache volume                         | `nil` (uses alpha storage annotation)          |
| `persistence.apache.accessMode`      | PVC Access Mode for Apache volume                           | `ReadWriteOnce`                                |
| `persistence.apache.size`            | PVC Storage Request for Apache volume                       | `1Gi`                                          |
| `persistence.joomla.storageClass`    | PVC Storage Class for Joomla! volume                        | `nil` (uses alpha storage annotation)          |
| `persistence.joomla.accessMode`      | PVC Access Mode for Joomla! volume                          | `ReadWriteOnce`                                |
| `persistence.joomla.size`            | PVC Storage Request for Joomla! volume                      | `8Gi`                                          |
| `resources`                          | CPU/Memory resource requests/limits                         | Memory: `512Mi`, CPU: `300m`                   |
| `livenessProbe.enabled`              | Enable/disable the liveness probe                           | `true`                                         |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                    | 120                                            |
| `livenessProbe.periodSeconds`        | How often to perform the probe                              | 10                                             |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                    | 5                                              |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures to be considered failed        | 6                                              |
| `livenessProbe.successThreshold`     | Minimum consecutive successes to be considered successful   | 1                                              |
| `readinessProbe.enabled`             | Enable/disable the readiness probe                          | `true`                                         |
| `readinessProbe.initialDelaySeconds` | Delay before readinessProbe is initiated                    | 30                                             |
| `readinessProbe.periodSeconds   `    | How often to perform the probe                              | 10                                             |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                    | 5                                              |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures to be considered failed        | 6                                              |
| `readinessProbe.successThreshold`    | Minimum consecutive successes to be considered successful   | 1                                              |
| `nodeSelector`                       | Node labels for pod assignment                              | `{}`                                           |
| `tolerations`                        | List of node taints to tolerate                             | `[]`                                           |
| `affinity`                           | Map of node/pod affinities                                  | `{}`                                           |
| `podAnnotations`                     | Pod annotations                                             | `{}`                                           |
| `metrics.enabled`                    | Start a side-car prometheus exporter                        | `false`                                        |
| `metrics.image.registry`             | Apache exporter image registry                              | `docker.io`                                    |
| `metrics.image.repository`           | Apache exporter image name                                  | `lusotycoon/apache-exporter`                   |
| `metrics.image.tag`                  | Apache exporter image tag                                   | `v0.5.0`                                       |
| `metrics.image.pullPolicy`           | Image pull policy                                           | `IfNotPresent`                                 |
| `metrics.image.pullSecrets`          | Specify docker-registry secret names as an array            | `[]` (does not add image pull secrets to deployed    |
| `metrics.podAnnotations`             | Additional annotations for Metrics exporter pod             | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources`                  | Exporter resource requests/limit                            | {}                                              |

The above parameters map to the env variables defined in [bitnami/joomla](http://github.com/bitnami/bitnami-docker-joomla). For more information please refer to the [bitnami/joomla](http://github.com/bitnami/bitnami-docker-joomla) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set joomlaUsername=admin,joomlaPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/joomla
```

The above command sets the Joomla! administrator account username and password to `admin` and `password` respectively. Additionally it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/joomla
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Persistence

The [Bitnami Joomla!](https://github.com/bitnami/bitnami-docker-joomla) image stores the Joomla! data and configurations at the `/bitnami/joomla` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is opencart:

```console
$ kubectl patch deployment joomla-joomla --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset joomla-mariadb --cascade=false
```
