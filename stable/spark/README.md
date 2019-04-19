# Apache Spark Helm Chart

Apache Spark is a fast and general-purpose cluster computing system including Apache Zeppelin.

* http://spark.apache.org/
* https://zeppelin.apache.org/

Inspired from Helm Classic chart https://github.com/helm/charts

## Chart Details
This chart will do the following:

* 1 x Spark Master with port 8080 exposed on an external LoadBalancer
* 3 x Spark Workers with HorizontalPodAutoscaler to scale to max 10 pods when CPU hits 50% of 100m. A LoadBalancer on these worker machines exposes ports 8080, 8888, 8889 and 4040 for purposes such as monitoring or serving spark-serving endpoints.
* 1 x Zeppelin pod (Optional) with port 8080 exposed on an external LoadBalancer
* 1 x Livy pod (Optional) with port 8998 exposed on an external LoadBalancer
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
| `Master.Image`          | Container image name               | `dbanda/spark2.4`                                 |
| `Master.ImageTag`       | Container image tag                | `v3`                                                      |
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
| `Worker.Image`               | Container image name                 | `dbanda/spark2.4`                                 |
| `Worker.ImageTag`            | Container image tag                  | `v3`                                                      |
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

|       Parameter                |           Description            |                         Default                          |
|--------------------------------|----------------------------------|----------------------------------------------------------|
| `Zeppelin.Name`                | Zeppelin name                    | `zeppelin-controller`                                    |
| `Zeppelin.Enabled`             | if `true` enable Zeppelin        | `true`                                                   |
| `Zeppelin.Image`               | Container image name             | `dbanda/zeppelin`                                        |
| `Zeppelin.ImageTag`            | Container image tag              | `v4`                                                     |
| `Zeppelin.Replicas`            | k8s deployment replicas          | `1`                                                      |
| `Zeppelin.Component`           | k8s selector key                 | `zeppelin`                                               |
| `Zeppelin.Cpu`                 | container requested cpu          | `100m`                                                   |
| `Zeppelin.ServicePort`         | k8s service port                 | `8080`                                                   |
| `Zeppelin.ContainerPort`       | Container listening port         | `8080`                                                   |
| `Zeppelin.Ingress.Enabled`     | if `true`, an ingress is created | `false`                                                  |
| `Zeppelin.Ingress.Annotations` | annotations for the ingress      | `{}`                                                     |
| `Zeppelin.Ingress.Path`        | the ingress path                 | `/`                                                      |
| `Zeppelin.Ingress.Hosts`       | a list of ingress hosts          | `[zeppelin.example.com]`                                 |
| `Zeppelin.Ingress.Tls`         | a list of [IngressTLS](https://v1-8.docs.kubernetes.io/docs/api-reference/v1.8/#ingresstls-v1beta1-extensions) items | `[]`
| `Zeppelin.ServiceType `        | Kubernetes Service type          | `LoadBalancer`                                           |

### Livy
|       Parameter                |           Description            |                         Default                          |
|--------------------------------|----------------------------------|----------------------------------------------------------|
| `Livy.Name`                    | Livy name                        | `livy-controller`                                        |
| `Livy.Enabled`                 | if `true` enable Zeppelin        | `true`                                                   |
| `Livy.Image`                   | Container image name             | `dbanda/livy`                                            |
| `Livy.ImageTag`                | Container image tag              | `v4`                                                     |
| `Livy.Replicas`                | k8s deployment replicas          | `1`                                                      |
| `Liyy.Component`               | k8s selector key                 | `livy`                                                   |
| `Livy.Cpu`                     | container requested cpu          | `100m`                                                   |
| `Livy.ServicePort`             | k8s service port                 | `8998`                                                   |
| `Livy.ServiceType `            | Kubernetes Service type          | `LoadBalancer`                                           |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/spark
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Running Spark Jobs

There are two ways to sumbit jobs to the spark cluster.
1. Using sparks inbuilt support for K8s clusters. This is mostly suited for jobs that don't require any user interaction or monitoring. See https://spark.apache.org/docs/latest/running-on-kubernetes.html#submitting-applications-to-kubernetes. To sumbit a job, typically you would run `kubectl proxy` to setup a proxy to the cluster at `localhost:8001` usually. The you would run call spark-submit. For example, to run the SparkPi sample app https://spark.apache.org/examples.html, you would run ```bin/spark-submit \
    --master k8s://https://localhost:8001 \
    --deploy-mode cluster \
    --name spark-pi \
    --class org.apache.spark.examples.SparkPi \
    --conf spark.executor.instances=5 \
    --conf spark.kubernetes.container.image=mhamilton723/spark-2.4.0 \
    local:///opt/spark/examples/jars/spark-examples_2.11-2.4.0.jar ``` 
This will create a pod based on the supplied container image and use that as the executor for your job. You can access this pod from the K8s dashboard. A downside to this method is that it requires creating a new pod for jobs and it is less transparent about how its jobs are executing. It is possible to sumbit jobs in client mode but that would require openning ports on the driver machine.

2. Using the zeppelin pod. The zeppelin pod exists in the cluster and already has its ports readily visible to the master and works pods and as such can run apps in both client and cluster mode. In addition, the pod contains a running instance of the zepplin notebook on port 8080  that can be used to run spark scripts in either scala, python, or as bash scripts.  To access the notebook look for the `spark-zeppelin` service under service on your dashboard. (if you run `kubectl proxy` you dashboard would be here http://localhost:8001/api/v1/namespaces/kube-system/services/kubernetes-dashboard:/proxy/#!/overview?namespace=default). Click the externel endpoint link.

Because the zeppelin pod is a full debian jessie container with spark 2.4.0 in the `/opt/spark` folder, you can also call spark-submit via the terminal with the `kubectl exec` command. For example, to run SparkPi you would first look for the name of your zeppelin pod under pods in the dashboard. This is will be something like `spark-zeppelin-76b6998f78-zm8c8`. Then run  `kubectl exec spark-zeppelin-76b6998f78-zm8c8 /opt/spark/bin/run-example SparkPi`

3. Using Livy. See https://livy.incubator.apache.org/docs/latest/. The livy rest endpoint is exposed by the livy loadbalancer service. By default, livy uses the `spark-master` pod as the master and livy jobs can be monitored from either the `spark-webui` loadbalancer service on port `8080` or the livy ui endpoint.

## Upgrading

To upgrade to this chart from 0.2.2 you will have to update the docker images to point the images in `values.yaml`. The dockerfiles for these images are here https://github.com/Azure/mmlspark/tree/master/tools/helm/docker_images.  To enable livy, you will need to create a livy deployment with a load balancer and optional pod scaler as described in `spark-livy-deployment.yaml` and `spark-livy-hpa.yaml`. Ensure that your livy pods have the right `SPARK_MASTER` environment variables.
