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

## Upgrading

To upgrade your Cassandra release, simply run

```bash
helm upgrade "cassandra" incubator/cassandra
```

### 0.12.0

This version fixes https://github.com/helm/charts/issues/7803 by removing mutable labels in `spec.VolumeClaimTemplate.metadata.labels` so that it is upgradable.

Until this version, in order to upgrade, you have to delete the Cassandra StatefulSet before upgrading:
```bash
$ kubectl delete statefulset --cascade=false my-cassandra-release
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

When running a cluster without persistence, the termination of a pod will first initiate a decommissioning of that pod.
Depending on the amount of data stored inside the cluster this may take a while. In order to complete a graceful
termination, pods need to get more time for it. Set the following values in `values.yaml`:

```yaml
podSettings:
  terminationGracePeriodSeconds: 1800
```

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

The following table lists the configurable parameters of the Cassandra chart and their default values.

| Parameter                  | Description                                     | Default                                                    |
| -----------------------    | ---------------------------------------------   | ---------------------------------------------------------- |
| `image.repo`                         | `cassandra` image repository                    | `cassandra`                                                |
| `image.tag`                          | `cassandra` image tag                           | `3.11.3`                                                   |
| `image.pullPolicy`                   | Image pull policy                               | `Always` if `imageTag` is `latest`, else `IfNotPresent`    |
| `image.pullSecrets`                  | Image pull secrets                              | `nil`                                                      |
| `config.cluster_domain`              | The name of the cluster domain.                 | `cluster.local`                                            |
| `config.cluster_name`                | The name of the cluster.                        | `cassandra`                                                |
| `config.cluster_size`                | The number of nodes in the cluster.             | `3`                                                        |
| `config.seed_size`                   | The number of seed nodes used to bootstrap new clients joining the cluster.                            | `2` |
| `config.seeds`                       | The comma-separated list of seed nodes.         | Automatically generated according to `.Release.Name` and `config.seed_size` |
| `config.num_tokens`                  | Initdb Arguments                                | `256`                                                      |
| `config.dc_name`                     | Initdb Arguments                                | `DC1`                                                      |
| `config.rack_name`                   | Initdb Arguments                                | `RAC1`                                                     |
| `config.endpoint_snitch`             | Initdb Arguments                                | `SimpleSnitch`                                             |
| `config.max_heap_size`               | Initdb Arguments                                | `2048M`                                                    |
| `config.heap_new_size`               | Initdb Arguments                                | `512M`                                                     |
| `config.ports.cql`                   | Initdb Arguments                                | `9042`                                                     |
| `config.ports.thrift`                | Initdb Arguments                                | `9160`                                                     |
| `config.ports.agent`                 | The port of the JVM Agent (if any)              | `nil`                                                      |
| `config.start_rpc`                   | Initdb Arguments                                | `false`                                                    |
| `configOverrides`                    | Overrides config files in /etc/cassandra dir    | `{}`                                                       |
| `commandOverrides`                   | Overrides default docker command                | `[]`                                                       |
| `argsOverrides`                      | Overrides default docker args                   | `[]`                                                       |
| `env`                                | Custom env variables                            | `{}`                                                       |
| `schedulerName`                      | Name of k8s scheduler (other than the default)  | `nil`                                                      |
| `persistence.enabled`                | Use a PVC to persist data                       | `true`                                                     |
| `persistence.storageClass`           | Storage class of backing PVC                    | `nil` (uses alpha storage class annotation)                |
| `persistence.accessMode`             | Use volume as ReadOnly or ReadWrite             | `ReadWriteOnce`                                            |
| `persistence.size`                   | Size of data volume                             | `10Gi`                                                     |
| `resources`                          | CPU/Memory resource requests/limits             | Memory: `4Gi`, CPU: `2`                                    |
| `service.type`                       | k8s service type exposing ports, e.g. `NodePort`| `ClusterIP`                                                |
| `podManagementPolicy`                | podManagementPolicy of the StatefulSet          | `OrderedReady`                                             |
| `podDisruptionBudget`                | Pod distruption budget                          | `{}`                                                       |
| `podAnnotations`                     | pod annotations for the StatefulSet             | `{}`                                                       |
| `updateStrategy.type`                | UpdateStrategy of the StatefulSet               | `OnDelete`                                                 |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated        | `90`                                                       |
| `livenessProbe.periodSeconds`        | How often to perform the probe                  | `30`                                                       |
| `livenessProbe.timeoutSeconds`       | When the probe times out                        | `5`                                                        |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed.           | `1` |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.             | `3` |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated       | `90`                                                       |
| `readinessProbe.periodSeconds`       | How often to perform the probe                  | `30`                                                       |
| `readinessProbe.timeoutSeconds`      | When the probe times out                        | `5`                                                        |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed.           | `1` |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.             | `3` |
| `readinessProbe.address`             | Address to use for checking node has joined the cluster and is ready.                          | `${POD_IP}` |
| `rbac.create`                        | Specifies whether RBAC resources should be created                                                  | `true` |
| `serviceAccount.create`              | Specifies whether a ServiceAccount should be created                                                | `true` |
| `serviceAccount.name`                | The name of the ServiceAccount to use           |                                                            |
| `backup.enabled`                     | Enable backup on chart installation             | `false`                                                    |
| `backup.schedule`                    | Keyspaces to backup, each with cron time        |                                                            |
| `backup.annotations`                 | Backup pod annotations                          | iam.amazonaws.com/role: `cain`                             |
| `backup.image.repository`            | Backup image repository                         | `maorfr/cain`                                              |
| `backup.image.tag`                   | Backup image tag                                | `0.6.0`                                                    |
| `backup.extraArgs`                   | Additional arguments for cain                   | `[]`                                                       |
| `backup.env`                         | Backup environment variables                    | AWS_REGION: `us-east-1`                                    |
| `backup.resources`                   | Backup CPU/Memory resource requests/limits      | Memory: `1Gi`, CPU: `1`                                    |
| `backup.destination`                 | Destination to store backup artifacts           | `s3://bucket/cassandra`                                    |
| `backup.google.serviceAccountSecret` | Secret containing credentials if GCS is used as destination |                                                |
| `exporter.enabled`                   | Enable Cassandra exporter                       | `false`                                                    |
| `exporter.image.repo`                | Exporter image repository                       | `criteord/cassandra_exporter`                              |
| `exporter.image.tag`                 | Exporter image tag                              | `2.0.2`                                                    |
| `exporter.port`                      | Exporter port                                   | `5556`                                                     |
| `exporter.jvmOpts`                   | Exporter additional JVM options                 |                                                            |
| `exporter.resources`                 | Exporter CPU/Memory resource requests/limits    | `{}`                                                       |
| `affinity`                           | Kubernetes node affinity                        | `{}`                                                       |
| `tolerations`                        | Kubernetes node tolerations                     | `[]`                                                       |


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
