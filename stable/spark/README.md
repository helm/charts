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

The following tables lists the configurable parameters of the Spark chart and their default values.

### Spark Master

| Parameter               | Description                        | Default                                                    |
| ----------------------- | ---------------------------------- | ---------------------------------------------------------- |
| `Master.Name`           | Spark master name                  | `spark-master`                                             |
| `Master.Image`          | Container image name               | `gcr.io/google_containers/spark`                           |
| `Master.ImageTag`       | Container image tag                | `1.5.1_v3`                                                 |
| `Master.Replicas`       | k8s deployment replicas            | `1`                                                        |
| `Master.Component`      | k8s selector key                   | `spark-master`                                             |
| `Master.Cpu`            | container requested cpu            | `100m`                                                     |
| `Master.Memory`         | container requested memory         | `512Mi`                                                    |
| `Master.ServicePort`    | k8s service port                   | `7077`                                                     |
| `Master.ContainerPort`  | Container listening port           | `7077`                                                     |
| `Master.DaemonMemory`   | Master JVM Xms and Xmx option      | `1g`                                                       |

### Spark WebUi

|       Parameter       |           Description            |                         Default                          |
|-----------------------|----------------------------------|----------------------------------------------------------|
| `WebUi.Name`          | Spark webui name                 | `spark-webui`                                            |
| `WebUi.ServicePort`   | k8s service port                 | `8080`                                                   |
| `WebUi.ContainerPort` | Container listening port         | `8080`                                                   |
| `WebUi.Image`               | The reverse proxy image to use for spark-ui-proxy         | `elsonrodriguez/spark-ui-proxy:1.0`|
| `WebUi.ProxyPort` | Reverse proxy port         | `80`                                                   |

### Persistence

|       Parameter          |           Description            |                         Default                          |
|--------------------------|----------------------------------|----------------------------------------------------------|
| `Persistence.Enabled`    | Enable Persistence               | `true`                                                   |
| `Persistence.AccessMode` | Persistence Access mode          | `ReadWriteOnce`                                          |
| `Persistence.Size`       | Persistence size                 | `8Gi`                                                    |
| `Persistence.volumes`    | Additional volumes to persist    | `undefined`                                              |
| `Persistence.mounts`     | Additional mounts                | `undefined`                                              |

### Spark Worker

| Parameter                    | Description                        | Default                                                    |
| -----------------------      | ---------------------------------- | ---------------------------------------------------------- |
| `Worker.Name`                | Spark worker name                  | `spark-worker`                                             |
| `Worker.Image`               | Container image name               | `gcr.io/google_containers/spark`                           |
| `Worker.ImageTag`            | Container image tag                | `1.5.1_v3`                                                 |
| `Worker.Replicas`            | k8s hpa and deployment replicas    | `3`                                                        |
| `Worker.ReplicasMax`         | k8s hpa max replicas               | `10`                                                       |
| `Worker.Component`           | k8s selector key                   | `spark-worker`                                             |
| `Worker.WorkingDirectory`    | Directory to run applications in   | `SPARK_HOME/work`                                          |
| `Worker.Cpu`                 | container requested cpu            | `100m`                                                     |
| `Worker.Memory`              | container requested memory         | `512Mi`                                                    |
| `Worker.ContainerPort`       | Container listening port           | `7077`                                                     |
| `Worker.CpuTargetPercentage` | k8s hpa cpu targetPercentage       | `50`                                                       |
| `Worker.DaemonMemory`        | Worker JVM Xms and Xmx setting     | `1g`                                                       |
| `Worker.ExecutorMemory`      | Worker memory available for executor | `1g`                                                     |
| `Environment`                | The worker environment configuration | `NA`                                                     |


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
$ helm install --name my-release -f values.yaml stable/spark
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The Spark image stores persistence under `/opt/spark/work` path of the container. A Persistent Volume
Claim is used to keep the data across deployments. 

It is possible to mount several volumes using `Persistence.volumes` and `Persistence.mounts` parameters.

## Do something with the cluster

Use the kubectl exec to connect to Spark driver.

```
$ kubectl exec !Enter your spark master pod name here! -it bash
root@your-spark-master:/#
root@your-spark-master:/# pyspark
Python 2.7.9 (default, Mar  1 2015, 12:57:24)
[GCC 4.9.2] on linux2
Type "help", "copyright", "credits" or "license" for more information.
15/06/26 14:25:28 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /__ / .__/\_,_/_/ /_/\_\   version 1.4.0
      /_/
Using Python version 2.7.9 (default, Mar  1 2015 12:57:24)
SparkContext available as sc, HiveContext available as sqlContext.
>>> import socket
>>> sc.parallelize(range(1000)).map(lambda x:socket.gethostname()).distinct().collect()
17/03/24 19:42:44 INFO DAGScheduler: Job 0 finished: collect at <stdin>:1, took 2.260357 s
['spark15-worker-2', 'spark15-worker-1', 'spark15-worker-0']
```

## Open the Spark UI to view your cluster

Use the kubectl `get svc` command lookup the external IP of your reverse proxy.

```
$ kubectl get svc
NAME               CLUSTER-IP     EXTERNAL-IP     PORT(S)                         AGE
kubernetes         10.0.0.1       <none>          443/TCP                         8d
spark-master       10.0.46.27     52.168.36.95    7077:30399/TCP,8080:31312/TCP   2h
spark-webui        10.0.102.137   **-->40.71.186.201<--**   80:31027/TCP                    2h
spark14-worker-0   10.0.234.55    52.179.10.132   8081:30408/TCP                  3d
spark15-zeppelin   10.0.229.183   40.71.190.17    8080:31840/TCP                  2h
```

Open 40.71.186.201:8080 in your browser.
