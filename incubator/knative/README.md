# Knative

This chart installs Knative components for Build, Serving, Eventing and Eventing-Sources.

## Introduction

- Visit [Knative Build](https://github.com/knative/build/blob/master/README.md) for more information about Build.
- Visit [Knative Eventing](https://github.com/knative/eventing/blob/master/README.md) for more information about Eventing.
- Visit [Knative Eventing Sources](https://github.com/knative/eventing-sources/blob/master/README.md) for more information about Eventing Sources.
- Visit [Knative Serving](https://github.com/knative/serving/blob/master/README.md) for more information about Serving.

## Chart Details

This chart is comprised of multiple subcharts which is illustrated in the structure below:
```
knative                         (default)
├── build                       (default)
├── eventing
|   ├── gcpPubSubProvisioner
│   ├── inMemoryProvisioner
|   ├── kafkaProvisioner
│   └── natssProvisioner
├── serving                     (default)
│   └── monitoring              (default)
│       ├── elasticsearch       (default)
│       ├── prometheus          (default)
|       ├── zipkin
│       └── zipkinInMem         (default)
└── eventingSources
    ├── camel
    ├── eventDisplay
    └── gcpPubSub
```
Disabling a chart will disable all charts below it in the chart structure. When enabling a subset of charts note that the parent charts are prerequisites and must be installed previously or in conjunction.

## Prerequisites
- Requires kubectl v1.10+.
- Knative requires a Kubernetes cluster v1.11 or newer with the
[MutatingAdmissionWebhook admission controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#how-do-i-turn-on-an-admission-controller)
enabled.
- Istio - You should have Istio installed on your Kubernetes cluster. If you do not have it installed already you can do so by running the following commands:
```bash
$ kubectl apply --filename https://github.com/knative/serving/releases/download/v0.5.2/istio-crds.yaml
$ kubectl apply --filename https://github.com/knative/serving/releases/download/v0.5.2/istio.yaml
```
or by following these steps:
[Installing Istio](https://www.knative.dev/docs/install/knative-with-any-k8s/#installing-istio)


## Installing the Chart

Please ensure that you have reviewed the [prerequisites](#prerequisites).

1. Install Knative crds
```bash
$ kubectl install -f https://raw.githubusercontent.com/helm/charts/7030ef8a367f5e31f0a76a888bdd529b69f2f45c/incubator/knative/all-crds.yaml
```

2. Install the chart using helm cli:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/knative --name <my-release> [--tls]
```

The command deploys Knative on the Kubernetes cluster in the default configuration.  The [configuration](#configuration) section lists the parameters that can be configured during installation.

You can use the command ```helm status <my-release> [--tls]``` to get a summary of the various Kubernetes artifacts that make up your Knative deployment.

### Configuration

| Parameter                                  | Description                              | Default |
|--------------------------------------------|------------------------------------------|---------|
| `build.enabled`                                  | Enable/Disable Knative Build             | `true`    |
| `build.buildController.image`                    | Build Controller Image                   | gcr.io/knative-releases/github.com/knative/build/cmd/controller@sha256:77b883fec7820bd3219c011796f552f15572a037895fbe7a7c78c7328fd96187    |
| `build.buildController.replicas`                 | Number of pods for Build Contoller       |    1      |
| `build.buildWebhook.image`                       | Build Webhook Image                      | gcr.io/knative-releases/github.com/knative/build/cmd/webhook@sha256:488920f65763374a2886860e3b06c3b614ee685b68ec4fdbbcd08d849bb84b71  |
| `build.buildWebhook.replicas`                    | Number of pods for Build Webhook         |    1      |
| `build.credsInit.image`                          | credsInit Image                          |    gcr.io/knative-releases/github.com/knative/build/cmd/creds-init@sha256:ebf58f848c65c50a7158a155db7e0384c3430221564c4bbaf83e8fbde8f756fe    |
| `build.gcsFetcher.image`                         | gcsFetcher Image                          |    gcr.io/cloud-builders/gcs-fetcher      |
| `build.gitInit.image`                            | gitInit Image                            |    gcr.io/knative-releases/github.com/knative/build/cmd/git-init@sha256:09f22919256ba4f7451e4e595227fb852b0a55e5e1e4694cb7df5ba0ad742b23      |
| `build.nop.image`                                | nop Image                                |    gcr.io/knative-releases/github.com/knative/build/cmd/nop@sha256:a318ee728d516ff732e2861c02ddf86197e52c6288049695781acb7710c841d4      |
| `eventing.enabled`                         | Enable/Disable Knative Eventing          | `false`   |
| `eventing.eventingController.image`        | Controller Image                         | gcr.io/knative-releases/github.com/knative/eventing/cmd/controller@sha256:de1727c9969d369f2c3c7d628c7b8c46937315ffaaf9fe3ca242ae2a1965f744 | 
| `eventing.eventingController.replicas`                        | Controller Replicas                      | 1         |
| `eventing.webhook.image`                   | Webhook Image                            | gcr.io/knative-releases/github.com/knative/eventing/cmd/webhook@sha256:3c0f22b9f9bd9608f804c6b3b8cbef9cc8ebc54bb67d966d3e047f377feb4ccb |
| `eventing.webhook.replicas`                | Webhook Replicas                         | 1         |
| `eventing.gcpPubSubProvisioner.enabled`    | Enable/Disable GCP PubSub Provisioner    | `false`   |
| `eventing.gcpPubSubProvisioner.gcpPubsubChannelController.controller.image` | Controller Image | gcr.io/knative-releases/github.com/knative/eventing/contrib/gcppubsub/pkg/controller/cmd@sha256:a37c64dc6cf6a22bd8a47766e3de1fb945dcec97d6fe768d675430f16ff011dd |
| `eventing.gcpPubSubProvisioner.gcpPubsubChannelController.replicas` | Controller Replicas | 1     |
| `eventing.gcpPubSubProvisioner.gcpPubsubChannelDispatcher.dispatcher.image` | Dispatcher Image | gcr.io/knative-releases/github.com/knative/eventing/contrib/gcppubsub/pkg/dispatcher/cmd@sha256:ffcc3319ca6b87075e6cac939c15d50862214ace4ff3d4bacb3853d43e9b0efb | 
| `eventing.gcpPubSubProvisioner.gcpPubsubChannelDispatcher.replicas` | Dispatcher Replicas | 1     |
| `eventing.gcpPubSubProvisioner.type`       | GCP PubSub Provisioner Ingress Type      | ClusterIP |
| `eventing.inMemoryProvisioner.enabled`     | Enable/Disable In-Memory Provisioner     | `false`   |
| `eventing.inMemoryProvisioner.inMemoryChannelController.controller.image` | Controller Image                    | gcr.io/knative-releases/github.com/knative/eventing/pkg/provisioners/inmemory/controller@sha256:3e4287fba1447d82b80b5fd87983609ba670850c4d28499fe7e60fb87d04cc53 |
| `eventing.inMemoryProvisioner.inMemoryChannelController.replicas`    | Controller Replicas           | 1         |
| `eventing.inMemoryProvisioner.inMemoryChannelDispatcher.dispatcher.image` | Dispatcher Image | gcr.io/knative-releases/github.com/knative/eventing/cmd/fanoutsidecar@sha256:f388c5226fb7f29b74038bef5591de05820bcbf7c13e7f5e202f1c5f9d9ab224 | 
| `eventing.inMemoryProvisioner.inMemoryChannelDispatcher.replicas` | Dispatcher Replicas | 1       |
| `eventing.kafkaProvisioner.enabled`        | Enable/Disable Kafka Provisioner         | `false`   |
| `eventing.kafkaProvisioner.kafkaChannelController.kafkaChannelControllerController.image` | Controller Image | gcr.io/knative-releases/github.com/knative/eventing/contrib/kafka/cmd/controller@sha256:5fa8b57594949b7e6d9d99d0dfba5109d0a57c497d34f0d8d84569cb9f2ad19e | 
| `eventing.kafkaProvisioner.kafkaChannelController.replicas` | Controller Replicas     | 1         | 
| `eventing.kafkaProvisioner.kafkaChannelDispatcher.dispatcher.image` | Dispatcher Image | gcr.io/knative-releases/github.com/knative/eventing/contrib/kafka/cmd/dispatcher@sha256:94d0f74892ce19e7f909bc0063b89ba68f85e2d12188f6bf918321542adcec05 |
| `eventing.kafkaProvisioner.kafkaChannelDispatcher.replicas` | Dispatcher Replicas     | 1         | 
| `eventing.natssProvisioner.enabled`        | Enable/Disable NATS Provisioner          | `false`   |
| `eventing.natssProvisioner.natssController.controller.image` | Controller Image | gcr.io/knative-releases/github.com/knative/eventing/contrib/natss/pkg/controller@sha256:c0ee52280ba652fa42d6a60ad5e51d7650244043b05e7fd6d693dfbfceb8abd6 |
| `eventing.natssProvisioner.natssController.replicas` | Controller Replicas            | 1         | 
| `eventing.natssProvisioner.natssDispatcher.dispatcher.image` | Dispatcher Image       | gcr.io/knative-releases/github.com/knative/eventing/contrib/natss/pkg/dispatcher@sha256:2de14f9876d0288060bae5266e663f9d77c130a8d491680438552b70cf394ca5 |
| `eventing.natssProvisioner.natssDispatcher.replicas` | Dispatcher Replicas            | 1         |
| `eventingSources.enabled`                  | Enable/Disable Knative Eventing Sources  | `false`   |
| `eventingSources.controllerManager.manager.image`        | Manager Image for Controller Manager | gcr.io/knative-releases/github.com/knative/eventing-sources/cmd/manager@sha256:deb40ead1bd4eedda8384d1e6d535cf75f1820ac723fdaa0c4670636ca94cf2e   |
| `eventingSources.camel.enabled`            | Enable/Disable Apache Camel Event Source | `false`   |
| `eventingSources.camel.camelControllerManager.manager.image`        | Manager Image for Camel Controller Manager | gcr.io/knative-releases/github.com/knative/eventing-sources/contrib/camel/cmd/controller@sha256:1c4631019f85cf63b7d6362a99483fbaae65277a68ac004de15168a79e90be73   |
| `eventingSources.eventDisplay.enabled`     | Enable/Disable A Knative Service that logs events received for use in samples and debugging. | `false`   |
| `eventingSources.eventDisplay.eventDisplay.image`        | Event Display Image for Event Display | gcr.io/knative-releases/github.com/knative/eventing-sources/cmd/event_display@sha256:bf45b3eb1e7fc4cb63d6a5a6416cf696295484a7662e0cf9ccdf5c080542c21d   |
| `eventingSources.gcpPubSub.enabled`        | Enable/Disable GCP Event Source          | `false`   |
| `eventingSources.gcpPubSub.gcppubsubControllerManager.manager.image`        | Google Cloud Platform Pub Sub Controller Manager Image | gcr.io/knative-releases/github.com/knative/eventing-sources/contrib/gcppubsub/cmd/controller@sha256:cde83a9f10c3c1340c93a9a9fd5ba76c9f7c33196fdab98a4c525f9cd5d3bb1f   |
| `serving.enabled`                          | Enable/Disable Knative Serving           | `true`    |
| `serving.activator.image`                  | Activator Image                          | gcr.io/knative-releases/github.com/knative/serving/cmd/activator@sha256:c75dc977b2a4d16f01f89a1741d6895990b7404b03ffb45725a63104d267b74a   |
| `serving.activatorService.type`            | Activator Ingress Type                   | ClusterIP |
| `serving.autoscaler.image`                 | Autoscaler Image                         | gcr.io/knative-releases/github.com/knative/serving/cmd/autoscaler@sha256:90f1199b3557242d46c4347d101e6767c388387e7cc30d8e6748dbfb10cefaef   |
| `serving.autoscaler.replicas`              | Autoscaler Replicas                      | 1         |
| `serving.controller.image`                 | Controller Image                         | gcr.io/knative-releases/github.com/knative/serving/cmd/controller@sha256:df02e462373a3e4a408356d8d6240222bfe31f6aebbac804d28a6982532fb45f  |
| `serving.controller.replicas`              | Controller Replicas                      | 1         |
| `serving.queueProxy.image`                 | Queue Proxy Image                        | gcr.io/knative-releases/github.com/knative/serving/cmd/queue@sha256:cae33dcb4477f87815dfae6fa8e2b1ec850562accb77b7bc36bb3ac12bafead1  |
| `serving.webhook.image`                    | Webhook Image                            | gcr.io/knative-releases/github.com/knative/serving/cmd/webhook@sha256:72189c6a5610e13794836a49bd2d6269206f434ab881b817d23e31f61493152e  |
| `serving.webhook.replicas`                 | Webhook Replicas                         | 1         |
| `serving.monitoring.enabled`               | Enable/Disable Knative Monitoring        | `true`    |
| `serving.monitoring.elasticsearch.enabled` | Enable/Disable Elasticsearch Logging     | `true`    |
| `serving.monitoring.elasticsearch.elasticsearchLogging.elasticsearchLoggingInit.image` | Elasticsearch Logging Init Image | alpine:3.6 |
| `serving.monitoring.elasticsearch.elasticsearchLogging.image`   | Elasticsearch Image | k8s.gcr.io/elasticsearch:v5.6.4  |
| `serving.monitoring.elasticsearch.elasticsearchLogging.replicas` | Elasticsearch Replicas | 2     |
| `serving.monitoring.elasticsearch.fluentdDs.image` | Fluentd Image                    | k8s.gcr.io/fluentd-elasticsearch:v2.0.4 |
| `serving.monitoring.elasticsearch.kibanaLogging.image` | Kibana Image                 | docker.elastic.co/kibana/kibana:5.6.4 |
| `serving.monitoring.elasticsearch.kibanaLogging.replicas` | Kibana Replicas           | 1         |
| `serving.monitoring.elasticsearch.kibanaLogging.type` | Kibana Ingress Type           | NodePort  |
| `serving.monitoring.prometheus.enabled`    | Enable/Disable Prometheus Metrics        | `true`    |
| `serving.monitoring.prometheus.grafana.image`    | Grafana Image        | quay.io/coreos/monitoring-grafana:5.0.3    |
| `serving.monitoring.prometheus.grafana.replicas`    | Number of Grafana pods         | 1    |
| `serving.monitoring.prometheus.grafana.type`    | Grafana Ingress Type        | NodePort   |
| `serving.monitoring.prometheus.kubeControllerManager.type`    | kubeControllerManager Ingress Type |  ClusterIP  |
| `serving.monitoring.prometheus.kubeStateMetrics.addonResizer.image` | Add On Resizer Image for Kube State Metrics | k8s.gcr.io/addon-resizer:1.7    |
| `serving.monitoring.prometheus.kubeStateMetrics.image`    | Kube State Metrics Image        | quay.io/coreos/kube-state-metrics:v1.3.0   |
| `serving.monitoring.prometheus.kubeStateMetrics.kubeRbacProxyMain.image`    | Kube Rbac Proxy Main Image for Kube State Metrics  | quay.io/coreos/kube-rbac-proxy:v0.3.0   |
| `serving.monitoring.prometheus.kubeStateMetrics.kubeRbacProxySelf.image`    | Kube Rbac Proxy Self Image for Kube State Metrics  | quay.io/coreos/kube-rbac-proxy:v0.3.0   |
| `serving.monitoring.prometheus.kubeStateMetrics.replicas`  | Number of Kube State Metrics Pods |  1  |
| `serving.monitoring.prometheus.nodeExporter.image` | Node Exporter Image for Prometheus | quay.io/prometheus/node-exporter:v0.15.2    |
| `serving.monitoring.prometheus.nodeExporter.kubeRbacProxy.https.hostPort`    | Https Host Port for Kube Rbac Proxy Node Exporter  | 9100  |
| `serving.monitoring.prometheus.nodeExporter.kubeRbacProxy.image`    | Kube Rbac Proxy Image  | quay.io/coreos/kube-rbac-proxy:v0.3.0  |
| `serving.monitoring.prometheus.nodeExporter.type`    | Node Exporter Ingress Type  | ClusterIP  |
| `serving.monitoring.prometheus.prometheusSystem.prometheus.image`    | Prometheus Image for Prometheus System  | prom/prometheus:v2.2.1  |
| `serving.monitoring.prometheus.prometheusSystem.replicas`    | Number of Prometheus System Pods  | 2  |
| `serving.monitoring.prometheus.prometheusSystemDiscovery.type`    | Ingress Type for Prometheus System Discovery  | ClusterIP  |
| `serving.monitoring.prometheus.prometheusSystemNp.type`    | Ingress Type for Prometheus System Np  | NodePort  |
| `serving.monitoring.zipkin.enabled`        | Enable/Disable Zipkin Metrics            | `false`   |
| `serving.monitoring.zipkin.zipkin.image`       | Zipkin Image                     | docker.io/openzipkin/zipkin:latest   |
| `serving.monitoring.zipkin.zipkin.replicas`    | Zipkin Image                     | 1             |
| `serving.monitoring.zipkinInMem.enabled`   | Enable/Disable Zipkin In Memory Metrics  | `true`    |
| `serving.monitoring.zipkinInMem.zipkin.image`       | Zipkin In Memory Image                     | docker.io/openzipkin/zipkin:latest   |
| `serving.monitoring.zipkinInMem.zipkin.replicas`    | Zipkin In Memory Image                     | 1             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

### Verifying the Chart

To verify all Pods are running, try:
```bash
$ helm status <my-release> [--tls]
```

## Uninstalling the Chart

To uninstall/delete the deployment:
```bash
$ helm delete <my-release> --purge [--tls]
```

To uninstall/delete the crds:
```bash
$ kubectl delete -f https://raw.githubusercontent.com/helm/charts/7030ef8a367f5e31f0a76a888bdd529b69f2f45c/incubator/knative/all-crds.yaml
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Limitations

Currently this chart does not support multiple installs of Knative, upgrades or rollbacks.

## Documentation

To learn more about Knative in general, see the [Knative Documentation](https://www.knative.dev/docs).

# Support

If you're a developer, operator, or contributor trying to use Knative, the
following resources are available for you:

- [Knative Users](https://groups.google.com/forum/#!forum/knative-users)
- [Knative Developers](https://groups.google.com/forum/#!forum/knative-dev)

For contributors to Knative, we also have [Knative Slack](https://slack.knative.dev).