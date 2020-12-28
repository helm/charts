# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# aws-alb-ingress-controller

[aws-alb-ingress-controller](https://github.com/kubernetes-sigs/aws-alb-ingress-controller) satisfies Kubernetes ingress resources by provisioning Application Load Balancers.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

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

| Parameter                         | Description                                                                                                      | Default                                                                   |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| `affinity`                        | Affinity for pod assignment                                                                                      | `{}`                                                                      |
| `awsRegion`                       | AWS region of k8s cluster, required if ec2metadata is unavailable from controller pod                            | `"us-east-2"`                                                             |
| `autoDiscoverAwsRegion`           | Auto discover awsRegion from ec2metadata, omit awsRegion when this set to true                                   | `false`                                                                   |
| `awsVpcID`                        | AWS VPC ID of k8s cluster, required if ec2metadata is unavailable from controller pod                            | `"vpc-xxx"`                                                               |
| `autoDiscoverAwsVpcID`            | Auto discover awsVpcID from ec2metadata, omit awsRegion when this set to true                                    | `false`                                                                   |
| `clusterName`                     | (REQUIRED) Resources created by the ALB Ingress controller will be prefixed with this string                     | `k8s`                                                                     |
| `containerSecurityContext`        | Set to security context for container                                                                            | `{}`                                                                      |
| `enableReadinessProbe`            | Enable readinessProbe on controller pod                                                                          | `false`                                                                   |
| `enableLivenessProbe`             | Enable livenessProbe on controller pod                                                                           | `false`                                                                   |
| `extraEnv`                        | Map of environment variables to be injected into the controller pod                                              | `{}`                                                                      |
| `fullnameOverride`                | Custom fullname override for the chart                                                                           | `""`                                                                      |
| `image.pullPolicy`                | Controller container image pull policy                                                                           | `IfNotPresent`                                                            |
| `image.repository`                | Controller container image repository                                                                            | `docker.io/amazon/aws-alb-ingress-controller`                             |
| `image.tag`                       | Controller container image tag                                                                                   | `v1.1.8`                                                                  |
| `livenessProbeInitialDelay`       | How long to wait (in seconds) before checking the liveness probe                                                 | `30`                                                                      |
| `livenessProbeTimeout`            | How long to wait before timeout (in seconds) when checking controller liveness                                   | `1`                                                                       |
| `nameOverride`                    | Custom name override for the chart                                                                               | `""`                                                                      |
| `nodeSelector`                    | Node labels for controller pod assignment                                                                        | `{}`                                                                      |
| `podAnnotations`                  | Annotations to be added to controller pod                                                                        | `{}`                                                                      |
| `podLabels`                       | Labels to be added to controller pod                                                                             | `{}`                                                                      |
| `priorityClassName`               | Set to ensure your pods survive resource shortages                                                               | `""`                                                                      |
| `rbac.create`                     | If true, create & use RBAC resources                                                                             | `true`                                                                    |
| `rbac.serviceAccount.annotations` | Service Account annotations                                                                                      | `{}`                                                                      |
| `rbac.serviceAccount.create`      | If true and `rbac.create` is also `true`, a service account will be created                                      | `true`                                                                    |
| `rbac.serviceAccount.name`        | Existing ServiceAccount to use (ignored if `rbac.create=true` and `rbac.serviceAccount.create=true`)             | `default`                                                                 |
| `readinessProbeInitialDelay`      | How long to wait (in seconds) before checking the readiness probe                                                | `30`                                                                      |
| `readinessProbeInterval`          | How often (in seconds) to check controller readiness                                                             | `60`                                                                      |
| `readinessProbeTimeout`           | How long to wait before timeout (in seconds) when checking controller readiness                                  | `3`                                                                       |
| `replicaCount`                    | Number of ALB controller replicas                                                                                | `1`                                                                       |
| `securityContext`                 | Set to security context for pod                                                                                  | `{}`                                                                      |
| `resources`                       | Controller pod resource requests & limits                                                                        | `{}`                                                                      |
| `securityContext`                 | Set to security context for pod                                                                                  | `{}`                                                                      |
| `scope.ingressClass`              | If provided, the ALB ingress controller will only act on Ingress resources annotated with this class             | `alb`                                                                     |
| `scope.singleNamespace`           | If true, the ALB ingress controller will only act on Ingress resources in a single namespace                     | `false` (watch all namespaces)                                            |
| `scope.watchNamespace`            | If `scope.singleNamespace=true`, the ALB ingress controller will only act on Ingress resources in this namespace | `""` (namespace of the ALB ingress controller)                            |
| `tolerations`                     | Controller pod toleration for taints                                                                             | `{}`                                                                      |
| `volumesMounts`                   | VolumeMounts into the controller pod                                                                             | `[]`                                                                      |
| `volumes`                         | Volumes the controller pod                                                                                       | `[]`                                                                      |

```bash
helm install incubator/aws-alb-ingress-controller --set clusterName=MyClusterName --set autoDiscoverAwsRegion=true --set autoDiscoverAwsVpcID=true --name my-release --namespace kube-system
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install incubator/aws-alb-ingress-controller --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

> **Tip**: If you use `aws-alb-ingress-controller` as releaseName, the generated pod name will be shorter.(e.g. `aws-alb-ingress-controller-66cc9fb67c-7mg4w` instead of `my-release-aws-alb-ingress-controller-66cc9fb67c-7mg4w`)

## Upgrading to v1.0.2
[AWS ALB Ingress Controller](https://github.com/kubernetes-sigs/aws-alb-ingress-controller) indicates that there is an incompatible breaking change needing manual actions. The below instructions are based on [the official annotation guide](https://github.com/kubernetes-sigs/aws-alb-ingress-controller/blob/master/docs/guide/ingress/annotation.md#wafv2).

This version of controller needs [new IAM permissions](https://github.com/kubernetes-sigs/aws-alb-ingress-controller/blob/0338ed144f584c7a7738b4bf1d8ca8c827e7abb0/docs/examples/iam-policy.json#L117-L126).

***Notices***:
- **New IAM permission is required even no wafv2 annotation is used.**
- WAFV2 support can be disabled by controller flags `--feature-gates=wafv2=false`
