# aws-alb-ingress-controller

[aws-alb-ingress-controller](https://github.com/kubernetes-sigs/aws-alb-ingress-controller) satisfies Kubernetes ingress resources by provisioning Application Load Balancers.

## TL;DR:
```bash
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm install incubator/aws-alb-ingress-controller --set clusterName=MyClusterName --set autoDiscoverAwsRegion=true --set autoDiscoverAwsVpcID=true
```

## Introduction

This chart bootstraps an alb-ingress-controller deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9+ with Beta APIs enabled

## Enable helm incubator repository
```bash
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
```

## Installing the Chart
To install the chart with the release name `my-release` into `kube-system`:

```bash
helm install incubator/aws-alb-ingress-controller --set clusterName=MyClusterName --set autoDiscoverAwsRegion=true --set autoDiscoverAwsVpcID=true --name my-release --namespace kube-system
```

The command deploys alb-ingress-controller on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the alb-ingress-controller chart and their default values.

| Parameter                 | Description                                                                                                    | Default                                                                   |
| ------------------------- | -------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| `clusterName`             | (REQUIRED) Resources created by the ALB Ingress controller will be prefixed with this string                   | N/A                                                                       |
| `awsRegion`               | AWS region of k8s cluster, required if ec2metadata is unavailable from controller pod                          | `us-west-2 `                                                              |
| `autoDiscoverAwsRegion`   | auto discover awsRegion from ec2metadata, omit awsRegion when this set to true                                 | false                                                                     |
| `awsVpcID`                | AWS VPC ID of k8s cluster, required if ec2metadata is unavailable from controller pod                          | `vpc-xxx`                                                                 |
| `autoDiscoverAwsVpcID`    | auto discover awsVpcID from ec2metadata, omit awsRegion when this set to true                                  | false                                                                     |
| `image.repository`        | controller container image repository                                                                          | `docker.io/amazon/aws-alb-ingress-controller` |
| `image.tag`               | controller container image tag                                                                                 | `v1.1.3`                                                                  |
| `image.pullPolicy`        | controller container image pull policy                                                                         | `IfNotPresent`                                                            |
| `enableReadinessProbe`    | enable readinessProbe on controller pod                                                                      | `false`                                                                    |
| `enableLivenessProbe`     | enable livenessProbe on controller pod                                                                         | `false`                                                                   |
| `livenessProbeTimeout`     | How long to wait before timeout (in seconds) when checking controller liveness                                |    1                                                                      |
| `extraEnv`                | map of environment variables to be injected into the controller pod                                            | `{}`                                                                      |
| `volumesMounts`           | volumeMounts into the controller pod                                                                           | `[]`                                                                      |
| `volumes`                 | volumes the controller pod                                                                                     | `[]`                                                                      |
| `nodeSelector`            | node labels for controller pod assignment                                                                      | `{}`                                                                      |
| `tolerations`             | controller pod toleration for taints                                                                           | `{}`                                                                      |
| `podAnnotations`          | annotations to be added to controller pod                                                                      | `{}`                                                                      |
| `podLabels`               | labels to be added to controller pod                                                                           | `{}`                                                                      |
| `priorityClassName`       | set to ensure your pods survive resource shortages                                                             | `""`                                                                      |
| `resources`               | controller pod resource requests & limits                                                                      | `{}`                                                                      |
| `rbac.create`             | If true, create & use RBAC resources                                                                           | `true`                                                                    |
| `rbac.serviceAccountName` | ServiceAccount ALB ingress controller will use (ignored if rbac.create=true)                                   | `default`                                                                 |
| `scope.ingressClass`      | If provided, the ALB ingress controller will only act on Ingress resources annotated with this class           | `alb`                                                                     |
| `scope.singleNamespace`   | If true, the ALB ingress controller will only act on Ingress resources in a single namespace                   | `false` (watch all namespaces)                                            |
| `scope.watchNamespace`    | If scope.singleNamespace=true, the ALB ingress controller will only act on Ingress resources in this namespace | `""` (namespace of the ALB ingress controller)                            |

```bash
helm install incubator/aws-alb-ingress-controller --set clusterName=MyClusterName --set autoDiscoverAwsRegion=true --set autoDiscoverAwsVpcID=true --name my-release --namespace kube-system
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install incubator/aws-alb-ingress-controller --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

> **Tip**: If you use `aws-alb-ingress-controller` as releaseName, the generated pod name will be shorter.(e.g. `aws-alb-ingress-controller-66cc9fb67c-7mg4w` instead of `my-release-aws-alb-ingress-controller-66cc9fb67c-7mg4w`)
