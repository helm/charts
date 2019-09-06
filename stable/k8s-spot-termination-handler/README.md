# Kubernetes AWS EC2 Spot Termination Notice Handler

This chart installs the [k8s-spot-termination-handler](https://github.com/kube-aws/kube-spot-termination-notice-handler)
as a daemonset across the cluster nodes.

## Purpose

Spot instances on EC2 come with significant cost savings, but with the burden of instance being terminated if
the market price goes higher than the maximum price you have configured.

The termination handler watches the AWS Metadata API for termination requests and starts draining the node
so that it can be terminated safely. Optionally it can also send a message to a Slack channel informing that
a termination notice has been received.

## Installation

You should install into the `kube-system` namespace, but this is not a requirement. The following example assumes this has been chosen.

```
helm install stable/k8s-spot-termination-handler --namespace kube-system
```

## Configuration

The following table lists the configurable parameters of the k8s-spot-termination-handler chart and their default values.

Parameter | Description | Default
--- | --- | ---
`image.repository` | container image repository | `kubeaws/kube-spot-termination-notice-handler`
`image.tag` | container image tag | `1.13.7-1`
`image.pullPolicy` | container image pull policy | `IfNotPresent`
`noticeUrl` | the URL of EC2 spot instance termination notice endpoint | `http://169.254.169.254/latest/meta-data/spot/termination-time`
`pollInterval` | the interval in seconds between attempts to poll EC2 metadata API for termination events | `"5"`
`verbose` | Enable verbose | _not defined_
`slackUrl` | Slack webhook URL to send messages when a termination notice is received | _not defined_
`clusterName` | if `slackUrl` is set - use this cluster name in Slack messages | _not defined_
`enableLogspout` | if `true`, enable the Logspout log capturing. Logspout should be deployed separately | `false`
`rbac.create` | if `true`, create & use RBAC resources | `true`
`serviceAccount.create` | if `true`, create a service account | `true`
`serviceAccount.name` | the name of the service account to use. If not set and `create` is `true`, a name is generated using the fullname template. | ``
`detachAsg` | if `true`, the spot termination handler will detect (standard) AutoScaling Group, and initiate detach when termination notice is detected. | `false`
`gracePeriod` | Grace period for node draining | `120`
`envFromSecret` | Name of a Kubenretes secret (must be manually created in the same namespace) containing values to be added to the environment | `""` |
`resources` | pod resource requests & limits | `{}`
`nodeSelector` | node labels for pod assignment | `{}`
`tolerations` | node taints to tolerate (requires Kubernetes >=1.6) | `[]`
`affinity` | node/pod affinities (requires Kubernetes >=1.6) | `{}`
`priorityClassName` | pod priorityClassName for pod. | ``
`hostNetwork` | controls whether the pod may use the node network namespace | `true`
`podAnnotations` | annotations to be added to pods | `{}`
`updateStrategy` | can be either `RollingUpdate` or `OnDelete` | `RollingUpdate`
