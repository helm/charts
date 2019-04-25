# Knative Serving

This chart installs Knative components for Serving.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This is a helm chart for installing Knative serving which provides provides middleware primitives that enable rapid deployment of serverless containers, automatic scaling up and down to zero, routing and network programming for Istio components and point-in-time snapshots of deployed code and configurations. Visit [Knative Serving](https://github.com/knative/serving/blob/master/README.md) for more information.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- Knative Serving:
    - Deployments: activator, autoscaler, controller, webhook
    - Service: activator-service, autoscaler, controller, webhook
    - ServiceAccounts: controller, default

### Configuration

| Parameter                                  | Description                              | Default |
|--------------------------------------------|------------------------------------------|---------|
| `serving.enabled`                          | Enable/Disable Knative Serving           | `true`    |
| `serving.activator.image`                  | Activator Image                          | gcr.io/knative-releases/github.com/knative/serving/cmd/activator@sha256:c75dc977b2a4d16f01f89a1741d6895990b7404b03ffb45725a63104d267b74a   |
| `serving.activatorService.type`            | Activator Ingress Type                   | ClusterIP |
| `serving.autoscaler.image`                 | Autoscaler Image                         | gcr.io/knative-releases/github.com/knative/serving/cmd/autoscaler@sha256:90f1199b3557242d46c4347d101e6767c388387e7cc30d8e6748dbfb10cefaef   |
| `serving.autoscaler.replicas`              | Autoscaler Replicas                      | 1         |
| `serving.controller.image`                 | Controller Image                         | gcr.io/knative-releases/github.com/knative/serving/cmd/controller@sha256:df02e462373a3e4a408356d8d6240222bfe31f6aebbac804d28a6982532fb45f  |
| `serving.controller.replicas`              | Controller Replicas                      | 1         |
| `serving.queueProxy.image`                 | Queue Proxy Image                        | gcr.io/knative-releases/github.com/knative/serving/cmd/queue@sha256:cae33dcb4477f87815dfae6fa8e2b1ec850562accb77b7bc36bb3ac12bafead1  |
| `serving.webhook.image`                    | Webhook Image                            | gcr.io/knative-releases/github.com/knative/serving/cmd/webhook@sha256:72189c6a5610e13794836a49bd2d6269206f434ab881b817d23e31f61493152e  |
| `serving.webhook.replicas`                 | Webhook Replicas                         | 1         |
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
| `serving.monitoring.zipkin.enabled`        | Enable/Disable Zipkin Metrics            | `false`   |
| `serving.monitoring.zipkin.zipkin.image`       | Zipkin Image                     | docker.io/openzipkin/zipkin:latest   |
| `serving.monitoring.zipkin.zipkin.replicas`    | Zipkin Image                     | 1             |
| `serving.monitoring.zipkinInMem.enabled`   | Enable/Disable Zipkin In Memory Metrics  | `true`    |
| `serving.monitoring.zipkinInMem.zipkin.image`       | Zipkin In Memory Image                     | docker.io/openzipkin/zipkin:latest   |
| `serving.monitoring.zipkinInMem.zipkin.replicas`    | Zipkin In Memory Image                     | 1             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Additional Information
For further information see the top level Knative chart.