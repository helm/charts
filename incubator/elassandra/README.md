# Elassandra

An [Elassandra](http://www.elassandra.io) Chart for Kubernetes.

## Install Chart

To install the Elassandra Chart into your Kubernetes cluster (This Chart requires persistent volume by default, you may need to create a storage class before install chart. To create storage class, see Persist data section)

```bash
helm install --namespace "default" -n "elassandra" incubator/elassandra
```

After installation succeeds, you can get a status of Chart

```bash
helm status "elassandra"
```

As show below, the Elassandra chart creates 2 clustered service for elasticsearch and cassandra. This allow to deploy elasticsearch and cassandra applications in their default configuration.

```bash
kubectl get all -o wide -n elassandra
NAME                          READY     STATUS    RESTARTS   AGE
pod/elassandra-0              1/1       Running   0          51m
pod/elassandra-1              1/1       Running   0          50m
pod/elassandra-2              1/1       Running   0          49m

NAME                    TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                                                          AGE
service/cassandra       ClusterIP   10.0.174.13    <none>        9042/TCP,9160/TCP                                                51m
service/elassandra      ClusterIP   None           <none>        7199/TCP,7000/TCP,7001/TCP,9300/TCP,9042/TCP,9160/TCP,9200/TCP   51m
service/elasticsearch   ClusterIP   10.0.131.15    <none>        9200/TCP                                                         51m

NAME                          DESIRED   CURRENT   AGE
statefulset.apps/elassandra   3         3         51m
```

If you want to delete your Chart, use this command

```bash
helm delete  --purge "elassandra"
```

## Enable/Disable elasticsearch

You can enable/disable the elasticsearch service by setting the following values in `values.yaml`

```yaml
elasticsearch:
  enabled: true
```

## Persist data
You need to create `StorageClass` before able to persist data in persistent volume.
To create a `StorageClass` on Google Cloud, run the following

```bash
kubectl create -f sample/create-storage-gce.yaml
```

And set the following values in `values.yaml`

```yaml
persistence:
  enabled: true
```

If you want to create a `StorageClass` on other platform, please see documentation here [https://kubernetes.io/docs/user-guide/persistent-volumes/](https://kubernetes.io/docs/user-guide/persistent-volumes/)

If you want to use SSD managed disk on Microsoft Azure, set `persistence.storageClassName: "managed-premium"` in `values.yaml`.

When running a cluster without persistence, the termination of a pod will first initiate a decommissioning of that pod.
Depending on the amount of data stored inside the cluster this may take a while. In order to complete a graceful
termination, pods need to get more time for it. Set the following values in `values.yaml`:

```yaml
podSettings:
  terminationGracePeriodSeconds: 1800
```

## Install Chart with specific cluster size
By default, this Chart will create an elassandra with 3 nodes. If you want to change the cluster size during installation, you can use `--set config.cluster_size={value}` argument. Or edit `values.yaml`

For example:
Set cluster size to 5

```bash
helm install --namespace "elassandra" -n "elassandra" --set config.cluster_size=5 incubator/elassandra/
```

## Install Chart with specific resource size

By default, this Chart will create a cassandra with CPU 2 vCPU and 4Gi of memory which is suitable for development environment.
If you want to use this Chart for production, I would recommend to update the CPU to 4 vCPU and 16Gi. Also increase size of `max_heap_size` and `heap_new_size`.
To update the settings, edit `values.yaml`

## Configuration

The following table lists the configurable parameters of the Cassandra chart and their default values.

| Parameter                  | Description                                     | Default                                                    |
| -----------------------    | ---------------------------------------------   | ---------------------------------------------------------- |
| `image.repo`                         | `elassandra` image repository                   | `strapdata/elassandra`                                    |
| `image.tag`                          | `elassandra` image tag                          | `6.2.3.7`                                                  |
| `image.pullPolicy`                   | Image pull policy                               | `Always` if `imageTag` is `latest`, else `IfNotPresent`    |
| `image.pullSecrets`                  | Image pull secrets                              | `nil`                                                      |
| `elasticsearch.enabled`              | Enable elasticsearch service                    | `true`                                                     |
| `config.cluster_name`                | The name of the cluster.                        | `elassandra`                                               |
| `config.cluster_size`                | The number of nodes in the cluster.             | `3`                                                        |
| `config.seed_size`                   | The number of seed nodes used to bootstrap new clients joining the cluster.                            | `2` |
| `config.num_tokens`                  | Initdb Arguments                                | `16`                                                       |
| `config.dc_name`                     | Initdb Arguments                                | `DC1`                                                      |
| `config.rack_name`                   | Initdb Arguments                                | `RAC1`                                                     |
| `config.endpoint_snitch`             | Initdb Arguments                                | `GossipingPropertyFileSnitch`                              |
| `config.max_heap_size`               | Initdb Arguments                                | `4096M`                                                    |
| `config.heap_new_size`               | Initdb Arguments                                | `512M`                                                     |
| `config.ports.cql`                   | Initdb Arguments                                | `9042`                                                     |
| `config.ports.thrift`                | Initdb Arguments                                | `9160`                                                     |
| `config.ports.elasticsearch`         | Initdb Arguments                                | `9200`                                                     |
| `config.ports.transport`             | Initdb Arguments                                | `9300`                                                     |
| `config.ports.agent`                 | The port of the JVM Agent (if any)              | `nil`                                                      |
| `config.start_rpc`                   | Initdb Arguments                                | `false`                                                    |
| `persistence.enabled`                | Use a PVC to persist data                       | `true`                                                     |
| `persistence.storageClass`           | Storage class of backing PVC                    | `nil` (uses alpha storage class annotation)                |
| `persistence.accessMode`             | Use volume as ReadOnly or ReadWrite             | `ReadWriteOnce`                                            |
| `persistence.size`                   | Size of data volume                             | `10Gi`                                                     |
| `resources`                          | CPU/Memory resource requests/limits             | Memory: `4Gi`, CPU: `2`                                    |
| `podManagementPolicy`                | podManagementPolicy of the StatefulSet          | `OrderedReady`                                             |
| `updateStrategy.type`                | UpdateStrategy of the StatefulSet               | `RollingUpdate`                                            |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated        | `30`                                                       |
| `livenessProbe.periodSeconds`        | How often to perform the probe                  | `5`                                                       |
| `livenessProbe.timeoutSeconds`       | When the probe times out                        | `5`                                                        |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed.           | `1` |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.             | `10` |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated       | `30`                                                       |
| `readinessProbe.periodSeconds`       | How often to perform the probe                  | `5`                                                       |
| `readinessProbe.timeoutSeconds`      | When the probe times out                        | `5`                                                        |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed.           | `1` |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.             | `10` |

### Scale elassandra
When you want to change the cluster size of your cassandra, you can use the helm upgrade command.

```bash
helm upgrade --set config.cluster_size=5 elassandra incubator/elassandra
```

### Switch form Elassandra / Cassandra
You can switch from Elassandra (Elasticsearch enabled) to pure Cassandra (Elasticsearch disabled) by setting the `elasticsearch.enabled` to `true` or `false`, this change java main class. 

**WARNING**: As soon as you have created one elasticsearch index in your elassandra cluster, the CQL schema requires that all nodes runs the elassandra binaries. Running a node with standard cassandra binaries will causes a *ClassNotFounException* when trying to instanciate the elasticsearch custom secondary index.

### Get elassandra status

You can get your elassandra cluster status by running the command

```bash
kubectl exec -it --namespace elassandra $(kubectl get pods --namespace elassandra -l app=elassandra-elassandra -o jsonpath='{.items[0].metadata.name}') nodetool status
```

Output
```bash
Datacenter: asia-east1
======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address    Load       Tokens       Owns (effective)  Host ID                               Rack
UN  10.8.1.11  108.45 KiB  256          66.1%             410cc9da-8993-4dc2-9026-1dd381874c54  a
UN  10.8.4.12  84.08 KiB  256          68.7%             96e159e1-ef94-406e-a0be-e58fbd32a830  c
UN  10.8.3.6   103.07 KiB  256          65.2%             1a42b953-8728-4139-b070-b855b8fff326  b
```
To check the elasticsearch cluster status:

```bash
kubectl exec -it -n elassandra $(kubectl get pods -n elassandra -l app=elassandra,release=elassandra -o jsonpath='{.items[0].metadata.name}') curl http://localhost:9200/_cluster/state?pretty
```

To check elasticsearch nodes status:

```bash
kubectl exec -it -n elassandra $(kubectl get pods -n elassandra -l app=elassandra,release=elassandra -o jsonpath='{.items[0].metadata.name}') curl http://localhost:9200/_cat/nodes
```

To check Elasticsearch indices:

```bash
kubectl exec -it -n elassandra $(kubectl get pods -n elassandra -l app=elassandra,release=elassandra -o jsonpath='{.items[0].metadata.name}') curl http://localhost:9200/_cat/indices?v
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  kVpEHykCR7CT_Xnlastq7A   3   0          1            0      3.5kb          3.5kb
```

## Deploy Kibana

To install the Kibana chart with the release name `elassandra`:

```console
$ helm install --namespace "elassandra" --name kibana --set image.tag=6.2.3  stable/kibana
```

To forward the kibana port to POD localhost:5601 run the following:

```console
kubectl port-forward -n elassandra $(kubectl get pods -n elassandra -l app=kibana -o jsonpath='{ .items[0].metadata.name }') 5601:5601
```

## Benchmark
You can use [cassandra-stress](https://docs.datastax.com/en/cassandra/3.0/cassandra/tools/toolsCStress.html) tool to run the benchmark on the cluster by the following command

```bash
kubectl exec -it --namespace elassandra $(kubectl get pods --namespace elassandra -l app=elassandra-elassandra -o jsonpath='{.items[0].metadata.name}') cassandra-stress
```

Example of `cassandra-stress` argument
 - Run both read and write with ration 9:1
 - Operator total 1 million keys with uniform distribution
 - Use QUORUM for read/write
 - Generate 50 threads
 - Generate result in graph
 - Use NetworkTopologyStrategy with replica factor 2

```bash
cassandra-stress mixed ratio\(write=1,read=9\) n=1000000 cl=QUORUM -pop dist=UNIFORM\(1..1000000\) -mode native cql3 -rate threads=50 -log file=~/mixed_autorate_r9w1_1M.log -graph file=test2.html title=test revision=test2 -schema "replication(strategy=NetworkTopologyStrategy, factor=2)"
```

## Acknowledgment

This HELM chart is largely based from the [cassandra charts](https://github.com/strapdata/charts/tree/master/incubator/cassandra) maintained by **KongZ**.