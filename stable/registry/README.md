# Registry

The [Docker Registry](https://docs.docker.com/registry/) is a stateless, highly scalable server side application that stores and lets you distribute Docker images.

## TL;DR;

```console
$ helm install stable/registry
```

## Introduction

This chart bootstraps a private Docker Registry deployment.  It is based on the Kubernetes document for setting up a [Private Docker Registry](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/registry).

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure (only when persisting data)

## TODO

This chart should eventually support the post-configuration options documented in the [registry addon documentation](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/registry):

- [Enable TLS](https://github.com/kubernetes/kubernetes/blob/master/cluster/addons/registry/tls/README.md)
- [Enable authentication](https://github.com/kubernetes/kubernetes/blob/master/cluster/addons/registry/auth/README.md)
- Make proposed [kube-registry-proxy](https://github.com/kubernetes/charts/pull/286) chart a dependency.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/registry
```

The command deploys the Registry on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Registry chart and their default values.

| Parameter                         | Description                             | Default                                                   |
| --------------------------------- | --------------------------------------- | --------------------------------------------------------- |
| `image.repository`                | Registry repository                     | `registry`                                                |
| `image.tag`                       | Registry image version                  | `2.6.0`                                                   |
| `image.pullPolicy`                | Image pull policy                       | `IfNotPresent`                                            |
| `service.type`                    | k8s Service Type                        | `ClusterIP`                                               |
| `service.nodePort`                | Optionally select a nodePort if service.Type is `NodePort`  | `nil`                                 |
| `service.externalPort`            | k8s External Service Port               | `5000`                                                    |
| `service.internalPort`            | k8s Internal Container Port             | `5000`                                                    |
| `persistence.enabled`             | Enable persistence using PVC            | `true`                                                    |
| `persistence.storageClass`        | PVC Storage Class for Registry volume   | `nil`                                                     |
| `persistence.accessMode`          | PVC Access Mode for Registry volume     | `ReadWriteOnce`                                           |
| `persistence.size`                | PVC Storage Request for Registry volume | `8Gi`                                                     |
| `resources`                       | CPU/Memory resource requests/limits     | Memory: `512Mi`, CPU: `100m`                              |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set service.type=NodePort,service.nodePort=30500 \
    stable/registry
```

This configures the registry to be reachable externally from the cluster on port `30500`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/registry
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

Any images uploaded to the Registry are stored in the `/var/lib/registry` path of the container.  Persistent Volume Claims can be used to keep the data across deployments. 
