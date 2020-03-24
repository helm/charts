### Helm Chart for Spark Operator

This is the Helm chart for the [Kubernetes Operator for Apache Spark](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator).

#### Prerequisites

The Operator requires Kubernetes version 1.8 and above because it relies on garbage collection of custom resources. If customization of driver and executor pods (through mounting custom ConfigMaps and volumes) is desired, then the [Mutating Admission Webhook](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/quick-start-guide.md#using-the-mutating-admission-webhook) needs to be enabled and it only became beta in Kubernetes 1.9.

#### Installing the chart

First add the incubator repo:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
```

If using Helm 2, then the chart can be installed by running:

```bash
$ helm install incubator/sparkoperator --namespace spark-operator --set sparkJobNamespace=default
```

Note that you need to use the `--namespace` flag during `helm install` to specify in which namespace you want to install the operator. The namespace can be existing or not. When it's not available, Helm would take care of creating the namespace. Note that this namespace has no relation to the namespace where you would like to deploy Spark jobs (i.e. the setting `sparkJobNamespace` shown in the table below). They can be the same namespace or different ones.

If using Helm 3, then install the chart by running:

```bash
$ helm install incubator/sparkoperator --generate-name --namespace spark-operator --set sparkJobNamespace=default
```

or

```bash
$ helm install [RELEASE-NAME] incubator/sparkoperator --namespace spark-operator --set sparkJobNamespace=default
```

if you don't want Helm to automatically generate a name for you.

#### Configuration

The following table lists the configurable parameters of the Spark operator chart and their default values.

| Parameter                 | Description                                                  | Default                                |
| ------------------------- | ------------------------------------------------------------ | -------------------------------------- |
| `operatorImageName`       | The name of the operator image                               | `gcr.io/spark-operator/spark-operator` |
| `operatorVersion`         | The version of the operator to install                       | `v1beta2-1.1.1-2.4.5`                  |
| `imagePullPolicy`         | Docker image pull policy                                     | `IfNotPresent`                         |
| `imagePullSecrets`        | Docker image pull secrets                                    |                                        |
| `replicas`                | The number of replicas of the operator Deployment            | 1                                      |
| `sparkJobNamespace`       | K8s namespace where Spark jobs are to be deployed            | ``                                     |
| `enableWebhook`           | Whether to enable mutating admission webhook                 | false                                  |
| `enableMetrics`           | Whether to expose metrics to be scraped by Prometheus        | true                                   |
| `controllerThreads`       | Number of worker threads used by the SparkApplication controller | 10                                 |
| `ingressUrlFormat`        | Ingress URL format                                           | ""                                     |
| `logLevel`                | Logging verbosity level                                      | 2                                      |
| `installCrds`             | Whether the release should install CRDs.                     | true                                   |
| `metricsPort`             | Port for the metrics endpoint                                | 10254                                  |
| `metricsEndpoint`         | Metrics endpoint                                             | "/metrics"                             |
| `metricsPrefix`           | Prefix for the metrics                                       | ""                                     |
| `podAnnotations`          | annotations to be added to pods                              | `{}`                                   |
| `resyncInterval`          | Informer resync interval in seconds                          | 30                                     |
| `webhookPort`             | Service port of the webhook server                           | 8080                                   |
| `resources`               | Resources needed for the sparkoperator deployment            | {}                                     |
| `enableBatchScheduler`    | Whether to enable batch scheduler for pod scheduling         | false                                  |
| `enableResourceQuotaEnforcement`    | Whether to enable the ResourceQuota enforcement for SparkApplication resources. Requires the webhook to be enabled by setting enableWebhook to true.         | false                                  |
| `leaderElection.enable`   | Whether to enable leader election when the operator Deployment has more than one replica, i.e., when `replicas` is greater than 1.         | false                                  |
| `leaderElection.lockName` | Lock name to use for leader election                         | `spark-operator-lock`                  |
| `leaderElection.lockNamespace` | Namespace to use for leader election                    | (namespace of release)                 |
| `securityContext` | Defines security context for operator container. | `{}` |
Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

#### Upgrading

##### To 0.6.5

- `enableLeaderElection` has been renamed `leaderElection.enable` to keep all of the leader election stuff together

##### To 0.6.2

###### Breaking changes

- `cleanupCrdsBeforeInstall` has been removed for Helm 3 compatibility. If you wish to replicate this behavior before upgrading, do so manually (`kubectl delete CustomResourceDefinition sparkapplications.sparkoperator.k8s.io scheduledsparkapplications.sparkoperator.k8s.io`)

###### Non-breaking changes

- `app.kubernetes.io/name=sparkoperator` label is added to CRDs if installed at this version, for easier manual cleanup after chart deletion (`kubectl delete CustomResourceDefinition -l app.kubernetes.io/name=sparkoperator`)

#### Contributing

When making changes to values.yaml, update the files in `ci/` by running `hack/update-ci.sh`.
