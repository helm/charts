# Keycloak Proxy

[Keycloak Proxy](https://www.keycloak.org/docs/3.3/server_installation/topics/proxy.html)
Keycloak has an HTTP(S) proxy that you can put in front of web applications and services where it is not possible to install the Keycloak adapter. You can set up URL filters so that certain URLs are secured either by browser login and/or bearer token authentication. You can also define role constraints for URL patterns within your applications.

## TL;DR;

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/keycloak-proxy
```

## Introduction

This chart bootstraps a [Keycloak Proxy](https://www.keycloak.org/docs/3.3/server_installation/topics/proxy.html) Deployment on a [Kubernetes](https://kubernetes.io) cluster
using the [Helm](https://helm.sh) package manager. It provisions a fully featured Keycloak Proxy installation.
For more information on Keycloak and its capabilities, see its [documentation](https://www.keycloak.org/docs/3.3/server_installation/topics/proxy.html) and [Docker Hub repository](https://hub.docker.com/r/jboss/keycloak-proxy/).

## Prerequisites Details

The chart has an optional dependency on the [Keycloak](https://github.com/kubernetes/charts/tree/master/incubator/keycloak) chart.
If you already have a Keycloak environment, you can use it.

## Installing the Chart

To install the chart with the release name `keycloak-proxy`:

```console
$ helm install --name keycloak-proxy incubator/keycloak-proxy
```

## Uninstalling the Chart

To uninstall/delete the `keycloak-proxy` deployment:

```console
$ helm delete keycloak-proxy
```

## Configuration

The following table lists the configurable parameters of the Keycloak chart and their default values.

Parameter | Description | Default
--- | --- | ---
`imageRepository` | Keycloak Proxy image repository | `jboss/keycloak-proxy`
`imageTag` | Keycloak Proxy image version | `3.4.0.Final`
`imagePullPolicy` | Keycloak Proxy image pull policy | `IfNotPresent`
`service.type` | The service type | `ClusterIP`
`service.port` | The service port | `80`
`service.nodePort` | The service nodePort | `""`
`ingress.enabled` | If true, an ingress is be created | `false`
`ingress.annotations` | Annotations for the ingress | `{}`
`ingress.hosts` | A list of hosts for the ingresss | `[keycloak-proxy.example.com]`
`ingress.tls.enabled` | If true, tls is enabled for the ingress | `false`
`ingress.tls.existingSecret` | A list of hosts for the ingress | `false`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name keycloak-proxy -f values.yaml incubator/keycloak-proxy
```
