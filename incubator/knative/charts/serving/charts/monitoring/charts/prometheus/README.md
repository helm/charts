# Prometheus Metrics for Knative Monitoring

This chart installs Prometheus Metrics components for Knative Monitoring.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This chart is a subchart of Knative Monitoring. It installs Prometheus metrics. Visit [accessing metrics](https://github.com/knative/docs/blob/master/serving/accessing-metrics.md) to find out more.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- Prometheus Metrics for Knative Monitoring:
    - Deployment: kibana-logging, activator, autoscaler, controller, webhook
    - Service: elasticsearch-logging, fluentd-ds, kibana-logging, activator-service, autoscaler, controller, webhook
    - ServiceAccount: elasticsearch-logging, fluentd-ds, controller
    - DaemonSet: fluentd-ds
    - Gateway: cluster-local-gateway, knative-ingress-gateway

### Configuration

| Parameter                                  | Description                              | Default |
|--------------------------------------------|------------------------------------------|---------|
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

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Additional Information
For further information see the top level Knative chart.