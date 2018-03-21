# Jaeger

[Jaeger](http://jaeger.readthedocs.io/en/latest/) is a distributed tracing system.

## Introduction

This chart adds all components required to run Jaeger as described in the [jaeger-kubernetes](https://github.com/jaegertracing/jaeger-kubernetes) GitHub page for a production-like deployment. The chart default will deploy a new Cassandra cluster (using the [cassandra chart](https://github.com/kubernetes/charts/tree/master/incubator/cassandra)), but also supports using an existing Cassandra cluster, deploying a new ElasticSearch cluster (using the [elasticsearch chart](https://github.com/kubernetes/charts/tree/master/incubator/elasticsearch)), or connecting to an existing ElasticSearch cluster. Once the back storage available, the chart will deploy jaeger-agent as a DaemonSet and deploy the jaeger-collector and jaeger-query components as standard individual deployments.

## Prerequisites

- Has been tested on Kubernetes 1.7+
  - The `spark` cron job requires [K8s CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) support: 
    > You need a working Kubernetes cluster at version >= 1.8 (for CronJob). For previous versions of cluster (< 1.8) you need to explicitly enable `batch/v2alpha1` API by passing `--runtime-config=batch/v2alpha1=true` to the API server ([see Turn on or off an API version for your cluster for more](https://kubernetes.io/docs/admin/cluster-management/#turn-on-or-off-an-api-version-for-your-cluster)).

- The Cassandra chart calls out the following requirements (default) for a test environment (please see the important note in the installation section):
```
resources:
  requests:
    memory: 4Gi
    cpu: 2
  limits:
    memory: 4Gi
    cpu: 2
```
- The Cassandra chart calls out the following requirements for a production environment:
```
resources:
  requests:
    memory: 8Gi
    cpu: 2
  limits:
    memory: 8Gi
    cpu: 2
```

- The ElasticSearch chart calls out the following requirements for a production environment:
```
client:
  ...
  resources:
    limits:
      cpu: "1"
      # memory: "1024Mi"
    requests:
      cpu: "25m"
      memory: "512Mi"

master:
  ...
  resources:
    limits:
      cpu: "1"
      # memory: "1024Mi"
    requests:
      cpu: "25m"
      memory: "512Mi"

data:
  ...
  resources:
    limits:
      cpu: "1"
      # memory: "2048Mi"
    requests:
      cpu: "25m"
      memory: "1536Mi"
```

## Installing the Chart

To install the chart with the release name `myrel`, run the following command:

```bash
$ helm install incubator/jaeger --name myrel
```

After a few minutes, you should see a 3 node Cassandra instance, a Jaeger DaemonSet, a Jaeger Collector, and a Jaeger Query (UI) pod deployed into your Kubernetes cluster.

IMPORTANT NOTE: For testing purposes, the footprint for Cassandra can be reduced significantly in the event resources become constrained (such as running on your local laptop or in a Vagrant environment). You can override the resources required run running this command:

```bash
helm install incubator/jaeger --name myrel --set cassandra.config.max_heap_size=1024M --set cassandra.config.heap_new_size=256M --set cassandra.resources.requests.memory=2048Mi --set cassandra.resources.requests.cpu=0.4 --set cassandra.resources.limits.memory=2048Mi --set cassandra.resources.limits.cpu=0.4
```

> **Tip**: List all releases using `helm list`

## Installing the Chart using an Existing Cassandra Cluster

If you already have an existing running Cassandra cluster, you can configure the chart as follows to use it as your backing store (make sure you replace `<HOST>`, `<PORT>`, etc with your values):

```bash
helm install incubator/jaeger --name myrel --set provisionDataStore.cassandra=false --set storage.cassandra.host=<HOST> --set storage.cassandra.port=<PORT> --set storage.cassandra.user=<USER> --set storage.cassandra.password=<PASSWORD> 
```

> **Tip**: It is highly encouraged to run the Cassandra cluster with storage persistence.

## Installing the Chart using a New ElasticSearch Cluster

To install the chart with the release name `myrel` using a new ElasticSearch cluster instead of Cassandra (default), run the following command:

```bash
$ helm install incubator/jaeger --name myrel --set provisionDataStore.cassandra=false  --set provisionDataStore.elasticsearch=true
```

After a few minutes, you should see 2 ElasticSearch client nodes, 2 ElasticSearch data nodes, 3 ElasticSearch master nodes, a Jaeger DaemonSet, a Jaeger Collector, and a Jaeger Query (UI) pod deployed into your Kubernetes cluster.

> **Tip**: If the ElasticSearch client nodes do not enter the running state, try --set elasticsearch.rbac.create=true

## Installing the Chart using an Existing ElasticSearch Cluster

If you already have an existing running ElasticSearch cluster, you can configure the chart as follows to use it as your backing store:

```bash
helm install incubator/jaeger --name myrel --set provisionDataStore.cassandra=false --set provisionDataStore.elasticsearch=true --set storage.type=elasticsearch --set storage.elasticsearch.host=<HOST> --set storage.elasticsearch.port=<PORT> --set storage.elasticsearch.user=<USER> --set storage.elasticsearch.password=<password>
```

> **Tip**: It is highly encouraged to run the ElasticSearch cluster with storage persistence.


## Uninstalling the Chart

To uninstall/delete the `myrel` deployment:

```bash
$ helm delete myrel
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Tip**: To completely remove the release, run `helm delete --purge myrel`

## Configuration

The following table lists the configurable parameters of the Jaeger chart and their default values.

|             Parameter                    |            Description              |                  Default               |
|------------------------------------------|-------------------------------------|----------------------------------------|
| `agent.annotationsPod`                   | Annotations for Agent               |  nil                                   |
| `agent.annotationsSvc`                   | Annotations for Agent SVC           |  nil                                   |
| `agent.binaryPort`                       | jaeger.thrift over binary thrift    |  6832                                  |
| `agent.cmdlineParams`                    | Additional command line parameters  |  nil                                   |
| `agent.compactPort`                      | jaeger.thrift over compact thrift   |  6831                                  |
| `agent.image`                            | Image for Jaeger Agent              |  jaegertracing/jaeger-agent            |
| `agent.pullPolicy`                       | Agent image pullPolicy              |  IfNotPresent                          |
| `agent.tag`                              | Image tag/version                   |  0.6                                   |
| `agent.zipkinThriftPort`                 | zipkin.thrift over compact thrift   |  5775                                  |
| `cassandra.config.cluster_name`          | Cluster name                        |  jaeger                                |
| `cassandra.config.dc_name`               | Datacenter name                     |  dc1                                   |
| `cassandra.config.endpoint_snitch`       | Node discovery method               |  GossipingPropertyFileSnitch           |
| `cassandra.config.rack_name`             | Rack name                           |  rack1                                 |
| `cassandra.config.seed_size`             | Seed size                           |  1                                     |
| `cassandra.image.tag`                    | The image tag/version               |  3.11                                  |
| `cassandra.persistence.enabled`          | To enable storage persistence       |  false (Highly recommended to enable)  |
| `collector.annotationsPod`               | Annotations for Collector           |  nil                                   |
| `collector.annotationsSvc`               | Annotations for Collector SVC       |  nil                                   |
| `collector.cmdlineParams`                | Additional command line parameters  |  nil                                   |
| `collector.httpPort`                     | Client port for HTTP thrift         |  14268                                 |
| `collector.image`                        | Image for jaeger collector          |  jaegertracing/jaeger-collector        |
| `collector.pullPolicy`                   | Collector image pullPolicy          |  IfNotPresent                          |
| `collector.tag`                          | Image tag/version                   |  0.6                                   |
| `collector.tchannelPort`                 | Jaeger Agent port for thrift        |  14267                                 |
| `collector.type`                         | Service type                        |  ClusterIP                             |
| `collector.zipkinPort`                   | Zipkin port for JSON/thrift HTTP    |  9411                                  |
| `elasticsearch.cluster.name`             | Elasticsearch cluster name          |  "tracing"                             |
| `elasticsearch.data.persistence.enabled` | To enable storage persistence       |  false (Highly recommended to enable)  |
| `elasticsearch.image.tag`                | Elasticsearch image tag             |  "5.4"                                 |
| `elasticsearch.rbac.create`              | To enable RBAC                      |  false                                 |
| `hotrod.enabled`                         | Enables the Hotrod demo app         |  false                                 |
| `provisionDataStore.cassandra`           | Provision Cassandra Data Store      |  true                                  |
| `provisionDataStore.elasticsearch`       | Provision Elasticsearch Data Store  |  false                                 |
| `query.annotationsPod`                   | Annotations for Query UI            |  nil                                   |
| `query.annotationsSvc`                   | Annotations for Query SVC           |  nil                                   |
| `query.cmdlineParams`                    | Additional command line parameters  |  nil                                   |
| `query.image`                            | Image for Jaeger Query UI           |  jaegertracing/jaeger-query            |
| `query.ingress.enabled`                  | Allow external traffic access       |  false                                 |
| `query.pullPolicy`                       | Query UI image pullPolicy           |  IfNotPresent                          |
| `query.queryPort`                        | External accessible port            |  80                                    |
| `query.tag`                              | Image tag/version                   |  0.6                                   |
| `query.targetPort`                       | Internal Query UI port              |  16686                                 |
| `query.type`                             | Service type                        |  ClusterIP                             |
| `schema.annotations`                     | Annotations for the schema job      |  nil                                   |
| `schema.image`                           | Image to setup cassandra schema     |  jaegertracing/jaeger-cassandra-schema |
| `schema.mode`                            | Schema mode (prod or test)          |  prod                                  |
| `schema.pullPolicy`                      | Schema image pullPolicy             |  IfNotPresent                          |
| `schema.tag`                             | Image tag/version                   |  0.6                                   |
| `spark.enabled`                          | Enables the dependencies job        |  false                                 |
| `spark.image`                            | Image for the dependencies job      |  jaegertracing/spark-dependencies      |
| `spark.pullPolicy`                       | Image pull policy of the deps image |  Always                                |
| `spark.schedule`                         | Schedule of the cron job            |  "49 23 * * *"                         |
| `spark.successfulJobsHistoryLimit`       | Cron job successfulJobsHistoryLimit |  5                                     |
| `spark.failedJobsHistoryLimit`           | Cron job failedJobsHistoryLimit     |  5                                     |
| `spark.tag`                              | Tag of the dependencies job image   |  latest                                |
| `storage.cassandra.host`                 | Provisioned cassandra host          |  cassandra                             |
| `storage.cassandra.password`             | Provisioned cassandra password      |  password                              |
| `storage.cassandra.port`                 | Provisioned cassandra port          |  9042                                  |
| `storage.cassandra.user`                 | Provisioned cassandra username      |  user                                  |
| `storage.elasticsearch.host`             | Provisioned elasticsearch host      |  elasticsearch                         |
| `storage.elasticsearch.password`         | Provisioned elasticsearch password  |  changeme                              |
| `storage.elasticsearch.port`             | Provisioned elasticsearch port      |  9200                                  |
| `storage.elasticsearch.scheme`           | Provisioned elasticsearch scheme    |  http                                  |
| `storage.elasticsearch.user`             | Provisioned elasticsearch user      |  elastic                               |
| `storage.type`                           | Storage type (ES or Cassandra)      |  cassandra                             |
|------------------------------------------|-------------------------------------|----------------------------------------|

For more information about some of the tunable parameters that Cassandra provides, please visit the helm chart for [cassandra](https://github.com/kubernetes/charts/tree/master/incubator/cassandra) and the official [website](http://cassandra.apache.org/) at apache.org.

For more information about some of the tunable parameters that Jaeger provides, please visit the official [Jaeger repo](https://github.com/uber/jaeger) at GitHub.com.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name myrel \
    --set cassandra.config.rack_name=rack2 \
    incubator/jaeger
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart.

### Storage persistence

Jaeger itself is a stateful application that by default uses Cassandra to store all related data. That means this helm chart has a dependency on the Cassandra helm chart for its data persistence. To deploy Jaeger with storage persistence, please take a look at the [README.md](https://github.com/kubernetes/charts/tree/master/incubator/cassandra) for configuration details.

Override any required configuration options in the Cassandra chart that is required and then enable persistence by setting the following option: `--set cassandra.persistence.enabled=true`

### Image tags

Jaeger offers a multitude of [tags](https://hub.docker.com/u/jaegertracing/) for the various components used in this chart.

### Pending enhancements
- [x] Use ConfigMap for configurable parameters
- [x] Add the Hotrod example app
- [x] Allow only some of the components to be installed
- [x] Add support for the spark dependencies job (as a [k8s cronjob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)) 
- [x] Use `provisionDataStore` key in the values.yaml file instead of `tags` to configure data store provisioning.
- [x] Refactor chart to remove unnecessary quotes
- [x] Remove the command overrides of the docker images and use [environment variables configuration](http://jaeger.readthedocs.io/en/latest/deployment/#configuration) instead
- [x] Fix hard-coded replica count
- [x] Collector service works both as `NodePort` and `ClusterIP` service types
- [ ] Sidecar deployment support
