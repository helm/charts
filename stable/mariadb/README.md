# MariaDB

[MariaDB](https://mariadb.org) is one of the most popular database servers in the world. It’s made by the original developers of MySQL and guaranteed to stay open source. Notable users include Wikipedia, Facebook and Google.

MariaDB is developed as open source software and as a relational database it provides an SQL interface for accessing data. The latest versions of MariaDB also include GIS and JSON features.

## TL;DR

```bash
$ helm install stable/mariadb
```

## Introduction

This chart bootstraps a [MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) replication cluster deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.10+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/mariadb
```

The command deploys MariaDB on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the MariaDB chart and their default values.

|             Parameter                     |                     Description                     |                              Default                              |
|-------------------------------------------|-----------------------------------------------------|-------------------------------------------------------------------|
| `global.imageRegistry`                    | Global Docker image registry                        | `nil`                                                             |
| `global.imagePullSecrets`                 | Global Docker registry secret names as an array     | `[]` (does not add image pull secrets to deployed pods)           |
| `image.registry`                          | MariaDB image registry                              | `docker.io`                                                       |
| `image.repository`                        | MariaDB Image name                                  | `bitnami/mariadb`                                                 |
| `image.tag`                               | MariaDB Image tag                                   | `{TAG_NAME}`                                                      |
| `image.pullPolicy`                        | MariaDB image pull policy                           | `IfNotPresent`                                                    |
| `image.pullSecrets`                       | Specify docker-registry secret names as an array    | `[]` (does not add image pull secrets to deployed pods)           |
| `image.debug`                             | Specify if debug logs should be enabled             | `false`                                                           |
| `nameOverride`                            | String to partially override mariadb.fullname template with a string (will prepend the release name) | `nil`            |
| `fullnameOverride`                        | String to fully override mariadb.fullname template with a string                                     | `nil`            |
| `volumePermissions.enabled`          | Enable init container that changes volume permissions in the data directory (for cases where the default k8s `runAsUser` and `fsUser` values do not work) | `false`                                                      |
| `volumePermissions.image.registry`   | Init container volume-permissions image registry                                                                                                          | `docker.io`                                                  |
| `volumePermissions.image.repository` | Init container volume-permissions image name                                                                                                              | `bitnami/minideb`                                            |
| `volumePermissions.image.tag`        | Init container volume-permissions image tag                                                                                                               | `latest`                                                     |
| `volumePermissions.image.pullPolicy` | Init container volume-permissions image pull policy                                                                                                       | `Always`                                                     |
| `volumePermissions.resources`        | Init container resource requests/limit                                                                                                                    | `nil`                                                        |
| `service.type`                            | Kubernetes service type                             | `ClusterIP`                                                       |
| `service.clusterIp`                       | Specific cluster IP when service type is cluster IP. Use None for headless service | `nil`                              |
| `service.port`                            | MySQL service port                                  | `3306`                                                            |
| `serviceAccount.create`                   | Specifies whether a ServiceAccount should be created | `false`                                                          |
| `serviceAccount.name`                     | The name of the ServiceAccount to create            | Generated using the mariadb.fullname template                     |
| `schedulerName`                           | Name of the k8s scheduler (other than default)      | `nil`                                                             |
| `rbac.create`                             | Create and use RBAC resources                       | `false`                                                           |
| `securityContext.enabled`                 | Enable security context                             | `true`                                                            |
| `securityContext.fsGroup`                 | Group ID for the container                          | `1001`                                                            |
| `securityContext.runAsUser`               | User ID for the container                           | `1001`                                                            |
| `existingSecret`                          | Use existing secret for password details (`rootUser.password`, `db.password`, `replication.password` will be ignored and picked up from this secret). The secret has to contain the keys `mariadb-root-password`, `mariadb-replication-password` and `mariadb-password`. |                         |
| `rootUser.password`                       | Password for the `root` user. Ignored if existing secret is provided. | _random 10 character alphanumeric string_       |
| `rootUser.forcePassword`                  | Force users to specify a password                   | `false`                                                           |
| `db.user`                                 | Username of new user to create                      | `nil`                                                             |
| `db.password`                             | Password for the new user. Ignored if existing secret is provided.    | _random 10 character alphanumeric string if `db.user` is defined_ |
| `db.forcePassword`                        | Force users to specify a password                   | `false`                                                           |
| `db.name`                                 | Name for new database to create                     | `my_database`                                                     |
| `replication.enabled`                     | MariaDB replication enabled                         | `true`                                                            |
| `replication.user`                        |MariaDB replication user                             | `replicator`                                                      |
| `replication.password`                    | MariaDB replication user password. Ignored if existing secret is provided. | _random 10 character alphanumeric string_  |
| `replication.forcePassword`               | Force users to specify a password                   | `false`                                                           |
| `initdbScripts`                           | Dictionary of initdb scripts                        | `nil`                                                             |
| `initdbScriptsConfigMap`                  | ConfigMap with the initdb scripts (Note: Overrides `initdbScripts`) | `nil`                                             |
| `master.annotations[].key`                | key for the the annotation list item                |  `nil`                                                            |
| `master.annotations[].value`              | value for the the annotation list item              |  `nil`                                                            |
| `master.extraFlags`                       | MariaDB master additional command line flags        |  `nil`                                                            |
| `master.affinity`                         | Master affinity (in addition to master.antiAffinity when set)  | `{}`                                                   |
| `master.antiAffinity`                     | Master pod anti-affinity policy                     | `soft`                                                            |
| `master.nodeSelector`                     | Master node labels for pod assignment               | `{}`                                                              |
| `master.tolerations`                      | List of node taints to tolerate (master)            | `[]`                                                              |
| `master.updateStrategy`                   | Master statefulset update strategy policy           | `RollingUpdate`                                                   |
| `master.persistence.enabled`              | Enable persistence using PVC                        | `true`                                                            |
| `master.persistence.existingClaim`        | Provide an existing `PersistentVolumeClaim`         | `nil`                                                             |
| `master.persistence.subPath`              | Subdirectory of the volume to mount                 | `nil`                                                             |
| `master.persistence.mountPath`            | Path to mount the volume at                         | `/bitnami/mariadb`                                                |
| `master.persistence.annotations`          | Persistent Volume Claim annotations                 | `{}`                                                              |
| `master.persistence.storageClass`         | Persistent Volume Storage Class                     | ``                                                                |
| `master.persistence.accessModes`          | Persistent Volume Access Modes                      | `[ReadWriteOnce]`                                                 |
| `master.persistence.size`                 | Persistent Volume Size                              | `8Gi`                                                             |
| `master.extraInitContainers`              | Additional init containers as a string to be passed to the `tpl` function (master) |                                    |
| `master.config`                           | Config file for the MariaDB Master server           | `_default values in the values.yaml file_`                        |
| `master.resources`                        | CPU/Memory resource requests/limits for master node | `{}`                                                              |
| `master.livenessProbe.enabled`            | Turn on and off liveness probe (master)             | `true`                                                            |
| `master.livenessProbe.initialDelaySeconds`| Delay before liveness probe is initiated (master)   | `120`                                                             |
| `master.livenessProbe.periodSeconds`      | How often to perform the probe (master)             | `10`                                                              |
| `master.livenessProbe.timeoutSeconds`     | When the probe times out (master)                   | `1`                                                               |
| `master.livenessProbe.successThreshold`   | Minimum consecutive successes for the probe (master)| `1`                                                               |
| `master.livenessProbe.failureThreshold`   | Minimum consecutive failures for the probe (master) | `3`                                                               |
| `master.readinessProbe.enabled`           | Turn on and off readiness probe (master)            | `true`                                                            |
| `master.readinessProbe.initialDelaySeconds`| Delay before readiness probe is initiated (master) | `30`                                                              |
| `master.readinessProbe.periodSeconds`     | How often to perform the probe (master)             | `10`                                                              |
| `master.readinessProbe.timeoutSeconds`    | When the probe times out (master)                   | `1`                                                               |
| `master.readinessProbe.successThreshold`  | Minimum consecutive successes for the probe (master)| `1`                                                               |
| `master.readinessProbe.failureThreshold`  | Minimum consecutive failures for the probe (master) | `3`                                                               |
| `master.podDisruptionBudget.enabled`      | If true, create a pod disruption budget for master pods. | `false`                                                      |
| `master.podDisruptionBudget.minAvailable` | Minimum number / percentage of pods that should remain scheduled | `1`                                                  |
| `master.podDisruptionBudget.maxUnavailable`| Maximum number / percentage of pods that may be made unavailable | `nil`                                               |
| `slave.replicas`                          | Desired number of slave replicas                    | `1`                                                               |
| `slave.annotations[].key`                 | key for the the annotation list item                | `nil`                                                             |
| `slave.annotations[].value`               | value for the the annotation list item              | `nil`                                                             |
| `slave.extraFlags`                        | MariaDB slave additional command line flags         | `nil`                                                             |
| `slave.affinity`                          | Slave affinity (in addition to slave.antiAffinity when set) | `{}`                                                      |
| `slave.antiAffinity`                      | Slave pod anti-affinity policy                      | `soft`                                                            |
| `slave.nodeSelector`                      | Slave node labels for pod assignment                | `{}`                                                              |
| `slave.tolerations`                       | List of node taints to tolerate for (slave)         | `[]`                                                              |
| `slave.updateStrategy`                    | Slave statefulset update strategy policy            | `RollingUpdate`                                                   |
| `slave.persistence.enabled`               | Enable persistence using a `PersistentVolumeClaim`  | `true`                                                            |
| `slave.persistence.annotations`           | Persistent Volume Claim annotations                 | `{}`                                                              |
| `slave.persistence.storageClass`          | Persistent Volume Storage Class                     | ``                                                                |
| `slave.persistence.accessModes`           | Persistent Volume Access Modes                      | `[ReadWriteOnce]`                                                 |
| `slave.persistence.size`                  | Persistent Volume Size                              | `8Gi`                                                             |
| `slave.extraInitContainers`               | Additional init containers as a string to be passed to the `tpl` function (slave)               |                       |
| `slave.config`                            | Config file for the MariaDB Slave replicas          | `_default values in the values.yaml file_`                        |
| `slave.resources`                         | CPU/Memory resource requests/limits for slave node  | `{}`                                                              |
| `slave.livenessProbe.enabled`             | Turn on and off liveness probe (slave)              | `true`                                                            |
| `slave.livenessProbe.initialDelaySeconds` | Delay before liveness probe is initiated (slave)    | `120`                                                             |
| `slave.livenessProbe.periodSeconds`       | How often to perform the probe (slave)              | `10`                                                              |
| `slave.livenessProbe.timeoutSeconds`      | When the probe times out (slave)                    | `1`                                                               |
| `slave.livenessProbe.successThreshold`    | Minimum consecutive successes for the probe (slave) | `1`                                                               |
| `slave.livenessProbe.failureThreshold`    | Minimum consecutive failures for the probe (slave)  | `3`                                                               |
| `slave.readinessProbe.enabled`            | Turn on and off readiness probe (slave)             | `true`                                                            |
| `slave.readinessProbe.initialDelaySeconds`| Delay before readiness probe is initiated (slave)   | `45`                                                              |
| `slave.readinessProbe.periodSeconds`      | How often to perform the probe (slave)              | `10`                                                              |
| `slave.readinessProbe.timeoutSeconds`     | When the probe times out (slave)                    | `1`                                                               |
| `slave.readinessProbe.successThreshold`   | Minimum consecutive successes for the probe (slave) | `1`                                                               |
| `slave.readinessProbe.failureThreshold`   | Minimum consecutive failures for the probe (slave)  | `3`                                                               |
| `slave.podDisruptionBudget.enabled`       | If true, create a pod disruption budget for slave pods. | `false`                                                       |
| `slave.podDisruptionBudget.minAvailable`  | Minimum number / percentage of pods that should remain scheduled | `1`                                                  |
| `slave.podDisruptionBudget.maxUnavailable`| Maximum number / percentage of pods that may be made unavailable | `nil`                                                |
| `metrics.enabled`                         | Start a side-car prometheus exporter                | `false`                                                           |
| `metrics.image.registry`                  | Exporter image registry                             | `docker.io`                                                       |
| `metrics.image.repository`                | Exporter image name                                 | `bitnami/mysqld-exporter`                                            |
| `metrics.image.tag`                       | Exporter image tag                                  | `0.12.0-debian-9-r2`                                                         |
| `metrics.image.pullPolicy`                | Exporter image pull policy                          | `IfNotPresent`                                                    |
| `metrics.resources`                       | Exporter resource requests/limit                    | `nil`                                                             |
| `metrics.serviceMonitor.enabled`          | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                    | `false`                                                             |
| `metrics.serviceMonitor.namespace`        | Optional namespace which Prometheus is running in   | `nil`                                                             |
| `metrics.serviceMonitor.interval`         | How frequently to scrape metrics (use by default, falling back to Prometheus' default)  | `nil`                                                             |
| `metrics.serviceMonitor.selector`         | Default to kube-prometheus install (CoreOS recommended), but should be set according to Prometheus install                    | `{ prometheus: kube-prometheus }`                                                             |

The above parameters map to the env variables defined in [bitnami/mariadb](http://github.com/bitnami/bitnami-docker-mariadb). For more information please refer to the [bitnami/mariadb](http://github.com/bitnami/bitnami-docker-mariadb) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set rootUser.password=secretpassword,db.user=app_database \
    stable/mariadb
```

The above command sets the MariaDB `root` account password to `secretpassword`. Additionally it creates a database named `my_database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/mariadb
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`.

```console
$ helm install --name my-release -f ./values-production.yaml stable/mariadb
```

- Force users to specify a password:
```diff
- rootUser.forcePassword: false
+ rootUser.forcePassword: true
- db.forcePassword: false
+ db.forcePassword: true
- replication.forcePassword: false
+ replication.forcePassword: true
```

- Desired number of slave replicas:
```diff
- slave.replicas: 1
+ slave.replicas: 2
```

- Start a side-car prometheus exporter:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

## Initialize a fresh instance

The [Bitnami MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) image allows you to use your custom scripts to initialize a fresh instance. In order to execute the scripts, they must be located inside the chart folder `files/docker-entrypoint-initdb.d` so they can be consumed as a ConfigMap.

Alternatively, you can specify custom scripts using the `initdbScripts` parameter as dict.

In addition to these options, you can also set an external ConfigMap with all the initialization scripts. This is done by setting the `initdbScriptsConfigMap` parameter. Note that this will override the two previous options.

The allowed extensions are `.sh`, `.sql` and `.sql.gz`.

## Persistence

The [Bitnami MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) image stores the MariaDB data and configurations at the `/bitnami/mariadb` path of the container.

The chart mounts a [Persistent Volume](kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning, by default. An existing PersistentVolumeClaim can be defined.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an initContainer to change the ownership of the volume before mounting it in the final destination.

You can enable this initContainer by setting `volumePermissions.enabled` to `true`.

## Extra Init Containers

The feature allows for specifying a template string for a initContainer in the master/slave pod. Usecases include situations when you need some pre-run setup. For example, in IKS (IBM Cloud Kubernetes Service), non-root users do not have write permission on the volume mount path for NFS-powered file storage. So, you could use a initcontainer to `chown` the mount. See a example below, where we add an initContainer on the master pod that reports to an external resource that the db is going to starting.
`values.yaml`
```yaml
master:
  extraInitContainers: |
    - name: initcontainer
      image: bitnami/minideb:latest
      command: ["/bin/sh", "-c"]
      args:
        - install_packages curl && curl http://api-service.local/db/starting;
```

## Upgrading

It's necessary to set the `rootUser.password` parameter when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, some notes will be displayed providing the credentials you must use under the 'Administrator credentials' section. Please note down the password and run the command below to upgrade your chart:

```bash
$ helm upgrade my-release stable/mariadb --set rootUser.password=[ROOT_PASSWORD]
```

| Note: you need to substitute the placeholder _[ROOT_PASSWORD]_ with the value obtained in the installation notes.

### To 6.0.0

MariaDB version was updated from 10.1 to 10.3, there are no changes in the chart itself. According to the official documentation, upgrading from 10.1 should be painless. However, there are some things that have changed which could affect an upgrade:

- [Incompatible changes upgrading from MariaDB 10.1 to MariaDB 10.2](https://mariadb.com/kb/en/library/upgrading-from-mariadb-101-to-mariadb-102//#incompatible-changes-between-101-and-102)
- [Incompatible changes upgrading from MariaDB 10.2 to MariaDB 10.3](https://mariadb.com/kb/en/library/upgrading-from-mariadb-102-to-mariadb-103/#incompatible-changes-between-102-and-103)

### To 5.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to 5.0.0. The following example assumes that the release name is mariadb:

```console
$ kubectl delete statefulset opencart-mariadb --cascade=false
```
