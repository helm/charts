# SumoLogicFluentd

![sumologic-fluentd](/incubator/sumologic-fluentd/sumologic-fluentd.jpg)

[Sumo Logic](https://www.sumologic.com/) is a hosted logging platform.

## Introduction

This chart adds the Sumo Logic Collector to all nodes in your cluster via a
DaemonSet. After you have installed the chart, each pod, deployment, etc. can be
optionally
[configured](https://github.com/SumoLogic/fluentd-kubernetes-sumologic#options)
to specify its log format, source category, or source name.

    annotations:
      sumologic.com/format: "text"
      sumologic.com/sourceCategory: "mywebsite/nginx"
      sumologic.com/sourceName: "mywebsite_nginx"
      sumologic.com/exclude: true

## Prerequisites

- Kubernetes 1.2+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`, create your Sumo Logic [HTTP Collector](http://help.sumologic.com/Send_Data/Sources/02Sources_for_Hosted_Collectors/HTTP_Source) and run:

```bash
$ helm install --name my-release \
    --set sumologic.collectorUrl=YOUR-URL-HERE incubator/sumologic-fluentd
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
| `sumologic.collectorUrl` | An HTTP collector in SumoLogic that the container can send logs to via HTTP | `Nil` You must provide your own |
| `sumologic.flushInterval` | How frequently to push logs to sumo, in seconds | `5` |
| `sumologic.numThreads` | The number of http threads sending data to sumo | `1` |
| `sumologic.sourceName` | Set the sumo `_sourceName` | `%{namespace}.%{pod}.%{container}` |
| `sumologic.sourceCategory` | Set the sumo `_sourceCategory` | `%{namespace}/%{pod_name}` |
| `sumologic.sourceCategoryPrefix` | Define a prefix, for `_sourceCategory` | `Nil` |
| `sumologic.sourceCategoryReplaceDash` | Used to replace `-` with another character | `/` |
| `sumologic.logFormat` | Format to post logs, into sumo (`json`, `json_merge`, or `text`) | `json` |
| `sumologic.kubernetesMeta` | Include or exclude kubernetes metadata, with `json` format | `true` |
| `sumologic.excludePath` | Files in this pattern will not be sent to sumo, ie `"[\"/var/log/containers/*.log\", \"/var/log/*.log\"]` | `Nil` |
| `sumologic.excludeNamespaceRegex` | All matching namespaces will not be sent to sumo | `Nil` |
| `sumologic.excludePodRegex` | All matching pods will not be sent to sumo | `Nil` |
| `sumologic.excludeContainerRegex` | All matching containers will not be sent to sumo | `Nil` |
| `sumologic.excludeHostRegex` | All matching hosts will not be sent to sumo | `Nil` |
| `sumologic.fluentdOpt` | Additional command line options, sent to fluentd | `Nil` |
| `sumologic.verifySsl` | Verify SumoLogic HTTPS certificates | `true` |
| `image.name` | The image repository and name to pull from | `sumologic/fluentd-kubernetes-sumologic` |
| `image.tag` | The image tag to pull | `latest` |
| `imagePullPolicy` | Image pull policy | `IfNotPresent` |
| `persistence.hostPath` | The path, on each node, to a directory for fluentd pos files. You must create the directory on each node first. | `Nil` |
| `resources.requests.cpu` | CPU resource requests | 100m |
| `resources.limits.cpu` | CPU resource limits | 256m |
| `resources.requests.memory` | Memory resource requests | 128Mi |
| `resources.limits.memory` | Memory resource limits | 256Mi |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set sumologic.collectorUrl=YOUR-URL-HERE \
    incubator/sumologic-fluentd
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/sumologic-fluentd
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Persistence

By default, the fluentd position files will be written to an ephemeral
`emptyDir`. Each time the pods die, new position files will be created, all of
the logs in the cluster will be sent to sumologic again. To avoid unneccessary
re-transmissions, pos directories can be maintained as a `hostPath`. Create a
directory, on each of the nodes, and point `persistence.hostPath` at that
directory.

```bash
$ helm install --name my-release \
    --set sumologic.collectorUrl=URL,persistence.hostPath=/var/run/fluentd \
    incubator/sumologic-fluentd
```
