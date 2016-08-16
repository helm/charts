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

## Chart Installation
```
helm repo add lachlan-charts http://storage.googleapis.com/lachlan-charts
helm search spark
lachlan-charts/spark-0.1.0.tgz
helm install lachlan-charts/spark-0.1.0.tgz
```

## Configuration

The following tables lists the configurable parameters of the Spark chart and their default values.

### Spark Master

|       Parameter       |           Description            |                         Default                          |
|-----------------------|----------------------------------|----------------------------------------------------------|
| `Master.Name`         | Spark master name                | `spark-master`                                           |
| `Master.Image`        | Container image name             | `gcr.io/google_containers/spark`                         |
| `Master.ImageTag`     | Container image tag              | `1.5.1_v3`                                               |
| `Master.Replicas`     | k8s deployment replicas          | `1`                                                      |
| `Master.Component`    | k8s selector key                 | `spark-master`                                           |
| `Master.Cpu`          | container requested cpu          | `100m`                                                   |
| `Master.ServicePort`  | k8s service port                 | `7077`                                                   |
| `Master.ContainerPort`| Container listening port         | `7077`                                                   |

### Spark WebUi

|       Parameter       |           Description            |                         Default                          |
|-----------------------|----------------------------------|----------------------------------------------------------|
| `WebUi.Name`          | Spark webui name                 | `spark-webui`                                            |
| `WebUi.ServicePort`   | k8s service port                 | `8080`                                                   |
| `WebUi.ContainerPort` | Container listening port         | `8080`                                                   |

### Spark Worker

|       Parameter       |           Description            |                         Default                          |
|-----------------------|----------------------------------|----------------------------------------------------------|
| `Worker.Name`         | Spark worker name                | `spark-worker`                                           |
| `Worker.Image`        | Container image name             | `gcr.io/google_containers/spark`                         |
| `Worker.ImageTag`     | Container image tag              | `1.5.1_v3`                                               |
| `Worker.Replicas`     | k8s deployment replicas          | `3`                                                      |
| `Worker.Component`    | k8s selector key                 | `spark-worker`                                           |
| `Worker.Cpu`          | container requested cpu          | `100m`                                                   |
| `Worker.ContainerPort`| Container listening port         | `7077`                                                   |

### Zeppelin

|       Parameter         |           Description            |                         Default                          |
|-------------------------|----------------------------------|----------------------------------------------------------|
| `Zeppelin.Name`         | Zeppelin name                    | `zeppelin-controller`                                    |
| `Zeppelin.Image`        | Container image name             | `gcr.io/google_containers/zeppelin`                      |
| `Zeppelin.ImageTag`     | Container image tag              | `v0.5.5_v2`                                              |
| `Zeppelin.Replicas`     | k8s deployment replicas          | `1`                                                      |
| `Zeppelin.Component`    | k8s selector key                 | `zeppelin`                                               |
| `Zeppelin.Cpu`          | container requested cpu          | `100m`                                                   |
| `Zeppelin.ServicePort`  | k8s service port                 | `8080`                                                   |
| `Zeppelin.ContainerPort`| Container listening port         | `8080`                                                   |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml spark-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)
