# Apache Kafka Helm Chart

This is an implementation of Kafka StatefulSet found here:

 * https://github.com/Yolean/kubernetes-kafka

## Pre Requisites:

* Kubernetes 1.3 with alpha APIs enabled and support for storage classes

* PV support on underlying infrastructure

* Requires at least `v2.0.0-beta.1` version of helm to support
  dependency management with requirements.yaml

## StatefulSet Details

* https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/

## StatefulSet Caveats

* https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#limitations

## Chart Details

This chart will do the following:

* Implement a dynamically scalable kafka cluster using Kubernetes StatefulSets

* Implement a dynamically scalable zookeeper cluster as another Kubernetes StatefulSet required for the Kafka cluster above

* Expose Kafka protocol endpoints via NodePort services (optional)

### Installing the Chart

To install the chart with the release name `my-kafka` in the default
namespace:

```
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-kafka incubator/kafka
```

If using a dedicated namespace(recommended) then make sure the namespace
exists with:

```
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ kubectl create ns kafka
$ helm install --name my-kafka --namespace kafka incubator/kafka
```

This chart includes a ZooKeeper chart as a dependency to the Kafka
cluster in its `requirement.yaml` by default. The chart can be customized using the
following configurable parameters:

| Parameter                                      | Description                                                                                                                                                              | Default                                                            |
|------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------|
| `image`                                        | Kafka Container image name                                                                                                                                               | `confluentinc/cp-kafka`                                            |
| `imageTag`                                     | Kafka Container image tag                                                                                                                                                | `5.0.1`                                                            |
| `imagePullPolicy`                              | Kafka Container pull policy                                                                                                                                              | `IfNotPresent`                                                     |
| `replicas`                                     | Kafka Brokers                                                                                                                                                            | `3`                                                                |
| `component`                                    | Kafka k8s selector key                                                                                                                                                   | `kafka`                                                            |
| `resources`                                    | Kafka resource requests and limits                                                                                                                                       | `{}`                                                               |
| `kafkaHeapOptions`                             | Kafka broker JVM heap options                                                                                                                                            | `-Xmx1G-Xms1G`                                                     |
| `logSubPath`                                   | Subpath under `persistence.mountPath` where kafka logs will be placed.                                                                                                   | `logs`                                                             |
| `schedulerName`                                | Name of Kubernetes scheduler (other than the default)                                                                                                                    | `nil`                                                              |
| `affinity`                                     | Defines affinities and anti-affinities for pods as defined in: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity preferences | `{}`                                                               |
| `tolerations`                                  | List of node tolerations for the pods. https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/                                                           | `[]`                                                               |
| `headless.annotations`                                  | List of annotations for the headless service. https://kubernetes.io/docs/concepts/services-networking/service/#headless-services                                                            | `[]`                                                               |
| `headless.targetPort`                                  | Target port to be used for the headless service. This is not a required value.                                                            | `nil`                                                               |
| `headless.port`                                  | Port to be used for the headless service. https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/                                                           | `9092`                                                               |
| `external.enabled`                             | If True, exposes Kafka brokers via NodePort (PLAINTEXT by default)                                                                                                       | `false`                                                            |
| `external.dns.useInternal`                     | If True, add Annotation for internal DNS service                                                                                                                           | `false`                                                          |
| `external.dns.useExternal`                     | If True, add Annotation for external DNS service                                                                                                                           | `true`                                                           |
| `external.servicePort`                         | TCP port configured at external services (one per pod) to relay from NodePort to the external listener port.                                                             | '19092'                                                            |
| `external.firstListenerPort`                   | TCP port which is added pod index number to arrive at the port used for NodePort and external listener port.                                                             | '31090'                                                            |
| `external.domain`                              | Domain in which to advertise Kafka external listeners.                                                                                                                   | `cluster.local`                                                    |
| `external.init`                                | External init container settings.                                                                                                                                        | (see `values.yaml`)                                                |
| `external.type`                                | Service Type.                                                                                                                                                            | `NodePort`                                                         |
| `external.distinct`                            | Distinct DNS entries for each created A record.                                                                                                                          | `false`                                                            |
| `external.annotations`                         | Additional annotations for the external service.                                                                                                                         | `{}`                                                               |
| `podAnnotations`                               | Annotation to be added to Kafka pods                                                                                                                                     | `{}`                                                               |
| `loadBalancerIP`                               | Add Static IP to the type Load Balancer. Depends on the provider if enabled   | `[]`
| `rbac.enabled`                                 | Enable a service account and role for the init container to use in an RBAC enabled cluster                                                                               | `false`                                                            |
| `envOverrides`                                 | Add additional Environment Variables in the dictionary format                       | `{ zookeeper.sasl.enabled: "False" }`                              |
| `configurationOverrides`                       | `Kafka ` [configuration setting][brokerconfigs] overrides in the dictionary format                                                                                       | `{ offsets.topic.replication.factor: 3 }`                          |
| `secrets` | `{}` | Pass any secrets to the kafka pods. Each secret will be passed as an environment variable by default. The secret can also be mounted to a specific path if required. Environment variable names are generated as: `<secretName>_<secretKey>` (All upper case)|
| `additionalPorts`                              | Additional ports to expose on brokers.  Useful when the image exposes metrics (like prometheus, etc.) through a javaagent instead of a sidecar                           | `{}`                                                               |
| `readinessProbe.initialDelaySeconds`           | Number of seconds before probe is initiated.                                                                                                                             | `30`                                                               |
| `readinessProbe.periodSeconds`                 | How often (in seconds) to perform the probe.                                                                                                                             | `10`                                                               |
| `readinessProbe.timeoutSeconds`                | Number of seconds after which the probe times out.                                                                                                                       | `5`                                                                |
| `readinessProbe.successThreshold`              | Minimum consecutive successes for the probe to be considered successful after having failed.                                                                             | `1`                                                                |
| `readinessProbe.failureThreshold`              | After the probe fails this many times, pod will be marked Unready.                                                                                                       | `3`                                                                |
| `terminationGracePeriodSeconds`                | Wait up to this many seconds for a broker to shut down gracefully, after which it is killed                                                                              | `60`                                                               |
| `updateStrategy`                               | StatefulSet update strategy to use.                                                                                                                                      | `{ type: "OnDelete" }`                                             |
| `podManagementPolicy`                          | Start and stop pods in Parallel or OrderedReady (one-by-one.)  Can not change after first release.                                                                       | `OrderedReady`                                                     |
| `persistence.enabled`                          | Use a PVC to persist data                                                                                                                                                | `true`                                                             |
| `persistence.size`                             | Size of data volume                                                                                                                                                      | `1Gi`                                                              |
| `persistence.mountPath`                        | Mount path of data volume                                                                                                                                                | `/opt/kafka/data`                                                  |
| `persistence.storageClass`                     | Storage class of backing PVC                                                                                                                                             | `nil`                                                              |
| `jmx.configMap.enabled`                        | Enable the default ConfigMap for JMX                                                                                                                                     | `true`                                                             |
| `jmx.configMap.overrideConfig`                 | Allows config file to be generated by passing values to ConfigMap                                                                                                        | `{}`                                                               |
| `jmx.configMap.overrideName`                   | Allows setting the name of the ConfigMap to be used                                                                                                                      | `""`                                                               |
| `jmx.port`                                     | The jmx port which JMX style metrics are exposed (note: these are not scrapeable by Prometheus)                                                                          | `5555`                                                             |
| `jmx.whitelistObjectNames`                     | Allows setting which JMX objects you want to expose to via JMX stats to JMX Exporter                                                                                     | (see `values.yaml`)                                                |
| `prometheus.jmx.resources`                     | Allows setting resource limits for jmx sidecar container                                                                                                                 | `{}`                                                               |
| `prometheus.jmx.enabled`                       | Whether or not to expose JMX metrics to Prometheus                                                                                                                       | `false`                                                            |
| `prometheus.jmx.image`                         | JMX Exporter container image                                                                                                                                             | `solsson/kafka-prometheus-jmx-exporter@sha256`                     |
| `prometheus.jmx.imageTag`                      | JMX Exporter container image tag                                                                                                                                         | `a23062396cd5af1acdf76512632c20ea6be76885dfc20cd9ff40fb23846557e8` |
| `prometheus.jmx.interval`                      | Interval that Prometheus scrapes JMX metrics when using Prometheus Operator                                                                                              | `10s`                                                              |
| `prometheus.jmx.scrapeTimeout`                 | Timeout that Prometheus scrapes JMX metrics when using Prometheus Operator                                                                                              | `10s`                                                              |
| `prometheus.jmx.port`                          | JMX Exporter Port which exposes metrics in Prometheus format for scraping                                                                                                | `5556`                                                             |
| `prometheus.kafka.enabled`                     | Whether or not to create a separate Kafka exporter                                                                                                                       | `false`                                                            |
| `prometheus.kafka.image`                       | Kafka Exporter container image                                                                                                                                           | `danielqsj/kafka-exporter`                                         |
| `prometheus.kafka.imageTag`                    | Kafka Exporter container image tag                                                                                                                                       | `v1.2.0`                                                           |
| `prometheus.kafka.interval`                    | Interval that Prometheus scrapes Kafka metrics when using Prometheus Operator                                                                                            | `10s`                                                              |
| `prometheus.kafka.scrapeTimeout`               | Timeout that Prometheus scrapes Kafka metrics when using Prometheus Operator                                                                                            | `10s`                                                              |
| `prometheus.kafka.port`                        | Kafka Exporter Port which exposes metrics in Prometheus format for scraping                                                                                              | `9308`                                                             |
| `prometheus.kafka.resources`                   | Allows setting resource limits for kafka-exporter pod                                                                                                                    | `{}`                                                               |
| `prometheus.kafka.affinity`                    | Defines affinities and anti-affinities for pods as defined in: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity preferences | `{}`                                                               |
| `prometheus.kafka.tolerations`                 | List of node tolerations for the pods. https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/                                                           | `[]`                                                               |
| `prometheus.operator.enabled`                  | True if using the Prometheus Operator, False if not                                                                                                                      | `false`                                                            |
| `prometheus.operator.serviceMonitor.namespace` | Namespace which Prometheus is running in.  Default to kube-prometheus install.                                                                                           | `monitoring`                                                       |
| `prometheus.operator.serviceMonitor.selector`  | Default to kube-prometheus install (CoreOS recommended), but should be set according to Prometheus install                                                               | `{ prometheus: kube-prometheus }`                                  |
| `configJob.backoffLimit`                       | Number of retries before considering kafka-config job as failed                                                                                                          | `6`                                                                |
| `topics`                                       | List of topics to create & configure. Can specify name, partitions, replicationFactor, reassignPartitions, config. See values.yaml                                       | `[]` (Empty list)                                                  |
| `zookeeper.enabled`                            | If True, installs Zookeeper Chart                                                                                                                                        | `true`                                                             |
| `zookeeper.resources`                          | Zookeeper resource requests and limits                                                                                                                                   | `{}`                                                               |
| `zookeeper.env`                                | Environmental variables provided to Zookeeper Zookeeper                                                                                                                  | `{ZK_HEAP_SIZE: "1G"}`                                             |
| `zookeeper.storage`                            | Zookeeper Persistent volume size                                                                                                                                         | `2Gi`                                                              |
| `zookeeper.image.PullPolicy`                   | Zookeeper Container pull policy                                                                                                                                          | `IfNotPresent`                                                     |
| `zookeeper.url`                                | URL of Zookeeper Cluster (unneeded if installing Zookeeper Chart)                                                                                                        | `""`                                                               |
| `zookeeper.port`                               | Port of Zookeeper Cluster                                                                                                                                                | `2181`                                                             |
| `zookeeper.affinity`                           | Defines affinities and anti-affinities for pods as defined in: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity preferences | `{}`                                                               |


