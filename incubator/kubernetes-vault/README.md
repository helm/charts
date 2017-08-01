# Kubernetes-Vault

The [Kubernetes-Vault](https://github.com/Boostport/kubernetes-vault) project allows pods to automatically receive a Vault token using Vault's AppRole auth backend.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- Hashicorp Vault deployed and running
- Reviewed [sample deployments](https://github.com/Boostport/kubernetes-vault/blob/master/deployments/README.md)

## Installing the Chart

To install the chart with the release name `my-release`

```bash
$ helm install --name my-release 
```

For kubernetes 1.6+ with rbac enabled:

```bash
$ helm install --name my-release -set rbac.install=true
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

## Configuration

The following tables lists the configurable parameters of the Sysdig chart and their default values.

|      Parameter              |          Description                 |                         Default           |
|-----------------------------|--------------------------------------|-------------------------------------------|
| `configmap.kubernetes-vault.yml`          | configmap Data                      | default set, please override |
| `configmapExternalCA.kubernetes-vault.yml`| configmap Data for external CA case | default set, please override |
| `deployment.image.repository`             | The image repository to pull from   | boostport/kubernetes-vault   |
| `deployment.image.tag`                    | The image tag to pull               | latest                       |
| `deployment.image.pullPolicy`             | The Image pull policy               | `Always`                     |
| `deployment.replicaCount`                 | Number of replicated pod instances  | 3                            |
| `externalCA`                              | True if using external CA           | false                        |
| `rbac.apiVersion`                         | The current rbac api version        | `v1beta1`                    |
| `rbac.create`                             | Create RBAC if true                 | false                        |
| `rbac.serviceAccountName`                 | Define service account name to use  | `kubernetes-vault`           |
| `service.servicePort`                     | Port to expose                      | 80                           |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

We strongly suggest for this chart the use of a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/kubernetes-vault
```
