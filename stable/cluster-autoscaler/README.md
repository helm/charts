# cluster-autoscaler

[The cluster autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler) scales worker nodes within an AWS autoscaling group or Spotinst Elastigroup.

## TL;DR:

## Helm < 2.5

```console
$ helm install stable/cluster-autoscaler --name my-release -f values.yaml
```
Where `values.yaml` contains:

```
autoscalingGroups:
  - name: your-scaling-group-name
    maxSize: 10
    minSize: 1
```
## Helm >= 2.5

```console
$ helm install stable/cluster-autoscaler --name my-release --set "autoscalingGroups[0].name=your-asg-name,autoscalingGroups[0].maxSize=10,autoscalingGroups[0].minSize=1"
```

## Introduction

This chart bootstraps an cluster-autoscaler deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.3+ with Beta APIs enabled

## Installing the Chart

In order for the chart to configure the cluster-autoscaler properly during the installation process, you must provide some minimal configuration which can't rely on defaults. This includes at least one element in the `autoscalingGroups` array and its three values: `name`, `minSize` and `maxSize`. If you are using Helm < 2.5 these parameters cannot be passed to helm using the `--set` parameter, so you must supply these using a `values.yaml` file such as:

```
autoscalingGroups:
  - name: your-scaling-group-name
    maxSize: 10
    minSize: 1
```

To install the chart with the release name `my-release`:

## Helm < 2.5

```console
$ helm install stable/cluster-autoscaler --name my-release -f values.yaml
```

## Helm >= 2.5

```console
$ helm install stable/cluster-autoscaler --name my-release --set "autoscalingGroups[0].name=your-asg-name,autoscalingGroups[0].maxSize=10,autoscalingGroups[0].minSize=1"
```

The command deploys cluster-autoscaler on the Kubernetes cluster using the supplied configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Verifying Installation

The chart will succeed even if the three required parameters are not supplied. To verify the cluster-autoscaler is configured properly find a pod that the deployment created and describe it. It must have a `--nodes` argument supplied to the `./cluster-autoscaler` app under `Command`. For example (all other values are omitted for brevity):

```
Containers:
  cluster-autoscaler:
    Command:
      ./cluster-autoscaler
      --cloud-provider=aws
      --nodes=1:10:your-scaling-group-name
      --scale-down-delay=10m
      --skip-nodes-with-local-storage=false
      --skip-nodes-with-system-pods=true
      --v=4
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the cluster-autoscaler chart and their default values.

Parameter | Description | Default
--- | --- | ---
`affinity` | node/pod affinities | None
`autoscalingGroups[].name` | autoscaling group name | None. You *must* supply at least one.
`autoscalingGroups[].maxSize` | maximum autoscaling group size | None. You *must* supply at least one.
`autoscalingGroups[].minSize` | minimum autoscaling group size | None. You *must* supply at least one.
`awsRegion` | AWS region (required if `cloudProvider=aws`) | `us-east-1`
`cloudProvider` | `aws` or `spotinst` are currently supported | `aws`
`image.repository` | Image (used if `cloudProvider=aws`) | `gcr.io/google_containers/cluster-autoscaler`
`image.tag` | Image tag (used if `cloudProvider=aws`) | `v0.6.0`
`image.pullPolicy` | Image pull policy (used if `cloudProvider=aws`) | `IfNotPresent`
`extraArgs` | additional container arguments | `{}`
`nodeSelector` | node labels for pod assignment | `{}`
`podAnnotations` | annotations to add to each pod | `{}`
`rbac.create` | If true, create & use RBAC resources | `false`
`rbac.serviceAccountName` | existing ServiceAccount to use (ignored if rbac.create=true) | `default`
`replicaCount` | desired number of pods | `1`
`resources` | pod resource requests & limits | `{}`
`service.annotations` | annotations to add to service | none
`service.clusterIP` | IP address to assign to service | `""`
`service.externalIPs` | service external IP addresses | `[]`
`service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`service.servicePort` | service port to expose | `8085`
`service.type` | type of service to create | `ClusterIP`
`spotinst.account` | Spotinst Account ID (required if `cloudprovider=spotinst`) | `""`
`spotinst.token` | Spotinst API token (required if `cloudprovider=spotinst`) | `""`
`spotinst.image.repository` | Image (used if `cloudProvider=spotinst`) | `spotinst/kubernetes-cluster-autoscaler`
`spotinst.image.tag` | Image tag (used if `cloudProvider=spotinst`) | `v0.6.0`
`spotinst.image.pullPolicy` | Image pull policy (used if `cloudProvider=spotinst`) | `IfNotPresent`
`tolerations` | List of node taints to tolerate (requires Kubernetes >= 1.6) | `[]`


Specify each parameter you'd like to override using a YAML file as described above in the [installation](#Installing the Chart) section.


You can also specify any non-array parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/cluster-autoscaler --name my-release \
    --set awsRegion=us-west-1
```

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
