# stable/gangway

ref: https://github.com/heptiolabs/gangway

An app that can be used to easily enable authentication flows via OIDC for a kubernetes cluster.

## TL;DR;

```console
$ helm install stable/gangway
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/gangway
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

## Configuration

The following table lists the configurable parameters of the chart and its default values.

|              Parameter          |                    Description                     |                     Default                      |
| ------------------------------- | -------------------------------------------------- | ------------------------------------------------ |
| `replicaCount`                  | Number of replicas                                 | `1`                                              |
| `podDisruptionBudget`           | Pod disruption budget                              | `maxUnavailable: 1`                              |
| `terminationGracePeriodSeconds` | Duration the pod needs to terminate gracefully     | `1`                                              |
| `strategy`                      | Update strategy                                    | `type: RollingUpdate`                            |
| `image.pullPolicy`              | Container image pull policy                        | `IfNotPresent`                                   |
| `image.repository`              | Container image name                               | `gcr.io/heptio-images/gangway`                   |
| `image.tag`                     | Container image tag                                |  (see `values.yaml`)                             |
| `service.type`                  | Service type (ClusterIP, NodePort or LoadBalancer) | `ClusterIP`                                      |
| `service.annotations`           | Service annotations                                | `{}`                                             |
| `service.ports`                 | Ports exposed by service                           | http                                             |
| `ingress.annotations`           | Ingress annotations                                | `{}`                                             |
| `ingress.enabled`               | Enables Ingress                                    | `false`                                          |
| `ingress.hosts`                 | Ingress accepted hostnames                         | `["gangway.cluster.local"]`                      |
| `ingress.path`                  | Ingress path                                       | `/`                                              |
| `ingress.tls`                   | Ingress TLS configuration                          | `[]`                                             |
| `ports`                         | Ports exposed by app container                     | http                                             |
| `resources`                     | Pod resource requests & limits                     | `{}`                                             |
| `priorityClassName`             | Priority class name                                | ``                                               |
| `nodeSelector`                  | Node selector                                      | `{}`                                             |
| `tolerations`                   | Tolerations                                        | `[]`                                             |
| `affinity`                      | Affinity or Anti-Affinity                          | `{}`                                             |
| `podAnnotations`                | Pod annotations                                    | `{}`                                             |
| `podLabels`                     | Pod labels                                         | `{}`                                             |
| `livenessProbe`                 | Liveness probe settings for app container          | (see `values.yaml`)                              |
| `readinessProbe`                | Readiness probe settings for app container         | (see `values.yaml`)                              |
| `podLabels`                     | Pod labels                                         | `{}`                                             |
| `securityContext`               | Security context                                   | `{}`                                             |
| `secrets`                       | Secret key values for pods                         | (see `values.yaml`)                              |
| `env`                           | Environment variables for pods                     | (see `values.yaml`)                              |
| `configFiles`                   | Configuration files                                | (see `values.yaml`)                              |
