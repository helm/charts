# JFrog Artifactory High Availability Helm Chart - DEPRECATED
**This chart is deprecated! You can find the new chart in:**
- **Sources:** https://github.com/jfrog/charts
- **Charts repository:** https://charts.jfrog.io
```bash
helm repo add jfrog https://charts.jfrog.io
```

## Prerequisites Details

* Kubernetes 1.8+
* Artifactory HA license

## Chart Details
This chart will do the following:

* Deploy Artifactory highly available cluster. 1 primary node and 2 member nodes.
* Deploy a PostgreSQL database
* Deploy an Nginx server

## Artifactory HA architecture
The Artifactory HA cluster in this chart is made up of
- A single primary node
- Two member nodes, which can be resized at will

Load balancing is done to the member nodes only.
This leaves the primary node free to handle jobs and tasks and not be interrupted by inbound traffic.
> This can be controlled by the parameter `artifactory.service.pool`.

## Installing the Chart
To install the chart with the release name `artifactory-ha`:
```bash
$ helm install --name artifactory-ha stable/artifactory-ha
```

### Deploying Artifactory with replicator enabled
```bash
## Artifactory replicator is disabled by default. To enable it use the following:
$ helm install --name artifactory --set artifactory.replicator.enabled=true stable/artifactory-ha
```

### Accessing Artifactory
**NOTE:** It might take a few minutes for Artifactory's public IP to become available, and the nodes to complete initial setup.
Follow the instructions outputted by the install command to get the Artifactory IP and URL to access it.

### Updating Artifactory
Once you have a new chart version, you can update your deployment with
```bash
$ helm upgrade artifactory-ha stable/artifactory-ha
```

This will apply any configuration changes on your existing deployment.

### Artifactory memory and CPU resources
The Artifactory HA Helm chart comes with support for configured resource requests and limits to all pods. By default, these settings are commented out.
It is **highly** recommended to set these so you have full control of the allocated resources and limits.

