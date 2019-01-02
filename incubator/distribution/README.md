# JFrog Distribution Helm Chart

**Note: This Chart is Deprecated. We have moved it to stable.**

## Prerequisites Details

* Kubernetes 1.8+

## Chart Details
This chart will do the following:

* Deploy Mongodb database.
* Deploy a Redis.
* Deploy a distributor.
* Deploy a distribution.

## Requirements
- A running Kubernetes cluster
- Dynamic storage provisioning enabled
- Default StorageClass set to allow services using the default StorageClass for persistent storage
- A running Artifactory Enterprise Plus
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed and setup to use the cluster
- [Helm](https://helm.sh/) installed and setup to use the cluster (helm init)

## Installing the Chart
To install the chart with the release name `distribution`:
```
helm install --name distribution incubator/distribution
```

### Accessing Distribution
**NOTE:** It might take a few minutes for Distribution's public IP to become available, and the nodes to complete initial setup.
Follow the instructions outputted by the install command to get the Distribution IP and URL to access it.

### Updating Distribution
Once you have a new chart version, you can update your deployment with
```
helm upgrade distribution incubator/distribution
```

## Configuration

The following table lists the configurable parameters of the distribution chart and their default values.

|         Parameter                            |           Description                      |               Default              |
|----------------------------------------------|--------------------------------------------|------------------------------------|
| `imagePullSecrets`                           | Docker registry pull secret                |                                    |
| `mongodb.enabled`                            | Enable Mongodb                             | `true`                             |
| `mongodb.image.tag`                          | Mongodb docker image tag                   | `3.6.3`                            |
| `mongodb.image.pullPolicy`                   | Mongodb Container pull policy              | `IfNotPresent`                     |
| `mongodb.persistence.enabled`                | Mongodb persistence volume enabled         | `true`                             |
| `mongodb.persistence.existingClaim`          | Use an existing PVC to persist data        | `nil`                              |
| `mongodb.persistence.storageClass`           | Storage class of backing PVC               | `generic`                          |
| `mongodb.persistence.size`                   | Mongodb persistence volume size            | `10Gi`                             |
| `mongodb.livenessProbe.initialDelaySeconds`  | Mongodb delay before liveness probe is initiated    | `40`                      |
| `mongodb.readinessProbe.initialDelaySeconds` | Mongodb delay before readiness probe is initiated   | `30`                      |
| `mongodb.mongodbExtraFlags`                  | MongoDB additional command line flags      | `["--wiredTigerCacheSizeGB=1"]`    |
| `mongodb.usePassword`                        | Enable password authentication             | `false`                            |
| `mongodb.mongodbDatabase`                    | Mongodb Database for distribution          | `bintray`                          |
| `mongodb.mongodbRootPassword`                | Mongodb Database Password for root user    | ` `                                |
| `mongodb.mongodbUsername`                    | Mongodb Database Mission Control User      | `distribution`                     |
| `mongodb.mongodbPassword`                    | Mongodb Database Password for Mission Control user  | ` `                       |
| `redis.enabled`                              | Enable Redis                               | `true`                             |
| `redis.redisPassword`                        | Redis password                             | ` `                                |
| `redis.master.port`                          | Redis Port                                 | `6379`                             |
| `redis.persistence.enabled`                  | Use a PVC to persist data                  | `true`                             |
| `redis.persistence.existingClaim`            | Use an existing PVC to persist data        | `nil`                              |
| `redis.persistence.storageClass`             | Storage class of backing PVC               | `generic`                          |
| `redis.persistence.size`                     | Size of data volume                        | `10Gi`                             |
| `distribution.name`                          | Distribution name                          | `distribution`                     |
| `distribution.image.pullPolicy`              | Container pull policy                      | `IfNotPresent`                     |
| `distribution.image.repository`              | Container image                            | `docker.jfrog.io/jf-distribution`  |
| `distribution.image.version`                 | Container image tag                        | `1.0.0`                            |
| `distribution.service.type`                  | Distribution service type                  | `LoadBalancer`                     |
| `distribution.externalPort`                  | Distribution service external port         | `80`                               |
| `distribution.internalPort`                  | Distribution service internal port         | `8080`                             |
| `distribution.env.artifactoryUrl`            | Distribution Environment Artifactory URL   | ` `                                |
| `distribution.persistence.mountPath`         | Distribution persistence volume mount path | `"/jf-distribution"`               |
| `distribution.persistence.enabled`           | Distribution persistence volume enabled    | `true`                             |
| `distribution.persistence.storageClass`      | Storage class of backing PVC               | `nil`                              |
| `distribution.persistence.existingClaim`     | Provide an existing PersistentVolumeClaim  | `nil`                              |
| `distribution.persistence.accessMode`        | Distribution persistence volume access mode| `ReadWriteOnce`                    |
| `distribution.persistence.size`              | Distribution persistence volume size       | `50Gi`                             |
| `distributor.name`                           | Distribution name                          | `distribution`                     |
| `distributor.image.pullPolicy`               | Container pull policy                      | `IfNotPresent`                     |
| `distributor.image.repository`               | Container image                            | `docker.jfrog.io/jf-distribution`  |
| `distributor.image.version`                  | Container image tag                        | `1.0.0`                            |
| `distributor.token`                          | Distributor token                          | ` `                                |
| `distributor.persistence.mountPath`          | Distributor persistence volume mount path  | `"/bt-distributor"`                |
| `distributor.persistence.existingClaim`      | Provide an existing PersistentVolumeClaim  | `nil`                              |
| `distributor.persistence.storageClass`       | Storage class of backing PVC | `nil (uses alpha storage class annotation)`      |
| `distributor.persistence.enabled`            | Distributor persistence volume enabled     | `true`                             |
| `distributor.persistence.accessMode`         | Distributor persistence volume access mode | `ReadWriteOnce`                    |
| `distributor.persistence.size`               | Distributor persistence volume size        | `50Gi`                             |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Useful links
- https://www.jfrog.com/confluence/display/EP/Getting+Started
- https://www.jfrog.com/confluence/display/DIST/Installing+Distribution
- https://www.jfrog.com/confluence/
