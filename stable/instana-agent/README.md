# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Instana

Instana is an [APM solution](https://www.instana.com/) built for microservices that enables IT Ops to build applications faster and deliver higher quality services by automating monitoring, tracing and root cause analysis. This solution is optimized for [Kubernetes](https://www.instana.com/automatic-kubernetes-monitoring/).

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## Introduction

This chart adds the Instana Agent to all schedulable nodes in your cluster via a `DaemonSet`.

## Prerequisites

Kubernetes 1.9.x - 1.18.x

### Helm 3 prerequisites

Working `helm` with the `stable` repo added to your helm client.

### Helm 2 prerequisites

Working `helm` and `tiller`.

_Note:_ Tiller may need a service account and role binding if RBAC is enabled in your cluster.

## Installing the Chart

To configure the installation you can either specify the options on the command line using the **--set** switch, or you can edit **values.yaml**.

### Required Settings

#### Configuring the Instana Backend

In order to report the data it collects to the Instana backend for analysis, the Instana agent must know which backend to report to, and which credentials to use to authenticate, known as "agent key".

As described by the [Install Using the Helm Chart](https://www.instana.com/docs/setup_and_manage/host_agent/on/kubernetes#install-using-the-helm-chart) documentation, you will find the right values for the following fields inside Instana itself:

* `agent.endpointHost`
* `agent.endpointPort`
* `agent.key`

_Note:_ You can find the options mentioned in the [configuration section below](#configuration)

If your agents report into a self-managed Instana unit (also known as "on-prem"), you will also need to configure a "download key", which allows the agent to fetch its components from the Instana repository.
The download key is set via the following value:

* `agent.downloadKey`

### Zone and Cluster

Instana needs to know how to name your Kubernetes cluster and, optionally, how to group your Instana agents in [Custom zones](https://www.instana.com/docs/setup_and_manage/host_agent/configuration/#custom-zones) using the following fields:

* `zone.name`
* `cluster.name`

Either `zone.name` or `cluster.name` are required.
If you omit `cluster.name`, the value of `zone.name` will be used as cluster name as well.
If you omit `zone.name`, the host zone will be automatically determined by the availability zone information provided by the [supported Cloud providers](https://www.instana.com/docs/setup_and_manage/cloud_service_agents).

### Optional Settings

#### Configuring Additional Backends

You may want to have your Instana agents report to multiple backends.
The first backend must be configured as shown in the [Configuring the Instana Backend](#configuring-the-instana-backend); every backend after the first, is configured in the `agent.additionalBackends` list in the [values.yaml](values.yaml) as follows:

```yaml
agent:
  additionalBackends:
  # Second backend
  - endpointHost: my-instana.instana.io # endpoint host; e.g., my-instana.instana.io
    endpointPort: 443 # default is 443, so this line could be omitted
    key: ABCDEFG # agent key for this backend
  # Third backend
  - endpointHost: another-instana.instana.io # endpoint host; e.g., my-instana.instana.io
    endpointPort: 1444 # default is 443, so this line could be omitted
    key: LMNOPQR # agent key for this backend
```

The snippet above configures the agent to report to two additional backends.
The same effect as the above can be accomplished via the command line via:

```sh
$ helm install -n instana-agent instana-agent stable/instana-agent ... \
    --set 'agent.additionalBackends[0].endpointHost=my-instana.instana.io' \
    --set 'agent.additionalBackends[0].endpointPort=443' \
    --set 'agent.additionalBackends[0].key=ABCDEFG' \
    --set 'agent.additionalBackends[1].endpointHost=another-instana.instana.io' \
    --set 'agent.additionalBackends[1].endpointPort=1444' \
    --set 'agent.additionalBackends[1].key=LMNOPQR'
```

_Note:_ There is no hard limitation on the number of backends an Instana agent can report to, although each comes at the cost of a slight increase in CPU and memory consumption.

#### Configuring a Proxy between the Instana agents and the Instana backend

If your infrastructure uses a proxy, you should ensure that you set values for:

* `agent.pod.proxyHost`
* `agent.pod.proxyPort`
* `agent.pod.proxyProtocol`
* `agent.pod.proxyUser`
* `agent.pod.proxyPassword`
* `agent.pod.proxyUseDNS`

#### Configuring which Networks the Instana Agent should listen on

If your infrastructure has multiple networks defined, you might need to allow the agent to listen on all addresses (typically with value set to `*`):

* `agent.listenAddress`

#### Agent Modes

Agent can have either APM or INFRASTRUCTURE.
Default is APM and if you want to override that, ensure you set value:

* `agent.mode`

For more information on agent modes, refer to the [Host Agent Modes](https://www.instana.com/docs/setup_and_manage/host_agent#host-agent-modes) documentation.

#### Installing with Helm 3

First, create a namespace for the instana-agent

```bash
$ kubectl create namespace instana-agent
```

To install the chart with the release name `instana-agent` and set the values on the command line run:

```bash
$ helm install instana-agent --namespace instana-agent \
--set agent.key=INSTANA_AGENT_KEY \
--set agent.endpointHost=HOST \
--set zone.name=ZONE_NAME \
stable/instana-agent
```

#### Installing with Helm 2

To install the chart with the release name `instana-agent` and set the values on the command line run:

```bash
$ helm install --name instana-agent --namespace instana-agent \
--set agent.key=INSTANA_AGENT_KEY \
--set agent.endpointHost=HOST \
--set zone.name=ZONE_NAME \
stable/instana-agent
```

## Uninstalling the Chart

To uninstall/delete the `instana-agent` release:

### Uninstalling with Helm 3

```bash
$ helm del instana-agent -n instana-agent
```

### Uninstalling with Helm 2

```bash
$ helm del --purge instana-agent
```

## Configuration

### Helm Chart

The following table lists the configurable parameters of the Instana chart and their default values.

|             Parameter              |            Description                                                  |                    Default                                                                                  |
|------------------------------------|-------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| `agent.configuration_yaml`         | Custom content for the agent configuration.yaml file                    | `nil` See [below](#agent) for more details                                                                  |
| `agent.downloadKey`                | Your Instana Download key                                               | `nil` Usually not required                                                                                  |
| `agent.endpointHost`               | Instana Agent backend endpoint host                                     | `ingress-red-saas.instana.io` (US and ROW). If in Europe, please override with `ingress-blue-saas.instana.io`                   |
| `agent.endpointPort`               | Instana Agent backend endpoint port                                     | `443`                                                                                                       |
| `agent.additionalBackends`         | List of additional backends to report to; it must specify the `endpointHost` and `key` fields, and optionally `endpointPort` | `[]` Usually not required; see [Configuring Additional Backends](#configuring-additional-backends) for more info and examples |
| `agent.image.name`                 | The image name to pull                                                  | `instana/agent`                                                                                             |
| `agent.image.tag`                  | The image tag to pull                                                   | `latest`                                                                                                    |
| `agent.image.pullPolicy`           | Image pull policy                                                       | `Always`                                                                                                    |
| `agent.key`                        | Your Instana Agent key                                                  | `nil` You must provide your own key                                                                         |
| `agent.listenAddress`              | List of addresses to listen on, or "*" for all interfaces               | `nil`                                                                                                       |
| `agent.mode`                       | Agent mode. Supported values are `APM`, `INFRASTRUCTURE`, `AWS`         | `APM`                                                                                                 |
| `agent.pod.annotations`            | Additional annotations to apply to the pod                              | `{}`                                                                                                        |
| `agent.pod.limits.cpu`             | Container cpu limits in cpu cores                                       | `1.5`                                                                                                       |
| `agent.pod.limits.memory`          | Container memory limits in MiB                                          | `512`                                                                                                       |
| `agent.pod.priorityClassName`      | Name of an _existing_ PriorityClass that should be set on the agent pods | `nil`                                                                                                      |
| `agent.pod.proxyHost`              | Hostname/address of a proxy                                             | `nil`                                                                                                       |
| `agent.pod.proxyPort`              | Port of a proxy                                                         | `nil`                                                                                                       |
| `agent.pod.proxyProtocol`          | Proxy protocol. Supported proxy types are `http` (for both HTTP and HTTPS proxies), `socks4`, `socks5`.   | `nil`                                                         |
| `agent.pod.proxyUser`              | Username of the proxy auth                                              | `nil`                                                                                                       |
| `agent.pod.proxyPassword`          | Password of the proxy auth                                              | `nil`                                                                                                       |
| `agent.pod.proxyUseDNS`            | Boolean if proxy also does DNS                                          | `nil`                                                                                                       |
| `agent.pod.requests.memory`        | Container memory requests in MiB                                        | `512`                                                                                                       |
| `agent.pod.requests.cpu`           | Container cpu requests in cpu cores                                     | `0.5`                                                                                                       |
| `agent.pod.tolerations`            | Tolerations for pod assignment                                          | `[]`                                                                                                        |
| `agent.env`                        | Additional environment variables for the agent                          | `{}`                                                                                                        |
| `agent.redactKubernetesSecrets`    | Enable additional secrets redaction for selected Kubernetes resources   | `nil` See [Kubernetes secrets](https://docs.instana.io/setup_and_manage/host_agent/on/kubernetes/#secrets) for more details.   |
| `cluster.name`                     | Display name of the monitored cluster                                   | Value of `zone.name`                                                                                        |
| `leaderElector.port`               | Instana leader elector sidecar port                                     | `42655`                                                                                                     |
| `leaderElector.image.name`         | The elector image name to pull                                          | `instana/leader-elector`                                                                                             |
| `leaderElector.image.tag`          | The elector image tag to pull                                           | `0.5.4`                                                                                                    |
| `podSecurityPolicy.enable`         | Whether a PodSecurityPolicy should be authorized for the Instana Agent pods. Requires `rbac.create` to be `true` as well. | `false` See [PodSecurityPolicy](https://docs.instana.io/setup_and_manage/host_agent/on/kubernetes/#podsecuritypolicy) for more details. |
| `podSecurityPolicy.name`           | Name of an _existing_ PodSecurityPolicy to authorize for the Instana Agent pods. If not provided and `podSecurityPolicy.enable` is `true`, a PodSecurityPolicy will be created for you. | `nil` |
| `rbac.create`                      | Whether RBAC resources should be created                                | `true`                                                                                                      |
| `serviceAccount.create`            | Whether a ServiceAccount should be created                              | `true`                                                                                                      |
| `serviceAccount.name`              | Name of the ServiceAccount to use                                       | `instana-agent`                                                                                             |
| `zone.name`                        | Zone that detected technologies will be assigned to                     | `nil` You must provide either `zone.name` or `cluster.name`, see [above](#installing-the-chart) for details |

#### Development and debugging options

These options will be rarely used outside of development or debugging of the agent.

|             Parameter              |            Description                                                  |                    Default                                                                                  |
|------------------------------------|-------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| `agent.host.repository`            | Host path to mount as the agent maven repository                        | `nil`                                                                                                       |

### Agent Configuration

Besides the settings listed above, there are many more settings that can be applied to the agent via the so-called "Agent Configuration File", often also referred to as `configuration.yaml` file.
An overview of the settings that can be applied is provided in the [Agent Configuration File](https://www.instana.com/docs/setup_and_manage/host_agent/configuration#agent-configuration-file) documentation.
To configure the agent, you can either:

- edit the [config map](templates/configmap.yaml), or
- provide the configuration via the `agent.configuration_yaml` parameter in [values.yaml](values.yaml)

This configuration will be used for all Instana Agents on all nodes. Visit the [agent configuration documentation](https://docs.instana.io/setup_and_manage/host_agent/#agent-configuration-file) for more details on configuration options.

_Note:_ This Helm Chart does not support configuring [Multiple Configuration Files](https://www.instana.com/docs/setup_and_manage/host_agent/configuration#multiple-configuration-files).
