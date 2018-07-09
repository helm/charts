# Helm Chart for Spark History Server

[Spark History Server](https://spark.apache.org/docs/latest/monitoring.html#viewing-after-the-fact) provides a web UI for completed and running Spark applications.

#### Installing the Chart

To install the chart:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/spark-history-server
```

#### Configrations

The following tables lists the configurable parameters of the Spark History Sever chart and their default values.

| Parameter                            | Description                                                       |Default                           |
| ------------------------------------ |----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| logDirectory                     |The URL to the directory containing application event logs to load. Currently only supports an HDFS location.|hdfs://hdfs/history/|
| image.repository |The Docker image used to start the history server daemon|lightbend/spark-history-server|
| image.tag |The tag of the image|2.3.1|

#### Viewing the UI

The Spark history server UI is exposed via a NodePort service. To view it in a browser:

1. Locate the service for the Spark history server and check its exposed port.

   ```bash
   $ kubectl get svc -l chart=spark-history-server-0.1.0
   NAME                                 TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
   worn-antelope-spark-history-server   NodePort   10.100.193.130   <none>        80:31102/TCP   20m
   ```

2. Find out the Kubernetes master IP.

   ```bash
   $ kubectl cluster-info
   Kubernetes master is running at http://10.0.8.205:9000
   KubeDNS is running at http://10.0.8.205:9000/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
   ```

3. From the example output of Step 1, we got `31102` as the exposed IP. The example output of Step 2 gave us `http://10.0.8.205` as the master IP. Now go to `http://10.0.8.205:31102` in a browser to see the web UI as shown below.

   ![Screen Shot 2018-07-09 at 14.46.28](/Users/cyu/Desktop/Screen Shot 2018-07-09 at 14.46.28.png)