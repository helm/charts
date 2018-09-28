# Dashd

[Dash](https://www.dash.org/) is an experimental new digital currency that enables anonymous, instant payments to anyone, anywhere in the world.

## Introduction

This chart bootstraps a single node Dash deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/dashd
```

The command deploys dashd on the Kubernetes cluster in the default configuration.
The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the dashd chart and their default values.

Parameter                  | Description                        | Default
-----------------------    | ---------------------------------- | ----------------------------------------------------------
`image.repository`         | Image source repository name       | `arilot/docker-dashd`
`image.tag`                 | `dashd` image tag.                 | `1.0`
`image.pullPolicy`          | Image pull policy                  | `IfNotPresent`
`service.rpcPort`          | RPC port                           | `9998`
`service.p2pPort`          | P2P port                           | `9999`
`service.testnetPort`      | Testnet port                       | `19998`
`persistence.enabled`      | Create a volume to store data      | `true`
`persistence.accessMode`   | ReadWriteOnce or ReadOnly          | `ReadWriteOnce`
`persistence.size`         | Size of persistent volume claim    | `300Gi`
`resources`                | CPU/Memory resource requests/limits| `{}`
`configurationFile`        | Config file ConfigMap entry        |


Dash is Bitcoin fork. For more information about Dash configuration please see example [bitcoin.conf](https://github.com/dash-project/dash/blob/master/contrib/debian/examples/bitcoin.conf).

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/dashd
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The dashd image stores the Dashd node data (Blockchain and wallet) and configurations at the `/dash` path of the container.

By default a PersistentVolumeClaim is created and mounted into that directory. In order to disable this functionality
you can change the values.yaml to disable persistence and use an emptyDir instead.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

!!! WARNING !!!

Please NOT use emptyDir for production cluster! Your wallets will be lost on container restart!

## Custom dashd configuration file

```yaml
configurationFile:
  dash.conf: |-
    onlynet=IPv4
    server=1
    rpcuser=rpcuser
    rpcpassword=rpcpassword
    rpcconnect=127.0.0.1
    disablewallet=0
    printtoconsole=1
```
