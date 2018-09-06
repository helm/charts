# Apache Spark Helm Chart

Apache Spark is a fast and general-purpose cluster computing system including Apache Zeppelin.

* http://spark.apache.org/
* https://zeppelin.apache.org/

Inspired from Helm Classic chart https://github.com/helm/charts

## Chart Details
This chart will do the following:

* 1 x Spark Master with port 8080 exposed on an external LoadBalancer
* 3 x Spark Workers with HorizontalPodAutoscaler to scale to max 10 pods when CPU hits 50% of 100m
* 1 x Zeppelin with port 8080 exposed on an external LoadBalancer
* All using Kubernetes Deployments

## Prerequisites

* Assumes that serviceAccount tokens are available under hostname metadata. (Works on GKE by default) URL -- http://metadata/computeMetadata/v1/instance/service-accounts/default/token

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/spark
```

## Configuration

The following table lists the configurable parameters of the Spark chart and their default values.

### Spark Master

| Parameter               | Description                        | Default                                                    |
| ----------------------- | ---------------------------------- | ---------------------------------------------------------- |
| `Master.Name`           | Spark master name                  | `spark-master`                                             |
| `Master.Image`          | Container image name               | `k8s.gcr.io/spark`                                         |
| `Master.ImageTag`       | Container image tag                | `1.5.1_v3`                                                 |
| `Master.Replicas`       | k8s deployment replicas            | `1`                                                        |
| `Master.Component`      | k8s selector key                   | `spark-master`                                             |
| `Master.Cpu`            | container requested cpu            | `100m`                                                     |
| `Master.Memory`         | container requested memory         | `512Mi`                                                    |
| `Master.ServicePort`    | k8s service port                   | `7077`                                                     |
| `Master.ContainerPort`  | Container listening port           | `7077`                                                     |
| `Master.DaemonMemory`   | Master JVM Xms and Xmx option      | `1g`                                                       |
| `Master.ServiceType `   | Kubernetes Service type            | `LoadBalancer`                                             |

### Spark WebUi

|       Parameter       |           Description            |                         Default                          |
|-----------------------|----------------------------------|----------------------------------------------------------|
| `WebUi.Name`          | Spark webui name                 | `spark-webui`                                            |
| `WebUi.ServicePort`   | k8s service port                 | `8080`                                                   |
| `WebUi.ContainerPort` | Container listening port         | `8080`                                                   |

### Spark Worker

| Parameter                    | Description                          | Default                                                    |
| -----------------------      | ------------------------------------ | ---------------------------------------------------------- |
| `Worker.Name`                | Spark worker name                    | `spark-worker`                                             |
| `Worker.Image`               | Container image name                 | `k8s.gcr.io/spark`                                         |
| `Worker.ImageTag`            | Container image tag                  | `1.5.1_v3`                                                 |
| `Worker.Replicas`            | k8s hpa and deployment replicas      | `3`                                                        |
| `Worker.ReplicasMax`         | k8s hpa max replicas                 | `10`                                                       |
| `Worker.Component`           | k8s selector key                     | `spark-worker`                                             |
| `Worker.Cpu`                 | container requested cpu              | `100m`                                                     |
| `Worker.Memory`              | container requested memory           | `512Mi`                                                    |
| `Worker.ContainerPort`       | Container listening port             | `7077`                                                     |
| `Worker.CpuTargetPercentage` | k8s hpa cpu targetPercentage         | `50`                                                       |
| `Worker.DaemonMemory`        | Worker JVM Xms and Xmx setting       | `1g`                                                       |
| `Worker.ExecutorMemory`      | Worker memory available for executor | `1g`                                                       |
| `Worker.Autoscaling`         | Enable horizontal pod autoscaling    | `false`                                                    |


### Zeppelin

|          Parameter                           |           Description                |                         Default            |
|----------------------------------------------|--------------------------------------|--------------------------------------------|
| `Zeppelin.Name`                              | Zeppelin name                        | `zeppelin-controller`                      |
| `Zeppelin.Image`                             | Container image name                 | `apache/zeppelin`                          |
| `Zeppelin.ImageTag`                          | Container image tag                  | `0.7.3`                                    |
| `Zeppelin.Replicas`                          | k8s deployment replicas              | `1`                                        |
| `Zeppelin.Component`                         | k8s selector key                     | `zeppelin`                                 |
| `Zeppelin.Cpu`                               | container requested cpu              | `100m`                                     |
| `Zeppelin.ServicePort`                       | k8s service port                     | `8080`                                     |
| `Zeppelin.ContainerPort`                     | Container listening port             | `8080`                                     |
| `Zeppelin.Ingress.Enabled`                   | if `true`, an ingress is created     | `false`                                    |
| `Zeppelin.Ingress.Annotations`               | annotations for the ingress          | `{}`                                       |
| `Zeppelin.Ingress.Path`                      | the ingress path                     | `/`                                        |
| `Zeppelin.Ingress.Hosts`                     | a list of ingress hosts              | `[zeppelin.example.com]`                   |
| `Zeppelin.Ingress.Tls`                       | a list of [IngressTLS](https://v1-8.docs.kubernetes.io/docs/api-reference/v1.8/#ingresstls-v1beta1-extensions) items | `[]`
| `Zeppelin.ServiceType `                      | Kubernetes Service type              | `LoadBalancer`                             |
| `Zeppelin.Persistence.Config.Enabled`        | Enable Persistence for configuration | `false`                                    |
| `Zeppelin.Persistence.Config.StorageClass`   | Volume storageClassName              | `-` (no dynamic provisioning)              |
| `Zeppelin.Persistence.Config.Size`           | Configuration Persistence Size       | `10G`                                      |
| `Zeppelin.Persistence.Config.AccessMode`     | Configuration Persistence AccessMode | `ReadWriteOnce`                            |
| `Zeppelin.Persistence.Notebook.Enabled`      | Enable Persistence for notebook      | `false`                                    |
| `Zeppelin.Persistence.Notebook.StorageClass` | Volume storageClassName              | `-` (no dynamic provisioning)              |
| `Zeppelin.Persistence.Notebook.Size`         | Notebook Persistence Size            | `10G`                                      |
| `Zeppelin.Persistence.Notebook.AccessMode`   | Notebook Persistence AccessMode      | `ReadWriteOnce`                            |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/spark
```

> **Tip**: You can use the default [values.yaml](values.yaml)
