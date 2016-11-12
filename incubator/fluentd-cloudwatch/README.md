# Fluentd CloudWatch

* Installs [Fluentd](https://www.fluentd.org/) [Cloudwatch](https://aws.amazon.com/cloudwatch/) log forwarder.

## TL;DR;

```console
$ helm install incubator/fluentd-cloudwatch
```

## Introduction

This chart bootstraps a [Fluentd](https://www.fluentd.org/) [Cloudwatch](https://aws.amazon.com/cloudwatch/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/fluentd-cloudwatch
```

The command deploys Fluentd Cloudwatch on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Fluentd Cloudwatch chart and their default values.

| Parameter                  | Description                                | Default                                                    |
| -------------------------- | ------------------------------------------ | ---------------------------------------------------------- |
| `image`                    | Image                                      | `18fgsa/fluentd-cloudwatch`                                |
| `imageTag`                 | Image tag                                  | `0.1.0`                                                    |
| `imagePullPolicy`          | Image pull policy                          | `Always` if `imageTag` is `latest`, else `IfNotPresent`    |
| `resources.limits.cpu`     | CPU limit                                  | `100m`                                                     |
| `resources.limits.memory`  | Memory limit                               | `200Mi`                                                    |
| `resources.requests.cpu`   | CPU request                                | `100m`                                                     |
| `resources.requests.memory`| Memory request                             | `200Mi`                                                    |
| `hostNetwork`              | Host network                               | `false`                                                    |
| `annotations`              | Annotations                                | `nil`                                                      |
| `awsRegion`                | AWS Cloudwatch region                      | `us-east-1`                                                |
| `logGroupName`             | AWS Cloudwatch log group                   | `kubernetes`                                               |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set awsRegion=us-east-1 \
    incubator/fluentd-cloudwatch
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/fluentd-cloudwatch
```

### Files

| File name                  | Description                                       |
|----------------------------|---------------------------------------------------|
| `td-agent.conf`             | Fluentd configuration file                        |
