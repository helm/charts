# Zookeeper chart

Apache ZooKeeper is an effort to develop and maintain an open-source server which enables highly reliable distributed coordination.

## Chart Details
This chart will provision a fully functional and fully featured Zookeeper installation
that can be used for a variety of tier 2/3 applications.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/zookeeper
```

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/zookeeper
```

## Docker image

The Docker image used for this chart resides [here](https://github.com/kow3ns/kubernetes-zookeeper/tree/master/docker)


## Customizing your installation

Within the `values.yaml` there are default options described below that are parameterised and passed through to Zookeeper.

```
maxClientConnections: 60
#Limits the number of concurrent connections (at the socket level) that a single client,
#identified by IP address, may make to a single member of the ZooKeeper ensemble.
#This is used to prevent certain classes of DoS attacks, including file descriptor exhaustion.
#The default is 10. Setting this to 0 entirely removes the limit on concurrent connections.
maxSessionTimeout: 40000
#New in 3.3.0: the maximum session timeout in milliseconds that the server will allow the client to negotiate. Defaults to 20 times the tickTime.
minSessionTimeout: 4000
#New in 3.3.0: the minimum session timeout in milliseconds that the server will allow the client to negotiate. Defaults to 2 times the tickTime.
tickTime: 2000
#the length of a single tick, which is the basic time unit used by ZooKeeper, as measured in milliseconds. It is used to regulate heartbeats, and timeouts.
#For example, the minimum session timeout will be two ticks.
purgeInterval: 12
initLimit: 10
#Amount of time, in ticks (see tickTime), to allow followers to connect and sync to a leader.
#Increased this value as needed, if the amount of data managed by ZooKeeper is large.
syncLimit: 5
#Amount of time, in ticks (see tickTime), to allow followers to sync with ZooKeeper. If followers fall too far behind a leader, they will be dropped.
snapRetainCount: 3
```

In addition to this there are performance, isolation and scalability controls also available for customization.

```
resources: {}

nodeSelector: {}

tolerations: []

affinity: {}

heapSize: 1024m

storageSize: 250Gi
```
