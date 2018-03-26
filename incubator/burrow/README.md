# burrow

[burrow](https://github.com/hyperledger/burrow) is a permissioned Ethereum smart-contract blockchain node. It executes Ethereum smart contract code on a permissioned virtual machine. Burrow provides transaction finality and high transaction throughput on a proof-of-stake Tendermint consensus engine.

**Note - this chart has been deprecated and [moved to stable](../../stable/burrow)**.

## TL;DR;

```console
$ helm install incubator/burrow
```

## Introduction

This chart bootstraps a burrow network on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install incubator/burrow --name my-release
```

The command deploys burrow on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

There is a zero percent chance that you will want the default configuration. Please see the [runtime configuration](#runtime) section for more information on how to setup your network properly.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the kibana chart and their default values.

Parameter | Description | Default
--- | --- | ---
`affinity` | node/pod affinities | None
`chain.extraSeeds` | network seeds to dial in addition to the cluster booted by the chart; each entry in the array should be in the form `ip:port` (noting that because the p2p connects over tcp that the port is absolutely required) | `[]`
`chain.id` | machine readable (and preferably unique) ID for the blockchain network | `simpleTestChain`
`chain.logLevel` | log level for the nodes (`debug`, `info`, `warn`) | `info`
`chain.name` | human readable name of the blockchain network | `simpleTestChain`
`chain.numberOfNodes` | number of nodes for the blockchain network | `1`
`env` | Environment variables to configure burrow | `{}`
`extraArgs` | extra arguments to give to the build in `burrow serve` command | `{}`
`genesisFile` | base64 encoded string for the genesis.json file | See values.yaml
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`image.repository` | Image repository | `quay.io/monax/db`
`image.tag` | Image tag | `0.17.1`
`ingress.annotations` | Ingress annotations | None
`ingress.enabled` | Enables Ingress | `false`
`ingress.hosts` | Ingress accepted hostnames | None
`ingress.tls` | Ingress TLS configuration | None
`keysFiles` | base64 encoded strings for the priv_validator.json files | See values.yaml
`nodeSelector` | node labels for pod assignment | `{}`
`organization` | name of the organization running these nodes (used in the peer's moniker) | `myOrg`
`persistence.accessMode` | access mode for the chain data pvc | None
`persistence.annotations` | annotations for the chain data pvc | None
`persistence.enabled` | enable pvc for the chain data | `false`
`persistence.size` | size of the chain data pvc | None
`persistence.storageClass` | storage class for the chain data pvc | None
`podAnnotations` | annotations to add to each pod | `{}`
`podLabels` | labels to add to each pod | `{}`
`resources` | pod resource requests & limits | `{}`
`service.api.loadBalance` | if `true` then the api service will load balance across the nodes | `true`
`service.api.node` | node number to link the api service to (ignored if loadBalance is `true`) | `""`
`service.api.port` | api port | `46656`
`service.api.type` | service type for the api port | `ClusterIP`
`service.peer.port` | peer port | `46656`
`service.peer.type` | service type for the peer port | `ClusterIP`
`service.rpc.loadBalance` | if `true` then the rpc service will load balance across the nodes | `false`
`service.rpc.node` | node number to link the rpc service to (ignored if loadBalance is `true`) | `000`
`service.rpc.port` | rpc port | `46656`
`service.rpc.type` | service type for the rpc port | `ClusterIP`
`tolerations` | List of node taints to tolerate | `[]`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install incubator/burrow --name my-release \
  --set=image.tag=0.16.0,resources.limits.cpu=200m
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install incubator/burrow --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Runtime

As noted above, there is a zero percent chance that you will want to deploy this chart with the default runtime configuration. When booting permissioned blockchains in a cloud environment there are three predominant considerations in addition to the normal configuration of any cloud application.

1. What access rights to place on the ports?
2. What is the set of initial accounts and validators for the chain?
3. What keys should the validating nodes have?

Each of these considerations will be dealt with in more detail below.

### Configuration of the Ports

Burrow utilizes three different ports by default:

* `peer`: Burrow's peer port is the port on which the p2p communication within the blockchain network is conducted. The peer port is utilized by burrow's consensus engine (which is the [Tendermint](https://github.com/tendermint/tendermint) engine) to perform bilateral gossiping communication.
* `rpc`: Burrow's rpc port is the port on which remote procedures are conducted. It is utilized by tools such as, e.g., the [Monax](https://github.com/monax/monax) tools which can be utilized to deploy smart contracts and perform other functions.
* `api`: Burrow's api port is the port on which javascript libraries interact with the chain utilizing websockets. It is generally utilized by tools.

The default configuration for the chart sets up the port access rights in the following manner:

* `peer`: Peer ports are **only** opened within the cluster. By default, there is no p2p communication exposed to the general internet. Each node within the cluster has its own distinct peer service built by the chart which utilizes a `ClusterIP` service type.
* `rpc`: The RPC port is **only** opened within the cluster. By default, there is no rpc communication exposed to the general internet. There is **one** rpc service built by the chart which utilizes a `ClusterIP` service type. The default rpc service used by the chart is strongly linked to node number `000` and is not load balanced across the nodes by default so as to reduce any challenges with tooling that conduct long-polling after sending transactions. The chart offers an ingress which is connected to the `rpc` service. This is `disabled` by default.
* `api`: The API port is **only** opened within the cluster. By default, there is no api communication exposed to the general internet. There is **one** api service built by the chart which utilizes a `ClusterIP` service type. The default api service used by the chart is load balanced across the nodes within the cluster by default because libraries which utilize this port typical do so on websockets and the service is able to utilize a sessionAffinity setting.

The following options are available to increase the exposure of the `peer` port:

* In order to expose the peers to the general internet change the `service.peer.type` to `NodePort`. It is not advised to run p2p traffic through an ingress or other load balancing service as there is uncertainty with respect to the IP address which the blockchain node advertises and gossips. As such, the best way to expose p2p traffic to the internet is to utilize a `NodePort` service type. While such service types can be a challenge to work with in many instances, the p2p libraries that blockchains utilize are very resilient to movement between machine nodes by a blockchain node. The biggest gotcha with `NodePort` service types is the ensure that the machine nodes have proper egress within the cloud or data center provider. As long as the machine nodes do not have egress restrictions disabling the utilization of `NodePort` service types the p2p traffic will be exposed fluidly.

The following options are available to increase the exposure of the `rpc` port:

* To expose the rpc service to the general internet change the default `ingress.enabled` to `true` and add the appropriate fields to the ingress for your Kubernetes cluster. This will enable developers to connect to the rpc from their local machines and the general internet will be able to access the rpc service.
* To change from a non-loadBalanced rpc service to a loadBalanced service change the `service.rpc.loadBalance` to `true`. Making this change is not advised if developers or services will be deploying contracts, however it is helpful if developers or services will simply be accessing the informational aspects of the rpc with the caveat that some of the `rpc` end points (e.g., `net_info`) will only return information for a single node and as such will be non-deterministic.
* To change the node that a non-loadBalanced rpc service connects to change the default `service.rpc.node` from `000` to another node number.

The following options are available to increase the exposure of the `api` port:

* To change from a loadBalanced api service to a non-loadBalanced servie change the `service.api.loadBalance` to `false` and add the node number to the `service.api.node` field.
* To denote the node that a non-loadBalanced api service connects to add the `service.api.node` to a node number such as `000`.

### Configuration of the `genesis.json`

Burrow initializes any single blockchain via use of a `genesis.json` which defines what validators and accounts are given access to the permissioned blockchain when it is booted.

Anyone that works with either the `monax` toolkit or `burrow` will be familiar with the `genesis.json`. This file is utilized by the blockchain nodes within the cluster to set up their initial state.

The chart imports the `genesis.json` file as a Kubernetes secret and then mounts the secret in each of the deployments utilized. The chart provides a default genesis file so as to ensure this chart is testable. The genesis file may be used to test out the blockchain, but otherwise should **absolutely not be used**. For more information on how to integrate your own genesis file for this chart see the [examples](examples/) folder.

### Configuration of the validator keys

**NOTE the chart has not been security audited and as such one should use the validator keys functionality of the chart at one's own risk**.

Burrow blockchain nodes need to have a key available to them which has been properly registered within the `genesis.json` initial state. The registered key is what enables a blockchain node to participate in the p2p validation of the network.

Anyone that works with either the `monax` toolkit, `burrow`, or `tendermint` will be familiar with the key files known as: `priv_validator.json` files used to initialize an individual blockchain node.

The chart imports the `priv_validator.json` files as Kubernetes secrets, as such the security of the blockchain is only as strong as the Kubernetes secrets utilized via helm. The chart provides a default keys file so as to ensure that this chart is testable. The key file may be used to test out the blockchain, but otherwise should **absolutely not be used**. For more information on how to integrate your own keys files for this chart see the [examples](examples/) folder.

## Other considerations

There are a few other considerations underpinning how this chart was developed.

### Deployments versus StatefulSets

The first consideration is whether to utilize multiple deployments or a statefulSet. The chart maintainer has (to date) found it significantly easier to work with multiple deployments than with a statefulSet because the config files and keys differ subtly between and across each blockchain node. StatefulSets are currently not able to as elegantly handle the 1-to-1 linkages between the various key secrets and config files that are necessary to operate each blockchain node within the cluster.

### Running multiple chains within your cluster

Many users run multiple blockchains within their cluster. To run more than one blockchain it is best to utilize the `nameOverride` Value and set that to the `$CHAIN_ID` of any one blockchain network. That will allow easy use of multiple chains within a single cluster. For an example of this see the examples directory.
