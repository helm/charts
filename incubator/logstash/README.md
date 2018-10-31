# Logstash

**Note - this chart has been deprecated and [moved to stable](../../stable/logstash)**.

[Logstash](https://www.elastic.co/products/logstash) is an open source, server-side data processing pipeline that ingests data from a multitude of sources simultaneously, transforms it, and then sends it to your favorite “stash.”

## TL;DR;

```console
$ helm install incubator/logstash
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/logstash
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes nearly all the Kubernetes components associated with the
chart and deletes the release.

## Best Practices

### Release and tune this chart once per Logstash pipeline

To achieve multiple pipelines with this chart, current best practice is to
maintain one pipeline per chart release. In this way configuration is
simplified and pipelines are more isolated from one another.

### Default Pipeline: Beats Input -> Elasticsearch Output

Current best practice for ELK logging is to ship logs from hosts using Filebeat
to logstash where persistent queues are enabled. Filebeat supports structured
(e.g. JSON) and unstructured (e.g. log lines) log shipment.

### Load Beats-generated index template into Elasticsearch

To best utilize the combination of Beats, Logstash and Elasticsearch,
load Beats-generated index templates into Elasticsearch as described [here](
https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-template.html).

On a remote-to-Kubernetes Linux instance you might run the following command to
load that instance's Beats-generated index template into Elasticsearch
(Elasticsearch hostname will vary).

```
filebeat setup --template -E output.logstash.enabled=false \
  -E 'output.elasticsearch.hosts=["elasticsearch.cluster.local:9200"]'
```

### Links

Please review the following links that expound on current best practices.

- https://www.elastic.co/blog/structured-logging-filebeat
- https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-template.html
- https://www.elastic.co/guide/en/logstash/current/deploying-and-scaling.html
- https://www.elastic.co/guide/en/logstash/current/persistent-queues.html

## Configuration

The following table lists the configurable parameters of the chart and its default values.

|              Parameter      |                    Description                     |                     Default                      |
| --------------------------- | -------------------------------------------------- | ------------------------------------------------ |
| `replicaCount`                  | Number of replicas                                 | `1`                                              |
| `podDisruptionBudget`           | Pod disruption budget                              | `maxUnavailable: 1`                              |
| `updateStrategy`                | Update strategy                                    | `type: RollingUpdate`                            |
| `image.repository`              | Container image name                               | `docker.elastic.co/logstash/logstash-oss`        |
| `image.tag`                     | Container image tag                                | `6.4.2`                                          |
| `image.pullPolicy`              | Container image pull policy                        | `IfNotPresent`                                   |
| `service.type`                  | Service type (ClusterIP, NodePort or LoadBalancer) | `ClusterIP`                                      |
| `service.annotations`           | Service annotations                                | `{}`                                             |
| `service.ports`                 | Ports exposed by service                           | beats                                            |
| `service.loadBalancerIP`        | The load balancer IP for the service               | unset                                            |
| `service.clusterIP`             | The cluster IP for the service                     | unset                                            |
| `ports`                         | Ports exposed by logstash container                | beats                                            |
| `ingress.enabled`               | Enables Ingress                                    | `false`                                          |
| `ingress.annotations`           | Ingress annotations                                | `{}`                                             |
| `ingress.path`                  | Ingress path                                       | `/`                                              |
| `ingress.hosts`                 | Ingress accepted hostnames                         | `["logstash.cluster.local"]`                     |
| `ingress.tls`                   | Ingress TLS configuration                          | `[]`                                             |
| `resources`                     | Pod resource requests & limits                     | `{}`                                             |
| `nodeSelector`                  | Node selector                                      | `{}`                                             |
| `tolerations`                   | Tolerations                                        | `[]`                                             |
| `affinity`                      | Affinity or Anti-Affinity                          | `{}`                                             |
| `podAnnotations`                | Pod annotations                                    | `{}`                                             |
| `podLabels`                     | Pod labels                                         | `{}`                                             |
| `livenessProbe`                 | Liveness probe settings for logstash container     | (see `values.yaml`)                              |
| `readinessProbe`                | Readiness probe settings for logstash container    | (see `values.yaml`)                              |
| `persistence.enabled`           | Enable persistence                                 | `true`                                           |
| `persistence.storageClass`      | Storage class for PVCs                             | unset                                            |
| `persistence.accessMode`        | Access mode for PVCs                               | `ReadWriteOnce`                                  |
| `persistence.size`              | Size for PVCs                                      | `2Gi`                                            |
| `volumeMounts`                  | Volume mounts to configure for logstash container  | (see `values.yaml`)                              |
| `volumes`                       | Volumes to configure for logstash container        | []                              |
| `terminationGracePeriodSeconds` | Duration the pod needs to terminate gracefully     | `30`
| `exporter.logstash`             | Prometheus logstash-exporter settings              | (see `values.yaml`)                              |
| `exporter.logstash.enabled`     | Enables Prometheus logstash-exporter               | `false`                                          |
| `elasticsearch.host`            | ElasticSearch hostname                             | `elasticsearch-client.default.svc.cluster.local` |
| `elasticsearch.port`            | ElasticSearch port                                 | `9200`                                           |
| `config`                        | Logstash configuration key-values                  | (see `values.yaml`)                              |
| `patterns`                      | Logstash patterns configuration                    | `nil`                                            |
| `inputs`                        | Logstash inputs configuration                      | beats                                            |
| `filters`                       | Logstash filters configuration                     | `nil`                                            |
| `outputs`                       | Logstash outputs configuration                     | elasticsearch                                    |
