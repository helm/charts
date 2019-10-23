###### based on [dpage/pgadmin4]

# Helm Chart for pgAdmin

#### Table of Contents

1. [Description][Description]
2. [Setup][Setup]
    * [Configuration][Configuration]
    * [Install the Chart][Install the Chart]
    * [Uninstall the Chart][Uninstall the Chart]

## Description

pgAdmin is a web based administration tool for PostgreSQL database.

## Setup

### Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `replicaCount` | Number of pgadmin replicas | `1` |
| `image.repository` | Docker image | `dpage/pgadmin4` |
| `image.tag` | Docker image tag | `4.14` |
| `image.pullPolicy` | Docker image pull policy | `IfNotPresent` |
| `service.type` | Service type (ClusterIP, NodePort or LoadBalancer) | `ClusterIP` |
| `service.port` | Service port | `80` |
| `ingress.enabled` | Enables Ingress | `false` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts` | Ingress accepted hostnames | `nil` |
| `ingress.tls` | Ingress TLS configuration | `[]` |
| `ingress.path` | Ingress path mapping | `` |
| `env.username` | pgAdmin default email | `pgadmin@domain.com` |
| `env.password` | pgAdmin default password | `SuperSecret` |
| `persistence` | Persistent enabled/disabled | `true` |
| `persistence.accessMode` | Persistent Access Mode | `ReadWriteOnce` |
| `persistence.size` | Persistent volume size | `10Gi` |
| `resources` | CPU/memory resource requests/limits | `{}` |
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `tolerations` | Node tolerations for pod assignment | `[]` |
| `affinity` | Node affinity for pod assignment | `{}` |

### Install the Chart

To install the chart with the release name `my-release`:

```console
helm install --name my-release .
```

### Uninstall the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete --purge my-release
```

The command removes nearly all the Kubernetes components associated with the chart and deletes the release.

[Overview]: #overview
[Description]: #description
[Setup]: #setup
[Configuration]: #configuration
[Install the Chart]: #install-the-chart
[Uninstall the Chart]: #uninstall-the-chart

[dpage/pgadmin4]: https://hub.docker.com/r/dpage/pgadmin4
[cert-manager]: https://github.com/helm/charts/tree/master/stable/cert-manager
[letsencrypt]: https://letsencrypt.org/
