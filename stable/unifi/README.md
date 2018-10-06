# Ubiqiti Network's Unifi Controller

This is a helm chart for [Ubiqiti Network's](https://www.ubnt.com/) [Unifi Controller](https://unifi-sdn.ubnt.com/)

## TL;DR;

```console
helm install stable/unifi
```

## Introduction

This code is adopted from [this original repo](https://github.com/jacobalberty/unifi-docker)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install --name my-release stable/unifi
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Sentry chart and their default values.

| Parameter                  | Description                         | Default                                                 |
|----------------------------|-------------------------------------|---------------------------------------------------------|
| `image.repository`         | Image repository | `jacobalberty/unifi` |
| `image.tag`                | Image tag. Possible values listed [here](https://hub.docker.com/r/jacobalberty/unifi/tags/).| `5.8.23`|
| `image.pullPolicy`         | Image pull policy | `IfNotPresent` |
| `guiService.type`             | Kubernetes service type for the Unifi GUI | `ClusterIP` |
| `guiService.port`             | Kubernetes port where the Unifi GUI is exposed| `8443` |
| `guiService.annotations`      | Service annotations for the Unifi GUI | `{}` |
| `guiService.labels`           | Custom labels | `{}` |
| `guiService.loadBalancerIP`   | Loadbalance IP for the Unifi GUI | `{}` |
| `guiService.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported)      | None
| `guiService.externalTrafficPolicy` | Set the externalTrafficPolicy in the Service to either Cluster or Local | `Cluster`
| `controllerService.type`             | Kubernetes service type for the Unifi Controller communication | `NodePort` |
| `controllerService.port`             | Kubernetes port where the Unifi Controller is exposed - this needs to be reachable by the unifi devices on the network | `8080` |
| `controllerService.annotations`      | Service annotations for the Unifi Controller | `{}` |
| `controllerService.labels`           | Custom labels | `{}` |
| `controllerService.loadBalancerIP`   | Loadbalance IP for the Unifi Controller | `{}` |
| `controllerService.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported)      | None
| `controllerService.externalTrafficPolicy` | Set the externalTrafficPolicy in the Service to either Cluster or Local | `Cluster`
| `stunService.type`             | Kubernetes service type for the Unifi STUN | `NodePort` |
| `stunService.port`             | Kubernetes UDP port where the Unifi STUN is exposed | `3478` |
| `stunService.annotations`      | Service annotations for the Unifi STUN | `{}` |
| `stunService.labels`           | Custom labels | `{}` |
| `stunService.loadBalancerIP`   | Loadbalance IP for the Unifi STUN | `{}` |
| `stunService.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported)      | None
| `stunService.externalTrafficPolicy` | Set the externalTrafficPolicy in the Service to either Cluster or Local | `Cluster`
| `discoveryService.type`             | Kubernetes service type for AP discovery | `NodePort` |
| `discoveryService.port`             | Kubernetes UDP port for AP discovery | `10001` |
| `discoveryService.annotations`      | Service annotations for AP discovery | `{}` |
| `discoveryService.labels`           | Custom labels | `{}` |
| `discoveryService.loadBalancerIP`   | Loadbalance IP for AP discovery | `{}` |
| `discoveryService.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported)      | None
| `discoveryService.externalTrafficPolicy` | Set the externalTrafficPolicy in the Service to either Cluster or Local | `Cluster`
| `ingress.enabled`              | Enables Ingress | `false` |
| `ingress.annotations`          | Ingress annotations | `{}` |
| `ingress.labels`               | Custom labels                       | `{}`
| `ingress.path`                 | Ingress path | `/` |
| `ingress.hosts`                | Ingress accepted hostnames | `chart-example.local` |
| `ingress.tls`                  | Ingress TLS configuration | `[]` |
| `timezone`                     | Timezone the Unifi controller should run as, e.g. 'America/New York' | `UTC` |
| `runAsRoot`                    | Run the controller as UID0 (root user) | `false` |
| `mongodb.enabled`              | Use external MongoDB for data storage | `false` |
| `mongodb.dbUri`                | external MongoDB URI | `mongodb://mongo/unifi` |
| `mongodb.statDbUri`            | external MongoDB statdb URI | `mongodb://mongo/unifi_stat` |
| `mongodb.databaseName`         | external MongoDB database name | `unifi` |
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
  --set timezone="America/New York" \
    stable/unifi
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install --name my-release -f values.yaml stable/unifi
```

Read through the [values.yaml](values.yaml) file. It has several commented out suggested values.

## Regarding the services

* `guiService`: represents the main web UI and is what one would normally point the ingress to
* `controllerService`: This is needed in order for the unifi devices to talk to the controller and must be otherwise exposed to the network where the unifi devices run.  If you run this as a NodePort (the default setting), make sure that there is an external loadbalancer that is directing traffic from port 8080 to the NodePort for this service
* `discoveryService`: This needs to be reachable by the unifi devices on the network similar to the controllerService but only during the discovery phase. This is a UDP service
* `stunService`: Also used periodically by the unifi devices to communicate with the controller using UDP.  See [this article](https://help.ubnt.com/hc/en-us/articles/204976094-UniFi-What-protocol-does-the-controller-use-to-communicate-with-the-UAP-) and [this other article](https://help.ubnt.com/hc/en-us/articles/115015457668-UniFi-Troubleshooting-STUN-Communication-Errors) for more information
