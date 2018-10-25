# Apache Pulsar

## TL;DR;

```console
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com
$ helm install incubator/pulsar
```

## Introduction

This chart bootstraps a [Apache Pulsar](https://pulsar.apache.org) deployment on a [GKE (Google Kubernetes Engine)](https://cloud.google.com/kubernetes-engine/) cluster using the [Helm](https://helm.sh) package manager.


## Prerequisites

- If you would like TLS encryption and/or authentication you will need to create certificates:
    - [Transport Encryption using TLS](https://pulsar.apache.org/docs/en/security-tls-transport/)
    - [Authentication using TLS](https://pulsar.apache.org/docs/en/security-tls-authentication/)



## RBAC

By default the chart is installed with associated RBAC roles and rolebindings. If you would like to not install the provided roles and rolebindings please do the following:

```
$ helm install incubator/pulsar --set rbac.install=false
```


## Installing the Chart

The default installation does not include TLS and would be open to anyone. While this is quick to get up and running it is insecure and not reccommended. 

The installation requires that we install zookeeper before other components are marked as "up". To acheive this, we use init containers to wait for required pods to be available.

```console
$ helm install --name pulsar incubator/pulsar --namespace pulsar
```

## Uninstalling the Chart

To uninstall/delete the `pulsar` deployment:

```console
$ helm delete pulsar
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

If you would like to completely wipe the install, use:

```console
$ helm delete pulsar --purge
```


## Configuration

Configuration is documented in the [values.yaml](values.yaml) file. It is reccommended that you copy this file somewhere then reference it when installing:

```console
$ helm install -f /path/to/values.yaml incubator/pulsar --name pulsar --namesapce pulsar
```

> **Tip**: You can use the default [values.yaml](values.yaml)

In interest of security, you can use multiple values.yaml files. I put my certificates and keys ("secrets") in one file and the rest of my configuration in another:

```console
$ helm install -f /path/to/values.yaml -f /path/to/secrets.yaml incubator/pulsar --name pulsar --namesapce pulsar
```


## Extra Config

Each component can use the `extraConfig` dict to set more configuration if you would like. This is useful to enable flags that are not enabled by default:

```yaml
broker:
  extraConfig:
    authorizationAllowWildcardsMatching: "true"
    tlsAllowInsecureConnection: "true"
```

### Addons
Pulsar ships with several preconfigured addons
* Grafana
* Prometheus
* Pulsar Dashboard

These addons can be selectively disabled in the values.yaml file.


