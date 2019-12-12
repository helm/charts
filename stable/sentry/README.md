# Sentry

[Sentry](https://sentry.io/) is a cross-platform crash reporting and aggregation platform.

_This helm chart is **not** official nor maintained by Sentry itself._

## TL;DR;

```console
$ helm install --wait stable/sentry
```

## Introduction

This chart bootstraps a [Sentry](https://sentry.io/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also optionally packages the [PostgreSQL](https://github.com/kubernetes/charts/tree/master/stable/postgresql) and [Redis](https://github.com/kubernetes/charts/tree/master/stable/redis) which are required for Sentry.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- helm >= v2.3.0 to run "weighted" hooks in right order.
- PV provisioner support in the underlying infrastructure (with persistence storage enabled)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release --wait stable/sentry
```

> **Note**: We have to use the --wait flag for initial creation because the database creation takes longer than the default 300 seconds

The command deploys Sentry on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

> **Warning**: This Chart does not support `helm upgrade` an upgrade will currently reset your installation

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Warning**: Jobs are not deleted automatically. They need to be manually deleted

```console
$ kubectl delete job/sentry-db-init job/sentry-user-create
```

## Configuration

The following table lists the configurable parameters of the Sentry chart and their default values.

Dependent charts can also have values overwritten. Preface values with postgresql.* or redis.*
=======
Parameter                                            | Description                                                                                                | Default
:--------------------------------------------------- | :--------------------------------------------------------------------------------------------------------- | :---------------------------------------------------
`image.repository`                                   | Sentry image                                                                                               | `library/sentry`
`image.tag`                                          | Sentry image tag                                                                                           | `9.1.2`
`image.pullPolicy`                                   | Image pull policy                                                                                          | `IfNotPresent`
`image.imagePullSecrets`                             | Specify image pull secrets                                                                                 | `[]`
`sentrySecret`                                       | Specify SENTRY_SECRET_KEY. If isn't specified it will be generated automatically.                          | `nil`
`web.podAnnotations`                                 | Web pod annotations                                                                                        | `{}`
`web.podLabels`                                      | Web pod extra labels                                                                                       | `{}`
`web.replicacount`                                   | Amount of web pods to run                                                                                  | `1`
`web.resources.limits`                               | Web resource limits                                                                                        | `{cpu: 500m, memory: 500Mi}`
`web.resources.requests`                             | Web resource requests                                                                                      | `{cpu: 300m, memory: 300Mi}`
`web.env`                                            | Additional web environment variables                                                                       | `[{name: GITHUB_APP_ID}, {name: GITHUB_API_SECRET}]`
`web.nodeSelector`                                   | Node labels for web pod assignment                                                                         | `{}`
`web.affinity`                                       | Affinity settings for web pod assignment                                                                   | `{}`
`web.schedulerName`                                  | Name of an alternate scheduler for web pod                                                                 | `nil`
`web.tolerations`                                    | Toleration labels for web pod assignment                                                                   | `[]`
`web.probeInitialDelaySeconds`                       | The number of seconds before the probe doing healthcheck                                                   | `50`
`web.priorityClassName`                              | The priorityClassName on web deployment                                                                    | `nil`
`cron.podAnnotations`                                | Cron pod annotations                                                                                       | `{}`
`cron.podLabels`                                     | Worker pod extra labels                                                                                    | `{}`
`cron.replicacount`                                  | Amount of cron pods to run                                                                                 | `1`
`cron.resources.limits`                              | Cron resource limits                                                                                       | `{cpu: 200m, memory: 200Mi}`
`cron.resources.requests`                            | Cron resource requests                                                                                     | `{cpu: 100m, memory: 100Mi}`
`cron.nodeSelector`                                  | Node labels for cron pod assignment                                                                        | `{}`
`cron.affinity`                                      | Affinity settings for cron pod assignment                                                                  | `{}`
`cron.schedulerName`                                 | Name of an alternate scheduler for cron pod                                                                | `nil`
`cron.tolerations`                                   | Toleration labels for cron pod assignment                                                                  | `[]`
`cron.priorityClassName`                             | The priorityClassName on cron deployment                                                                   | `nil`
`worker.podAnnotations`                              | Worker pod annotations                                                                                     | `{}`
`worker.podLabels`                                   | Worker pod extra labels                                                                                    | `{}`
`worker.replicacount`                                | Amount of worker pods to run                                                                               | `2`
`worker.resources.limits`                            | Worker resource limits                                                                                     | `{cpu: 300m, memory: 500Mi}`
`worker.resources.requests`                          | Worker resource requests                                                                                   | `{cpu: 100m, memory: 100Mi}`
`worker.nodeSelector`                                | Node labels for worker pod assignment                                                                      | `{}`
`worker.schedulerName`                               | Name of an alternate scheduler for worker                                                                  | `nil`
`worker.affinity`                                    | Affinity settings for worker pod assignment                                                                | `{}`
`worker.tolerations`                                 | Toleration labels for worker pod assignment                                                                | `[]`
`worker.concurrency`                                 | Celery worker concurrency                                                                                  | `nil`
`worker.priorityClassName`                           | The priorityClassName on workers deployment                                                                | `nil`
`user.create`                                        | Create the default admin                                                                                   | `true`
`user.email`                                         | Username for default admin                                                                                 | `admin@sentry.local`
`email.from_address`                                 | Email notifications are from                                                                               | `smtp`
`email.host`                                         | SMTP host for sending email                                                                                | `smtp`
`email.port`                                         | SMTP port                                                                                                  | `25`
`email.user`                                         | SMTP user                                                                                                  | `nil`
`email.password`                                     | SMTP password                                                                                              | `nil`
`email.use_tls`                                      | SMTP TLS for security                                                                                      | `false`
`email.enable_replies`                               | Allow email replies                                                                                        | `false`
`email.existingSecret`                               | SMTP password from an existing secret (key must be `smtp-password`)                                        | `nil`
`service.type`                                       | Kubernetes service type                                                                                    | `LoadBalancer`
`service.name`                                       | Kubernetes service name                                                                                    | `sentry`
`service.externalPort`                               | Kubernetes external service port                                                                           | `9000`
`service.internalPort`                               | Kubernetes internal service port                                                                           | `9000`
`service.annotations`                                | Service annotations                                                                                        | `{}`
`service.nodePort`                                   | Kubernetes service NodePort port                                                                           | Randomly chosen by Kubernetes
`service.loadBalancerSourceRanges`                   | Allow list for the load balancer                                                                           | `nil`
`ingress.enabled`                                    | Enable ingress controller resource                                                                         | `false`
`ingress.annotations`                                | Ingress annotations                                                                                        | `{}`
`ingress.hostname`                                   | URL to address your Sentry installation                                                                    | `sentry.local`
`ingress.path`                                       | path to address your Sentry installation                                                                   | `/`
`ingress.tls`                                        | Ingress TLS configuration                                                                                  | `[]`
`postgresql.enabled`                                 | Deploy postgres server (see below)                                                                         | `true`
`postgresql.postgresqlDatabase`                      | Postgres database name                                                                                     | `sentry`
`postgresql.postgresqlUsername`                      | Postgres username                                                                                          | `postgres`
`postgresql.postgresqlHost`                          | External postgres host                                                                                     | `nil`
`postgresql.postgresqlPassword`                      | External/Internal postgres password                                                                                 | `nil`
`postgresql.postgresqlPort`                          | External postgres port                                                                                     | `5432`
`redis.enabled`                                      | Deploy redis server (see below)                                                                            | `true`
`redis.host`                                         | External redis host                                                                                        | `nil`
`redis.password`                                     | External redis password                                                                                    | `nil`
`redis.port`                                         | External redis port                                                                                        | `6379`
`filestore.backend`                                  | Backend for Sentry Filestore                                                                               | `filesystem`
`filestore.filesystem.path`                          | Location to store files for Sentry                                                                         | `/var/lib/sentry/files`
`filestore.filesystem.persistence.enabled`           | Enable Sentry files persistence using PVC                                                                  | `true`
`filestore.filesystem.persistence.existingClaim`     | Provide an existing `PersistentVolumeClaim`                                                                | `nil`
`filestore.filesystem.persistence.storageClass`      | PVC Storage Class                                                                                          | `nil` (uses alpha storage class annotation)
`filestore.filesystem.persistence.accessMode`        | PVC Access Mode                                                                                            | `ReadWriteOnce`
`filestore.filesystem.persistence.size`              | PVC Storage Request                                                                                        | `10Gi`
`filestore.filesystem.persistence.persistentWorkers` | Mount the PVC to Sentry workers, enabling features such as private source maps                             | `false`
`filestore.gcs.credentialsFile`                      | Filename of the service account in secret                                                                  | `credentials.json`
`filestore.gcs.secretName`                           | The name of the secret for GCS access                                                                      | `nil`
`filestore.gcs.bucketName`                           | The name of the GCS bucket                                                                                 | `nil`
`filestore.s3.accessKey`                             | S3 access key                                                                                              | `nil`
`filestore.s3.secretKey`                             | S3 secret key                                                                                              | `nil`
`filestore.s3.bucketName`                            | The name of the S3 bucket                                                                                  | `nil`
`filestore.s3.endpointUrl`                           | The endpoint url of the S3 (using for "MinIO S3 Backend")                                                  | `nil`
`filestore.s3.signature_version`                     | S3 signature version (optional)                                                                            | `nil`
`filestore.s3.region_name`                           | S3 region name (optional)                                                                                  | `nil`
`filestore.s3.default_acl`                           | S3 default acl (optional)                                                                                  | `nil`
`config.configYml`                                   | Sentry config.yml file                                                                                     | ``
`config.sentryConfPy`                                | Sentry sentry.conf.py file                                                                                 | ``
`metrics.enabled`                                    | Start an exporter for sentry metrics                                                                       | `false`
`metrics.nodeSelector`                               | Node labels for metrics pod assignment                                                                     | `{}`
`metrics.tolerations`                                | Toleration labels for metrics pod assignment                                                               | `[]`
`metrics.affinity`                                   | Affinity settings for metrics pod                                                                          | `{}`
`metrics.schedulerName`                              | Name of an alternate scheduler for metrics pod                                                             | `nil`
`metrics.podLabels`                                  | Labels for metrics pod                                                                                     | `nil`
`metrics.resources`                                  | Metrics resource requests/limit                                                                            | `{}`
`metrics.service.type`                               | Kubernetes service type for metrics service                                                                | `ClusterIP`
`metrics.service.labels`                             | Additional labels for metrics service                                                                      | `{}`
`metrics.image.repository`                           | Metrics exporter image repository                                                                          | `prom/statsd-exporter`
`metrics.image.tag`                                  | Metrics exporter image tag                                                                                 | `v0.10.5`
`metrics.image.PullPolicy`                           | Metrics exporter image pull policy                                                                         | `IfNotPresent`
`metrics.serviceMonitor.enabled`                     | if `true`, creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)     | `false`
`metrics.serviceMonitor.namespace`                   | Optional namespace which Prometheus is running in                                                          | `nil`
`metrics.serviceMonitor.interval`                    | How frequently to scrape metrics (use by default, falling back to Prometheus' default)                     | `nil`
`metrics.serviceMonitor.selector`                    | Default to kube-prometheus install (CoreOS recommended), but should be set according to Prometheus install | `{ prometheus: kube-prometheus }`
`hooks.affinity`                                     | Affinity settings for hooks pods                                                                           | `{}`
`hooks.dbInit.resources.limits`                      | Hook job resource limits                                                                                   | `{memory: 3200Mi}`
`hooks.dbInit.resources.requests`                    | Hook job resource requests                                                                                 | `{memory: 3000Mi}`

Dependent charts can also have values overwritten. Preface values with postgresql. _or redis._

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set persistence.enabled=false,email.host=email \
    stable/sentry
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/sentry
```

> **Tip**: You can use the default <values.yaml>

## PostgresSQL

By default, PostgreSQL is installed as part of the chart. To use an external PostgreSQL server set `postgresql.enabled` to `false` and then set `postgresql.postgresHost` and `postgresql.postgresqlPassword`. The other options (`postgresql.postgresqlDatabase`, `postgresql.postgresqlUsername` and `postgresql.postgresqlPort`) may also want changing from their default values.

To avoid issues when upgrade this chart, provide `postgresql.postgresqlPassword` for subsequent upgrades. This is due to an issue in the PostgreSQL chart where password will be overwritten with randomly generated passwords otherwise. See https://github.com/helm/charts/tree/master/stable/postgresql#upgrade for more detail.

## Redis

By default, Redis is installed as part of the chart. To use an external Redis server/cluster set `redis.enabled` to `false` and then set `redis.host`. If your redis cluster uses password define it with `redis.password`, otherwise just omit it. Check the table above for more configuration options.

## Persistence

The [Sentry](https://github.com/getsentry/docker-sentry) image stores the Sentry data at the `/var/lib/sentry/files` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube. See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Ingress

This chart provides support for Ingress resource. If you have an available Ingress Controller such as Nginx or Traefik you maybe want to set `ingress.enabled` to true and choose an `ingress.hostname` for the URL. Then, you should be able to access the installation using that address.

## Persistence

This chart is capable of mounting the sentry-data PV in the Sentry worker and cron pods. This feature is disabled by default, but is needed for some advanced features such as private sourcemaps.

You may enable mounting of the sentry-data PV across worker and cron pods by changing `filestore.filesystem.persistence.persistentWorkers` to `true`. If you plan on deploying Sentry containers across multiple nodes, you may need to change your PVC's access mode to `ReadWriteMany` and check that your PV supports mounting across multiple nodes.

## Upgrading from pre-2.0.0

The `persistence` keys have changed in charts 2.0.0 and newer, the following shows the mapping of keys from pre-2.0.0 to their current form:

Previous Key                    | New Key
:-------------------------------|---------
`persistence.enabled`           | `filestore.filesystem.persistence.enabled`
`persistence.existingClaim`     | `filestore.filesystem.persistence.existingClaim`
`persistence.storageClass`      | `filestore.filesystem.persistence.storageClass`
`persistence.accessMode`        | `filestore.filesystem.persistence.accessMode`
`persistence.size`              | `filestore.filesystem.persistence.size`
`persistence.filestore_dir`     | `filestore.filesystem.path`
`persistence.persistentWorkers` | `filestore.filesystem.persistence.persistentWorkers`
