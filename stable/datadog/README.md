# Datadog

[Datadog](https://www.datadoghq.com/) is a hosted infrastructure monitoring platform.

## Introduction

This chart adds the Datadog Agent to all nodes in your cluster via a DaemonSet. It also optionally depends on the [kube-state-metrics chart](https://github.com/kubernetes/charts/tree/master/stable/kube-state-metrics). For more information about monitoring Kubernetes with Datadog, please refer to the [Datadog documentation website](https://docs.datadoghq.com/agent/basic_agent_usage/kubernetes/).

## Prerequisites

Kubernetes 1.4+ or OpenShift 3.4+ (1.3 support is currently partial, full support is planned for 6.4.0).

## Installing the Chart

To install the chart with the release name `my-release`, retrieve your Datadog API key from your [Agent Installation Instructions](https://app.datadoghq.com/account/settings#agent/kubernetes) and run:

```bash
helm install --name my-release \
  --set datadog.apiKey=YOUR-KEY-HERE stable/datadog
```

After a few minutes, you should see hosts and metrics being reported in Datadog.

**Tip**: List all releases using `helm list`

### Enabling the Datadog Cluster Agent

Read about the Datadog Cluster Agent in the [official documentation](https://docs.datadoghq.com/agent/kubernetes/cluster/).

Run the following if you want to deploy the chart with the Datadog Cluster Agent.
Note that specifying `clusterAgent.metricsProvider.enabled=true` will enable the External Metrics Server.
If you want to learn to use this feature, you can check out this [walkthrough](https://github.com/DataDog/datadog-agent/blob/master/docs/cluster-agent/CUSTOM_METRICS_SERVER.md).
The Leader Election is enabled by default in the chart for the Cluster Agent. Only the Cluster Agent(s) participate in the election, in case you have several replicas configured (using `clusterAgent.replicas`.
You can specify the token used to secure the communication between the Cluster Agent(s)q and the Agents with `clusterAgent.token`. If not specified, a random one will be generated and you will be prompted a warning when installing the chart.

```bash
helm install --name datadog-monitoring \
    --set datadog.apiKey=YOUR-API-KEY-HERE \
    --set datadog.appKey=YOUR-APP-KEY-HERE \
    --set clusterAgent.enabled=true \
    --set clusterAgent.metricsProvider.enabled=true \
    stable/datadog
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Datadog chart and their default values.

|             Parameter       |            Description             |                    Default                |
|-----------------------------|------------------------------------|-------------------------------------------|
| `datadog.apiKey`            | Your Datadog API key               |  `Nil` You must provide your own key      |
| `datadog.apiKeyExistingSecret` | If set, use the secret with a provided name instead of creating a new one |`nil` |
| `datadog.appKey`            | Datadog APP key required to use metricsProvider |  `Nil` You must provide your own key      |
| `datadog.appKeyExistingSecret` | If set, use the secret with a provided name instead of creating a new one |`nil` |
| `image.repository`          | The image repository to pull from  | `datadog/agent`                           |
| `image.tag`                 | The image tag to pull              | `6.6.0`                                   |
| `image.pullPolicy`          | Image pull policy                  | `IfNotPresent`                            |
| `image.pullSecrets`         | Image pull secrets                 |  `nil`                                    |
| `rbac.create`               | If true, create & use RBAC resources | `true`                                  |
| `rbac.serviceAccount`       | existing ServiceAccount to use (ignored if rbac.create=true) | `default`       |
| `datadog.name`              | Container name if Daemonset or Deployment | `datadog`                          |
| `datadog.site`              | Site ('datadoghq.com' or 'datadoghq.eu') | `nil`                                |
| `datadog.dd_url`            | Datadog intake server              | `nil`                                     |
| `datadog.env`               | Additional Datadog environment variables | `nil`                               |
| `datadog.logsEnabled`       | Enable log collection              | `nil`                                     |
| `datadog.logsConfigContainerCollectAll` | Collect logs from all containers | `nil`                           |
| `datadog.logsPointerHostPath` | Host path to store the log tailing state in | `/var/lib/datadog-agent/logs`   |
| `datadog.apmEnabled`        | Enable tracing from the host       | `nil`                                     |
| `datadog.processAgentEnabled` | Enable live process monitoring   | `nil`                                     |
| `datadog.checksd`           | Additional custom checks as python code  | `nil`                               |
| `datadog.confd`             | Additional check configurations (static and Autodiscovery) | `nil`             |
| `datadog.criSocketPath`     | Path to the container runtime socket (if different from Docker) | `nil`        |
| `datadog.tags`              | Set host tags                      | `nil`                                     |
| `datadog.nonLocalTraffic` | Enable statsd reporting from any external ip | `False`                           |
| `datadog.useCriSocketVolume` | Enable mounting the container runtime socket in Agent containers | `True` |
| `datadog.volumes`           | Additional volumes for the daemonset or deployment | `nil`                     |
| `datadog.volumeMounts`      | Additional volumeMounts for the daemonset or deployment | `nil`                |
| `datadog.podAnnotationsAsTags` | Kubernetes Annotations to Datadog Tags mapping | `nil`                      |
| `datadog.podLabelsAsTags`   | Kubernetes Labels to Datadog Tags mapping      | `nil`                         |
| `datadog.resources.requests.cpu` | CPU resource requests         | `200m`                                    |
| `datadog.resources.limits.cpu` | CPU resource limits             | `200m`                                    |
| `datadog.resources.requests.memory` | Memory resource requests   | `256Mi`                                   |
| `datadog.resources.limits.memory` | Memory resource limits       | `256Mi`                                   |
| `datadog.securityContext`   | Allows you to overwrite the default securityContext applied to the container  | `nil`  |
| `datadog.livenessProbe`     | Overrides the default liveness probe | exec /probe.sh                          |
| `datadog.hostname`          | Set the hostname (write it in datadog.conf) | `nil`                            |
| `datadog.acInclude`         | Include containers based on image name | `nil`                                 |
| `datadog.acExclude`         | Exclude containers based on image name | `nil`                                 |
| `daemonset.podAnnotations`  | Annotations to add to the DaemonSet's Pods | `nil`                             |
| `daemonset.tolerations`     | List of node taints to tolerate (requires Kubernetes >= 1.6) | `nil`           |
| `daemonset.nodeSelector`    | Node selectors                     | `nil`                                     |
| `daemonset.affinity`        | Node affinities                    | `nil`                                     |
| `daemonset.useHostNetwork`  | If true, use the host's network    | `nil`                                     |
| `daemonset.useHostPID`.     | If true, use the host's PID namespace    | `nil`                               |
| `daemonset.useHostPort`     | If true, use the same ports for both host and container  | `nil`               |
| `daemonset.priorityClassName` | Which Priority Class to associate with the daemonset| `nil`                  |
| `datadog.leaderElection`    | Enable the leader Election feature | `false`                                   |
| `datadog.leaderLeaseDuration`| The duration for which a leader stays elected.| `nil`                         |
| `datadog.collectEvents`     | Enable Kubernetes event collection. Requires leader election. | `false`        |
| `deployment.affinity`       | Node / Pod affinities              | `{}`                                      |
| `deployment.tolerations`    | List of node taints to tolerate    | `[]`                                      |
| `deployment.priorityClassName` | Which Priority Class to associate with the deployment | `nil`               |
| `kubeStateMetrics.enabled`  | If true, create kube-state-metrics | `true`                                    |
| `kube-state-metrics.rbac.create`| If true, create & use RBAC resources for kube-state-metrics | `true`       |
| `kube-state-metrics.rbac.serviceAccount` | existing ServiceAccount to use (ignored if rbac.create=true) for kube-state-metrics | `default` |
| `clusterAgent.enabled`                   | Use the cluster-agent for cluster metrics (Kubernetes 1.10+ only) | `false`                           |
| `clusterAgent.token`                     | A cluster-internal secret for agent-to-agent communication. Must be 32+ characters a-zA-Z | Generates a random value |
| `clusterAgent.containerName`             | The container name for the Cluster Agent  | `cluster-agent`                           |
| `clusterAgent.image.repository`          | The image repository for the cluster-agent | `datadog/cluster-agent`                           |
| `clusterAgent.image.tag`                 | The image tag to pull              | `1.0.0`                                   |
| `clusterAgent.image.pullPolicy`          | Image pull policy                  | `IfNotPresent`                            |
| `clusterAgent.image.pullSecrets`         | Image pull secrets                 |  `nil`                                    |
| `clusterAgent.metricsProvider.enabled`   | Enable Datadog metrics as a source for HPA scaling |  `false`                  |
| `clusterAgent.resources.requests.cpu`    | CPU resource requests              | `200m`                                    |
| `clusterAgent.resources.limits.cpu`      | CPU resource limits                | `200m`                                    |
| `clusterAgent.resources.requests.memory` | Memory resource requests           | `256Mi`                                   |
| `clusterAgent.resources.limits.memory`   | Memory resource limits             | `256Mi`                                   |
| `clusterAgent.tolerations`               | List of node taints to tolerate    | `[]`                                      |
| `clusterAgent.livenessProbe`             | Overrides the default liveness probe | http port 443 if external metrics enabled       |
| `clusterAgent.readinessProbe`            | Overrides the default readiness probe | http port 443 if external metrics enabled      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install --name my-release \
  --set datadog.apiKey=YOUR-KEY-HERE,datadog.logLevel=DEBUG \
  stable/datadog
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install --name my-release -f my-values.yaml stable/datadog
```

**Tip**: You can copy and customize the default [values.yaml](values.yaml)

### Image repository and tag

Datadog [offers two variants](https://hub.docker.com/r/datadog/agent/tags/), switch to a `-jmx` tag if you need to run JMX/java integrations. The chart also supports running [the standalone dogstatsd image](https://hub.docker.com/r/datadog/dogstatsd/tags/).

Starting with version 1.0.0, this chart does not support deploying Agent 5.x anymore. If you cannot upgrade to Agent 6.x, you can use a previous version of the chart by calling helm install with `--version 0.18.0`.

### DaemonSet and Deployment

By default, the Datadog Agent runs in a DaemonSet. It can alternatively run inside a Deployment for special use cases.

**Note:** simultaneous DaemonSet + Deployment installation within a single release will be deprecated in a future version, requiring two releases to achieve this.

### Secret

By default, this Chart creates a Secret and puts an API key in that Secret.
However, you can use manually created secret by setting the `datadog.apiKeyExistingSecret` value.

### confd and checksd

The Datadog [entrypoint
](https://github.com/DataDog/datadog-agent/blob/master/Dockerfiles/agent/entrypoint/89-copy-customfiles.sh)
will copy files with a `.yaml` extension found in `/conf.d` and files with `.py` extension in
`/check.d` to `/etc/datadog-agent/conf.d` and `/etc/datadog-agent/checks.d` respectively. The keys for
`datadog.confd` and `datadog.checksd` should mirror the content found in their
respective ConfigMaps, ie

```yaml
datadog:
  confd:
    redisdb.yaml: |-
      ad_identifiers:
        - redis
        - bitnami/redis
      init_config:
      instances:
        - host: "%%host%%"
          port: "%%port%%"
    jmx.yaml: |-
      ad_identifiers:
        - openjdk
      instance_config:
      instances:
        - host: "%%host%%"
          port: "%%port_0%%"
    redisdb.yaml: |-
      init_config:
      instances:
        - host: "outside-k8s.example.com"
          port: 6379
```

For more details, please refer to [the documentation](https://docs.datadoghq.com/agent/kubernetes/integrations/).

### Kubernetes event collection

To enable event collection, you will need to set the `datadog.leaderElection`, `datadog.collectEvents` and `rbac.create` options to `true`.

It is now recommended to use the Datadog Cluster Agent to collect the events - Refer to the [Enabling the Datadog Cluster Agent](#enabling-the-datadog-cluster-agent) section.
Please read [the official documentation](https://docs.datadoghq.com/agent/kubernetes/event_collection/) for more context.

### Kubernetes Labels and Annotations

To map Kubernetes pod labels and annotations to Datadog tags, provide a dictionary with kubernetes labels/annotations as keys and datadog tags as values:

```yaml
podAnnotationsAsTags:
  iam.amazonaws.com/role: kube_iamrole
```

```yaml
podLabelsAsTags:
  app: kube_app
  release: helm_release
```

### CRI integration

As of the version 6.6.0, the Datadog Agent supports collecting metrics from any container runtime interface used in your cluster.
Configure the location path of the socket with `datadog.criSocketPath` and make sure you allow the socket to be mounted into the pod running the agent by setting `datadog.useCriSocketVolume` to `True`.
Standard paths are:

- Containerd socket: `/var/run/containerd/containerd.sock`
- Cri-o socket: `/var/run/crio/crio.sock`
