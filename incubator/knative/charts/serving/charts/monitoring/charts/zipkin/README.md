# Zipkin Tracing for Knative Monitoring

This chart installs Zipkin Tracing components for Knative Monitoring.
[Knative](https://github.com/knative/) extends Kubernetes to provide a set of middleware components that are essential to build modern, source-centric, and container-based applications that can run anywhere: on premises, in the cloud, or even in a third-party data center.

## Introduction

This chart is a subchart of Knative Monitoring. It installs Zipkin tracing. Visit [accessing traces](https://github.com/knative/docs/blob/master/serving/accessing-traces.md) to find out more.

## Chart Details

In its default configuration, this chart will create the following Kubernetes resources:

- Zipkin Tracing for Knative Monitoring:
    - Deployments: zipkin, activator, autoscaler, controller, webhook
    - Gateway: cluster-local-gateway, knative-ingress-gateway
    - ServiceAccounts: controller
    - Service: zipkin, activator-service, autoscaler, controller, webhook

### Configuration

| Parameter                                  | Description                              | Default |
|--------------------------------------------|------------------------------------------|---------|
| `serving.monitoring.zipkin.enabled`        | Enable/Disable Zipkin Metrics            | `false`   |
| `serving.monitoring.zipkin.zipkin.image`       | Zipkin Image                     | docker.io/openzipkin/zipkin:latest   |
| `serving.monitoring.zipkin.zipkin.replicas`    | Zipkin Image                     | 1             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Additional Information
For further information see the top level Knative chart.