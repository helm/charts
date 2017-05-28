# Telegraf

*This chart has been deprecated as of version 0.2.1 and will not be updated. Please use the telegraf-s and telegraf-ds charts instead.*

[Telegraf](https://github.com/influxdata/telegraf) is a plugin-driven server agent written by the folks over at [InfluxData](https://influxdata.com) for collecting & reporting metrics.

## TL;DR

```console
$ helm install stable/telegraf
```

## Introduction

This chart bootstraps a `telegraf` deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/telegraf
```

The command deploys Telegraf on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
 
## Configuration

The default configuration parameters are listed in `values.yaml`. To change the defaults, specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set single.enabled=false \
    stable/telegraf
```

The above command prevents the single telegraf instance from deploying.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/telegraf
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Telegraf Configuration

This chart deploys the following by default:

- `telegraf` (`telegraf-ds`) running in a daemonset with the following plugins enabled
  * [`cpu`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/system)
  * [`disk`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/system)
  * [`docker`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/docker)
  * [`diskio`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/system)
  * [`kernel`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/system)
  * [`kubernetes`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/kubernetes)
  * [`mem`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/system)
  * [`processes`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/system)
  * [`swap`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/system)
  * [`system`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/system)

- A single `telegraf` deployment (`telegraf-s`) with an associated service running the following plugins:
  * [`prometheus`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/prometheus)
  * [`influxdb`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/influxdb)
  * [`statsd`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/statsd)

  
### Supported Outputs

The following telegraf output plugins are supported for both the daemonset and the single instance. To enable them uncomment them in `.Values.{{ "daemonset" | "single" }}.outputs`:

- [`amqp`](https://github.com/influxdata/telegraf/tree/master/plugins/outputs/amqp)
- [`influxdb`](https://github.com/influxdata/telegraf/tree/master/plugins/outputs/influxdb)
- [`kafka`](https://github.com/influxdata/telegraf/tree/master/plugins/outputs/kafka)
- [`mqtt`](https://github.com/influxdata/telegraf/tree/master/plugins/outputs/mqtt)
- [`nats`](https://github.com/influxdata/telegraf/tree/master/plugins/outputs/nats)
- [`nsq`](https://github.com/influxdata/telegraf/tree/master/plugins/outputs/nsq)

### Service Plugins - Single Instance

The single telegraf also supports all service plugins. To enable them uncomment the named plugin in `.Values.single.inputs` section. The associated service exposes the ports if it is enabled:

- [`tcp_listener`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/tcp_listener)
- [`udp_listener`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/udp_listener)
- [`statsd`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/statsd)
- [`http_listener`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/http_listener)

### Supported Inputs - Single Instance

To enable additional input plugins uncomment them in the `.Values.single.inputs` section. The input plugins supported by the single telegraf instance are as follows:

- [`aerospike`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/aerospike)
- [`apache`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/apache)
- [`cassandra`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/cassandra)
- [`cloudwatch`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/cloudwatch)
- [`consul`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/consul)
- [`couchbase`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/couchbase)
- [`couchdb`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/couchdb)
- [`disque`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/disque)
- [`dns_query`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/dns_query)
- [`dovecot`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/dovecot)
- [`elasticsearch`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/elasticsearch)
- [`graylog`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/graylog)
- [`haproxy`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/haproxy)
- [`influxdb`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/influxdb)
- [`lustre2`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/lustre2)
- [`mailchimp`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/mailchimp)
- [`memcached`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/memcached)
- [`mesos`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/mesos)
- [`mongodb`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/mongodb)
- [`mysql`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/mysql)
- [`net_response`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/net_response)
- [`nginx`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/nginx)
- [`nsq`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/nsq)
- [`phpfpm`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/phpfpm)
- [`ping`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/ping)
- [`postgresql`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/postgresql)
- [`prometheus`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/prometheus)
- [`rabbitmq`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/rabbitmq)
- [`raindrops`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/raindrops)
- [`redis`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/redis)
- [`rethinkdb`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/rethinkdb)
- [`riak`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/riak)
- [`sqlserver`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/sqlserver)
- [`twemproxy`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/twemproxy)
- [`zookeeper`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/zookeeper)
- [`http_listener`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/http_listener)
- [`statsd`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/statsd)
- [`tcp_listener`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/tcp_listener)
- [`udp_listener`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/udp_listener)
- [`webhooks`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/webhooks)

### Future work:

There are a couple of additional plugins that could/should possibly be supported but are not yet:
- `telegraf-s`
  - [`smnp`](https://github.com/influxdata/telegraf/tree/master/plugins/smnp)
- `telegraf-ds`
  - [`jolokia`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/jolokia)
  - [`bcache`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/bcache)
  - [`cgroup`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/cgroup)
  - [`conntrack`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/conntrack)
  - [`exec`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/exec)
  - [`filestat`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/filestat)
  - [`hddtemp`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/hddtemp)
  - [`ipmi_sensor`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/ipmi_sensor)
  - [`iptables`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/iptables)
  - [`leofs`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/leofs)
  - [`logparser`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/logparser)
  - [`nstat`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/nstat)
  - [`ntpq`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/ntpq)
  - [`passenger`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/passenger)
  - [`powerdns`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/powerdns)
  - [`procstat`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/procstat)
  - [`puppetagent`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/puppetagent)
  - [`sysstat`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/sysstat)
  - [`varnish`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/varnish)
  - [`win_perf_counters`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/win_perf_counters)
  - [`zfs`](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/zfs)
