# Unbound

[Unbound](http://www.unbound.net) is a caching DNS resolver written in C. It is suitable for use as an upstream DNS resolver for kube-dns to enable in-cluster resolution of hostnames in private DNS zones. The image is based on alpine and includes unbound, bind-tools and bash and is approximately 20MB in size, making for fast startup.

allowedIpRanges:
- "10.10.10.10/32"
- "10.10.11.11/20"
To set forward zones uncomment the block below and replace the example
with your own data. For each zone you can provide forwardHosts, forwardIps
or both. If no forwardZones are set then the service will run
and respond to health probes, but will not resolve any dns names.
forwardZones:
- name: "fake.net"
  forwardHosts:
  - "fake1.host.net"
  - "fake2.host.net"
- name: "stillfake.net"
  forwardIps:
  - "10.10.10.10"
  - "10.11.10.10"
