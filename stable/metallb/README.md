MetalLB
-------

MetalLB is a load-balancer implementation for bare
metal [Kubernetes](https://kubernetes.io) clusters, using standard
routing protocols.

TL;DR;
------

```console
$ helm install --name metallb stable/metallb
```

Introduction
------------

This chart bootstraps a [MetalLB](https://metallb.universe.tf)
installation on a [Kubernetes](http://kubernetes.io) cluster using
the [Helm](https://helm.sh) package manager. This chart provides an
implementation for LoadBalancer Service objects.

MetalLB is a cluster service, and as such can only be deployed as a
cluster singleton. Running multiple installations of MetalLB in a
single cluster is not supported.

Prerequisites
-------------

-	Kubernetes 1.9+

Installing the Chart
--------------------

The chart can be installed as follows:

```console
$ helm install --name metallb stable/metallb
```

The command deploys MetalLB on the Kubernetes cluster. This chart does
not provide a default configuration, MetalLB will not act on your
Kubernetes Services until you provide
one. The [configuration](#configuration) section lists various ways to
provide this configuration.

Uninstalling the Chart
----------------------

To uninstall/delete the `metallb` deployment:

```console
$ helm delete metallb
```

The command removes all the Kubernetes components associated with the
chart and deletes the release.

Configuration
-------------

See `values.yaml` for configuration notes. Specify each parameter
using the `--set key=value[,key=value]` argument to `helm
install`. For example,

```console
$ helm install --name metallb \
  --set rbac.create=false \
    stable/metallb
```

The above command disables the use of RBAC rules.

Alternatively, a YAML file that specifies the values for the above
parameters can be provided while installing the chart. For example,

```console
$ helm install --name metallb -f values.yaml stable/metallb
```

By default, this chart does not install a configuration for MetalLB,
and simply warns you that you must
follow
[the configuration instructions on MetalLB's website](https://metallb.universe.tf/configuration/) to
create an appropriate ConfigMap.

For simple setups that only use
MetalLB's [ARP mode](https://metallb.universe.tf/concepts/arp-ndp/),
you can specify a single IP range using the `arpCIDR` parameter to
have the chart install a working configuration for you:

```console
$ helm install --name metallb \
  --set arpCIDR=192.168.16.240/30 \
  stable/metallb
```

If you have a more complex configuration and want Helm to manage it
for you, you can provide it in the `config` parameter. The
configuration format
is
[documented on MetalLB's website](https://metallb.universe.tf/configuration/).

```console
$ cat values.yaml
config:
  peers:
  - peer-address: 10.0.0.1
    peer-asn: 64512
    my-asn: 64512
  address-pools:
  - name: default
    protocol: bgp
    cidr:
    - 198.51.100.0/24

$ helm install --name metallb -f values.yaml stable/metallb
```
