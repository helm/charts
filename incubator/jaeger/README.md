# Jaeger

[Jaeger](http://jaeger.readthedocs.io/en/latest/) is a distributed tracing system.

## Introduction

This chart adds all components required to run Jaeger as described in the [jaeger-kubernetes](https://github.com/jaegertracing/jaeger-kubernetes) GitHub page for a production-like deployment. The chart default will deploy a new Cassandra cluster, but also supports using an existing Cassandra cluster, deploying a new ElasticSearch cluster, or connecting to an existing ElasticSearch cluster. Once the back storage available, the chart will deploy jaeger-agent as a DaemonSet and deploy the jaeger-collector and jaeger-query components as standard individual deployments.

## Prerequisites

- Has been tested on Kubernetes 1.7+
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
$ helm install --name myrel
```

After a few minutes, you should see a 3 node Cassandra instance, a Jaeger DaemonSet, a Jaeger Collector, and a Jaeger Query (UI) pod deployed into your Kubernetes cluster.

IMPORTANT NOTE: For testing purposes, the footprint for Cassandra can be reduced significantly in the event resources become constrained (such as running on your local laptop or in a Vagrant environment). You can override the resources required run running this command:

```bash
helm install incubator/jaeger --name myrel --set cassandra.config.max_heap_size=1024M --set cassandra.config.heap_new_size=256M --set cassandra.resources.requests.memory=2048Mi --set cassandra.resources.requests.cpu=0.4 --set cassandra.resources.limits.memory=2048Mi --set cassandra.resources.limits.cpu=0.4
```

> **Tip**: List all releases using `helm list`

## Installing the Chart using an Existing Cassandra Cluster

If you already have an existing running Cassandra cluster, you can configure the chart as follows to use it as your backing store (replace `cassandra` with whatever hostname the cluster has been configured with):

```bash
helm install incubator/jaeger --name myrel --set tags.cassandra=false --set tags.elasticsearch=false --set cassandra.config.host=cassandra
```

> **Tip**: It is highly encouraged to run the Cassandra cluster with storage persistence.

## Installing the Chart using a New ElasticSearch Cluster

To install the chart with the release name `myrel` using a new ElasticSearch cluster instead of Cassandra (default), run the following command:

```bash
$ helm install incubator/jaeger --name myrel --set tags.cassandra=false --set tags.elasticsearch=true
```

After a few minutes, you should see 2 ElasticSearch client nodes, 2 ElasticSearch data nodes, 3 ElasticSearch master nodes, a Jaeger DaemonSet, a Jaeger Collector, and a Jaeger Query (UI) pod deployed into your Kubernetes cluster.

> **Tip**: If the ElasticSearch client nodes do not enter the running state, try --set elasticsearch.rbac.create=true

## Installing the Chart using an Existing ElasticSearch Cluster

If you already have an existing running ElasticSearch cluster, you can configure the chart as follows to use it as your backing store (replace `http://elasticsearch:9200` with whatever hostname the cluster has been configured with):

```bash
helm install incubator/jaeger --name myrel --set tags.cassandra=false --set tags.elasticsearch=false --set elasticsearch.config.host=http://elasticsearch:9200
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

The following tables lists the configurable parameters of the Jaeger chart and their default values.

|             Parameter             |            Description             |                  Default               |
|-----------------------------------|------------------------------------|----------------------------------------|
| `cassandra.image.tag`             | The image tag/version              |  3.11                                  |
| `cassandra.persistence.enabled`   | To enable storage persistence      |  false (Highly recommended to enable)  |
| `cassandra.config.host`           | Existing Cassandra hostname        |  ""                                    |
| `cassandra.config.cluster_name`   | Cluster name                       |  jaeger                                |
| `cassandra.config.seed_size`      | Seed size                          |  1                                     |
| `cassandra.config.dc_name`        | Datacenter name                    |  dc1                                   |
| `cassandra.config.rack_name`      | Rack name                          |  rack1                                 |
| `cassandra.config.endpoint_snitch`| Node discovery method              |  GossipingPropertyFileSnitch           |
| `elasticsearch.config.host`       | Existing ElasticSearch hostname    |  ""                                    |
| `elasticsearch.config.username`   | Existing ElasticSearch username    |  "elastic"                             |
| `elasticsearch.config.password`   | Existing ElasticSearch password    |  "changeme"                            |
| `schema.annotations`              | Annotations for the schema job     |  nil                                   |
| `schema.image`                    | Image to setup cassandra schema    |  jaegertracing/jaeger-cassandra-schema |
| `schema.tag`                      | Image tag/version                  |  0.6                                   |
| `schema.pullPolicy`               | Schema image pullPolicy            |  IfNotPresent                          |
| `schema.mode`                     | Schema mode (prod or test)         |  prod                                  |
| `agent.annotationsPod`            | Annotations for Agent              |  nil                                   |
| `agent.image`                     | Image for Jaeger Agent             |  jaegertracing/jaeger-agent            |
| `agent.tag`                       | Image tag/version                  |  0.6                                   |
| `agent.pullPolicy`                | Agent image pullPolicy             |  IfNotPresent                          |
| `agent.cmdlineParams`             | Additional command line parameters |  nil                                   |
| `agent.annotationsSvc`            | Annotations for Agent SVC          |  nil                                   |
| `agent.zipkinThriftPort`          | zipkin.thrift over compact thrift  |  5775                                  |
| `agent.compactPort`               | jaeger.thrift over compact thrift  |  6831                                  |
| `agent.binaryPort`                | jaeger.thrift over binary thrift   |  6832                                  |
| `collector.annotationsPod`        | Annotations for Collector          |  nil                                   |
| `collector.image`                 | Image for jaeger collector         |  jaegertracing/jaeger-collector        |
| `collector.tag`                   | Image tag/version                  |  0.6                                   |
| `collector.pullPolicy`            | Collector image pullPolicy         |  IfNotPresent                          |
| `collector.cmdlineParams`         | Additional command line parameters |  nil                                   |
| `collector.annotationsSvc`        | Annotations for Collector SVC      |  nil                                   |
| `collector.type`                  | Service type                       |  ClusterIP                             |
| `collector.tchannelPort`          | Jaeger Agent port for thrift       |  14267                                 |
| `collector.httpPort`              | Client port for HTTP thrift        |  14268                                 |
| `collector.zipkinPort`            | Zipkin port for JSON/thrift HTTP   |  9411                                  |
| `query.annotationsPod`            | Annotations for Query UI           |  nil                                   |
| `query.image`                     | Image for Jaeger Query UI          |  jaegertracing/jaeger-query            |
| `query.tag`                       | Image tag/version                  |  0.6                                   |
| `query.pullPolicy`                | Query UI image pullPolicy          |  IfNotPresent                          |
| `query.cmdlineParams`             | Additional command line parameters |  nil                                   |
| `query.annotationsSvc`            | Annotations for Query SVC          |  nil                                   |
| `query.type`                      | Service type                       |  ClusterIP                             |
| `query.queryPort`                 | External accessible port           |  80                                    |
| `query.targetPort`                | Internal Query UI port             |  16686                                 |
| `ingress.enabled`                 | Allow external traffic access      |  false                                 |
|-----------------------------------|------------------------------------|----------------------------------------|

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
- Moving configurable parameters to use ConfigMap
- Sidecar deployment support
