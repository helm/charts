# Knative Monitoring

This chart installs Knative components for Monitoring.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This is a helm chart for installing Knative Monitoring which provides tracing, logging and metrics. More info about Knative Monitoring can be found in the [Serving documentation](https://github.com/knative/docs/tree/master/serving#setting-up-logging-and-metrics).

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- Knative Monitoring:
    - Deployments: grafana, kibana-logging, kube-state-metrics
    - Service: elasticsearch-logging, fluentd-dsgrafana, kibana-logging, kube-controller-manager, kube-state-metrics, node-exporter, prometheus-system-discovery, prometheus-system-np
    - DaemonSet: fluentd-ds, node-exporter
    - StatefulSet: elasticsearch-logging, prometheus-system

### Configuration

| Parameter                                  | Description                              | Default |
|--------------------------------------------|------------------------------------------|---------|
| `serving.monitoring.enabled`               | Enable/Disable Knative Monitoring        | `true`    |
| `serving.monitoring.elasticsearch.enabled` | Enable/Disable Elasticsearch Logging     | `true`    |
| `serving.monitoring.elasticsearch.elasticsearchLogging.elasticsearchLoggingInit.image` | Elasticsearch Logging Init Image | alpine:3.6 |
| `serving.monitoring.elasticsearch.elasticsearchLogging.image`   | Elasticsearch Image | k8s.gcr.io/elasticsearch:v5.6.4  |
| `serving.monitoring.elasticsearch.elasticsearchLogging.replicas` | Elasticsearch Replicas | 2     |
| `serving.monitoring.elasticsearch.fluentdDs.image` | Fluentd Image                    | k8s.gcr.io/fluentd-elasticsearch:v2.0.4 |
| `serving.monitoring.elasticsearch.kibanaLogging.image` | Kibana Image                 | docker.elastic.co/kibana/kibana:5.6.4 |
| `serving.monitoring.elasticsearch.kibanaLogging.replicas` | Kibana Replicas           | 1         |
| `serving.monitoring.elasticsearch.kibanaLogging.type` | Kibana Ingress Type           | NodePort  |
| `serving.monitoring.prometheus.enabled`    | Enable/Disable Prometheus Metrics        | `true`    |
| `serving.monitoring.prometheus.grafana.image`    | Grafana Image        | quay.io/coreos/monitoring-grafana:5.0.3    |
| `serving.monitoring.prometheus.grafana.replicas`    | Number of Grafana pods         | 1    |
| `serving.monitoring.prometheus.grafana.type`    | Grafana Ingress Type        | NodePort   |
| `serving.monitoring.prometheus.kubeControllerManager.type`    | kubeControllerManager Ingress Type |  ClusterIP  |
| `serving.monitoring.prometheus.kubeStateMetrics.addonResizer.image` | Add On Resizer Image for Kube State Metrics | k8s.gcr.io/addon-resizer:1.7    |
| `serving.monitoring.prometheus.kubeStateMetrics.image`    | Kube State Metrics Image        | quay.io/coreos/kube-state-metrics:v1.3.0   |
| `serving.monitoring.prometheus.kubeStateMetrics.kubeRbacProxyMain.image`    | Kube Rbac Proxy Main Image for Kube State Metrics  | quay.io/coreos/kube-rbac-proxy:v0.3.0   |
| `serving.monitoring.prometheus.kubeStateMetrics.kubeRbacProxySelf.image`    | Kube Rbac Proxy Self Image for Kube State Metrics  | quay.io/coreos/kube-rbac-proxy:v0.3.0   |
| `serving.monitoring.prometheus.kubeStateMetrics.replicas`  | Number of Kube State Metrics Pods |  1  |
| `serving.monitoring.prometheus.nodeExporter.image` | Node Exporter Image for Prometheus | quay.io/prometheus/node-exporter:v0.15.2    |
| `serving.monitoring.prometheus.nodeExporter.kubeRbacProxy.https.hostPort`    | Https Host Port for Kube Rbac Proxy Node Exporter  | 9100  |
| `serving.monitoring.prometheus.nodeExporter.kubeRbacProxy.image`    | Kube Rbac Proxy Image  | quay.io/coreos/kube-rbac-proxy:v0.3.0  |
| `serving.monitoring.prometheus.nodeExporter.type`    | Node Exporter Ingress Type  | ClusterIP  |
| `serving.monitoring.prometheus.prometheusSystem.prometheus.image`    | Prometheus Image for Prometheus System  | prom/prometheus:v2.2.1  |
| `serving.monitoring.prometheus.prometheusSystem.replicas`    | Number of Prometheus System Pods  | 2  |
| `serving.monitoring.prometheus.prometheusSystemDiscovery.type`    | Ingress Type for Prometheus System Discovery  | ClusterIP  |
| `serving.monitoring.prometheus.prometheusSystemNp.type`    | Ingress Type for Prometheus System Np  | NodePort  |
| `serving.monitoring.zipkinInMem.enabled`   | Enable/Disable Zipkin In Memory Metrics  | `true`    |
| `serving.monitoring.zipkinInMem.zipkin.image`       | Zipkin In Memory Image                     | docker.io/openzipkin/zipkin:latest   |
| `serving.monitoring.zipkinInMem.zipkin.replicas`    | Zipkin In Memory Image                     | 1             |
| `serving.monitoring.zipkin.enabled`        | Enable/Disable Zipkin Metrics            | `false`   |
| `serving.monitoring.zipkin.zipkin.image`       | Zipkin Image                     | docker.io/openzipkin/zipkin:latest   |
| `serving.monitoring.zipkin.zipkin.replicas`    | Zipkin Image                     | 1             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Additional Information
For further information see the top level Knative chart.