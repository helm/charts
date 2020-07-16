# Instana

Instana is an [APM solution](https://www.instana.com/) built for microservices that enables IT Ops to build applications faster and deliver higher quality services by automating monitoring, tracing and root cause analysis. This solution is optimized for [Kubernetes](https://www.instana.com/automatic-kubernetes-monitoring/).

## Introduction

This chart adds the Instana Agent to all schedulable nodes in your cluster via a `DaemonSet`.

## Prerequisites

Kubernetes 1.9.x - 1.18.x

#### Helm 3 prerequisites

Working `helm` with the `stable` repo added to your helm client.

#### Helm 2 prerequisites

Working `helm` and `tiller`.

_Note:_ Tiller may need a service account and role binding if RBAC is enabled in your cluster.

## Installing the Chart

To configure the installation you can either specify the options on the command line using the **--set** switch, or you can edit **values.yaml**. Either way you should ensure that you set values for:

* agent.key
* zone.name or cluster.name

For most users, setting the `zone.name` is sufficient. However, if you would like to be able group your hosts based on the availability zone rather than cluster name, then you can specify the cluster name using the `cluster.name` instead of the `zone.name` setting. If you omit the `zone.name` the host zone will be automatically determined by the availability zone information on the host.

If you're in the EU, you'll probably also want to set the regional equivalent values for:

* agent.endpointHost
* agent.endpointPort

_Note:_ You can find the options mentioned in the [configuration section below](#configuration)

Optionally, if your infrastructure uses a proxy, you should ensure that you set values for:

* agent.pod.proxyHost
* agent.pod.proxyPort
* agent.pod.proxyProtocol
* agent.pod.proxyUser
* agent.pod.proxyPassword
* agent.pod.proxyUseDNS

Optionally, if your infrastructure has multiple networks defined, you might need to allow the agent to listen on all addresses (typically with value set to '*'):

* agent.listenAddress

If your agent requires download key, you should ensure that you set values for it:

* agent.downloadKey

Agent can have APM, INFRASTRUCTURE or AWS mode. Default is APM and if you want to override that, ensure you set value:

* agent.mode

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

#### Uninstalling with Helm 2

```bash
$ helm del --purge instana-agent
```

#### Uninstalling with Helm 3

```bash
$ helm del instana-agent -n instana-agent
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
| `agent.image.name`                 | The image name to pull                                                  | `instana/agent`                                                                                             |
| `agent.image.tag`                  | The image tag to pull                                                   | `latest`                                                                                                    |
| `agent.image.pullPolicy`           | Image pull policy                                                       | `Always`                                                                                                    |
| `agent.key`                        | Your Instana Agent key                                                  | `nil` You must provide your own key                                                                         |
| `agent.listenAddress`              | List of addresses to listen on, or "*" for all interfaces               | `nil`                                                                                                       |
| `agent.mode`                       | Agent mode (Supported values are APM, INFRASTRUCTURE, AWS)              | `APM`                                                                                                       |
| `agent.pod.annotations`            | Additional annotations to apply to the pod                              | `{}`                                                                                                        |
| `agent.pod.limits.cpu`             | Container cpu limits in cpu cores                                       | `1.5`                                                                                                       |
| `agent.pod.limits.memory`          | Container memory limits in MiB                                          | `512`                                                                                                       |
| `agent.pod.proxyHost`              | Hostname/address of a proxy                                             | `nil`                                                                                                       |
| `agent.pod.proxyPort`              | Port of a proxy                                                         | `nil`                                                                                                       |
| `agent.pod.proxyProtocol`          | Proxy protocol (Supported proxy types are "http", "socks4", "socks5")   | `nil`                                                                                                       |
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

### Agent

To configure the agent, you can either:

- edit the [config map](templates/configmap.yaml), or
- provide the configuration via the `agent.configuration_yaml` parameter in [values.yaml](values.yaml)

This configuration will be used for all Instana Agents on all nodes. Visit the [agent configuration documentation](https://docs.instana.io/setup_and_manage/host_agent/#agent-configuration-file) for more details on configuration options.
