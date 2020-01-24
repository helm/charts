# Elastalert Helm Chart

[elastalert](https://github.com/Yelp/elastalert) is a simple framework for alerting on anomalies, spikes, or other patterns of interest from data in Elasticsearch.

## TL;DR;

For ES 5.x:

```console
$ helm install stable/elastalert
```

For ES 6 and newer:

```console
$ helm install stable/elastalert --set writebackIndex=elastalert

# Open Dev Tools on Kibana and send the below.
# Otherwise elastalert ends up with errors like "RequestError: TransportError(400, u'search_phase_execution_exception', u'No mapping found for [alert_time] in order to sort on')"
PUT /elastalert/_mapping/elastalert
{
  "properties": {
      "alert_time": {"type": "date"}
  }
}
```

See the comment in the default `values.yaml` to know why `writebackIndex` is required for ES 6.x.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/elastalert
```

The command deploys elastalert on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

| Parameter                         | Description                                                                                | Default                         |
|-----------------------------------|--------------------------------------------------------------------------------------------|---------------------------------|
| `image.repository`                | docker image                                                                               | jertel/elastalert-docker        |
| `image.tag`                       | docker image tag                                                                           | 0.2.1                           |
| `image.pullPolicy`                | image pull policy                                                                          | IfNotPresent                    |
| `podAnnotations`                  | Annotations to be added to pods                                                            | {}                              |
| `command`                         | command override for container                                                             | `NULL`                          |
| `args`                            | args override for container                                                                | `NULL`                          |
| `replicaCount`                    | number of replicas to run                                                                  | 1                               |
| `elasticsearch.host`              | elasticsearch endpoint to use                                                              | elasticsearch                   |
| `elasticsearch.port`              | elasticsearch port to use                                                                  | 80                              |
| `elasticsearch.useSsl`            | whether or not to connect to es_host using SSL                                             | False                           |
| `elasticsearch.username`          | Username for ES with basic auth                                                            | `NULL`                          |
| `elasticsearch.password`          | Password for ES with basic auth                                                            | `NULL`                          |
| `elasticsearch.verifyCerts`       | whether or not to verify TLS certificates                                                  | True                            |
| `elasticsearch.clientCert`        | path to a PEM certificate to use as the client certificate                                 | /certs/client.pem               |
| `elasticsearch.clientKey`         | path to a private key file to use as the client key                                        | /certs/client-key.pem           |
| `elasticsearch.caCerts`           | path to a CA cert bundle to use to verify SSL connections                                  | /certs/ca.pem                   |
| `elasticsearch.certsVolumes`      | certs volumes, required to mount ssl certificates when elasticsearch has tls enabled       | `NULL`                          |
| `elasticsearch.certsVolumeMounts` | mount certs volumes, required to mount ssl certificates when elasticsearch has tls enabled | `NULL`                          |
| `extraConfigOptions`              | Additional options to propagate to all rules, cannot be `alert`, `type`, `name` or `index` | `{}`                            |
| `optEnv`                          | Additional pod environment variable definitions                                            | []                              |
| `extraVolumes`                    | Additional volume definitions                                                              | []                              |
| `extraVolumeMounts`               | Additional volumeMount definitions                                                         | []                              |
| `resources`                       | Container resource requests and limits                                                     | {}                              |
| `rules`                           | Rule and alert configuration for Elastalert                                                | {} example shown in values.yaml |
| `runIntervalMins`                 | Default interval between alert checks, in minutes                                          | 1                               |
| `realertIntervalMins`             | Time between alarms for same rule, in minutes                                              | `NULL`                          |
| `alertRetryLimitMins`             | Time to retry failed alert deliveries, in minutes                                          | 2880 (2 days)                   |
| `bufferTimeMins`                  | Default rule buffer time, in minutes                                                       | 15                              |
| `writebackIndex`                  | Name or prefix of elastalert index(es)                                                     | elastalert_status               |
| `nodeSelector`                    | Node selector for deployment                                                               | {}                              |
| `tolerations`                     | Tolerations for deployment                                                                 | []                              |
