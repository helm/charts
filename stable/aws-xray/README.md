# aws-xray

[AWS X-Ray](https://aws.amazon.com/xray/) helps you debug and analyze your microservices applications with request tracing.

## TL;DR;

```console
$ helm install stable/aws-xray
```

## Introduction

This chart bootstraps a [AWS X-Ray](https://aws.amazon.com/xray/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/aws-xray
```

The command deploys AWS X-Ray on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the AWS X-Ray chart and their default values.

| Parameter                            | Description                                 | Default                                                    |
| -------------------------------      | -------------------------------             | ---------------------------------------------------------- |
| `image.repository`                   | aws-xray image                              | `okgolove/aws-xray`                                        |
| `image.tag`                          | aws-xray image tag                          | `3.0.0`                                                    |
| `pullPolicy`                         | Image pull policy                           | `IfNotPresent`                                             |
| `rbac.create`                        | Install required rbac clusterrole           | `true`                                                     |
| `serviceAccount.create`              | Enable ServiceAccount creation              | `true`                                                     |
| `serviceAccount.name`                | ServiceAccount for AWS X-Ray pods           | `default`                                                  |
| `xray.region`                        | AWS region you deploy AWS X-Ray to          | ``                                                         |
| `xray.loglevel`                      | AWS X-Ray daemon log level                  | `prod`                                                     |
| `service.port`                       | Service UDP port                            | `2000`                                                     |
| `nodeSelector`                       | Node labels for pod assignment              | `{}`                                                       |
| `tolerations`                        | List of node taints to tolerate             | `[]`                                                       |
| `affinity`                           | Map of node/pod affinities                  | `{}`                                                       |
| `resources`                          | CPU/Memory resource requests/limits         | `{}`
Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set aws-xray.port=8080,serviceAccount.name=aws-xray \
    stable/aws-xray
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/aws-xray
```

> **Tip**: You can use the default [values.yaml](values.yaml)
