# Locust Helm Chart

This is a templated deployment of [Locust](locust.io) for Distributed Load 
testing using Kubernetes.

## Pre Requisites:

* Requires (and tested with) helm `v2.1.2` or above.

## Chart details

This chart will do the following:

* Convert all files in `tasks/` folder into a configmap
* Create a Locust master and Locust worker deployment with the Target host
  and Tasks file specified.
 

### Installing the chart

To install the chart with the release name `locust-nymph` in the default namespace:

```bash
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm install -n locust-nymph --set master.config.target-host=http://site.example.com incubator/locust
```

| Parameter                    | Description                        | Default                                               |
| ---------------------------- | ---------------------------------- | ----------------------------------------------------- |
| `Name`                       | Locust master name                 | `locust`                                              |
| `image.repository`           | Locust container image name        | `quay.io/honestbee/locust`                            |
| `image.tag`                  | Locust Container image tag         | `0.7.5`                                               |
| `service.type`               | k8s service type exposing master   | `NodePort`                                            |
| `service.nodePort`           | Port on cluster to expose master   | `0`                                                   |
| `master.config.target-host`  | locust target host                 | `http://site.example.com`                             |
| `worker.config.locust-script`| locust script to run               | `/locust-tasks/tasks.py`                              |
| `worker.replicaCount`        | Number of workers to run           | `2`                                                   |

Specify parameters using `--set key=value[,key=value]` argument to `helm install`

Alternatively a YAML file that specifies the values for the parameters can be provided like this:

```bash
$ helm install --name my-release -f values.yaml incubator/locust
```

You can start the swarm from the command line using Port forwarding as follows:

```bash
export release=my-release
master=`kubectl get po -l app=$release-locust,component=master -o name | head -n 1`
kubectl port-forward ${master:4} 8089 &
```

Now start / stop swarm via web panel or command line:

Start:
```bash
curl -XPOST http://127.0.0.1:8089/swarm -d"locust_count=100&hatch_rate=10"
```

Monitor:
```bash
watch -n 1 "curl -s http://127.0.0.1:8089/stats/requests | jq -r '[.user_count, .total_rps, .state] | @tsv'"
```

Stop:
```bash
curl http://127.0.0.1:8089/stop
```

