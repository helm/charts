CoreDNS
=======

CoreDNS is a DNS server that chains middleware and provides Kubernetes DNS Services

TL;DR;
------

```console
$ helm install --name coredns stable/coredns
```

Introduction
------------

This chart bootstraps a [CoreDNS](https://github.com/coredns/coredns) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

This chart will provide DNS Services to a Kubernetes cluster and is a drop-in replacement for Kube/SkyDNS.

Prerequisites
-------------

-	Kubernetes 1.4+ with Beta APIs enabled

Installing the Chart
--------------------

Since there is typically only a single DNS Server per kubernetes cluster, this Chart does not make use of the release name. For convenience the chart can be installed as follows:

```console
$ helm install --name coredns stable/coredns
```

The command deploys CoreDNS on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

Uninstalling the Chart
----------------------

To uninstall/delete the `my-release` deployment:

```console
$ helm delete coredns
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

Configuration
-------------

The following tables lists the configurable parameters of the CoreDNS chart and their default values.

| Parameter          | Description                         | Default                      |
|--------------------|-------------------------------------|------------------------------|
| `image.repository` | CoreDNS image                       | `coredns/coredns`            |
| `image.tag`        | CoreDNS tag                         | `006`                        |
| `image.pullPolicy` | Image pull policy                   | `IfNotPresent`               |
| `clusterCidr`      | The CIDR for the Kubernetes Cluster | `10.3.0.0/24`                |
| `clusterDomain`    | The Domain for the Cluster DNS      | `cluster.local`              |
| `clusterIP`        | The IP for the DNS Server           | `10.3.0.10`                  |
| `metrics.enabled`  | Enable Prometheus Metrics           | `true`                       |
| `metrics.port`     | Prometheus Pot                      | `9153`                       |
| `resources`        | CPU/Memory resource requests/limits | Memory: `128Mi`, CPU: `100m` |

The above parameters map to the env variables defined in [coredns/coredns](http://github.com/coredns/coredns). For more information please refer to the [coredns/coredns](http://github.com/coredns/coredns) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name coredns \
  --set metrics.enabled=false \
    stable/coredns
```

The above command disables the Prometheus metrics.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name coredns -f values.yaml stable/coredns
```

> **Tip**: You can use the default [values.yaml](values.yaml)
