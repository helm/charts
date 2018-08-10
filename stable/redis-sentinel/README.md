# Redis Sentinel

This chart provide the [Redis Sentinel](https://redis.io/topics/sentinel) deployments.
Redis Sentinel consists of Sentinel nodes, Master node and Slave nodes

Note: It is strongly recommend to use on Official Redis image to run this chart.

## Install Chart
To install the Redis Sentinel Chart into your Kubernetes cluster (This Chart requires persistent volume by default, you may need to create a storage class before install chart.

```bash
helm install -n "redis-sentinel" stable/redis-sentinel
```

After installation succeeds, you can get a status of Chart

```bash
helm status "redis-sentinel"
```

If you want to delete your Chart, use this command
```bash
helm delete --purge "redis-sentinel"
```

If you want to test your Deployment, use this command
```bash
helm test --cleanup "redis-sentinel"
```

## Install Chart with specific Redis cluster size
By default, this Chart will create a redis with 3 nodes (1 master and 2 slaves). If you want to change the cluster size during installation, you can use `--set servers.replicas={value}` argument. Or edit `values.yaml`

For example:
Set cluster size to 5

```bash
helm install --namespace "redis-sentinel" -n "redis-sentinel" --set servers.replicas=5 stable/redis-sentinel
```

## Install Chart with specific node pool
Sometime you may need to deploy your Redis to specific node pool to allocate resources. 
For example, you have 6 vms in node pools and you want to deploy Redis to node which labeled as `cloud.google.com/gke-nodepool: redis-pool`

Set the following values in `values.yaml`

```yaml
servers:
   nodeSelector: { cloud.google.com/gke-nodepool: redis-pool }
```

You may also use anti-affinity pattern to distribute pod to nodes for example, "hard" will deploy pod on each node and "soft" will allow multiple pods to deploy on same node

Set the following values in `values.yaml` for "soft"

```yaml
servers:
   antiAffinity: "soft"
```

## Configuration

The following table lists the configurable parameters of the Cassandra chart and their default values.

| Parameter                                | Description                                            | Default                                     |
|------------------------------------------|--------------------------------------------------------|---------------------------------------------|
| `image     `                             | `redis` image repository                               | `redis:4.0.10-alpine`                       |
| `imagePullPolicy`                        | Image pull policy                                      | `IfNotPresent`                              |
| `redisPassword`                          | Redis password (ignored if `auth` set)                 | Randomly generated                          |
| `rbac.create`                            | Specifies whether RBAC resources should be created     | `true`                                      |
| `serviceAccount.create`                  | Specifies whether a ServiceAccount should be created   | `true`                                      |
| `serviceAccount.name`                    | The name of the ServiceAccount to use.                 | nil                                         |
| `servers.name`                           | The name of the redis server suffix.                   | `server`                                    |
| `servers.replicas`                       | The number of redis instances in the cluster.          | `3`                                         |
| `servers.resources`                      | CPU/Memory resource requests/limits                    | Memory: `200Mi`, CPU: `100m`                |
| `servers.nodeSelector`                   | Redis server pod assignment                            | `{}`                                        |
| `servers.antiAffinity`                   | Redis server anti affinity                             | `soft`                                      |
| `servers.serviceType`                    | Kubernetes Service type                                | `ClusterIP`                                 |
| `servers.masterAnnotations`              | Kubernetes Master Service annotations                  | `{}`                                        |
| `servers.slaveAnnotations`               | Kubernetes Slave Service annotations                   | `{}`                                        |
| `servers.podAnnotations`                 | Kubernetes Pod annotations                             | `{}`                                        |
| `servers.terminationGracePeriodSeconds`  | Pod termination grace period                           | `300`                                       |
| `servers.updateStrategy`                 | Update Strategy of the StatefulSet                     | `OnDelete`                                  |
| `servers.persistence.enabled`            | Use a PVC to persist data                              | `true`                                      |
| `servers.persistence.storageClass`       | Storage class of backing PVC                           | `nil` (uses alpha storage class annotation) |
| `servers.persistence.accessMode`         | Use volume as ReadOnly or ReadWrite                    | `ReadWriteOnce`                             |
| `servers.persistence.size`               | Size of data volume                                    | `10Gi`                                      |
| `sentinel.name`                          | The name of the redis server suffix.                   | `sentinel`                                  |
| `sentinel.replicas`                      | The number of redis sentinel instances in the cluster. | `3`                                         |
| `sentinel.resources`                     | CPU/Memory resource requests/limits                    | Memory: `200Mi`, CPU: `100m`                |
| `sentinel.nodeSelector`                  | Redis server pod assignment                            | `{}`                                        |
| `sentinel.antiAffinity`                  | Redis server anti affinity                             | `soft`                                      |
| `sentinel.serviceType`                   | Kubernetes Service type                                | `ClusterIP`                                 |
| `sentinel.masterAnnotations`             | Kubernetes Master Service annotations                  | `{}`                                        |
| `sentinel.slaveAnnotations`              | Kubernetes Slave Service annotations                   | `{}`                                        |
| `sentinel.podAnnotations`                | Kubernetes Pod annotations                             | `{}`                                        |
| `sentinel.terminationGracePeriodSeconds` | Pod termination grace period                           | `300`                                       |
| `sentinel.updateStrategy`                | Update Strategy of the StatefulSet                     | `OnDelete`                                  |
| `sentinel.persistence.enabled`           | Use a PVC to persist data                              | `true`                                      |
| `sentinel.persistence.storageClass`      | Storage class of backing PVC                           | `nil` (uses alpha storage class annotation) |
| `sentinel.persistence.accessMode`        | Use volume as ReadOnly or ReadWrite                    | `ReadWriteOnce`                             |
| `sentinel.persistence.size`              | Size of data volume                                    | `10Gi`                                      |

## How it works
This chart will create two statefulset for Sentinel servers and Redis servers. When Redis server is started, the script will detect current available master server from Pod label `redis-role=master`. If no pod found, the server will be started on Master mode. Otherwise it will be started on Salve mode.

The Sentinel server will be started with automatic `quorum` and `parallel-syncs` setting. For example: 
   * If `sentinel.replicas` value is 3, the `quorum` value will be `2`, and `parallel-syncs` will be `1`. 
   * If `sentinel.replicas` value is 6, the `quorum` value will be `4`, and `parallel-syncs` will be `3`. 

The Sentinel servers will monitor current Master server status, if they unable to connect to the Master server, it will promote current Slave to the new Master and also re-label slave pod with `redis-role=master`

## Get Redis Sentinel status
You can get your Redis Sentinel status by running the command

```
kubectl get po -L redis-role
```

Output
```
NAME                        READY     STATUS    RESTARTS   AGE       REDIS-ROLE
redis-sentinel-sentinel-0   1/1       Running   0          43m       sentinel
redis-sentinel-sentinel-1   1/1       Running   0          42m       sentinel
redis-sentinel-sentinel-2   1/1       Running   0          42m       sentinel
redis-sentinel-server-0     1/1       Running   0          43m       master
redis-sentinel-server-1     1/1       Running   0          43m       slave
redis-sentinel-server-2     1/1       Running   0          42m       slave
```

## Sentinel clients
Many Redis Sentinel client requires sentinel URLs on sentinels parameter. And master name is required. 
This chart will automatic use master service as the master name. So you can easily replace master name parameter with master endpoint.
This is very convenient especially on Ruby client.

Ruby (redis-rb)
```ruby
  $redis = Redis.new(
    url: "redis://redis-sentinel-master.redis-sentinel.svc.cluster.local", 
    sentinels: [
      { host: "redis-sentinel-sentinel.redis-sentinel.svc.cluster.local", port: 26379 }
    ], 
    role: :master
  )
```

Java (Redisson)
```java
  Config config = new Config();
  config.useSentinelServers()
      .setMasterName("redis-sentinel-master.redis-sentinel.svc.cluster.local")
      .addSentinelAddress("redis://redis-sentinel-sentinel.redis-sentinel.svc.cluster.local:26379");
  RedissonClient redisson = Redisson.create(config);
```

Go (go-redis)
```go
  var client *redis.Client
  client = redis.NewFailoverClient(&redis.FailoverOptions{
    MasterName:    "redis-sentinel-master.redis-sentinel.svc.cluster.local",
    SentinelAddrs: []string{"redis://redis-sentinel-sentinel.redis-sentinel.svc.cluster.local:26379"},
  })
```