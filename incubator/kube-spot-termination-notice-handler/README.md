# Kubernetes AWS EC2 Spot Termination Notice Handler

This chart installs the [kube-spot-termination-notice-handler](https://github.com/kube-aws/kube-spot-termination-notice-handler) as a daemonset across the cluster nodes.

## Purpose

The handler watches for Spot termination events, and will do the following if detected:

* Drain the affected node

* [Optional] Send a message to a Slack channel informing that a termination notice has been received.

## Installation

You should install into the `kube-system` namespace, but this is not a requirement. The following example assumes this has been chosen.

```
helm install incubator/kube-spot-termination-notice-handler --name-space kube-system
```

## Configuration

You may set these options in your values file:

* `enableLogspout` - if you use Logspout to capture logs, this option will ensure your logs are captured. The logs are noisy, and as such are disabled from Logspout by default.

* `slackUrl` - optional - put a slack webhook URL here to get messaged when a termination notice is received.

* `clusterName` - optional - when slack is configured use this cluster name for reports

* `pollInterval` - how often to query the EC2 metadata for termination notices. Defaults to every `5` seconds.

* `rbac.create` -  Specifies whether RBAC resources should be created. Defaults to `true`.

* `serviceAccount.create` -  Specifies whether a ServiceAccount should be created. Defaults to `true`.

* `serviceAccount.name` - The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template.
