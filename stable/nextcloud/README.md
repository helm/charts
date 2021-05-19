# DEPRECATED - nextcloud

|**This chart has been deprecated and moved to its new home:**
|
|- **GitHub repo:** https://github.com/nextcloud/helm/tree/master/charts/nextcloud
|- **Charts repo:** https://nextcloud.github.io/helm/

[nextcloud](https://nextcloud.com/) is a file sharing server that puts the control and security of your own data back into your hands.

## TL;DR;

```console
$ helm install stable/nextcloud
```

## Introduction

This chart bootstraps an [nextcloud](https://hub.docker.com/_/nextcloud/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the nextcloud application.

## Prerequisites

- Kubernetes 1.9+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/nextcloud
```

The command deploys nextcloud on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the nextcloud chart and their default values.

| Parameter                                                    | Description                                             | Default                                     |
| ------------------------------------------------------------ | ------------------------------------------------------- | ------------------------------------------- |
| `image.repository`                                           | nextcloud Image name                                    | `nextcloud`                                 |
| `image.tag`                                                  | nextcloud Image tag                                     | `{VERSION}`                                 |
| `image.pullPolicy`                                           | Image pull policy                                       | `IfNotPresent`                              |
| `image.pullSecrets`                                          | Specify image pull secrets                              | `nil`                                       |
| `ingress.enabled`                                            | Enable use of ingress controllers                       | `false`                                     |
| `ingress.servicePort`                                        | Ingress' backend servicePort                            | `http`                                      |
| `ingress.annotations`                                        | An array of service annotations                         | `nil`                                       |
| `ingress.labels`                                             | An array of service labels                              | `nil`                                       |
| `ingress.tls`                                                | Ingress TLS configuration                               | `[]`                                        |
| `nextcloud.host`                                             | nextcloud host to create application URLs               | `nextcloud.kube.home`                       |
| `nextcloud.username`                                         | User of the application                                 | `admin`                                     |
| `nextcloud.password`                                         | Application password                                    | `changeme`                                  |
| `nextcloud.update`                                           | Trigger update if custom command is used                | `0`                                         |
| `nextcloud.datadir`                                          | nextcloud data dir location                             | `/var/www/html/data`                        |
| `nextcloud.tableprefix`                                      | nextcloud db table prefix                               | `''`                                        |
| `nextcloud.mail.enabled`                                     | Whether to enable/disable email settings                | `false`                                     |
| `nextcloud.mail.fromAddress`                                 | nextcloud mail send from field                          | `nil`                                       |
| `nextcloud.mail.domain`                                      | nextcloud mail domain                                   | `nil`                                       |
| `nextcloud.mail.smtp.host`                                   | SMTP hostname                                           | `nil`                                       |
| `nextcloud.mail.smtp.secure`                                 | SMTP connection `ssl` or empty                          | `''`                                        |
| `nextcloud.mail.smtp.port`                                   | Optional SMTP port                                      | `nil`                                       |
| `nextcloud.mail.smtp.authtype`                               | SMTP authentication method                              | `LOGIN`                                     |
| `nextcloud.mail.smtp.name`                                   | SMTP username                                           | `''`                                        |
| `nextcloud.mail.smtp.password`                               | SMTP password                                           | `''`                                        |
| `nextcloud.configs`                                          | Config files created in `/var/www/html/config`          | `{}`                                        |
| `nextcloud.persistence.subPath`                              | Set the subPath for nextcloud to use in volume          | `nil`                                       |
| `nextcloud.phpConfigs`                                       | PHP Config files created in `/usr/local/etc/php/conf.d` | `{}`                                        |
| `nextcloud.defaultConfigs.\.htaccess`                        | Default .htaccess to protect `/var/www/html/config`     | `true`                                      |
| `nextcloud.defaultConfigs.\.redis\.config\.php`              | Default Redis configuration                             | `true`                                      |
| `nextcloud.defaultConfigs.\.apache-pretty-urls\.config\.php` | Default Apache configuration for rewrite urls           | `true`                                      |
| `nextcloud.defaultConfigs.\.apcu\.config\.php`               | Default configuration to define APCu as local cache     | `true`                                      |
| `nextcloud.defaultConfigs.\.apps\.config\.php`               | Default configuration for apps                          | `true`                                      |
| `nextcloud.defaultConfigs.\.autoconfig\.php`                 | Default auto-configuration for databases                | `true`                                      |
| `nextcloud.defaultConfigs.\.smtp\.config\.php`               | Default configuration for smtp                          | `true`                                      |
| `nextcloud.strategy`                                         | specifies the strategy used to replace old Pods by new ones | `type: Recreate`                                      |
| `nextcloud.extraEnv`                                         | specify additional environment variables                | `{}`                                        |
| `nextcloud.extraVolumes`                                     | specify additional volumes for the NextCloud pod        | `{}`                                        |
| `nextcloud.extraVolumeMounts`                                | specify additional volume mounts for the NextCloud pod  | `{}`                                        |
| `nginx.enabled`                                              | Enable nginx (requires you use php-fpm image)           | `false`                                     |
| `nginx.image.repository`                                     | nginx Image name                                        | `nginx`                                     |
| `nginx.image.tag`                                            | nginx Image tag                                         | `alpine`                                    |
| `nginx.image.pullPolicy`                                     | nginx Image pull policy                                 | `IfNotPresent`                              |
| `nginx.config.default`                                       | Whether to use nextclouds recommended nginx config      | `true`                                      |
| `nginx.config.custom`                                        | Specify a custom config for nginx                       | `{}`                                        |
| `nginx.resources`                                            | nginx resources                                         | `{}`                                        |
| `lifecycle.postStartCommand`                                 | Specify deployment lifecycle hook postStartCommand      | `nil`                                       |
| `lifecycle.preStopCommand`                                   | Specify deployment lifecycle hook preStopCommand        | `nil`                                       |
| `internalDatabase.enabled`                                   | Whether to use internal sqlite database                 | `true`                                      |
| `internalDatabase.database`                                  | Name of the existing database                           | `nextcloud`                                 |
| `externalDatabase.enabled`                                   | Whether to use external database                        | `false`                                     |
| `externalDatabase.type`                                      | External database type: `mysql`, `postgresql`           | `mysql`                                     |
| `externalDatabase.host`                                      | Host of the external database                           | `nil`                                       |
| `externalDatabase.database`                                  | Name of the existing database                           | `nextcloud`                                 |
| `externalDatabase.user`                                      | Existing username in the external db                    | `nextcloud`                                 |
| `externalDatabase.password`                                  | Password for the above username                         | `nil`                                       |
| `externalDatabase.existingSecret.enabled`                    | Whether to use a existing secret or not                 | `false`                                     |
| `externalDatabase.existingSecret.secretName`                 | Name of the existing secret                             | `nil`                                       |
| `externalDatabase.existingSecret.usernameKey`                | Name of the key that contains the username              | `nil`                                       |
| `externalDatabase.existingSecret.passwordKey`                | Name of the key that contains the password              | `nil`                                       |
| `mariadb.enabled`                                            | Whether to use the MariaDB chart                        | `false`                                     |
| `mariadb.db.name`                                            | Database name to create                                 | `nextcloud`                                 |
| `mariadb.db.password`                                        | Password for the database                               | `changeme`                                  |
| `mariadb.db.user`                                            | Database user to create                                 | `nextcloud`                                 |
| `mariadb.rootUser.password`                                  | MariaDB admin password                                  | `nil`                                       |
| `redis.enabled`                                              | Whether to install/use redis for locking                | `false`                                     |
| `cronjob.enabled`                                            | Whether to enable/disable cronjob                       | `false`                                     |
| `cronjob.schedule`                                           | Schedule for the CronJob                                | `*/15 * * * *`                              |
| `cronjob.annotations`                                        | Annotations to add to the cronjob                       | {}                                          |
| `cronjob.curlInsecure`                                       | Set insecure (-k) option to curl                        | false                                       |
| `cronjob.failedJobsHistoryLimit`                             | Specify the number of failed Jobs to keep               | `5`                                         |
| `cronjob.successfulJobsHistoryLimit`                         | Specify the number of completed Jobs to keep            | `2`                                         |
| `cronjob.resources`                                          | Cronjob Resources                                       | `nil`                                       |
| `cronjob.nodeSelector`                                       | Cronjob Node selector                                   | `nil`                                       |
| `cronjob.tolerations`                                        | Cronjob tolerations                                     | `nil`                                       |
| `cronjob.affinity`                                           | Cronjob affinity                                        | `nil`                                       |
| `service.type`                                               | Kubernetes Service type                                 | `ClusterIp`                                 |
| `service.loadBalancerIP`                                     | LoadBalancerIp for service type LoadBalancer            | `nil`                                       |
| `service.nodePort`                                           | NodePort for service type NodePort                      | `nil`                                       |
| `persistence.enabled`                                        | Enable persistence using PVC                            | `false`                                     |
| `persistence.annotations`                                    | PVC annotations                                         | `{}`                                        |
| `persistence.storageClass`                                   | PVC Storage Class for nextcloud volume                  | `nil` (uses alpha storage class annotation) |
| `persistence.existingClaim`                                  | An Existing PVC name for nextcloud volume               | `nil` (uses alpha storage class annotation) |
| `persistence.accessMode`                                     | PVC Access Mode for nextcloud volume                    | `ReadWriteOnce`                             |
| `persistence.size`                                           | PVC Storage Request for nextcloud volume                | `8Gi`                                       |
| `resources`                                                  | CPU/Memory resource requests/limits                     | `{}`                                        |
| `livenessProbe.enabled`                                      | Turn on and off liveness probe                          | `true`                                      |
| `livenessProbe.initialDelaySeconds`                          | Delay before liveness probe is initiated                | `30`                                        |
| `livenessProbe.periodSeconds`                                | How often to perform the probe                          | `15`                                        |
| `livenessProbe.timeoutSeconds`                               | When the probe times out                                | `5`                                         |
| `livenessProbe.failureThreshold`                             | Minimum consecutive failures for the probe              | `3`                                         |
| `livenessProbe.successThreshold`                             | Minimum consecutive successes for the probe             | `1`                                         |
| `readinessProbe.enabled`                                     | Turn on and off readiness probe                         | `true`                                      |
| `readinessProbe.initialDelaySeconds`                         | Delay before readiness probe is initiated               | `30`                                        |
| `readinessProbe.periodSeconds`                               | How often to perform the probe                          | `15`                                        |
| `readinessProbe.timeoutSeconds`                              | When the probe times out                                | `5`                                         |
| `readinessProbe.failureThreshold`                            | Minimum consecutive failures for the probe              | `3`                                         |
| `readinessProbe.successThreshold`                            | Minimum consecutive successes for the probe             | `1`                                         |
| `hpa.enabled`                                                | Boolean to create a HorizontalPodAutoscaler             | `false`                                     |
| `hpa.cputhreshold`                                           | CPU threshold percent for the HorizontalPodAutoscale    | `60`                                        |
| `hpa.minPods`                                                | Min. pods for the Nextcloud HorizontalPodAutoscaler     | `1`                                         |
| `hpa.maxPods`                                                | Max. pods for the Nextcloud HorizontalPodAutoscaler     | `10`                                        |
| `deploymentAnnotations`                                      | Annotations to be added at 'deployment' level           | not set                                     |
| `podAnnotations`                                             | Annotations to be added at 'pod' level                  | not set                                     |
| `metrics.enabled`                                            | Start Prometheus metrics exporter                       | `false`                                     |
| `metrics.https`                                              | Defines if https is used to connect to nextcloud        | `false` (uses http)                         |
| `metrics.timeout`                                            | When the scrape times out                               | `5s`                                        |
| `metrics.image.repository`                                   | Nextcloud metrics exporter image name                   | `xperimental/nextcloud-exporter`            |
| `metrics.image.tag`                                          | Nextcloud metrics exporter image tag                    | `v0.3.0`                                    |
| `metrics.image.pullPolicy`                                   | Nextcloud metrics exporter image pull policy            | `IfNotPresent`                              |
| `metrics.podAnnotations`                                     | Additional annotations for metrics exporter             | not set                                     |
| `metrics.podLabels`                                          | Additional labels for metrics exporter                  | not set                                     |
| `metrics.service.type`                                       | Metrics: Kubernetes Service type                        | `ClusterIP`                                 |
| `metrics.service.loadBalancerIP`                             | Metrics: LoadBalancerIp for service type LoadBalancer   | `nil`                                       |
| `metrics.service.nodePort`                                   | Metrics: NodePort for service type NodePort             | `nil`                                       |
| `metrics.service.annotations`                                | Additional annotations for service metrics exporter     | `{prometheus.io/scrape: "true", prometheus.io/port: "9205"}` |
| `metrics.service.labels`                                     | Additional labels for service metrics exporter          | `{}`                                        |

> **Note**:
>
> For nextcloud to function correctly, you should specify the `nextcloud.host` parameter to specify the FQDN (recommended) or the public IP address of the nextcloud service.
>
> Optionally, you can specify the `service.loadBalancerIP` parameter to assign a reserved IP address to the nextcloud service of the chart. However please note that this feature is only available on a few cloud providers (f.e. GKE).
>
> To reserve a public IP address on GKE:
>
> ```bash
> $ gcloud compute addresses create nextcloud-public-ip
> ```
>
> The reserved IP address can be associated to the nextcloud service by specifying it as the value of the `service.loadBalancerIP` parameter while installing the chart.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set nextcloud.username=admin,nextcloud.password=password,mariadb.rootUser.password=secretpassword \
    stable/nextcloud
```

The above command sets the nextcloud administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/nextcloud
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Nextcloud](https://hub.docker.com/_/nextcloud/) image stores the nextcloud data and configurations at the `/var/www/html` paths of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to enable persistence and configuration of the PVC.

## Cronjob

This chart can utilize Kubernetes `CronJob` resource to execute [background tasks](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/background_jobs_configuration.html).

To use this functionality, set `cronjob.enabled` parameter to `true` and switch background mode to Webcron in your nextcloud settings page.
See the [Configuration](#configuration) section for further configuration of the cronjob resource.

> **Note**: For the cronjobs to work correctly, ingress must be also enabled (set `ingress.enabled` to `true`) and `nextcloud.host` has to be publicly resolvable.

## Multiple config.php file

Nextcloud supports loading configuration parameters from multiple files.
You can add arbitrary files ending with `.config.php` in the `config/` directory.
See [documentation](https://docs.nextcloud.com/server/15/admin_manual/configuration_server/config_sample_php_parameters.html#multiple-config-php-file).

For example, following config will configure Nextcloud with [S3 as primary storage](https://docs.nextcloud.com/server/13/admin_manual/configuration_files/primary_storage.html#simple-storage-service-s3) by creating file `/var/www/html/config/s3.config.php`:

```yaml
nextcloud:
  configs:
    s3.config.php: |-
      <?php
      $CONFIG = array (
        'objectstore' => array(
          'class' => '\\OC\\Files\\ObjectStore\\S3',
          'arguments' => array(
            'bucket'     => 'my-bucket',
            'autocreate' => true,
            'key'        => 'xxx',
            'secret'     => 'xxx',
            'region'     => 'us-east-1',
            'use_ssl'    => true
          )
        )
      );
```
