# Helm Chart for Spark History Server

[Spark History Server](https://spark.apache.org/docs/latest/monitoring.html#viewing-after-the-fact) provides a web UI for completed and running Spark applications. This chart is adapted from the [chart](https://github.com/SnappyDataInc/spark-on-k8s/tree/master/charts/spark-hs) from SnappyData Inc.

#### Prerequisites

1. HDFS ConfigMaps (Only if using HDFS)

   This chart supports specifying an HDFS-compatible URI as the log directory. In order for the Spark history server to communicate with HDFS, two HDFS files,  `hdfs-site.xml` and `core-site.xml`, need to be mounted as configMaps in the Kubernetes cluster. Locate them and then run the following command to create configMaps:

   ```bash
   $ kubectl create configmap hdfs-site --from-file=hdfs-site.xml && kubectl create configmap core-site --from-file=core-site.xml
   ```

   Then the two files would be mounted in the Docker image when the chart is installed.

2. PersistentVolumeClaim (Only if NOT using HDFS)

   If you are using a PVC as the backing storage for Spark history events, then you'll need to create the PVC before installing the chart. On the Google Kubernetes Engine (GKE), the recommended underlying PersistentVolume is NFS. You can also use Portworx or Gluster. All three options provide sharing capabilities that would allow both the history server pod and the Spark job pods to mount the same PVC. 

   For a concise documentation on how to set up an NFS-backed PVC, refer to this [page](https://github.com/kubernetes/examples/tree/master/staging/volumes/nfs). 

#### Installing the Chart

To install the chart:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install incubator/spark-history-server
```

#### Configurations

The following tables lists the configurable parameters of the Spark History Sever chart and their default values.

| Parameter                            | Description                                                       |Default                           |
| ------------------------------------ |----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| hdfs.logDirectory                |The log directory when HDFS is used|hdfs://hdfs/history/|
| hdfs.hdfsSiteConfigMap |The name of the configMap for hdfs-site.xml|hdfs-site|
| hdfs.coreSiteConfigMap |The name of the configMap for core-site.xml|Core-site|
| hdfs.HADOOP_CONF_DIR |The directory containing core-site.xml and hdfs-site.xml in the image|/etc/hadoop|
| image.repository |The Docker image used to start the history server daemon|lightbend/spark-history-server|
| image.tag |The tag of the image|2.3.1|
| service.type |The type of history server service that exposes the UI|LoadBalancer|
| service.port |The port on which the service UI can be accessed.|18080|
| pvc.enablePVC |Whether to enable PVC or use HDFS|true|
| pvc.existingClaimName |The pre-created PVC name|spark-hs-pvc|
| pvc.eventsDir |The log directory when PVC is used|/|

Note that only when `pvc.enablePVC` is set to `true`, the following settings are required:

* pvc.existingClaimName
* pvc.eventsDir

Similarly, only when `pvc.enablePVC` is set to `false`, meaning when HDFS is used, the settings below are required:

* hdfs.logDirectory
* hdfs.hdfsSiteConfigMap
* hdfs.coreSiteConfigMap
* hdfs.HADOOP_CONF_DIR

#### Viewing the UI

After the chart is successfully installed, a message would be printed out to the console with details about how to access the UI. Depending on what `service.type` is specified, different instructions would be presented. Valid `service.type` values are `LoadBalancer`, `NodePort` and `ClusterIP`. 

#### Enabling spark-submit to log events

The history server UI would only show Spark jobs if they are configured to log events to the same location that Spark history server is tracking.

1. PVC

   When a PVC is used as storage, `spark-submit` needs to mount the same PVC as follows:

   ```bash
   bin/spark-submit \
       --master k8s://https://<k8s-master-url> \
       --deploy-mode cluster \
       --name spark-pi \
       --class org.apache.spark.examples.SparkPi \
       --conf spark.eventLog.enabled=true \
       --conf spark.eventLog.dir=file:/mnt \
       --conf spark.executor.instances=2 \
       --conf spark.kubernetes.container.image=lightbend/spark-history-server:2.3.1 \
       --conf spark.kubernetes.container.image.pullPolicy=Always \
       --conf spark.kubernetes.driver.volumes.persistentVolumeClaim.checkpointpvc.options.claimName=spark-hs-pvc \
       --conf spark.kubernetes.driver.volumes.persistentVolumeClaim.checkpointpvc.mount.path=/mnt \
       --conf spark.kubernetes.driver.volumes.persistentVolumeClaim.checkpointpvc.mount.readOnly=false \
       --conf spark.kubernetes.executor.volumes.persistentVolumeClaim.checkpointpvc.options.claimName=spark-hs-pvc \
       --conf spark.kubernetes.executor.volumes.persistentVolumeClaim.checkpointpvc.mount.path=/mnt \
       --conf spark.kubernetes.executor.volumes.persistentVolumeClaim.checkpointpvc.mount.readOnly=false \
       local:///opt/spark/examples/jars/spark-examples_2.11-2.3.1.jar
   ```

   Points worth noting are

   * The PVC `spark-hs-pvc` needs to be present.
   * The mount path `/mnt` is just an example, it should be where your volume is mounted. 
   * The underlying volume needs to have sharing capability. Otherwise, when the above `spark-submit` command is executed, you would see an error saying that the PVC `spark-hs-pvc` is already mounted by another pod (i.e. the Spark history server pod).

2. HDFS

   If using HDFS to log events, only two flags are required: `--conf spark.eventLog.enabled=true` and
      ` --conf spark.eventLog.dir=hdfs://hdfs/history/`.

