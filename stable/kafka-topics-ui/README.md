# Kafka Topics UI Helm Chart
This helm chart creates a [Kafka-Topics-UI server](https://github.com/Landoop/kafka-topics-ui).

This is a web tool for the confluentinc/kafka-rest proxy in order to browse Kafka topics and understand what's happening on your cluster. Find topics / view topic metadata / browse topic data (kafka messages) / view topic configuration / download data.


## Prerequisites
* Kubernetes 1.8
* A running Kafka Installation
* A running Zookeeper Installation
* A running Kafka REST Proxy installation

## Chart Components
This chart will do the following:

* Create a Kafka-Topics-UI deployment
* Create a Service configured to connect to the available Kafka-Topics-UI pods on the configured
  client port.

## Installing the Chart
You can install the chart with the release name `ktopics-ui` as below.

```console
$ helm install --name ktopics-ui kafka-topics-ui
```

If you do not specify a name, helm will select a name for you.

```console{%raw}
$ kubectl get all -l app=kafka-topics-ui
NAME                          DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/ktopics-ui-kafka-topics-ui   1         1         1            1           23m

NAME                                DESIRED   CURRENT   READY     AGE
rs/ktopics-ui-kafka-topics-ui-bcb4c994c   1         1         1         23m

NAME                                      READY     STATUS    RESTARTS   AGE
po/ktopics-ui-kafka-topics-ui-bcb4c994c-qjqbj   1/1       Running   1          23m
```

1. `deploy/ktopics-ui-kafka-topics-ui` is the Deployment created by this chart.
1. `rs/ktopics-ui-kafka-topics-ui-bcb4c994c` is the ReplicaSet created by this Chart's Deployment.
1. `po/ktopics-ui-kafka-topics-ui-bcb4c994c-qjqbj` is the Pod created by the ReplicaSet under this Chart's Deployment.

## Configuration
You can specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml kafka-topics-ui
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Parameters
The following table lists the configurable parameters of the KafkaTopicsUI chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `replicaCount` | The number of `KafkaTopicsUI` Pods in the Deployment | `1` |
| `image.repository` | The `KafkaTopicsUI` image repository | `landoop/kafka-topics-ui` |
| `image.tag` | The `KafkaTopicsUI` image tag | `0.9.4` |
| `image.imagePullPolicy` | Image Pull Policy | `IfNotPresent` |
| `kafkaRest.url` | URL to the kafka rest endpoint | `http://localhost` |
| `kafkaRest.port` | Port for the kafka rest | `8082` |
| `kafkaRest.proxy` | Whether to proxy Kafka REST endpoint via the internal webserver | `false` |
| `service.type` | Type of the service | `LoadBalancer` |
| `service.port` | Port to use | `80` |
| `service.annotations` | Kubernetes service annotations | `{}` |
| `service.loadBalancerSourceRanges` | Limit load balancer source IPs to list of CIDRs (where available)) | None |
| `ingress.enabled` | Ingress rules. Disabled by default | `false` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.path` | Ingress path | `/` |
| `ingress.hosts` | Ingress accepted hostnames | `[kafka-topics-ui.local]` |
| `ingress.tls` | Ingress TLS configuration | `/` |
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `tolerations` | List of node taints to tolerate | `[]` |
| `affinity` | Node/pod affinities | `{}` |
| `resources` | CPU/Memory resource requests/limits | `{}` |
