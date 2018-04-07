# ethereum

[Ethereum](https://www.ethereum.org/) is a decentralized platform for building applications using blockchain.

## TL;DR;

```console
$ helm install stable/ethereum
```

## Introduction

This chart deploys a **private** [Ethereum](https://www.ethereum.org/) network onto a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. This network is **not** connected to MainNet, and for further information on running a private network, refer to [Geth's documentation](https://github.com/ethereum/go-ethereum/wiki/Private-network). This chart is comprised of 4 components:

1. *bootnode*: used for Geth node discovery
1. *ethstats*: [Ethereum Network Stats](https://github.com/cubedro/eth-netstats)
1. *geth-miner*: Geth miner nodes
1. *geth-tx*: Geth transaction nodes with mining disabled whose responsbility is to respond to API (websocket, rpc) queries

## Prerequisites

* Kubernetes 1.8

## Installing the Chart

1. Create an Ethereum address and private key. To create a new Ethereum wallet, refer to [this blog post](https://kobl.one/blog/create-full-ethereum-keypair-and-address/) which will walkthrough the following instructions in greater detail:

    ```console
    $ git clone https://github.com/vkobel/ethereum-generate-wallet
    $ cd ethereum-generate-wallet
    $ pip3 install -r requirements.txt
    $ python3 ethereum-wallet-generator.py

    Private key: 38000e15ca07309cc2d0b30faaaadb293c45ea222a117e9e9c6a2a9872bb3bcf
    Public key:  60758d37d431d34b920847212febbd583008ec2a34d00f907d48bd48b88dc2661806eb99cb6178312d228b2fd08cdb88bafc352d0395ae09b2fe453f0c4403ad
    Address:     0xab70383d9207c6cc43ab85eeef9db4d33a8ad4e8
    ```

2. Install the chart as follows:

    ```console
    $ helm install --name my-release stable/ethereum
        --set geth.account.address=[PUBLIC_ADDRESS]
        --set geth.account.privateKey=[PRIVATE_KEY]
        --set geth.account.secret=[SECRET]
    ```

    using the above generated example, the configurations would equate to:
    
    * `geth.account.address` = `0xab70383d9207c6cc43ab85eeef9db4d33a8ad4e8` 
    * `geth.account.privateKey` = `38000e15ca07309cc2d0b30faaaadb293c45ea222a117e9e9c6a2a9872bb3bcf`
    * `geth.account.secret` = any passphrase that Geth will use to encrypt your private key


## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the vault chart and their default values.

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
| `geth.genesis.difficulty`         | Ethereum network difficulty                   | `0x0400`                              |
| `geth.genesis.gasLimit`           | Ethereum network gas limit                    | `0x8000000`                         |
| `geth.account.address`            | Geth Account to be initially funded and deposited with mined Ether |                  |
| `geth.account.privateKey`         | Geth Private Key                              |                                       |
| `geth.account.secret`             | Geth Account Secret                           |                                       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example, to configure the networkid:

```console
$ helm install stable/ethereum --name ethereum --set geth.genesis.networkid=98052
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/ethereum -f values.yaml
```

