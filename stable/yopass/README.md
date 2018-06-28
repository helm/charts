# Yopass

[Yopass](https://yopass.se/) is an application to securely share one-time secrets. A demo is [available here](https://yopass.se).

## Introduction

This chart stands up a Yopass installation. This includes:

- A [Yopass](https://github.com/jhaals/yopass) Pod
- [Memcached](https://hub.docker.com/r/_/memcached/)

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release` run:

```bash
$ helm install --name my-release \
    --set externalUrl=http://your-domain.com/ stable/yopass
```

Note that you _must_ pass in externalUrl, or you'll end up with a non-functioning release.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

Refer to [values.yaml](values.yaml) for more details on defaults.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install --name my-release \
    --set externalUrl=http://your-domain.com/,serviceType=LoadBalancer \
    stable/yopass
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/yopass
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

Persistence of secret data is ephemeral.
