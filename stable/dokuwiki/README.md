# DokuWiki

[DokuWiki](https://www.dokuwiki.org) is a standards-compliant, simple to use wiki optimized for creating documentation. It is targeted at developer teams, workgroups, and small companies. All data is stored in plain text files, so no database is required.

## TL;DR;

```console
$ helm install stable/dokuwiki
```

## Introduction

This chart bootstraps a [DokuWiki](https://github.com/bitnami/bitnami-docker-dokuwiki) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/dokuwiki
```

The command deploys DokuWiki on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the DokuWiki chart and their default values.

|              Parameter               |               Description                                  |                   Default                     |
|--------------------------------------|------------------------------------------------------------|-----------------------------------------------|
| `global.imageRegistry`               | Global Docker image registry                               | `nil`                                         |
| `image.registry`                     | DokuWiki image registry                                    | `docker.io`                                   |
| `image.repository`                   | DokuWiki image name                                        | `bitnami/dokuwiki`                            |
| `image.tag`                          | DokuWiki image tag                                         | `{VERSION}`                                   |
| `image.pullPolicy`                   | Image pull policy                                          | `Always`                                      |
| `image.pullSecrets`                  | Specify image pull secrets                                 | `nil`                                         |
| `dokuwikiUsername`                   | User of the application                                    | `user`                                        |
| `dokuwikiFullName`                   | User's full name                                           | `User Name`                                   |
| `dokuwikiPassword`                   | Application password                                       | _random 10 character alphanumeric string_     |
| `dokuwikiEmail`                      | User email                                                 | `user@example.com`                            |
| `dokuwikiWikiName`                   | Wiki name                                                  | `My Wiki`                                     |
| `service.loadBalancer`               | Kubernetes LoadBalancerIP to request                       | `nil`                                         |
| `service.externalTrafficPolicy`      | Enable client source IP preservation                       | `Cluster`                                     |
| `service.nodePorts.http`             | Kubernetes http node port                                  | `""`                                          |
| `service.nodePorts.https`            | Kubernetes https node port                                 | `""`                                          |
| `ingress.enabled`                    | Enable ingress controller resource                         | `false`                                       |
| `ingress.hosts[0].name`              | Hostname to your DokuWiki installation                     | `dokuwiki.local`                              |
| `ingress.hosts[0].path`              | Path within the url structure                              | `/`                                           |
| `ingress.hosts[0].tls`               | Utilize TLS backend in ingress                             | `false`                                       |
| `ingress.hosts[0].certManager`       | Add annotations for cert-manager                           | `false`                                       |
| `ingress.hosts[0].tlsSecret`         | TLS Secret (certificates)                                  | `dokuwiki.local-tls`                          |
| `ingress.hosts[0].annotations`       | Annotations for this host's ingress record                 | `[]`                                          |
| `ingress.secrets[0].name`            | TLS Secret Name                                            | `nil`                                         |
| `ingress.secrets[0].certificate`     | TLS Secret Certificate                                     | `nil`                                         |
| `ingress.secrets[0].key`             | TLS Secret Key                                             | `nil`                                         |
| `persistence.enabled`                | Enable persistence using PVC                               | `true`                                        |
| `persistence.apache.storageClass`    | PVC Storage Class for apache volume                        | `nil` (uses alpha storage class annotation)   |
| `persistence.apache.accessMode`      | PVC Access Mode for apache volume                          | `ReadWriteOnce`                               |
| `persistence.apache.size`            | PVC Storage Request for apache volume                      | `1Gi`                                         |
| `persistence.dokuwiki.storageClass`  | PVC Storage Class for DokuWiki volume                      | `nil` (uses alpha storage class annotation)   |
| `persistence.dokuwiki.accessMode`    | PVC Access Mode for DokuWiki volume                        | `ReadWriteOnce`                               |
| `persistence.dokuwiki.size`          | PVC Storage Request for DokuWiki volume                    | `8Gi`                                         |
| `resources`                          | CPU/Memory resource requests/limits                        |  Memory: `512Mi`, CPU: `300m`                 |
| `livenessProbe.enabled`              | Enable/disable the liveness probe                          | `true`                                        |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                   | 120                                           |
| `livenessProbe.periodSeconds`        | How often to perform the probe                             | 10                                            |
| `livenessProbe.timeoutSeconds`       | When the probe times out                                   | 5                                             |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures to be considered failed       | 6                                             |
| `livenessProbe.successThreshold`     | Minimum consecutive successes to be considered successful  | 1                                             |
| `readinessProbe.enabled`             | Enable/disable the readiness probe                         | `true`                                        |
| `readinessProbe.initialDelaySeconds` | Delay before readinessProbe is initiated                   | 30                                            |
| `readinessProbe.periodSeconds   `    | How often to perform the probe                             | 10                                            |
| `readinessProbe.timeoutSeconds`      | When the probe times out                                   | 5                                             |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures to be considered failed       | 6                                             |
| `readinessProbe.successThreshold`    | Minimum consecutive successes to be considered successful  | 1                                             |
| `nodeSelector`                       | Node labels for pod assignment                             | `{}`                                          |
| `affinity`                           | Affinity settings for pod assignment                       | `{}`                                          |
| `tolerations`                        | Toleration labels for pod assignment                       | `[]`                                          |

The above parameters map to the env variables defined in [bitnami/dokuwiki](http://github.com/bitnami/bitnami-docker-dokuwiki). For more information please refer to the [bitnami/dokuwiki](http://github.com/bitnami/bitnami-docker-dokuwiki) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set dokuwikiUsername=admin,dokuwikiPassword=password \
    stable/dokuwiki
```

The above command sets the DokuWiki administrator account username and password to `admin` and `password` respectively.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/dokuwiki
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Bitnami DokuWiki](https://github.com/bitnami/bitnami-docker-dokuwiki) image stores the DokuWiki data and configurations at the `/bitnami/dokuwiki` and `/bitnami/apache` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Upgrading

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 3.0.0. The following example assumes that the release name is dokuwiki:

```console
$ kubectl patch deployment dokuwiki-dokuwiki --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
```
