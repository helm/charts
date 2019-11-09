# Prometheus MongoDB Exporter

Installs the [MongoDB Exporter](https://github.com/percona/mongodb_exporter) for [Prometheus](https://prometheus.io/). The
MongoDB Exporter collects and exports oplog, replica set, server status, sharding and storage engine metrics.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm upgrade --install my-release stable/prometheus-mongodb-exporter
```

This command deploys the MongoDB Exporter with the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Using the Chart

To use the chart, ensure the `mongodb.uri` is populated with a valid [MongoDB URI](https://docs.mongodb.com/manual/reference/connection-string).
If the MongoDB server requires authentication, credentials should be populated in the connection string as well. The MongoDB Exporter supports
connecting to either a MongoDB replica set member, shard, or standalone instance.

The chart comes with a ServiceMonitor for use with the [Prometheus Operator](https://github.com/helm/charts/tree/master/stable/prometheus-operator).
If you're not using the Prometheus Operator, you can disable the ServiceMonitor by setting `serviceMonitor.enabled` to `false` and instead
populate the `podAnnotations` as below:

```yaml
podAnnotations:
  prometheus.io/scrape: "true"
  prometheus.io/port: "metrics"
```

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `affinity` | Node/pod affinities | `{}` |
| `annotations` | Annotations to be added to the pods | `{}` |
| `extraArgs` | The extra command line arguments to pass to the MongoDB Exporter  | See values.yaml |
| `fullnameOverride` | Override the full chart name | `` |
| `image.pullPolicy` | MongoDB Exporter image pull policy | `IfNotPresent` |
| `image.repository` | MongoDB Exporter image name | `ssheehy/mongodb-exporter` |
| `image.tag` | MongoDB Exporter image tag | `0.7.0` |
| `imagePullSecrets` | List of container registry secrets | `[]` |
| `mongodb.uri` | The required [URI](https://docs.mongodb.com/manual/reference/connection-string) to connect to MongoDB | `` |
| `nameOverride` | Override the application name  | `` |
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `podAnnotations` | Annotations to be added to all pods | `{}` |
| `port` | The container port to listen on | `9216` |
| `priorityClassName` | Pod priority class name | `` |
| `replicas` | Number of replicas in the replica set | `1` |
| `resources` | Pod resource requests and limits | `{}` |
| `env` | Extra environment variables passed to pod | `{}` |
| `securityContext` | Security context for the pod | See values.yaml |
| `service.annotations` | Annotations to be added to the service | `{}` |
| `service.port` | The port to expose | `9216` |
| `service.type` | The type of service to expose | `ClusterIP` |
| `serviceAccount.create` | If `true`, create the service account | `true` |
| `serviceAccount.name` | Name of the service account | `` |
| `serviceMonitor.enabled` | Set to true if using the Prometheus Operator | `true` |
| `serviceMonitor.interval` | Interval at which metrics should be scraped | `30s` |
| `serviceMonitor.scrapeTimeout` | Interval at which metric scrapes should time out | `10s` |
| `serviceMonitor.namespace` | The namespace where the Prometheus Operator is deployed | `` |
| `serviceMonitor.additionalLabels` | Additional labels to add to the ServiceMonitor | `{}` |
| `tolerations` | List of node taints to tolerate  | `[]` |

## Limitations

Connecting to MongoDB via TLS is currently not supported.

