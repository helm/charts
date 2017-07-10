# Prometheus

[Prometheus](https://prometheus.io/), a [Cloud Native Computing Foundation](https://cncf.io/) project, is a systems and service monitoring system. It collects metrics from configured targets at given intervals, evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true.

## TL;DR;

```console
$ helm install stable/prometheus
```

## Introduction

This chart bootstraps a [Prometheus](https://prometheus.io/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.3+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/prometheus
```

The command deploys Prometheus on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

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
`alertmanager.enabled` | If true, create alertmanager | `true`
`alertmanager.name` | alertmanager container name | `alertmanager`
`alertmanager.image.repository` | alertmanager container image repository | `prom/alertmanager`
`alertmanager.image.tag` | alertmanager container image tag | `v0.5.1`
`alertmanager.image.pullPolicy` | alertmanager container image pull policy | `IfNotPresent`
`alertmanager.extraArgs` | Additional alertmanager container arguments | `{}`
`alertmanager.ingress.enabled` | If true, alertmanager Ingress will be created | `false`
`alertmanager.ingress.annotations` | alertmanager Ingress annotations | `{}`
`alertmanager.ingress.hosts` | alertmanager Ingress hostnames | `[]`
`alertmanager.ingress.tls` | alertmanager Ingress TLS configuration (YAML) | `[]`
`alertmanager.nodeSelector` | node labels for alertmanager pod assignment | `{}`
`alertmanager.persistentVolume.enabled` | If true, alertmanager will create a Persistent Volume Claim | `true`
`alertmanager.persistentVolume.accessModes` | alertmanager data Persistent Volume access modes | `[ReadWriteOnce]`
`alertmanager.persistentVolume.annotations` | Annotations for alertmanager Persistent Volume Claim` | `{}`
`alertmanager.persistentVolume.existingClaim` | alertmanager data Persistent Volume existing claim name | `""`
`alertmanager.persistentVolume.mountPath` | alertmanager data Persistent Volume mount root path | `/data`
`alertmanager.persistentVolume.size` | alertmanager data Persistent Volume size | `2Gi`
`alertmanager.persistentVolume.storageClass` | alertmanager data Persistent Volume Storage Class | `volume.alpha.kubernetes.io/storage-class: default`
`alertmanager.persistentVolume.subPath` | Subdirectory of alertmanager data Persistent Volume to mount | `""`
`alertmanager.podAnnotations` | annotations to be added to alertmanager pods | `{}`
`alertmanager.replicaCount` | desired number of alertmanager pods | `1`
`alertmanager.resources` | alertmanager pod resource requests & limits | `{}`
`alertmanager.service.annotations` | annotations for alertmanager service | `{}`
`alertmanager.service.clusterIP` | internal alertmanager cluster service IP | `""`
`alertmanager.service.externalIPs` | alertmanager service external IP addresses | `[]`
`alertmanager.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`alertmanager.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`alertmanager.service.servicePort` | alertmanager service port | `80`
`alertmanager.service.type` | type of alertmanager service to create | `ClusterIP`
`alertmanagerFiles` | alertmanager ConfigMap entries | `alertmanager.yml`
`configmapReload.name` | configmap-reload container name | `configmap-reload`
`configmapReload.image.repository` | configmap-reload container image repository | `jimmidyson/configmap-reload`
`configmapReload.image.tag` | configmap-reload container image tag | `v0.1`
`configmapReload.image.pullPolicy` | configmap-reload container image pull policy | `IfNotPresent`
`configmapReload.resources` | configmap-reload pod resource requests & limits | `{}`
`kubeStateMetrics.enabled` | If true, create kube-state-metrics | `true`
`kubeStateMetrics.name` | kube-state-metrics container name | `kube-state-metrics`
`kubeStateMetrics.image.repository` | kube-state-metrics container image repository| `gcr.io/google_containers/kube-state-metrics`
`kubeStateMetrics.image.tag` | kube-state-metrics container image tag | `v0.4.1`
`kubeStateMetrics.image.pullPolicy` | kube-state-metrics container image pull policy | `IfNotPresent`
`kubeStateMetrics.nodeSelector` | node labels for kube-state-metrics pod assignment | `{}`
`kubeStateMetrics.podAnnotations` | annotations to be added to kube-state-metrics pods | `{}`
`kubeStateMetrics.replicaCount` | desired number of kube-state-metrics pods | `1`
`kubeStateMetrics.resources` | kube-state-metrics resource requests and limits (YAML) | `{}`
`kubeStateMetrics.service.annotations` | annotations for kube-state-metrics service | `{prometheus.io/scrape: "true"}`
`kubeStateMetrics.service.clusterIP` | internal kube-state-metrics cluster service IP | `None`
`kubeStateMetrics.service.externalIPs` | kube-state-metrics service external IP addresses | `[]`
`kubeStateMetrics.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`kubeStateMetrics.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`kubeStateMetrics.service.servicePort` | kube-state-metrics service port | `80`
`kubeStateMetrics.service.type` | type of kube-state-metrics service to create | `ClusterIP`
`nodeExporter.enabled` | If true, create node-exporter | `true`
`nodeExporter.name` | node-exporter container name | `node-exporter`
`nodeExporter.image.repository` | node-exporter container image repository| `prom/node-exporter`
`nodeExporter.image.tag` | node-exporter container image tag | `v0.13.0`
`nodeExporter.image.pullPolicy` | node-exporter container image pull policy | `IfNotPresent`
`nodeExporter.extraArgs` | Additional node-exporter container arguments | `{}`
`nodeExporter.extraHostPathMounts` | Additional node-exporter hostPath mounts | `[]`
`nodeExporter.nodeSelector` | node labels for node-exporter pod assignment | `{}`
`nodeExporter.podAnnotations` | annotations to be added to node-exporter pods | `{}`
`nodeExporter.resources` | node-exporter resource requests and limits (YAML) | `{}`
`nodeExporter.service.annotations` | annotations for node-exporter service | `{prometheus.io/scrape: "true"}`
`nodeExporter.service.clusterIP` | internal node-exporter cluster service IP | `None`
`nodeExporter.service.externalIPs` | node-exporter service external IP addresses | `[]`
`nodeExporter.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`nodeExporter.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`nodeExporter.service.servicePort` | node-exporter service port | `9100`
`nodeExporter.service.type` | type of node-exporter service to create | `ClusterIP`
`server.name` | Prometheus server container name | `server`
`server.image.repository` | Prometheus server container image repository | `prom/prometheus`
`server.image.tag` | Prometheus server container image tag | `v1.5.1`
`server.image.pullPolicy` | Prometheus server container image pull policy | `IfNotPresent`
`server.alertmanagerURL` | (optional) alertmanager URL; only used if alertmanager.enabled = false | `""`
`server.extraArgs` | Additional Prometheus server container arguments | `{}`
`server.extraHostPathMounts` | Additional Prometheus server hostPath mounts | `[]`
`server.ingress.enabled` | If true, Prometheus server Ingress will be created | `false`
`server.ingress.annotations` | Prometheus server Ingress annotations | `[]`
`server.ingress.hosts` | Prometheus server Ingress hostnames | `[]`
`server.ingress.tls` | Prometheus server Ingress TLS configuration (YAML) | `[]`
`server.nodeSelector` | node labels for Prometheus server pod assignment | `{}`
`server.persistentVolume.enabled` | If true, Prometheus server will create a Persistent Volume Claim | `true`
`server.persistentVolume.accessModes` | Prometheus server data Persistent Volume access modes | `[ReadWriteOnce]`
`server.persistentVolume.annotations` | Prometheus server data Persistent Volume annotations | `{}`
`server.persistentVolume.existingClaim` | Prometheus server data Persistent Volume existing claim name | `""`
`server.persistentVolume.mountPath` | Prometheus server data Persistent Volume mount root path | `/data`
`server.persistentVolume.size` | Prometheus server data Persistent Volume size | `8Gi`
`server.persistentVolume.storageClass` | Prometheus server data Persistent Volume Storage Class | `volume.alpha.kubernetes.io/storage-class: default`
`server.persistentVolume.subPath` | Subdirectory of Prometheus server data Persistent Volume to mount | `""`
`server.podAnnotations` | annotations to be added to Prometheus server pods | `{}`
`server.replicaCount` | desired number of Prometheus server pods | `1`
`server.resources` | Prometheus server resource requests and limits | `{}`
`server.service.annotations` | annotations for Prometheus server service | `{}`
`server.service.clusterIP` | internal Prometheus server cluster service IP | `""`
`server.service.externalIPs` | Prometheus server service external IP addresses | `[]`
`server.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`server.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`server.service.servicePort` | Prometheus server service port | `80`
`server.service.type` | type of Prometheus server service to create | `ClusterIP`
`server.terminationGracePeriodSeconds` | Prometheus server Pod termination grace period | `300`
`serverFiles.alerts` | Prometheus server alerts configuration | `""`
`serverFiles.rules` | Prometheus server rules configuration | `""`
`serverFiles.prometheus.yml` | Prometheus server scrape configuration | example configuration

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/prometheus --name my-release \
    --set server.terminationGracePeriodSeconds=360
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/prometheus --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### ConfigMap Files
AlertManager is configured through [alertmanager.yml](https://prometheus.io/docs/alerting/configuration/). This file (and any others listed in `alertmanagerFiles`) will be mounted into the `alertmanager` pod.

Prometheus is configured through [prometheus.yml](https://prometheus.io/docs/operating/configuration/). This file (and any others listed in `serverFiles`) will be mounted into the `server` pod.

### Ingress TLS
If your cluster allows automatic creation/retrieval of TLS certificates (e.g. [kube-lego](https://github.com/jetstack/kube-lego)), please refer to the documentation for that mechanism.

To manually configure TLS, first create/retrieve a key & certificate pair for the address(es) you wish to protect. Then create a TLS secret in the namespace:

```console
kubectl create secret tls prometheus-server-tls --cert=path/to/tls.cert --key=path/to/tls.key
```

Include the secret's name, along with the desired hostnames, in the alertmanager/server Ingress TLS section of your custom `values.yaml` file:

```
server:
  ingress:
    ## If true, Prometheus server Ingress will be created
    ##
    enabled: true

    ## Prometheus server Ingress hostnames
    ## Must be provided if Ingress is enabled
    ##
    hosts:
      - prometheus.domain.com

    ## Prometheus server Ingress TLS configuration
    ## Secrets must be manually created in the namespace
    ##
    tls:
      - secretName: prometheus-server-tls
        hosts:
          - prometheus.domain.com
```
