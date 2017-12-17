# Cassandra
A Cassandra Chart for Kubernetes

## Install Chart
To install the Cassandra Chart into your Kubernetes cluster (This Chart requires persistent volume by default, you may need to create a storage class before install chart. To create storage class, see [Persist data](#persist_data) section)

```bash
helm install --namespace "cassandra" -n "cassandra" incubator/cassandra
```

After installation succeeds, you can get a status of Chart

```bash
helm status "cassandra"
```

If you want to delete your Chart, use this command
```bash
helm delete  --purge "cassandra"
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


## Install Chart with specific cluster size
By default, this Chart will create a cassandra with 3 nodes. If you want to change the cluster size during installation, you can use `--set config.cluster_size={value}` argument. Or edit `values.yaml`

For example:
Set cluster size to 5

```bash
helm install --namespace "cassandra" -n "cassandra" --set config.cluster_size=5 incubator/cassandra/
```

## Install Chart with specific resource size
By default, this Chart will create a cassandra with CPU 2 vCPU and 4Gi of memory which is suitable for development environment.
If you want to use this Chart for production, I would recommend to update the CPU to 4 vCPU and 16Gi. Also increase size of `max_heap_size` and `heap_new_size`.
To update the settings, edit `values.yaml`

## Install Chart with specific node
Sometime you may need to deploy your cassandra to specific nodes to allocate resources. You can use node selector by edit `nodes.enabled=true` in `values.yaml`
For example, you have 6 vms in node pools and you want to deploy cassandra to node which labeled as `cloud.google.com/gke-nodepool: pool-db`

Set the following values in `values.yaml`

```yaml
nodes:
  enabled: true
  selector:
    nodeSelector:
      cloud.google.com/gke-nodepool: pool-db
```

## Configuration

The following tables lists the configurable parameters of the Cassandra chart and their default values.

| Parameter                  | Description                                     | Default                                                    |
| -----------------------    | ---------------------------------------------   | ---------------------------------------------------------- |
| `image.repo`               | `cassandra` image repository                    | `cassandra`                                                |
| `image.tag`                | `cassandra` image tag                           | `3`                                                        |
| `image.pullPolicy`         | Image pull policy                               | `Always` if `imageTag` is `latest`, else `IfNotPresent`    |
| `image.pullSecrets`        | Image pull secrets                              | `nil`                                                      |
| `config.cluster_name`      | Username of new user to create.                 | `cassandra`                                                |
| `config.cluster_size`      | Password for the new user.                      | `3`                                                        |
| `config.seed_size`         | Name for new database to create.                | `2`                                                        |
| `config.num_tokens`        | Initdb Arguments                                | `256`                                                      |
| `config.dc_name`           | Initdb Arguments                                | `DC1`                                                      |
| `config.rack_name`         | Initdb Arguments                                | `RAC1`                                                     |
| `config.endpoint_snitch`   | Initdb Arguments                                | `SimpleSnitch`                                             |
| `config.max_heap_size`     | Initdb Arguments                                | `2048M`                                                    |
| `config.heap_new_size`     | Initdb Arguments                                | `512M`                                                     |
| `config.ports.cql`         | Initdb Arguments                                | `9042`                                                     |
| `config.ports.thrift`      | Initdb Arguments                                | `9160`                                                     |
| `config.start_rpc`         | Initdb Arguments                                | `false`                                                    |
| `persistence.enabled`      | Use a PVC to persist data                       | `true`                                                     |
| `persistence.storageClass` | Storage class of backing PVC                    | `nil` (uses alpha storage class annotation)                |
| `persistence.accessMode`   | Use volume as ReadOnly or ReadWrite             | `ReadWriteOnce`                                            |
| `persistence.size`         | Size of data volume                             | `10Gi`                                                     |
| `resources`                | CPU/Memory resource requests/limits             | Memory: `4Gi`, CPU: `2`                                    |
| `service.type`             | k8s service type exposing ports, e.g. `NodePort`| `ClusterIP`                                                |

## Scale cassandra
When you want to change the cluster size of your cassandra, you can use the helm upgrade command.

```bash
helm upgrade --set config.cluster_size=5 cassandra incubator/cassandra
```

## Get cassandra status
You can get your cassandra cluster status by running the command

```bash
kubectl exec -it --namespace cassandra $(kubectl get pods --namespace cassandra -l app=cassandra-cassandra -o jsonpath='{.items[0].metadata.name}') nodetool status
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

## Benchmark
You can use [cassandra-stress](https://docs.datastax.com/en/cassandra/3.0/cassandra/tools/toolsCStress.html) tool to run the benchmark on the cluster by the following command

```bash
kubectl exec -it --namespace cassandra $(kubectl get pods --namespace cassandra -l app=cassandra-cassandra -o jsonpath='{.items[0].metadata.name}') cassandra-stress
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
