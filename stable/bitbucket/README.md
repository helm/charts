# Unofficial chart for Atlassian Bitbucket

This helm chart installs Atlassian [Bitbucket](https://bitbucket.org)

## Chart Details

This chart will do the following:

* Set up a dynamically scalable Bitbucket cluster using a Kubernetes StatefulSet
* Set up stable/postgresql chart for Bibucket application (optional)
* Set up stable/elasticsearch chart for Bibucket application (optional)

## Prerequisites

### Database

* Change ```database``` settings in values.yaml file for connecting to external database
* Change ```postgresql``` settings in values.yaml file for connecting to provisioned postgresql with helm
* Change ```elasticsearch``` settings in values.yaml file for connecting to provisioned elasticsearch nodes with helm

## Installing the Chart

To install the chart with the release name `bitbucket`:

```bash
helm install --name bitbucket stable/bitbucket
```

To install the chart with dependecies:

```bash
helm dep up && \
helm install --name bitbucket stable/bitbucket
```

## Configuration

The following table lists the configurable parameters of the bitbucket chart and their default values.

|              Parameter               |                             Description                             |                       Default                       |
| ------------------------------------ | ------------------------------------------------------------------- | --------------------------------------------------- |
| `postgresql.enabled`                         | Use enclosed PostgreSQL as database                                 | `true`
| `postgresql.postgresDatabase`                         | Provisioned database in PostgreSQL                              | `bitbucket`
| `postgresql.postgresUser`                         | Provisioned user in PostgreSQL                              | `bitbucket`
| `postgresql.service.port`                         | PostgreSQL service port for connection                            | `5432`
| `elasticsearch.enabled`                         | Use enclosed Elasticsearch                            | `true`
| `disruptionBudget.maxUnavailable`                         | Pod disruption budget settings for Bitbucket | `1`
| `terminationGracePeriodSeconds`                         | Statefulset's termination period | `120`
| `imagePullSecrets`                         | Secrets for image pulling | `nil`
| `serviceAccountName`                         | ServiceAccount for installing bitbucket | `nil`
| `updateStrategy`                         | Statefulset's update strategy | `RollingUpdate`                                               | `podManagementPolicy`                         | Statefulset's [podManagementPolicy](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#pod-management-policies) | `{}`
| `config`                         | Bitbucket settings. For example HAZELCAST_ properties should passed here | ``  
| `config.HAZELCAST_NETWORK_MULTICAST`                         | Bitbucket's hazelcast network multicast | `true`
| `config.HAZELCAST_GROUP_PASSWORD`                         | Bitbucket's hazelcast group password | `xxxxxxxxx`
| `config.HAZELCAST_GROUP_NAME`                         | Bitbucket's hazelcast group's name | `bitbucket`
| `config.HAZELCAST_HTTP_SESSIONS`                         | Bitbucket's hazelcast session settings | `replicated`
| `config.JVM_MINIMUM_MEMORY`                         | JVM Heap size | `1024m`
| `config.JVM_MAXIMUM_MEMORY`                         | JVM Heap size | `1024m`
| `database.JDBC.DRIVER`                         | Settings for external database. JDBC DRIVER | `nil`
| `database.JDBC.URL`                         | Settings for external database. JDBC URL | `nil`
| `database.JDBC.PORT`                         | Settings for external database. JDBC PORT | `nil`
| `database.JDBC.USER`                         | Settings for external database. JDBC USER | `nil`
| `database.JDBC.PASSWORD`                         | Settings for external database. JDBC PASSWORD | `nil`
| `ingress`                         | Ingress settings | `{}`
| `service`                         | Service settings | ``
| `service.ports.httpPort`                         | Bitbucket's http port | `7990`
| `service.ports.sshPort`                         | Bitbucket's ssh port | `7999`
| `service.ports.clusterPort`                         | Bitbucket's cluster port | `5701`
| `service.type`                         | Type of Service | `LoadBalancer`
| `service.annotations`                         | Service annotations | `nil`
| `service.clusterIP`                         | Service's clusterIP | `None`
| `persistence.enabled`                         | Bitbucket's persistance settings | `false`
| `persistence.persistentVolumeReclaimPolicy`                         | PVC policy | `Recycle`
| `persistence.mountPath`                         | Mount path for Bitbucket's pod | `/var/atlassian/application-data/bitbucket/shared`
| `persistence.storageClassName`                         | StorageClass name | `nil`
| `persistence.accessModes`                         | AccessMode for PVC| `ReadWriteMany`
| `persistence.storage`                         | Storage request for PVC | `nil`
| `bitbucket`                         | Settings for StatefulSet | ``
| `bitbucket.replicas`                         | Replicas in StatefulSet | `1`
| `bitbucket.image.repository`                         | Image repository | `atlassian/bitbucket-server`
| `bitbucket.image.version`                         | Image version | `appVersion`
| `bitbucket.image.pullPolicy`                         | Image pullPolicy | `IfNotPresent`
| `bitbucket.ports.httpPort`                         | Bitbucket's http port | `7990`
| `bitbucket.ports.sshPort`                         | Bitbucket's ssh port | `7999`
| `bitbucket.ports.clusterPort`                         | Bitbucket's cluster port | `5701`
| `bitbucket.args`                         | Args to be passed into container | `nil`
| `bitbucket.resources`                         | Bitbucket's resource limits and requests | `{}`
| `bitbucket.livenessProbe.failureThreshold`                         | FailureThreshold for liveness probe | `3`
| `bitbucket.livenessProbe.httpGet.path`                         | Path for liveness probe | `/status`
| `bitbucket.livenessProbe.httpGet.port`                         | Port for liveness probe | `7990`
| `bitbucket.livenessProbe.initialDelaySeconds`                         | Initial delay in seconds | `600`
| `bitbucket.livenessProbe.periodSeconds`                         | How often probe should be performed  | `10`
| `bitbucket.livenessProbe.successThreshold`                         | Minimum consecutive successes for the probe to be considered successful after having failed  | `1`
| `bitbucket.livenessProbe.timeoutSeconds`                         | Timeout for probe in seconds  | `5`
| `bitbucket.readinessProbe.failureThreshold`                         | Count of retries before restarting | `3`
| `bitbucket.readinessProbe.httpGet.path`                         | Path for readiness probe | `/status`
| `bitbucket.readinessProbe.httpGet.port`                         | Port for readiness probe | `7990`
| `bitbucket.readinessProbe.initialDelaySeconds`                         | Initial delay in seconds  | `420`
| `bitbucket.readinessProbe.periodSeconds`                         |  How often probe should be performed  | `10`
| `bitbucket.readinessProbe.successThreshold`  |  Minimum consecutive successes for the probe to be considered successful after having failed  | `1`
| `bitbucket.readinessProbe.timeoutSeconds`  |  Timeout for probe in seconds  | `5`
| `bitbucket.nodeSelector`  |  NodeSelector for statefulSet   | `{}`
| `bitbucket.tolerations`  |  Tolerations for statefulSet   | `{}`
| `bitbucket.affinity.podantiaffinity.requiredDuringSchedulingIgnoredDuringExecution`  |  Podantiaffinity for Bitbucket's pods | `Every pod must be schedulled only on to different nodes`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Deep dive

### Init-containers

This chart is using [init-container](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) for checking when PostgreSQL DB is ready accept connections. This check is available when ```postgresql.enabled: true``` key is set

## Production notes

* Make sure that you have ```persistence.enabled``` for production deployments
* Use external database for production deployments

## Deleting the Charts

Delete the Helm deployment as normal

```bash
helm delete bitbucket
```

Delete the Helm deployment with history

```bash
helm delete --purge bitbucket
```