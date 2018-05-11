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


| Parameter                             | Description                         | Default                                                 |
|---------------------------------------|-------------------------------------|---------------------------------------------------------|
| `replicas`                            | Number of nodes | `1` |
| `image.repository`                    | Image repository | `grafana/grafana` |
| `image.tag`                           | Image tag. (`Must be >= 5.0.0`) Possible values listed [here](https://hub.docker.com/r/grafana/grafana/tags/).| `5.0.4`|
| `image.pullPolicy`                    | Image pull policy | `IfNotPresent` |
| `service.type`                        | Kubernetes service type | `ClusterIP` |
| `service.port`                        | Kubernetes port where service is exposed| `9000` |
| `service.annotations`                 | Service annotations | `80` |
| `service.labels`                      | Custom labels                       | `{}`
| `ingress.enabled`                     | Enables Ingress | `false` |
| `ingress.annotations`                 | Ingress annotations | `{}` |
| `ingress.hosts`                       | Ingress accepted hostnames | `[]` |
| `ingress.tls`                         | Ingress TLS configuration | `[]` |
| `resources`                           | CPU/Memory resource requests/limits | `{}` |
| `nodeSelector`                        | Node labels for pod assignment | `{}` |
| `tolerations`                         | Toleration labels for pod assignment | `[]` |
| `affinity`                            | Affinity settings for pod assignment | `{}` |
| `persistence.enabled`                 | Use persistent volume to store data | `false` |
| `persistence.size`                    | Size of persistent volume claim | `10Gi` |
| `persistence.existingClaim`           | Use an existing PVC to persist data | `nil` |
| `persistence.storageClass`            | Type of persistent volume claim | `generic` |
| `persistence.accessModes`             | Persistence access modes | `[]` |
| `persistence.subPath`                 | Mount a sub directory of the persistent volume if set | `""` |
| `env`                                 | Extra environment variables passed to pods | `{}` |
| `datasource`                          | Configure grafana datasources | `{}` |
| `dashboardProviders`                  | Configure grafana dashboard providers | `{}` |
| `dashboards`                          | Dashboards to import | `{}` |
| `grafana.ini`                         | Grafana's primary configuration | `{}` |
| `ldap.existingSecret`                 | The name of an existing secret containing the `ldap.toml` file, this must have the key `ldap-toml`. | `""` |
| `ldap.config  `                       | Grafana's LDAP configuration    | `""` |
| `annotations`                         | Deployment annotations | `{}` |
| `podAnnotations`                      | Pod annotations | `{}` |
| `smtp.existingSecret`                 | The name of an existing secret containing the SMTP credentials, this must have the keys `user` and `password`. | `""` |
| `database.existingSecret`             | The name of an existing secret containing database credentials, this must have the keys `user` and `password | `""` |
| `database.cloudSQL.enabled`           | Use a Google CloudSQL Proxy for database access | `false` |
| `database.cloudSQL.image.repository`  | CloudSQL proxy image repository | `gcr.io/cloudsql-docker/gce-proxy` |
| `database.cloudSQL.image.tag`         | CloudSQL proxy image tag. Possible values listed [here](https://console.cloud.google.com/gcr/images/cloudsql-docker/GLOBAL/gce-proxy?gcrImageListsize=50).| `1.11`|
| `database.cloudSQL.image.pullPolicy`  | CloudSQL proxy image pull policy | `IfNotPresent` |
| `database.cloudSQL.instanceConnectionName`  | CloudSQL database instance connection name | `""` |
| `database.cloudSQL.port`              | CloudSQL proxy listening port | `5432` |
| `database.cloudSQL.existingSecret`    | The name of an existing secret containing CloudSQL database instance credentials, this must have the key `credentials.json` | `""` |
