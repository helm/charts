# Datadog

[Datadog](https://www.datadoghq.com/) is a hosted infrastructure monitoring platform.

## Introduction

This chart adds the DataDog Agent to all nodes in your cluster via a DaemonSet. It also depends on the [kube-state-metrics chart](https://github.com/kubernetes/charts/tree/master/stable/kube-state-metrics).

## Prerequisites

- Kubernetes 1.2+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`, retrieve your DataDog API key from your [Agent Installation Instructions](https://app.datadoghq.com/account/settings#agent/kubernetes) and run:

```bash
$ helm install --name my-release \
    --set datadog.apiKey=YOUR-KEY-HERE stable/datadog
```

After a few minutes, you should see hosts and metrics being reported in DataDog.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Datadog chart and their default values.

|             Parameter       |            Description             |                    Default                |
|-----------------------------|------------------------------------|-------------------------------------------|
| `datadog.apiKey`            | Your Datadog API key               |  `Nil` You must provide your own key      |
| `image.repository`          | The image repository to pull from  | `datadog/docker-dd-agent`                 |
| `image.tag`                 | The image tag to pull              | `latest`                                  |
| `image.pullPolicy`          | Image pull policy                  | `IfNotPresent`                            |
| `rbac.create`               | If true, create & use RBAC resources | `true`                                  |
| `rbac.serviceAccount`       | existing ServiceAccount to use (ignored if rbac.create=true) | `default`       |
| `datadog.env`               | Additional Datadog environment variables | `nil`                               |
| `datadog.apmEnabled`        | Enable tracing from the host       | `nil`                                     |
| `datadog.autoconf`          | Additional Datadog service discovery configurations | `nil`                    |
| `datadog.checksd`           | Additional Datadog service checks  | `nil`                                     |
| `datadog.confd`             | Additional Datadog service configurations | `nil`                              |
| `datadog.volumes`           | Additional volumes for the daemonset or deployment | `nil`                     |
| `datadog.volumeMounts`      | Additional volumeMounts for the daemonset or deployment | `nil`                |
| `resources.requests.cpu`    | CPU resource requests              | `100m`                                    |
| `resources.limits.cpu`      | CPU resource limits                | `256m`                                    |
| `resources.requests.memory` | Memory resource requests           | `128Mi`                                   |
| `resources.limits.memory`   | Memory resource limits             | `512Mi`                                   |
| `kubeStateMetrics.enabled`  | If true, create kube-state-metrics | `true`                                    |
| `daemonset.podAnnotations`  | Annotations to add to the DaemonSet's Pods | `nil`                             |
| `daemonset.tolerations`     | List of node taints to tolerate (requires Kubernetes >= 1.6) | `nil`           |
| `daemonset.useHostNetwork`  | If true, use the host's network    | `nil`                                     |
| `daemonset.useHostPort`     | If true, use the same ports for both host and container  | `nil`               |
| `datadog.leaderElection`    | Adds the leader Election feature   | `false`                                   |
| `datadog.leaderLeaseDuration`| The duration for which a leader stays elected.| `nil`                         |
| `kube-state-metrics.rbac.create`| If true, create & use RBAC resources for kube-state-metrics | `true`       |
| `kube-state-metrics.rbac.serviceAccount` | existing ServiceAccount to use (ignored if rbac.create=true) for kube-state-metrics | `default` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set datadog.apiKey=YOUR-KEY-HERE,datadog.logLevel=DEBUG \
    stable/datadog
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/datadog
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Image tags

Datadog offers a multitude of [tags](https://hub.docker.com/r/datadog/docker-dd-agent/tags/), including alpine based agents and JMX.

### DaemonSet and Deployment
By default installs Datadog agent inside a DaemonSet. You may also use Datadog agent inside a Deployment, if you want to collect Kubernetes API events or send custom metrics to DogStatsD endpoint.

### confd and checksd

The Datadog entrypoint will copy files found in `/conf.d` and `/check.d` to
`/etc/dd-agent/conf.d` and `/etc/dd-agent/check.d` respectively. The keys for
`datadog.confd`, `datadog.autoconf`, and `datadog.checksd` should mirror the content found in their
respective ConfigMaps, ie

```yaml
datadog:
  autoconf:
    redisdb.yaml: |-
      docker_images:
        - redis
        - bitnami/redis
      init_config:
      instances:
        - host: "%%host%%"
          port: "%%port%%"
    jmx.yaml: |-
      docker_images:
        - openjdk
      instance_config:
      instances:
        - host: "%%host%%"
          port: "%%port_0%%"
  confd:
    redisdb.yaml: |-
      init_config:
      instances:
        - host: "outside-k8s.example.com"
          port: 6379
```

### Leader election

The Datadog Agent supports built in leader election option for the Kubernetes event collector As of 5.17.

This feature relies on ConfigMaps, enabling this flag will grant Datadog Agent get, list, delete and create access to the ConfigMap resource.
See the full [RBAC](https://github.com/DataDog/integrations-core/tree/master/kubernetes#gathering-kubernetes-events) and keep in mind that these RBAC entities **will need** to be created before the option is set.

Agents coordinate by performing a leader election among members of the Datadog DaemonSet through kubernetes to ensure only one leader agent instance is gathering events at a given time.

**This functionality is disabled by default.**

The `datadog.leaderLeaseDuration` is the duration for which a leader stays elected. It should be > 30 seconds. The longer it is, the less frequently your agents hit the apiserver with requests, but it also means that if the leader dies (and under certain conditions), events can be missed until the lease expires and a new leader takes over.


Make sure the `rbac.create` is enable as well to ensure the feature to work properly.

### Agent6 beta

The new major version of the agent is currently in beta, and this chart allows you to use it by setting a different `image.repository`.
See `values.yaml` for supported values. Please note that not all features are available yet.

Please refer to [the agent6 image documentation](https://github.com/DataDog/datadog-agent/tree/master/Dockerfiles/agent) and
[the agent6 general documentation](https://github.com/DataDog/datadog-agent/tree/master/docs) for more information.
