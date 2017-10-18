# Node Exporter

[Prometheus](https://prometheus.io/), a [Cloud Native Computing Foundation](https://cncf.io/) project, is a systems and service monitoring system. It collects metrics from configured targets at given intervals, evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true.

## TL;DR;

```console
$ helm install stable/node-exporter
```

## Introduction

This chart bootstraps a Node-Exporter [Prometheus](https://prometheus.io/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.3+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/node-exporter
```

The command deploys Node Exporter on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Prometheus chart and their default values.

Parameter | Description | Default
--------- | ----------- | -------
`name` | node-exporter container name | `node-exporter`
`image.repository` | node-exporter container image repository| `prom/node-exporter`
`image.tag` | node-exporter container image tag | `v0.13.0`
`image.pullPolicy` | node-exporter container image pull policy | `IfNotPresent`
`extraArgs` | Additional node-exporter container arguments | `{}`
`extraHostPathMounts` | Additional node-exporter hostPath mounts | `[]`
`nodeSelector` | node labels for node-exporter pod assignment | `{}`
`podAnnotations` | annotations to be added to node-exporter pods | `{}`
`tolerations` | node taints to tolerate (requires Kubernetes >=1.6) | `[]`
`resources` | node-exporter resource requests and limits (YAML) | `{}`
`serviceAccountName` | service account name for node-exporter to use (ignored if rbac.create=true) | `default`
`service.annotations` | annotations for node-exporter service | `{prometheus.io/scrape: "true"}`
`service.clusterIP` | internal node-exporter cluster service IP | `None`
`service.externalIPs` | node-exporter service external IP addresses | `[]`
`service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`service.servicePort` | node-exporter service port | `9100`
`service.type` | type of node-exporter service to create | `ClusterIP`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/node-exporter --name my-release \
    --set server.terminationGracePeriodSeconds=360
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/node-exporter --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
