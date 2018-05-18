# JFrog Xray HA on Kubernetes Helm Chart

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

$ export XRAY_MONGODB_CONN_URL='mongodb://xray:password1_X@custom-mongodb.local:27017/?authSource=xray&authMechanism=SCRAM-SHA-1'
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

$ export XRAY_POSTGRESQL_CONN_URL='postgres://xray:password2_X@custom-postgresql.local:5432/xraydb?sslmode=disable'
$ helm install -n xray --set postgresql.enabled=false,global.postgresqlUrl=${XRAY_POSTGRESQL_CONN_URL} incubator/xray
```

## Useful links
- https://www.jfrog.com/confluence/display/XRAY/Xray+High+Availability
- https://www.jfrog.com/confluence/display/EP/Getting+Started
- https://www.jfrog.com/confluence/