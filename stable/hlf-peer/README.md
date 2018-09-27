# Hyperledger Fabric Peer

[Hyperledger Fabric Peer](http://hyperledger-fabric.readthedocs.io/) is the node type responsible for endorsing transactions and recording them on the Blockchain for the [Hyperledger](https://www.hyperledger.org/) Fabric permissioned blockchain framework.

## TL;DR;

```bash
$ helm install stable/hlf-peer
```

## Introduction

The Hyperledger Fabric Peer can either use a `goleveldb` or a `CouchDB` database for holding the ledger data.

This Peer can receive transaction requests, which it checks and signs, endorsing them. These endorsements can then be sent to the Ordering Service (one or more Orderer nodes), which will package them and return blocks that the Peer can then commit to their own Ledger.

## Prerequisites

- Kubernetes 1.9+
- PV provisioner support in the underlying infrastructure.
- Three K8S secrets containing:
    - the channel transaction for the Peer
    - the certificate of the Peer Organisation Admin
    - the private key of the Peer Organisation Admin (needed to join the channel)
- A running [HLF-CouchDB Chart](https://github.com/kubernetes/charts/tree/master/stable/hlf-couchdb) if you are using the `CouchDB` database.

## Installing the Chart

To install the chart with the release name `peer1`:

```bash
$ helm install stable/hlf-peer --name peer1
```

The command deploys the Hyperledger Fabric Peer on the Kubernetes cluster in the default configuration. The [Configuration](#configuration) section lists the parameters that can be configured during installation.

### Custom parameters

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install stable/hlf-peer --name peer1 --set caUsername=peer1,caPassword=secretpassword
```

The above command specifies (but does not register/enroll) a Peer username of `peer1` with password `secretpassword`.

Alternatively, a YAML file can be provided while installing the chart. This file specifies values to override those provided in the defualt values.yaml. For example,

```bash
$ helm install stable/hlf-peer --name peer1 -f my-values.yaml
```

## Updating the chart

When updating the chart, make sure you provide the `caPassword`, otherwise `helm update` will generate a new random (and invalid) password.

```bash
$ export CA_PASSWORD=$(kubectl get secret --namespace {{ .Release.Namespace }} peer1-hlf-peer -o jsonpath="{.data.CA_PASSWORD}" | base64 --decode; echo)
$ helm upgrade peer1 stable/hlf-peer --set caPassword=$CA_PASSWORD
```

## Uninstalling the Chart

To uninstall/delete the `peer1` deployment:

```bash
$ helm delete peer1
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Hyperledger Fabric Peer chart and default values.

| Parameter                          | Description                                     | Default                                                    |
| ---------------------------------- | ---------------------------------------------------- | ---------------------------------------------------------- |
| `image.repository`                 | `hlf-peer` image repository                          | `hyperledger/fabric-peer`                                  |
| `image.tag`                        | `hlf-peer` image tag                                 | `x86_64-1.1.0`                                             |
| `image.pullPolicy`                 | Image pull policy                                    | `IfNotPresent`                                             |
| `service.portRequest`              | TCP port for requests to Peer                        | `7051`                                                     |
| `service.portEvent`                | TCP port for event service on Peer                   | `7053`                                                     |
| `service.type`                     | K8S service type exposing ports, e.g. `ClusterIP`    | `ClusterIP`                                                |
| `persistence.accessMode`           | Use volume as ReadOnly or ReadWrite                  | `ReadWriteOnce`                                            |
| `persistence.annotations`          | Persistent Volume annotations                        | `{}`                                                       |
| `persistence.size`                 | Size of data volume (adjust for production!)         | `1Gi`                                                      |
| `persistence.storageClass`         | Storage class of backing PVC                         | `default`                                                  |
| `caAddress`                        | Address of CA to register/enroll with                | `hlf-ca.local`                                             |
| `caUsername`                       | Username for registering/enrolling with CA           | `peer1`                                                    |
| `caPassword`                       | Password for registering/enrolling with CA           | Random 24 alphanumeric characters                          |
| `peer.hlfToolsVersion`             | Which version of HLF tools we use (e.g. CA client)   | `1.1.0`                                                    |
| `peer.databaseType`                | Database type to use (`goleveldb` or `CouchDB`)      | `goleveldb`                                                |
| `peer.couchdbInstance              | CouchDB chart name to use `cdb-peer1`                | `cdb-peer1`                                                |
| `peer.mspID`                       | ID of MSP the Peer belongs to                        | `Org1MSP`                                                  |
| `secrets.channel`                  | Secret containing Channel tx for peer to create/join | ``                                                         |
| `secrets.adminCert`                | Secret containing Peer Org admin certificate         | ``                                                         |
| `secrets.adminCert`                | Secret containing Peer Org admin private key         | ``                                                         |
| `secrets.caServerTls`              | Secret containing CA Server TLS certificate      | `ca--tls`                                                  |
| `resources`                        | CPU/Memory resource requests/limits                  | `{}`                                                       |
| `nodeSelector`                     | Node labels for pod assignment                       | `{}`                                                       |
| `tolerations`                      | Toleration labels for pod assignment                 | `[]`                                                       |
| `affinity`                         | Affinity settings for pod assignment                 | `{}`                                                       |

## Persistence

The volume stores the Fabric Peer data and configurations at the `/var/hyperledger` path of the container.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning through a PersistentVolumeClaim managed by the chart.

## Feedback and feature requests

This is a work in progress and we are happy to accept feature requests. We are even happier to accept pull requests implementing improvements :-)
