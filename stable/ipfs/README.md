# IPFS

> [IPFS](https://ipfs.io/) is a part of the distributed web - a peer-to-peer hypermedia protocol to make the web faster, safer, and more open.

## TL;DR;

```bash
$ helm install stable/ipfs
```

## Introduction

This chart bootstraps a [IPFS](https://ipfs.io) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/ipfs
```

The command deploys IPFS on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Memcached chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | The number of replicas of go-ipfs to run | 1 |
| `service.type` | Type of the service: `ClusterIP`, `LoadBalancer` or `NodePort` | `ClusterIP` |
| `service.nameOverride` | The name to use for the service | The full name of the release |
| `persistence.enabled` | Turn on persistent storage for the IPFS data directory | `true` |
| `persistence.storageClass` | StorageClass to set for the persistent volume claim.  | The default storageclass in the cluster|
| `persistence.annotations` | Extra annotations for the persistent volume claim. | `{}` |
| `persistence.accessModes` | List of access modes for use with the persistent volume claim | `["ReadWriteOnce"]` |
| `persistence.size` | Size of the PVC for each IPFS pod, used as persistent cache | `8Gi`  |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set storage.size="20Gi" \
    stable/ipfs
```

The above command sets the disk size to 20Gi.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/ipfs
```

> **Tip**: You can use the default [values.yaml](values.yaml) as a base for customization.
