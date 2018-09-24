# CoreOS Update Operator

[container-linux-update-operator](https://github.com/coreos/container-linux-update-operator) controls CoreOS instances update behavior.


## Introduction

This chart bootstraps and starts a container-linux-update-operator install.

## Documentation

See the [official docs](https://github.com/coreos/container-linux-update-operator)

## Requirements

* Kubernetes 1.9+
* RBAC (can be disabled, but highly recommended)
* `locksmithd` masked

## Installation

To install `cluo`, or some other release name, issue this:

```
$ helm install --name cluo stable/container-linux-update-operator
```

## Configuration

| Parameter          | Description             | Default                                          |
|--------------------|-------------------------|--------------------------------------------------|
| `image.repository` | Image Repository to use | `quay.io/coreos/container-linux-update-operator` |
| `image.tag`        | Image tag to use        | `v0.7.0`                                         |
| `rbac.create`      | Enable RBAC creation    | `true`                                           |

## Disable Locksmithd

You can mask `locksmithd` via kops, with the following:

```yaml
$ kops edit cluster

spec:
  updatePolicy: external
  ...
```

## RBAC

By default, RBAC is created. To verify you support RBAC in your cluster, issue this command:

```
$ kubectl api-versions | grep rbac
```

If you don't have RBAC enabled, please read [the following on how to enable RBAC](https://kubernetes.io/docs/admin/authorization/rbac/)

### Disable RBAC (NOT RECOMMENDED)

Install the chart as such:

```
$ helm install --name cluo --set rbac.create=false stable/container-linux-update-operator
```
