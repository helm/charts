# MongoDB

[MongoDB](https://www.mongodb.com/) is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas, making the integration of data in certain types of applications easier and faster.

## TL;DR;

```bash
$ helm install stable/mongodb
```

## Introduction

This chart bootstraps a [MongoDB](https://github.com/bitnami/bitnami-docker-mongodb) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/mongodb
```

The command deploys MongoDB on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the MongoDB chart and their default values.

|         Parameter                       |             Description                                                                      |                         Default                          |
|-----------------------------------------|----------------------------------------------------------------------------------------------|----------------------------------------------------------|
| `image.registry`                        | MongoDB image registry                                                                       | `docker.io`                                              |
| `image.repository`                      | MongoDB Image name                                                                           | `bitnami/mongodb`                                        |
| `image.tag`                             | MongoDB Image tag                                                                            | `{VERSION}`                                              |
| `image.pullPolicy`                      | Image pull policy                                                                            | `Always`                                                 |
| `image.pullSecrets`                     | Specify image pull secrets                                                                   | `nil`                                                    |
| `usePassword`                           | Enable password authentication                                                               | `true`                                                   |
| `existingSecret`                        | Existing secret with MongoDB credentials                                                     | `nil`                                                    |
| `mongodbRootPassword`                   | MongoDB admin password                                                                       | `random alhpanumeric string (10)`                        |
| `mongodbUsername`                       | MongoDB custom user                                                                          | `nil`                                                    |
| `mongodbPassword`                       | MongoDB custom user password                                                                 | `random alhpanumeric string (10)`                        |
| `mongodbDatabase`                       | Database to create                                                                           | `nil`                                                    |
| `mongodbEnableIPv6`                     | Switch to enable/disable IPv6 on MongoDB                                                     | `true`                                                   |
| `mongodbExtraFlags`                     | MongoDB additional command line flags                                                        | []                                                       |
| `service.annotations`                   | Kubernetes service annotations                                                               | `{}`                                                     |
| `service.type`                          | Kubernetes Service type                                                                      | `ClusterIP`                                              |
| `service.nodePort`                      | Port to bind to for NodePort service type                                                    | `nil`                                                    |
| `port`                                  | MongoDB service port                                                                         | `27017`                                                  |
| `replicaSet.enabled`                    | Switch to enable/disable replica set configuration                                           | `false`                                                  |
| `replicaSet.name`                       | Name of the replica set                                                                      | `rs0`                                                    |
| `replicaSet.useHostnames`               | Enable DNS hostnames in the replica set config                                               | `true` |
| `replicaSet.key`                        | Key used for authentication in the replica set                                               | `nil`                                                    |
| `replicaSet.replicas.secondary`         | Number of secondary nodes in the replica set                                                 | `1`                                                      |
| `replicaSet.replicas.arbiter`           | Number of arbiter nodes in the replica set                                                   | `1`                                                      |
| `replicaSet.pdb.minAvailable.primary`   | PDB for the MongoDB Primary nodes                                                            | `1`                                                      |
| `replicaSet.pdb.minAvailable.secondary` | PDB for the MongoDB Secondary nodes                                                          | `1`                                                      |
| `replicaSet.pdb.minAvailable.arbiter`   | PDB for the MongoDB Arbiter nodes                                                            | `1`                                                      |
| `podAnnotations`                        | Annotations to be added to pods                                                              | {}                                                       |
| `resources`                             | Pod resources                                                                                | {}                                                       |
| `nodeSelector`                          | Node labels for pod assignment                                                               | {}                                                       |
| `affinity`                              | Affinity for pod assignment                                                                  | {}                                                       |
| `tolerations`                           | Toleration labels for pod assignment                                                         | {}                                                       |
| `securityContext.enabled`               | Enable security context                                                                      | `true`                                                   |
| `securityContext.fsGroup`               | Group ID for the container                                                                   | `1001`                                                   |
| `securityContext.runAsUser`             | User ID for the container                                                                    | `1001`                                                   |
| `persistence.enabled`                   | Use a PVC to persist data                                                                    | `true`                                                   |
| `persistence.storageClass`              | Storage class of backing PVC                                                                 | `nil` (uses alpha storage class annotation)              |
| `persistence.accessMode`                | Use volume as ReadOnly or ReadWrite                                                          | `ReadWriteOnce`                                          |
| `persistence.size`                      | Size of data volume                                                                          | `8Gi`                                                    |
| `persistence.annotations`               | Persistent Volume annotations                                                                | `{}`                                                     |
| `persistence.existingClaim`             | Name of an existing PVC to use (avoids creating one if this is given)                        | `nil`                                                    |
| `livenessProbe.initialDelaySeconds`     | Delay before liveness probe is initiated                                                     | `30`                                                     |
| `livenessProbe.periodSeconds`           | How often to perform the probe                                                               | `10`                                                     |
| `livenessProbe.timeoutSeconds`          | When the probe times out                                                                     | `5`                                                      |
| `livenessProbe.successThreshold`        | Minimum consecutive successes for the probe to be considered successful after having failed. | `1`                                                      |
| `livenessProbe.failureThreshold`        | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | `6`                                                      |
| `readinessProbe.initialDelaySeconds`    | Delay before readiness probe is initiated                                                    | `5`                                                      |
| `readinessProbe.periodSeconds`          | How often to perform the probe                                                               | `10`                                                     |
| `readinessProbe.timeoutSeconds`         | When the probe times out                                                                     | `5`                                                      |
| `readinessProbe.failureThreshold`       | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | `6`                                                      |
| `readinessProbe.successThreshold`       | Minimum consecutive successes for the probe to be considered successful after having failed. | `1`                                                      |
| `configmap`                             | MongoDB configuration file to be used                                                        | `nil`                                                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set mongodbRootPassword=secretpassword,mongodbUsername=my-user,mongodbPassword=my-password,mongodbDatabase=my-database \
    stable/mongodb
```

The above command sets the MongoDB `root` account password to `secretpassword`. Additionally, it creates a standard database user named `my-user`, with the password `my-password`, who has access to a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/mongodb
```
> **Tip**: You can use the default [values.yaml](values.yaml)

## Replication

You can start the MongoDB chart in replica set mode with the following command:

```bash
$ helm install --name my-release stable/mongodb --set replication.enabled=true
```
## Production settings and horizontal scaling

The [values-production.yaml](values-production.yaml) file consists a configuration to deploy a scalable and high-available MongoDB deployment for production environments. We recommend that you base your production configuration on this template and adjust the parameters appropriately.

```console
$ curl -O https://raw.githubusercontent.com/kubernetes/charts/master/stable/mongodb/values-production.yaml
$ helm install --name my-release -f ./values-production.yaml stable/mongodb
```

To horizontally scale this chart, run the following command to scale the number of secondary nodes in your MongoDB replica set.

```console
$ kubectl scale statefulset my-release-mongodb-secondary --replicas=3
```

Some characteristics of this chart are:

* Each of the participants in the replication has a fixed stateful set so you always know where to find the primary, secondary or arbiter nodes.
* The number of secondary and arbiter nodes can be scaled out independently.
* Easy to move an application from using a standalone MongoDB server to use a replica set.

## Initialize a fresh instance

The [Bitnami MongoDB](https://github.com/bitnami/bitnami-docker-mongodb) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, they must be located inside the chart folder `files/docker-entrypoint-initdb.d` so they can be consumed as a ConfigMap.

The allowed extensions are `.sh`, and `.js`.

## Persistence

The [Bitnami MongoDB](https://github.com/bitnami/bitnami-docker-mongodb) image stores the MongoDB data and configurations at the `/bitnami/mongodb` path of the container.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.
