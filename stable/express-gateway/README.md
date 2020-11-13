# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# ⚠️ Chart Deprecated

## Express Gateway

[Express Gateway](https://express-gateway.io) is an API Gateway that sits at the heart of any microservices architecture.
## TL;DR;

```bash
$ helm install stable/express-gateway
```

## Introduction

This chart bootstraps all the components needed to run Express Gateway on a [Kubernetes](http://kubernetes.io)
cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9+
- PV provisioner support in the underlying infrastructure if persistence
  is needed for Express Gateway datastore (backed by Redis)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/express-gateway
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

### General Deployment Configuration Parameters

The following table lists the configurable parameters of the Express Gateway chart
and their default values.

| Parameter            | Description                                                                                            | Default                          |
|----------------------|--------------------------------------------------------------------------------------------------------|----------------------------------|
| image.repository     | Express Gateway image                                                                                  | `expressgateway/express-gateway` |
| image.tag            | Express Gateway image version                                                                          | `v1.16.9`               |
| image.pullPolicy     | Image pull policy                                                                                      | `IfNotPresent`                   |
| replicaCount         | Express Gateway instance count                                                                         | `1`                              |
| admin.servicePort    | TCP port on which the Express Gateway admin service is exposed                                         | `9876`                           |
| admin.containerPort  | TCP port on which Express Gateway app listens for admin traffic                                        | `9876`                           |
| admin.nodePort       | Node port when service type is `NodePort`. Randomly chonsen by Kubernetes if not provided              |                                  |
| admin.type           | k8s service type, Options: NodePort, ClusterIP, LoadBalancer                                           | `NodePort`                       |
| admin.loadBalancerIP | Will reuse an existing ingress static IP for the admin service                                         | `null`                           |
| proxy.https          | Secure Proxy traffic                                                                                   | `true`                           |
| proxy.tls            | When `proxy.https` is `true`, an [array of key][eg-tls-section]                                        | `{}`                             |
| proxy.servicePort    | TCP port on which the Express Gateway Proxy Service is exposed                                         | `8080`                           |
| proxy.containerPort  | TCP port on which the Express Gateway app listens for Proxy traffic                                    | `8080`                           |
| proxy.nodePort       | Node port when service type is `NodePort`. Randomly chonsen by Kubernetes if not provided              |                                  |
| proxy.type           | k8s service type. Options: NodePort, ClusterIP, LoadBalancer                                           | `NodePort`                       |
| proxy.loadBalancerIP | To reuse an existing ingress static IP for the admin service                                           |                                  |
| readinessProbe       | Express Gateway readiness probe                                                                        |                                  |
| livenessProbe        | Express Gateway liveness probe                                                                         |                                  |
| affinity             | Node/pod affinities                                                                                    |                                  |
| nodeSelector         | Node labels for pod assignment                                                                         | `{}`                             |
| podAnnotations       | Annotations to add to each pod                                                                         | `{}`                             |
| resources            | Pod resource requests & limits                                                                         | `{}`                             |
| tolerations          | List of node taints to tolerate                                                                        | `[]`                             |


### Express Gateway configuration parameters

Express Gateway is configured through the [Admin API interface][admin-api]. Its complete configuration is stored in a config map.
However there are some parameters that need to beset up before the container can start.

```yml

storage:
  emulate: true
  namespace: EG

crypto:
  cipherKey: sensitiveKey
  algorithm: aes256
  saltRounds: 10
session:
  secret: keyboard cat
  resave: false
  saveUninitialized: false
accessTokens:
  timeToExpiry: 7200000
refreshTokens:
  timeToExpiry: 7200000
authorizationCodes:
  timeToExpiry: 300000

```

For a complete list of Express Gateway cnfiguration parameters please check https://www.express-gateway.io/docs/configuration/system.config.yml

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/express-gateway --name my-release \
  --set=image.tag=v1.11.0,redis.enabled=false
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/express-gateway --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

[eg-tls-section]: https://www.express-gateway.io/docs/configuration/gateway.config.yml/https/#description
[admin-api]: https://www.express-gateway.io/docs/admin/
