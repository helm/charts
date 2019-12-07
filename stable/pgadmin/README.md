###### based on [dpage/pgadmin4]

# pgAdmin

[pgAdmin](https://www.pgadmin.org/) is the leading Open Source management tool for Postgres, the world’s most advanced Open Source database. pgAdmin is designed to meet the needs of both novice and experienced Postgres users alike, providing a powerful graphical interface that simplifies the creation, maintenance and use of database objects.

## TL;DR;

```console
$ helm install stable/pgadmin
```

## Introduction

This chart bootstraps a [pgAdmin](https://www.pgadmin.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Install the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/pgadmin
```

The command deploys pgAdmin on the Kubernetes cluster in the default configuration. The configuration section lists the parameters that can be configured durign installation.

> **Tip**: List all releases using `helm list`

## Uninstall the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete --purge my-release
```

The command removes nearly all the Kubernetes components associated with the chart and deletes the release.

## Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `replicaCount` | Number of pgadmin replicas | `1` |
| `image.repository` | Docker image | `dpage/pgadmin4` |
| `image.tag` | Docker image tag | `4.15` |
| `image.pullPolicy` | Docker image pull policy | `IfNotPresent` |
| `service.type` | Service type (ClusterIP, NodePort or LoadBalancer) | `ClusterIP` |
| `service.port` | Service port | `80` |
| `ingress.enabled` | Enables Ingress | `false` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts` | Ingress accepted hostnames | `nil` |
| `ingress.tls` | Ingress TLS configuration | `[]` |
| `ingress.path` | Ingress path mapping | `` |
| `env.username` | pgAdmin default email | `chart@example.local` |
| `env.password` | pgAdmin default password | `SuperSecret` |
| `persistence` | Persistent enabled/disabled | `true` |
| `persistence.accessMode` | Persistent Access Mode | `ReadWriteOnce` |
| `persistence.size` | Persistent volume size | `10Gi` |
| `resources` | CPU/memory resource requests/limits | `{}` |
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `tolerations` | Node tolerations for pod assignment | `[]` |
| `affinity` | Node affinity for pod assignment | `{}` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install stable/pgadmin --name my-release \
  --set env.password=SuperSecret
```

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,

```bash
$ helm install stable/pgadmin --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

[dpage/pgadmin4]: https://hub.docker.com/r/dpage/pgadmin4
