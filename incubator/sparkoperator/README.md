### Helm Chart for Spark Operator

This is the Helm chart for the [Spark-on-Kubernetes Operator](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator).

#### Prerequisites

The Operator requires Kubernetes version 1.8 and above because it relies on garbage collection of custom resources. If customization of driver and executor pods (through mounting custom ConfigMaps and volumes) is desired, then the [Mutating Admission Webhook](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/quick-start-guide.md#using-the-mutating-admission-webhook) needs to be enabled and it only became beta in Kubernetes 1.9.

#### Installing the chart

The chart can be installed by running:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/sparkoperator
```

By default, the chart creates a namespace called "spark-operator" and installs the operator there. Alternatively, you can choose to install the operator in an existing namespace or in a new namespace with your custom name.

#### Configuration

The following table lists the configurable parameters of the Spark operator chart and their default values.

| Parameter                 | Description                                           | Default                   |
| ------------------------- | ----------------------------------------------------- | ------------------------- |
| `operatorImageName`       | The name of the operator image                        | `lightbend/sparkoperator` |
| `operatorVersion`         | The version of the operator to install                | `2.3.1`                   |
| `operatorNamespace`       | K8s namespace where operator is installed             | `spark-operator`          |
| `sparkJobNamespace`       | K8s namespace where Spark jobs are to be deployed     | `default`                 |
| `createOperatorNamespace` | Whether to create the operator namespace              | true                      |
| `createSparkJobNamespace` | Whether to create the Spark job namespace             | false                     |
| `enableWebhook`           | Whether to enable mutating admission webhook          | true                      |
| `enableMetrics`           | Whether to expose metrics to be scraped by Premetheus | true                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. 

