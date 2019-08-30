# PostgreSQL

[PostgreSQL](https://www.postgresql.org/) is an object-relational database management system (ORDBMS) with an emphasis on extensibility and on standards-compliance.

## TL;DR;

```console
$ helm install stable/postgresql
```

## Introduction

This chart bootstraps a [PostgreSQL](https://github.com/bitnami/bitnami-docker-postgresql) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.10+
- PV provisioner support in the underlying infrastructure

## Installing the Chart
To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/postgresql
```

The command deploys PostgreSQL on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the PostgreSQL chart and their default values.

| Parameter                                     | Description                                                                                                            | Default                                                     |
| --------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| `global.imageRegistry`                        | Global Docker Image registry                                                                                           | `nil`                                                       |
| `global.postgresql.postgresqlDatabase`        | PostgreSQL database (overrides `postgresqlDatabase`)                                                                   | `nil`                                                       |
| `global.postgresql.postgresqlUsername`        | PostgreSQL username (overrides `postgresqlUsername`)                                                                   | `nil`                                                       |
| `global.postgresql.existingSecret`            | Name of existing secret to use for PostgreSQL passwords (overrides `existingSecret`)                                   | `nil`                                                       |
| `global.postgresql.postgresqlPassword`        | Name of existing secret to use for PostgreSQL passwords (overrides `postgresqlPassword`)                               | `nil`                                                       |
| `global.postgresql.servicePort`               | PostgreSQL port (overrides `service.port`)                                                                             | `nil`                                                       |
| `global.postgresql.replicationPassword`       | Replication user password (overrides `replication.password`)                                                           | `nil`                                                       |
| `global.imagePullSecrets`                     | Global Docker registry secret names as an array                                                                        | `[]` (does not add image pull secrets to deployed pods)     |
| `global.storageClass`                     | Global storage class for dynamic provisioning                                               | `nil`                                                        |
| `image.registry`                              | PostgreSQL Image registry                                                                                              | `docker.io`                                                 |
| `image.repository`                            | PostgreSQL Image name                                                                                                  | `bitnami/postgresql`                                        |
| `image.tag`                                   | PostgreSQL Image tag                                                                                                   | `{TAG_NAME}`                                                |
| `image.pullPolicy`                            | PostgreSQL Image pull policy                                                                                           | `IfNotPresent`                                              |
| `image.pullSecrets`                           | Specify Image pull secrets                                                                                             | `nil` (does not add image pull secrets to deployed pods)    |
| `image.debug`                                 | Specify if debug values should be set                                                                                  | `false`                                                     |
| `nameOverride`                                | String to partially override postgresql.fullname template with a string (will prepend the release name)                | `nil`                                                       |
| `fullnameOverride`                            | String to fully override postgresql.fullname template with a string                                                    | `nil`                                                       |
| `volumePermissions.image.registry`            | Init container volume-permissions image registry                                                                       | `docker.io`                                                 |
| `volumePermissions.image.repository`          | Init container volume-permissions image name                                                                           | `bitnami/minideb`                                           |
| `volumePermissions.image.tag`                 | Init container volume-permissions image tag                                                                            | `buster`                                                    |
| `volumePermissions.image.pullPolicy`          | Init container volume-permissions image pull policy                                                                    | `Always`                                                    |
| `volumePermissions.securityContext.runAsUser` | User ID for the init container                                                                                         | `0`                                                         |
| `usePasswordFile`                             | Have the secrets mounted as a file instead of env vars                                                                 | `false`                                                     |
| `replication.enabled`                         | Enable replication                                                                                                     | `false`                                                     |
| `replication.user`                            | Replication user                                                                                                       | `repl_user`                                                 |
| `replication.password`                        | Replication user password                                                                                              | `repl_password`                                             |
| `replication.slaveReplicas`                   | Number of slaves replicas                                                                                              | `1`                                                         |
| `replication.synchronousCommit`               | Set synchronous commit mode. Allowed values: `on`, `remote_apply`, `remote_write`, `local` and `off`                   | `off`                                                       |
| `replication.numSynchronousReplicas`          | Number of replicas that will have synchronous replication. Note: Cannot be greater than `replication.slaveReplicas`.   | `0`                                                         |
| `replication.applicationName`                 | Cluster application name. Useful for advanced replication settings                                                     | `my_application`                                            |
| `existingSecret`                              | Name of existing secret to use for PostgreSQL passwords                                                                | `nil`                                                       |
| `postgresqlUsername`                          | PostgreSQL admin user                                                                                                  | `postgres`                                                  |
| `postgresqlPassword`                          | PostgreSQL admin password                                                                                              | _random 10 character alphanumeric string_                   |
| `postgresqlDatabase`                          | PostgreSQL database                                                                                                    | `nil`                                                       |
| `postgresqlDataDir`                           | PostgreSQL data dir folder                                                                                             | `/bitnami/postgresql` (same value as persistence.mountPath) |
| `postgresqlInitdbArgs`                        | PostgreSQL initdb extra arguments                                                                                      | `nil`                                                       |
| `postgresqlInitdbWalDir`                      | PostgreSQL location for transaction log                                                                                | `nil`                                                       |
| `postgresqlConfiguration`                     | Runtime Config Parameters                                                                                              | `nil`                                                       |
| `postgresqlExtendedConf`                      | Extended Runtime Config Parameters (appended to main or default configuration)                                         | `nil`                                                       |
| `pgHbaConfiguration`                          | Content of pg\_hba.conf                                                                                                | `nil (do not create pg_hba.conf)`                           |
| `configurationConfigMap`                      | ConfigMap with the PostgreSQL configuration files (Note: Overrides `postgresqlConfiguration` and `pgHbaConfiguration`). The value is evaluated as a template. | `nil`                                                       |
| `extendedConfConfigMap`                       | ConfigMap with the extended PostgreSQL configuration files. The value is evaluated as a template.                      | `nil`                                                       |
| `initdbScripts`                               | Dictionary of initdb scripts                                                                                           | `nil`                                                       |
| `initdbScriptsConfigMap`                      | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`). The value is evaluated as a template.             | `nil`                                                       |
| `initdbScriptsSecret`                         | Secret with initdb scripts that contain sensitive information (Note: can be used with `initdbScriptsConfigMap` or `initdbScripts`). The value is evaluated as a template. | `nil`                                           |
| `service.type`                                | Kubernetes Service type                                                                                                | `ClusterIP`                                                 |
| `service.port`                                | PostgreSQL port                                                                                                        | `5432`                                                      |
| `service.nodePort`                            | Kubernetes Service nodePort                                                                                            | `nil`                                                       |
| `service.annotations`                         | Annotations for PostgreSQL service                                                                                     | {}                                                          |
| `service.loadBalancerIP`                      | loadBalancerIP if service type is `LoadBalancer`                                                                       | `nil`                                                       |
| `service.loadBalancerSourceRanges`            | Address that are allowed when svc is LoadBalancer                                                                      | []                                                          |
| `schedulerName`                               | Name of the k8s scheduler (other than default)                                                                         | `nil`                                                       |
| `persistence.enabled`                         | Enable persistence using PVC                                                                                           | `true`                                                      |
| `persistence.existingClaim`                   | Provide an existing `PersistentVolumeClaim`, the value is evaluated as a template.                                     | `nil`                                                       |
| `persistence.mountPath`                       | Path to mount the volume at                                                                                            | `/bitnami/postgresql`                                       |
| `persistence.subPath`                         | Subdirectory of the volume to mount at                                                                                 | `""`                                                        |
| `persistence.storageClass`                    | PVC Storage Class for PostgreSQL volume                                                                                | `nil`                                                       |
| `persistence.accessModes`                     | PVC Access Mode for PostgreSQL volume                                                                                  | `[ReadWriteOnce]`                                           |
| `persistence.size`                            | PVC Storage Request for PostgreSQL volume                                                                              | `8Gi`                                                       |
| `persistence.annotations`                     | Annotations for the PVC                                                                                                | `{}`                                                        |
| `master.nodeSelector`                         | Node labels for pod assignment (postgresql master)                                                                     | `{}`                                                        |
| `master.affinity`                             | Affinity labels for pod assignment (postgresql master)                                                                 | `{}`                                                        |
| `master.tolerations`                          | Toleration labels for pod assignment (postgresql master)                                                               | `[]`                                                        |
| `master.podAnnotations`                       | Map of annotations to add to the pods (postgresql master)                                                              | `{}`                                                        |
| `master.podLabels`                            | Map of labels to add to the pods (postgresql master)                                                                   | `{}`                                                        |
| `master.extraVolumeMounts`                    | Additional volume mounts to add to the pods (postgresql master)                                                        |  `[]`                                                       |
| `master.extraVolume`                          | Additional volumes to add to the pods (postgresql master)                                                              |  `[]`                                                       |
| `slave.nodeSelector`                          | Node labels for pod assignment (postgresql slave)                                                                      | `{}`                                                        |
| `slave.affinity`                              | Affinity labels for pod assignment (postgresql slave)                                                                  | `{}`                                                        |
| `slave.tolerations`                           | Toleration labels for pod assignment (postgresql slave)                                                                | `[]`                                                        |
| `slave.podAnnotations`                        | Map of annotations to add to the pods (postgresql slave)                                                               | `{}`                                                        |
| `slave.podLabels`                             | Map of labels to add to the pods (postgresql slave)                                                                    | `{}`                                                        |
| `slave.extraVolumeMounts`                     | Additional volume mounts to add to the pods (postgresql slave)                                                         |  `[]`                                                       |
| `slave.extraVolume`                           | Additional volumes to add to the pods (postgresql slave)                                                               |  `[]`                                                       |
| `terminationGracePeriodSeconds`               | Seconds the pod needs to terminate gracefully                                                                          | `nil`                                                       |
| `resources`                                   | CPU/Memory resource requests/limits                                                                                    | Memory: `256Mi`, CPU: `250m`                                |
| `securityContext.enabled`                     | Enable security context                                                                                                | `true`                                                      |
| `securityContext.fsGroup`                     | Group ID for the container                                                                                             | `1001`                                                      |
| `securityContext.runAsUser`                   | User ID for the container                                                                                              | `1001`                                                      |
| `serviceAccount.enabled`                      | Enable service account (Note: Service Account will only be automatically created if `serviceAccount.name` is not set)  | `false`                                                     |
| `serviceAcccount.name`                        | Name of existing service account                                                                                       | `nil`                                                       |
| `livenessProbe.enabled`                       | Would you like a livenessProbe to be enabled                                                                            | `true`                                                      |
| `networkPolicy.enabled`                       | Enable NetworkPolicy                                                                                                   | `false`                                                     |
| `networkPolicy.allowExternal`                 | Don't require client label for connections                                                                             | `true`                                                      |
| `livenessProbe.initialDelaySeconds`           | Delay before liveness probe is initiated                                                                               | 30                                                          |
| `livenessProbe.periodSeconds`                 | How often to perform the probe                                                                                         | 10                                                          |
| `livenessProbe.timeoutSeconds`                | When the probe times out                                                                                               | 5                                                           |
| `livenessProbe.failureThreshold`              | Minimum consecutive failures for the probe to be considered failed after having succeeded.                             | 6                                                           |
| `livenessProbe.successThreshold`              | Minimum consecutive successes for the probe to be considered successful after having failed                            | 1                                                           |
| `readinessProbe.enabled`                      | would you like a readinessProbe to be enabled                                                                          | `true`                                                      |
| `readinessProbe.initialDelaySeconds`          | Delay before readiness probe is initiated                                                                               | 5                                                           |
| `readinessProbe.periodSeconds`                | How often to perform the probe                                                                                         | 10                                                          |
| `readinessProbe.timeoutSeconds`               | When the probe times out                                                                                               | 5                                                           |
| `readinessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded.                             | 6                                                           |
| `readinessProbe.successThreshold`             | Minimum consecutive successes for the probe to be considered successful after having failed                            | 1                                                           |
| `metrics.enabled`                             | Start a prometheus exporter                                                                                            | `false`                                                     |
| `metrics.service.type`                        | Kubernetes Service type                                                                                                | `ClusterIP`                                                 |
| `service.clusterIP`                           | Static clusterIP or None for headless services                                                                         | `nil`                                                       |
| `metrics.service.annotations`                 | Additional annotations for metrics exporter pod                                                                        | `{ prometheus.io/scrape: "true", prometheus.io/port: "9187"}` |
| `metrics.service.loadBalancerIP`              | loadBalancerIP if redis metrics service type is `LoadBalancer`                                                         | `nil`                                                       |
| `metrics.serviceMonitor.enabled`              | Set this to `true` to create ServiceMonitor for Prometheus operator                                                    | `false`                                                     |
| `metrics.serviceMonitor.additionalLabels`     | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus                                  | `{}`                                                        |
| `metrics.serviceMonitor.namespace`            | Optional namespace in which to create ServiceMonitor                                                                   | `nil`                                                       |
| `metrics.serviceMonitor.interval`             | Scrape interval. If not set, the Prometheus default scrape interval is used                                            | `nil`                                                       |
| `metrics.serviceMonitor.scrapeTimeout`        | Scrape timeout. If not set, the Prometheus default scrape timeout is used                                              | `nil`                                                       |
| `metrics.image.registry`                      | PostgreSQL Image registry                                                                                              | `docker.io`                                                 |
| `metrics.image.repository`                    | PostgreSQL Image name                                                                                                  | `bitnami/postgres-exporter`                               |
| `metrics.image.tag`                           | PostgreSQL Image tag                                                                                                   | `{TAG_NAME}`                                                    |
| `metrics.image.pullPolicy`                    | PostgreSQL Image pull policy                                                                                           | `IfNotPresent`                                              |
| `metrics.image.pullSecrets`                   | Specify Image pull secrets                                                                                             | `nil` (does not add image pull secrets to deployed pods)    |
| `metrics.securityContext.enabled`             | Enable security context for metrics                                                                                    | `false`                                                     |
| `metrics.securityContext.runAsUser`           | User ID for the container for metrics                                                                                  | `1001`                                                      |
| `metrics.livenessProbe.initialDelaySeconds`   | Delay before liveness probe is initiated                                                                               | 30                                                          |
| `metrics.livenessProbe.periodSeconds`         | How often to perform the probe                                                                                         | 10                                                          |
| `metrics.livenessProbe.timeoutSeconds`        | When the probe times out                                                                                               | 5                                                           |
| `metrics.livenessProbe.failureThreshold`      | Minimum consecutive failures for the probe to be considered failed after having succeeded.                             | 6                                                           |
| `metrics.livenessProbe.successThreshold`      | Minimum consecutive successes for the probe to be considered successful after having failed                            | 1                                                           |
| `metrics.readinessProbe.enabled`              | would you like a readinessProbe to be enabled                                                                          | `true`                                                      |
| `metrics.readinessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated                                                                               | 5                                                           |
| `metrics.readinessProbe.periodSeconds`        | How often to perform the probe                                                                                         | 10                                                          |
| `metrics.readinessProbe.timeoutSeconds`       | When the probe times out                                                                                               | 5                                                           |
| `metrics.readinessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                             | 6                                                           |
| `metrics.readinessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed                            | 1                                                           |
| `extraEnv`                                    | Any extra environment variables you would like to pass on to the pod. The value is evaluated as a template.            | `{}`                                                        |
| `updateStrategy`                              | Update strategy policy                                                                                                 | `{type: "RollingUpdate"}`                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set postgresqlPassword=secretpassword,postgresqlDatabase=my-database \
    stable/postgresql
```

The above command sets the PostgreSQL `postgres` account password to `secretpassword`. Additionally it creates a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/postgresql
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`.

```console
$ helm install --name my-release -f ./values-production.yaml stable/postgresql
```

- Enable replication:
```diff
- replication.enabled: false
+ replication.enabled: true
```

- Number of slaves replicas:
```diff
- replication.slaveReplicas: 1
+ replication.slaveReplicas: 2
```

- Set synchronous commit mode:
```diff
- replication.synchronousCommit: "off"
+ replication.synchronousCommit: "on"
```

- Number of replicas that will have synchronous replication:
```diff
- replication.numSynchronousReplicas: 0
+ replication.numSynchronousReplicas: 1
```

- Start a prometheus exporter:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

To horizontally scale this chart, first download the [values-production.yaml](values-production.yaml) file to your local folder, then:

```console
$ helm install --name my-release -f ./values-production.yaml stable/postgresql
$ kubectl scale statefulset my-postgresql-slave --replicas=3
```

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### postgresql.conf / pg_hba.conf files as configMap

This helm chart also supports to customize the whole configuration file.

Add your custom file to "files/postgresql.conf" in your working directory. This file will be mounted as configMap to the containers and it will be used for configuring the PostgreSQL server.

Alternatively, you can specify PostgreSQL configuration parameters using the `postgresqlConfiguration` parameter as a dict, using camelCase, e.g. {"sharedBuffers": "500MB"}.

In addition to these options, you can also set an external ConfigMap with all the configuration files. This is done by setting the `configurationConfigMap` parameter. Note that this will override the two previous options.

### Allow settings to be loaded from files other than the default `postgresql.conf`

If you don't want to provide the whole PostgreSQL configuration file and only specify certain parameters, you can add your extended `.conf` files to "files/conf.d/" in your working directory.
Those files will be mounted as configMap to the containers adding/overwriting the default configuration using the `include_dir` directive that allows settings to be loaded from files other than the default `postgresql.conf`.

Alternatively, you can also set an external ConfigMap with all the extra configuration files. This is done by setting the `extendedConfConfigMap` parameter. Note that this will override the previous option.

## Initialize a fresh instance

The [Bitnami PostgreSQL](https://github.com/bitnami/bitnami-docker-postgresql) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, they must be located inside the chart folder `files/docker-entrypoint-initdb.d` so they can be consumed as a ConfigMap.

Alternatively, you can specify custom scripts using the `initdbScripts` parameter as dict.

In addition to these options, you can also set an external ConfigMap with all the initialization scripts. This is done by setting the `initdbScriptsConfigMap` parameter. Note that this will override the two previous options. If your initialization scripts contain sensitive information such as credentials or passwords, you can use the `initdbScriptsSecret` parameter.

The allowed extensions are `.sh`, `.sql` and `.sql.gz`.

## Persistence

The [Bitnami PostgreSQL](https://github.com/bitnami/bitnami-docker-postgresql) image stores the PostgreSQL data and configurations at the `/bitnami/postgresql` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Metrics

The chart optionally can start a metrics exporter for [prometheus](https://prometheus.io). The metrics endpoint (port 9187) is not exposed and it is expected that the metrics are collected from inside the k8s cluster using something similar as the described in the [example Prometheus scrape configuration](https://github.com/prometheus/prometheus/blob/master/documentation/examples/prometheus-kubernetes.yml).

The exporter allows to create custom metrics from additional SQL queries. See the Chart's `values.yaml` for an example and consult the [exporters documentation](https://github.com/wrouesnel/postgres_exporter#adding-new-metrics-via-a-config-file) for more details.

## NetworkPolicy

To enable network policy for PostgreSQL, install [a networking plugin that implements the Kubernetes NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin), and set `networkPolicy.enabled` to `true`.

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

```console
$ kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"
```

With NetworkPolicy enabled, traffic will be limited to just port 5432.

For more precise policy, set `networkPolicy.allowExternal=false`. This will only allow pods with the generated client label to connect to PostgreSQL.
This label will be displayed in the output of a successful install.

## Deploy chart using Docker Official PostgreSQL Image

From chart version 4.0.0, it is possible to use this chart with the Docker Official PostgreSQL image.
Besides specifying the new Docker repository and tag, it is important to modify the PostgreSQL data directory and volume mount point. Basically, the PostgreSQL data dir cannot be the mount point directly, it has to be a subdirectory.

```
helm install --name postgres \
             --set image.repository=postgres \
             --set image.tag=10.6 \
             --set postgresqlDataDir=/data/pgdata \
             --set persistence.mountPath=/data/ \
             stable/postgresql
```

## Differences between Bitnami PostgreSQL image and [Docker Official](https://hub.docker.com/_/postgres) image

- The Docker Official PostgreSQL image does not support replication. If you pass any replication environment variable, this would be ignored. The only environment variables supported by the Docker Official image are POSTGRES_USER, POSTGRES_DB, POSTGRES_PASSWORD, POSTGRES_INITDB_ARGS, POSTGRES_INITDB_WALDIR and PGDATA. All the remaining environment variables are specific to the Bitnami PostgreSQL image.
- The Bitnami PostgreSQL image is non-root by default. This requires that you run the pod with `securityContext` and updates the permissions of the volume with an `initContainer`. A key benefit of this configuration is that the pod follows security best practices and is prepared to run on Kubernetes distributions with hard security constraints like OpenShift.

## Use of global variables

In more complex scenarios, we may have the following tree of dependencies

```
                     +--------------+
                     |              |
        +------------+   Chart 1    +-----------+
        |            |              |           |
        |            --------+------+           |
        |                    |                  |
        |                    |                  |
        |                    |                  |
        |                    |                  |
        v                    v                  v
+-------+------+    +--------+------+  +--------+------+
|              |    |               |  |               |
|  PostgreSQL  |    |  Sub-chart 1  |  |  Sub-chart 2  |
|              |    |               |  |               |
+--------------+    +---------------+  +---------------+
```

The three charts below depend on the parent chart Chart 1. However, subcharts 1 and 2 may need to connect to PostgreSQL as well. In order to do so, subcharts 1 and 2 need to know the PostgreSQL credentials, so one option for deploying could be:

```
helm install chart1 --set postgresql.postgresqlPassword=testtest --set subchart1.postgresql.postgresqlPassword=testtest --set subchart2.postgresql.postgresqlPassword=testtest --set postgresql.postgresqlDatabase=db1 --set subchart1.postgresql.postgresqlDatabase=db1 --set subchart1.postgresql.postgresqlDatabase=db1
```

If the number of dependent sub-charts increases, executing `helm install` can become increasingly difficult. An alternative would be to set the credentials using global variables as follows:

```
helm install chart1 --set global.postgresql.postgresqlPassword=testtest --set global.postgresql.postgresqlDatabase=db1
```

This way, the credentials will be available in all of the subcharts.

## Upgrade

## 5.0.0

In this version, the **chart is using PostgreSQL 11 instead of PostgreSQL 10**. You can find the main difference and notable changes in the following links: [https://www.postgresql.org/about/news/1894/](https://www.postgresql.org/about/news/1894/) and [https://www.postgresql.org/about/featurematrix/](https://www.postgresql.org/about/featurematrix/).

For major releases of PostgreSQL, the internal data storage format is subject to change, thus complicating upgrades, you can see some errors like the following one in the logs:

```bash
Welcome to the Bitnami postgresql container
Subscribe to project updates by watching https://github.com/bitnami/bitnami-docker-postgresql
Submit issues and feature requests at https://github.com/bitnami/bitnami-docker-postgresql/issues
Send us your feedback at containers@bitnami.com

INFO  ==> ** Starting PostgreSQL setup **
NFO  ==> Validating settings in POSTGRESQL_* env vars..
INFO  ==> Initializing PostgreSQL database...
INFO  ==> postgresql.conf file not detected. Generating it...
INFO  ==> pg_hba.conf file not detected. Generating it...
INFO  ==> Deploying PostgreSQL with persisted data...
INFO  ==> Configuring replication parameters
INFO  ==> Loading custom scripts...
INFO  ==> Enabling remote connections
INFO  ==> Stopping PostgreSQL...
INFO  ==> ** PostgreSQL setup finished! **

INFO  ==> ** Starting PostgreSQL **
  [1] FATAL:  database files are incompatible with server
  [1] DETAIL:  The data directory was initialized by PostgreSQL version 10, which is not compatible with this version 11.3.
```
In this case, you should migrate the data from the old chart to the new one following an approach similar to that described in [this section](https://www.postgresql.org/docs/current/upgrading.html#UPGRADING-VIA-PGDUMPALL) from the official documentation. Basically, create a database dump in the old chart, move and restore it in the new one.

### 4.0.0

This chart will use by default the Bitnami PostgreSQL container starting from version `10.7.0-r68`. This version moves the initialization logic from node.js to bash. This new version of the chart requires setting the `POSTGRES_PASSWORD` in the slaves as well, in order to properly configure the `pg_hba.conf` file. Users from previous versions of the chart are advised to upgrade immediately.

IMPORTANT: If you do not want to upgrade the chart version then make sure you use the `10.7.0-r68` version of the container. Otherwise, you will get this error

```
The POSTGRESQL_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development
```

### 3.0.0

This releases make it possible to specify different nodeSelector, affinity and tolerations for master and slave pods.
It also fixes an issue with `postgresql.master.fullname` helper template not obeying fullnameOverride.

#### Breaking changes

- `affinty` has been renamed to `master.affinity` and `slave.affinity`.
- `tolerations` has been renamed to `master.tolerations` and `slave.tolerations`.
- `nodeSelector` has been renamed to `master.nodeSelector` and `slave.nodeSelector`.

### 2.0.0

In order to upgrade from the `0.X.X` branch to `1.X.X`, you should follow the below steps:

 - Obtain the service name (`SERVICE_NAME`) and password (`OLD_PASSWORD`) of the existing postgresql chart. You can find the instructions to obtain the password in the NOTES.txt, the service name can be obtained by running

 ```console
$ kubectl get svc
 ```

- Install (not upgrade) the new version

```console
$ helm repo update
$ helm install --name my-release stable/postgresql
```

- Connect to the new pod (you can obtain the name by running `kubectl get pods`):

```console
$ kubectl exec -it NAME bash
```

- Once logged in, create a dump file from the previous database using `pg_dump`, for that we should connect to the previous postgresql chart:

```console
$ pg_dump -h SERVICE_NAME -U postgres DATABASE_NAME > /tmp/backup.sql
```

After run above command you should be prompted for a password, this password is the previous chart password (`OLD_PASSWORD`).
This operation could take some time depending on the database size.

- Once you have the backup file, you can restore it with a command like the one below:

```console
$ psql -U postgres DATABASE_NAME < /tmp/backup.sql
```

In this case, you are accessing to the local postgresql, so the password should be the new one (you can find it in NOTES.txt).

If you want to restore the database and the database schema does not exist, it is necessary to first follow the steps described below.

```console
$ psql -U postgres
postgres=# drop database DATABASE_NAME;
postgres=# create database DATABASE_NAME;
postgres=# create user USER_NAME;
postgres=# alter role USER_NAME with password 'BITNAMI_USER_PASSWORD';
postgres=# grant all privileges on database DATABASE_NAME to USER_NAME;
postgres=# alter database DATABASE_NAME owner to USER_NAME;
```
