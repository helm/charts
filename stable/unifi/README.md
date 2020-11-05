# DEPRECATED - Network's Unifi Controller

|**This chart has been deprecated and moved to its new home:**
|
|- **GitHub repo:** https://github.com/k8s-at-home/charts/tree/master/charts/unifi
|- **Charts repo:** https://k8s-at-home.com/charts/

This is a helm chart for [Ubiquiti Network's][ubnt] [Unifi Controller][ubnt 2].

## TL;DR;

```console
helm install stable/unifi
```

## Introduction

This code is adopted from [this original repo][github].

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

The following tables lists the configurable parameters of the Unifi chart and their default values.

| Parameter                                       | Default                      | Description                                                                                                            |
|-------------------------------------------------|------------------------------|------------------------------------------------------------------------------------------------------------------------|
| `image.repository`                              | `jacobalberty/unifi`         | Image repository                                                                                                       |
| `image.tag`                                     | `5.12.35`                    | Image tag. Possible values listed [here][docker].                                                                      |
| `image.pullPolicy`                              | `IfNotPresent`               | Image pull policy                                                                                                      |
| `strategyType`                                  | `Recreate`                   | Specifies the strategy used to replace old Pods by new ones                                                            |
| `guiService.type`                               | `ClusterIP`                  | Kubernetes service type for the Unifi GUI                                                                              |
| `guiService.port`                               | `8443`                       | Kubernetes port where the Unifi GUI is exposed                                                                         |
| `guiService.annotations`                        | `{}`                         | Service annotations for the Unifi GUI                                                                                  |
| `guiService.labels`                             | `{}`                         | Custom labels                                                                                                          |
| `guiService.loadBalancerIP`                     | `{}`                         | Loadbalance IP for the Unifi GUI                                                                                       |
| `guiService.loadBalancerSourceRanges`           | None                         | List of IP CIDRs allowed access to load balancer (if supported)                                                        |
| `guiService.externalTrafficPolicy`              | `Cluster`                    | Set the externalTrafficPolicy in the Service to either Cluster or Local                                                |
| `captivePortalService.enabled`                  | `false`                      | Install the captive portal service (needed if you want guest captive portal)                                           |
| `captivePortalService.type`                     | `ClusterIP`                  | Kubernetes service type for the captive portal                                                                         |
| `captivePortalService.http`                     | `8880`                       | Kubernetes port where the captive portal is exposed                                                                    |
| `captivePortalService.https`                    | `8843`                       | Kubernetes port where the captive portal is exposed (with SSL)                                                         |
| `captivePortalService.annotations`              | `{}`                         | Service annotations for the captive portal                                                                             |
| `captivePortalService.labels`                   | `{}`                         | Custom labels                                                                                                          |
| `captivePortalService.loadBalancerIP`           | `{}`                         | Loadbalance IP for the Unifi GUI                                                                                       |
| `captivePortalService.loadBalancerSourceRanges` | None                         | List of IP CIDRs allowed access to load balancer (if supported)                                                        |
| `captivePortalService.externalTrafficPolicy`    | `Cluster`                    | Set the externalTrafficPolicy in the Service to either Cluster or Local                                                |
| `captivePortalService.ingress.enabled`          | `false`                      | Enables Ingress (for the captive portal, the main ingress needs to be enabled for the controller to be accessible)     |
| `captivePortalService.ingress.annotations`      | `{}`                         | Ingress annotations for the captive portal                                                                             |
| `captivePortalService.ingress.labels`           | `{}`                         | Custom labels for the captive portal                                                                                   |
| `captivePortalService.ingress.path`             | `/`                          | Ingress path for the captive portal                                                                                    |
| `captivePortalService.ingress.hosts`            | `chart-example.local`        | Ingress accepted hostnames for the captive portal                                                                      |
| `captivePortalService.ingress.tls`              | `[]`                         | Ingress TLS configuration for the captive portal                                                                       |
| `controllerService.type`                        | `NodePort`                   | Kubernetes service type for the Unifi Controller communication                                                         |
| `controllerService.port`                        | `8080`                       | Kubernetes port where the Unifi Controller is exposed - this needs to be reachable by the unifi devices on the network |
| `controllerService.annotations`                 | `{}`                         | Service annotations for the Unifi Controller                                                                           |
| `controllerService.labels`                      | `{}`                         | Custom labels                                                                                                          |
| `controllerService.loadBalancerIP`              | `{}`                         | Loadbalance IP for the Unifi Controller                                                                                |
| `controllerService.loadBalancerSourceRanges`    | None                         | List of IP CIDRs allowed access to load balancer (if supported)                                                        |
| `controllerService.externalTrafficPolicy`       | `Cluster`                    | Set the externalTrafficPolicy in the Service to either Cluster or Local                                                |
| `controllerService.ingress.enabled`             | `false`                      | Enables Ingress for the controller                                                                                     |
| `controllerService.ingress.annotations`         | `{}`                         | Ingress annotations for the controller                                                                                 |
| `controllerService.ingress.labels`              | `{}`                         | Custom labels for the controller                                                                                       |
| `controllerService.ingress.path`                | `/`                          | Ingress path for the controller                                                                                        |
| `controllerService.ingress.hosts`               | `chart-example.local`        | Ingress accepted hostnames for the controller                                                                          |
| `controllerService.ingress.tls`                 | `[]`                         | Ingress TLS configuration for the controller                                                                           |
| `stunService.type`                              | `NodePort`                   | Kubernetes service type for the Unifi STUN                                                                             |
| `stunService.port`                              | `3478`                       | Kubernetes UDP port where the Unifi STUN is exposed                                                                    |
| `stunService.annotations`                       | `{}`                         | Service annotations for the Unifi STUN                                                                                 |
| `stunService.labels`                            | `{}`                         | Custom labels                                                                                                          |
| `stunService.loadBalancerIP`                    | `{}`                         | Loadbalance IP for the Unifi STUN                                                                                      |
| `stunService.loadBalancerSourceRanges`          | None                         | List of IP CIDRs allowed access to load balancer (if supported)                                                        |
| `stunService.externalTrafficPolicy`             | `Cluster`                    | Set the externalTrafficPolicy in the Service to either Cluster or Local                                                |
| `discoveryService.type`                         | `NodePort`                   | Kubernetes service type for AP discovery                                                                               |
| `discoveryService.port`                         | `10001`                      | Kubernetes UDP port for AP discovery                                                                                   |
| `discoveryService.annotations`                  | `{}`                         | Service annotations for AP discovery                                                                                   |
| `discoveryService.labels`                       | `{}`                         | Custom labels                                                                                                          |
| `discoveryService.loadBalancerIP`               | `{}`                         | Loadbalance IP for AP discovery                                                                                        |
| `discoveryService.loadBalancerSourceRanges`     | None                         | List of IP CIDRs allowed access to load balancer (if supported)                                                        |
| `discoveryService.externalTrafficPolicy`        | `Cluster`                    | Set the externalTrafficPolicy in the Service to either Cluster or Local                                                |
| `unifiedService.enabled`                        | `false`                      | Use a single service for GUI, controller, STUN, and discovery                                                          |
| `unifiedService.type`                           | `ClusterIP`                  | Kubernetes service type for the unified service                                                                        |
| `unifiedService.annotations`                    | `{}`                         | Annotations for the unified service                                                                                    |
| `unifiedService.labels`                         | `{}`                         | Custom labels for the unified service                                                                                  |
| `unifiedService.loadBalancerIP`                 | None                         | Load balancer IP for the unified service                                                                               |
| `unifiedService.loadBalancerSourceRanges`       | None                         | List of IP CIDRs allowed access to the load balancer (if supported)                                                    |
| `unifiedService.externalTrafficPolicy`          | `Cluster`                    | Set the externalTrafficPolicy in the service to either Cluster or Local                                                |
| `ingress.enabled`                               | `false`                      | Enables Ingress                                                                                                        |
| `ingress.annotations`                           | `{}`                         | Ingress annotations                                                                                                    |
| `ingress.labels`                                | `{}`                         | Custom labels                                                                                                          |
| `ingress.path`                                  | `/`                          | Ingress path                                                                                                           |
| `ingress.hosts`                                 | `chart-example.local`        | Ingress accepted hostnames                                                                                             |
| `ingress.tls`                                   | `[]`                         | Ingress TLS configuration                                                                                              |
| `timezone`                                      | `UTC`                        | Timezone the Unifi controller should run as, e.g. 'America/New York'                                                   |
| `runAsRoot`                                     | `false`                      | Run the controller as UID0 (root user); if set to false, will give container SETFCAP instead                           |
| `UID`                                           | `999`                        | Run the controller as user UID                                                                                         |
| `GID`                                           | `999`                        | Run the controller as group GID                                                                                        |
| `customCert.enabled`                            | `false`                      | Define whether you are using s custom certificate                                                                      |
| `customCert.isChain`                            | `false`                      | If you are using a Let's Encrypt certificate which already includes the full chain set this to `true`                  |
| `customCert.certName`                           | `tls.crt`                    | Name of the the certificate file in `<unifi-data>/cert`                                                                |
| `customCert.keyName`                            | `tls.key`                    | Name of the the private key file in `<unifi-data>/cert`                                                                |
| `customCert.certSecret`                         | `nil`                        | Name of the the k8s tls secret where the certificate and its key are stored.                                           |
| `mongodb.enabled`                               | `false`                      | Use external MongoDB for data storage                                                                                  |
| `mongodb.dbUri`                                 | `mongodb://mongo/unifi`      | external MongoDB URI                                                                                                   |
| `mongodb.statDbUri`                             | `mongodb://mongo/unifi_stat` | external MongoDB statdb URI                                                                                            |
| `mongodb.databaseName`                          | `unifi`                      | external MongoDB database name                                                                                         |
| `persistence.enabled`                           | `true`                       | Use persistent volume to store data                                                                                    |
| `persistence.size`                              | `5Gi`                        | Size of persistent volume claim                                                                                        |
| `persistence.existingClaim`                     | `nil`                        | Use an existing PVC to persist data                                                                                    |
| `persistence.subPath`                           | ``                           | Store data in a subdirectory of PV instead of at the root directory                                                    |
| `persistence.storageClass`                      | `-`                          | Type of persistent volume claim                                                                                        |
| `extraVolumes`                                  | `[]`                         | Additional volumes to be used by extraVolumeMounts                                                                     |
| `extraVolumeMounts`                             | `[]`                         | Additional volume mounts to be mounted in unifi container                                                              |
| `persistence.accessModes`                       | `[]`                         | Persistence access modes                                                                                               |
| `extraConfigFiles`                              | `{}`                         | Dictionary containing files mounted to `/configmap` inside the pod (See [values.yaml](values.yaml) for examples)       |
| `extraJvmOpts`                                  | `[]`                         | List of additional JVM options, e.g. `["-Dlog4j.configurationFile=file:/configmap/log4j2.xml"]`                        |
| `resources`                                     | `{}`                         | CPU/Memory resource requests/limits                                                                                    |
| `nodeSelector`                                  | `{}`                         | Node labels for pod assignment                                                                                         |
| `tolerations`                                   | `[]`                         | Toleration labels for pod assignment                                                                                   |
| `affinity`                                      | `{}`                         | Affinity settings for pod assignment                                                                                   |
| `podAnnotations`                                | `{}`                         | Key-value pairs to add as pod annotations                                                                              |
| `deploymentAnnotations`                         | `{}`                         | Key-value pairs to add as deployment annotations                                                                       |

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

- `guiService`: Represents the main web UI and is what one would normally point
  the ingress to.
- `captivePortalService`: This service is used to allow the captive portal webpage
  to be accessible. It needs to be reachable by the clients connecting to your guest
  network.
- `controllerService`: This is needed in order for the unifi devices to talk to
  the controller and must be otherwise exposed to the network where the unifi
  devices run. If you run this as a `NodePort` (the default setting), make sure
  that there is an external load balancer that is directing traffic from port
  8080 to the `NodePort` for this service.
- `discoveryService`: This needs to be reachable by the unifi devices on the
  network similar to the controller `Service` but only during the discovery
  phase. This is a UDP service.
- `stunService`: Also used periodically by the unifi devices to communicate
  with the controller using UDP. See [this article][ubnt 3] and [this other
  article][ubnt 4] for more information.

## Ingress and HTTPS

Unifi does [not support HTTP][unifi] so if you wish to use the guiService, you
need to ensure that you use a backend transport of HTTPS.

An example entry in `values.yaml` to achieve this is as follows:

```
ingress:
  enabled: true
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
```

[docker]: https://hub.docker.com/r/jacobalberty/unifi/tags/
[github]: https://github.com/jacobalberty/unifi-docker
[ubnt]: https://www.ubnt.com/
[ubnt 2]: https://unifi-sdn.ubnt.com/
[ubnt 3]: https://help.ubnt.com/hc/en-us/articles/204976094-UniFi-What-protocol-does-the-controller-use-to-communicate-with-the-UAP-
[ubnt 4]: https://help.ubnt.com/hc/en-us/articles/115015457668-UniFi-Troubleshooting-STUN-Communication-Errors
[unifi]: https://community.ui.com/questions/Controller-how-to-deactivate-http-to-https/c5e247d8-b5b9-4c84-a3bb-28a90fd65668
