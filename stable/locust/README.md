# Locust Helm Chart

This is a templated deployment of [Locust](http://locust.io) for Distributed Load
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
helm install -n locust-nymph --set master.config.target-host=http://site.example.com stable/locust
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
$ helm install --name my-release -f values.yaml stable/locust
```

You can start the swarm from the command line using Port forwarding as follows:

Get the Locust URL following the Post Installation notes.

for example:
```bash
export LOCUST_URL=http://127.0.0.1:8089
```

Start / Monitor & Stop the Locust swarm via the web panel or with following commands:

Start:
```bash
curl -XPOST $LOCUST_URL/swarm -d"locust_count=100&hatch_rate=10"
```

Monitor:
```bash
watch -n 1 "curl -s $LOCUST_URL/stats/requests | jq -r '[.user_count, .total_rps, .state] | @tsv'"
```

Stop:
```bash
curl $LOCUST_URL/stop
```
