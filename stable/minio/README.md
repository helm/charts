MinIO
=====

[MinIO](https://min.io) is a distributed object storage service for high performance, high scale data infrastructures. It is a drop in replacement for AWS S3 in your own environment. It uses erasure coding to provide highly resilient storage that can tolerate failures of upto n/2 nodes. It runs on cloud, container, kubernetes and bare-metal environments. It is simple enough to be deployed in seconds, and can scale to 100s of peta bytes. MinIO is suitable for storing objects such as photos, videos, log files, backups, VM and container images.

MinIO supports [distributed mode](https://docs.minio.io/docs/distributed-minio-quickstart-guide). In distributed mode, you can pool multiple drives (even on different machines) into a single object storage server.

Introduction
------------

This chart bootstraps MinIO deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Prerequisites
-------------

-	Kubernetes 1.4+ with Beta APIs enabled for default standalone mode.
-   Kubernetes 1.5+ with Beta APIs enabled to run MinIO in [distributed mode](#distributed-minio).
-	PV provisioner support in the underlying infrastructure.

Installing the Chart
--------------------

Install this chart using:

```bash
$ helm install stable/minio
```

The command deploys MinIO on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

### Release name

An instance of a chart running in a Kubernetes cluster is called a release. Each release is identified by a unique name within the cluster. Helm automatically assigns a unique release name after installing the chart. You can also set your preferred name by:

```bash
$ helm install --name my-release stable/minio
```

### Access and Secret keys

By default a pre-generated access and secret key will be used. To override the default keys, pass the access and secret keys as arguments to helm install.

```bash
$ helm install --set accessKey=myaccesskey,secretKey=mysecretkey \
    stable/minio
```

### Updating MinIO configuration via Helm

[ConfigMap](https://kubernetes.io/docs/user-guide/configmap/) allows injecting containers with configuration data even while a Helm release is deployed.

To update your MinIO server configuration while it is deployed in a release, you need to

1. Check all the configurable values in the MinIO chart using `helm inspect values stable/minio`.
2. Override the `minio_server_config` settings in a YAML formatted file, and then pass that file like this `helm upgrade -f config.yaml stable/minio`.
3. Restart the MinIO server(s) for the changes to take effect.

You can also check the history of upgrades to a release using `helm history my-release`. Replace `my-release` with the actual release name.

Uninstalling the Chart
----------------------

Assuming your release is named as `my-release`, delete it using the command:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

Upgrading the Chart
-------------------

You can use Helm to update MinIO version in a live release. Assuming your release is named as `my-release`, get the values using the command:

```bash
$ helm get values my-release > old_values.yaml
```

Then change the field `image.tag` in `old_values.yaml` file with MinIO image tag you want to use. Now update the chart using

```bash
$ helm upgrade -f old_values.yaml my-release stable/minio
```

Default upgrade strategies are specified in the `values.yaml` file. Update these fields if you'd like to use a different strategy.

Configuration
-------------

The following table lists the configurable parameters of the MinIO chart and their default values.

| Parameter                  | Description                         | Default                                                 |
|----------------------------|-------------------------------------|---------------------------------------------------------|
| `image.repository`         | Image repository                    | `minio/minio`                                           |
| `image.tag`                | MinIO image tag. Possible values listed [here](https://hub.docker.com/r/minio/minio/tags/).| `RELEASE.2019-05-14T23-57-45Z`|
| `image.pullPolicy`         | Image pull policy                   | `IfNotPresent`                                          |
| `mcImage.repository`       | Client image repository             | `minio/mc`                                              |
| `mcImage.tag`              | mc image tag. Possible values listed [here](https://hub.docker.com/r/minio/mc/tags/).| `RELEASE.2019-05-01T23-27-44Z`|
| `mcImage.pullPolicy`       | mc Image pull policy                | `IfNotPresent`                                          |
| `ingress.enabled`          | Enables Ingress                     | `false`                                                 |
| `ingress.annotations`      | Ingress annotations                 | `{}`                                                    |
| `ingress.hosts`            | Ingress accepted hostnames          | `[]`                                                    |
| `ingress.tls`              | Ingress TLS configuration           | `[]`                                                    |
| `mode`                     | MinIO server mode (`standalone` or `distributed`)| `standalone`                               |
| `replicas`                 | Number of nodes (applicable only for MinIO distributed mode). Should be 4 <= x <= 32 | `4`    |
| `existingSecret`           | Name of existing secret with access and secret key.| `""`                                     |
| `accessKey`                | Default access key (5 to 20 characters) | `AKIAIOSFODNN7EXAMPLE`                              |
| `secretKey`                | Default secret key (8 to 40 characters) | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`          |
| `configPath`               | Default config file location        | `~/.minio`                                              |
| `configPathmc`             | Default config file location for MinIO client - mc | `~/.mc`                                  |
| `mountPath`                | Default mount location for persistent drive| `/export`                                        |
| `clusterDomain`            | domain name of kubernetes cluster where pod is running.| `cluster.local`                      |
| `service.type`             | Kubernetes service type             | `ClusterIP`                                             |
| `service.port`             | Kubernetes port where service is exposed| `9000`                                              |
| `service.externalIPs`      | service external IP addresses | `nil`                                                         |
| `service.annotations`      | Service annotations                 | `{}`                                                    |
| `serviceAccount.create`    | Toggle creation of new service account | `true`                                               |
| `serviceAccount.name`      | Name of service account to create and/or use | `""`                                           |
| `persistence.enabled`      | Use persistent volume to store data | `true`                                                  |
| `persistence.size`         | Size of persistent volume claim     | `10Gi`                                                  |
| `persistence.existingClaim`| Use an existing PVC to persist data | `nil`                                                   |
| `persistence.storageClass` | Storage class name of PVC           | `nil`                                                   |
| `persistence.accessMode`   | ReadWriteOnce or ReadOnly           | `ReadWriteOnce`                                         |
| `persistence.subPath`      | Mount a sub directory of the persistent volume if set | `""`                                  |
| `resources`                | CPU/Memory resource requests/limits | Memory: `256Mi`, CPU: `100m`                            |
| `priorityClassName`        | Pod priority settings               | `""`                                                    |
| `nodeSelector`             | Node labels for pod assignment      | `{}`                                                    |
| `affinity`                 | Affinity settings for pod assignment | `{}`                                                   |
| `tolerations`              | Toleration labels for pod assignment | `[]`                                                   |
| `podAnnotations`           | Pod annotations                      | `{}`                                                   |
| `tls.enabled`              | Enable TLS for MinIO server | `false`                                                         |
| `tls.certSecret`           | Kubernetes Secret with `public.crt` and `private.key` files. | `""`                           |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated        | `5`                               |
| `livenessProbe.periodSeconds`        | How often to perform the probe                  | `30`                              |
| `livenessProbe.timeoutSeconds`       | When the probe times out                        | `1`                               |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed. | `1` |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | `3` |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated       | `5`                               |
| `readinessProbe.periodSeconds`       | How often to perform the probe                  | `15`                              |
| `readinessProbe.timeoutSeconds`      | When the probe times out                        | `1`                               |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed. | `1` |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | `3` |
| `defaultBucket.enabled`    | If set to true, a bucket will be created after MinIO install | `false`                        |
| `defaultBucket.name`       | Bucket name                         | `bucket`                                                |
| `defaultBucket.policy`     | Bucket policy                       | `none`                                                  |
| `defaultBucket.purge`      | Purge the bucket if already exists  | `false`                                                 |
| `buckets`                  | List of buckets to create after MinIO install  | `[]`                                         |
| `s3gateway.enabled`        | Use MinIO as a [s3 gateway](https://github.com/minio/minio/blob/master/docs/gateway/s3.md)| `false` |
| `s3gateway.replicas`       | Number of s3 gateway instances to run in parallel | `4` |
| `s3gateway.serviceEndpoint`| Endpoint to the S3 compatible service | `""` |
| `azuregateway.enabled`     | Use MinIO as an [azure gateway](https://docs.minio.io/docs/minio-gateway-for-azure)| `false`  |
| `azuregateway.replicas`    | Number of azure gateway instances to run in parallel | `4` |
| `gcsgateway.enabled`       | Use MinIO as a [Google Cloud Storage gateway](https://docs.minio.io/docs/minio-gateway-for-gcs)| `false` |
| `gcsgateway.gcsKeyJson`    | credential json file of service account key | `""` |
| `gcsgateway.projectId`     | Google cloud project id             | `""` |
| `ossgateway.enabled`       | Use MinIO as an [Alibaba Cloud Object Storage Service gateway](https://github.com/minio/minio/blob/master/docs/gateway/oss.md)| `false` |
| `ossgateway.replicas`      | Number of oss gateway instances to run in parallel | `4` |
| `ossgateway.endpointURL`   | OSS server endpoint. | `""` |
| `nasgateway.enabled`       | Use MinIO as a [NAS gateway](https://docs.MinIO.io/docs/minio-gateway-for-nas)             | `false` |
| `nasgateway.replicas`      | Number of NAS gateway instances to be run in parallel on a PV            | `4` |
| `environment`              | Set MinIO server relevant environment variables in `values.yaml` file. MinIO containers will be passed these variables when they start. | `MINIO_BROWSER: "on"` |
| `metrics.serviceMonitor.enabled`          | Set this to `true` to create ServiceMonitor for Prometheus operator                   | `false` |
| `metrics.serviceMonitor.additionalLabels` | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `{}`    |
| `metrics.serviceMonitor.namespace`        | Optional namespace in which to create ServiceMonitor                                  | `nil`   |
| `metrics.serviceMonitor.interval`         | Scrape interval. If not set, the Prometheus default scrape interval is used           | `nil`   |
| `metrics.serviceMonitor.scrapeTimeout`    | Scrape timeout. If not set, the Prometheus default scrape timeout is used             | `nil`   |

Some of the parameters above map to the env variables defined in the [MinIO DockerHub image](https://hub.docker.com/r/minio/minio/).

You can specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set persistence.size=100Gi \
    stable/minio
```

The above command deploys MinIO server with a 100Gi backing persistent volume.

Alternately, you can provide a YAML file that specifies parameter values while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/minio
```

> **Tip**: You can use the default [values.yaml](values.yaml)

Distributed MinIO
-----------

This chart provisions a MinIO server in standalone mode, by default. To provision MinIO server in [distributed mode](https://docs.minio.io/docs/distributed-minio-quickstart-guide), set the `mode` field to `distributed`,

```bash
$ helm install --set mode=distributed stable/minio
```

This provisions MinIO server in distributed mode with 4 nodes. To change the number of nodes in your distributed MinIO server, set the `replicas` field,

```bash
$ helm install --set mode=distributed,replicas=8 stable/minio
```

This provisions MinIO server in distributed mode with 8 nodes. Note that the `replicas` value should be an integer between 4 and 16 (inclusive).

### StatefulSet [limitations](http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/#limitations) applicable to distributed MinIO

1. StatefulSets need persistent storage, so the `persistence.enabled` flag is ignored when `mode` is set to `distributed`.
2. When uninstalling a distributed MinIO release, you'll need to manually delete volumes associated with the StatefulSet.

NAS Gateway
-----------

### Prerequisites

MinIO in [NAS gateway mode](https://docs.minio.io/docs/minio-gateway-for-nas) can be used to create multiple MinIO instances backed by single PV in `ReadWriteMany` mode. Currently few [Kubernetes volume plugins](https://kubernetes.io/docs/user-guide/persistent-volumes/#access-modes) support `ReadWriteMany` mode. To deploy MinIO NAS gateway with Helm chart you'll need to have a Persistent Volume running with one of the supported volume plugins. [This document](https://kubernetes.io/docs/user-guide/volumes/#nfs)
outlines steps to create a NFS PV in Kubernetes cluster.

### Provision NAS Gateway MinIO instances

To provision MinIO servers in [NAS gateway mode](https://docs.minio.io/docs/minio-gateway-for-nas), set the `nasgateway.enabled` field to `true`,

```bash
$ helm install --set nasgateway.enabled=true stable/minio
```

This provisions 4 MinIO NAS gateway instances backed by single storage. To change the number of instances in your MinIO deployment, set the `replicas` field,

```bash
$ helm install --set nasgateway.enabled=true,nasgateway.replicas=8 stable/minio
```

This provisions MinIO NAS gateway with 8 instances.

Persistence
-----------

This chart provisions a PersistentVolumeClaim and mounts corresponding persistent volume to default location `/export`. You'll need physical storage available in the Kubernetes cluster for this to work. If you'd rather use `emptyDir`, disable PersistentVolumeClaim by:

```bash
$ helm install --set persistence.enabled=false stable/minio
```

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

Existing PersistentVolumeClaim
------------------------------

If a Persistent Volume Claim already exists, specify it during installation.

1. Create the PersistentVolume
2. Create the PersistentVolumeClaim
3. Install the chart

```bash
$ helm install --set persistence.existingClaim=PVC_NAME stable/minio
```

NetworkPolicy
-------------

To enable network policy for MinIO,
install [a networking plugin that implements the Kubernetes
NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin),
and set `networkPolicy.enabled` to `true`.

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting
the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

    kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"

With NetworkPolicy enabled, traffic will be limited to just port 9000.

For more precise policy, set `networkPolicy.allowExternal=true`. This will
only allow pods with the generated client label to connect to MinIO.
This label will be displayed in the output of a successful install.

Existing secret
---------------

Instead of having this chart create the secret for you, you can supply a preexisting secret, much
like an existing PersistentVolumeClaim.

First, create the secret:
```bash
$ kubectl create secret generic my-minio-secret --from-literal=accesskey=foobarbaz --from-literal=secretkey=foobarbazqux
```

Then install the chart, specifying that you want to use an existing secret:
```bash
$ helm install --set existingSecret=my-minio-secret stable/minio
```

The following fields are expected in the secret
1. `accesskey` - the access key ID
2. `secretkey` - the secret key
3. `gcs_key.json` - The GCS key if you are using the GCS gateway feature. This is optional.

Configure TLS
-------------

To enable TLS for MinIO containers, acquire TLS certificates from a CA or create self-signed certificates. While creating / acquiring certificates ensure the corresponding domain names are set as per the standard [DNS naming conventions](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#pod-identity) in a Kubernetes StatefulSet (for a distributed MinIO setup). Then create a secret using

```bash
$ kubectl create secret generic tls-ssl-minio --from-file=path/to/private.key --from-file=path/to/public.crt
```

Then install the chart, specifying that you want to use the TLS secret:

```bash
$ helm install --set tls.enabled=true,tls.certSecret=tls-ssl-minio stable/minio
```

Pass environment variables to MinIO containers
----------------------------------------------

To pass environment variables to MinIO containers when deploying via Helm chart, use the below command line format

```bash
$ helm install --set environment.MINIO_BROWSER=on,environment.MINIO_DOMAIN=domain-name stable/minio
```

You can add as many environment variables as required, using the above format. Just add `environment.<VARIABLE_NAME>=<value>` under `set` flag.

Create buckets after install
---------------------------

Install the chart, specifying the buckets you want to create after install:

```bash
$ helm install --set buckets[0].name=bucket1,buckets[0].policy=none,buckets[0].purge=false stable/minio
```

Description of the configuration parameters used above - 
1. `buckets[].name` - name of the bucket to create, must be a string with length > 0
2. `buckets[].policy` - Can be one of none|download|upload|public
3. `buckets[].purge` - Purge if bucket exists already

