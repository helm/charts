# JFrog Xray HA on Kubernetes Helm Chart

**Note: This Chart is Deprecated. We have moved it to stable.**

## Prerequisites Details

* Kubernetes 1.8+

## Chart Details
This chart will do the following:

* Optionally deploy PostgreSQL, MongoDB
* Deploy RabbitMQ (optionally as an HA cluster)
* Deploy JFrog Xray micro-services

## Requirements
- A running Kubernetes cluster
  - Dynamic storage provisioning enabled
  - Default StorageClass set to allow services using the default StorageClass for persistent storage
- A running Artifactory
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed and setup to use the cluster
- [Helm](https://helm.sh/) installed and setup to use the cluster (helm init)


## Deploy JFrog Xray
```bash
# cd to directory that includes untar version of helm charts
helm install -n xray --set replicaCount=2,rabbitmq-ha.replicaCount=2,common.masterKey=${MASTER_KEY} incubator/xray

# Passing the imagePullSecrets to authenticate with Bintray and download E+ docker images. 
helm upgrade xray --set replicaCount=3,rabbitmq-ha.replicaCount=3,common.masterKey=${MASTER_KEY} incubator/xray
```

### Deploy Xray
Deploy the Xray tools and services
```bash
# Get required dependency charts
$ helm dependency update incubator/xray

# Deploy Xray
$ helm install -n xray incubator/xray
```

## Status
See the status of your deployed **helm** releases
```bash
$ helm status xray 
```

## Upgrade
To upgrade an existing Xray, you still use **helm**
```bash
# Update existing deployed version to 2.1.0
$ helm upgrade --set common.xrayVersion=2.1.0 incubator/xray
```

## Remove
Removing a **helm** release is done with
```bash
# Remove the Xray services and data tools
$ helm delete --purge xray

# Remove the data disks
$ kubectl delete pvc -l release=xray
```

### Create a unique Master Key
JFrog Xray requires a unique master key to be used by all micro-services in the same cluster. By default the chart has one set in values.yaml (`common.masterKey`).

**This key is for demo purpose and should not be used in a production environment!**

You should generate a unique one and pass it to the template at install/upgrade time.
```bash
# Create a key
$ export MASTER_KEY=$(openssl rand -hex 32)
$ echo ${MASTER_KEY}

# Pass the created master key to helm
$ helm install --set common.masterKey=${MASTER_KEY} -n xray incubator/xray
```
**NOTE:** Make sure to pass the same master key with `--set common.masterKey=${MASTER_KEY}` on all future calls to `helm install` and `helm upgrade`!

## Special deployments
This is a list of special use cases for non-standard deployments

### High Availability
For **high availability** of Xray, just need to set the replica count per pod be equal or higher than **2**. Recommended is **3**.
> It is highly recommended to also set **RabbitMQ** to run as an HA cluster.
```bash
# Start Xray with 3 replicas per service and 3 replicas for RabbitMQ
$ helm install -n xray --set replicaCount=3,rabbitmq-ha.replicaCount=3 incubator/xray
```

### External Databases
There is an option to use external database services (MongoDB or PostgreSQL) for your Xray.

#### MongoDB
To use an external **MongoDB**, You need to set Xray **MongoDB** connection URL.

For this, pass the parameter: `global.mongoUrl=${XRAY_MONGODB_CONN_URL}`.

**IMPORTANT:** Make sure the DB is already created before deploying Xray services
```bash
# Passing a custom MongoDB to Xray

# Example
# MongoDB host: custom-mongodb.local
# MongoDB port: 27017
# MongoDB user: xray
# MongoDB password: password1_X

$ export XRAY_MONGODB_CONN_URL='mongodb://${MONGODB_USER}:${MONGODB_PASSWORD}@custom-mongodb.local:27017/?authSource=${MONGODB_DATABSE}&authMechanism=SCRAM-SHA-1'
$ helm install -n xray --set global.mongoUrl=${XRAY_MONGODB_CONN_URL} incubator/xray
```

#### PostgreSQL
To use an external **PostgreSQL**, You need to disable the use of the bundled **PostgreSQL** and set a custom **PostgreSQL** connection URL.

For this, pass the parameters: `postgresql.enabled=false` and `global.postgresqlUrl=${XRAY_POSTGRESQL_CONN_URL}`.

**IMPORTANT:** Make sure the DB is already created before deploying Xray services
```bash
# Passing a custom PostgreSQL to Xray

# Example
# PostgreSQL host: custom-postgresql.local
# PostgreSQL port: 5432
# PostgreSQL user: xray
# PostgreSQL password: password2_X

$ export XRAY_POSTGRESQL_CONN_URL='postgres://${POSTGRESQL_USER}:${POSTGRESQL_PASSWORD}@custom-postgresql.local:5432/${POSTGRESQL_DATABASE}?sslmode=disable'
$ helm install -n xray --set postgresql.enabled=false,global.postgresqlUrl=${XRAY_POSTGRESQL_CONN_URL} incubator/xray
```

## Configuration

The following table lists the configurable parameters of the artifactory chart and their default values.

|         Parameter            |                    Description                   |           Default                  |
|------------------------------|--------------------------------------------------|------------------------------------|
| `imagePullSecrets`           | Docker registry pull secret                      |                                    |
| `imagePullPolicy`            | Container pull policy                            | `IfNotPresent`                     |
| `initContainerImage`         | Init container image                             | `alpine:3.6`                       |
| `replicaCount`               | Replica count for Xray services                  | `1`                                |
| `postgresql.enabled`              | Use enclosed PostgreSQL as database        | `true`                              |
| `postgresql.postgresDatabase`     | PostgreSQL database name                   | `xraydb`                            |
| `postgresql.postgresUser`         | PostgreSQL database user                   | `xray`                              |
| `postgresql.postgresPassword`     | PostgreSQL database password               | ` `                                 |
| `postgresql.persistence.enabled`  | PostgreSQL use persistent storage          | `true`                              |
| `postgresql.persistence.size`     | PostgreSQL persistent storage size         | `50Gi`                              |
| `postgresql.persistence.existingClaim`  | PostgreSQL use existing persistent storage          | ` `                  |
| `postgresql.service.port`         | PostgreSQL database port                   | `5432`                              |
| `postgresql.resources.requests.memory`    | PostgreSQL initial memory request  |                                     |
| `postgresql.resources.requests.cpu`       | PostgreSQL initial cpu request     |                                     |
| `postgresql.resources.limits.memory`      | PostgreSQL memory limit            |                                     |
| `postgresql.resources.limits.cpu`         | PostgreSQL cpu limit               |                                     |
| `mongodb.enabled`                         | Enable Mongodb                     | `true`                              |
| `mongodb.image.tag`                       | Mongodb docker image tag           | `3.6.3`                             |
| `mongodb.image.pullPolicy`                | Mongodb Container pull policy      | `IfNotPresent`                      |
| `mongodb.persistence.enabled`    | Mongodb persistence volume enabled          | `true`                              |
| `mongodb.persistence.existingClaim`   | Use an existing PVC to persist data               | `nil`                    |
| `mongodb.persistence.storageClass`    | Storage class of backing PVC                      | `generic`                |
| `mongodb.persistence.size`            | Mongodb persistence volume size             | `50Gi`                         |
| `mongodb.livenessProbe.initialDelaySeconds` | Mongodb delay before liveness probe is initiated   | ` `               |
| `mongodb.readinessProbe.initialDelaySeconds`| Mongodb delay before readiness probe is initiated  | ` `               |
| `mongodb.mongodbExtraFlags`                 | MongoDB additional command line flags | `["--wiredTigerCacheSizeGB=1"]`|
| `mongodb.mongodbDatabase`                   | Mongodb Database for Xray                       | `xray`               |
| `mongodb.mongodbRootPassword`                  | Mongodb Database Password for root user      | ` `           |
| `mongodb.mongodbUsername`                      | Mongodb Database Xray User                   | `admin`              |
| `mongodb.mongodbPassword`                      | Mongodb Database Password for Xray User      | ` `           |
| `rabbitmq-ha.replicaCount`                     | RabbitMQ Number of replica                   | `1`                  |
| `rabbitmq-ha.rabbitmqUsername`                 | RabbitMQ application username                | `guest`              |
| `rabbitmq-ha.rabbitmqPassword`                 | RabbitMQ application password                | ` `              |
| `rabbitmq-ha.customConfigMap`                  | RabbitMQ Use a custom ConfigMap              | `true`               |
| `rabbitmq-ha.rabbitmqErlangCookie`             | RabbitMQ Erlang cookie                       | `XRAYRABBITMQCLUSTER`|
| `rabbitmq-ha.rabbitmqMemoryHighWatermark`      | RabbitMQ Memory high watermark               | `500MB`              |
| `rabbitmq-ha.persistentVolume.enabled`         | If `true`, persistent volume claims are created | `true`            |
| `rabbitmq-ha.persistentVolume.size`            | RabbitMQ Persistent volume size              | `20Gi`               |
| `rabbitmq-ha.rbac.create`                      | If true, create & use RBAC resources         | `false`              |
| `common.xrayVersion`                           | Xray image tag                               | `2.1.0`              |
| `common.xrayConfigPath`                        | Xray config path                   | `/var/opt/jfrog/xray/data`     |
| `common.xrayUserId`                            | Xray User Id                                 | `1035`               |
| `common.xrayGroupId`                           | Xray Group Id                                | `1035`               |
| `common.stdOutEnabled`                         | Xray enable standard output                  | `true`               |
| `common.masterKey`  | Xray Master Key Can be generated with `openssl rand -hex 32` | `FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF` |
| `global.mongoUrl`                              | Xray external MongoDB URL                    | ` `                  |
| `global.postgresqlUrl`                         | Xray external PostgreSQL URL                | ` `                  |
| `analysis.name`                                | Xray Analysis name                           | `xray-analysis`      |
| `analysis.image`                               | Xray Analysis container image                | `docker.bintray.io/jfrog/xray-analysis` |
| `analysis.internalPort`                        | Xray Analysis internal port                  | `7000`               |
| `analysis.externalPort`                        | Xray Analysis external port                  | `7000`               |
| `analysis.service.type`                        | Xray Analysis service type                   | `ClusterIP`          |
| `analysis.storage.sizeLimit`                   | Xray Analysis storage size limit             | `10Gi`               |
| `analysis.resources`                           | Xray Analysis resources                      | `{}`                 |
| `indexer.name`                                 | Xray Indexer name                            | `xray-indexer`       |
| `indexer.image`                                | Xray Indexer container image                 | `docker.bintray.io/jfrog/xray-indexer`  |
| `indexer.internalPort`                         | Xray Indexer internal port                   | `7002`               |
| `indexer.externalPort`                         | Xray Indexer external port                   | `7002`               |
| `indexer.service.type`                         | Xray Indexer service type                    | `ClusterIP`          |
| `indexer.storage.sizeLimit`                    | Xray Indexer storage size limit              | `10Gi`               |
| `indexer.resources`                            | Xray Indexer resources                       | `{}`                 |
| `persist.name`                                 | Xray Persist name                            | `xray-persist`       |
| `persist.image`                                | Xray Persist container image                 | `docker.bintray.io/jfrog/xray-persist`  |
| `persist.internalPort`                         | Xray Persist internal port                   | `7003`               |
| `persist.externalPort`                         | Xray Persist external port                   | `7003`               |
| `persist.service.type`                         | Xray Persist service type                    | `ClusterIP`          |
| `persist.storage.sizeLimit`                    | Xray Persist storage size limit              | `10Gi`               |
| `persist.resources`                            | Xray Persist resources                       | `{}`                 |
| `server.name`                                  | Xray server name                             | `xray-server`        |
| `server.image`                                 | Xray server container image                  | `docker.bintray.io/jfrog/xray-server`   |
| `server.internalPort`                          | Xray server internal port                    | `8000`               |
| `server.externalPort`                          | Xray server external port                    | `80`                 |
| `server.service.name`                          | Xray server service name                     | `xray`               |
| `server.service.type`                          | Xray server service type                     | `LoadBalancer`       |
| `server.storage.sizeLimit`                     | Xray server storage size limit               | `10Gi`               |
| `server.resources`                             | Xray server resources                        | `{}`                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Useful links
- https://www.jfrog.com/confluence/display/XRAY/Xray+High+Availability
- https://www.jfrog.com/confluence/display/EP/Getting+Started
- https://www.jfrog.com/confluence/
