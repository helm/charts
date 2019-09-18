# Wavefront Kubenetes collector

[Wavefront](https://wavefront.com) is a cloud-native monitoring and analytics platform that provides 
three dimensional microservices observability with metrics, histograms and OpenTracing-compatible distributed tracing.

## Introduction

This chart will deploy the Wavefront Kubernetes collector and Wavefront Proxy to your
Kubernetes cluster.  You can use this chart to install multiple Wavefront Proxy releases,
though only one Wavefront Kubernetes collector per cluster should be used.

You can learn more about the Wavefront and Kubernetes integration [here](https://docs.wavefront.com/wavefront_kubernetes.html)

## Configuration

The [values.yaml](./values.yaml) file contains information about all configuration
options for this chart.

The **requried** options are `clusterName`, `wavefront.url` and `wavefront.token`.
You will need to provide values for those options for a successful installation of the chart.
