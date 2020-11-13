# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Kubeless

[Kubeless](http://kubeless.io/) is a Kubernetes-native serverless framework. It runs on top of your Kubernetes cluster and allows you to deploy small unit of code without having to build container images. With kubeless you can build advanced applications that tie together services using functions.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## TL;DR;

```bash
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
$ helm install --namespace kubeless incubator/kubeless
```

## Introduction

This chart bootstraps a [Kubeless](https://github.com/kubeless/kubeless) and a [Kubeless-UI](https://github.com/kubeless/kubeless-ui) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.7+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release --namespace kubeless incubator/kubeless
```

> **NOTE**
>
> While the chart supports deploying Kubeless to any namespace, Kubeless expects to be deployed under a namespace named `kubeless`.

The command deploys Kubeless on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Kafka Trigger

Kubeless supports triggering functions via Kafka events. More info here: https://kubeless.io/docs/use-existing-kafka/.
An existing Kafka cluster needs to be accessible to kubeless -- if you like, you may look into setting Kafka up via the [Kafka chart](https://github.com/kubernetes/charts/tree/master/incubator/kafka). Once Kafka is running,
to enable the Kafka trigger you must configure the following values: `rbac.create: true`, `kafkaTrigger.enabled: true`, `kafkaTrigger.env.kafkaBrokers: <your_kafka_brokers>`.

## Configuration

The following table lists the configurable parameters of the Kubeless chart and their default values.

| Parameter                                                         | Description                                | Default                                   |
| ----------------------------------------------------------------- | ------------------------------------------ | ----------------------------------------- |
| `rbac.create`                                                     | Create RBAC backed ServiceAccount          | `false`                                   |
| `config.functionsNamespace`                                       | Functions namespace                        | ""                                        |
| `config.builderImage`                                             | Function builder image                     | `kubeless/function-image-builder`         |
| `config.builderImagePullSecret`                                   | Secret to pull builder image               | ""                                        |
| `config.provisionImage`                                           | Provision image                            | `kubeless/unzip`                          |
| `config.provisionImagePullSecret`                                 | Secret to pull provision image             | ""                                        |
| `config.deploymentTemplate`                                       | Deployment template for functions          | `{}`                                      |
| `config.enableBuildStep`                                          | Enable builder functionality               | `false`                                   |
| `config.functionRegistryTLSVerify`                                | Enable TLS verification for image registry | `{}`                                      |
| `config.runtimeImages`                                            | Runtimes available                         | python, nodejs, ruby, php and go          |
| `controller.deployment.functionController.image.repository`       | Function Controller image                  | `kubeless/function-controller`            |
| `controller.deployment.functionController.image.pullPolicy`       | Function Controller image pull policy      | `IfNotPresent`                            |
| `controller.deployment.httpTriggerController.image.repository`    | HTTP Controller image                      | `bitnami/bitnami/http-trigger-controller` |
| `controller.deployment.httpTriggerController.image.pullPolicy`    | HTTP Controller image pull policy          | `IfNotPresent`                            |
| `controller.deployment.cronJobTriggerController.image.repository` | CronJob Controller image                   | `bitnami/cronjob-trigger-controller`      |
| `controller.deployment.cronJobTriggerController.image.pullPolicy` | CronJob Controller image pull policy       | `IfNotPresent`                            |
| `controller.deployment.replicaCount`                              | Number of replicas                         | `1`                                       |
| `ui.enabled`                                                      | Kubeless UI component                      | `false`                                   |
| `ui.deployment.ui.image.repository`                               | Kubeless UI image                          | `bitnami/kubeless-ui`                     |
| `ui.deployment.ui.image.pullPolicy`                               | Kubeless UI image pull policy              | `IfNotPresent`                            |
| `ui.deployment.proxy.image.repository`                            | Proxy image                                | `kelseyhightower/kubectl`                 |
| `ui.deployment.proxy.image.pullPolicy`                            | Proxy image pull policy                    | `IfNotPresent`                            |
| `ui.deployment.replicaCount`                                      | Number of replicas                         | `1`                                       |
| `ui.service.name`                                                 | Service name                               | `ui-port`                                 |
| `ui.service.type`                                                 | Kubernetes service name                    | `NodePort`                                |
| `ui.service.externalPort`                                         | Service external port                      | `3000`                                    |
| `ui.ingress.enabled`                                              | Kubeless UI ingress switch                 | `false`                                   |
| `ui.ingress.annotations`                                          | Kubeless UI ingress annotations            | `{}`                                      |
| `ui.ingress.path`                                                 | Kubeless UI ingress path                   | `{}`                                      |
| `ui.ingress.hosts`                                                | Kubeless UI ingress hosts                  | `[chart-example.local]`                   |
| `ui.ingress.tls`                                                  | Kubeless UI ingress TLS                    | `[]`                                      |
| `kafkaTrigger.enabled`                                            | Kubeless Kafka Trigger                     | `false`                                   |
| `kafkaTrigger.env.kafkaBrokers`                                   | Kafka Brokers Environment Variable         | `localhost:9092`                          |
| `kafkaTrigger.deployment.ui.image.repository`                     | Kubeless Kafka Trigger image               | `bitnami/kubeless-ui`                     |
| `kafkaTrigger.deployment.ui.image.pullPolicy`                     | Kubeless Kafka Trigger image pull policy   | `IfNotPresent`                            |
| `kafkaTrigger.deployment.ui.image.tag`                            | Kubeless Kafka Trigger image tag           | `v1.0.1`                                  |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release --set service.name=ui-service,service,externalPort=4000 --namespace kubeless incubator/kubeless
```

The above command sets the Kubeless service name to `ui-service` and the external port to `4000`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml --namespace kubeless incubator/kubeless
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Kubeless UI

The [Kubeless UI](https://github.com/kubeless/kubeless-ui) component is disabled by default. In order to enable it set the ui.enabled property to true. For example,

```bash
$ helm install --name my-release --set ui.enabled=true --namespace kubeless incubator/kubeless
```
