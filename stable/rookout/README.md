# Rookout

[Rookout](http://rookout.com/) gets data from your live code, as it runs. Extract any piece of data from your code and pipeline it anywhere, in realtime, even if you’d never thought about it beforehand or created any instrumentation to collect it.

## TL;DR;

```bash
$ helm install --name my-release stable/rookout --set rookout.token=YOUR_ORGANIZATIONAL_TOKEN
```

## Introduction

This chart bootstraps a [Rookout ETL Agent](https://docs.rookout.com/docs/agent-setup.html) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/rookout --set rookout.token=YOUR_ORGANIZATIONAL_TOKEN
```

The command deploys Rookout on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Rookout Router chart and their default values.

|            Parameter                      |              Description                 |                          Default                        | 
| ----------------------------------------- | ---------------------------------------- | ------------------------------------------------------- |
| `rookout.token`                           | Rookout organizational token             | `Nil` You must provide your own token                   |  
| `rookout.listenAll`                       | Configuring the agent to listen on all addresses instead of only localhost.                        | `False` Listens only on localhost |
| `rookout.resources.requests.cpu`          | CPU resource requests                    | `30m`                                                   |
| `rookout.resources.limits.cpu`            | CPU resource limits                      | `4000m`                                                 |
| `rookout.resources.requests.memory`       | Memory resource requests                 | `32Mi`                                                  |
| `rookout.resources.limits.memory`         | Memory resource limits                   | `1024Mi`                                                |
| `rookout.internalResources.limits.cpu`    | Rookout ETL Agent internal cpu limit, measured in number of full cpus     | `4`                    |
| `rookout.internalReources.limits.memory`  | Rookout ETL Agent internal memory limit, measured in Mb                 | `1024`                   |
| `image.registry`                          | Rookout image registry                   | `docker.io`                                             |
| `image.repository`                        | Rookout image name                       | `rookout/agent`                                         |
| `image.tag`                               | Rookout image tag                        | `{VERSION}`                                             |
| `image.pullPolicy`                        | Image pull policy                        | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `image.pullSecrets`                       | Specify image pull secrets               | `nil`                                                   |


The above parameters map to the env variables defined in [rookout/agent](https://docs.rookout.com/docs/agent-setup.html). For more information please refer to the [rookout/agent](https://hub.docker.com/r/rookout/agent/) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set rookout.token=YOUR_ORGANIZATIONAL_TOKEN,listenAll=False \
    stable/rookout
```

The above command sets the Rookout Router token to your organizational token. Additionally, it sets the listenAll to `False`.

> **Tip**: You can use the default [values.yaml](values.yaml)
