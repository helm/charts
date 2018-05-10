# CoreOS vault-operator

[vault-operator](https://coreos.com/blog/introducing-vault-operator-project) Simplify vault cluster
configuration and management.

__DISCLAIMER:__ While this chart has been well-tested, the vault-operator is still currently in beta.
Current project status is available [here](https://github.com/coreos/vault-operator).

## Introduction

This chart bootstraps a vault-operator and allows the deployment of vault cluster(s). It depends on the `etcd-operator` being installed.

## Official Documentation

Official project documentation found [here](https://github.com/coreos/vault-operator)

## Prerequisites

- Kubernetes 1.8+
- __Suggested:__ RBAC setup for the Kubernetes cluster

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install incubator/vault-operator --name my-release
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components EXCEPT the persistent volume.

## Configuration

The following table lists the configurable parameters of the etcd-operator chart and their default values.

| Parameter                                         | Description                                                          | Default                                        |
| ------------------------------------------------- | -------------------------------------------------------------------- | ---------------------------------------------- |
| `rbac.create`                                     | install required RBAC service account, roles and rolebindings        | `true`                                         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install --name my-release --set image.tag=v0.1.9 incubator/vault-operator
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm install --name my-release --values values.yaml incubator/vault-operator
```

## RBAC
By default the chart will install the recommended RBAC roles and rolebindings.

To determine if your cluster supports this running the following:

```console
$ kubectl api-versions | grep rbac
```

You also need to have the following parameter on the api server. See the following document for how to enable [RBAC](https://kubernetes.io/docs/admin/authorization/rbac/)

```
--authorization-mode=RBAC
```

If the output contains "beta" or both "alpha" and "beta" you can may install rbac by default, if not, you may turn RBAC off as described below.

### RBAC role/rolebinding creation

RBAC resources are enabled by default. To disable RBAC do the following:

```console
$ helm install --name my-release incubator/vault-operator --set rbac.create=false
```

### Changing RBAC manifest apiVersion

By default the RBAC resources are generated with the "v1beta1" apiVersion. To use "v1alpha1" do the following:

```console
$ helm install --name my-release incubator/vault-operator --set rbac.install=true,rbac.apiVersion=v1alpha1
```
