#  Apache superset

## Introduction

This chart bootstraps an [Apache superset](https://superset.incubator.apache.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## TL;DR;

```bash
$ helm install incubator/superset
```

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure (Only when persisting data)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/superset
```

The command deploys Superset on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

| Parameter                  | Description                                     | Default                                                      |
| -----------------------    | ---------------------------------------------   | ------------------------------------------------------------ |
| `image`                    | `superset` image repository                     | `alitari`                                                    |
| `imageTag`                 | `superset` image tag                            | `v0.23.3`                                                    |
| `imagePullPolicy`          | Image pull policy                               | `Always`                                                     |
| `containerPort`            | Container port                                  | `9000`                                                       |
| `configFile`               | Content of [`superset_config.py`](https://superset.incubator.apache.org/installation.html)                      | See [values.yaml](./values.yaml)                                                   |
| `replicas`                 | Number of replicas of superset                  | `1`                                                          |
| `persistence.enabled`      | Enable persistence                              | `false`                                                      |
| `persistence.existingClaim`| Provide an existing PersistentVolumeClaim       | `""`                                                         |
| `persistence.storageClass` | Storage class of backing PVC                    | `nil` (uses alpha storage class annotation)                  |
| `persistence.accessMode`   | Use volume as ReadOnly or ReadWrite             | `ReadWriteOnce`                                              |
| `persistence.size`         | Size of data volume                             | `8Gi`                                                        |
| `resources`                | CPU/Memory resource requests/limits             |  Memory: `256Mi`, CPU: `50m`     / Memory: `500Mi`, CPU: `500m`|
| `service.port`             | TCP port                                        | `9000`                                                       |
| `service.type`             | k8s service type exposing ports, e.g. `NodePort`| `ClusterIP`                                                  |
| `nodeSelector`             | Node labels for pod assignment                  | {}                                                           |
| `tolerations`              | Toleration labels for pod assignment            | []                                                           |
| `livenessProbe`            | Parameter for liveness probe                    | See [values.yaml](./values.yaml)                             |
| `readinessProbe`           | Parameter for readiness probe                   | See [values.yaml](./values.yaml)                             |

 see [values.yaml](./values.yaml)

## Persistence

The [superset image](https://hub.docker.com/r/alitari/superset/) stores at startup time the file `superset.db` to `/etc/superset-db` path of the container, if no file exists there.
The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning. If the PersistentVolumeClaim should not be managed by the chart, define `persistence.existingClaim`.

### Existing PersistentVolumeClaims

1. Create the PersistentVolumeClaim with name `superset-pvc` in the same namespace
1. Install the chart
```bash
$ helm install --set persistence.enabled=true,persistence.existingClaim=superset-pvc incubator/superset
```
