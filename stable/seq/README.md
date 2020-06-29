# Seq

[Seq](https://getseq.net/) is the easiest way for development teams to capture, search and visualize structured log events!

## TL;DR;

```bash
$ helm install stable/seq
```

## Introduction

This chart bootstraps a [Seq](https://hub.docker.com/r/datalust/seq/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release seq
```

The command deploys Seq on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Seq chart and their default values.

| Parameter                            | Description                                                                                           | Default                               |
| ------------------------------------ | ----------------------------------------------------------------------------------------------------- | --------------------------------------|
| `image.repository`                   | Image repository                                                                                      | `datalust/seq`                        |
| `image.tag`                          | Seq image tag. Possible values listed [here](https://hub.docker.com/r/datalust/seq/tags/).            | `2020`                                   |
| `image.pullPolicy`                   | Image pull policy                                                                                     | `IfNotPresent`                        |
| `acceptEULA`                         | Accept EULA                                                                                           | `Y`                                   |
| `baseURI`                            | Base URL for ingress/AAD (see values.yaml)                                                            |                                       |
| `service.type`                       | Kubernetes service type                                                                               | `ClusterIP`                           |
| `ingress.annotations`                | Ingress annotations                                                                                   | `{}`                                  |
| `ingress.labels`                     | Custom labels                                                                                         | `{}`                                  |
| `ingress.tls`                        | Ingress TLS configuration                                                                             | `[]`                                  |
| `ui.service.port`                    | Kubernetes port where the full API/UI is exposed                                                      | `80`                                  |
| `ui.ingress.enabled`                 | Enable ingress on the full API/UI                                                                     | `false`                               |
| `ui.ingress.path`                    | Ingress path                                                                                          | `/`                                   |
| `ui.ingress.hosts`                   | Ingress accepted hostnames                                                                            | `[]`                                  |
| `ingestion.service.port`             | Kubernetes port where the ingestion-only API is exposed                                               | `5341`                                |
| `ingestion.ingress.enabled`          | Enable ingress on the ingestion-only API                                                              | `false`                               |
| `ingestion.ingress.path`             | Ingress path                                                                                          | `/`                                   |
| `ingestion.ingress.hosts`            | Ingress accepted hostnames                                                                            | `[]`                                  |
| `gelf.enabled`                       | Enable log ingestion using the GELF protocol                                                          | `false`                               |
| `gelf.apiKey`                        | The API key to use when forwarding events into Seq                                                    |                                       |
| `gelf.image.repository`              | Image repository                                                                                      | `datalust/sqelf`                      |
| `gelf.image.tag`                     | Sqelf image tag                                                                                       | `2`                                   |
| `gelf.image.pullPolicy`              | Image pull policy                                                                                     | `IfNotPresent`                        |
| `gelf.service.port`                  | The port to listen for GELF events on                                                                 | `12201`                               |
| `gelf.service.protocol`              | The protocol to listen for GELF events on. Can be either `UDP` or `TCP`.                              | `TCP`                                 |
| `persistence.enabled`                | Use persistent volume to store data                                                                   | `true`                                |
| `persistence.size`                   | Size of persistent volume claim                                                                       | `8Gi`                                 |
| `persistence.existingClaim`          | Use an existing PVC to persist data                                                                   | `nil`                                 |
| `persistence.storageClass`           | Type of persistent volume claim                                                                       | `generic`                             |
| `persistence.accessMode`             | ReadWriteOnce or ReadOnly                                                                             | `ReadWriteOnce`                       |
| `persistence.subPath`                | Mount a sub directory of the persistent volume if set                                                 | `""`                                  |
| `resources`                          | CPU/Memory resource requests/limits                                                                   | `{}`                                  |
| `nodeSelector`                       | Node labels for pod assignment                                                                        | `{}`                                  |
| `affinity`                           | Affinity settings for pod assignment                                                                  | `{}`                                  |
| `tolerations`                        | Toleration labels for pod assignment                                                                  | `[]`                                  |
| `serviceAccount.create`              | Specifies whether a ServiceAccount should be created                                                  | `false`                               |
| `serviceAccount.name`                | The name of the ServiceAccount to create                                                              | Generated using the fullname template |
| `rbac.create`                        | Specifies whether RBAC resources should be created                                                    | `false`                               |
| `podSecurityPolicy.create`           | Specifies whether a PodSecurityPolicy should be created                                               | `false`                               |
| `livenessProbe.enabled`              | Enable/disable the Liveness probe                                                                     | `true`                                |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the liveness probe to be considered failed after having succeeded    | `3`                                   |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                              | `0`                                   |
| `livenessProbe.periodSeconds`        | How often to perform the liveness probe                                                               | `10`                                  |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the liveness probe to be considered successful after having failed  | `1`                                   |
| `livenessProbe.timeoutSeconds`       | When the liveness probe times out                                                                     | `1`                                   |
| `readinessProbe.enabled`             | Enable/disable the Readiness probe                                                                    | `true`                                |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the readiness probe to be considered failed after having succeeded   | `3`                                   |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                                                             | `0`                                   |
| `readinessProbe.periodSeconds`       | How often to perform the readiness probe                                                              | `10`                                  |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the readiness probe to be considered successful after having failed | `1`                                   |
| `readinessProbe.timeoutSeconds`      | When the readiness probe times out                                                                    | `1`                                   |
| `startupProbe.enabled`               | Enable/disable the Readiness probe                                                                    | `true`                                |
| `startupProbe.failureThreshold`      | Minimum consecutive failures for the readiness probe to be considered failed after having succeeded   | `30`                                  |
| `startupProbe.periodSeconds`         | How often to perform the readiness probe                                                              | `10`                                  |

Some of the parameters above map to the env variables defined in the [Seq DockerHub image](https://hub.docker.com/r/datalust/seq/).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set persistence.size=8Gi \
    stable/seq
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/seq
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Seq](https://hub.docker.com/r/datalust/seq/) image stores the Seq data and configurations at the `/data` path of the container.

By default, the chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning. If a Persistent Volume Claim already exists, specify it during installation.

### Existing PersistentVolumeClaim

1. Create the PersistentVolume
2. Create the PersistentVolumeClaim
3. Install the chart

```bash
$ helm install --set persistence.existingClaim=PVC_NAME stable/seq
```
