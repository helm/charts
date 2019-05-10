# MongoDB

[MongoDB](https://www.mongodb.com/) is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas, making the integration of data in certain types of applications easier and faster.

## TL;DR;

```bash
$ helm install stable/mongodb
```

## Introduction

This chart bootstraps a [MongoDB](https://github.com/bitnami/bitnami-docker-mongodb) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

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

| Parameter                                          | Description                                                                                  | Default                                                 |
| -------------------------------------------------- | -------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `global.imageRegistry`                             | Global Docker image registry                                                                 | `nil`                                                   |
| `global.imagePullSecrets`                          | Global Docker registry secret names as an array                                              | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`                                   | MongoDB image registry                                                                       | `docker.io`                                             |
| `image.repository`                                 | MongoDB Image name                                                                           | `bitnami/mongodb`                                       |
| `image.tag`                                        | MongoDB Image tag                                                                            | `{VERSION}`                                             |
| `image.pullPolicy`                                 | Image pull policy                                                                            | `Always`                                                |
| `image.pullSecrets`                                | Specify docker-registry secret names as an array                                             | `[]` (does not add image pull secrets to deployed pods) |
| `image.debug`                                      | Specify if debug logs should be enabled                                                      | `false`                                                 |
| `clusterDomain`                                      | Default Kubernetes cluster domain                                                               | `cluster.local`                                                  |
| `usePassword`                                      | Enable password authentication                                                               | `true`                                                  |
| `existingSecret`                                   | Existing secret with MongoDB credentials                                                     | `nil`                                                   |
| `mongodbRootPassword`                              | MongoDB admin password                                                                       | `random alphanumeric string (10)`                       |
| `mongodbUsername`                                  | MongoDB custom user                                                                          | `nil`                                                   |
| `mongodbPassword`                                  | MongoDB custom user password                                                                 | `random alphanumeric string (10)`                       |
| `mongodbDatabase`                                  | Database to create                                                                           | `nil`                                                   |
| `mongodbEnableIPv6`                                | Switch to enable/disable IPv6 on MongoDB                                                     | `true`                                                  |
| `mongodbDirectoryPerDB`                            | Switch to enable/disable DirectoryPerDB on MongoDB                                           | `false`                                                 |
| `mongodbSystemLogVerbosity`                        | MongoDB systen log verbosity level                                                           | `0`                                                     |
| `mongodbDisableSystemLog`                          | Whether to disable MongoDB system log or not                                                 | `false`                                                 |
| `mongodbExtraFlags`                                | MongoDB additional command line flags                                                        | []                                                      |
| `service.annotations`                              | Kubernetes service annotations                                                               | `{}`                                                    |
| `service.type`                                     | Kubernetes Service type                                                                      | `ClusterIP`                                             |
| `service.clusterIP`                                | Static clusterIP or None for headless services                                               | `nil`                                                   |
| `service.nodePort`                                 | Port to bind to for NodePort service type                                                    | `nil`                                                   |
| `service.loadBalancerIP`                           | Static IP Address to use for LoadBalancer service type                                       | `nil`                                                   |
| `service.externalIPs`                              | External IP list to use with ClusterIP service type                                          | []                                                      |
| `port`                                             | MongoDB service port                                                                         | `27017`                                                 |
| `replicaSet.enabled`                               | Switch to enable/disable replica set configuration                                           | `false`                                                 |
| `replicaSet.name`                                  | Name of the replica set                                                                      | `rs0`                                                   |
| `replicaSet.useHostnames`                          | Enable DNS hostnames in the replica set config                                               | `true`                                                  |
| `replicaSet.key`                                   | Key used for authentication in the replica set                                               | `nil`                                                   |
| `replicaSet.replicas.secondary`                    | Number of secondary nodes in the replica set                                                 | `1`                                                     |
| `replicaSet.replicas.arbiter`                      | Number of arbiter nodes in the replica set                                                   | `1`                                                     |
| `replicaSet.pdb.minAvailable.primary`              | PDB for the MongoDB Primary nodes                                                            | `1`                                                     |
| `replicaSet.pdb.minAvailable.secondary`            | PDB for the MongoDB Secondary nodes                                                          | `1`                                                     |
| `replicaSet.pdb.minAvailable.arbiter`              | PDB for the MongoDB Arbiter nodes                                                            | `1`                                                     |
| `podAnnotations`                                   | Annotations to be added to pods                                                              | {}                                                      |
| `podLabels`                                        | Additional labels for the pod(s).                                                            | {}                                                      |
| `resources`                                        | Pod resources                                                                                | {}                                                      |
| `priorityClassName`                                | Pod priority class name                                                                      | ``                                                      |
| `nodeSelector`                                     | Node labels for pod assignment                                                               | {}                                                      |
| `affinity`                                         | Affinity for pod assignment                                                                  | {}                                                      |
| `tolerations`                                      | Toleration labels for pod assignment                                                         | {}                                                      |
| `updateStrategy`                                   | Statefulsets update strategy policy                                                          | `RollingUpdate`                                         |
| `securityContext.enabled`                          | Enable security context                                                                      | `true`                                                  |
| `securityContext.fsGroup`                          | Group ID for the container                                                                   | `1001`                                                  |
| `securityContext.runAsUser`                        | User ID for the container                                                                    | `1001`                                                  |
| `persistence.enabled`                              | Use a PVC to persist data                                                                    | `true`                                                  |
| `persistence.mountPath`                            | Path to mount the volume at                                                                  | `/bitnami/mongodb`                                      |
| `persistence.subPath`                              | Subdirectory of the volume to mount at                                                       | `""`                                                     |
| `persistence.storageClass`                         | Storage class of backing PVC                                                                 | `nil` (uses alpha storage class annotation)             |
| `persistence.accessMode`                           | Use volume as ReadOnly or ReadWrite                                                          | `ReadWriteOnce`                                         |
| `persistence.size`                                 | Size of data volume                                                                          | `8Gi`                                                   |
| `persistence.annotations`                          | Persistent Volume annotations                                                                | `{}`                                                    |
| `persistence.existingClaim`                        | Name of an existing PVC to use (avoids creating one if this is given)                        | `nil`                                                   |
| `extraInitContainers`                              | Additional init containers as a string to be passed to the `tpl` function                    | `{}`                                                    |                                                   |
| `livenessProbe.enabled`                            | Enable/disable the Liveness probe                                                            | `true`                                                  |
| `livenessProbe.initialDelaySeconds`                | Delay before liveness probe is initiated                                                     | `30`                                                    |
| `livenessProbe.periodSeconds`                      | How often to perform the probe                                                               | `10`                                                    |
| `livenessProbe.timeoutSeconds`                     | When the probe times out                                                                     | `5`                                                     |
| `livenessProbe.successThreshold`                   | Minimum consecutive successes for the probe to be considered successful after having failed. | `1`                                                     |
| `livenessProbe.failureThreshold`                   | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | `6`                                                     |
| `readinessProbe.enabled`                           | Enable/disable the Readiness probe                                                           | `true`                                                  |
| `readinessProbe.initialDelaySeconds`               | Delay before readiness probe is initiated                                                    | `5`                                                     |
| `readinessProbe.periodSeconds`                     | How often to perform the probe                                                               | `10`                                                    |
| `readinessProbe.timeoutSeconds`                    | When the probe times out                                                                     | `5`                                                     |
| `readinessProbe.failureThreshold`                  | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | `6`                                                     |
| `readinessProbe.successThreshold`                  | Minimum consecutive successes for the probe to be considered successful after having failed. | `1`                                                     |
| `initConfigMap.name`                               | Custom config map with init scripts                                                          | `nil`                                                   |
| `configmap`                                        | MongoDB configuration file to be used                                                        | `nil`                                                   |
| `ingress.enabled`                                  | Enables Ingress. Tested with nginx-ingress version `1.3.1`                                   | `false`                                                 |
| `ingress.annotations`                              | Ingress annotations                                                                          | `{}`                                                    |
| `ingress.labels`                                   | Custom labels                                                                                | `{}`                                                    |
| `ingress.hosts`                                    | Ingress accepted hostnames                                                                   | `[]`                                                    |
| `ingress.tls`                                      | Ingress TLS configuration                                                                    | `[]`                                                    |
| `metrics.enabled`                                  | Start a side-car prometheus exporter                                                         | `false`                                                 |
| `metrics.image.registry`                           | MongoDB exporter image registry                                                              | `docker.io`                                             |
| `metrics.image.repository`                         | MongoDB exporter image name                                                                  | `forekshub/percona-mongodb-exporter`                    |
| `metrics.image.tag`                                | MongoDB exporter image tag                                                                   | `latest`                                                |
| `metrics.image.pullPolicy`                         | Image pull policy                                                                            | `IfNotPresent`                                          |
| `metrics.image.pullSecrets`                        | Specify docker-registry secret names as an array                                             | `[]` (does not add image pull secrets to deployed pods) |
| `metrics.podAnnotations`                           | Additional annotations for Metrics exporter pod                                              | {}                                                      |
| `metrics.extraArgs`               | String with extra arguments for the MongoDB Exporter                                                          | ``                                                      |
| `metrics.resources`                                | Exporter resource requests/limit                                                             | Memory: `256Mi`, CPU: `100m`                            |
| `metrics.serviceMonitor.enabled`                   | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                 | `false`                                                 |
| `metrics.serviceMonitor.additionalLabels`          | Used to pass Labels that are required by the Installed Prometheus Operator                   | {}                                                      |
| `metrics.serviceMonitor.relabellings`              | Specify Metric Relabellings to add to the scrape endpoint                                    | `nil`                                                   |
| `metrics.serviceMonitor.alerting.rules`            | Define individual alerting rules as required                                                 | {}                                                      |
| `metrics.serviceMonitor.alerting.additionalLabels` | Used to pass Labels that are required by the Installed Prometheus Operator                   | {}                                                      |
| `metrics.livenessProbe.enabled`                    | Enable/disable the Liveness Check of Prometheus metrics exporter                             | `false`                                                 |
| `metrics.livenessProbe.initialDelaySeconds`        | Initial Delay for Liveness Check of Prometheus metrics exporter                              | `15`                                                    |
| `metrics.livenessProbe.periodSeconds`              | How often to perform Liveness Check of Prometheus metrics exporter                           | `10`                                                    |
| `metrics.livenessProbe.timeoutSeconds`             | Timeout for Liveness Check of Prometheus metrics exporter                                    | `5`                                                     |
| `metrics.livenessProbe.failureThreshold`           | Failure Threshold for Liveness Check of Prometheus metrics exporter                          | `3`                                                     |
| `metrics.livenessProbe.successThreshold`           | Success Threshold for Liveness Check of Prometheus metrics exporter                          | `1`                                                     |
| `metrics.readinessProbe.enabled`                   | Enable/disable the Readiness Check of Prometheus metrics exporter                            | `false`                                                 |
| `metrics.readinessProbe.initialDelaySeconds`       | Initial Delay for Readiness Check of Prometheus metrics exporter                             | `5`                                                     |
| `metrics.readinessProbe.periodSeconds`             | How often to perform Readiness Check of Prometheus metrics exporter                          | `10`                                                    |
| `metrics.readinessProbe.timeoutSeconds`            | Timeout for Readiness Check of Prometheus metrics exporter                                   | `1`                                                     |
| `metrics.readinessProbe.failureThreshold`           | Failure Threshold for Readiness Check of Prometheus metrics exporter                        | `3`                                                     |
| `metrics.readinessProbe.successThreshold`           | Success Threshold for Readiness Check of Prometheus metrics exporter                        | `1`                                                     |


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
$ helm install --name my-release stable/mongodb --set replicaSet.enabled=true
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

- Each of the participants in the replication has a fixed stateful set so you always know where to find the primary, secondary or arbiter nodes.
- The number of secondary and arbiter nodes can be scaled out independently.
- Easy to move an application from using a standalone MongoDB server to use a replica set.

## Initialize a fresh instance

The [Bitnami MongoDB](https://github.com/bitnami/bitnami-docker-mongodb) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, they must be located inside the chart folder `files/docker-entrypoint-initdb.d` so they can be consumed as a ConfigMap.
Also you can create a custom config map and give it via `initConfigMap`(check options for more details).

The allowed extensions are `.sh`, and `.js`.

## Persistence

The [Bitnami MongoDB](https://github.com/bitnami/bitnami-docker-mongodb) image stores the MongoDB data and configurations at the `/bitnami/mongodb` path of the container.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning.

## Upgrading

### To 5.0.0

When enabling replicaset configuration, backwards compatibility is not guaranteed unless you modify the labels used on the chart's statefulsets.
Use the workaround below to upgrade from versions previous to 5.0.0. The following example assumes that the release name is `my-release`:

```consoloe
$ kubectl delete statefulset my-release-mongodb-arbiter my-release-mongodb-primary my-release-mongodb-secondary --cascade=false
```

## Configure Ingress
MongoDB can exposed externally using the [NGINX Ingress Controller](https://github.com/kubernetes/ingress-nginx). To do so, it's necessary to:

- Install the MongoDB chart setting the parameter `ingress.enabled=true`.
- Create a ConfigMap to map the external port to use and the internal service/port where to redirect the requests (see https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/exposing-tcp-udp-services.md for more information).

For instance, if you installed the MongoDB chart in the `default` namespace, you can install the [stable/nginx-ingress chart](https://github.com/helm/charts/tree/master/stable/nginx-ingress) setting the "tcp" parameter in the **values.yaml** used to install the chart as shown below:

```yaml
...

tcp:
  27017: "default/mongodb:27017"
```
