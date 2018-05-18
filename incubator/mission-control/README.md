# JFrog Mission-Control Helm Chart

## Prerequisites Details

* Kubernetes 1.8+

## Chart Details
This chart will do the following:

* Deploy Mongodb database.
* Deploy Elasticsearch.
* Deploy Mission Control.

## Requirements
- A running Kubernetes cluster on GCP
- A running Artifactory Enterprise
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed and setup to use the cluster
- [Helm](https://helm.sh/) installed and setup to use the cluster (helm init)

## Installing the Chart
To install the chart with the release name `mission-control`:
```
helm install --name mission-control incubator/mission-control
```

## Set Mission Control base URL
* Get mission-control url by running following commands:
`export SERVICE_IP=$(kubectl get svc --namespace default mission-control-mission-control -o jsonpath='{.status.loadBalancer.ingress[0].ip}')`

`export MISSION_CONTROL_URL="http://$SERVICE_IP:8080/"`

* Set mission-control by running helm upgrade command:
```
helm upgrade --name mission-control --set missionControl.missionControlUrl=$MISSION_CONTROL_URL incubator/mission-control
```

### Accessing Mission Control
**NOTE:** It might take a few minutes for Mission Control's public IP to become available, and the nodes to complete initial setup.
Follow the instructions outputted by the install command to get the Distribution IP and URL to access it.

### Updating Mission Control
Once you have a new chart version, you can update your deployment with
```
helm upgrade mission-control incubator/mission-control
```

## Configuration

The following table lists the configurable parameters of the distribution chart and their default values.

|         Parameter            |           Description             |                         Default                       |
|------------------------------|-----------------------------------|-------------------------------------------------------|
| `initContainerImage`           | Init Container Image       |     `alpine:3.6`                                           |
| `imagePullPolicy`           | Container pull policy      |                   `IfNotPresent`                                    |
| `global.imagePullSecrets`           | Docker registry pull secret       |                                                       |
| `mongodb.enabled`                   | Enable Mongodb                      | `true`                              |
| `mongodb.image.tag`                   | Mongodb docker image tag                     | `3.6.3`                              |
| `mongodb.image.pullPolicy`                   | Mongodb Container pull policy                      | `IfNotPresent`                              |
| `mongodb.persistence.enabled`    | Mongodb persistence volume enabled          | `true`                          |
| `mongodb.persistence.existingClaim`   | Use an existing PVC to persist data               | `nil`                        |
| `mongodb.persistence.storageClass`    | Storage class of backing PVC                      | `generic`                    |
| `mongodb.persistence.size`       | Mongodb persistence volume size             | `50Gi`                         |
| `mongodb.livenessProbe.initialDelaySeconds` | Mongodb delay before liveness probe is initiated                                                     | `40`                                                       |
| `mongodb.readinessProbe.initialDelaySeconds`| Mongodb delay before readiness probe is initiated                                                    | `30`                                                       |
| `mongodb.mongodbExtraFlags`                 | MongoDB additional command line flags                                                        | `["--wiredTigerCacheSizeGB=1"]`                                                       |
| `mongodb.usePassword`                       | Enable password authentication                                                               | `false`                                                   |
| `mongodb.db.adminUser`                   | Mongodb Database Admin User                     | `admin`                              |
| `mongodb.db.adminPassword`                   | Mongodb Database Password for Admin user                     | `password`                              |
| `mongodb.db.mcUser`                   | Mongodb Database Mission Control User                     | `mission_platform`                              |
| `mongodb.db.mcPassword`                   | Mongodb Database Password for Mission Control user                     | `password`                              |
| `mongodb.db.insightUser`                   | Mongodb Database Insight User                     | `jfrog_insight`                              |
| `mongodb.db.insightPassword`                   | Mongodb Database password for Insight User                     | `password`                              |
| `mongodb.db.insightSchedulerDb`                   | Mongodb Database for Scheduler                    | `insight_scheduler`                              |
| `elasticsearch.enabled`                   | Enable Elasticsearch                      | `true`                              |
| `elasticsearch.persistence.enabled`    | Elasticsearch persistence volume enabled          | `true`                          |
| `elasticsearch.persistence.existingClaim`   | Use an existing PVC to persist data               | `nil`                        |
| `elasticsearch.persistence.storageClass`    | Storage class of backing PVC                      | `generic`                    |
| `elasticsearch.persistence.size`       | Elasticsearch persistence volume size             | `50Gi`                         |
| `missionControl.name`                   | Mission Control name                     | `mission-control`                              |
| `missionControl.replicaCount`       | Mission Control replica count                       | `1`  |
| `missionControl.image`       | Container image                      | `docker.jfrog.io/jfrog/mission-control`  |
| `missionControl.version`          | Container image tag                  | `3.0.0`                                    |
| `missionControl.service.type`   | Mission Control service type                                  | `LoadBalancer`                   |
| `missionControl.externalPort`   | Mission Control service external port                         | `8080`                        |
| `missionControl.internalPort`   | Mission Control service internal port                         | `8080`                        |
| `missionControl.missionControlUrl`    | Mission Control URL               | ` `                                  |
| `missionControl.persistence.mountPath`     | Mission Control persistence volume mount path  | `"/var/opt/jfrog/mission-control"`  |
| `missionControl.persistence.storageClass`  | Storage class of backing PVC                   | `nil (uses alpha storage class annotation)`|
| `missionControl.persistence.existingClaim` | Provide an existing PersistentVolumeClaim    | `nil`                        |
| `missionControl.persistence.enabled`    | Mission Control persistence volume enabled      | `true`                       |
| `missionControl.persistence.accessMode` | Mission Control persistence volume access mode  | `ReadWriteOnce`              |
| `missionControl.persistence.size`       | Mission Control persistence volume size         | `100Gi`                      |
| `missionControl.javaOpts.other`         | Mission Control JAVA_OPTIONS                    | `-server -XX:+UseG1GC -Dfile.encoding=UTF8` |
| `missionControl.javaOpts.xms`           | Mission Control JAVA_OPTIONS -Xms               | `1g`                         |
| `missionControl.javaOpts.xmx`           | Mission Control JAVA_OPTIONS -Xmx               | `2g`                         |
| `insightServer.name`                    | Insight Server name                             | `insight-server`             |
| `insightServer.replicaCount`       | Insight Server replica count                       | `1`  |
| `insightServer.image`       | Container image                      | `docker.jfrog.io/jfrog/insight-server`  |
| `insightServer.version`          | Container image tag                  | `3.0.0`                                    |
| `insightServer.service.type`   | Insight Server service type                                  | `ClusterIP`                   |
| `insightServer.externalHttpPort`   | Insight Server service external port                         | `8082`                        |
| `insightServer.internalHttpPort`   | Insight Server service internal port                         | `8082`                        |
| `insightServer.externalHttpsPort`   | Insight Server service external port                         | `8091`                        |
| `insightServer.internalHttpsPort`   | Insight Server service internal port                         | `8091`                        |
| `insightScheduler.name`                   | Insight Scheduler name                     | `insight-scheduler`                              |
| `insightScheduler.replicaCount`       | Insight Scheduler replica count                       | `1`  |
| `insightScheduler.image`       | Container image                      | `docker.jfrog.io/jfrog/insight-scheduler`  |
| `insightScheduler.version`          | Container image tag                  | `3.0.0`                                    |
| `insightScheduler.service.type`   | Insight Scheduler service type                                  | `ClusterIP`                   |
| `insightScheduler.externalPort`   | Insight Scheduler service external port                         | `8080`                        |
| `insightScheduler.internalPort`   | Insight Scheduler service internal port                         | `8080`                        |
| `insightExecutor.name`                   | Insight Executor name                     | `insight-scheduler`                              |
| `insightExecutor.replicaCount`       | Insight Executor replica count                       | `1`  |
| `insightExecutor.image`       | Container image                      | `docker.jfrog.io/jfrog/insight-executor`  |
| `insightExecutor.version`          | Container image tag                  | `3.0.0`                                    |
| `insightExecutor.service.type`   | Insight Executor service type                                  | `ClusterIP`                   |
| `insightExecutor.externalPort`   | Insight Executor service external port                         | `8080`                        |
| `insightExecutor.internalPort`   | Insight Executor service internal port                         | `8080`                        |
| `insightExecutor.persistence.mountPath`  | Insight Executor persistence volume mount path       | `"/var/cloudbox"`  |
| `insightExecutor.persistence.enabled`    | Insight Executor persistence volume enabled          | `true`                          |
| `insightExecutor.persistence.storageClass` | Storage class of backing PVC | `nil (uses alpha storage class annotation)`   |
| `insightExecutor.persistence.existingClaim` | Provide an existing PersistentVolumeClaim | `nil`   |
| `insightExecutor.persistence.accessMode` | Insight Executor persistence volume access mode      | `ReadWriteOnce`                 |
| `insightExecutor.persistence.size`       | Insight Executor persistence volume size             | `100Gi`                         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.


## Useful links
- https://www.jfrog.com
- https://www.jfrog.com/confluence/
- https://www.jfrog.com/confluence/display/EP/Getting+Started