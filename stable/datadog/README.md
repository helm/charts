# Datadog

[Datadog](https://www.datadoghq.com/) is a hosted infrastructure monitoring platform. This chart adds the Datadog Agent to all nodes in your cluster via a DaemonSet. It also optionally depends on the [kube-state-metrics chart](https://github.com/kubernetes/charts/tree/master/stable/kube-state-metrics). For more information about monitoring Kubernetes with Datadog, please refer to the [Datadog documentation website](https://docs.datadoghq.com/agent/basic_agent_usage/kubernetes/).

Datadog [offers two variants](https://hub.docker.com/r/datadog/agent/tags/), switch to a `-jmx` tag if you need to run JMX/java integrations. The chart also supports running [the standalone dogstatsd image](https://hub.docker.com/r/datadog/dogstatsd/tags/).

See the [Datadog JMX integration](https://docs.datadoghq.com/integrations/java/) to learn more.

## Prerequisites

Kubernetes 1.4+ or OpenShift 3.4+, note that:

* the Datadog Agent supports Kubernetes 1.3+
* The Datadog chart's defaults are tailored to Kubernetes 1.7.6+, see [Datadog Agent legacy Kubernetes versions documentation](https://github.com/DataDog/datadog-agent/tree/master/Dockerfiles/agent#legacy-kubernetes-versions) for adjustments you might need to make for older versions

## Quick start

By default, the Datadog Agent runs in a DaemonSet. It can alternatively run inside a Deployment for special use cases.

**Note:** simultaneous DaemonSet + Deployment installation within a single release will be deprecated in a future version, requiring two releases to achieve this.

### Installing the Datadog Chart

To install the chart with the release name `<RELEASE_NAME>`, retrieve your Datadog API key from your [Agent Installation Instructions](https://app.datadoghq.com/account/settings#agent/kubernetes) and run:

```bash
helm install --name <RELEASE_NAME> \
  --set datadog.apiKey=<DATADOG_API_KEY> stable/datadog
```

By default, this Chart creates a Secret and puts an API key in that Secret.
However, you can use manually created secret by setting the `datadog.apiKeyExistingSecret` value. After a few minutes, you should see hosts and metrics being reported in Datadog.

### Enabling the Datadog Cluster Agent

Read about the Datadog Cluster Agent in the [official documentation](https://docs.datadoghq.com/agent/kubernetes/cluster/).

Run the following if you want to deploy the chart with the Datadog Cluster Agent:

```bash
helm install --name datadog-monitoring \
    --set datadog.apiKey=<DATADOG_API_KEY> \
    --set datadog.appKey=<DATADOG_APP_KEY \
    --set clusterAgent.enabled=true \
    --set clusterAgent.metricsProvider.enabled=true \
    stable/datadog
```

**Note**: Specifying `clusterAgent.metricsProvider.enabled=true` enables the External Metrics Server.
If you want to learn to use this feature, you can check out this [Datadog Cluster Agent walkthrough](https://github.com/DataDog/datadog-agent/blob/master/docs/cluster-agent/CUSTOM_METRICS_SERVER.md).

The Leader Election is enabled by default in the chart for the Cluster Agent. Only the Cluster Agent(s) participate in the election, in case you have several replicas configured (using `clusterAgent.replicas`.

#### Cluster Agent Token

You can specify the Datadog Cluster Agent token used to secure the communication between the Cluster Agent(s) and the Agents with `clusterAgent.token`.

**If you don't specify a token, a random one is generated at each deployment so you must use `--recreate-pods` to ensure all pod use the same token.** see[Datadog Chart notes](https://github.com/helm/charts/blob/57d3030941ad2ec2d6f97c86afdf36666658a884/stable/datadog/templates/NOTES.txt#L49-L59) to learn more.

### Upgrading

#### From 1.19.0 onwards

Version `1.19.0` introduces the use of release name as full name if it contains the chart name(`datadog` in this case).
E.g. with a release name of `datadog`, this renames the `DaemonSet` from `datadog-datadog` to `datadog`.
The suggested approach is to delete the release and reinstall it.

#### From 1.0.0 onwards

Starting with version 1.0.0, this chart does not support deploying Agent 5.x anymore. If you cannot upgrade to Agent 6.x, you can use a previous version of the chart by calling helm install with `--version 0.18.0`.

See [0.18.1's README](https://github.com/helm/charts/blob/847f737479bb78d89f8fb650db25627558fbe1f0/stable/datadog/README.md) to see which options were supported at the time.

### Uninstalling the Chart

To uninstall/delete the `<RELEASE_NAME>` deployment:

```bash
helm delete <RELEASE_NAME> --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

As a best practice, a YAML file that specifies the values for the chart parameters should be provided to configure the chart:

1.  **Copy the default [`datadog-values.yaml`](values.yaml) value file.**
2.  Set the `apiKey` parameter with your [Datadog API key](https://app.datadoghq.com/account/settings#api).
3.  Upgrade the Datadog Helm chart with the new `datadog-values.yaml` file:

```bash
helm upgrade -f datadog-values.yaml <RELEASE_NAME> stable/datadog --recreate-pods
```

See the [All configuration options](#all-configuration-options) section to discover all possibilities offered by the Datadog chart.

### Enabling Log Collection

Update your [datadog-values.yaml](values.yaml) file with the following log collection configuration:

```
datadog:
  (...)
 logsEnabled: true
 logsConfigContainerCollectAll: true
```

then upgrade your Datadog Helm chart:

```bash
helm upgrade -f datadog-values.yaml <RELEASE_NAME> stable/datadog --recreate-pods
```

### Enabling Process Collection

Update your [datadog-values.yaml](values.yaml) file with the process collection configuration:

```
datadog:
  (...)
  processAgentEnabled: true
```

then upgrade your Datadog Helm chart:

```bash
helm upgrade -f datadog-values.yaml <RELEASE_NAME> stable/datadog --recreate-pods
```

### Enabling System Probe Collection

The system-probe agent only runs in dedicated container environment. Update your [datadog-values.yaml](values.yaml) file with the system-probe collection configuration:

```
systemProbe:
  (...)
  enabled: true

(...)

daemonset:
  useDedicatedContainers: true
```

then upgrade your Datadog Helm chart:

```bash
helm upgrade -f datadog-values.yaml <RELEASE_NAME> stable/datadog --recreate-pods
```

### Kubernetes event collection

Use the [Datadog Cluster Agent](#enabling-the-datadog-cluster-agent) to collect Kubernetes events. Please read [the official documentation](https://docs.datadoghq.com/agent/kubernetes/event_collection/) for more context.

Alternatively set the `datadog.leaderElection`, `datadog.collectEvents` and `rbac.create` options to `true` in order to enable Kubernetes event collection.

### conf.d and checks.d

The Datadog [entrypoint](https://github.com/DataDog/datadog-agent/blob/master/Dockerfiles/agent/entrypoint/89-copy-customfiles.sh) copies files with a `.yaml` extension found in `/conf.d` and files with `.py` extension in `/check.d` to `/etc/datadog-agent/conf.d` and `/etc/datadog-agent/checks.d` respectively.

The keys for `datadog.confd` and `datadog.checksd` should mirror the content found in their respective ConfigMaps. Update your [datadog-values.yaml](values.yaml) file with the check configurations:

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

then upgrade your Datadog Helm chart:

```bash
helm upgrade -f datadog-values.yaml <RELEASE_NAME> stable/datadog --recreate-pods
```

For more details, please refer to [the documentation](https://docs.datadoghq.com/agent/kubernetes/integrations/).

### Kubernetes Labels and Annotations

To map Kubernetes node labels and pod labels and annotations to Datadog tags, provide a dictionary with kubernetes labels/annotations as keys and Datadog tags key as values in your [datadog-values.yaml](values.yaml) file:

```yaml
nodeLabelsAsTags:
  beta.kubernetes.io/instance-type: aws_instance_type
  kubernetes.io/role: kube_role
```

```yaml
podAnnotationsAsTags:
  iam.amazonaws.com/role: kube_iamrole
```

```yaml
podLabelsAsTags:
  app: kube_app
  release: helm_release
```

then upgrade your Datadog Helm chart:

```bash
helm upgrade -f datadog-values.yaml <RELEASE_NAME> stable/datadog --recreate-pods
```

### CRI integration

As of the version 6.6.0, the Datadog Agent supports collecting metrics from any container runtime interface used in your cluster. Configure the location path of the socket with `datadog.criSocketPath` and make sure you allow the socket to be mounted into the pod running the agent by setting `datadog.useCriSocketVolume` to `True`.
Standard paths are:

- Containerd socket: `/var/run/containerd/containerd.sock`
- Cri-o socket: `/var/run/crio/crio.sock`

## All configuration options

The following table lists the configurable parameters of the Datadog chart and their default values. Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install --name <RELEASE_NAME> \
  --set datadog.apiKey=<DATADOG_API_KEY>,datadog.logLevel=DEBUG \
  stable/datadog
```

| Parameter                                | Description                                                                               | Default                                     |
| -----------------------------            | ------------------------------------                                                      | ------------------------------------------- |
| `datadog.apiKey`                         | Your Datadog API key                                                                      | `Nil` You must provide your own key         |
| `datadog.apiKeyExistingSecret`           | If set, use the secret with a provided name instead of creating a new one                 | `nil`                                       |
| `datadog.appKey`                         | Datadog APP key required to use metricsProvider                                           | `Nil` You must provide your own key         |
| `datadog.appKeyExistingSecret`           | If set, use the secret with a provided name instead of creating a new one                 | `nil`                                       |
| `image.repository`                       | The image repository to pull from                                                         | `datadog/agent`                             |
| `image.tag`                              | The image tag to pull                                                                     | `6.10.1`                                    |
| `image.pullPolicy`                       | Image pull policy                                                                         | `IfNotPresent`                              |
| `image.pullSecrets`                      | Image pull secrets                                                                        | `nil`                                       |
| `nameOverride`                           | Override name of app                                                                      | `nil`                                       |
| `fullnameOverride`                       | Override full name of app                                                                 | `nil`                                       |
| `rbac.create`                            | If true, create & use RBAC resources                                                      | `true`                                      |
| `rbac.serviceAccountName`                | existing ServiceAccount to use (ignored if rbac.create=true)                              | `default`                                   |
| `daemonset.podLabels`                    | labels to add to each pod                                                                 | `nil`                                       |
| `datadog.name`                           | Container name if Daemonset or Deployment                                                 | `datadog`                                   |
| `datadog.site`                           | Site ('datadoghq.com' or 'datadoghq.eu')                                                  | `nil`                                       |
| `datadog.dd_url`                         | Datadog intake server                                                                     | `nil`                                       |
| `datadog.env`                            | Additional Datadog environment variables                                                  | `nil`                                       |
| `datadog.logLevel`                       | Agent log verbosity (possible values: trace, debug, info, warn, error, critical, and off) | `INFO`                                      |
| `datadog.logsEnabled`                    | Enable log collection                                                                     | `nil`                                       |
| `datadog.logsConfigContainerCollectAll`  | Collect logs from all containers                                                          | `nil`                                       |
| `datadog.logsPointerHostPath`            | Host path to store the log tailing state in                                               | `/var/lib/datadog-agent/logs`               |
| `datadog.apmEnabled`                     | Enable tracing from the host                                                              | `nil`                                       |
| `datadog.processAgentEnabled`            | Control live process and container monitoring. Possible values: `nil` for container monitoring only, `true` for container and process monitoring, `false` turns off process-agent | `nil`|
| `datadog.checksd`                        | Additional custom checks as python code                                                   | `nil`                                       |
| `datadog.confd`                          | Additional check configurations (static and Autodiscovery)                                | `nil`                                       |
| `datadog.criSocketPath`                  | Path to the container runtime socket (if different from Docker)                           | `nil`                                       |
| `datadog.tags`                           | Set host tags                                                                             | `nil`                                       |
| `datadog.nonLocalTraffic`                | Enable statsd reporting from any external ip                                              | `False`                                     |
| `datadog.useCriSocketVolume`             | Enable mounting the container runtime socket in Agent containers                          | `True`                                      |
| `datadog.dogstatsdOriginDetection`       | Enable origin detection for container tagging                                             | `False`                                     |
| `datadog.useDogStatsDSocketVolume`       | Enable dogstatsd over Unix Domain Socket                                                  | `False`                                     |
| `datadog.dogStatsDSocketPath`            | Custom path to the socket, has to be located in the `/var/run/datadog` folder path        | `/var/run/datadog/dsd.socket`               |
| `datadog.volumes`                        | Additional volumes for the daemonset or deployment                                        | `nil`                                       |
| `datadog.volumeMounts`                   | Additional volumeMounts for the daemonset or deployment                                   | `nil`                                       |
| `datadog.nodeLabelsAsTags`               | Kubernetes Node Labels to Datadog Tags mapping                                            | `nil`                                       |
| `datadog.podAnnotationsAsTags`           | Kubernetes Annotations to Datadog Tags mapping                                            | `nil`                                       |
| `datadog.podLabelsAsTags`                | Kubernetes Labels to Datadog Tags mapping                                                 | `nil`                                       |
| `datadog.resources.requests.cpu`         | CPU resource requests                                                                     | `200m`                                      |
| `datadog.resources.limits.cpu`           | CPU resource limits                                                                       | `200m`                                      |
| `datadog.resources.requests.memory`      | Memory resource requests                                                                  | `256Mi`                                     |
| `datadog.resources.limits.memory`        | Memory resource limits                                                                    | `256Mi`                                     |
| `datadog.securityContext`                | Allows you to overwrite the default securityContext applied to the container              | `nil`                                       |
| `datadog.livenessProbe`                  | Overrides the default liveness probe                                                      | http port 5555                              |
| `datadog.hostname`                       | Set the hostname (write it in datadog.conf)                                               | `nil`                                       |
| `datadog.acInclude`                      | Include containers based on image name                                                    | `nil`                                       |
| `datadog.acExclude`                      | Exclude containers based on image name                                                    | `nil`                                       |
| `daemonset.podAnnotations`               | Annotations to add to the DaemonSet's Pods                                                | `nil`                                       |
| `daemonset.tolerations`                  | List of node taints to tolerate (requires Kubernetes >= 1.6)                              | `nil`                                       |
| `daemonset.nodeSelector`                 | Node selectors                                                                            | `nil`                                       |
| `daemonset.affinity`                     | Node affinities                                                                           | `nil`                                       |
| `daemonset.useHostNetwork`               | If true, use the host's network                                                           | `nil`                                       |
| `daemonset.useHostPID`.                  | If true, use the host's PID namespace                                                     | `nil`                                       |
| `daemonset.useHostPort`                  | If true, use the same ports for both host and container                                   | `nil`                                       |
| `daemonset.useDedicatedContainers`       | If true, each Datadog agent will run in a separate container                              | `nil`                                       |
| `daemonset.containers.agent.env`                          | Additional list of environment variables to use in the agent container                 | `nil`                                         |
| `daemonset.containers.agent.logLevel`                     | Agent log verbosity                                                                    | `INFO`                                        |
| `daemonset.containers.agent.resources.limits.cpu`         | CPU resource limits for the agent container                                            | `200m`                                        |
| `daemonset.containers.agent.resources.requests.cpu`       | CPU resource requests for the agent container                                          | `200m`                                        |
| `daemonset.containers.agent.resources.limits.memory`      | Memory resource limits for the agent container                                         | `256Mi`                                       |
| `daemonset.containers.agent.resources.requests.memory`    | Memory resource requests for the agent container                                       | `256Mi`                                       |
| `daemonset.containers.processAgent.env`                          | Additional list of environment variables to use in the process-agent container         | `nil`                                         |
| `daemonset.containers.processAgent.logLevel`                     | Process agent log verbosity                                                            | `INFO`                                        |
| `daemonset.containers.processAgent.resources.limits.cpu`         | CPU resource limits for the process-agent container                                    | `100m`                                        |
| `daemonset.containers.processAgent.resources.requests.cpu`       | CPU resource requests for the process-agent container                                  | `100m`                                        |
| `daemonset.containers.processAgent.resources.limits.memory`      | Memory resource limits for the process-agent container                                 | `200Mi`                                       |
| `daemonset.containers.processAgent.resources.requests.memory`    | Memory resource requests for the process-agent container                               | `200Mi`                                       |
| `daemonset.containers.traceAgent.env`                            | Additional list of environment variables to use in the trace-agent container           | `nil`                                         |
| `daemonset.containers.traceAgent.logLevel`                       | Trace agent log verbosity                                                              | `INFO`                                        |
| `daemonset.containers.traceAgent.resources.limits.cpu`           | CPU resource limits for the trace-agent container                                      | `100m`                                        |
| `daemonset.containers.traceAgent.resources.requests.cpu`         | CPU resource requests for the trace-agent container                                    | `100m`                                        |
| `daemonset.containers.traceAgent.resources.limits.memory`        | Memory resource limits for the trace-agent container                                   | `200Mi`                                       |
| `daemonset.containers.traceAgent.resources.requests.memory`      | Memory resource requests for the trace-agent container                                 | `200Mi`                                       |
| `daemonset.containers.systemProbe.env`                            | Additional list of environment variables to use in the system-probe container           | `nil`                                         |
| `daemonset.containers.systemProbe.logLevel`                       | System probe log verbosity                                                              | `INFO`                                        |
| `daemonset.containers.systemProbe.resources.limits.cpu`           | CPU resource limits for the system-probe container                                      | `100m`                                        |
| `daemonset.containers.systemProbe.resources.requests.cpu`         | CPU resource requests for the system-probe container                                    | `100m`                                        |
| `daemonset.containers.systemProbe.resources.limits.memory`        | Memory resource limits for the system-probe container                                   | `200Mi`                                       |
| `daemonset.containers.systemProbe.resources.requests.memory`      | Memory resource requests for the system-probe container                                 | `200Mi`                                       |
| `daemonset.priorityClassName`            | Which Priority Class to associate with the daemonset                                      | `nil`                                       |
| `daemonset.updateStrategy`               | Which update strategy to deploy the daemonset                                             | RollingUpdate with 10% maxUnavailable       |
| `datadog.leaderElection`                 | Enable the leader Election feature                                                        | `false`                                     |
| `datadog.leaderLeaseDuration`            | The duration for which a leader stays elected.                                            | 60 sec, 15 if Cluster Checks enabled        |
| `datadog.collectEvents`                  | Enable Kubernetes event collection. Requires leader election.                             | `false`                                     |
| `deployment.affinity`                    | Node / Pod affinities                                                                     | `{}`                                        |
| `deployment.tolerations`                 | List of node taints to tolerate                                                           | `[]`                                        |
| `deployment.priorityClassName`           | Which Priority Class to associate with the deployment                                     | `nil`                                       |
| `kubeStateMetrics.enabled`               | If true, create kube-state-metrics                                                        | `true`                                      |
| `kube-state-metrics.rbac.create`         | If true, create & use RBAC resources for kube-state-metrics                               | `true`                                      |
| `kube-state-metrics.serviceAccount.create`                 | If true, create & use serviceAccount                                    | `true`                                      |
| `kube-state-metrics.serviceAccount.name`                   | If not set & create is true, use template fullname                      |                                             |
| `kube-state-metrics.resources`                             | Overwrite the default kube-state-metrics container resources (Optional) |                                             |
| `clusterAgent.enabled`                   | Use the cluster-agent for cluster metrics (Kubernetes 1.10+ only)                         | `false`                                     |
| `clusterAgent.token`                     | A cluster-internal secret for agent-to-agent communication. Must be 32+ characters a-zA-Z | Generates a random value                    |
| `clusterAgent.tokenExistingSecret`                     | If set, use the secret with a provided name instead of creating a new one | `nil`                    |
| `clusterAgent.containerName`             | The container name for the Cluster Agent                                                  | `cluster-agent`                             |
| `clusterAgent.image.repository`          | The image repository for the cluster-agent                                                | `datadog/cluster-agent`                     |
| `clusterAgent.image.tag`                 | The image tag to pull                                                                     | `1.2.0`                                     |
| `clusterAgent.image.pullPolicy`          | Image pull policy                                                                         | `IfNotPresent`                              |
| `clusterAgent.image.pullSecrets`         | Image pull secrets                                                                        | `nil`                                       |
| `clusterAgent.metricsProvider.enabled`   | Enable Datadog metrics as a source for HPA scaling                                        | `false`                                     |
| `clusterAgent.clusterChecks.enabled`     | Enable Cluster Checks on both the Cluster Agent and the Agent daemonset                   | `false`                                     |
| `clusterAgent.confd`                     | Additional check configurations (static and Autodiscovery)                                | `nil`                                       |
| `clusterAgent.podAnnotations`            | Annotations to add to the Cluster Agent Pod(s)                                            | `nil`                                       |
| `clusterAgent.priorityClassName`         | Name of the priorityClass to apply to the Cluster Agent                                   | `nil`                                       |
| `clusterAgent.resources.requests.cpu`    | CPU resource requests                                                                     | `200m`                                      |
| `clusterAgent.resources.limits.cpu`      | CPU resource limits                                                                       | `200m`                                      |
| `clusterAgent.resources.requests.memory` | Memory resource requests                                                                  | `256Mi`                                     |
| `clusterAgent.resources.limits.memory`   | Memory resource limits                                                                    | `256Mi`                                     |
| `clusterAgent.tolerations`               | List of node taints to tolerate                                                           | `[]`                                        |
| `clusterAgent.livenessProbe`             | Overrides the default liveness probe                                                      | http port 443 if external metrics enabled   |
| `clusterAgent.readinessProbe`            | Overrides the default readiness probe                                                     | http port 443 if external metrics enabled   |
| `clusterAgent.strategy`                  | Which update strategy to deploy the cluster-agent                                         | RollingUpdate with 0 maxUnavailable, 1 maxSurge |
| `clusterchecksDeployment.enabled`        | Enable Datadog agent deployment dedicated for running Cluster Checks. It allows having different resources (Request/Limit) for Cluster Checks agent pods.  | `false` |
| `clusterchecksDeployment.env`                            | Additional Datadog environment variables for Cluster Checks Deployment                        | `nil`                                       |
| `clusterchecksDeployment.resources.requests.cpu`         | CPU resource requests                                                                         | `200m`                                      |
| `clusterchecksDeployment.resources.limits.cpu`           | CPU resource limits                                                                           | `200m`                                      |
| `clusterchecksDeployment.resources.requests.memory`      | Memory resource requests                                                                      | `256Mi`                                     |
| `clusterchecksDeployment.resources.limits.memory`        | Memory resource limits                                                                        | `256Mi`                                     |
| `clusterchecksDeployment.nodeSelector`                   | Node selectors                                                                                | `nil`                                       |
| `clusterchecksDeployment.tolerations`                    | List of node taints to tolerate                                                               | `nil`                                       |
| `clusterchecksDeployment.affinity`                       | Node affinities                                                                               | avoid running pods on the same node         |
| `clusterchecksDeployment.livenessProbe`                  | Overrides the default liveness probe                                                          | http port 5555                              |
| `clusterchecksDeployment.rbac.dedicated`                 | If true, use dedicated RBAC resources for clusterchecks agent's pods                          | `false`                                     |
| `clusterchecksDeployment.rbac.serviceAccount`            | existing ServiceAccount to use (ignored if rbac.create=true) for clusterchecks                | `default`                                   |
| `clusterchecksDeployment.strategy`                       | Which update strategy to deploy the Cluster Checks Deployment                                 | RollingUpdate with 0 maxUnavailable, 1 maxSurge |
| `systemProbe.enabled`                  | If both this flag and `daemonset.useDedicatedContainers` are true, enable system probe collection 	        | `false`                                           |
| `systemProbe.seccompRoot`              | Seccomp root directory for system-probe                                                                    | `/var/lib/kubelet/seccomp`                        |
| `systemProbe.debugPort`                | The port to expose pprof and expvar for system-probe agent, it is not enabled if the value is set to 0     | `0`                                               |
| `systemProbe.enableConntrack`          | If true, system-probe connects to the netlink/conntrack subsystem to add NAT information to connection data. Ref: http://conntrack-tools.netfilter.org/| `true`|
| `systemProbe.bpfDebug`                 | If true, system-probe writes debug logs to /sys/kernel/debug/tracing/trace_pipe                            | `false`                                           |
| `systemProbe.apparmor`                 | Apparmor profile for system-probe                            | `unconfined`                                           |
