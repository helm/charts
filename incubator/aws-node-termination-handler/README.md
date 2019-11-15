

aws-node-termination-handler
============================

## Description

A Helm chart for AWS node termination handler

The **AWS Node Termination Handler** is an operational [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
built to run on any Kubernetes cluster using AWS [EC2 Spot Instances](https://aws.amazon.com/ec2/spot/).
When a user starts the termination handler, the handler watches the AWS [instance metadata service](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html)
for [spot instance interruptions](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-interruptions.html) within a customer's account.
If a termination notice is received for an instance that’s running on the cluster, the termination handler begins a multi-step cordon and drain process for the node.

You can run the termination handler on any Kubernetes cluster running on AWS,
including clusters created with Amazon [Elastic Kubernetes Service](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html).

You can override default values, see [Chart Values](#chart-values) section.

## Installation

```bash
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm install incubator/aws-node-termination-handler
```

## Version

Current chart version is `0.1.0`

## Source

Source code can be found [here](https://github.com/aws/aws-node-termination-handler)



## Chart Values


| Key | Type | Description | Default |
|-----|------|-------------|---------|
| fullnameOverride | string | full name override | `""` |
| image.pullPolicy | string | controller container image pull policy | `"IfNotPresent"` |
| image.repository | string | container image repository | `"amazon/aws-node-termination-handler"` |
| image.tag | string | container image tag | `"v1.0.0"` |
| nameOverride | string | name override | `""` |
| podAnnotations | object | pod annotations | `{}` |
| podLabels | object | pod labels | `{}` |
| priorityClassName | string | priority class name (see https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption) | `""` |
| rbac.create | bool | if true, create & use RBAC resources | `true` |
| rbac.serviceAccountAnnotations | object |  | `{}` |
| rbac.serviceAccountName | string | service account annotations | `"default"` |
| resources | object | pod resource requests & limits | `{}` |


Specify each parameter using the --set key=value[,key=value] argument to helm install.
