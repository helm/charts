# CouchPotato

This is a helm chart for [CouchPotato][home].

## TL;DR:

```console
helm install incubator/couchpotato
```

## Introduction

This code is adopted from [this original repo][github].

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install --name my-release incubator/couchpotato
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the CouchPotato chart and their default values.

| Parameter                          | Description                                                                                                                            | Default                   |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| `image.repository`                 | Image repository                                                                                                                       | `linuxserver/couchpotato` |
| `image.tag`                        | Image tag. Possible values listed [here][docker].                                                                                      | `75e576ee-ls3`            |
| `image.pullPolicy`                 | Image pull policy                                                                                                                      | `IfNotPresent`            |
| `service.type`                     | Kubernetes service type for the CouchPotato UI/API                                                                                     | `ClusterIP`               |
| `service.clusterIP`                | ClusterIP for CouchPotato service; the default (empty string) will cause it to be auto-assigned                                        | `""`                      |
| `service.port`                     | Kubernetes port where CouchPotato is exposed                                                                                           | `5050`                    |
| `service.annotations`              | Service annotations for CouchPotato                                                                                                    | `{}`                      |
| `service.labels`                   | Custom labels                                                                                                                          | `{}`                      |
| `service.loadBalancerIP`           | Load balancer IP for CouchPotato                                                                                                       | `{}`                      |
| `service.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported)                                                                        | None                      |
| `service.externalTrafficPolicy`    | Set the externalTrafficPolicy in the Service to either Cluster or Local                                                                | `Cluster`                 |
| `ingress.enabled`                  | Enables Ingress                                                                                                                        | `false`                   |
| `ingress.annotations`              | Ingress annotations                                                                                                                    | `{}`                      |
| `ingress.labels`                   | Custom labels                                                                                                                          | `{}`                      |
| `ingress.path`                     | Ingress path                                                                                                                           | `/`                       |
| `ingress.hosts`                    | Ingress accepted hostnames                                                                                                             | `couchpotato`             |
| `ingress.tls`                      | Ingress TLS configuration                                                                                                              | `[]`                      |
| `settings.timezone`                | Timezone CouchPotato should run as, e.g. 'America/New York'                                                                            | `UTC`                     |
| `settings.uid`                     | Run as user UID                                                                                                                        | `1001`                    |
| `settings.gid`                     | Run as group GID                                                                                                                       | `1001`                    |
| `persistence.config.enabled`       | Use persistent volume to store config                                                                                                  | `true`                    |
| `persistence.config.size`          | Size of persistent volume claim                                                                                                        | `1Gi`                     |
| `persistence.config.existingClaim` | Use an existing PVC to persist config                                                                                                  | `nil`                     |
| `persistence.config.storageClass`  | Type of persistent volume claim                                                                                                        | `-`                       |
| `persistence.config.accessModes`   | Persistence access modes                                                                                                               | `[]`                      |
| `persistence.movies`               | REQUIRED.  Volume spec to inject into PodSpec for movie library - usually shared storage, but you can embed a PVC reference if desired | `{}`                      |
| `persistence.downloads`            | REQUIRED.  Volume spec to inject into PodSpec for downloads - usually shared storage, but you can embed a PVC reference if desired.    | `{}`                      |
| `resources`                        | CPU/Memory resource requests/limits                                                                                                    | `{}`                      |
| `nodeSelector`                     | Node labels for pod assignment                                                                                                         | `{}`                      |
| `tolerations`                      | Toleration labels for pod assignment                                                                                                   | `[]`                      |
| `affinity`                         | Affinity settings for pod assignment                                                                                                   | `{}`                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install --name my-release \
  --set timezone="America/New York" \
    incubator/couchpotato
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install --name my-release -f values.yaml incubator/couchpotato
```

Read through the [values.yaml](values.yaml) file. It has several commented out suggested values.

[home]: https://couchpota.to/
[github]: https://github.com/linuxserver/docker-couchpotato
[docker]: https://hub.docker.com/r/linuxserver/couchpotato/tags/

