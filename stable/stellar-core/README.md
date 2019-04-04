# Stellar Core

[Stellar](https://www.stellar.org) is an open-source and distributed payments infrastructure. Stellar Core is the software that powers the backbone of the Stellar network and validates and agrees on transactions. For more information see the [Stellar network overview](https://www.stellar.org/developers/guides/get-started/).

## Introduction

This chart bootstraps a [Stellar Core](https://github.com/stellar/stellar-core/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. By default the deployment includes a PostgreSQL database. The chart is based on the Kubernetes-ready [Stellar Core images provided by SatoshiPay](https://github.com/satoshipay/docker-stellar-core/).

## Prerequisites

- You need a node seed to run Stellar Core. If you don't have one you can generate one with the following command:
  ```bash
  $ docker run --rm -it --entrypoint '' satoshipay/stellar-core stellar-core --genseed
  ```
  The output will look like
  ```
  Secret seed: SDUFQA7YL3KTWZNKOXX7XXIYU4R5R6JKELMREKHDQOYY2WPUGXFVJN52
  Public: GDJFYQK2VFVMQAOFSBM7RVE4I5HCUT7VNWOKSJKGI5JEODIH6F3EM6YX
  ```
  The node seed must be kept secret but the public key can (and should) be shared with other Stellar node operators.
- Kubernetes 1.8+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure (Only when persisting data)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/stellar-core
```

🚨 **Warning:** Make sure to use your own node seed, either via setting `nodeSeed` or `existingNodeSeedSecret`. See [prerequisites](#prerequisites) for how to generate a new node seed.

## Configuration

The following table lists the configurable parameters of the Stellar Core chart and their default values.

| Parameter                           | Description                                                        | Default                                          |
| -----------------------             | ---------------------------------------------                      | ---------------------------------------------    |
| `nodeSeed`                          | Stellar Core node seed (if `existingNodeSeedSecret` is not set)    | Not set                                          |
| `existingNodeSeedSecret`            | Existing secret with the node seed (if `nodeSeed` is not set)      | Not set                                          |
| `existingNodeSeedSecret.name`       | Secret containing the node seed                                    | Not set                                          |
| `existingNodeSeedSecret.key`        | Key of the node seed in the secret                                 | Not set                                          |
| `nodeIsValidator`                   | Should the node participate in SCP? Otherwise it is only observing | `true`                                           |
| `networkPassphrase`                 | The network this instance should talk to                           | `Public Global Stellar Network ; September 2015` |
| `catchupRecent`                     | Number of ledgers to catch up (`0` means minimal catchup)          | `0`                                              |
| `maxPeerConnections`                | Maximum number of connections to other peers                       | `50`                                             |
| `knownPeers`                        | List of hostnames/IPs and ports of peers to connect to initially   | Default peers, see `values.yaml`                 |
| `preferredPeers`                    | List of hostnames/IPs and ports of peers to stay connected to      | Default peers, see `values.yaml`                 |
| `nodeNames`                         | List of node public keys and node names                            | Default node names, see `values.yaml`            |
| `nodeNames[].publicKey`             | Public key of a node                                               | See above                                        |
| `nodeNames[].name`                  | Name of a node                                                     | See above                                        |
| `quorumSet`                         | List of quorum set definitions                                     | Default quorum set, see `values.yaml`            |
| `quorumSet.thresholdPercent`        | Threshold in percent for the quorum set                            | See above                                        |
| `quorumSet.validators`              | List of node names (prefixed with `$$`) or public keys in this set | See above                                        |
| `quorumSet.path`                    | Path for sub-quorum-sets                                           | See above                                        |
| `history`                           | Definition for fetching and storing the history of the network     | Default history, see `values.yaml`               |
| `history.$name.get`                 | Command for fetching from the history archive                      | See above                                        |
| `history.$name.put`                 | Command for storing the history in an archive                      | See above                                        |
| `initializeHistoryArchives`         | Set to `true` if you want history archives to be initialized       | `false`                                          |
| `gcloudServiceAccountKey`           | Gcloud service account key for `gcloud` flavor                     | Not set                                          |
| `environment`                       | Additional environment variables for Stellar Core                  | `{}`                                             |
| `postgresql.enabled`                | Enable PostgreSQL database                                         | `true`                                           |
| `postgresql.postgresDatabase`       | PostgreSQL database name                                           | `stellar-core`                                   |
| `postgresql.postgresUser`           | PostgreSQL username                                                | `postgres`                                       |
| `postgresql.postgresPassword`       | PostgreSQL password                                                | Random password (see PostgreSQL chart)           |
| `postgresql.persistence`            | PostgreSQL persistence options                                     | See PostgreSQL chart                             |
| `postgresql.*`                      | Any PostgreSQL option                                              | See PostgreSQL chart                             |
| `existingDatabase`                  | Provide existing database (used if `postgresql.enabled` is `false`)|                                                  |
| `existingDatabase.passwordSecret`   | Existing secret with the database password                         | `{name: 'postgresql-core', value: 'password'}`   |
| `existingDatabase.url`              | Existing database URL (use `$(DATABASE_PASSWORD` as the password)  | Not set                                          |
| `image.repository`                  | `stellar-core` image repository                                    | `satoshipay/stellar-core`                        |
| `image.tag`                         | `stellar-core` image tag                                           | `10.0.0-2`                                        |
| `image.flavor`                      | `stellar-core` flavor (e.g., `aws` or `gcloud`)                    | Not set                                          |
| `image.pullPolicy`                  | Image pull policy                                                  | `IfNotPresent`                                   |
| `peerService.type`                  | p2p service type                                                   | `LoadBalancer`                                   |
| `peerService.port`                  | p2p service TCP port                                               | `11625`                                          |
| `peerService.loadBalancerIP`        | p2p service load balancer IP                                       | Not set                                          |
| `peerService.externalTrafficPolicy` | p2p service traffic policy                                         | Not set                                          |
| `httpService.type`                  | Non-public HTTP admin endpoint service type                        | `ClusterIP`                                      |
| `httpService.port`                  | Non-public HTTP admin endpoint TCP port                            | `11626`                                          |
| `persistence.enabled`               | Use a PVC to persist data                                          | `true`                                           |
| `persistence.existingClaim`         | Provide an existing PersistentVolumeClaim                          | Not set                                          |
| `persistence.storageClass`          | Storage class of backing PVC                                       | Not set (uses alpha storage class annotation)    |
| `persistence.accessMode`            | Use volume as ReadOnly or ReadWrite                                | `ReadWriteOnce`                                  |
| `persistence.annotations`           | Persistent Volume annotations                                      | `{}`                                             |
| `persistence.size`                  | Size of data volume                                                | `8Gi`                                            |
| `persistence.subPath`               | Subdirectory of the volume to mount at                             | `stellar-core`                                   |
| `persistence.mountPath`             | Mount path of data volume                                          | `/data`                                          |
| `resources`                         | CPU/Memory resource requests/limits                                | Requests: `512Mi` memory, `100m` CPU             |
| `nodeSelector`                      | Node labels for pod assignment                                     | {}                                               |
| `tolerations`                       | Toleration labels for pod assignment                               | []                                               |
| `affinity`                          | Affinity settings for pod assignment                               | {}                                               |
| `serviceAccount.create`             | Specifies whether a ServiceAccount should be created               | `true`                                           |
| `serviceAccount.name`               | The name of the ServiceAccount to create                           | Generated using the fullname template            |

## Persistence

Both Stellar Core and PostgreSQL (if `postgresql.enabled` is `true`) need to store data and thus this chart creates [Persistent Volumes](http://kubernetes.io/docs/user-guide/persistent-volumes/) by default. Make sure to size them properly for your needs and use an appropriate storage class, e.g. SSDs.

You can also use existing claims with the `persistence.existingClaim` and `postgresql.persistence.existingClaim` options.
