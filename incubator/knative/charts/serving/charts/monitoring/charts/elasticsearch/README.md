# Elasticsearch logging for Knative Monitoring

This chart installs Elasticsearch logging components for Knative Monitoring.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This chart is a subchart of Knative Monitoring. It installs Elasticsearch logging. Visit [accessing logs](https://github.com/knative/docs/blob/master/serving/accessing-logs.md) to find out more.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- Elasticsearch logging for Knative Monitoring:
    - Deployments: kibana-logging, activator, autoscaler, controller, webhook
    - Service: elasticsearch-logging, fluentd-ds, kibana-logging, activator-service, autoscaler, controller, webhook
    - StatefulSet: elasticsearch-logging, fluentd-ds
    - Gateway: cluster-local-gateway, knative-ingress-gateway
    - ServiceAccount: elasticsearch-logging, fluentd-ds, controller

### Configuration

| Parameter                                  | Description                              | Default |
|--------------------------------------------|------------------------------------------|---------|
| `serving.monitoring.elasticsearch.enabled` | Enable/Disable Elasticsearch Logging     | `true`    |
| `serving.monitoring.elasticsearch.elasticsearchLogging.elasticsearchLoggingInit.image` | Elasticsearch Logging Init Image | alpine:3.6 |
| `serving.monitoring.elasticsearch.elasticsearchLogging.image`   | Elasticsearch Image | k8s.gcr.io/elasticsearch:v5.6.4  |
| `serving.monitoring.elasticsearch.elasticsearchLogging.replicas` | Elasticsearch Replicas | 2     |
| `serving.monitoring.elasticsearch.fluentdDs.image` | Fluentd Image                    | k8s.gcr.io/fluentd-elasticsearch:v2.0.4 |
| `serving.monitoring.elasticsearch.kibanaLogging.image` | Kibana Image                 | docker.elastic.co/kibana/kibana:5.6.4 |
| `serving.monitoring.elasticsearch.kibanaLogging.replicas` | Kibana Replicas           | 1         |
| `serving.monitoring.elasticsearch.kibanaLogging.type` | Kibana Ingress Type           | NodePort  |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Additional Information
For further information see the top level Knative chart.