# Redis Auto Cluster Helm chart


## Examples values:

#### 6 Gb / 3 shards cluster / 1 slave per master
```yaml
nameOverride: "cluster"
serviceNameOverride: "dev"

shards:
  count: 3
  replicationFactor: 1
  sizeGb: 2

persistence:
  storageClassName: standard-retain

nodePool: development

image:
  repository: redis
  tag: 4.0.7-alpine

config:
  appendOnly: "yes"
  clusterNodeTimeout: 15000
  maxMemoryPolicy: "allkeys-random"
  save:
    save 900 1
    save 300 5
    save 60 10
```

#### 30 Gb / 3 shards cluster / 2 slaves per master
```yaml
nameOverride: "cluster"
serviceNameOverride: "prod"
shards:
  count: 3
  replicationFactor: 2
  sizeGb: 10

persistence:
  storageClassName: ssd-retain

nodePool: production

image:
  repository: redis
  tag: 4.0.8-alpine

config:
  appendOnly: "yes"
  clusterNodeTimeout: 15000
  maxMemoryPolicy: "volatile-lru"
  saveOptions: |
    save 900 1
    save 300 10
    save 60 10000
```

To install it, if you did not disable autoCluster.enabled, you MUST add --wait to helm install:
```bash
helm install --namespace redis-prod -n prod -f prod.yaml --wait incubator/redis-auto-cluster
```
helm upgrade will not try to rebuild the cluster. 


## Important notes

- You must have (.Values.shards.replicationFactor + 1) x .Values.shards.count nodes available
- You must have .Values.shards.sizeGb available on each node

##### Only 1 pod will be allowed per node, in order to keep the cluster highly available.

I would recommend using a dedicated node pool in your cluster and taint the nodes as below:

```bash
kubectl taint node `kubectl get node -l cloud.google.com/gke-nodepool=redis-pool -o name` dedicated=redis-auto-cluster:NoSchedule
kubectl taint node `kubectl get node -l cloud.google.com/gke-nodepool=redis-pool -o name` dedicated=redis-auto-cluster:NoExecute
```

this way, only pods with the same tolerations will be able to run on these nodes.

Just add to your custom values:
```yaml
tolerations:
- key: dedicated
  operator: Equal
  value: "redis-auto-cluster"
  effect: NoSchedule
- key: dedicated
  operator: Equal
  value: redis-auto-cluster
  effect: "NoExecute"

```
