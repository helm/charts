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

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `alertmanager.httpPort` | Alertmanager Service port | `80` |
| `alertmanager.httpPortName` | Alertmanager service port name | `http` |
| `alertmanager.image` | Alertmanager Docker image | `prom/alertmanager:${VERSION}` |
| `alertmanager.ingress.enabled` | If true, Alertmanager Ingress will be created | `false` |
| `alertmanager.ingress.annotations` | Alertmanager Ingress annotations | `{}` |
| `alertmanager.ingress.hosts` | Alertmanager Ingress hostnames | `[]` |
| `alertmanager.ingress.tls` | Alertmanager Ingress TLS configuration (YAML) | `[]` |
| `alertmanager.name` | Alertmanager container name | `alertmanager` |
| `alertmanager.persistentVolume.enabled` | If true, AlertManager will create a Persistent Volume Claim | `true` |
| `alertmanager.persistentVolume.accessModes` | AlertManager data Persistent Volume access modes | `[ReadWriteOnce]` |
| `alertmanager.persistentVolume.existingClaim` | AlertManager data Persistent Volume existing claim name | |
| `alertmanager.persistentVolume.size` | AlertManager data Persistent Volume size | `2Gi` |
| `alertmanager.persistentVolume.storageClass` | AlertManager data Persistent Volume Storage Class | `volume.alpha.kubernetes.io/storage-class: default` |
| `alertmanager.persistentVolume.subPath` | Subdirectory of the volume to mount at  | `""` |
| `alertmanager.resources` | Alertmanager resource requests and limits (YAML) |`requests: {cpu: 10m, memory: 32Mi}` |
| `alertmanager.serviceType` | Alertmanager service type | `ClusterIP` |
| `alertmanager.storagePath` | Alertmanager data storage path | `/data` |
| `configmapReload.image` | Configmap-reload Docker image | `jimmidyson/configmap-reload:${VERSION}` |
| `configmapReload.name` | Configmap-reload container name | `configmap-reload` |
| `imagePullPolicy` | Global image pull policy | `Always` if image tag is latest, else `IfNotPresent` |
| `kubeStateMetrics.httpPort` | Kube-state-metrics service port | `80` |
| `kubeStateMetrics.httpPortName` | Kube-state-metrics service port name | `http` |
| `kubeStateMetrics.image` | Kube-state-metrics Docker image| `gcr.io/google_containers/kube-state-metrics:v0.3.0` |
| `kubeStateMetrics.name` | Kube-state-metrics container name | `kube-state-metrics` |
| `kubeStateMetrics.resources` | Kube-state-metrics resource requests and limits (YAML) | `requests: {cpu: 10m, memory:16Mi}` |
| `kubeStateMetrics.serviceType` | Kube-state-metrics service type | `ClusterIP` |
| `server.annotations` | Server Pod annotations | `[]` |
| `server.extraArgs` | Additional Server container arguments | `[]` |
| `server.httpPort` | Server service port | `80` |
| `server.httpPortName` | Server service port name | `http` |
| `server.image` | Server Docker image | ` prom/prometheus:${VERSION}` |
| `server.ingress.enabled` | If true, Server Ingress will be created | `false` |
| `server.ingress.annotations` | Server Ingress annotations | `[]` |
| `server.ingress.hosts` | Server Ingress hostnames | `[]` |
| `server.ingress.tls` | Server Ingress TLS configuration (YAML) | `[]` |
| `server.name` | Server container name | `server` |
| `server.persistentVolume.enabled` | If true, Server will create a Persistent Volume Claim | `false` |
| `server.persistentVolume.accessModes` | Server data Persistent Volume access modes | `[ReadWriteOnce]` |
| `server.persistentVolume.annotations` | Server data Persistent Volume annotations | `[]` |
| `server.persistentVolume.existingClaim` | Server data Persistent Volume existing claim name | |
| `server.persistentVolume.size` | Server data Persistent Volume size | `8Gi` |
| `server.persistentVolume.storageClass` | Server data Persistent Volume Storage Class | `volume.alpha.kubernetes.io/storage-class: default` |
| `server.persistentVolume.subPath` | Subdirectory of the volume to mount at  | `""` |
| `server.resources` | Server resource requests and limits | `requests: {cpu: 500m, memory: 512Mi}` |
| `server.serviceType` | Server service type | `ClusterIP` |
| `server.storageLocalPath` | Server local data storage path | `/data` |
| `server.terminationGracePeriodSeconds` | Server Pod termination grace period | `300` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set server.storageLocalPath=/prometheus \
    stable/prometheus
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/prometheus
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
    ## If true, Server Ingress will be created
    ##
    enabled: true

    ## Server Ingress hostnames
    ## Must be provided if Ingress is enabled
    ##
    hosts:
      - prometheus.domain.com

    ## Server Ingress TLS configuration
    ## Secrets must be manually created in the namespace
    ##
    tls:
      - secretName: prometheus-server-tls
        hosts:
          - prometheus.domain.com
```
