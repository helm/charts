# Unbound

[Unbound](http://www.unbound.net) is a caching DNS resolver written in C. It is suitable for use as an upstream DNS resolver for kube-dns. The image is based on alpine and includes unbound, bind-tools and bash and is approximately 20MB in size, making for fast startup. Google's [healthz container](https://hub.docker.com/r/googlecontainer/exechealthz/) is used as a sidecar to probe the unbound container on localhost, which allows unbound to run in a default configuration with restricted network access, and still play nice with kubelet.

## Configuration

The chart values file contains the default settings for the unbound server. In the default configuration unbound will allow queries from localhost only, and will not have any forward zones. This means that queries sent to the clusterip of the service will return access denied, and queries from localhost for anything other than the health check record `health.check.unbound` will return NXDOMAIN.

You can configure unbound for your specific use case by passing a values file that contains the following properties. Most or all of these can also be set from the helm command line using `--set`.

### Access control

Controls which IP address ranges unbound will allow queries from. If you want to use unbound as an upstream for kube-dns, or allow other pods to query the resolver directly, you'll at least need to allow the `clusterIpV4Cidr` range.

```yaml
allowedIpRanges:
- "10.10.10.10/20"
- "10.10.11.11/20"
```

### Forward zones

You can set as many forward zones as needed by speciying the zone name and forward hosts. Forward hosts can be set by hostname or ip.

```yaml
forwardZones:
- name: "fake.net"
  forwardHosts:
  - "fake1.host.net"
  - "fake2.host.net"
- name: "stillfake.net"
  forwardIps:
  - "10.10.10.10"
  - "10.11.10.10"
```

### Local records

Unbound can store DNS records in a "local zone." This facility can be used to assign context-specific names to a given IP address, and could also be used for private DNS if you don't want or have an external resolver.

```yaml
localRecords:
- name: "fake3.host.net"
  ip: "10.12.10.10"
- name: "fake4.host.net"
  ip: "10.13.10.10"
```

## Configuring as an upstream resolver for kube-dns

To configure unbound to act as an upstream resolver for kube-dns edit the `kube-dns` configmap in the kube-system namespace to add the `stubDomains` value as shown below. The forwarding address for the domain should be set to the cluster IP of the unbound service.

```yaml
apiVersion: v1
data:
  stubDomains: |
    {"fake.net": ["10.59.248.82"]}
kind: ConfigMap
metadata:
  creationTimestamp: 2018-01-04T18:09:38Z
  labels:
    addonmanager.kubernetes.io/mode: EnsureExists
  name: kube-dns
  namespace: kube-system
  resourceVersion: "1825"
  selfLink: /api/v1/namespaces/kube-system/configmaps/kube-dns
  uid: 6d759f7d-f17a-11e7-898d-42010a800159
```
