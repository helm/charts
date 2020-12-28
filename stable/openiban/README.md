# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# OpenIBAN

[OpenIBAN](https://github.com/fourcube/goiban-service) implements a basic REST Web-service for validating IBAN account numbers in GO.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## TL;DR;

```bash
$ helm install stable/openiban
```

## Introduction

This chart bootstraps an [OpenIBAN](https://github.com/fourcube/goiban-service) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm update --install my-release stable/openiban
```

The command deploys OpenIBAN on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Redmine chart and their default values.

|            Parameter              |              Description                 |                          Default                        | 
| --------------------------------- | ---------------------------------------- | ------------------------------------------------------- |
| `replicaCount`                    | Number of replicas to start              | `1`                                                     |
| `image.repository`                | Image name        	               | `fourcube/openiban`                                     |
| `image.tag`                       | Image tag		                       | `1.0.1`                                                 |
| `image.pullPolicy`                | Image pull policy                        | `IfNotPresent`                                          |
| `service.type`                    | Desired service type                                | `ClusterIP`               |
| `service.port`                    | Service exposed port                               | `8080`                    |
| `rbac.create` 		            | Use Role-based Access Control		  | `true`	      |
| `serviceAccount.create`	         | Should we create a ServiceAccount	          | `true`	      |
| `serviceAccount.name`		         | Name of the ServiceAccount to use           | `null`		      |
| `ingress.enabled`                 | Enable or disable the ingress            | `false`                                                 |
| `ingress.hosts`                   | The virtual host name(s)                 | `{}`                                 |
| `ingress.annotations`             | An array of service annotations          | `nil`                                                   |
| `ingress.tls[i].secretName`       | The secret kubernetes.io/tls             | `nil`                                                   |
| `ingress.tls[i].hosts[j]`         | The virtual host name                    | `nil`                                                   |
| `resources`                       | Resources allocation (Requests and Limits) | `{}` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm upgrade --install my-release \
  --set replicaCount=2 \
    stable/openiban
```

The above command enables starts 2 replicas.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
$ helm upgrade --install my-release -f values.yaml stable/openiban
```

> **Tip**: You can use the default [values.yaml](values.yaml)
