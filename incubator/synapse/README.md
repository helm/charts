# Synapse
This is a helm chart for [Synapse][github], the reference implementation for a [Matrix][matrix] chat server.

## TL;DR;
```console
helm install --set server_name=matrix.example.org incubator/synapse
```

## Installing the Chart
To install the chart with the release name `my-release`:

```console
helm install --name my-release incubator/synapse
```

## Uninstalling the Chart
To uninstall/delete the `my-release` deployment:

```console
helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration
The following tables lists the configurable parameters of the Synapse chart and their default values.

| Parameter                                      | Description                                                                                                            | Default                           |
| ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `server_name`                                  | Public hostname of the server                                                                                          | Required                          |
| `image.repository`                             | Image repository                                                                                                       | `matrixdotorg/synapse`            |
| `image.tag`                                    | Image tag. Possible values listed [here][docker].                                                                      | `v0.99.1rc1-py3`                  |
| `image.pullPolicy`                             | Image pull policy                                                                                                      | `IfNotPresent`                    |
| `extraLabels`                                  | Additional labels to apply to all created resources                                                                    | `{}`                              |
| `settings.uid`                                 | Run the server as user UID                                                                                             | `991`                             |
| `settings.git`                                 | Run the server as group GID                                                                                            | `991`                             |
| `settings.report_stats`                        | Whether or not to report anonymous usage stats to Matrix (`yes` or `no`)                                               | `yes`                             |
| `settings.tls.enabled`                         | Whether or not the server should expose TLS                                                                            | `false`                           |
| `settings.tls.acme`                            | If TLS is enabled, whether or not the server should use ACME to retrieve TLS certs                                     | `true`                            |
| `settings.registration.enabled`                | Whether or not to allow new users to register                                                                          | `true`                            |
| `settings.guest`                               | Whether or not to allow guests to enter the server                                                                     | `false`                           |
| `settings.event_cache_size`                    | The event cache size                                                                                                   | `"10K"`                           |
| `settings.recaptcha.enabled`                   | Whether or not to require users to pass a ReCAPTCHA challenge when registering                                         | `false`                           |
| `settings.recaptcha.secret.name_override`      | Override for the name of the ReCAPTCHA secret                                                                          | ``                                |
| `settings.recaptcha.secret.deploy.enabled`     | Whether or not to deploy the ReCAPTCHA secret as part of the chart                                                     | `true`                            |
| `settings.recaptcha.secret.deploy.public_key`  | Public key for ReCAPTCHA (required if `settings.recaptcha.secret.deploy.enabled` is set to `true`)                     | ``                                |
| `settings.recaptcha.secret.deploy.private_key` | Private key for ReCAPTCHA (required if `settings.recaptcha.secret.deploy.enabled` is set to `true`)                    | ``                                |
| `settings.turn.uris`                           | Comma-separated list of TURN URIs to enable TURN on this server                                                        | `[]`                              |
| `settings.turn.secret.name_override`           | Override for the name of the TURN secret                                                                               | ``                                |
| `settings.turn.secret.deploy.enabled`          | Whether or not to deploy the TURN secret as part of the chart                                                          | `true`                            |
| `settings.turn.secret.deploy.value`            | The TURN shared secret, if enabled (required if `settings.turn.secret.deploy.enabled` is set to `true`)                | ``                                |
| `settings.max_upload_size`                     | Maximum size, in bytes, of files uploaded to the server                                                                | `"10M"`                           |
| `postgresql.deploy`                            | Whether or not to deploy `stable/postgresql` as a subchart                                                             | `false`                           |
| `postgresql.client.image.repository`           | Image repository for PostgreSQL client container                                                                       | `postgres`                        |
| `postgresql.client.image.tag`                  | Image tag for PostgreSQL client container. Possible values listed [here][postgres-docker].                             | `11.2-alpine`                     |
| `postgresql.client.image.pullPolicy`           | Image pull policy fpr PostgreSQL client contianer                                                                      | `IfNotPresent`                    |
| `postgresql.nameOverride`                      | Override for Postgres subchart artifacts' names                                                                        | `db`                              |
| `postgresql`                                   | There are many other options for [the Postgres subchart][postgres-chart]                                               |                                   |
| `database.mode`                                | Which database type to run; valid options are `sqlite` and `postgres`                                                  | `sqlite`                          |
| `database.secret.name_override`                | Override for the name of the secret containing database credentials                                                    | ``                                |
| `database.secret.deploy.enabled`               | Whether or not to deploy the database secret as part of the chart                                                      | `true`                            |
| `database.secret.deploy.username`              | If deploying the database secret, use this username                                                                    | `synapse`                         |
| `database.secret.deploy.password`              | If deploying the database secret, use this password                                                                    | 16 random alphanmueric characters |
| `database.host`                                | IP or hostname for database access; if in Postgres mode and `postgresql.deploy` is set to `false`, this is required    |                                   |
| `database.port`                                | Port for database access                                                                                               | `5432`                            |
| `database.name`                                | Name of database to access                                                                                             | `synapse`                         |
| `service.annotations`                          | Annotations for Service resource                                                                                       | `{}`                              |
| `service.type`                                 | Type of service to deploy                                                                                              | `ClusterIP`                       |
| `service.clusterIP`                            | ClusterIP of service; if blank, it will be selected at random from the cluster CIDR range                              | `""`                              |
| `service.port`                                 | Port to expose service                                                                                                 | `8008`                            |
| `service.externalIPs`                          | External IPs for service                                                                                               | `[]`                              |
| `service.loadBalancerIP`                       | Load balancer IP                                                                                                       | `""`                              |
| `service.loadBalancerSourceRanges`             | List of IP CIDRs allowed to access the load balancer (if supported)                                                    | `[]`                              |
| `ingress.enabled`                              | Whether or not to deploy the Ingress resource                                                                          | `false`                           |
| `ingress.class`                                | Ingress class (included in annotations)                                                                                | ``                                |
| `ingress.annotations`                          | Ingress annotations                                                                                                    | `{}`                              |
| `ingress.path`                                 | Ingress path                                                                                                           | `/`                               |
| `ingress.hosts`                                | Ingress accepted hostnames                                                                                             | `[synapse]`                       |
| `ingress.tls`                                  | Ingress TLS configuration                                                                                              | `[]`                              |
| `persistence.data.enabled`                     | Use persistent volume to store data                                                                                    | `true`                            |
| `persistence.data.size`                        | Size of persistent volume claim                                                                                        | `8Gi`                             |
| `persistence.data.existingClaim`               | Use an existing PVC to persist data                                                                                    | ``                                |
| `persistence.data.storageClass`                | Type of persistent volume claim                                                                                        | ``                                |
| `persistence.data.accessMode`                  | PVC access mode                                                                                                        | `[]`                              |
| `resources`                                    | CPU/Memory resource requests/limits                                                                                    | `{}`                              |
| `nodeSelector`                                 | Node labels for pod assignment                                                                                         | `{}`                              |
| `tolerations`                                  | Toleration labels for pod assignment                                                                                   | `[]`                              |
| `affinity`                                     | Affinity settings for pod assignment                                                                                   | `{}`                              |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install --name my-release \
	--set server_name="matrix.example.com" \
	--set ingress.enabled=true \
	incubator/synapse
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install --name my-release -f values.yaml incubator/synapse
```

Read through the [values.yaml](values.yaml) file.

[docker]: https://hub.docker.com/r/matrixdotorg/synapse
[github]: https://github.com/matrix-org/synapse
[matrix]: https://matrix.org/blog/home/
[postgres-docker]: https://hub.docker.com/r/bitnami/postgresql
[postgres-chart]: https://github.com/helm/charts/tree/master/stable/postgresql

