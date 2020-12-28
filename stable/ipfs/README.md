# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# IPFS

> [IPFS](https://ipfs.io/) is a part of the distributed web - a peer-to-peer hypermedia protocol to make the web faster, safer, and more open.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## TL;DR;

```bash
$ helm install stable/ipfs
```

## Introduction

This chart bootstraps an [IPFS](https://ipfs.io) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

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

The following table lists the configurable parameters of the Memcached chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | The number of replicas of go-ipfs to run | 1 |
| `service.type` | Type of the service: `ClusterIP`, `LoadBalancer` or `NodePort` | `ClusterIP` |
| `service.nameOverride` | The name to use for the service | The full name of the release |
| `ingressApi.enabled` | Enables Ingress for the IPFS api | `false` |
| `ingressApi.annotations` | IPFS api ingress annotations | None: |
| `ingressApi.hosts` | IPFS api ingress accepted hostnames | None: |
| `ingressApi.tls` | IPFS api ingress TLS configuration | None: |
| `ingressGateway.enabled` | Enables Ingress for the IPFS gateway | `false` |
| `ingressGateway.annotations` | IPFS gateway ingress annotations | None: |
| `ingressGateway.hosts` | IPFS gateway ingress accepted hostnames | None: |
| `ingressGateway.tls` | IPFS gateway ingress TLS configuration | None: |
| `persistence.enabled` | Turn on persistent storage for the IPFS data directory | `true` |
| `persistence.storageClass` | StorageClass to set for the persistent volume claim.  | The default storageclass in the cluster|
| `persistence.annotations` | Extra annotations for the persistent volume claim. | `{}` |
| `persistence.accessModes` | List of access modes for use with the persistent volume claim | `["ReadWriteOnce"]` |
| `persistence.size` | Size of the PVC for each IPFS pod, used as persistent cache | `8Gi`  |
| `service.swarm.enabled` | Expose port `4001` (IPFS swarm network port) | `false` |
| `service.swarm.type` | Service type for swarm | `LoadBalancer` |
| `service.swarm.nodePort` | Desired nodePort for service of type NodePort used for swarm requests | blank ('') - will assign a dynamic node port |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set persistence.size="20Gi" \
    stable/ipfs
```

The above command sets the disk size to 20Gi.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/ipfs
```

> **Tip**: You can use the default [values.yaml](values.yaml) as a base for customization.
