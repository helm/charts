# Bitgod Helm Chart

Drop-in replacement for bitcoind JSON-RPC which proxies to the BitGo API

## Introduction

This chart bootstraps a single bitgod deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.7+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release ./bitgod
```

The command deploys bitgod on the Kubernetes cluster in the default configuration.
The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the bitgod chart and their default values.

| Parameter           | Description                         | Default             |
| ------------------- | ----------------------------------- | --------------------|
| `image.repository`  | `bitgod` image repository.          | `rubykube/bitgod`   |
| `image.tag`         | `bitgod` image tag.                 | Most recent release |
| `image.pullPolicy`  | `bitgod` image pull policy          | `Always`            |
| `service.type`      | Service type                        | `ClusterIP`         |
| `service.name`      | Service name                        | `bitgod`            |
| `service.port`      | Port to run `bitgod`                | `19332`             |
| `bitgo.enabled`     | Job for specifing Bitgo wallet ID   | `false`             |
| `bitgo.wallet`      | `Bitgo` wallet ID                   | `nil`               |
| `bitgo.accessToken` | `Bitgo` access token                | `nil`               |
| `testnet`           | Network and Environment             | `true`              |
| `rpc.user`          | `JSON-RPC` user                     | `bitgod`            |
| `rpc.password`      | `JSON-RPC` password                 | `changeme`          |
| `resources`         | CPU/Memory resource requests/limits | `{}`                |
| `config.bitgod`     | Additional configs for bitcoind     | `{}`                |
| `config.bitcoind`   | Additional configs for bitgod       | `{}`                |

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml ./bitgod
```

## Production

Put `testnet: false` and `bitgo.enabled: false` into `values.yaml`.

Helm deploys bitgod on the Kubernetes cluster

```bash
$ helm install --name my-production-release -f values.yaml ./bitgod
```

After that, you should create token on www.bitgo.com. Then execute to container and set bitgo `accessToken` and `wallet`.

```bash
$ kubectl exec -it <pod_name> sh
$ bitcoin-cli settoken <token>
$ bitcoin-cli setwallet <wallet_id>
```