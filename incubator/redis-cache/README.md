## Redis-cache

This chart will allow us to use redis as a pure in-memory cache, this uses a special utility to perform master-slave promotion which overcomes this [problem](https://redis.io/topics/replication#safety-of-replication-when-master-has-persistence-turned-off), K8s could restart the master way before it is detected and agreed among the redis-sentinels.

###Prerequisites
* Kubernetes 1.6+

Install Redis-cache chart as an in-memory cache.
* Uses 7MB [redis:4.0.12-alpine](https://hub.docker.com/r/library/redis/tags/4.0.12-alpine/) image which is extremely light weight
* Uses [redis-sentinel-k8s](https://github.com/dhilipkumars/redis-sentinel-micro/tree/k8s) for automatic slave promotion if master fails, feel free to fork.
* Super fast caching as no persistence involved
* Has Pod Disruption Budget
* Uses Statefulset
* Has Anti-Affinity Configured

Quick Benchmark comparison between redis with and without persistence enabled, as you can notice the writes are at least 3 times slower.

Redis persistence enabled
```
$ k exec -i -t ${REPLICA-NAME} -c redis -- redis-benchmark -q -h ${REPLICA-NAME}.${POD-NAME}.${NAMESPACE} -p 6379 -t set,get -n 100000 -d 100 -r 1000000
SET: 22026.43 requests per second
GET: 76161.46 requests per second
```
Redis without persistence
```
$ k exec -i -t ${REPLICA-NAME} -c redis -- redis-benchmark -q -h ${REPLICA-NAME}.${POD-NAME}.${NAMESPACE} -p 6379 -t set,get -n 100000 -d 100 -r 1000000
SET: 60060.06 requests per second
GET: 89285.71 requests per second
```

Here is a sample demo of master slave promotion.

Install this chart
```
$helm install -n dev incubator/redis-cache/
NAME:   dev
LAST DEPLOYED: Wed Apr 12 23:25:56 2017
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Service
NAME    CLUSTER-IP  EXTERNAL-IP  PORT(S)   AGE
rd-dev  None        <none>       6379/TCP  0s

==> policy/v1beta1/PodDisruptionBudget
NAME    MIN-AVAILABLE  ALLOWED-DISRUPTIONS  AGE
rd-dev  2              0                    0s

==> apps/v1beta1/StatefulSet
NAME    DESIRED  CURRENT  AGE
rd-dev  3        0        0s


NOTES:
1. To Find which replica is the master
  kubectl exec -i -t rd-dev-0 -c redis -- redis-cli -h rd-dev-0.rd-dev.default -p 6379 info replication
```

Wait until the PODs are created and check which replica is the master (by default it creates 3 replicas with 1 master and 2 slaves)
```
$kubectl get pods
NAME                  READY     STATUS    RESTARTS   AGE
rd-dev-0              2/2       Running   0          57s
rd-dev-1              2/2       Running   0          41s
rd-dev-2              2/2       Running   0          29s

$kubectl exec -i -t rd-dev-0 -c redis -- redis-cli -h rd-dev-0.rd-dev.default -p 6379 info replication
# Replication
role:master
connected_slaves:2
slave0:ip=10.244.2.18,port=6379,state=online,offset=29,lag=0
slave1:ip=10.244.1.16,port=6379,state=online,offset=29,lag=0
master_repl_offset:29
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:2
repl_backlog_histlen:28
```

Set a Key
```
$kubectl exec -i -t rd-dev-0 -c redis -- redis-cli -h rd-dev-0.rd-dev.default -p 6379 set foo bar
OK
```

Check if that is replicated in any of the slaves
```
$kubectl exec -i -t rd-dev-0 -c redis -- redis-cli -h rd-dev-2.rd-dev.default -p 6379 get foo
"bar"
```

Kill the master
```
$kubectl delete po/rd-dev-0
pod "rd-dev-0" deleted
```

Wait until the kubernetes restarts rd-dev-0, once this is up you can check sentinel-micro's logs to find out which of the slave is now elected as the new master.
```
$kubectl logs rd-dev-0 sentinel-micro
I0412 18:07:08.633263       1 redis_sentinel_k8s.go:368] Available endpoints are [rd-dev-2.rd-dev.default.svc.cluster.local rd-dev-1.rd-dev.default.svc.cluster.local]
I0412 18:07:08.633392       1 redis_sentinel_k8s.go:194] Processing rd-dev-2.rd-dev.default.svc.cluster.local
I0412 18:07:08.633446       1 redis_sentinel_k8s.go:194] Processing rd-dev-1.rd-dev.default.svc.cluster.local
R=&{ slave -1 7 937 rd-dev-0.rd-dev.default 6379 100 false <nil>}
R=&{ slave -1 7 937 rd-dev-0.rd-dev.default 6379 100 false <nil>}
I0412 18:07:08.645222       1 redis_sentinel_k8s.go:382] OldMaster=<nil> NewMaster=&{rd-dev-1.rd-dev.default:6379 slave -1 7 937 rd-dev-0.rd-dev.default 6379 100 false 0xc42000e300}
I0412 18:07:08.646876       1 redis_sentinel_k8s.go:398] New Master is rd-dev-1.rd-dev.default:6379, All the slaves are re-configured to replicate from this
I0412 18:07:08.647040       1 redis_sentinel_k8s.go:421] Redis-Sentinal-micro Finished
```

As you can see `rd-dev-1` is the new master while `rd-dev-0` and `rd-dev-2` are its slaves
Lets check if our original key `foo` is retained across master restarts
```
$kubectl exec -i -t rd-dev-0 -c redis -- redis-cli -h rd-dev-0.rd-dev.default -p 6379 get foo
"bar"
```

#### Note: Care should be taken when you scale down the number of replicas of this statefulset.  Please make sure that current redis-master is not among _to be scaled down_ replicas.
