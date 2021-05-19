# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# SumoLogicFluentd

![sumologic-fluentd](/stable/sumologic-fluentd/sumologic-fluentd.jpg)

[Sumo Logic](https://www.sumologic.com/) is a hosted logging platform.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## Introduction

This chart adds the [Sumo Logic FluentD Plugin](https://github.com/SumoLogic/fluentd-kubernetes-sumologic) to all nodes in your cluster as a
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

- Kubernetes 1.10+ with Beta APIs enabled. However, certain configuration parameters may require a more recent version of Kubernetes. Such parameters will specify the minimum Kubernetes version required in the parameter description.

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

The following table lists the configurable parameters of the sumologic-fluentd chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podAnnotations` | Annotations to add to the DaemonSet's Pods | `{}` |
| `daemonsetAnnotations` | Annotations to add to the DaemonSet itself | `{}` |
| `tolerations` | List of node taints to tolerate (requires Kubernetes >= 1.6) | `[]` |
| `nodeSelector` | Node labels for fluentd pod assignment | `{}` |
| `affinity` | Expressions for affinity | `{}` |
| `extraEnv` | List of additional env vars to append to pods | `[]` |
| `updateStrategy` | `OnDelete` or `RollingUpdate` (requires Kubernetes >= 1.6) | `OnDelete` |
| `sumologic.collectorUrl` | An HTTP collector in SumoLogic that the container can send logs to via HTTP | `Nil` You must provide your own value |
| `sumologic.collectorUrlExistingSecret` | If set, use the secret with the name provided instead of creating a new one | `Nil` You must reference an existing secret |
| `sumologic.fluentdSource` | The fluentd input source, `file` or `systemd` | `file` |
| `sumologic.fluentdUserConfigDir` | A directory of user-defined fluentd configuration files, which must be in the `*.conf` directory in the container | `/fluentd/conf.d/user` |
| `sumologic.flushInterval` | How frequently to push logs to sumo, in seconds | `5` |
| `sumologic.numThreads` | The number of http threads sending data to sumo | `1` |
| `sumologic.sourceName` | Set the sumo `_sourceName` | `%{namespace}.%{pod}.%{container}` |
| `sumologic.sourceHost` | Set the sumo `_sourceHost` | `Nil` |
| `sumologic.sourceCategory` | Set the sumo `_sourceCategory` | `%{namespace}/%{pod_name}` |
| `sumologic.sourceCategoryPrefix` | Define a prefix, for `_sourceCategory` | `kubernetes/` |
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
| `sumologic.multilineStartRegexp` | The regular expression for the `concat` plugin to use when merging multi-line messages | `/^\w{3} \d{1,2}, \d{4}/`, i.e. Julian dates |
| `sumologic.readFromHead` | Start to read the logs from the head of file, not bottom. Only applies to containers log files. See in_tail doc for more information | `true` |
| `sumologic.concatSeparator` | The character to use to delimit lines within the final concatenated message. Most multi-line messages contain a newline at the end of each line | `Nil` |
| `sumologic.auditLogPath` | Define the path to the [Kubernetes Audit Log](https://kubernetes.io/docs/tasks/debug-application-cluster/audit/) | `/mnt/log/kube-apiserver-audit.log` |
| `sumologic.timeKey` | The field name for json formatted sources that should be used as the time. See [time_key](https://docs.fluentd.org/v0.12/articles/formatter_json#time_key-(string,-optional,-defaults-to-%E2%80%9Ctime%E2%80%9D)). | `time`
| `sumologic.addTimeStamp` | Option to control adding timestamp to logs. | `true`
| `sumologic.addTime` | Option to control adding time to logs. | `true`
| `sumologic.addStream` | Option to control adding stream to logs. | `true`
| `sumologic.containerLogsPath` | Specify the path in_tail should watch for container logs. | `/mnt/log/containers/*.log`
| `sumologic.proxyUri` | Add the uri of the proxy environment if present. | `Nil`
| `sumologic.enableStatWatcher` | Option to control the enabling of [stat_watcher](https://docs.fluentd.org/v1.0/articles/in_tail#enable_stat_watcher). | `true`
| `image.name` | The image repository and name to pull from | `sumologic/fluentd-kubernetes-sumologic` |
| `image.tag` | The image tag to pull | `v2.3.0` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `persistence.enabled` | Boolean value, used to turn on or off fluentd position file persistence, on nodes (requires Kubernetes >= 1.8) | `false` |
| `persistence.hostPath` | The path, on each node, to a directory for fluentd pos files. You must create the directory on each node first or set `persistence.createPath` (requires Kubernetes >= 1.8) | `/var/run/fluentd-pos` |
| `persistence.createPath` | Whether to create the directory on the host for you (requires Kubernetes >= 1.8) | `false` |
| `resources.requests.cpu` | CPU resource requests | 100m |
| `resources.limits.cpu` | CPU resource limits | 256m |
| `resources.requests.memory` | Memory resource requests | 128Mi |
| `resources.limits.memory` | Memory resource limits | 256Mi |
| `rbac.create` | Is Role Based Authentication enabled in the cluster | `false` |
| `rbac.serviceAccountName` | RBAC service account name | {{ fullname }} |
| `daemonset.priorityClassName` | Priority Class to use for the daemonset | `Nil` |


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

### Excluding and Including data

You have several options controlling the filtering of data that gets sent to Sumo Logic.

#### Excluding data using environment variables

There are several environment variables that can exclude data.  The following table show which  environment variables affect which Fluentd sources.

| Environment Variable | Containers | Docker | Kubernetes | Systemd |
|----------------------|------------|--------|------------|---------|
| `EXCLUDE_CONTAINER_REGEX` | ✔ | ✘ | ✘ | ✘ |
| `EXCLUDE_FACILITY_REGEX` | ✘ | ✘ | ✘ | ✔ |
| `EXCLUDE_HOST_REGEX `| ✔ | ✘ | ✘ | ✔ |
| `EXCLUDE_NAMESPACE_REGEX` | ✔ | ✘ | ✔ | ✘ |
| `EXCLUDE_PATH` | ✔ | ✔ | ✔ | ✘ |
| `EXCLUDE_PRIORITY_REGEX` | ✘ | ✘ | ✘ | ✔ |
| `EXCLUDE_POD_REGEX` | ✔ | ✘ | ✘ | ✘ |
| `EXCLUDE_UNIT_REGEX` | ✘ | ✘ | ✘ | ✔ |

#### Excluding data using annotations

You can also use the sumologic.com/exclude annotation to exclude data from Sumo. This data is sent to FluentD, but not to Sumo Logic.

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx
spec:
  replicas: 1
  selector:
    app: mywebsite
  template:
    metadata:
      name: nginx
      labels:
        app: mywebsite
      annotations:
        sumologic.com/format: "text"
        sumologic.com/sourceCategory: "mywebsite/nginx"
        sumologic.com/sourceName: "mywebsite_nginx"
        sumologic.com/exclude: "true"
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

#### Include excluded using annotations

If you excluded a whole namespace, but still need one or few pods to be still included for shipping to Sumo Logic, you can use the sumologic.com/include annotation to include data to Sumo. It takes precedence over the exclusion described above.

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx
spec:
  replicas: 1
  selector:
    app: mywebsite
  template:
    metadata:
      name: nginx
      labels:
        app: mywebsite
      annotations:
        sumologic.com/format: "text"
        sumologic.com/sourceCategory: "mywebsite/nginx"
        sumologic.com/sourceName: "mywebsite_nginx"
        sumologic.com/include: "true"
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

### FluentD stops processing logs
When dealing with large volumes of data (TB's from what we have seen), FluentD may stop processing logs, but continue to run.  This issue seems to be caused by the [scalability of the inotify process](https://github.com/fluent/fluentd/issues/1630) that is packaged with the FluentD in_tail plugin.  If you encounter this situation, setting the `ENABLE_STAT_WATCHER` to `false` should resolve this issue.
