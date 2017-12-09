# nginx-ingress

[Ibex Dashboard](https://github.com/CatalystCode/ibex-dashboard) is a dashboarding application that enables building dashboard and templates. It mainly supports Application Insights but data sources and visual components are easily extendable.

## TL;DR;

```console
$ helm install stable/ibex-dashboard
```

## Introduction

This chart bootstraps an ibex-dashboard deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/ibex-dashboard
```

The command deploys ibex-dashboard on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Ibex chart and their default values.

| Parameter                            | Description                                | Default                                                    |
| -------------------------------      | -------------------------------            | ---------------------------------------------------------- |
| `image`                              | Ibex image                            | `catalystcode/ibex-dashboard:{VERSION}`                              |
| `imagePullPolicy`                    | Image pull policy                          | `IfNotPresent`                                             |
| `serviceType`                        | Kubernetes Service type                    | `LoadBalancer`                                             |
| `internalPort`                        | Kubernetes Service type                    | `4000`                                             |
| `externalPort`                        | Kubernetes Service type                    | `80`                                             |
| `ingress.enabled`                    | Enable ingress controller resource         | `false`                                                    |
| `ingress.hostname`                   | URL to address your Ibex installation | `ibex.local`                                          |
| `ingress.tls`                        | Ingress TLS configuration                  | `[]`                                          |
| `persistence.enabled`                | Enable persistence using PVC               | `true`                                                     |
| `persistence.storageClass`           | PVC Storage Class                          | `slow` (uses alpha storage class annotation)                |
| `persistence.accessMode`             | PVC Access Mode                            | `ReadWriteOnce`                                            |
| `persistence.size`                   | PVC Storage Request                        | `8Gi`                                                     |
| `persistence.existingClaim`                   | Enable using existing PVC Storage Claim               | `false`                                          |
| `persistence.existingClassName`                   | Enable using existing PVC Storage ClassName           | `false`                                          |
| `persistence.storage.provisioner`                   | Storage provisioner                        | `kubernetes.io/azure-disk`                                                     |
| `persistence.storage.provisioner.parameters`                   | Storage provisioner params                        | `skuName: Standard_LRS,location: eastus`                                                     |

```console
$ helm install stable/ibex-dashboard --name my-release \
    --set controller.stats.enabled=true
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install stable/ibex-dashboard --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

Ibex image stores the data and configurations at the `/usr/src/app/server/dashboards/persistent` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in Microsoft Azure, GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.