### Helm Chart for Spark Operator

This is the Helm chart for the [Spark-on-Kubernetes Operator](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator).

#### Prerequisites

The Operator requires Kubernetes version 1.8 and above because it relies on garbage collection of custom resources. If customization of driver and executor pods (through mounting custom ConfigMaps and volumes) is desired, then the [Mutating Admission Webhook](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/quick-start-guide.md#using-the-mutating-admission-webhook) needs to be enabled and it only became beta in Kubernetes 1.9.

#### Installing the chart

The chart can be installed by running:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/sparkoperator --namespace spark-operator
```

Note that you need to use the `--namespace` flag during `helm install` to specify in which namespace you want to install the operator. The namespace can be existing or not. When it's not available, Helm would take care of creating the namespace. Note that this namespace has no relation to the namespace where you would like to deploy Spark jobs (i.e. the setting `sparkJobNamespace` shown in the table below). They can be the same namespace or different ones. 

#### Configuration

The following table lists the configurable parameters of the Spark operator chart and their default values.

| Parameter                 | Description                                                  | Default                                |
| ------------------------- | ------------------------------------------------------------ | -------------------------------------- |
| `operatorImageName`       | The name of the operator image                               | `gcr.io/spark-operator/spark-operator` |
| `operatorVersion`         | The version of the operator to install                       | `v2.4.0-v1alpha1-latest`               |
| `imagePullPolicy`         | Docker image pull policy                                     | `IfNotPresent`                         |
| `sparkJobNamespace`       | K8s namespace where Spark jobs are to be deployed            | `default`                              |
| `enableWebhook`           | Whether to enable mutating admission webhook                 | false                                   |
| `enableMetrics`           | Whether to expose metrics to be scraped by Premetheus        | true                                   |
| `controllerThreads`       | Number of worker threads used by the SparkApplication controller | 10                                     |
| `installCrds`             | Whether to install CRDs                                      | true                                   |
| `metricsPort`             | Port for the metrics endpoint                                | 10254                                  |
| `metricsEndpoint`         | Metrics endpoint                                             | "/metrics"                             |
| `metricsPrefix`           | Prefix for the metrics                                       | ""                                     |
| `namespace`               | The Kubernetes namespace to manage. Will manage custom resource objects of the managed CRD types for the whole cluster if set to empty string. | ""                                     |
| `resyncInterval`          | Informer resync interval in seconds                          | 30                                     |
| `webhookPort`             | Service port of the webhook server                           | 8080                                   |                                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. 

