# kube2iam

Installs [kube2iam](https://github.com/jtblin/kube2iam) to provide IAM credentials to pods based on annotations.

## TL;DR;

```console
$ helm install stable/kube2iam
```

## Introduction

This chart bootstraps a [kube2iam](https://github.com/jtblin/kube2iam) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install stable/kube2iam --name my-release
```

The command deploys kube2iam on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the kube2iam chart and their default values.

Parameter | Description | Default
--- | --- | ---
`affinity` | affinity configuration for pod assignment | `{}`
`extraArgs` | Additional container arguments | `{}`
`extraEnv` | Additional container environment variables | `{}`
`host.ip` | IP address of host | `$(HOST_IP)`
`host.iptables` | Add iptables rule | `false`
`host.interface` | Host interface for proxying AWS metadata | `docker0`
`host.port` | Port to listen on | `8181`
`image.repository` | Image | `jtblin/kube2iam`
`image.tag` | Image tag | `0.10.4`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`nodeSelector` | node labels for pod assignment | `{}`
`podAnnotations` | annotations to be added to pods | `{}`
`priorityClassName` | priorityClassName to be added to pods | `{}`
`prometheus.metricsPort` | Port to expose prometheus metrics on (if unspecified, `host.port` is used) | `host.port`
`prometheus.serviceMonitor.enabled` | If true, create a Prometheus Operator ServiceMonitor resource | `false`
`prometheus.serviceMonitor.interval` | Interval at which the metrics endpoint is scraped | `10s`
`prometheus.serviceMonitor.namespace` | An alternative namespace in which to install the ServiceMonitor | `""`
`rbac.create` | If true, create & use RBAC resources | `false`
`rbac.serviceAccountName` | existing ServiceAccount to use (ignored if rbac.create=true) | `default`
`resources` | pod resource requests & limits | `{}`
`updateStrategy` | Strategy for DaemonSet updates (requires Kubernetes 1.6+) | `OnDelete`
`verbose` | Enable verbose output | `false`
`tolerations` | List of node taints to tolerate (requires Kubernetes 1.6+) | `[]`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/kube2iam --name my-release \
  --set=extraArgs.base-role-arn=arn:aws:iam::0123456789:role/,extraArgs.default-role=kube2iam-default,host.iptables=true,host.interface=cbr0
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/kube2iam --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
