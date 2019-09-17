# Schema-Registry Helm Chart
This helm chart creates a [Confluent Schema-Registry server](https://github.com/confluentinc/schema-registry).

## Prerequisites
* Kubernetes 1.6
* A running Kafka Installation
* A running Zookeeper Installation

## Chart Components
This chart will do the following:

* Create a Schema-Registry deployment
* Create a Service configured to connect to the available Schema-Registry pods on the configured
  client port.

Note: Distributed Schema Registry Master Election is done via Kafka Coordinator Master Election
https://docs.confluent.io/current/schema-registry/docs/design.html#kafka-coordinator-master-election

## Installing the Chart
You can install the chart with the release name `mysr` as below.

```console
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name mysr incubator/schema-registry
```

If you do not specify a name, helm will select a name for you.

### Installed Components
You can use `kubectl get` to view all of the installed components.

```console{%raw}
$ kubectl get all -l app=schema-registry
NAME                          DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/mysr-schema-registry   1         1         1            1           23m

NAME                                DESIRED   CURRENT   READY     AGE
rs/mysr-schema-registry-bcb4c994c   1         1         1         23m

NAME                                      READY     STATUS    RESTARTS   AGE
po/mysr-schema-registry-bcb4c994c-qjqbj   1/1       Running   1          23m
```

1. `deploy/mysr-schema-registry` is the Deployment created by this chart.
1. `rs/mysr-schema-registry-bcb4c994c` is the ReplicaSet created by this Chart's Deployment.
1. `po/mysr-schema-registry-bcb4c994c-qjqbj` is the Pod created by the ReplicaSet under this Chart's Deployment.

## Configuration
You can specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml incubator/schema-registry
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Parameters
The following table lists the configurable parameters of the SchemaRegistry chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `image` | The `SchemaRegistry` image repository | `confluentinc/cp-schema-registry` |
| `imageTag` | The `SchemaRegistry` image tag | `5.0.1` |
| `imagePullPolicy` | Image Pull Policy | `IfNotPresent` |
| `replicaCount` | The number of `SchemaRegistry` Pods in the Deployment | `1` |
| `configurationOverrides` | `SchemaRegistry` [configuration setting](https://github.com/confluentinc/schema-registry/blob/master/docs/config.rst#configuration-options) overrides in the dictionary format `setting.name: value` | `{}` |
| `podAnnotations` | Pod annotations. | ` ` |
| `kafkaOpts` | Additional Java arguments to pass to Kafka. | ` ` |
| `sasl.configPath` | where to store config for sasl configurations | `/etc/kafka-config` |
| `sasl.scram.enabled` | whether sasl-scam is enabled | `false` |
| `sasl.scram.init.image` | which image to use for initializing sasl scram | `confluentinc/cp-schema-registry` |
| `sasl.scram.init.imageTag` | which version/tag to use for sasl scram init | `5.0.1` |
| `sasl.scram.init.imagePullPolicy` | the sasl scram init pull policy | `IfNotPresent` |
| `sasl.scram.clientUser` | the sasl scram user to use to authenticate to kafka | `kafka-client` |
| `sasl.scram.clientPassword` | the sasl scram password to use to authenticate to kafka | `kafka-password` |
| `sasl.scram.zookeeperClientUser` | the sasl scram user to use to authenticate to zookeeper | `zookeeper-client` |
| `sasl.scram.zookeeperClientPassword` | the sasl scram password to use to authenticate to zookeeper | `zookeeper-password` |
| `resources` | CPU/Memory resource requests/limits | `{}` |
| `servicePort` | The port on which the SchemaRegistry server will be exposed. | `8081` |
| `service.annotations` | Additional annotations for the service | `{}` |
| `service.labels` | Additional labels for the service | `{}` |
| `overrideGroupId` | Group ID defaults to using Release Name so each release is its own Schema Registry worker group, it can be overridden | `{- .Release.Name -}}` |
| `kafkaStore.overrideBootstrapServers` | Defaults to Kafka Servers in the same release, it can be overridden in case there was a separate release for Kafka Deploy | `{{- printf "PLAINTEXT://%s-kafka-headless:9092" .Release.Name }}`
| `kafka.enabled` | If `true`, install Kafka/Zookeeper alongside the `SchemaRegistry`. This is intended for testing and argument-less helm installs of this chart only and should not be used in Production. | `true` |
| `kafka.replicas` | The number of Kafka Pods to install as part of the `StatefulSet` if `kafka.Enabled` is `true`| `1` |
| `kafka.configurationOverrides` | Any Kafka Configuration overrides to provide to the underlying kafka chart | `{offsets.topic.replica.factor: 1}` |
| `kafka.zookeeper.servers` | The number of Zookeeper Pods to install as part of the `StatefulSet` if `kafka.Enabled` is `true`| `1` |
| `ingress.enabled` | Enable Ingress? | `false` |
| `ingress.hostname` | set hostname for ingress | `""` |
| `ingress.annotations` | set annotations for ingress | `{}` |
| `ingress.labels` | Additional labels for the ingress | `{}` |
| `ingress.tls.enabled` | Enable TLS for the Ingress | `false` |
| `ingress.tls.secretName` | Name of the Kubernetes `Secret` object to obtain the TLS certificate from | `schema-registry-tls` |
| `external.enabled` | Enable LoadBalancer/Nodeport for Cloud Provider external load balancers | `false` |
| `external.type` | set service type LoadBalancer/NodePort  | `LoadBalancer` |
| `external.servicePort` | set service port | `443` |
| `external.loadBalancerIP` | set Static IP for LoadBalancer | `""` |
| `external.nodePort` | set Nodeport (valid range depends on CLoud Provider) | `""` |
| `jmx.enabled` | Enable JMX? | `true` |
| `jmx.port` | set JMX port | `5555` |
| `prometheus.jmx.enabled` | Enable Prometheus JMX Exporter | `false` |
| `prometheus.jmx.image` | Set Prometheus JMX Exporter image | `solsson/kafka-prometheus-jmx-exporter@sha256` |
| `prometheus.jmx.imageTag` | Set Prometheus JMX Exporter image tag | `6f82e2b0464f50da8104acd7363fb9b995001ddff77d248379f8788e78946143` |
| `prometheus.jmx.port` | Set Prometheus JMX Exporter port | `5556` |
| `prometheus.jmx.resources` | Set Prometheus JMX Exporter resource requests & limits | `{}` |
| `secrets` | Pass any secrets to the pods.The secret will be mounted to a specific path if required | `[]` |
