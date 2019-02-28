# Piwigo
This is a helm chart for [Piwigo][piwigo]

## TL;DR;
```console
helm install --set server_name=matrix.example.org incubator/piwigo
```

## Installing the Chart
To install the chart with the release name `my-release`:

```console
helm install --name my-release incubator/piwigo
```

## Uninstalling the Chart
To uninstall/delete the `my-release` deployment:

```console
helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration
The following tables lists the configurable parameters of the Piwigo chart and their default values.

Note that the database user and password options _only_ apply directly to the user that MariaDB creates automatically.  Piwigo has an install procedure it goes through the first time it's visited in a web browser.

| Parameter                          | Description                                                                                                      | Default                           |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `image.repository`                 | Image repository                                                                                                 | `mathieuruellan/piwigo`           |
| `image.tag`                        | Image tag. Possible values listed [here][docker].                                                                | `release-2.9.4`                   |
| `image.pullPolicy`                 | Image pull policy                                                                                                | `IfNotPresent`                    |
| `replicaCount`                     | Number of replicas to deploy                                                                                     | `1`                               |
| `extraLabels`                      | Additional labels to apply to all created resources                                                              | `{}`                              |
| `mariadb.deploy`                   | Whether or not to deploy `stable/mariadb` as a subchart                                                          | `false`                           |
| `mariadb.nameOverride`             | Override for MariaDB subchart artifacts' names                                                                   | `db`                              |
| `mariadb.existingSecret`           | Name of secret to pass to MariaDB for user creation; this is deployed as part of this chart                      | `piwigo-db`                       |
| `mariadb.replication.enabled`      | Whether or not to deploy a MariaDB cluster                                                                       | `false`                           |
| `mariadb.db.user`                  | Name of user to automatically create in MariaDB                                                                  | `piwigo`                          |
| `mariadb.db.password`              | Password for automatically-created user in MariaDB                                                               | 16 random alphanumeric characters |
| `mariadb`                          | There are many other options for [the Mariadb subchart][mariadb-chart]                                           |                                   |
| `database.storage_engine`          | Which storage engine to use for creating the database tables.  Only applies during the installation procedure.   | `MyISAM`                          |
| `service.annotations`              | Annotations for Service resource                                                                                 | `{}`                              |
| `service.type`                     | Type of service to deploy                                                                                        | `ClusterIP`                       |
| `service.clusterIP`                | ClusterIP of service; if blank, it will be selected at random from the cluster CIDR range                        | `""`                              |
| `service.port`                     | Port to expose service                                                                                           | `80`                              |
| `service.externalIPs`              | External IPs for service                                                                                         | `[]`                              |
| `service.loadBalancerIP`           | Load balancer IP                                                                                                 | `""`                              |
| `service.loadBalancerSourceRanges` | List of IP CIDRs allowed to access the load balancer (if supported)                                              | `[]`                              |
| `ingress.enabled`                  | Whether or not to deploy the Ingress resource                                                                    | `false`                           |
| `ingress.class`                    | Ingress class (included in annotations)                                                                          | ``                                |
| `ingress.annotations`              | Ingress annotations                                                                                              | `{}`                              |
| `ingress.path`                     | Ingress path                                                                                                     | `/`                               |
| `ingress.hosts`                    | Ingress accepted hostnames                                                                                       | `[piwigo]`                        |
| `ingress.tls`                      | Ingress TLS configuration                                                                                        | `[]`                              |
| `persistence.galleries`            | Optional VolumeSpec to inject; if not specified, will simply be deployed as a subdirectory in `persistence.data` | `{}`                              |
| `persistence.data.enabled`         | Use persistent volume to store data                                                                              | `true`                            |
| `persistence.data.size`            | Size of persistent volume claim                                                                                  | `256Gi`                           |
| `persistence.data.existingClaim`   | Use an existing PVC to persist data                                                                              | ``                                |
| `persistence.data.storageClass`    | Type of persistent volume claim                                                                                  | ``                                |
| `persistence.data.accessMode`      | PVC access mode                                                                                                  | `ReadWriteMany`                   |
| `persistence.config.enabled`       | Use persistent volume to store config                                                                            | `true`                            |
| `persistence.config.size`          | Size of persistent volume claim                                                                                  | `4Gi`                             |
| `persistence.config.existingClaim` | Use an existing PVC to persist config                                                                            | ``                                |
| `persistence.config.storageClass`  | Type of persistent volume claim                                                                                  | ``                                |
| `persistence.config.accessMode`    | PVC access mode                                                                                                  | `ReadWriteMany`                   |
| `resources`                        | CPU/Memory resource requests/limits                                                                              | `{}`                              |
| `nodeSelector`                     | Node labels for pod assignment                                                                                   | `{}`                              |
| `tolerations`                      | Toleration labels for pod assignment                                                                             | `[]`                              |
| `affinity`                         | Affinity settings for pod assignment                                                                             | `{}`                              |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install --name my-release \
	--set server_name="matrix.example.com" \
	--set ingress.enabled=true \
	incubator/piwigo
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install --name my-release -f values.yaml incubator/piwigo
```

Read through the [values.yaml](values.yaml) file.

[docker]: https://hub.docker.com/r/mathieuruellan/piwigo
[github]: https://github.com/Piwigo/Piwigo
[piwigo]: https://piwigo.org/
[mariadb-docker]: https://hub.docker.com/r/bitnami/mariadb
[mariadb-chart]: https://github.com/helm/charts/tree/master/stable/mariadb

