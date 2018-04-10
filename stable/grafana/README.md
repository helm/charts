# Grafana Helm Chart

* Installs the web dashboarding system [Grafana](http://grafana.org/)

## TL;DR;

```console
$ helm install stable/grafana
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/grafana
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


## Configuration


| Parameter                  | Description                         | Default                                                 |
|----------------------------|-------------------------------------|---------------------------------------------------------|
| `replicas`                 | Number of nodes | `1` |
| `image.repository`         | Image repository | `grafana/grafana` |
| `image.tag`                | Image tag. (`Must be >= 5.0.0`) Possible values listed [here](https://hub.docker.com/r/grafana/grafana/tags/).| `5.0.4`|
| `image.pullPolicy`         | Image pull policy | `IfNotPresent` |
| `service.type`             | Kubernetes service type | `ClusterIP` |
| `service.port`             | Kubernetes port where service is exposed| `9000` |
| `service.annotations`      | Service annotations | `80` |
| `ingress.enabled`          | Enables Ingress | `false` |
| `ingress.annotations`      | Ingress annotations | `{}` |
| `ingress.hosts`            | Ingress accepted hostnames | `[]` |
| `ingress.tls`              | Ingress TLS configuration | `[]` |
| `resources`                | CPU/Memory resource requests/limits | `{}` |
| `nodeSelector`             | Node labels for pod assignment | `{}` |
| `tolerations`              | Toleration labels for pod assignment | `[]` |
| `affinity`                 | Affinity settings for pod assignment | `{}` |
| `persistence.enabled`      | Use persistent volume to store data | `false` |
| `persistence.size`         | Size of persistent volume claim | `10Gi` |
| `persistence.existingClaim`| Use an existing PVC to persist data | `nil` |
| `persistence.storageClass` | Type of persistent volume claim | `generic` |
| `persistence.accessModes`  | Persistence access modes | `[]` |
| `persistence.subPath`      | Mount a sub directory of the persistent volume if set | `""` |
| `env`                      | Extra environment variables passed to pods | `{}` |
| `datasource`               | Configure grafana datasources | `{}` |
| `dashboardProviders`       | Configure grafana dashboard providers | `{}` |
| `dashboards`               | Dashboards to import | `{}` |
| `grafana.ini`              | Grafana's primary configuration | `{}` |

