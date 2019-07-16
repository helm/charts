# ethereum

[Ethereum](https://www.ethereum.org/) is a decentralized platform for building applications using blockchain.

## TL;DR;

```console
$ helm install stable/ethereum
NAME:   snug-skunk
LAST DEPLOYED: Tue May 21 13:11:44 2019
NAMESPACE: eth
STATUS: DEPLOYED


RESOURCES:
==> v1/ConfigMap
NAME                             DATA  AGE
snug-skunk-ethereum-geth-config  2     1s

==> v1/Pod(related)
NAME                                             READY  STATUS             RESTARTS  AGE
snug-skunk-ethereum-bootnode-f684879d4-hwks7     0/2    Init:0/1           0         1s
snug-skunk-ethereum-ethstats-5997bd6fcb-m2rml    0/1    ContainerCreating  0         1s
snug-skunk-ethereum-geth-miner-85d8fcdfdf-hpzmq  0/1    Init:0/3           0         1s
snug-skunk-ethereum-geth-tx-5cb9c85ccf-t8w8m     0/1    Init:0/3           0         1s
snug-skunk-ethereum-geth-tx-5cb9c85ccf-twrwv     0/1    Init:0/3           0         1s

==> v1/Secret
NAME                              TYPE    DATA  AGE
snug-skunk-ethereum-ethstats      Opaque  1     1s
snug-skunk-ethereum-geth-account  Opaque  2     1s

==> v1/Service
NAME                          TYPE          CLUSTER-IP   EXTERNAL-IP  PORT(S)            AGE
snug-skunk-ethereum-bootnode  ClusterIP     None         <none>       30301/UDP,80/TCP   1s
snug-skunk-ethereum-ethstats  LoadBalancer  10.11.247.5  <pending>    80:30950/TCP       1s
snug-skunk-ethereum-geth-tx   ClusterIP     10.11.250.9  <none>       8545/TCP,8546/TCP  1s

==> v1beta2/Deployment
NAME                            READY  UP-TO-DATE  AVAILABLE  AGE
snug-skunk-ethereum-bootnode    0/1    1           0          1s
snug-skunk-ethereum-ethstats    0/1    1           0          1s
snug-skunk-ethereum-geth-miner  0/3    3           0          1s
snug-skunk-ethereum-geth-tx     0/2    2           0          1s

NOTES:


  1. View the EthStats dashboard at:
    export SERVICE_IP=$(kubectl get svc --namespace eth snug-skunk-ethereum-ethstats -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    echo http://$SERVICE_IP

    NOTE: It may take a few minutes for the LoadBalancer IP to be available.
          You can watch the status of by running 'kubectl get svc -w snug-skunk-ethereum-ethstats-service'

  2. Connect to Geth transaction nodes (through RPC or WS) at the following IP:
    export POD_NAME=$(kubectl get pods --namespace eth -l "app=ethereum,release=snug-skunk,component=geth-tx" -o jsonpath="{.items[0].metadata.name}")
    kubectl port-forward $POD_NAME 8545:8545 8546:8546
```

## Introduction

This chart deploys a **private [proof-of-authority](https://medium.com/coinmonks/ethereum-clique-poa-vs-pow-11be52cddde1)** [Ethereum](https://www.ethereum.org/) network onto a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. This network is **not** connected to MainNet, and for further information on running a private network, refer to [Geth's documentation](https://github.com/ethereum/go-ethereum/wiki/Private-network). This chart is comprised of 4 components:

1.  _bootnode_: used for Geth node discovery
2.  _ethstats_: [Ethereum Network Stats](https://github.com/cubedro/eth-netstats)
3.  _geth-miner_: Geth miner nodes
4.  _geth-tx_: Geth transaction nodes with mining disabled whose responsbility is to respond to API (websocket, rpc) queries

## Prerequisites

-   Kubernetes 1.8

## Installing the Chart

1.  Create an Ethereum address and private key. To create a new Ethereum wallet, refer to [this blog post](https://kobl.one/blog/create-full-ethereum-keypair-and-address/) which will walkthrough the following instructions in greater detail:

    ```console
    $ pip install eciespy
    $ eciespy -g
    Private: 0x75514a0d1b96bb27fdfe2b58d4a9e79f375d97727f7d894e766d43c848d1506f
    Public: 0xf1900916095f2dcbd681bcf44817a5e69d663790271a274a982afdbf1c416f2e3d48789fa1fc9a1b91a14b0b2fbe6372a17803d78fda7f819dac8b93c9488476
    Address: 0xe044d51367EB4B47EF360a1A9B5EDab879536B67
    ```

2.  Install the chart as follows:

    ```console
    $ helm install --name my-release stable/ethereum
        --set geth.account.address=[PUBLIC_ADDRESS]
        --set geth.account.privateKey=[PRIVATE_KEY]
        --set geth.account.secret=[SECRET]
    ```

    using the above generated example, the configurations would equate to (without the prefix 0x):

    -   `geth.account.address` = `e044d51367EB4B47EF360a1A9B5EDab879536B67`
    -   `geth.account.privateKey` = `75514a0d1b96bb27fdfe2b58d4a9e79f375d97727f7d894e766d43c848d1506f`
    -   `geth.account.secret` = any passphrase that Geth will use to encrypt your private key

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release --purge
release "my-release" deleted
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the vault chart and their default values.

| Parameter                   | Description                                                        | Default                                |
| --------------------------- | ------------------------------------------------------------------ | -------------------------------------- |
| `imagePullPolicy`           | Container pull policy                                              | `IfNotPresent`                         |
| `nodeSelector`              | Node labels for pod assignment                                     |                                        |
| `bootnode.image.repository` | bootnode container image to use                                    | `ethereum/client-go`                   |
| `bootnode.image.tag`        | bootnode container image tag to deploy                             | `alltools-v1.9.0`                     |
| `ethstats.image.repository` | ethstats container image to use                                    | `ethereumex/eth-stats-dashboard`       |
| `ethstats.image.tag`        | ethstats container image tag to deploy                             | `latest`                               |
| `ethstats.webSocketSecret`  | ethstats secret for posting data                                   | `my-secret-for-connecting-to-ethstats` |
| `ethstats.service.type`     | k8s service type for ethstats                                      | `LoadBalancer`                         |
| `geth.image.repository`     | geth container image to use                                        | `ethereum/client-go`                   |
| `geth.image.tag`            | geth container image tag to deploy                                 | `v1.9.0`                              |
| `geth.tx.replicaCount`      | geth transaction nodes replica count                               | `2`                                    |
| `geth.tx.service.type`      | k8s service type for geth transaction nodes                        | `ClusterIP`                            |
| `geth.tx.args.rpcapi`       | APIs offered over the HTTP-RPC interface                           | `eth,net,web3`                         |
| `geth.miner.replicaCount`   | geth miner nodes replica count                                     | `1`                                    |
| `geth.miner.account.secret` | geth account secret                                                | `my-secret-account-password`           |
| `geth.genesis.networkId`    | Ethereum network id                                                | `98052`                                |
| `geth.genesis.difficulty`   | Ethereum network difficulty                                        | `0x1`                                  |
| `geth.genesis.blockTime`    | Ethereum network block time                                        | `15`                                   |
| `geth.genesis.gasLimit`     | Ethereum network gas limit                                         | `0x8000000`                            |
| `geth.account.address`      | Geth Account to be initially funded and deposited with mined Ether |                                        |
| `geth.account.privateKey`   | Geth Private Key                                                   |                                        |
| `geth.account.secret`       | Geth Account Secret                                                |                                        |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example, to configure the networkid:

```console
$ helm install stable/ethereum --name ethereum --set geth.genesis.networkid=98052
...
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/ethereum -f values.yaml
```
