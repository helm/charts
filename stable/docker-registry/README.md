# Docker Registry Helm Chart

This directory contains a Kubernetes chart to deploy a private Docker Registry.

## Prerequisites Details

* PV support on underlying infrastructure (if persistence is required)

## Chart Details

This chart will do the following:

* Implement a Docker registry deployment

## Installing the Chart

To install the chart, use the following:

```console
$ helm install stable/docker-registry
```

## Configuration

The following tables lists the configurable parameters of the vault chart and
their default values.

|       Parameter            |           Description                       |                         Default                     |
|----------------------------|---------------------------------------------|-----------------------------------------------------|
| `image.pullPolicy`         | Container pull policy                       | `IfNotPresent`                                      |
| `image.repository`         | Container image to use                      | `registry`                                          |
| `image.tag`                | Container image tag to deploy               | `2.6.2`                                             |
| `persistence.accessMode`   | Access mode to use for PVC                  | `ReadWriteOnce`                                     |
| `persistence.enabled`      | Whether to use a PVC for the Docker storage | `false`                                             |
| `persistence.size`         | Amount of space to claim for PVC            | `10Gi`                                              |
| `persistence.storageClass` | Storage Class to use for PVC                | `-`                                                 |
| `replicaCount`             | k8s replicas                                | `1`                                                 |
| `resources.limits.cpu`     | Container requested CPU                     | `nil`                                               |
| `resources.limits.memory`  | Container requested memory                  | `nil`                                               |
| `storage`                  | Storage system to use                       | `fileststem`                                        |
| `tlsSecretName`            | Name of secret for TLS certs                | `nil`                                               |
| `secrets.s3.accessKey`     | Access Key for S3 configuration             | `nil`                                               |
| `secrets.s3.secretKey`     | Secret Key for S3 configuration             | `nil`                                               |
| `haSharedSecret`           | Shared secret for Registry                  | `nil`                                               |
| `configData`               | Configuration hash for docker               | `nil`                                               |

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`.
