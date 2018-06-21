### Helm Chart for Spark Operator

This is the Helm chart for the [Spark-on-Kubernetes Operator](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator).

#### Prerequisites

The Operator requires Kubernetes version 1.8 and above because it relies on garbage collection of custom resources. The [Initializer](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/#initializers) needs to be enabled for the Kubernetes API server if customization of driver and executor pods (through mounting ConfigMaps and volumes) are desired. For more details, read the project [documentation](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator).

#### Installing the chart

The chart can be installed by running:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/sparkoperator
```

By default, the operator is installed in a namespace called "sparkoperator". It would be created it does not exist.

#### Configuration

The following table lists the configurable parameters of the Spark operator chart and their default values.

| Parameter              | Description                                 | Default                                |
| ---------------------- | ------------------------------------------- | -------------------------------------- |
| `operatorImageName`    | The name of the operator image              | `gcr.io/spark-operator/spark-operator` |
| `operatorImageTag`     | The tag of the operator image               | `v2.3.0-v1alpha1-latest`               |
| `operatorNamespace`    | K8s namespace where operator is installed   | `sparkoperator`                        |
| `operatorVersionLabel` | The label indicating the operator version   | `v2.3.0-v1alpha1`                      |
| `enableInitializer`    | Whether to enable initializer alpha feature | false                                  |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

