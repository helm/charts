# Apache Spark Helm Chart

Apache Spark is a fast and general-purpose cluster computing system including Apache Zeppelin.

* http://spark.apache.org/
* https://zeppelin.apache.org/

Inspired from Helm Classic chart https://github.com/helm/charts

Generate using `helm create spark`

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
