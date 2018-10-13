# Syncthing

This is a helm chart for [Syncthing](https://syncthing.net/)

## TL;DR;

```console
helm install stable/syncthing
```

## Introduction

This code is adopted from [this original repo](https://github.com/linuxserver/docker-syncthing)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install --name my-release stable/syncthing
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Syncthing chart and their default values.

| Parameter                  | Description                         | Default                                                 |
|----------------------------|-------------------------------------|---------------------------------------------------------|
| `image.repository`         | Image repository | `linuxserver/syncthing` |
| `image.tag`                | Image tag. Possible values listed [here](https://hub.docker.com/r/linuxserver/syncthing/tags/).| `138`|
| `image.pullPolicy`         | Image pull policy | `IfNotPresent` |
| `webuiService.type`             | Kubernetes service type for the Syncthing WebUI | `ClusterIP` |
| `webuiService.port`             | Kubernetes port where the Syncthing WebUI is exposed| `80` |
| `webuiService.annotations`      | Service annotations for the Syncthing WebUI | `{}` |
| `webuiService.labels`           | Custom labels | `{}` |
| `webuiService.loadBalancerIP`   | Loadbalance IP for the Syncthing WebUI | `{}` |
| `webuiService.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported)      | None
| `webuiService.externalTrafficPolicy` | Set the externalTrafficPolicy in the Service to either Cluster or Local | `Cluster`
| `listenerService.type`             | Kubernetes service type for the Syncthing listener | `NodePort` |
| `listenerService.port`             | Kubernetes port where the Syncthing listener is exposed | `22000` |
| `listenerService.annotations`      | Service annotations for the Syncthing listener | `{}` |
| `listenerService.labels`           | Custom labels | `{}` |
| `listenerService.loadBalancerIP`   | Loadbalance IP for the Syncthing listener | `{}` |
| `listenerService.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported)      | None
| `listenerService.externalTrafficPolicy` | Set the externalTrafficPolicy in the Service to either Cluster or Local | `Cluster`
| `discoveryService.type`             | Kubernetes service type for discovery | `NodePort` |
| `discoveryService.port`             | Kubernetes UDP port for discovery | `21027` |
| `discoveryService.annotations`      | Service annotations for discovery | `{}` |
| `discoveryService.labels`           | Custom labels | `{}` |
| `discoveryService.loadBalancerIP`   | Loadbalance IP for AP discovery | `{}` |
| `discoveryService.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported)      | None
| `discoveryService.externalTrafficPolicy` | Set the externalTrafficPolicy in the Service to either Cluster or Local | `Cluster`
| `serviceAccount.create`        | Specifies whether a ServiceAccount should be created | `true` |
| `serviceAccount.name`          | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template | `(fullname template)` |
| `ingress.enabled`              | Enables Ingress | `false` |
| `ingress.annotations`          | Ingress annotations | `{}` |
| `ingress.labels`               | Custom labels                       | `{}`
| `ingress.path`                 | Ingress path | `/` |
| `ingress.hosts`                | Ingress accepted hostnames | `chart-example.local` |
| `ingress.tls`                  | Ingress TLS configuration | `[]` |
| `persistence.enabled`      | Use persistent volume to store data | `true` |
| `persistence.size`         | Size of persistent volume claim | `5Gi` |
| `persistence.existingClaim`| Use an existing PVC to persist data | `nil` |
| `persistence.storageClass` | Type of persistent volume claim | `-` |
| `persistence.accessModes`  | Persistence access modes | `[]` |
| `resources`                | CPU/Memory resource requests/limits | `{}` |
| `nodeSelector`             | Node labels for pod assignment | `{}` |
| `tolerations`              | Toleration labels for pod assignment | `[]` |
| `affinity`                 | Affinity settings for pod assignment | `{}` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install --name my-release \
  --set persistence.size="25Gi" \
    stable/syncthing
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install --name my-release -f values.yaml stable/syncthing
```

Read through the [values.yaml](values.yaml) file. It has several commented out suggested values.
