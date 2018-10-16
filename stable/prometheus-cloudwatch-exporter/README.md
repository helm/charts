# Cloudwatch exporter

* Installs [cloudwatch exporter](http://github.com/prometheus/cloudwatch_exporter)

## TL;DR;

```console
$ helm install stable/prometheus-cloudwatch-exporter
```

## Introduction

This chart bootstraps a [cloudwatch exporter](http://github.com/prometheus/cloudwatch_exporter) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- [kube2iam](../../stable/kube2iam) installed to used the **aws.role** config option otherwise configure **aws.aws_access_key_id** and **aws.aws_secret_access_key**

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ # edit aws.aws_access_key_id and aws.aws_access_key_id with the key/password of a AWS user with a policy to access  Cloudwatch
$ helm install --name my-release stable/prometheus-cloudwatch-exporter
$ # or add a role to aws with the [correct policy](https://github.com/prometheus/cloudwatch_exporter#credentials-and-permissions) to add to cloud watch
$ helm install --name my-release stable/prometheus-cloudwatch-exporter --set awsRole=roll_name_here
```

The command deploys Cloudwatch exporter on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Cloudwatch Exporter chart and their default values.

|          Parameter          |                      Description                       |          Default           |
| --------------------------- | ------------------------------------------------------ | -------------------------- |
| `image.repository`          | Image                                                  | `prom/cloudwatch-exporter` |
| `image.tag`                 | Image tag                                              | `cloudwatch_exporter-0.5.0`                   |
| `image.pullPolicy`          | Image pull policy                                      | `IfNotPresent`             |
| `service.type`              | Service type                                           | `ClusterIP`                |
| `service.port`              | The service port                                       | `80`                       |
| `service.portName`          | The name of the service port                           | `http`                     |
| `service.targetPort`        | The target port of the container                       | `9100`                     |
| `service.annotations`       | Custom annotations for service                         | `{}`                       |
| `service.labels`            | Additional custom labels for the service               | `{}`                       |
| `resources`                 |                                                        | `{}`                       |
| `aws.region`                | AWS Cloudwatch region                                  | `eu-west-1`                |
| `aws.role`                  | AWS IAM Role To Use                                    |                            |
| `aws.aws_access_key_id`     | AWS access key id                                      |                            |
| `aws.aws_secret_access_key` | AWS secret access key                                  |                            |
| `config`                    | Cloudwatch exporter configuration                      | `example configuration`    |
| `rbac.create`               | If true, create & use RBAC resources                   | `false`                    |
| `serviceAccount.create`     | Specifies whether a service account should be created. | `true`                     |
| `serviceAccount.name`       | Name of the service account.                           |                            |
| `tolerations`               | Add tolerations                                        | `[]`                       |
| `nodeSelector`              | node labels for pod assignment                         | `{}`                       |
| `affinity`                  | node/pod affinities                                    | `{}`                       |
| `livenessProbe`             | Liveness probe settings                                |                            |
| `readinessProbe`            | Readiness probe settings                               |                            |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set aws.region=us-east-1 --set aws.role=my-aws-role \
    stable/prometheus-cloudwatch-exporter
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/prometheus-cloudwatch-exporter
```
