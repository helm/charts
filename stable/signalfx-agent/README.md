# SignalFx Agent

**This chart has been deprecated. Please use the upstream chart found [here](https://github.com/signalfx/signalfx-agent/tree/master/deployments/k8s/helm/signalfx-agent) instead.**

[SignalFx](https://signalfx.com) is a cloud monitoring and alerting solution
for modern enterprise infrastructures.

## Introduction

This chart will deploy the SignalFx agent as a DaemonSet to all nodes in your
cluster.  It is designed to be run in only one release at a time.

See [the agent
docs](https://docs.signalfx.com/en/latest/integrations/kubernetes-quickstart.html)
for more information on how the agent works.  The installation steps will be
different since you are using Helm but the agent otherwise behaves identically.

## Configuration

See the [values.yaml](./values.yaml) file for more information on how to
configure releases.

There are two **required** config options to run this chart: `signalFxAccessToken`
and `clusterName` (if not overridding the agent config template and providing your own
cluster name).

If you want to provide your own agent configuration, you can do so with the
`agentConfig` value.  Otherwise, you can do a great deal of customization to
the provided config template using values.
