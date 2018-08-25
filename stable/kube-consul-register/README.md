# kube-consul-register

[kube-consul-register](https://github.com/tczekajlo/kube-consul-register) is a tool to register Kubernetes Pods to Consul.

## TL;DR;

```
helm install stable/kube-consul-register
```

## Introduction

This chart bootstraps [kube-consul-register](https://github.com/tczekajlo/kube-consul-register) on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

* Kubernetes

## Installing the Chart

To install the chart with release name `my-release`:

```bash
$ helm install --name my-release stable/kube-consul-register
```

The command deploys kube-consul-register on the Kubernetes cluster with the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the release `my-release`:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the kube-concul-register chart and their default values.

| Parameter                           | Description                                                                               | Default                          |
| ----------------------------------- | ----------------------------------------------------------------------------------------- | -------------------------------- |
| `image`                             | `kube-consul-register` image name                                                         | `tczekajlo/kube-consul-register` |
| `imageTag`                          | `kube-consul-register` image tag                                                          | `0.1.6`                          |
| `replicas`                          | replica count                                                                             | `3`                              |
| `rbac.create`                       | if true, create & use RBAC resources                                                      | `true`                           |
| `rbac.serviceAccountName`           | existing ServiceAccount to use (ignored if `rbac.create=true`)                            | `default`                        |
| `configMap.create`                  | if true, create ConfigMap with default values                                             | `true`                           |
| `configMap.name`                    | existing ConfigMap to use (igored if `configMap.create=true`)                             | `nil`                            |
| `configMap.consulAddress`           | `kube-consul-register` config, `consul_address` (used if `configMap.registerMode=single`) | `localhost`                      |
| `configMap.consulPort`              | `kube-consul-register` config, `consul_port`                                              | `8500`                           |
| `configMap.registerMode`            | `kube-consul-register` config, `register_mode`                                            | `node`                           |
| `configMap.registerSource`          | `kube-consul-register` config, `register_source`                                          | `pod`                            |
| `configMap.podLabelSelector`        | `kube-consul-register` config, `pod_label_selector`                                       | ``                               |
| `configMap.k8sTag`                  | `kube-consul-register` config, `k8s_tag`                                                  | `kubernetes`                     |
| `commandArgs.logToStdErr`           | `kube-consul-register` command argument `-logtostderr`                                    | `true`                           |
| `commandArgs.logLevel`              | `kube-consul-register` command argument `-v`                                              | `nil`                            |
| `commandArgs.cleanIntervalDuration` | `kube-consul-register` command argument `-clean-interval duration`                        | `nil`                            |
| `commandArgs.syncInterval`          | `kube-consul-register` command argument `-sync-interval`                                  | `nil`                            |
| `commandArgs.watchNamespace`        | `kube-consul-register` command argument `-watch-namespace`                                | `nil`                            |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set commandArgs.logLevel=8,commandArgs.watchNamespace=default \
    stable/kube-consul-register
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/kube-consul-register
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### kube-consul-register configs

[https://github.com/tczekajlo/kube-consul-register/#configuration](https://github.com/tczekajlo/kube-consul-register/#configuration)

### kube-consul-register command arguments

[https://github.com/tczekajlo/kube-consul-register/#usage](https://github.com/tczekajlo/kube-consul-register/#usage)