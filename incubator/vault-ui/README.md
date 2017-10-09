# Vault-UI Helm Chart

This directory contains a Kubernetes chart to deploy a Vault-UI server.

## Prerequisites Details

* Kubernetes 1.5

## Chart Details

This chart will do the following:

* Implement a Vault-UI deployment

## Installing the Chart

To install the chart, use the following:

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/vault --set vaultUI.vault.urlDefault="http://vault:8200"
```

## Configuration

The following tables lists the configurable parameters of the vault-ui chart and their default values.

|       Parameter         |           Description               |                         Default                     |
|-------------------------|-------------------------------------|-----------------------------------------------------|
| `image.pullPolicy`      | Container pull policy               | `IfNotPresent`                                      |
| `image.repository`      | Container image to use              | `djenriquez/vault-ui`                               |
| `image.tag`             | Container image tag to deploy       | `2.2.0`                                             |
| `vaultUI.vault.urlDefault` | Vault endpoint URL               | None                                                |
| `vaultUI.vault.authDefault` | Vault-UI default auth method    | None                                                |
| `replicaCount`          | k8s replicas                        | `1`                                                 |
| `resources.limits.cpu`  | Container requested CPU             | `nil`                                               |
| `resources.limits.memory` | Container requested memory        | `nil`                                               |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.
