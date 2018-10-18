# metricbeat Helm Chart


* Installs https://www.elastic.co/guide/en/beats/metricbeat/current/running-on-kubernetes.html

## Dependencies
This chart assumes the following:
* Each host has port 10255 open on kubelet 
* kube-state-metrics is deployed in `kube-system` [HERE](https://github.com/helm/charts/tree/master/stable/kube-state-metrics)
* Elasticsearch cluster deployed somewhere (Controlled by `env.ELASTICSEARCH_HOST`) [HERE](https://github.com/helm/charts/tree/master/incubator/elasticsearch)

## Install the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install incubator/metricbeat
```
## General Details

This Chart creates a `daemonset` that will track per host metrics such as filesystem,system, and local kubernetes stats

Also a `deployment` is created that communicates with kube-state-metrics that is assumed to be running in `kube-system` namespace

## Configuration

| Parameter                             | Description                                             | Default                                     |
|---------------------------------------|---------------------------------------------------------|---------------------------------------------|
| `image`                    | The image to pull                       | docker.elastic.co/beats/metricbeat:6.3.1           |
| `env.ELASTICSEARCH_HOST`                    | Sets Elasticsearch Host through environment variable                       | elasticsearch-client           |
| `env.ELASTICSEARCH_PORT`                    | Sets Elasticsearch Port through environment variable                       | 9200           |
| `env.ELASTICSEARCH_USERNAME`                    | Sets Elasticsearch Username through environment variable( only required to change if security configured on cluster )                       | elastic           |
| `env.ELASTICSEARCH_PASSWORD`                    | Sets Elasticsearch Password through environment variable( only required to change if security configured on cluster )                       | changeme           |
| `env.ELASTIC_CLOUD_ID`                    | Sets Elastic Cloud ID environment variable                       | null           |
| `env.ELASTIC_CLOUD_AUTH`                    | Sets Elastic Cloud AUTH environment variable                       | null           |
| `resources.limits.memory`                    | Set Memory Limits                       | 200Mi           |
| `resources.requests.memory`                    | Set Memory Requests                       | 100Mi           |
| `resources.requests.cpu`                    | Set CPU Requests                       | 100m           |
| `hostpath`                    | Define HostPath for Daemonset                       | `/var/lib/metricbeat`           |
| `config.reload.enabled`                    | Setting to autoreload config changes                       | false           |
| `daemonset.data.system.periods`                    | How often for daemonset to send system data                       | 10s           |
| `daemonset.data.system.metricssets`                    | List of metrics from the system module                       |         cpu,load,memory,network,process,process_summary,#core,#diskio,#socket          |
| `daemonset.data.filesystem.period`                    | How often for daemonset to send filesystem data                       | 1m           |
| `daemonset.data.filesystem.metricssets`                    | List of metrics from the filesystem module                       | filesystem,fsstat           |
| `daemonset.data.kubernetes.period`                    | How often for daemonset to send kubernetes data                       | 10s           |
| `daemonset.data.kubernetes.metricssets`                    | List of metrics from the kubernetes module                       | node,system,pod,container,volume           |
| `daemonset.data.kubernetes.hosts`                    | List of hosts to monitor by kubernetes module                       | '["localhost:10255"]'           |
| `deployment.data.kubernetes.metricsets`                    | List of metrics to monitor by kubernetes module                       | state_node,state_deployment,state_replicaset,state_container,state_pod,#event          |
| `deployment.data.kubernetes.hosts`                    | List of hosts to monitor by kubernetes module                       | '["kube-state-metrics.kube-system:8080"]'          |
| `deployment.data.kubernetes.period`                    | How often for deployment to send kubernetes data                       | 10s           |


