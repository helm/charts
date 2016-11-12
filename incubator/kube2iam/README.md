# kube2iam

* Installs [kube2iam](https://github.com/jtblin/kube2iam) to provide IAM credentials to containers running inside a kubernetes cluster based on annotations.

## TL;DR;

```console
$ helm install incubator/kube2iam
```

## Introduction

This chart bootstraps a [kube2iam](https://github.com/jtblin/kube2iam) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/kube2iam
```

The command deploys kube2iam on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the kube2iam chart and their default values.

| Parameter                   | Description                                | Default                                                    |
| --------------------------- | ------------------------------------------ | ---------------------------------------------------------- |
| `image`                     | Image                                      | `jtblin/kube2iam`                                          |
| `imageTag`                  | Image tag                                  | `0.2.2`                                                    |
| `imagePullPolicy`           | Image pull policy                          | `Always` if `imageTag` is `latest`, else `IfNotPresent`    |
| `resources.limits.cpu`      | CPU limit                                  | `100m`                                                     |
| `resources.limits.memory`   | Memory limit                               | `200Mi`                                                    |
| `resources.requests.cpu`    | CPU request                                | `100m`                                                     |
| `resources.requests.memory` | Memory request                             | `200Mi`                                                    |
| `hostNetwork`               | Host network                               | `true`                                                     |
| `securityContext.privileged`| Security context privileged                | `true`                                                     |
| `awsRegion`                 | AWS region                                 | `us-east-1`                                                |
| `baseRoleArn`               | Base role arn                              | `nil`                                                      |
| `defaultRole`               | Default role                               | `nil`                                                      |
| `hostInterface`             | Host interface                             | `nil`                                                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set awsRegion=us-east-1,hostInterface=cbr0 \
    incubator/kube2iam
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/kube2iam
```
