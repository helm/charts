# Goldpinger

[Goldpinger](https://github.com/bloomberg/goldpinger) makes calls between its instances for visibility and alerting.

## TL;DR;

```console
$ helm install stable/goldpinger
```

## Introduction

This chart bootstraps a [Goldpinger](https://github.com/bloomberg/goldpinger) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/goldpinger
```

The command deploys Goldpinger on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Goldpinger chart and their default values.

| Parameter                            | Description                                 | Default                                                    |
| -------------------------------      | -------------------------------             | ---------------------------------------------------------- |
| `image.repository`                   | Goldpinger image                            | `bloomberg/goldpinger`                                      |
| `image.tag`                          | Goldpinger image tag                        | `1.5.0`                                                    |
| `pullPolicy`                         | Image pull policy                           | `IfNotPresent`                                             |
| `rbac.create`                        | Install required rbac clusterrole           | `true`                                                     |
| `serviceAccount.create`              | Enable ServiceAccount creation              | `true`                                                     |
| `serviceAccount.name`                | ServiceAccount for Goldpinger pods          | `default`                                                  |
| `goldpinger.port`                    | Goldpinger app port listen to               | `80`                                                       |
| `service.type`                       | Kubernetes service type                     | `LoadBalancer`                                             |
| `service.port`                       | Service HTTP port                           | `80`                                                       |
| `service.annotations`                | Service annotations                         | `{}`                                                       |
| `ingress.enabled`                    | Enable ingress controller resource          | `false`                                                    |
| `ingress.annotations`                | Ingress annotations                         | `{}`                                                       |
| `ingress.path`                       | Ingress path                                | `/`                                                        |
| `ingress.hosts`                      | URLs to address your Goldpinger installation| `goldpinger.local`                                         |
| `ingress.tls`                        | Ingress TLS configuration                   | `[]`                                                       |
| `podAnnotations`                     | Pod annotations                             | `{}`                                                       |
| `nodeSelector`                       | Node labels for pod assignment              | `{}`                                                       |
| `tolerations`                        | List of node taints to tolerate             | `[]`                                                       |
| `affinity`                           | Map of node/pod affinities                  | `{}`                                                       |
| `resources`                          | CPU/Memory resource requests/limits         | `{}`                                                       |
| `podSecurityPolicy.enabled`          | Enable podSecuritypolicy                    | `false`                                                    |
| `podSecurityPolicy.policyName`       | PodSecurityPolicy Name                      | `unrestricted-psp`                                         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set goldpinger.port=8080,serviceAccount.name=goldpinger \
    stable/goldpinger
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/goldpinger
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Ingress

This chart provides support for Ingress resource. If you have an available Ingress Controller such as Nginx or Traefik you maybe want to set `ingress.enabled` to true and choose an `ingress.hostname` for the URL. Then, you should be able to access the installation using that address.
