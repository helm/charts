# Nifi chart

![forks](https://img.shields.io/github/forks/AlexsJones/nifi.svg)
![stars](https://img.shields.io/github/stars/AlexsJones/nifi.svg)
![license](https://img.shields.io/github/license/AlexsJones/nifi.svg)
![issues](https://img.shields.io/github/issues/AlexsJones/nifi.svg)

A helm chart for Nifi.
Includes zookeeper subchart.
Ready to roll.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/nifi
```

The command deploys nifi on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Post installation

Be prepared to wait a while - the election process in Nifi takes around 5 minutes.
You'll want to see:
```
nifi-1 nifi 2019-09-03 08:16:51,422 INFO [main] o.a.n.c.c.node.NodeClusterCoordinator This node is now connected to the cluster. Will no longer require election of DataFlow.
```

With logs afterwards containing similar to the following:
```
nifi-1 nifi 2019-09-03 08:17:09,879 INFO [Process Cluster Protocol Request-4] o.a.n.c.p.impl.SocketProtocolListener Finished processing request 538bf832-9a5d-4f53-93c6-1f35047ca1f8 (type=HEARTBEAT, length=3566 bytes) from nifi-2:8080 in 4 millis
nifi-1 nifi 2019-09-03 08:17:11,734 INFO [Process Cluster Protocol Request-5] o.a.n.c.p.impl.SocketProtocolListener Finished processing request 6d12fcd6-99e1-4b30-a78b-a70e18e9183c (type=HEARTBEAT, length=3566 bytes) from nifi-1:8080 in 3 millis
nifi-1 nifi 2019-09-03 08:17:11,735 INFO [Clustering Tasks Thread-1] o.a.n.c.c.ClusterProtocolHeartbeater Heartbeat created at 2019-09-03 08:17:11,727 and sent to nifi-1:2882 at 2019-09-03 08:17:11,735; send took 8 millis
```

## Configuration

Set a custom zookeeper subchart connection string
It is also possible to set `helm install . -n nifi --set="zookeeper.deploy.enabled=false"` to use an existing zookeeper deployment.

```yaml
listener:
  # This sets the nifi http listener port
  port: 8081

zookeeper:
  deploy:
    enabled: true
    # Enabled true will deploy zookeeper from the vendor folder
  nodeList: zk-0.zk-hs,zk-1.zk-hs,zk-2.zk-hs
  # NodeList can set a custom connection string of zookeeper hosts
  nodePort: 2888
```

Web UI Access

```yaml
service:
  type: LoadBalancer
  # Access the web UI from http://<IP>:8080/nifi/
  port: 8080
```

### Specifying Values

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm upgrade --install --wait my-release \
    --set zookeeper.heapSize=512 \
    .
```
_For more information around subchart values look within vendor/zookeeper_
