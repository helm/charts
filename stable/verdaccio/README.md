# Verdaccio

[Verdaccio](http://www.verdaccio.org) is a lightweight private
[NPM](https://www.npmjs.com) proxy registry.

## TL;DR;

```
$ helm install stable/verdaccio
```

## Introduction

This chart bootstraps a [Verdaccio](https://github.com/verdaccio/verdaccio)
deployment on a [Kubernetes](http://kubernetes.io) cluster using the
[Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.7+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```
$ helm install --name my-release stable/verdaccio
```

The command deploys Verdaccio on the Kubernetes cluster in the default
configuration. The [configuration](#configuration) section lists the parameters
that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following table lists the configurable parameters of the Verdaccio chart
and their default values.

| Parameter                          | Description                                                     | Default                                                  |
| ---------------------------------- | --------------------------------------------------------------- | -------------------------------------------------------- |
| `customConfigMap`                  | Use a custom ConfigMap                                          | `false`                                                  |
| `image.pullPolicy`                 | Image pull policy                                               | `IfNotPresent`                                           |
| `image.repository`                 | Verdaccio container image repository                            | `verdaccio/verdaccio`                                    |
| `image.tag`                        | Verdaccio container image tag                                   | `3.11.6`                                                 |
| `nodeSelector`                     | Node labels for pod assignment                                  | `{}`                                                     |
| `persistence.accessMode`           | PVC Access Mode for Verdaccio volume                            | `ReadWriteOnce`                                          |
| `persistence.enabled`              | Enable persistence using PVC                                    | `true`                                                   |
| `persistence.existingClaim`        | Use existing PVC                                                | `nil`                                                    |
| `persistence.mounts`               | Additional mounts                                               | `nil`                                                    |
| `persistence.size`                 | PVC Storage Request for Verdaccio volume                        | `8Gi`                                                    |
| `persistence.storageClass`         | PVC Storage Class for Verdaccio volume                          | `nil`                                                    |
| `persistence.volumes`              | Additional volumes                                              | `nil`                                                    |
| `podAnnotations`                   | Annotations to add to each pod                                  | `{}`                                                     |
| `replicaCount`                     | Desired number of pods                                          | `1`                                                      |
| `resources`                        | CPU/Memory resource requests/limits                             | `{}`                                                     |
| `resources`                        | pod resource requests & limits                                  | `{}`                                                     |
| `service.annotations`              | Annotations to add to service                                   | none                                                     |
| `service.clusterIP`                | IP address to assign to service                                 | `""`                                                     |
| `service.externalIPs`              | Service external IP addresses                                   | `[]`                                                     |
| `service.loadBalancerIP`           | IP address to assign to load balancer (if supported)            | `""`                                                     |
| `service.loadBalancerSourceRanges` | List of IP CIDRs allowed access to load balancer (if supported) | `[]`                                                     |
| `service.port`                     | Service port to expose                                          | `4873`                                                   |
| `service.nodePort`                 | Service port to expose                                          | none                                                     |
| `service.type`                     | Type of service to create                                       | `ClusterIP`                                              |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```
$ helm install --name my-release \
  --set service.type=LoadBalancer \
    stable/verdaccio
```

The above command sets the service type LoadBalancer.

Alternatively, a YAML file that specifies the values for the above parameters
can be provided while installing the chart. For example,

```
$ helm install --name my-release -f values.yaml stable/verdaccio
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Custom ConfigMap

When creating a new chart with this chart as a dependency, CustomConfigMap can
be used to override the default config.yaml provided. It also allows for
providing additional configuration files that will be copied into
`/verdaccio/conf`. In the parent chart's values.yaml, set the value to true and
provide the file `templates/config.yaml` for your use case.

### Persistence

The Verdaccio image stores persistence under `/verdaccio/storage` path of the
container. A dynamically managed Persistent Volume Claim is used to keep the
data across deployments, by default. This is known to work in GCE, AWS, and
minikube.
Alternatively, a previously configured Persistent Volume Claim can be used.

It is possible to mount several volumes using `Persistence.volumes` and
`Persistence.mounts` parameters.

#### Existing PersistentVolumeClaim

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart

```bash
$ helm install --name my-release \
    --set persistence.existingClaim=PVC_NAME \
    stable/verdaccio
```
