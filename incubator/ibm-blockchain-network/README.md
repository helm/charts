# ibm-blockchain-network

Use [ibm-blockchain](https://ibm-blockchain.github.io) to develop in a cloud sandbox using the IBM Blockchain Platform.

## TL;DR;

```console
$ helm install stable/ibm-blockchain-network
```

## Introduction

This chart bootstraps a [ibm-blockchain](https://ibm-blockchain.github.io) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.7+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/ibm-blockchain-network
```

The command deploys the IBM Blockchain Platform on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the IBM Blockchain Network chart and their default values.

|             Parameter              |               Description                |                         Default                          |
|------------------------------------|------------------------------------------|----------------------------------------------------------|
| `blockchain.toolsImage`            | Blockchain tools image                   | `ibmblockchain/fabric-tools:1.0.0`                       |
| `blockchain.ordererImage`          | Blockchain orderer image                 | `ibmblockchain/fabric-orderer:1.0.0`                     |
| `blockchain.caImage`               | Blockchain ca image                      | `ibmblockchain/fabric-ca:1.0.0`                          |
| `blockchain.peerImage`             | Blockchain peer image                    | `ibmblockchain/fabric-peer:1.0.0`                        |
| `blockchain.pullPolicy`            | Blockchain image pull policy             | `IfNotPresent`                                           |
| `persistence.storageClass`         | Storage Class for dynamic provisioning   | nil                                                      |


The above parameters map to the env variables defined in [IBM-Blockchain/ibm-container-service](https://github.ibm.com/IBM-Blockchain/ibm-container-service). For more information please refer to the [IBM-Blockchain/ibm-container-service](https://github.ibm.com/IBM-Blockchain/ibm-container-service) documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console-
$ helm install --name my-release -f values.yaml stable/ibm-blockchain-network
```

> **Tip**: You can use the default [values.yaml](values.yaml)
