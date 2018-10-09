# Stellar Friendbot

[Stellar](https://www.stellar.org) is an open-source and distributed payments infrastructure. Stellar Friendbot is a simple server that sends funds from the friendbot's account to another account. Friendbot is usually deployed in a test network.

## Introduction

This chart bootstraps a [Stellar Friendbot](https://github.com/stellar/go/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. The chart is based on the Kubernetes-ready [Stellar Friendbot images provided by SatoshiPay](https://github.com/satoshipay/docker-stellar-friendbot/).

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/stellar-friendbot
```

## Configuration

The following table lists the configurable parameters of the Stellar Friendbot chart and their default values.

| Parameter                           | Description                                                              | Default                                          |
| -----------------------             | ---------------------------------------------                            | ---------------------------------------------    |
| `accountSecret`                     | Friendbot's account secret (if `existingAccountSecretSecret` is not set) | Not set                                          |
| `existingAccountSecretSecret`       | Existing secret with the account secret (if `accountSecret` is not set)  | Not set                                          |
| `existingAccountSecretSecret.name`  | Secret containing the account secret                                     | Not set                                          |
| `existingAccountSecretSecret.key`   | Key of the account secret in the secret                                  | Not set                                          |
| `networkPassphrase`                 | The network the friendbot should use                                     | `Public Global Stellar Network ; September 2015` |
| `horizonUrl`                        | URL of Stellar Horizon where the transaction should be submitted         | `https://horizon.stellar.org`                    |
| `startingBalance`                   | Starting balance of newly funded accounts                                | `10000`                                          |
| `environment`                       | Additional environment variables for Stellar Friendbot                   | `{}`                                             |
| `image.repository`                  | `stellar-friendbot` image repository                                     | `satoshipay/stellar-friendbot`                   |
| `image.tag`                         | `stellar-friendbot` image tag                                            | `0.13.0`                                         |
| `image.pullPolicy`                  | Image pull policy                                                        | `IfNotPresent`                                   |
| `service.type`                      | HTTP endpoint service type                                               | `ClusterIP`                                      |
| `service.port`                      | HTTP endpoint TCP port                                                   | `80`                                             |
| `resources`                         | CPU/Memory resource requests/limits                                      | Requests: `128Mi` memory, `10m` CPU             |
| `nodeSelector`                      | Node labels for pod assignment                                           | {}                                               |
| `tolerations`                       | Toleration labels for pod assignment                                     | []                                               |
| `affinity`                          | Affinity settings for pod assignment                                     | {}                                               |
| `serviceAccount.create`             | Specifies whether a ServiceAccount should be created                     | `true`                                           |
| `serviceAccount.name`               | The name of the ServiceAccount to create                                 | Generated using the fullname template            |
