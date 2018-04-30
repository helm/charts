# kiam

Installs [kiam](https://github.com/uswitch/kiam) to integrate AWS IAM with Kubernetes.

## TL;DR;

```console
$ helm install incubator/kiam
```

## Introduction

This chart bootstraps a [kiam](https://github.com/uswitch/kiam) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

In order for the chart to configure kiam correctly during the installation process you should have created and installed TLS certificates and private keys as described [here](https://github.com/uswitch/kiam/blob/master/docs/TLS.md).

> **Tip**: The `hosts` field in the kiam server certificate should include the value _release-name_-kiam-server:443, e.g. `my-release-kiam-server:443`

To install the chart with the release name `my-release`:

```console
$ helm install incubator/kiam --name my-release
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
`agent.dnsPolicy` | Agent pod DNS policy | `ClusterFirstWithHostNet`
`agent.extraArgs` | Additional agent container arguments | `{}`
`agent.extraEnv` | Additional agent container environment variables | `{}`
`agent.extraHostPathMounts` | Additional agent container hostPath mounts | `[]`
`agent.host.ip` | IP address of host | `$(HOST_IP)`
`agent.host.iptables` | Add iptables rule | `false`
`agent.host.interface` | Agent's host interface for proxying AWS metadata | `cali+`
`agent.host.port` | Agent's listening port | `8181`
`agent.image.repository` | Agent image | `quay.io/uswitch/kiam`
`agent.image.tag` | Agent image tag | `v2.5`
`agent.image.pullPolicy` | Agent image pull policy | `IfNotPresent`
`agent.log.jsonOutput` | Whether or not to output agent log in JSON format | `true`
`agent.log.level` | Agent log level (`debug`, `info`, `warn` or `error`) | `info`
`agent.nodeSelector` | Node labels for agent pod assignment | `{}`
`agent.prometheus.port` | Agent Prometheus metrics port | `9620`
`agent.prometheus.scrape` | Whether or not Prometheus metrics for the agent should be scraped | `true`
`agent.prometheus.syncInterval` | Agent Prometheus synchronization interval | `5s`
`agent.podAnnotations` | Annotations to be added to agent pods | `{}`
`agent.podLabels` | Labels to be added to agent pods | `{}`
`agent.resources` | Agent container resources | `{}`
`agent.tls.caFileName` | Agent certificate authority file name | `ca.pem`
`agent.tls.certFileName` | Agent certificate file name | `agent.pem`
`agent.tls.keyFileName` | Agent private key file name | `agent-key.pem`
`agent.tls.mountPath` | Agent TLS certificates and keys mount path | `/etc/kiam/tls`
`agent.tls.secretName` | Agent TLS secret name | `kiam-agent-tls`
`agent.tolerations` | Tolerations to be applied to agent pods | `[]`
`agent.updateStrategy` | Strategy for agent DaemonSet updates (requires Kubernetes 1.6+) | `OnDelete`
`rbac.create` | If `true`, create & use RBAC resources | `false`
`rbac.serviceAccountName` | Existing service account to use (ignored if `rbac.create=true`) | `default`
`server.assumeRoleArn` | IAM role for the server to assume before processing requests | `null`
`server.cache.syncInterval` | Pod cache synchronization interval | `1m`
`server.extraArgs` | Additional server container arguments | `{}`
`server.extraEnv` | Additional server container environment variables | `{}`
`server.extraHostPathMounts` | Additional server container hostPath mounts | `[]`
`server.image.repository` | Server image | `quay.io/uswitch/kiam`
`server.image.tag` | Server image tag | `v2.5`
`server.image.pullPolicy` | Server image pull policy | `Always`
`server.log.jsonOutput` | Whether or not to output server log in JSON format | `true`
`server.log.level` | Server log level (`debug`, `info`, `warn` or `error`) | `info`
`server.nodeSelector` | Node labels for server pod assignment | `{}`
`server.prometheus.port` | Server Prometheus metrics port | `9620`
`server.prometheus.scrape` | Whether or not Prometheus metrics for the server should be scraped | `true`
`server.prometheus.syncInterval` | Server Prometheus synchronization interval | `5s`
`server.podAnnotations` | Annotations to be added to server pods | `{}`
`server.podLabels` | Labels to be added to server pods | `{}`
`server.resources` | Server container resources | `{}`
`server.roleBaseArn` | Base ARN for IAM roles. If not specified use EC2 metadata service to detect ARN prefix | `null`
`server.sessionDuration` | Session duration for STS tokens generated by the server | `15m`
`server.service.port` | Server service port | `443`
`server.service.targetPort` | Server service target port | `443`
`server.tls.caFileName` | Server certificate authority file name | `ca.pem`
`server.tls.certFileName` | Server certificate file name | `server.pem`
`server.tls.keyFileName` | Server private key file name | `server-key.pem`
`server.tls.mountPath` | Server TLS certificates and keys mount path | `/etc/kiam/tls`
`server.tls.secretName` | Server TLS secret name | `kiam-server-tls`
`server.tolerations` | Tolerations to be applied to server pods | `[]`
`server.updateStrategy` | Strategy for server DaemonSet updates (requires Kubernetes 1.6+) | `OnDelete`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install incubator/kiam --name my-release \
  --set=extraArgs.base-role-arn=arn:aws:iam::0123456789:role/,extraArgs.default-role=kube2iam-default,host.iptables=true,host.interface=cbr0
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install incubator/kiam --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