See more information on [setting resources for your Artifactory based on planned usage](https://www.jfrog.com/confluence/display/RTF/System+Requirements#SystemRequirements-RecommendedHardware).

```bash
# Example of setting resource requests and limits to all pods (including passing java memory settings to Artifactory)
$ helm install --name artifactory-ha \
               --set artifactory.primary.resources.requests.cpu="500m" \
               --set artifactory.primary.resources.limits.cpu="2" \
               --set artifactory.primary.resources.requests.memory="1Gi" \
               --set artifactory.primary.resources.limits.memory="4Gi" \
               --set artifactory.primary.javaOpts.xms="1g" \
               --set artifactory.primary.javaOpts.xmx="4g" \
               --set artifactory.node.resources.requests.cpu="500m" \
               --set artifactory.node.resources.limits.cpu="2" \
               --set artifactory.node.resources.requests.memory="1Gi" \
               --set artifactory.node.resources.limits.memory="4Gi" \
               --set artifactory.node.javaOpts.xms="1g" \
               --set artifactory.node.javaOpts.xmx="4g" \
               --set postgresql.resources.requests.cpu="200m" \
               --set postgresql.resources.limits.cpu="1" \
               --set postgresql.resources.requests.memory="500Mi" \
               --set postgresql.resources.limits.memory="1Gi" \
               --set nginx.resources.requests.cpu="100m" \
               --set nginx.resources.limits.cpu="250m" \
               --set nginx.resources.requests.memory="250Mi" \
               --set nginx.resources.limits.memory="500Mi" \
               stable/artifactory-ha
```
> Artifactory java memory parameters can (and should) also be set to match the allocated resources with `artifactory.[primary|node].javaOpts.xms` and `artifactory.[primary|node].javaOpts.xmx`.

Get more details on configuring Artifactory in the [official documentation](https://www.jfrog.com/confluence/).

### Create Distribution Certificates for Artifactory Enterprise Plus
```bash
# Create private.key and root.crt
$ openssl req -newkey rsa:2048 -nodes -keyout private.key -x509 -days 365 -out root.crt
```

Once Created, Use it to create ConfigMap
```bash
# Create ConfigMap distribution-certs
$ kubectl create configmap distribution-certs --from-file=private.key=private.key --from-file=root.crt=root.crt
```
Pass it to `helm`
```bash
$ helm install --name artifactory --set artifactory.distributionCerts=distribution-certs stable/artifactory-ha
```

### Artifactory storage
Artifactory HA support a wide range of storage back ends. You can see more details on [Artifactory HA storage options](https://www.jfrog.com/confluence/display/RTF/HA+Installation+and+Setup#HAInstallationandSetup-SettingUpYourStorageConfiguration)

In this chart, you set the type of storage you want with `artifactory.persistence.type` and pass the required configuration settings.
The default storage in this chart is the `file-system` replication, where the data is replicated to all nodes.

> **IMPORTANT:** All storage configurations (except NFS) come with a default `artifactory.persistence.redundancy` parameter.
This is used to set how many replicas of a binary should be stored in the cluster's nodes.
Once this value is set on initial deployment, you can not update it using helm.
It is recommended to set this to a number greater than half of your cluster's size, and never scale your cluster down to a size smaller than this number.

#### NFS
To use an NFS server as your cluster's storage, you need to
- Setup an NFS server. Get its IP as `NFS_IP`
- Create a `data` and `backup` directories on the NFS exported directory with write permissions to all
- Pass NFS parameters to `helm install` and `helm upgrade`
```bash
...
--set artifactory.persistence.type=nfs \
--set artifactory.persistence.nfs.ip=${NFS_IP} \
...
```

#### Google Storage
To use a Google Storage bucket as the cluster's filestore
- Pass Google Storage parameters to `helm install` and `helm upgrade`
```bash
...
--set artifactory.persistence.type=google-storage \
--set artifactory.persistence.googleStorage.identity=${GCP_ID} \
--set artifactory.persistence.googleStorage.credential=${GCP_KEY} \
...
```

#### AWS S3
To use an AWS S3 bucket as the cluster's filestore
- Pass AWS S3 parameters to `helm install` and `helm upgrade`
```bash
...
--set artifactory.persistence.type=aws-s3 \
--set artifactory.persistence.awsS3.region=${AWS_REGION} \
--set artifactory.persistence.awsS3.identity=${AWS_ACCESS_KEY_ID} \
--set artifactory.persistence.awsS3.credential=${AWS_SECRET_ACCESS_KEY} \
...
```

### Create a unique Master Key
Artifactory HA cluster requires a unique master key. By default the chart has one set in values.yaml (`artifactory.masterKey`).

**This key is for demo purpose and should not be used in a production environment!**

You should generate a unique one and pass it to the template at install/upgrade time.
```bash
# Create a key
$ export MASTER_KEY=$(openssl rand -hex 32)
$ echo ${MASTER_KEY}

# Pass the created master key to helm
$ helm install --name artifactory-ha --set artifactory.masterKey=${MASTER_KEY} stable/artifactory-ha
```
**NOTE:** Make sure to pass the same master key with `--set artifactory.masterKey=${MASTER_KEY}` on all future calls to `helm install` and `helm upgrade`!

### Install Artifactory HA license
For activating Artifactory HA, you must install an appropriate license. There are two ways to manage the license. **Artifactory UI** or a **Kubernetes Secret**.
The easier and recommended way is the **Artifactory UI**. Using the **Kubernetes Secret** is for advanced users and is better suited for automation.
**IMPORTANT:** You should use only one of the following methods. Switching between them while a cluster is running might disable your Artifactory HA cluster!

##### Artifactory UI
Once primary cluster is running, open Artifactory UI and insert the license(s) in the UI. See [HA installation and setup](https://www.jfrog.com/confluence/display/RTF/HA+Installation+and+Setup) for more details

##### Kubernetes Secret
You can deploy the Artifactory license(s) as a [Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/).
Prepare a text file with the license(s) written in it. If writing multiple licenses, it's important to put **two new lines between each license block**!
```bash
# Create the Kubernetes secret (assuming the local license file is 'art.lic')
$ kubectl create secret generic artifactory-cluster-license --from-file=./art.lic

# Pass the license to helm
$ helm install --name artifactory-ha --set artifactory.license.secret=artifactory-cluster-license,artifactory.license.dataKey=art.lic stable/artifactory-ha
```
**NOTE:** You have to keep passing the license secret parameters as `--set artifactory.license.secret=artifactory-cluster-license,artifactory.license.dataKey=art.lic` on all future calls to `helm install` and `helm upgrade`!

### Bootstrapping Artifactory
**IMPORTANT:** Bootstrapping Artifactory needs license. Pass license as shown in above section.

* User guide to [bootstrap Artifactory Global Configuration](https://www.jfrog.com/confluence/display/RTF/Configuration+Files#ConfigurationFiles-BootstrappingtheGlobalConfiguration)
* User guide to [bootstrap Artifactory Security Configuration](https://www.jfrog.com/confluence/display/RTF/Configuration+Files#ConfigurationFiles-BootstrappingtheSecurityConfiguration)

Create `bootstrap-config.yaml` with artifactory.config.import.xml and security.import.xml as shown below:
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-release-bootstrap-config
data:
  artifactory.config.import.xml: |
    <config contents>
  security.import.xml: |
    <config contents>
```

Create configMap in Kubernetes:
```bash
$ kubectl apply -f bootstrap-config.yaml
```

#### Pass the configMap to helm
```bash
$ helm install --name artifactory-ha --set artifactory.license.secret=artifactory-cluster-license,artifactory.license.dataKey=art.lic,artifactory.configMapName=my-release-bootstrap-config stable/artifactory-ha
```

### Use custom nginx.conf with Nginx

Steps to create configMap with nginx.conf
* Create `nginx.conf` file.
```bash
kubectl create configmap nginx-config --from-file=nginx.conf
```
* Pass configMap to helm install
```bash
helm install --name artifactory-ha --set nginx.customConfigMap=nginx-config stable/artifactory-ha
```

### Scaling your Artifactory cluster
A key feature in Artifactory HA is the ability to set an initial cluster size with `--set artifactory.node.replicaCount=${CLUSTER_SIZE}` and if needed, resize it.

##### Before scaling
**IMPORTANT:** When scaling, you need to explicitly pass the database password if it's an auto generated one (this is the default with the enclosed PostgreSQL helm chart).

Get the current database password
```bash
$ export DB_PASSWORD=$(kubectl get $(kubectl get secret -o name | grep postgresql) -o jsonpath="{.data.postgres-password}" | base64 --decode)
```
Use `--set postgresql.postgresPassword=${DB_PASSWORD}` with every scale action to prevent a miss configured cluster!

##### Scale up
Let's assume you have a cluster with **2** member nodes, and you want to scale up to **3** member nodes (a total of 4 nodes).
```bash
# Scale to 4 nodes (1 primary and 3 member nodes)
$ helm upgrade --install artifactory-ha --set artifactory.node.replicaCount=3 --set postgresql.postgresPassword=${DB_PASSWORD} stable/artifactory-ha
```

##### Scale down
Let's assume you have a cluster with **3** member nodes, and you want to scale down to **2** member node.

```bash
# Scale down to 2 member nodes
$ helm upgrade --install artifactory-ha --set artifactory.node.replicaCount=2 --set postgresql.postgresPassword=${DB_PASSWORD} stable/artifactory-ha
```
- **NOTE:** Since Artifactory is running as a Kubernetes Stateful Set, the removal of the node will **not** remove the persistent volume. You need to explicitly remove it
```bash
# List PVCs
$ kubectl get pvc

# Remove the PVC with highest ordinal!
# In this example, the highest node ordinal was 2, so need to remove its storage.
$ kubectl delete pvc volume-artifactory-node-2
```

### Use an external Database
There are cases where you will want to use a different database and not the enclosed **PostgreSQL**.
See more details on [configuring the database](https://www.jfrog.com/confluence/display/RTF/Configuring+the+Database)
> The official Artifactory Docker images include the PostgreSQL database driver.
> For other database types, you will have to add the relevant database driver to Artifactory's tomcat/lib 

This can be done with the following parameters
```bash
# Make sure your Artifactory Docker image has the MySQL database driver in it
...
--set postgresql.enabled=false \
--set artifactory.postStartCommand="curl -L -o /opt/jfrog/artifactory/tomcat/lib/mysql-connector-java-5.1.41.jar https://jcenter.bintray.com/mysql/mysql-connector-java/5.1.41/mysql-connector-java-5.1.41.jar && chown 1030:1030 /opt/jfrog/artifactory/tomcat/lib/mysql-connector-java-5.1.41.jar" \
--set database.type=mysql \
--set database.host=${DB_HOST} \
--set database.port=${DB_PORT} \
--set database.user=${DB_USER} \
--set database.password=${DB_PASSWORD} \
...
```
**NOTE:** You must set `postgresql.enabled=false` in order for the chart to use the `database.*` parameters. Without it, they will be ignored!

### Deleting Artifactory
To delete the Artifactory HA cluster
```bash
$ helm delete --purge artifactory-ha
```
This will completely delete your Artifactory HA cluster.  
**NOTE:** Since Artifactory is running as Kubernetes Stateful Sets, the removal of the helm release will **not** remove the persistent volumes. You need to explicitly remove them
```bash
$ kubectl delete pvc -l release=artifactory-ha
```
See more details in the official [Kubernetes Stateful Set removal page](https://kubernetes.io/docs/tasks/run-application/delete-stateful-set/)

### Custom Docker registry for your images
If you need to pull your Docker images from a private registry (for example, when you have a custom image with a MySQL database driver), you need to create a 
[Kubernetes Docker registry secret](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) and pass it to helm
```bash
# Create a Docker registry secret called 'regsecret'
$ kubectl create secret docker-registry regsecret --docker-server=${DOCKER_REGISTRY} --docker-username=${DOCKER_USER} --docker-password=${DOCKER_PASS} --docker-email=${DOCKER_EMAIL}
```
Once created, you pass it to `helm`
```bash
$ helm install --name artifactory-ha --set imagePullSecrets=regsecret stable/artifactory-ha
```

## Configuration

The following table lists the configurable parameters of the artifactory chart and their default values.

|         Parameter            |           Description             |                         Default                       |
|------------------------------|-----------------------------------|-------------------------------------------------------|
| `imagePullSecrets`           | Docker registry pull secret       |                                                       |
| `serviceAccount.create`   | Specifies whether a ServiceAccount should be created | `true`                               |
| `serviceAccount.name`     | The name of the ServiceAccount to create             | Generated using the fullname template |
| `rbac.create`             | Specifies whether RBAC resources should be created   | `true`                               |
| `rbac.role.rules`         | Rules to create                   | `[]`                                                     |
| `artifactory.name`                   | Artifactory name                     | `artifactory`                              |
| `artifactory.image.pullPolicy`       | Container pull policy                | `IfNotPresent`                             |
| `artifactory.image.repository`       | Container image                      | `docker.bintray.io/jfrog/artifactory-pro`  |
| `artifactory.image.version`          | Container image tag                  | `6.2.0`                                    |
| `artifactory.masterKey`      | Artifactory Master Key. Can be generated with `openssl rand -hex 32` |`FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF`|
| `artifactory.license.secret` | Artifactory license secret name              |                                            |
| `artifactory.license.dataKey`| Artifactory license secret data key          |                                            |
| `artifactory.service.name`   | Artifactory service name to be set in Nginx configuration | `artifactory`                 |
| `artifactory.service.type`   | Artifactory service type                                  | `ClusterIP`                   |
| `artifactory.service.pool`   | Artifactory instances to be in the load balancing pool. `members` or `all` | `members`    |
| `artifactory.externalPort`   | Artifactory service external port                         | `8081`                        |
| `artifactory.internalPort`   | Artifactory service internal port                         | `8081`                        |
| `artifactory.internalPortReplicator` | Replicator service internal port | `6061`   |
| `artifactory.externalPortReplicator` | Replicator service external port | `6061`   |
| `artifactory.livenessProbe.enabled`              | Enable liveness probe                     |  `true`                                        |
| `artifactory.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated  | 180                                                   |
| `artifactory.livenessProbe.periodSeconds`        | How often to perform the probe            | 10                                                    |
| `artifactory.livenessProbe.timeoutSeconds`       | When the probe times out                  | 10                                                    |
| `artifactory.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed. | 1  |
| `artifactory.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | 10 |
| `artifactory.readinessProbe.enabled`              | would you like a readinessProbe to be enabled           |  `true`                                |
| `artifactory.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated | 60                                                    |
| `artifactory.readinessProbe.periodSeconds`       | How often to perform the probe            | 10                                                    |
| `artifactory.readinessProbe.timeoutSeconds`      | When the probe times out                  | 10                                                    |
| `artifactory.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed. | 1  |
| `artifactory.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | 10 |
| `artifactory.persistence.mountPath`  | Artifactory persistence volume mount path       | `"/var/opt/jfrog/artifactory"`  |
| `artifactory.persistence.enabled`    | Artifactory persistence volume enabled          | `true`                          |
| `artifactory.persistence.accessMode` | Artifactory persistence volume access mode      | `ReadWriteOnce`                 |
| `artifactory.persistence.size`       | Artifactory persistence volume size             | `200Gi`                         |
| `artifactory.persistence.type`       | Artifactory HA storage type                     | `file-system`                   |
| `artifactory.persistence.redundancy` | Artifactory HA storage redundancy               | `3`                             |
| `artifactory.persistence.nfs.ip`            | NFS server IP                        |                                     |
| `artifactory.persistence.nfs.haDataMount`   | NFS data directory                   | `/data`                             |
| `artifactory.persistence.nfs.haBackupMount` | NFS backup directory                 | `/backup`                           |
| `artifactory.persistence.nfs.dataDir`       | HA data directory                    | `/var/opt/jfrog/artifactory-ha`     |
| `artifactory.persistence.nfs.backupDir`     | HA backup directory                  | `/var/opt/jfrog/artifactory-backup` |
| `artifactory.persistence.nfs.capacity`      | NFS PVC size                         | `200Gi`                             |
| `artifactory.persistence.googleStorage.bucketName`  | Google Storage bucket name          | `artifactory-ha`             |
| `artifactory.persistence.googleStorage.identity`    | Google Storage service account id   |                              |
| `artifactory.persistence.googleStorage.credential`  | Google Storage service account key  |                              |
| `artifactory.persistence.googleStorage.path`        | Google Storage path in bucket       | `artifactory-ha/filestore`   |
| `artifactory.persistence.awsS3.bucketName`          | AWS S3 bucket name                  | `artifactory-ha`             |
| `artifactory.persistence.awsS3.region`              | AWS S3 bucket region                |                              |
| `artifactory.persistence.awsS3.identity`            | AWS S3 AWS_ACCESS_KEY_ID            |                              |
| `artifactory.persistence.awsS3.credential`          | AWS S3 AWS_SECRET_ACCESS_KEY        |                              |
| `artifactory.persistence.awsS3.path`                | AWS S3 path in bucket               | `artifactory-ha/filestore`   |
| `artifactory.javaOpts.other` | Artifactory extra java options (for all nodes) | `-Dartifactory.locking.provider.type=db` |
| `artifactory.replicator.enabled`            | Enable Artifactory Replicator | `false`                                    |
| `artifactory.distributionCerts`            | Name of ConfigMap for Artifactory Distribution Certificate  |               |
| `artifactory.replicator.publicUrl`            | Artifactory Replicator Public URL |                                      |
| `artifactory.primary.resources.requests.memory` | Artifactory primary node initial memory request  |                     |
| `artifactory.primary.resources.requests.cpu`    | Artifactory primary node initial cpu request     |                     |
| `artifactory.primary.resources.limits.memory`   | Artifactory primary node memory limit            |                     |
| `artifactory.primary.resources.limits.cpu`      | Artifactory primary node cpu limit               |                     |
| `artifactory.primary.javaOpts.xms`              | Artifactory primary node java Xms size           |                     |
| `artifactory.primary.javaOpts.xmx`              | Artifactory primary node java Xms size           |                     |
| `artifactory.primary.javaOpts.other`            | Artifactory primary node additional java options |                     |
| `artifactory.node.replicaCount`                 | Artifactory member node replica count            | `1`                 |
| `artifactory.node.resources.requests.memory`    | Artifactory member node initial memory request   |                     |
| `artifactory.node.resources.requests.cpu`       | Artifactory member node initial cpu request      |                     |
| `artifactory.node.resources.limits.memory`      | Artifactory member node memory limit             |                     |
| `artifactory.node.resources.limits.cpu`         | Artifactory member node cpu limit                |                     |
| `artifactory.node.javaOpts.xms`                 | Artifactory member node java Xms size            |                     |
| `artifactory.node.javaOpts.xmx`                 | Artifactory member node java Xms size            |                     |
| `artifactory.node.javaOpts.other`               | Artifactory member node additional java options  |                     |
| `ingress.enabled`           | If true, Artifactory Ingress will be created | `false`                                     |
| `ingress.annotations`       | Artifactory Ingress annotations     | `{}`                                                 |
| `ingress.hosts`             | Artifactory Ingress hostnames       | `[]`                                                 |
| `ingress.tls`               | Artifactory Ingress TLS configuration (YAML) | `[]`                                        |
| `nginx.enabled`             | Deploy nginx server                      | `true`                                          |
| `nginx.name`                | Nginx name                        | `nginx`                                                |
| `nginx.replicaCount`        | Nginx replica count               | `1`                                                    |
| `nginx.image.repository`    | Container image                   | `docker.bintray.io/jfrog/nginx-artifactory-pro`        |
| `nginx.image.version`       | Container version                 | `6.2.0`                                                |
| `nginx.image.pullPolicy`    | Container pull policy             | `IfNotPresent`                                         |
| `nginx.service.type`        | Nginx service type                | `LoadBalancer`                                         |
| `nginx.service.loadBalancerSourceRanges`| Nginx service array of IP CIDR ranges to whitelist (only when service type is LoadBalancer) |        |
| `nginx.loadBalancerIP`| Provide Static IP to configure with Nginx |                                 |
| `nginx.externalPortHttp` | Nginx service external port            | `80`                            |
| `nginx.internalPortHttp` | Nginx service internal port            | `80`                            |
| `nginx.externalPortHttps` | Nginx service external port           | `443`                           |
| `nginx.internalPortHttps` | Nginx service internal port           | `443`                           |
| `nginx.internalPortReplicator` | Replicator service internal port | `6061`                          |
| `nginx.externalPortReplicator` | Replicator service external port | `6061`                          |
| `nginx.livenessProbe.enabled`              | would you like a liveness Probe to be enabled          |  `true`                                  |
| `nginx.livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated  | 100                                                   |
| `nginx.livenessProbe.periodSeconds`        | How often to perform the probe            | 10                                                    |
| `nginx.livenessProbe.timeoutSeconds`       | When the probe times out                  | 10                                                    |
| `nginx.livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed. | 1  |
| `nginx.livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | 10 |
| `nginx.readinessProbe.enabled`             | would you like a readinessProbe to be enabled           |  `true`                                 |
| `nginx.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated | 60                                                    |
| `nginx.readinessProbe.periodSeconds`       | How often to perform the probe            | 10                                                    |
| `nginx.readinessProbe.timeoutSeconds`      | When the probe times out                  | 10                                                    |
| `nginx.readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed. | 1  |
| `nginx.readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | 10 |
| `nginx.tlsSecretName` |  SSL secret that will be used by the Nginx pod |                                                 |
| `nginx.env.ssl`                   | Nginx Environment enable ssl               | `true`                                  |
| `nginx.env.skipAutoConfigUpdate`  | Nginx Environment to disable auto configuration update | `false`                     |
| `nginx.customConfigMap`           | Nginx CustomeConfigMap name for `nginx.conf` | ` `                                   |
| `nginx.resources.requests.memory` | Nginx initial memory request               | `250Mi`                                 |
| `nginx.resources.requests.cpu`    | Nginx initial cpu request                  | `100m`                                  |
| `nginx.resources.limits.memory`   | Nginx memory limit                         | `250Mi`                                 |
| `nginx.resources.limits.cpu`      | Nginx cpu limit                            | `500m`                                  |
| `postgresql.enabled`              | Use enclosed PostgreSQL as database        | `true`                                  |
| `postgresql.postgresDatabase`     | PostgreSQL database name                   | `artifactory`                           |
| `postgresql.postgresUser`         | PostgreSQL database user                   | `artifactory`                           |
| `postgresql.postgresPassword`     | PostgreSQL database password               |                                         |
| `postgresql.persistence.enabled`  | PostgreSQL use persistent storage          | `true`                                  |
| `postgresql.persistence.size`     | PostgreSQL persistent storage size         | `50Gi`                                  |
| `postgresql.service.port`         | PostgreSQL database port                   | `5432`                                  |
| `postgresql.resources.requests.memory`    | PostgreSQL initial memory request  |                                         |
| `postgresql.resources.requests.cpu`       | PostgreSQL initial cpu request     |                                         |
| `postgresql.resources.limits.memory`      | PostgreSQL memory limit            |                                         |
| `postgresql.resources.limits.cpu`         | PostgreSQL cpu limit               |                                         |
| `database.type`           | External database type (`postgresql`, `mysql`, `oracle` or `mssql`)  |                       |
| `database.host`           | External database hostname                         |                                         |
| `database.port`           | External database port                             |                                         |
| `database.user`           | External database username                         |                                         |
| `database.password`       | External database password                         |                                         |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

### Ingress and TLS
To get Helm to create an ingress object with a hostname, add these two lines to your Helm command:
```
helm install --name artifactory-ha \
  --set ingress.enabled=true \
  --set ingress.hosts[0]="artifactory.company.com" \
  --set artifactory.service.type=NodePort \
  --set nginx.enabled=false \
  stable/artifactory-ha
```

If your cluster allows automatic creation/retrieval of TLS certificates (e.g. [cert-manager](https://github.com/jetstack/cert-manager)), please refer to the documentation for that mechanism.

To manually configure TLS, first create/retrieve a key & certificate pair for the address(es) you wish to protect. Then create a TLS secret in the namespace:

```console
kubectl create secret tls artifactory-tls --cert=path/to/tls.cert --key=path/to/tls.key
```

Include the secret's name, along with the desired hostnames, in the Artifactory Ingress TLS section of your custom `values.yaml` file:

```
  ingress:
    ## If true, Artifactory Ingress will be created
    ##
    enabled: true

    ## Artifactory Ingress hostnames
    ## Must be provided if Ingress is enabled
    ##
    hosts:
      - artifactory.domain.com
    annotations:
      kubernetes.io/tls-acme: "true"
    ## Artifactory Ingress TLS configuration
    ## Secrets must be manually created in the namespace
    ##
    tls:
      - secretName: artifactory-tls
        hosts:
          - artifactory.domain.com
```


## Useful links
- https://www.jfrog.com/confluence/display/EP/Getting+Started
- https://www.jfrog.com/confluence/display/RTF/Installing+Artifactory
- https://www.jfrog.com/confluence/
