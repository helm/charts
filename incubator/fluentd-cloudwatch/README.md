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
- [kube2iam](../../stable/kube2iam) installed to used the **awsRole** config option

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ # use ec2 instance role credential
$ helm install --name my-release incubator/fluentd-cloudwatch
$ # or add aws_access_key_id and aws_access_key_id with the key/password of a AWS user with a policy to access  Cloudwatch
$ helm install --name my-release incubator/fluentd-cloudwatch --set awsAccessKeyId=aws_access_key_id_here --set awsSecretAccessKey=aws_secret_access_key_here
$ # or add a role to aws with the correct policy to add to cloud watch
$ helm install --name my-release incubator/fluentd-cloudwatch --set awsRole=roll_name_here
```

The command deploys Fluentd Cloudwatch on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Fluentd Cloudwatch chart and their default values.

| Parameter                    | Description                                                                     | Default                               |
| ---------------------------- | ------------------------------------------------------------------------------- | --------------------------------------|
| `image.repository`           | Image repository                                                                | `fluent/fluentd-kubernetes-daemonset` |
| `image.tag`                  | Image tag                                                                       | `v1.3.3-debian-cloudwatch-1.0`        |
| `image.pullPolicy`           | Image pull policy                                                               | `IfNotPresent`                        |
| `resources.limits.cpu`       | CPU limit                                                                       | `100m`                                |
| `resources.limits.memory`    | Memory limit                                                                    | `200Mi`                               |
| `resources.requests.cpu`     | CPU request                                                                     | `100m`                                |
| `resources.requests.memory`  | Memory request                                                                  | `200Mi`                               |
| `hostNetwork`                | Host network                                                                    | `false`                               |
| `podAnnotations`             | Annotations                                                                     | `{}`                                  |
| `podSecurityContext`         | Security Context                                                                | `{}`                                  |
| `awsRegion`                  | AWS Cloudwatch region                                                           | `us-east-1`                           |
| `awsRole`                    | AWS IAM Role To Use                                                             | `nil`                                 |
| `awsAccessKeyId`             | AWS Access Key Id of a AWS user with a policy to access Cloudwatch              | `nil`                                 |
| `awsSecretAccessKey`         | AWS Secret Access Key of a AWS user with a policy to access Cloudwatch          | `nil`                                 |
| `data`                       | Fluentd ConfigMap values. The main configuration is defined under `fluent.conf` | `example configuration`               |
| `logGroupName`               | AWS Cloudwatch log group                                                        | `kubernetes`                          |
| `rbac.create`                | If true, create & use RBAC resources                                            | `false`                               |
| `rbac.serviceAccountName`    | existing ServiceAccount to use (ignored if rbac.create=true)                    | `default`                             |
| `rbac.pspEnabled`            | PodSecuritypolicy                                                               | `false`                               |
| `tolerations`                | Add tolerations                                                                 | `[]`                                  |
| `extraVars`                  | Add pod environment variables (must be specified as a single line object)       | `[]`                                  |
| `updateStrategy`             | Define daemonset update strategy                                                | `OnDelete`                            |
| `nodeSelector`               | Node labels for pod assignment                                                  | `{}`                                  |
| `affinity`                   | Node affinity for pod assignment                                                | `{}`                                  |
| `priorityClassName`          | Set priority class for daemon set                                               | `nil`                                 |
| `busybox.repository`         | Image repository of busybox                                                     | `busybox`                             |
| `busybox.tag`                | Image tag of busybox                                                            | `1.31.0`                              |


If using fluentd-kubernetes-daemonset v0.12.43-cloudwatch, the container runs as user fluentd. To be able to write pos files to the host system, you'll need to run fluentd as root. Add the following extraVars value to run as root.

```code
"{ name: FLUENT_UID, value: '0' }"
```

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set awsRegion=us-east-1 \
    incubator/fluentd-cloudwatch
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/fluentd-cloudwatch
```
