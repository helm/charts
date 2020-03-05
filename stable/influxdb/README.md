# DEPRECATED - InfluxDB

**This chart has been deprecated and moved to its new home:**

- **GitHub repo:** https://github.com/influxdata/helm-charts
- **Charts repo:** https://helm.influxdata.com/

##  An Open-Source Time Series Database

[InfluxDB](https://github.com/influxdata/influxdb) is an open source time series database built by the folks over at [InfluxData](https://influxdata.com) with no external dependencies. It's useful for recording metrics, events, and performing analytics.

## QuickStart

```bash
$ helm install stable/influxdb --name foo --namespace bar
```

## Introduction

This chart bootstraps an InfluxDB statefulset and service on a Kubernetes cluster using the Helm Package manager.

## Prerequisites

- Kubernetes 1.4+
- PV provisioner support in the underlying infrastructure (optional)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/influxdb
```

The command deploys InfluxDB on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The default configuration values for this chart are listed in `values.yaml`.

#### General

| Parameter | Description | Default |
|---|---|---|
| image.repository | Image repository url | influxdb |
| image.tag | Image tag | 1.7.6-alpine |
| image.pullPolicy | Image pull policy | IfNotPresent |
| image.pullSecrets | It will store the repository's credentials to pull image | nil |
| serviceAccount.create | It will create service account | true |
| serviceAccount.name | Service account name | "" |
| serviceAccount.annotations | Service account annotations | {} |
| livenessProbe | Health check for pod | {} |
| readinessProbe | Health check for pod | {} |
| startupProbe | Health check for pod | {} |
| service.type | Kubernetes service type | ClusterIP |
| persistence.enabled | Boolean to enable and disable persistance | true |
| persistence.storageClass | If set to "-", storageClassName: "", which disables dynamic provisioning. If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner.  (gp2 on AWS, standard on GKE, AWS & OpenStack |  |
| persistence.annotations | Annotations for volumeClaimTemplates | nil |
| persistence.accessMode | Access mode for the volume | ReadWriteOnce |
| persistence.size | Storage size | 8Gi |
| podAnnotations | Annotations for pod | {} |
| ingress.enabled | Boolean flag to enable or disable ingress | false |
| ingress.tls | Boolean to enable or disable tls for ingress. If enabled provide a secret in `ingress.secretName` containing TLS private key and certificate. | false |
| ingress.secretName | Kubernetes secret containing TLS private key and certificate. It is `only` required if `ingress.tls` is enabled. | nil |
| ingress.hostname | Hostname for the ingress | influxdb.foobar.com |
| annotations | ingress annotations | nil |
| schedulerName | Use an [alternate scheduler](https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/), e.g. "stork". | nil |
| nodeSelector | Node labels for pod assignment | {} |
| affinity | [Affinity](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity) for pod assignment |  {|
| tolerations | [Tolerations](https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/) for pod assignment | [] |
| env | environment variables for influxdb container | {} |
| config.reporting_disabled | [Details](https://docs.influxdata.com/influxdb/v1.7/administration/config/#reporting-disabled-false) | false |
| config.rpc | RPC address for backup and storage | {} |
| config.meta | [Details](https://docs.influxdata.com/influxdb/v1.7/administration/config/#meta) | {} |
| config.data | [Details](https://docs.influxdata.com/influxdb/v1.7/administration/config/#data) | {} |
| config.coordinator | [Details](https://docs.influxdata.com/influxdb/v1.7/administration/config/#coordinator) | {} |
| config.retention | [Details](https://docs.influxdata.com/influxdb/v1.7/administration/config/#retention) | {} |
| config.shard_precreation | [Details](https://docs.influxdata.com/influxdb/v1.7/administration/config/#shard-precreation) | {} |
| config.monitor | [Details](https://docs.influxdata.com/influxdb/v1.7/administration/config/#monitor) | {} |
| config.http | [Details](https://docs.influxdata.com/influxdb/v1.7/administration/config/#http) | {} |
| config.logging | [Details](https://docs.influxdata.com/influxdb/v1.7/administration/config/#logging) | {} |
| config.subscriber | [Details](https://docs.influxdata.com/influxdb/v1.7/administration/config/#subscriber) | {} |
| config.graphite | [Details](https://docs.influxdata.com/influxdb/v1.7/administration/config/#graphite) | {} |
| config.collectd | [Details](https://docs.influxdata.com/influxdb/v1.7/administration/config/#collectd) | {} |
| config.opentsdb | [Details](https://docs.influxdata.com/influxdb/v1.7/administration/config/#opentsdb) | {} |
| config.udp | [Details](https://docs.influxdata.com/influxdb/v1.7/administration/config/#udp) | {} |
| config.continous_queries | [Details](https://docs.influxdata.com/influxdb/v1.7/administration/config/#continuous-queries) | {} |
| config.tls | [Details](https://docs.influxdata.com/influxdb/v1.7/administration/config/#tls) | {} |
| initScripts.enabled | Boolean flag to enable and disable initscripts. If the container finds any files with the extensions .sh or .iql inside of the /docker-entrypoint-initdb.d folder, it will execute them. The order they are executed in is determined by the shell. This is usually alphabetical order. | false |
| initScripts.scripts | Init scripts | {} |
| backup.enabled | Boolean flag to enable and disable backups. Currently, it backups the data on `azure` and `gcs`. | false |
| backup.schedule | Cron time | `0 0 * * *`. It means create a backup everyday at `00:00`. |
| backup.annotations | Annotations for backup | {} |

The [full image documentation](https://hub.docker.com/_/influxdb/) contains more information about running InfluxDB in docker.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set persistence.enabled=true,persistence.size=200Gi \
    stable/influxdb
```

The above command enables persistence and changes the size of the requested data volume to 200GB.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/influxdb
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Enterprise
[InfluxDB Enterprise](https://www.influxdata.com/products/influxdb-enterprise/) is a hardened version of the open source core InfluxDB that includes additional closed source features designed for production workloads, featuring high availability and horizontal scaling. InfluxDB Enterprise features require a InfluxDB Enterprise license.

#### Configuration
To enable InfluxDB Enterprise, set the following keys and values in a values file provided to Helm.

| Key | Description | Recommended value |
| --- | --- | --- |
| `livenessProbe.initalDelaySeconds` | Used to allow enough time to join meta nodes to a cluster | `3600` |
| `image.tag` | Set to a `data` image. See https://hub.docker.com/_/influxdb for details | `data` |
| `service.ClusterIP` | Use a headless service for StatefulSets | `"None"` |
| `env.name[_HOSTNAME]` | Used to provide a unique `name.service` for InfluxDB. See [values.yaml]() for an example | `valueFrom.fieldRef.fieldPath: metadata.name` |
| `enterprise.enabled` | Create StatefulSets for use with `influx-data` and `influx-meta` images | `true` |
| `enterprise.licensekey` | License for InfluxDB Enterprise |  |
| `enterprise.clusterSize` | Replicas for `influx` StatefulSet | Dependent on license |
| `enterprise.meta.image.tag` | Set to an `meta` image. See https://hub.docker.com/_/influxdb for details | `meta` |
| `enterprise.meta.clusterSize` | Replicas for `influxdb-meta` StatefulSet. | `3` |
| `enterprise.meta.resources` | Resources requests and limits for meta `influxdb-meta` pods | See `values.yaml` |

#### Join pods to InfluxDB Enterprise cluster
Meta and data pods need to be joined together using the command `influxd-ctl` found on meta pods.
It is recommended you run `influxd-ctl` on one and only one meta pod, and to join meta pods together before data pods.
For each meta pod, run `influxd-ctl`. With default settings it should look something like this:
```shell script
kubectl exec influxdb-meta-0 influxd-ctl add-meta influxdb-meta-0.influxdb-meta:8091
```
From the same meta pod, for each data pod, run `influxd-ctl`. With default settings it should look something like this:
```shell script
kubectl exec influxdb-meta-0 influxd-ctl add-data influxdb-0.influxdb:8088
```
When using `influxd-ctl` be sure to use the appropriate DNS name for your pods, following the naming scheme of `pod.service`.
In the above examples, the pod names were `influxdb-meta-0` and `influxdb-0` respectively, and the service name was `influxdb`

## Persistence

The [InfluxDB](https://hub.docker.com/_/influxdb/) image stores data in the `/var/lib/influxdb` directory in the container.

If persistence is enabled, a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) associated with Statefulset will be provisioned. The volume is created using dynamic volume provisioning. In case of a disruption e.g. a node drain, kubernetes ensures that the same volume will be reatached to the Pod, preventing any data loss. Althought, when persistence is not enabled, InfluxDB data will be stored in an empty directory thus, in a Pod restart, data will be lost.

## Starting with authentication

In `values.yaml` change `.Values.config.http.auth_enabled` to `true`.

Influxdb requires also a user to be set in order for authentication to be enforced. See more details [here](https://docs.influxdata.com/influxdb/v1.2/query_language/authentication_and_authorization/#set-up-authentication).

To handle this setup on startup, a job can be enabled in `values.yaml` by setting `.Values.setDefaultUser.enabled` to `true`.

Make sure to uncomment or configure the job settings after enabling it. If a password is not set, a random password will be generated.

Alternatively, if `.Values.setDefaultUser.user.existingSecret` is set the user and password are obtained from an existing Secret, the expected keys are `influxdb-user` and `influxdb-password`. Use this variable  if you need to check in the `values.yaml` in a repository to avoid exposing your secrets.

## Upgrading

### From < 1.0.0 To >= 1.0.0

Values `.Values.config.bind_address` and `.Values.exposeRpc` no longer exist. They have been replaced with `.Values.config.rpc.bind_address` and `.Values.config.rpc.enabled` respectively. Please adjust your values file accordingly.

### From < 1.5.0 to >= 2.0.0

The Kubernetes API change to support 1.160 may not be backwards compatible and may require the chart to be uninstalled in order to upgrade.  See [this issue](https://github.com/helm/helm/issues/6583) for some background.

### From < 3.0.0 to >= 3.0.0

Since version 3.0.0 this chart uses a StatefulSet instead of a Deployment. As part of this update the existing persistent volume (and all data) is deleted and a new one is created. Make sure to backup and restore the data manually.

### From < 4.0.0 to >= 4.0.0

Labels are changed to those in accordance with [kubernetes recommended labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/\#labels). This change also removes the ability to configure clusterIP value as to avoid `Error: UPGRADE FAILED: failed to replace object: Service "my-influxdb" is invalid: spec.clusterIP: Invalid value: "": field is immutable` type errors. For more info on this error and why it should be avoided at all costs, please see [this github issue](https://github.com/helm/helm/issues/6378#issuecomment-582764215).

Due to the significance of the changes. The recommended approach is to uninstall and reinstall the chart (the PVC *should* not be deleted during this process, but it is highly recommended to backup your data before).
