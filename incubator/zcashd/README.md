# Zcashd

[Zcash](https://z.cash) is the first open, permissionless cryptocurrency that can fully protect the privacy of transactions using zero-knowledge cryptography.

## Introduction

This chart bootstraps a single node Zcash deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/zcashd
```

The command deploys zcashd on the Kubernetes cluster in the default configuration.
The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the zcashd chart and their default values.

Parameter                  | Description                        | Default
-----------------------    | ---------------------------------- | ----------------------------------------------------------
`image.repository`         | Image source repository            | `arilot/docker-zcashd`
`image.tag`                | Image tag                          | `1.0`
`image.pullPolicy`          | Image pull policy                  | `IfNotPresent`
`service.rpcPort`          | RPC port                           | `8232`
`service.p2pPort`          | P2P port                           | `8233`
`service.testnetPort`      | Testnet port                       | `18232`
`persistence.enabled`      | Create a volume to store data      | `true`
`persistence.accessMode`   | ReadWriteOnce or ReadOnly          | `ReadWriteOnce`
`persistence.size`         | Size of persistent volume claim    | `300Gi`
`resources`                | CPU/Memory resource requests/limits| `{}`
`configurationFile`        | Config file ConfigMap entry        |


For more information about Zcash configuration please see example [zcash.conf](https://github.com/zcash/zcash/blob/master/contrib/debian/examples/zcash.conf).

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/zcashd
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The zcashd image stores the Zcashd node data (Blockchain and wallet) and configurations at the `/root` path of the container.

By default a PersistentVolumeClaim is created and mounted into that directory. In order to disable this functionality
you can change the values.yaml to disable persistence and use an emptyDir instead.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

!!! WARNING !!!

Please NOT use emptyDir for production cluster! Your wallets will be lost on container restart!

## Custom zcashd configuration file

```yaml
configurationFile:
  zcash.conf: |-
    onlynet=IPv4
    server=1
    rpcuser=rpcuser
    rpcpassword=rpcpassword
    printtoconsole=1
```
