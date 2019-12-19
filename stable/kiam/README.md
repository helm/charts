# kiam

Installs [kiam](https://github.com/uswitch/kiam) to integrate AWS IAM with Kubernetes.

## Deprecation Notice

As mentioned in #16664, this chart has been deprecated in favour of the [uSwitch-hosted Helm chart](https://github.com/uswitch/kiam/tree/master/helm/kiam).
Please open new [issues](https://github.com/uswitch/kiam/issues/new) and pull requests in the [uSwitch repository](https://github.com/uswitch/kiam).

The chart is also available in [Helm Hub](https://hub.helm.sh/charts/uswitch/kiam).

## TL;DR;

```console
$ helm install stable/kiam
```

## Introduction

This chart bootstraps a [kiam](https://github.com/uswitch/kiam) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

The chart generates a self signed TLS certificate by default.
If you want to create and install your own, you can create TLS certificates and private keys as described [here](https://github.com/uswitch/kiam/blob/master/docs/TLS.md).

> **Tip**: The `hosts` field in the kiam server certificate should include the value _release-name_-server:_server-service-port_, e.g. `my-release-server:443`

> If you don't include the exact hostname used by the kiam agent to connect to the server, you'll see a warning (which is really an error) in the agent logs similar to the following, and your pods will fail to obtain credentials:
```json
{"level":"warning","msg":"error finding role for pod: rpc error: code = Unavailable desc = there is no connection available","pod.ip":"100.120.0.2","time":"2018-05-24T04:11:25Z"}
```

Define values `agent.tlsFiles.ca`, `agent.tlsFiles.cert`, `agent.tlsFiles.key`, `server.tlsFiles.ca`, `server.tlsFiles.cert` and `server.tlsFiles.key` to be the base64-encoded contents (.e.g. using the `base64` command) of the generated PEM files.
For example

```yaml
agent:
  tlsFiles:
    key: LS0tL...
    cert: LS0tL...
    ca: LS0tL...

server:
  tlsFiles:
    key: LS0tL...
    cert: LS0tL...
    ca: LS0tL...
```

Define secret name values `agent.tlsSecret` and `server.tlsSecret` if TLS certificates secrets have already created instead of `tlsFiles`.

```yaml
agent:
  tlsSecret: kiam-agent-tls

server:
  tlsSecret: kiam-server-tls
```
Define TLS certificate names to use in kiam command line arguments as follows.
```yaml
agent:
  tlsCerts:
    certFileName: cert
    keyFileName: key
    caFileName: ca

server:
  tlsCerts:
    certFileName: cert
    keyFileName: key
    caFileName: ca
```

To install the chart with the release name `my-release`:

```console
$ helm install stable/kiam --name my-release
```

The command deploys kiam on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the kiam chart and their default values.

Parameter | Description | Default
--- | --- | ---
`agent.enabled` | If true, create agent | `true`
`agent.name` | Agent container name | `agent`
`agent.image.repository` | Agent image | `quay.io/uswitch/kiam`
`agent.image.tag` | Agent image tag | `v3.3`
`agent.image.pullPolicy` | Agent image pull policy | `IfNotPresent`
`agent.dnsPolicy` | Agent pod DNS policy | `ClusterFirstWithHostNet`
`agent.whiteListRouteRegexp` | Agent pod whitelist metadata API path argument regex  | `{}`
`agent.extraArgs` | Additional agent container arguments | `{}`
`agent.extraEnv` | Additional agent container environment variables | `{}`
`agent.extraHostPathMounts` | Additional agent container hostPath mounts | `[]`
`agent.gatewayTimeoutCreation` | Agent's timeout when creating the kiam gateway | `50ms`
`agent.host.ip` | IP address of host | `$(HOST_IP)`
`agent.host.iptables` | Add iptables rule | `false`
`agent.host.interface` | Agent's host interface for proxying AWS metadata | `cali+`
`agent.host.port` | Agent's listening port | `8181`
`agent.log.jsonOutput` | Whether or not to output agent log in JSON format | `true`
`agent.log.level` | Agent log level (`debug`, `info`, `warn` or `error`) | `info`
`agent.nodeSelector` | Node labels for agent pod assignment | `{}`
`agent.prometheus.port` | Agent Prometheus metrics port | `9620`
`agent.prometheus.scrape` | Whether or not Prometheus metrics for the agent should be scraped | `true`
`agent.prometheus.syncInterval` | Agent Prometheus synchronization interval | `5s`
`agent.podAnnotations` | Annotations to be added to agent pods | `{}`
`agent.podLabels` | Labels to be added to agent pods | `{}`
`agent.priorityClassName` | Agent pods priority class name | `""`
`agent.resources` | Agent container resources | `{}`
`agent.serviceAnnotations` | Annotations to be added to agent service | `{}`
`agent.serviceLabels` | Labels to be added to agent service | `{}`
`agent.tlsSecret` | Secret name for the agent's TLS certificates | `null`
`agent.tlsFiles.ca` | Base64 encoded string for the agent's CA certificate(s) | `null`
`agent.tlsFiles.cert` | Base64 encoded strings for the agent's certificate | `null`
`agent.tlsFiles.key` | Base64 encoded strings for the agent's private key | `null`
`agent.tolerations` | Tolerations to be applied to agent pods | `[]`
`agent.affinity` | Node affinity for pod assignment | `{}`
`agent.updateStrategy` | Strategy for agent DaemonSet updates (requires Kubernetes 1.6+) | `OnDelete`
`server.enabled` | If true, create server | `true`
`server.name` | Server container name | `server`
`server.gatewayTimeoutCreation` | Server's timeout when creating the kiam gateway | `50ms`
`server.image.repository` | Server image | `quay.io/uswitch/kiam`
`server.image.tag` | Server image tag | `v3.3`
`server.image.pullPolicy` | Server image pull policy | `Always`
`server.assumeRoleArn` | IAM role for the server to assume before processing requests | `null`
`server.cache.syncInterval` | Pod cache synchronization interval | `1m`
`server.extraArgs` | Additional server container arguments | `{}`
`server.extraEnv` | Additional server container environment variables | `{}`
`server.extraHostPathMounts` | Additional server container hostPath mounts | `[]`
`server.log.jsonOutput` | Whether or not to output server log in JSON format | `true`
`server.log.level` | Server log level (`debug`, `info`, `warn` or `error`) | `info`
`server.nodeSelector` | Node labels for server pod assignment | `{}`
`server.prometheus.port` | Server Prometheus metrics port | `9620`
`server.prometheus.scrape` | Whether or not Prometheus metrics for the server should be scraped | `true`
`server.prometheus.syncInterval` | Server Prometheus synchronization interval | `5s`
`server.podAnnotations` | Annotations to be added to server pods | `{}`
`server.podLabels` | Labels to be added to server pods | `{}`
`server.probes.serverAddress` | Address that readyness and liveness probes will hit | `127.0.0.1`
`server.priorityClassName` | Server pods priority class name | `""`
`server.resources` | Server container resources | `{}`
`server.roleBaseArn` | Base ARN for IAM roles. If not specified use EC2 metadata service to detect ARN prefix | `null`
`server.sessionDuration` | Session duration for STS tokens generated by the server | `15m`
`server.serviceAnnotations` | Annotations to be added to server service | `{}`
`server.serviceLabels` | Labels to be added to server service | `{}`
`server.service.port` | Server service port | `443`
`server.service.targetPort` | Server service target port | `443`
`server.tlsSecret` | Secret name for the server's TLS certificates | `null`
`server.tlsFiles.ca` | Base64 encoded string for the server's CA certificate(s) | `null`
`server.tlsFiles.cert` | Base64 encoded strings for the server's certificate | `null`
`server.tlsFiles.key` | Base64 encoded strings for the server's private key | `null`
`server.tolerations` | Tolerations to be applied to server pods | `[]`
`server.affinity` | Node affinity for pod assignment | `{}`
`server.updateStrategy` | Strategy for server DaemonSet updates (requires Kubernetes 1.6+) | `OnDelete`
`server.useHostNetwork` | If true, use hostNetwork on server to bypass agent iptable rules | `false`
`rbac.create` | If `true`, create & use RBAC resources | `true`
`psp.create` | If `true`, create Pod Security Policies for the agent and server when enabled | `false`
`serviceAccounts.agent.create` | If true, create the agent service account | `true`
`serviceAccounts.agent.name` | Name of the agent service account to use or create | `{{ kiam.agent.fullname }}`
`serviceAccounts.server.create` | If true, create the server service account | `true`
`serviceAccounts.server.name` | Name of the server service account to use or create | `{{ kiam.server.fullname }}`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/kiam --name my-release \
  --set=extraArgs.base-role-arn=arn:aws:iam::0123456789:role/,extraArgs.default-role=kube2iam-default,host.iptables=true,host.interface=cbr0
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/kiam --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