Specify parameters using `--set key=value[,key=value]` argument to `helm install`

Alternatively a YAML file that specifies the values for the parameters can be provided like this:

```bash
$ helm install --name my-kafka -f values.yaml incubator/kafka
```

### Connecting to Kafka from inside Kubernetes

You can connect to Kafka by running a simple pod in the K8s cluster like this with a configuration like this:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: testclient
  namespace: kafka
spec:
  containers:
  - name: kafka
    image: solsson/kafka:0.11.0.0
    command:
      - sh
      - -c
      - "exec tail -f /dev/null"
```

Once you have the testclient pod above running, you can list all kafka
topics with:

` kubectl -n kafka exec -ti testclient -- ./bin/kafka-topics.sh --zookeeper
my-release-zookeeper:2181 --list`

Where `my-release` is the name of your helm release.

## Extensions

Kafka has a rich ecosystem, with lots of tools. This sections is intended to compile all of those tools for which a corresponding Helm chart has already been created.

- [Schema-registry](https://github.com/kubernetes/charts/tree/master/incubator/schema-registry) -  A confluent project that provides a serving layer for your metadata. It provides a RESTful interface for storing and retrieving Avro schemas.

### Connecting to Kafka from outside Kubernetes

#### Node Port External Service Type

Review and optionally override to enable the example text concerned with external access in `values.yaml`.

Once configured, you should be able to reach Kafka via NodePorts, one per replica. In kops where private,
topology is enabled, this feature publishes an internal round-robin DNS record using the following naming
scheme. The external access feature of this chart was tested with kops on AWS using flannel networking.
If you wish to enable external access to Kafka running in kops, your security groups will likely need to
be adjusted to allow non-Kubernetes nodes (e.g. bastion) to access the Kafka external listener port range.

```
{{ .Release.Name }}.{{ .Values.external.domain }}
```

If `external.distinct` is set theses entries will be prefixed with the replica number or broker id.

```
{{ .Release.Name }}-<BROKER_ID>.{{ .Values.external.domain }}
```

Port numbers for external access used at container and NodePort are unique to each container in the StatefulSet.
Using the default `external.firstListenerPort` number with a `replicas` value of `3`, the following
container and NodePorts will be opened for external access: `31090`, `31091`, `31092`. All of these ports should
be reachable from any host to NodePorts are exposed because Kubernetes routes each NodePort from entry node
to pod/container listening on the same port (e.g. `31091`).

The `external.servicePort` at each external access service (one such service per pod) is a relay toward
the a `containerPort` with a number matching its respective `NodePort`. The range of NodePorts is set, but
should not actually listen, on all Kafka pods in the StatefulSet. As any given pod will listen only one
such port at a time, setting the range at every Kafka pod is a reasonably safe configuration.

#### Load Balancer External Service Type

The load balancer external service type differs from the node port type by routing to the `external.servicePort` specified in the service for each statefulset container (if `external.distinct` is set). If `external.distinct` is false, `external.servicePort` is unused and will be set to the sum of `external.firstListenerPort` and the replica number.  It is important to note that `external.firstListenerPort` does not have to be within the configured node port range for the cluster, however a node port will be allocated.

## Known Limitations

* Only supports storage options that have backends for persistent volume claims (tested mostly on AWS)
* KAFKA_PORT will be created as an envvar and brokers will fail to start when there is a service named `kafka` in the same namespace. We work around this be unsetting that envvar `unset KAFKA_PORT`.

[brokerconfigs]: https://kafka.apache.org/documentation/#brokerconfigs

## Prometheus Stats

### Prometheus vs Prometheus Operator

Standard Prometheus is the default monitoring option for this chart. This chart also supports the CoreOS Prometheus Operator,
which can provide additional functionality like automatically updating Prometheus and Alert Manager configuration. If you are
interested in installing the Prometheus Operator please see the [CoreOS repository](https://github.com/coreos/prometheus-operator/tree/master/helm) for more information or
read through the [CoreOS blog post introducing the Prometheus Operator](https://coreos.com/blog/the-prometheus-operator.html)

### JMX Exporter

The majority of Kafka statistics are provided via JMX and are exposed via the [Prometheus JMX Exporter](https://github.com/prometheus/jmx_exporter).

The JMX Exporter is a general purpose prometheus provider which is intended for use with any Java application. Because of this, it produces a number of statistics which
may not be of interest. To help in reducing these statistics to their relevant components we have created a curated whitelist `whitelistObjectNames` for the JMX exporter.
This whitelist may be modified or removed via the values configuration.

To accommodate compatibility with the Prometheus metrics, this chart performs transformations of raw JMX metrics. For example, broker names and topics names are incorporated
into the metric name instead of becoming a label. If you are curious to learn more about any default transformations to the chart metrics, please have reference the [configmap template](https://github.com/kubernetes/charts/blob/master/incubator/kafka/templates/jmx-configmap.yaml).

### Kafka Exporter

The [Kafka Exporter](https://github.com/danielqsj/kafka_exporter) is a complementary metrics exporter to the JMX Exporter. The Kafka Exporter provides additional statistics on Kafka Consumer Groups.
