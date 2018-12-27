# Hyperledger Fabric Orderer

[Hyperledger Fabric Orderer](http://hyperledger-fabric.readthedocs.io/) is the node type responsible for "consensus" for the [Hyperledger](https://www.hyperledger.org/) Fabric permissioned blockchain framework.

## TL;DR;

```bash
$ helm install stable/hlf-ord
```

## Introduction

The Hyperledger Fabric Orderer can be installed as either a `solo` orderer (for development), or a `kafka` orderer (for crash fault tolerant consensus).

This Orderer can receive transaction endorsements and package them into blocks to be distributed to the nodes of the Hyperledger Fabric network.

Learn more about deploying a production ready consensus framework based on Apache [Kafka](https://hyperledger-fabric.readthedocs.io/en/release-1.1/kafka.html?highlight=orderer). Minimally, you will need to set these options:

```
  "default.replication.factor": 4  # given a 4 node Kafka cluster
  "unclean.leader.election.enable": false
  "min.insync.replicas": 3  # to permit one Kafka replica to go offline
  "message.max.bytes": "103809024"  # 99 * 1024 * 1024 B
  "replica.fetch.max.bytes": "103809024"  # 99 * 1024 * 1024 B
  "log.retention.ms": -1  # Since we need to keep logs indefinitely for the HL Fabric Orderer
```

## Prerequisites

- Kubernetes 1.9+
- PV provisioner support in the underlying infrastructure.
- K8S secrets containing:
    - the crypto-materials (e.g. signcert, key, cacert, and optionally intermediatecert, CA credentials)
    - the genesis block for the Orderer
    - the certificate of the Orderer Organisation Admin
- A running [Kafka Chart](https://github.com/kubernetes/charts/tree/master/incubator/kafka) if you are using the `kafka` consensus mechanism.

## Installing the Chart

To install the chart with the release name `ord1`:

```bash
$ helm install stable/hlf-ord --name ord1
```

The command deploys the Hyperledger Fabric Orderer on the Kubernetes cluster in the default configuration. The [Configuration](#configuration) section lists the parameters that can be configured during installation.

### Custom parameters

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install stable/hlf-ord --name ord1 --set ord.mspID=MyMSP
```

Alternatively, a YAML file can be provided while installing the chart. This file specifies values to override those provided in the default values.yaml. For example,

```bash
$ helm install stable/hlf-ord --name ord1 -f my-values.yaml
```

## Updating the chart

To update the chart run:

```bash
$ helm upgrade ord1 stable/hlf-ord -f my-values.yaml
```

## Uninstalling the Chart

To uninstall/delete the `ord1` deployment:

```bash
$ helm delete ord1
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Hyperledger Fabric Orderer chart and default values.

| Parameter                          | Description                                     | Default                                                    |
| ---------------------------------- | ------------------------------------------------ | ---------------------------------------------------------- |
| `image.repository`                 | `hlf-ord` image repository                       | `hyperledger/fabric-orderer`                                    |
| `image.tag`                        | `hlf-ord` image tag                              | `x86_64-1.1.0`                                             |
| `image.pullPolicy`                 | Image pull policy                                | `IfNotPresent`                                             |
| `service.port`                     | TCP port                                         | `7050`                                                     |
| `service.type`                     | K8S service type exposing ports, e.g. `ClusterIP`| `ClusterIP`                                                |
| `ingress.enabled`                  | If true, Ingress will be created                 | `false`                                                    |
| `ingress.annotations`              | Ingress annotations                              | `{}`                                                       |
| `ingress.path`                     | Ingress path                                     | `/`                                                        |
| `ingress.hosts`                    | Ingress hostnames                                | `[]`                                                       |
| `ingress.tls`                      | Ingress TLS configuration                        | `[]`                                                       |
| `persistence.accessMode`           | Use volume as ReadOnly or ReadWrite              | `ReadWriteOnce`                                            |
| `persistence.annotations`          | Persistent Volume annotations                    | `{}`                                                       |
| `persistence.size`                 | Size of data volume (adjust for production!)     | `1Gi`                                                      |
| `persistence.storageClass`         | Storage class of backing PVC                     | `default`                                                  |
| `ord.type`                         | Type of Orderer (`solo` or `kafka`)              | `solo`                                                     |
| `ord.mspID`                        | ID of MSP the Orderer belongs to                 | `OrdererMSP`                                               |
| `ord.tls.server.enabled`           | Do we enable server-side TLS?                    | `false`                                                    |
| `ord.tls.client.enabled`           | Do we enable client-side TLS?                    | `false`                                                    |
| `secrets.ord.cred`                 | Credentials: 'CA_USERNAME' and 'CA_PASSWORD'     | ``                                                         |
| `secrets.ord.cert`                 | Certificate: as 'cert.pem'                       | ``                                                         |
| `secrets.ord.key`                  | Private key: as 'key.pem'                        | ``                                                         |
| `secrets.ord.caCert`               | CA Cert: as 'cacert.pem'                         | ``                                                         |
| `secrets.ord.intCaCert`            | Int. CA Cert: as 'intermediatecacert.pem'        | ``                                                         |
| `secrets.ord.tls`                  | TLS secret: as 'tls.crt' and 'tls.key'           | ``                                                         |
| `secrets.ord.tlsRootCert`          | TLS root CA certificate: as 'cert.pem'           | ``                                                         |
| `secrets.ord.tlsClientRootCert`    | TLS client root CA certificate: as 'cert.pem'    | ``                                                         |
| `secrets.genesis`                  | Secret containing Genesis Block for orderer      | ``                                                         |
| `secrets.adminCert`                | Secret containing Orderer Org admin certificate  | ``                                                         |
| `resources`                        | CPU/Memory resource requests/limits              | `{}`                                                       |
| `nodeSelector`                     | Node labels for pod assignment                   | `{}`                                                       |
| `tolerations`                      | Toleration labels for pod assignment             | `[]`                                                       |
| `affinity`                         | Affinity settings for pod assignment             | `{}`                                                       |

## Persistence

The volume stores the Fabric Orderer data and configurations at the `/var/hyperledger` path of the container.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning through a PersistentVolumeClaim managed by the chart.

## Upgrading from version 1.1.x

Previous versions of this chart performed enrollment with the Fabric CA directly from the pod. This prevented the possibility of using development cryptographic material (certificates and keys) from Cryptogen or the usage of other CA mechanisms.

Instead, crypto-material and CA credentials are stored separately as secrets.

If you used the former type of chart, you will need to obtain the relevant credentials and cryptographic material from the running pod, and save it externally to a set of secrets, whose names you will need to feed into the chart, under the `secrets.ord` section.

An example upgrade procedure is described in `UPGRADE_1-1-x.md`

## Feedback and feature requests

This is a work in progress and we are happy to accept feature requests. We are even happier to accept pull requests implementing improvements :-)
