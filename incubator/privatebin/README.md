# privatebin
This is a kubernetes chart to deploy [PrivateBin](https://github.com/PrivateBin/PrivateBin).

## Quick Start
To install the privatebin chart with default options:

```bash
helm repo update
helm fetch incubator/privatebin
tar -xvzf privatebin-*.tgz
helm install privatebin/
```

## Installation
1. Download the chart

    ```bash
    helm repo update
    helm fetch incubator/privatebin
    tar -xvzf privatebin-*.tgz
    ```

1. Customize your values.yaml for your needs. Add [custom config.php](https://github.com/PrivateBin/PrivateBin/blob/master/cfg/conf.sample.php)

1. Deploy with helm

    ```bash
    helm install \
      --name your-release \
      --values your-values.yaml \
      privatebin/
    ```

## Configuration
See values.yaml for full documentation

|              Parameter      |                    Description                     |                     Default                      |
| --------------------------- | -------------------------------------------------- | ------------------------------------------------ |
| `replicaCount`              | Number of replicas                                 | `1`                                              |
| `image.repository`          | Container image name                               | `privatebin/nginx-fpm-alpine`                    |
| `image.tag`                 | Container image tag                                | `1.2.1`                                          |
| `image.pullPolicy`          | Container image pull policy                        | `IfNotPresent`                                   |
| `nameOverride`              | Name Override                                      | `""`                                             |
| `fullnameOverride`          | FullName Override                                  | `""`                                             |
| `service.type`              | Service type (ClusterIP, NodePort or LoadBalancer) | `ClusterIP`                                      |
| `service.ports`             | Ports exposed by service                           | `80`                                             |
| `ingress.enabled`           | Enables Ingress                                    | `false`                                          |
| `ingress.annotations`       | Ingress annotations                                | `{}`                                             |
| `ingress.hosts.host`        | Ingress accepted hostnames                         | `privatebin.local`                               |
| `ingress.hosts.path`        | Ingress path                                       | `\`                                              |
| `ingress.tls`               | Ingress TLS configuration                          | `[]`                                             |
| `resources`                 | Pod resource requests & limits                     | `{}`                                             |
| `nodeSelector`              | Node selector                                      | `{}`                                             |
| `tolerations`               | Tolerations                                        | `[]`                                             |
| `affinity`                  | Affinity or Anti-Affinity                          | `{}`                                             |
| `configs`                   | List of files to put in cfg path                   | `{}`                                             |

