# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Bitcoind

[Bitcoin](https://bitcoin.org/) uses peer-to-peer technology to operate with no central authority or banks;
managing transactions and the issuing of bitcoins is carried out collectively by the network.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## Introduction

This chart bootstraps a single node Bitcoin deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.
Docker image was taken from [Bitcoind for Docker](https://github.com/kylemanna/docker-bitcoind) - many thanks!

## Prerequisites

- Kubernetes 1.10+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/bitcoind
```

The command deploys bitcoind on the Kubernetes cluster in the default configuration.
The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the bitcoind chart and their default values.

Parameter                 	 	| Description                        				| Default
------------------------------- | ------------------------------------------------- | ----------------------------------------------------------
`image.repository`         		| Image source repository name       				| `arilot/docker-bitcoind`
`image.tag`                		| `bitcoind` release tag.            				| `0.17.1`
`image.pullPolicy`         		| Image pull policy                  				| `IfNotPresent`
`service.rpcPort`          		| RPC port                           				| `8332`
`service.p2pPort`          		| P2P port                           				| `8333`
`service.testnetPort`      		| Testnet port                       				| `18332`
`service.testnetP2pPort`   		| Testnet p2p ports                  				| `18333`
`service.selector`         		| Node selector                      				| `tx-broadcast-svc`
`persistence.enabled`      		| Create a volume to store data      				| `true`
`persistence.accessMode`   		| ReadWriteOnce or ReadOnly          				| `ReadWriteOnce`
`persistence.size`         		| Size of persistent volume claim    				| `300Gi`
`resources`                		| CPU/Memory resource requests/limits				| `{}`
`configurationFile`        		| Config file ConfigMap entry      				    |
`terminationGracePeriodSeconds` | Wait time before forcefully terminating container | `30`

For more information about Bitcoin configuration please see [Bitcoin.conf_Configuration_File](https://en.bitcoin.it/wiki/Running_Bitcoin#Bitcoin.conf_Configuration_File).

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/bitcoind
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The bitcoind image stores the Bitcoind node data (Blockchain and wallet) and configurations at the `/bitcoin` path of the container.

By default a PersistentVolumeClaim is created and mounted into that directory. In order to disable this functionality
you can change the values.yaml to disable persistence and use an emptyDir instead.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

!!! WARNING !!!

Please NOT use emptyDir for production cluster! Your wallets will be lost on container restart!

## Customize bitcoind configuration file

```yaml
configurationFile:
  bitcoind.conf: |-
    server=1
    printtoconsole=1
    rpcuser=rpcuser
    rpcpassword=rpcpassword
```
