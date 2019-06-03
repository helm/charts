# Seq

[Seq](https://getseq.net/) is the easiest way for development teams to capture, search and visualize structured log events!

## TL;DR;

```bash
$ helm install seq
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

|           Parameter           |                Description                        |           Default            |
|-------------------------------|-------------------------------------------------- |------------------------------|
| `image.repository`         | Image repository                    | `datalust/seq`                                          |
| `image.tag`                | Seq image tag. Possible values listed [here](https://hub.docker.com/r/datalust/seq/tags/).| `5`|
| `image.pullPolicy`         | Image pull policy                   | `IfNotPresent`                                          |
| `acceptEULA`               | Accept EULA                         | `Y`                                                     |
| `baseURI`                  | Base URL for ingress/AAD (see values.yaml)|                                                   |
| `service.type`             | Kubernetes service type             | `ClusterIP`                                             |
| `service.port`             | Kubernetes port where service is exposed| `5341`                                              |
| `persistence.enabled`      | Use persistent volume to store data | `true`                                                  |
| `persistence.size`         | Size of persistent volume claim     | `8Gi`                                                   |
| `persistence.existingClaim`| Use an existing PVC to persist data | `nil`                                                   |
| `persistence.storageClass` | Type of persistent volume claim     | `generic`                                               |
| `persistence.accessMode`   | ReadWriteOnce or ReadOnly           | `ReadWriteOnce`                                         |
| `persistence.subPath`      | Mount a sub directory of the persistent volume if set | `""`                                  |
| `resources`                | CPU/Memory resource requests/limits | Memory: `256Mi`, CPU: `100m`                            |
| `nodeSelector`             | Node labels for pod assignment      | `{}`                                                    |
| `affinity`                 | Affinity settings for pod assignment | `{}`                                                   |
| `tolerations`              | Toleration labels for pod assignment | `[]`                                                   |
| `ingress.enabled`          | Enables Ingress                      | `false`                                                |
| `ingress.annotations`      | Ingress annotations                  | `{}`                                                   |
| `ingress.labels`           | Custom labels                        | `{}`                                                   |
| `ingress.hosts`            | Ingress accepted hostnames           | `[]`                                                   |
| `ingress.tls`              | Ingress TLS configuration            | `[]`                                                   |

Some of the parameters above map to the env variables defined in the [Seq DockerHub image](https://hub.docker.com/r/datalust/seq/).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set persistence.size=8Gi \
    seq
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml seq
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Seq](https://hub.docker.com/r/datalust/seq/) image stores the Seq data and configurations at the `/data` path of the container.

By default, the chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning. If a Persistent Volume Claim already exists, specify it during installation.

### Existing PersistentVolumeClaim

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart

```bash
$ helm install --set persistence.existingClaim=PVC_NAME seq
```
