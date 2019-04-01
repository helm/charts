# PyPi Sever Helm Chart

This chart installs a PyPI server

## Prerequisites Details

* Kubernetes 1.6+
* PV dynamic provisioning support on the underlying infrastructure

## Todo

* Document a setup using a `ReadWriteMany` storage that is resilient and scallable.
* Maybe use part of pypicloud in order to use S3 or GCS backend storage.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/pypisever
```

## Upgrading the Charts

Updating the chart is as straightforward as updating the helm release

```bash
$ helm upgrade my-release incubator/pypisever
```

## Configuration

The following tables lists the configurable parameters of the PyPI server chart and their default values.

| Parameter                          | Description                                                    | Default                 |
| ---------------------------------- | -------------------------------------------------------------- | ----------------------- |
| `replicaCount`                     | Deployment replica count                                       | `1`                     |
| `image.repository`                 | Container image repository                                     | `pypiserver/pypiserver` |
| `image.tag`                        | Container image name                                           | `v1.2.7`                |
| `image.pullPolicy`                 | Container pull policy                                          | `IfNotPresent`          |
| `image.pullSecrets`                | Container pull secrets                                         | `[]`                    |
| `auth.actions`                     | Actions requiring authentication (comma separated list)        | `update`                |
| `auth.credentials`                 | Map of username / encoded password to write in a htpasswd file | `{}`                    |
| `ingress.enabled`                  | Ingress configuration flag                                     | `false`                 |
| `ingress.labels`                   | Ingress labels                                                 | `{}`                    |
| `ingress.annotations`              | Ingress annotations                                            | `{}`                    |
| `ingress.path`                     | Ingress path                                                   | `nil`                   |
| `ingress.tls`                      | Ingress TLS configuration                                      | `[]`                    |
| `service.type`                     | Service type                                                   | `ClusterIP`             |
| `service.port`                     | Service port                                                   | `8080`                  |
| `service.annotations`              | Service annotations                                            | `{}`                    |
| `service.labels`                   | Service labels                                                 | `{}`                    |
| `service.clusterIP`                | Service cluster IP                                             | `""`                    |
| `service.externalIPs`              | Service external IPs                                           | `[]`                    |
| `service.loadBalancerIP`           | Service load balancer IP                                       | `""`                    |
| `service.loadBalancerSourceRanges` | Service load balancer CIDR ranges                              | `[]`                    |
| `service.nodePort`                 | Service node port                                              | `nil`                   |
| `persistence.enabled`              | Persistence configuration flag                                 | `false`                 |
| `persistence.storageClass`         | Persistence storage class                                      | `nil`                   |
| `persistence.existingClaim`        | Persistent volume claim static name                            | `nil`                   |
| `persistence.accessMode`           | Persistence access mode                                        | `ReadWriteOnce`         |
| `persistence.size`                 | Persistence volume size                                        | `5Gi`                   |
| `resources`                        | Resources configuration bloc                                   | `{}`                    |
| `nodeSelector`                     | Node selector of the deployment                                | `{}`                    |
| `tolerations`                      | Tolerations configuration for the deployment                   | `[]`                    |
| `affinity`                         | Affinity of the deployment                                     | `{}`                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.
