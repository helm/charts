# ethereum

[Ethereum](https://www.ethereum.org/) is a decentralized platform for building applications on the blockchain.

## TL;DR;

```console
$ helm install incubator/ethereum
```

## Introduction

This chart deploys a private [Ethereum](https://www.ethereum.org/) network onto a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. For more information on running a private network, refer to [this](https://github.com/ethereum/go-ethereum/wiki/Private-network). The private Ethereum network deployed with this chart is comprised of 4 different components: 

1. bootnode: used for node discovery
2. ethstats: [Ethereum Network Stats](https://github.com/cubedro/eth-netstats)
3. geth-miner: Geth miner nodes
3. geth-tx: Geth transaction nodes with mining disabled whose responsbility is to respond to API (websocket, rpc) queries

## Prerequisites

* Kubernetes 1.8

## Installing the Chart

The chart can be installed as follows:

```console
$ helm install --name my-release incubator/ethereum
```

The command deploys a private Ethereum network in the default configuration. The configuration](#configuration) section lists various ways to override default configuration during deployment.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the vault chart and their default values.

| Parameter                         | Description                                   | Default                               |
|-----------------------------------|-----------------------------------------------|---------------------------------------|
| `imagePullPolicy`                 | Container pull policy                         | `IfNotPresent`                        |
| `bootnode.image.repository`       | bootnode container image to use               | `ethereum/client-go`                  |
| `bootnode.image.tag`              | bootnode container image tag to deploy        | `alltools-v1.7.3`                     |
| `ethstats.image.repository`       | ethstats container image to use               | `ethereumex/eth-stats-dashboard`      |
| `ethstats.image.tag`              | ethstats container image tag to deploy        | `latest`                              |
| `ethstats.webSocketSecret`        | ethstats secret for posting data              | `my-secret-for-connecting-to-ethstats`|
| `ethstats.service.type`           | k8s service type for ethstats                 | `LoadBalancer`                        |
| `geth.image.repository`           | geth container image to use                   | `ethereum/client-go`                  |
| `geth.image.tag`                  | geth container image tag to deploy            | `v1.7.3`                              |
| `geth.tx.replicaCount`            | geth transaction nodes replica count          | `2`                                   |
| `geth.tx.service.type`            | k8s service type for geth transaction nodes   | `ClusterIP`                           |
| `geth.miner.replicaCount`         | geth miner nodes replica count                | `3`                                   |
| `geth.miner.account.secret`       | geth account secret                           | `my-secret-account-password`          |
| `geth.genesis.networkId`          | Ethereum network id                           | `98052`                               |
| `geth.genesis.accountsToFund`     | Array of accounts to initially fund           | `da1e55471ded03adadee63ac658b671277a6c7d1`|

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example, to configure the networkid:

```console
$ helm install kubernetes-ethereum-chart --name ethereum --set geth.genesis.networkid=98052 
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install incubator/ethereum -f values.yaml 
```

> **Tip**: You can use the default [values.yaml](values.yaml)
