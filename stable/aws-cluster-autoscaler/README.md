# aws-cluster-autoscaler

[The cluster autoscaler on AWS](https://github.com/kubernetes/contrib/tree/master/cluster-autoscaler/cloudprovider/aws) scales worker nodes within an autoscaling group.

## TL;DR;

```console
$ helm install stable/aws-cluster-autoscaler
```

## Introduction

This chart bootstraps an aws-cluster-autoscaler deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.3+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/aws-cluster-autoscaler
```

The command deploys aws-cluster-autoscaler on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the aws-cluster-autoscaler chart and their default values.

Parameter | Description | Default
--- | --- | ---
`annotations` | annotations to add to each pod | none
`autoscalingGroups[].maxSize` | maximum autoscaling group size | `1`
`autoscalingGroups[].minSize` | minimum autoscaling group size | `1`
`autoscalingGroups[].name` | autoscaling group name | none
`awsRegion` | AWS region | `us-east-1`
`expander` | algorithm to use when scaling | `least-waste`
`image.repository` | Image | `gcr.io/google_containers/cluster-autoscaler`
`image.tag` | Image tag | `v0.4.0`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`resources.limits.cpu` | CPU limit | `100m`
`resources.limits.memory` | Memory limit | `300Mi`
`resources.requests.cpu` | CPU request | `100m`
`resources.requests.memory` | Memory request | `300Mi`
`scaleDownDelay` | time to wait between scaling operations | `10m` (10 minutes)
`skipNodes.withLocalStorage` | don't terminate nodes running pods that use local storage | `false`
`skipNodes.withSystemPods` | don't terminate nodes running pods in the `kube-system` namespace | `true`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set asg.name=kubernetes-workers \
    stable/aws-cluster-autoscaler
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/aws-cluster-autoscaler
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Expanders
From the upstream [docs](https://github.com/kubernetes/contrib/blob/master/cluster-autoscaler/expander/EXPANDERS.md):
> Currently cluster-autoscaler has 3 expanders, but we anticipate more in the future:
>
`random` - this is the default expander, and should be used when you don't have a particular need for the node groups to scale differently
>
`most-pods` - this selects the node group that would be able to schedule the most pods when scaling up. This is useful when you are using nodeSelector to make sure certain pods land on certain nodes. Note that this won't cause the autoscaler to select bigger nodes vs. smaller, as it can grow multiple smaller nodes at once
>
`least-waste` - this selects the node group that will have the least idle CPU (and if tied, unused Memory) node group when scaling up. This is useful when you have different classes of nodes, for example, high CPU or high Memory nodes, and only want to expand those when pods that need those requirements are to be launched.

## IAM Permissions
The worker running the cluster autoscaler will need access to certain resources and actions:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": "*"
        }
    ]
}
```
Unfortunately AWS does not support ARNs for autoscaling groups yet so you must use "*" as the resource. More information [here](http://docs.aws.amazon.com/autoscaling/latest/userguide/IAM.html#UsingWithAutoScaling_Actions).
