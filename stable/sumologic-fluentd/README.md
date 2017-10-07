# SumoLogicFluentd

![sumologic-fluentd](/stable/sumologic-fluentd/sumologic-fluentd.jpg)

[Sumo Logic](https://www.sumologic.com/) is a hosted logging platform.

## Introduction

This chart adds the Sumo Logic Collector to all nodes in your cluster as a
DaemonSet. The image supports fluentd `file` and `systemd` log sources.

After you have installed the chart, each pod, deployment, etc. can be optionally
[configured](https://github.com/SumoLogic/fluentd-kubernetes-sumologic#options)
to specify its log format, source category, source name, or exclude itself from
SumoLogic.

### Configure an individual pod

    annotations:
      sumologic.com/format: "text"
      sumologic.com/sourceCategory: "mywebsite/nginx"
      sumologic.com/sourceName: "mywebsite_nginx"

### Prevent an individual pod from logging

    annotations:
      sumologic.com/exclude: "true"

## Prerequisites

- Kubernetes 1.2+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`, create your Sumo Logic [HTTP Collector](http://help.sumologic.com/Send_Data/Sources/02Sources_for_Hosted_Collectors/HTTP_Source) and run:

```bash
$ helm install --name my-release \
    --set sumologic.collectorUrl=YOUR-URL-HERE stable/sumologic-fluentd
```

After a few minutes, you should see logs available in Sumo Logic.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the sumologic-fluentd chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podAnnotations` | Annotations to add to the DaemonSet's Pods | `{}` |
| `tolerations` | List of node taints to tolerate (requires Kubernetes >= 1.6) | `[]` |
| `updateStrategy` | `OnDelete` or `RollingUpdate` (requires Kubernetes >= 1.6) | `OnDelete` |
| `sumologic.collectorUrl` | An HTTP collector in SumoLogic that the container can send logs to via HTTP | `Nil` You must provide your own |
| `sumologic.fluentdSource` | The fluentd input source, `file` or `systemd` | `file` |
| `sumologic.flushInterval` | How frequently to push logs to sumo, in seconds | `5` |
| `sumologic.numThreads` | The number of http threads sending data to sumo | `1` |
| `sumologic.sourceName` | Set the sumo `_sourceName` | `%{namespace}.%{pod}.%{container}` |
| `sumologic.sourceCategory` | Set the sumo `_sourceCategory` | `%{namespace}/%{pod_name}` |
| `sumologic.sourceCategoryPrefix` | Define a prefix, for `_sourceCategory` | `Nil` |
| `sumologic.sourceCategoryReplaceDash` | Used to replace `-` with another character | `/` |
| `sumologic.logFormat` | Format to post logs, into sumo (`json`, `json_merge`, or `text`) | `json` |
| `sumologic.kubernetesMeta` | Include or exclude kubernetes metadata, with `json` format | `true` |
| `sumologic.excludeContainerRegex` | All matching containers will not be sent to sumo | `Nil` |
| `sumologic.excludeFacilityRegex` | All matching facilities will not be sent to sumo | `Nil` |
| `sumologic.excludeHostRegex` | All matching hosts will not be sent to sumo | `Nil` |
| `sumologic.excludeNamespaceRegex` | All matching namespaces will not be sent to sumo | `Nil` |
| `sumologic.excludePath` | Files in this pattern will not be sent to sumo, ie `"[\"/var/log/containers/*.log\", \"/var/log/*.log\"]` | `Nil` |
| `sumologic.excludePodRegex` | All matching pods will not be sent to sumo | `Nil` |
| `sumologic.excludePriorityRegex` | All matching priorities will not be sent to sumo | `Nil` |
| `sumologic.excludeUnitRegex` | All matching systemd units will not be sent to sumo | `Nil` |
| `sumologic.fluentdOpt` | Additional command line options, sent to fluentd | `Nil` |
| `sumologic.verifySsl` | Verify SumoLogic HTTPS certificates | `true` |
| `image.name` | The image repository and name to pull from | `sumologic/fluentd-kubernetes-sumologic` |
| `image.tag` | The image tag to pull | `latest` |
| `imagePullPolicy` | Image pull policy | `IfNotPresent` |
| `persistence.enabled` | Boolean value, used to turn on or off fluentd position file persistence, on nodes | `false` |
| `persistence.hostPath` | The path, on each node, to a directory for fluentd pos files. You must create the directory on each node first. | `/var/run/fluentd-pos` |
| `resources.requests.cpu` | CPU resource requests | 100m |
| `resources.limits.cpu` | CPU resource limits | 256m |
| `resources.requests.memory` | Memory resource requests | 128Mi |
| `resources.limits.memory` | Memory resource limits | 256Mi |
| `rbac.create` | Is Role Based Authentication enabled in the cluster | `false` |
| `rbac.serviceAccountName` | RBAC service account name | {{ fullname }} |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set sumologic.collectorUrl=YOUR-URL-HERE \
    stable/sumologic-fluentd
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/sumologic-fluentd
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Persistence

By default, the fluentd position files will be written to an ephemeral
`emptyDir`. Each time the pods die, new position files will be created, all of
the logs in the cluster will be sent to sumologic again. To avoid unnecessary
re-transmissions, pos directories can be maintained as a `hostPath`. Create a
directory, on each of the nodes, and point `persistence.hostPath` at that
directory.

```bash
$ helm install --name my-release \
    --set sumologic.collectorUrl=URL,persistence.hostPath=/var/run/fluentd \
    stable/sumologic-fluentd
```

### RBAC

By default the chart will not install the associated RBAC rolebinding,
using beta annotations.

To determine if your cluster supports this running the following:

```console
$ kubectl api-versions | grep rbac
```

You also need to have the following parameter on the api server. See the
following document for how to enable
[RBAC](https://kubernetes.io/docs/admin/authorization/rbac/)

```
--authorization-mode=RBAC
```

If the output contains "beta" or both "alpha" and "beta" you can enable rbac.

### Enable RBAC role/rolebinding creation

To enable the creation of RBAC resources, do the following

```console
$ helm install --name my-release stable/sumologic-fluentd --set rbac.create=true
```
