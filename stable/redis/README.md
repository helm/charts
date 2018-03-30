# Redis

[Redis](http://redis.io/) is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

## TL;DR;

```bash
$ helm install stable/redis
```

## Introduction

This chart bootstraps a [Redis](https://github.com/bitnami/bitnami-docker-redis) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/redis
```

The command deploys Redis on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Redis chart and their default values.

|           Parameter           |                Description                        |           Default            |
|-------------------------------|-------------------------------------------------- |------------------------------|
| `image`                       | Redis image                                       | `bitnami/redis:{VERSION}`    |
| `imagePullPolicy`             | Image pull policy                                 | `IfNotPresent`               |
| `serviceType`                 | Kubernetes Service type                           | `ClusterIP`                  |
| `usePassword`                 | Use password                                      | `true`                       |
| `redisPassword`               | Redis password                                    | Randomly generated           |
| `redisDisableCommands`        | Comma-separated list of Redis commands to disable | `FLUSHDB,FLUSHALL`           |
| `args`                        | Redis command-line args                           | []                           |
| `redisExtraFlags`             | Redis additional command line flags               | []                           |
| `persistence.enabled`         | Use a PVC to persist data                         | `true`                       |
| `persistence.path`            | Path to mount the volume at, to use other images  | `/bitnami`                   |
| `persistence.subPath`         | Subdirectory of the volume to mount at            | `""`                         |
| `persistence.existingClaim`   | Use an existing PVC to persist data               | `nil`                        |
| `persistence.storageClass`    | Storage class of backing PVC                      | `generic`                    |
| `persistence.accessMode`      | Use volume as ReadOnly or ReadWrite               | `ReadWriteOnce`              |
| `persistence.size`            | Size of data volume                               | `8Gi`                        |
| `resources`                   | CPU/Memory resource requests/limits               | Memory: `256Mi`, CPU: `100m` |
| `metrics.enabled`             | Start a side-car prometheus exporter              | `false`                      |
| `metrics.image`               | Exporter image                                    | `oliver006/redis_exporter`   |
| `metrics.imageTag`            | Exporter image                                    | `v0.11`                      |
| `metrics.imagePullPolicy`     | Exporter image pull policy                        | `IfNotPresent`               |
| `metrics.resources`           | Exporter resource requests/limit                  | Memory: `256Mi`, CPU: `100m` |
| `nodeSelector`                | Node labels for pod assignment                    | {}                           |
| `tolerations`                 | Toleration labels for pod assignment              | []                           |
| `networkPolicy.enabled`       | Enable NetworkPolicy                              | `false`                      |
| `networkPolicy.allowExternal` | Don't require client label for connections        | `true`                       |
| `service.annotations`         | annotations for redis service                     | {}                           |
| `service.loadBalancerIP`      | loadBalancerIP if service type is `LoadBalancer`  | ``                           |
| `securityContext.enabled`     | Enable security context                           | `true`                       |

The above parameters map to the env variables defined in [bitnami/redis](http://github.com/bitnami/bitnami-docker-redis). For more information please refer to the [bitnami/redis](http://github.com/bitnami/bitnami-docker-redis) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set redisPassword=secretpassword \
    stable/redis
```

The above command sets the Redis server password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/redis
```

> **Tip**: You can use the default [values.yaml](values.yaml)
> **Note for minikube users**: Current versions of minikube (v0.24.1 at the time of writing) provision `hostPath` persistent volumes that are only writable by root. Using chart defaults cause pod failure for the Redis pod as it attempts to write to the `/bitnami` directory. Consider installing Redis with `--set persistence.enabled=false`. See minikube issue [1990](https://github.com/kubernetes/minikube/issues/1990) for more information.

## NetworkPolicy

To enable network policy for Redis, install
[a networking plugin that implements the Kubernetes NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin),
and set `networkPolicy.enabled` to `true`.

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting
the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

    kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"

With NetworkPolicy enabled, only pods with the generated client label will be
able to connect to Redis. This label will be displayed in the output
after a successful install.

## Persistence

The [Bitnami Redis](https://github.com/bitnami/bitnami-docker-redis) image stores the Redis data and configurations at the `/bitnami` path of the container.

By default, the chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning. If a Persistent Volume Claim already exists, specify it during installation.

### Existing PersistentVolumeClaim

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart

```bash
$ helm install --set persistence.existingClaim=PVC_NAME redis
```

## Metrics

The chart optionally can start a metrics exporter for [prometheus](https://prometheus.io). The metrics endpoint (port 9121) is exposed in the service. Metrics can be scraped from within the cluster using something similar as the described in the [example Prometheus scrape configuration](https://github.com/prometheus/prometheus/blob/master/documentation/examples/prometheus-kubernetes.yml). If metrics are to be scraped from outside the cluster, the Kubernetes API proxy can be utilized to access the endpoint.
