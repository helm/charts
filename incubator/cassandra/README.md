# Cassandra

Cassandra is a distributed NoSQL database management system designed to handle
large amounts of data across many commodity servers, providing high
availability with no single point of failure.

## Installing Chart
 
Installation of this Chart requires PV (Persistent Volume) storage.  You may
need to create a storage class before you install.  To create this, see the
[Persist Data](#persisting_data) section.

```bash
helm install --namespace "cassandra" -n "cassandra" incubator/cassandra
```

Once installed, you can get the status of the Chart with:

```bash
helm status "cassandra"
```

To uninstall this Chart:

```bash
helm delete  --purge "cassandra"
```

## Persisting Data

In order to persist data you need to create a `StorageClass`.  This allows the chart
to create the required storage automatically on your behalf.

On GCE (Google Container Engine):

```bash
kubectl create -f sample/create-storage-gce.yaml
```

Then set the following values in `values.yaml`

```yaml
persistence:
  enabled: true
```

If you want to create a `StorageClass` on other platform, please see
documentation here
[https://kubernetes.io/docs/user-guide/persistent-volumes/](https://kubernetes.io/docs/user-guide/persistent-volumes/)


## Sizing Cassandra Cluster

This Chart defaults to creating a Cassandra cluster with 3 nodes.  To increase
the cluster size during installation you can use `--set
config.cluster_size={value}`, or edit `values.yaml` and set it there.

Example (Set cluster size to 5):

```bash
helm install --namespace "cassandra" -n "cassandra" --set config.cluster_size=5 incubator/cassandra/
```

## Modifying resource limits

This Chart defaults to creating Cassandra nodes with 2 vCPU's and 4Gi of memory
which is suitable for development environments.  In order to adjust this chart
for realistic production values, we recommend updating CPU resources to 4 vCPUs
and at least 16Gi of memory.

Increasing the size of `max_heap_size` and `heap_new_size` to larger values is
also recommended.  You can edit all of these settings in `values.yaml` or via
the `--set` command.

## Selecting specific nodes

In some clusters you may wish to select specific nodes (such as nodes with fast
SSD storage, or more memory).  You can select nodes by enabling
`nodes.enabled=true` in `values.yaml`.  For example, you have 6 high memory vms
in a node pool and you wish to deploy Cassandra to these nodes, labelled as
`cloud.google.com/gke-nodepool: pool-db`

Set the following values in `values.yaml`

```yaml
nodes:
  enabled: true
  selector:
    nodeSelector:
      cloud.google.com/gke-nodepool: pool-db
```

## Scaling cassandra

To dynamically scale up the size of the Cassandra cluster you can use the helm
upgrade command:

```bash
helm upgrade --set config.cluster_size=5 cassandra incubator/cassandra
```

## Cassandra Status

You can get your Cassandra cluster status by running the command:

```bash
kubectl exec -it --namespace cassandra $(kubectl get pods --namespace cassandra
-l app=cassandra-cassandra -o jsonpath='{.items[0].metadata.name}') nodetool
status
```

Output:

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
You can use
[cassandra-stress](https://docs.datastax.com/en/cassandra/3.0/cassandra/tools/toolsCStress.html)
tool benchmark the cluster with the following command:

```bash
kubectl exec -it --namespace cassandra $(kubectl get pods --namespace cassandra
-l app=cassandra-cassandra -o jsonpath='{.items[0].metadata.name}')
cassandra-stress
```

Here's an example of `cassandra-stress` arguments to:
 - Run both read and write with ration 9:1
 - Operator total 1 million keys with uniform distribution
 - Use QUORUM for read/write
 - Generate 50 threads
 - Generate result in graph
 - Use NetworkTopologyStrategy with replica factor 2

```bash
cassandra-stress mixed ratio\(write=1,read=9\) n=1000000 cl=QUORUM -pop
dist=UNIFORM\(1..1000000\) -mode native cql3 -rate threads=50 -log
file=~/mixed_autorate_r9w1_1M.log -graph file=test2.html title=test
revision=test2 -schema "replication(strategy=NetworkTopologyStrategy,
factor=2)"
```
