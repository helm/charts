# Helm Chart for Spark History Server

[Spark History Server](https://spark.apache.org/docs/latest/monitoring.html#viewing-after-the-fact) provides a web UI for completed and running Spark applications. The supported storage backends are HDFS, Google Cloud Storage (GCS), Azure Blob Storage (WASBS) and PersistentVolumeClaim (PVC). This chart is adapted from the [chart](https://github.com/SnappyDataInc/spark-on-k8s/tree/master/charts/spark-hs) from SnappyData Inc.

#### Prerequisites

* ConfigMaps (Only if using HDFS)

  This chart supports specifying an HDFS-compatible URI as the log directory. In order for the Spark history server to communicate with HDFS, two HDFS files,  `hdfs-site.xml` and `core-site.xml`, need to be mounted as ConfigMaps in the same namespace where the chart is going to be installed. Locate them on your local computer and then run the following command to create ConfigMaps:

  ```bash
  $ kubectl -n <history-server-namespace> create configmap hdfs-site --from-file=hdfs-site.xml && kubectl -n history-server-namespace create configmap core-site --from-file=core-site.xml
  ```

* Secret (Only if using GCS, WASBS or S3 without IAM based authentication)

  If using GCS as storage, follow the preparatory steps below:

  Set up `gsutil` and `gcloud` on your local laptop and associate them with your Google Cloud Platform (GCP) project, create a bucket, create an IAM service account `sparkonk8s`, generate a JSON key file `sparkonk8s.json`, to grant `sparkonk8s` admin permission to bucket `gs://spark-history-server`.

  ```bash
  $ gsutil mb -c nearline gs://spark-history-server
  $ export ACCOUNT_NAME=sparkonk8s
  $ export GCP_PROJECT_ID=project-id
  $ gcloud iam service-accounts create ${ACCOUNT_NAME} --display-name "${ACCOUNT_NAME}"
  $ gcloud iam service-accounts keys create "${ACCOUNT_NAME}.json" --iam-account "${ACCOUNT_NAME}@${GCP_PROJECT_ID}.iam.gserviceaccount.com"
  $ gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} --member "serviceAccount:${ACCOUNT_NAME}@${GCP_PROJECT_ID}.iam.gserviceaccount.com" --role roles/storage.admin
  $ gsutil iam ch serviceAccount:${ACCOUNT_NAME}@${GCP_PROJECT_ID}.iam.gserviceaccount.com:objectAdmin gs://spark-history-server
  ```

  Then create a secret using the JSON key file:

  ```bash
  $ kubectl -n <history-server-namespace> create secret generic history-secrets --from-file=sparkonk8s.json
  ```

  Then install the chart to enable the history server pod to read from the GCS bucket.
  
  Similarly, if using WASBS as storage, follow the preparatory steps below:
  ```bash
  # https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-cli
  # create storage account and blob container
  # prepare wasbs.storageAccount and wasbs.container values to set
  # create blob for Spark event logs (default is wasbs:///spark-hs)
  $ echo "your-storage-account-name" >> azure-storage-account-name
  $ echo "your-container-name" >> azure-blob-container-name
  # to auth with sas token (if wasbs.sasKeyMode=true - default)
  $ echo "your-azure-blob-sas-key" >> azure-blob-sas-key
  # to auth with storage account key
  $ echo "your-azure-storage-account-key" >> azure-storage-account-key
  ```

  Then create a secret:
  ```bash
  $ kubectl create secret generic azure-secrets --from-file=azure-storage-account-name --from-file=azure-blob-container-name --from-file=azure-blob-sas-key --from-file=azure-storage-account-key
  ```

  Similarly, if using S3 as storage, follow the preparatory steps below:
  ```bash
  $ aws s3 mb s3://your-spark-event-log-directory # default bucket is s3://spark-hs/
  $ aws iam list-access-keys --user-name your-user-name --output text | awk '{print $2}' >> aws-access-key
  $ echo "your-aws-secret-key" >> aws-secret-key
  ```

  Then create a secret:
  ```bash
  $ kubectl create secret generic aws-secrets --from-file=aws-access-key --from-file=aws-secret-key
  ```

* PVC (Only if using PVC)

  If you are using a PVC as the backing storage for Spark history events, then you'll need to create the PVC before installing the chart. On the Google Kubernetes Engine (GKE), the recommended underlying PersistentVolume is NFS. You can also use Portworx or Gluster. All three options provide sharing capabilities that would allow both the history server pod and the Spark job pods to mount the same PVC. 

  The chart by default creates a PVC backed by an NFS volume. The NFS volume and server are installed as a child chart adapted from the [documentation](https://github.com/kubernetes/examples/tree/master/staging/volumes/nfs) in the kubernetes/examples repo. The NFS PVC provided makes the history server work out of the box. The user is free to replace NFS with other storage technologies (e.g. Gluster) as long as the history server references the PVC using `pvc.existingClaimName` setting that has been properly set up.

NOTE: If installing the chart on an OpenShift cluster, first run

```bash
$ oc adm policy add-scc-to-user privileged -n<history-server-namespace> -z default
$ oc adm policy add-scc-to-group anyuid system:authenticated
```

to allow creation of privileged containers in the project/namepace where the history server chart is going to be installed.

#### Discussions of Storage Options

Becuase a PVC is a namespaced Kubernetes resource, the fact that it is created in the same namespace where the chart is installed means that Spark jobs that would like to log events to the PVC also need to be deployed in the same namespace. If this is an issue for you (e.g. you have another dedicated namespace for your Spark jobs), then use HDFS or GCS instead.

In the case of GCS, a secret is also namespaced, but it's only used to enable the history server to read the remote GCS bucket. So Spark jobs logging to GCS can run in any namespace. Unless jobs are running in the same namespace as the history server, you'll need to create the secret separately in the job namespace before runninng the job.

Similarly for HDFS, you can run Spark jobs in any namespace, as long as pods in the job namespace can communicate with HDFS to write events.

#### Installing the Chart

To install the chart with the sample PVC setup:

```bash
$ helm repo add stable https://kubernetes-charts.storage.googleapis.com
$ helm install stable/spark-history-server --namespace spark-history-server
```

For details about installing the chart to use HDFS or GCS, see configurations options below.

#### Configurations

The following tables lists the configurable parameters of the Spark History Sever chart and their default values.

Note that the default image `lightbend/spark-history-server` is built using this [repo](https://github.com/lightbend/spark-history-server-docker).

| Parameter                            | Description                                                       |Default                           |
| ------------------------------------ |----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| hdfs.logDirectory                |The HDFS log directory that starts with "hdfs://"|hdfs://hdfs/history/|
| hdfs.hdfsSiteConfigMap |The name of the ConfigMap for hdfs-site.xml|hdfs-site|
| hdfs.coreSiteConfigMap |The name of the ConfigMap for core-site.xml|core-site|
| hdfs.HADOOP_CONF_DIR |The directory containing core-site.xml and hdfs-site.xml in the image|/etc/hadoop|
| image.repository |The Docker image used to start the history server daemon|lightbend/spark-history-server|
| image.tag |The tag of the image|2.4.0|
| service.type |The type of history server service that exposes the UI|LoadBalancer|
| service.port |The port on which the service UI can be accessed.|18080|
| pvc.enablePVC |Whether to use PVC storage|true|
| pvc.existingClaimName |The pre-created PVC name|nfs-pvc|
| pvc.eventsDir |The log directory when PVC is used|/|
| nfs.enableExampleNFS |Whether to install demo NFS volume and server|true|
| gcs.enableGCS |Whether to use GCS storage|false|
| gcs.secret |Pre-mounted secret name for GCS connection|history-secrets|
| gcs.key |The JSON key file name|sparkonk8s.json|
| gcs.logDirectory |The GCS log directory that starts with "gs://"|gs://spark-hs/|
| s3.enableS3 | Whether to use S3 storage | false |
| s3.enableIAM | Whether to use IAM based authentication or fall back to using AWS access key ID and secret access key | true |
| s3.secret | Pre-mounted secret name for S3 connection. Omit if using IAM based authentication | aws-secrets |
| s3.accessKeyName | The file name that contains the AWS access key ID. Omit if using IAM based authentication | aws-access-key |
| s3.secretKeyName | The file name that contains the AWS secret access key. Omit if using IAM based authentication | aws-secret-key |
| s3.logDirectory | The S3 log directory that starts with "s3a://" | s3a://spark-hs/ |
| wasbs.enableWASBS | Whether to use WASBS storage | false |
| wasbs.sasKeyMode | Whether to use SAS token based authentication or fall back to using Azure Storage Account access key secret | true |
| wasbs.secret | Pre-mounted secret name for WASBS connection | azure-secrets |
| wasbs.sasKeyName | The file name that contains the Azure Storage access SAS token | azure-blob-sas-key |
| wasbs.storageAccountKeyName | The file name that contains the Azure Storage Account access key | azure-storage-account-key |
| wasbs.storageAccountNameKeyName | The file name that contains the Azure Storage account name | azure-storage-account-name |
| wasbs.containerKeyName | The file name that contains the Azure Storage container name | azure-blob-container-name |
| wasbs.logDirectory | The WASBS log directory that starts with "wasbs:///" | wasbs:///spark-hs |
| ingress.enabled | if `true`, an ingress is created | false |
| ingress.annotations | annotations for the ingress | {} |
| ingress.path | if `true`, an ingress is created | / |
| ingress.hosts | a list of ingress hosts | [spark-history-server.example.com] |
| ingress.tls | a list of [IngressTLS](https://v1-9.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.9/#ingresstls-v1beta1-extensions) items | [] |
| resources | Resource requests and limits | {} |

Note that only when `pvc.enablePVC` is set to `true`, the following settings take effect:

* pvc.existingClaimName
* pvc.eventsDir

By default an NFS server and PVC are set up. Optionally they can be disabled by setting `nfs.enableExampleNFS` to false.

Similary, only when `gcs.enableGCS` is `true`, the following settings take effect:

* gcs.secret
* gcs.key
* gcs.logDirectory

Similarly, only when `s3.enableS3` is `true`, the following settings take effect:

* s3.enableIAM
* s3.secret
* s3.accessKeyName
* s3.secretKeyName
* s3.logDirectory

Similarly, only when `wasbs.enableWASBS` is `true`, the following settings take effect:
* wasbs.enableWASBS
* wasbs.sasKeyMode
* wasbs.secret
* wasbs.sasKeyName
* wasbs.storageAccountKeyName
* wasbs.storageAccountNameKeyName
* wasbs.containerKeyName
* wasbs.logDirectory

And only when `pvc.enablePVC` and `gcs.enableGCS` are both `false`, is HDFS used, in which case the settings below are in effect:

* hdfs.logDirectory
* hdfs.hdfsSiteConfigMap
* hdfs.coreSiteConfigMap
* hdfs.HADOOP_CONF_DIR

#### Viewing the UI

After the chart is successfully installed, a message would be printed out to the console with details about how to access the UI. Depending on what `service.type` is specified, different instructions would be presented on the console. Valid `service.type` values are `LoadBalancer`, `NodePort` and `ClusterIP`. 

#### Enabling spark-submit to log events

The history server UI would only show Spark jobs if they are configured to log events to the same location that Spark history server is tracking.

##### PVC

When a PVC is used as storage, `spark-submit` needs to deploy the job in the same namespace as the PVC (as discussed earlier) and mount the the PVC in driver and executor pods. Note that when installing the chart, a ServiceAccount bearing the `spark-history-server` suffix would also be created, unless a different name is specified in `rbac.serviceAccount.name`. It can be used to submit the job.

```bash
bin/spark-submit \
    --master k8s://https://<k8s-master-url> \
    --deploy-mode cluster \
    --name spark-pi \
    --class org.apache.spark.examples.SparkPi \
    --conf spark.kubernetes.namespace=<history-server-namespace> \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=<helm-release-name>-spark-history-server \
    --conf spark.eventLog.enabled=true \
    --conf spark.eventLog.dir=file:/mnt \
    --conf spark.executor.instances=2 \
    --conf spark.kubernetes.container.image=lightbend/spark-history-server:2.4.0 \
    --conf spark.kubernetes.container.image.pullPolicy=Always \
    --conf spark.kubernetes.driver.volumes.persistentVolumeClaim.checkpointpvc.options.claimName=nfs-pvc \
    --conf spark.kubernetes.driver.volumes.persistentVolumeClaim.checkpointpvc.mount.path=/mnt \
    --conf spark.kubernetes.driver.volumes.persistentVolumeClaim.checkpointpvc.mount.readOnly=false \
    --conf spark.kubernetes.executor.volumes.persistentVolumeClaim.checkpointpvc.options.claimName=nfs-pvc \
    --conf spark.kubernetes.executor.volumes.persistentVolumeClaim.checkpointpvc.mount.path=/mnt \
    --conf spark.kubernetes.executor.volumes.persistentVolumeClaim.checkpointpvc.mount.readOnly=false \
    local:///opt/spark/examples/jars/spark-examples_2.11-2.4.0.jar
```

Points worth noting are

* The PVC `nfs-pvc` needs to be present and bound to a PV.
* The mount path `/mnt` is just an example, it should be where your volume is mounted. 
* The underlying volume needs to have sharing capability. Otherwise, when the above `spark-submit` command is executed, you would see an error saying that the PVC `nfs-pvc` is already mounted by another pod (i.e. the Spark history server pod).

##### HDFS

In the case of HDFS, only two flags are required: 

```bash
--conf spark.eventLog.enabled=true
--conf spark.eventLog.dir=hdfs://hdfs/history/
```

##### GCS

In the case of GCS, the secret needs to be mounted in the driver and executor pods using the configuration options `spark.kubernetes.driver.secrets.[SecretName]` and `spark.kubernetes.executor.secrets.[SecretName]`. A sample command is given below:

```bash
bin/spark-submit \
    --master k8s://https://<k8s-master-url> \
    --deploy-mode cluster \
    --name spark-pi \
    --class org.apache.spark.examples.SparkPi \
    --conf spark.eventLog.enabled=true \
    --conf spark.eventLog.dir=gs://spark-hs/ \
    --conf spark.executor.instances=1 \
    --conf spark.hadoop.google.cloud.auth.service.account.json.keyfile=/etc/secrets/sparkonk8s.json \
    --conf spark.kubernetes.driver.secrets.history-secrets=/etc/secrets \
    --conf spark.kubernetes.executor.secrets.history-secrets=/etc/secrets \
    --conf spark.kubernetes.container.image=lightbend/spark-history-server:2.4.0 \
    local:///opt/spark/examples/jars/spark-examples_2.11-2.4.0.jar
```

Note that the image for your Spark job (i.e. `spark.kubernetes.container.image`, `spark.kubernetes.driver.container.image` and `spark.kubernetes.executor.container.image`) needs to have the [GCS connector](https://cloud.google.com/dataproc/docs/concepts/connectors/cloud-storage) dependency, which is included in `lightbend/spark-history-server:2.4.0`, otherwise the `gs://` scheme won't be recognized.

##### S3

In the case of S3, it is recommended to use IAM based authentication. The IAM role should have equivalent access to AmazonS3FullAccess. To write event logs to S3, you need to provide configs as below: 
```
--conf spark.eventLog.enabled=true \
--conf spark.eventLog.dir=s3a://spark-hs/
```
Similar to GCS, note that the image for your Spark job scheme needs to have the necessary dependencies: `hadoop-aws-2.7.5.jar` and `aws-java-sdk-1.7.4.jar`

When not using the IAM based authentication, you need to provide additional configs for authentication as below:
```bash
--conf spark.hadoop.fs.s3a.access.key=your-AWS-access-key-ID \
--conf spark.hadoop.fs.s3a.secret.key=your-AWS-secret-access-key
```

##### WASBS

To write event logs to WASBS, you need to provide configs as below: 
```
--conf spark.eventLog.enabled=true \
--conf spark.eventLog.dir=wasbs://$container@$storageAccount.blob.core.windows.net/spark-hs
```
Similar to GCS, note that the image for your Spark job scheme needs to have the necessary dependencies: `hadoop-azure-2.7.3.jar` and `azure-storage-2.0.0.jar`

You need to provide additional configs for authentication as below:
```bash
# For SAS token base auth
--conf spark.hadoop.fs.azure.local.sas.key.mode=true
--conf spark.hadoop.fs.azure.sas.$container.$storageAccount.blob.core.windows.net=your-SAS-token \
# For Storage Account key based auth
--conf spark.hadoop.fs.azure.account.key.$storageAccount.blob.core.windows.net=your-storage-account-key
```