# LND

[LND](https://github.com/lightningnetwork/lnd) is an implementation of a
Lightning Network Node. The Lightning Network is a "Layer 2" payment protocol
that operates on top of a blockchain-based cryptocurrency. It features a
peer-to-peer system for making micropayments of cryptocurrency through a
network of bidirectional payment channels without delegating custody of funds.

## Introduction

This chart bootstraps a single LND node. The default docker image is taken from
[BTCPay Server](https://hub.docker.com/r/btcpayserver/lnd)'s dockerhub
repository. By default it runs a testnet node using neutrino.

## Prerequisites

* Kubernetes 1.8+
* PV provisioner support
* Running Bitcoind (or a neutrino node to connect to)

## Installing the Chart

To install the chart with the release name `my-release`:

```
$ helm install --name my-release stable/lnd
```

This command deploys a testnet instance of lnd on the Kubernetes cluster in the
default configuration. The [configuration](#configuration) section lists the
parameters that can be configured during installation.

After the instance deploys you need to exec into the pod and create a new
wallet. It will ask you to create a password that you will need in the next
step.

```
NETWORK=testnet
kubectl exec -it $(kubectl get pod -l "release=my-release" -o jsonpath='{.items[0].metadata.name}') -- lncli -n $NETWORK create
```

Now you can enable auto unlock for your wallet. Replace `PASSWORD` with your
password:

```
helm upgrade my-release stable/lnd --set autoUnlock=true --set autoUnlockPassword=PASSWORD
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

## Configuration

The following tables list the configurable parameters of the lnd chart and
their default values.

Parameter                  | Description                        | Default
-----------------------    | ---------------------------------- | ----------------------------------------------------------
`image.repository`         | Image source repository name       | `btcpayserver/lnd`
`image.tag`                | `lnd` release tag.                 | `v0.5.2-beta-3`
`image.pullPolicy`         | Image pull policy                  | `IfNotPresent`
`internalServices.rpcPort` | RPC Port                           | `10009`
`externalServices.p2pPort` | P2P Port                           | `9735`
`persistence.enabled`      | Save node state                    | `true`
`persistence.accessMode`   | ReadWriteOnce or ReadOnly          | `ReadWriteOnce`
`persistence.size`         | Size of persistent volume claim    | `5Gi`
`resources`                | CPU/Memory resource requests/limits| `{}`
`configurationFile`        | Config file ConfigMap entry        |
`autoUnlock`               | Automatically unlock the wallet    | `false`
`autoUnlockPassword`       | Password used to unlock the wallet |
