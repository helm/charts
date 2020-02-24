# WordPress

[WordPress](https://wordpress.org/) is one of the most versatile open source content management systems on the market. A publishing platform for building blogs and websites.

## TL;DR;

```console
$ helm install my-release stable/wordpress
```

## Introduction

This chart bootstraps a [WordPress](https://github.com/bitnami/bitnami-docker-wordpress) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the WordPress application.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This chart has been tested to work with NGINX Ingress, cert-manager, fluentd and Prometheus on top of the [BKPR](https://kubeprod.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 2.11+ or Helm 3.0-beta3+
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release stable/wordpress
```

The command deploys WordPress on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the WordPress chart and their default values.

|                 Parameter                 |                                              Description                                               |                           Default                            |
|-------------------------------------------|--------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|
| `global.imageRegistry`                    | Global Docker image registry                                                                           | `nil`                                                        |
| `global.imagePullSecrets`                 | Global Docker registry secret names as an array                                                        | `[]` (does not add image pull secrets to deployed pods)      |
| `global.storageClass`                     | Global storage class for dynamic provisioning                                                          | `nil`                                                        |
| `image.registry`                          | WordPress image registry                                                                               | `docker.io`                                                  |
| `image.repository`                        | WordPress image name                                                                                   | `bitnami/wordpress`                                          |
| `image.tag`                               | WordPress image tag                                                                                    | `{TAG_NAME}`                                                 |
| `image.pullPolicy`                        | Image pull policy                                                                                      | `IfNotPresent`                                               |
| `image.pullSecrets`                       | Specify docker-registry secret names as an array                                                       | `[]` (does not add image pull secrets to deployed pods)      |
| `nameOverride`                            | String to partially override wordpress.fullname template with a string (will prepend the release name) | `nil`                                                        |
| `fullnameOverride`                        | String to fully override wordpress.fullname template with a string                                     | `nil`                                                        |
| `wordpressSkipInstall`                    | Skip wizard installation                                                                               | `false`                                                      |
| `wordpressUsername`                       | User of the application                                                                                | `user`                                                       |
| `wordpressPassword`                       | Application password                                                                                   | _random 10 character long alphanumeric string_               |
| `wordpressEmail`                          | Admin email                                                                                            | `user@example.com`                                           |
| `wordpressFirstName`                      | First name                                                                                             | `FirstName`                                                  |
| `wordpressLastName`                       | Last name                                                                                              | `LastName`                                                   |
| `wordpressBlogName`                       | Blog name                                                                                              | `User's Blog!`                                               |
| `wordpressTablePrefix`                    | Table prefix                                                                                           | `wp_`                                                        |
| `wordpressScheme`                         | Scheme to generate application URLs [`http`, `https`]                                                  | `http`                                                       |
| `allowEmptyPassword`                      | Allow DB blank passwords                                                                               | `true`                                                       |
| `allowOverrideNone`                       | Set Apache AllowOverride directive to None                                                             | `false`                                                      |
| `customHTAccessCM`                        | Configmap with custom wordpress-htaccess.conf directives                                               | `nil`                                                        |
| `smtpHost`                                | SMTP host                                                                                              | `nil`                                                        |
| `smtpPort`                                | SMTP port                                                                                              | `nil`                                                        |
| `smtpUser`                                | SMTP user                                                                                              | `nil`                                                        |
| `smtpPassword`                            | SMTP password                                                                                          | `nil`                                                        |
| `smtpUsername`                            | User name for SMTP emails                                                                              | `nil`                                                        |
| `smtpProtocol`                            | SMTP protocol [`tls`, `ssl`, `none`]                                                                   | `nil`                                                        |
| `replicaCount`                            | Number of WordPress Pods to run                                                                        | `1`                                                          |
| `extraEnv`                                | Additional container environment variables                                                             | `[]`                                                         |
| `extraVolumeMounts`                       | Additional volume mounts                                                                               | `[]`                                                         |
| `extraVolumes`                            | Additional volumes                                                                                     | `[]`                                                         |
| `mariadb.enabled`                         | Deploy MariaDB container(s)                                                                            | `true`                                                       |
| `mariadb.rootUser.password`               | MariaDB admin password                                                                                 | `nil`                                                        |
| `mariadb.db.name`                         | Database name to create                                                                                | `bitnami_wordpress`                                          |
| `mariadb.db.user`                         | Database user to create                                                                                | `bn_wordpress`                                               |
| `mariadb.db.password`                     | Password for the database                                                                              | _random 10 character long alphanumeric string_               |
| `externalDatabase.host`                   | Host of the external database                                                                          | `localhost`                                                  |
| `externalDatabase.user`                   | Existing username in the external db                                                                   | `bn_wordpress`                                               |
| `externalDatabase.password`               | Password for the above username                                                                        | `nil`                                                        |
| `externalDatabase.database`               | Name of the existing database                                                                          | `bitnami_wordpress`                                          |
| `externalDatabase.port`                   | Database port number                                                                                   | `3306`                                                       |
| `service.annotations`                     | Service annotations                                                                                    | `{}`                                                         |
| `service.type`                            | Kubernetes Service type                                                                                | `LoadBalancer`                                               |
| `service.port`                            | Service HTTP port                                                                                      | `80`                                                         |
| `service.httpsPort`                       | Service HTTPS port                                                                                     | `443`                                                        |
| `service.httpsTargetPort`                 | Service Target HTTPS port                                                                              | `https`                                                      |
| `service.loadBalancerSourceRanges`        | Restricts access for LoadBalancer (only with `service.type: LoadBalancer`)                             | `[]`                                                         |
| `service.metricsPort`                     | Service Metrics port                                                                                   | `9117`                                                       |
| `service.externalTrafficPolicy`           | Enable client source IP preservation                                                                   | `Cluster`                                                    |
| `service.nodePorts.http`                  | Kubernetes http node port                                                                              | `""`                                                         |
| `service.nodePorts.https`                 | Kubernetes https node port                                                                             | `""`                                                         |
| `service.nodePorts.metrics`               | Kubernetes metrics node port                                                                           | `""`                                                         |
| `service.extraPorts`                      | Extra ports to expose in the service (normally used with the `sidecar` value)                          | `nil`                                                        |
| `healthcheckHttps`                        | Use https for liveliness and readiness                                                                 | `false`                                                      |
| `livenessProbe.enabled`                   | Enable/disable livenessProbe                                                                          | `true`                                                       |
| `livenessProbe.initialDelaySeconds`       | Delay before liveness probe is initiated                                                               | `120`                                                        |
| `livenessProbe.periodSeconds`             | How often to perform the probe                                                                         | `10`                                                         |
| `livenessProbe.timeoutSeconds`            | When the probe times out                                                                               | `5`                                                          |
| `livenessProbe.failureThreshold`          | Minimum consecutive failures for the probe                                                             | `6`                                                          |
| `livenessProbe.successThreshold`          | Minimum consecutive successes for the probe                                                            | `1`                                                          |
| `livenessProbeHeaders`                    | Headers to use for livenessProbe                                                                       | `nil`                                                        |
| `readiness.enabled`                       | Enable/disable readinessProbe                                                                          | `true`                                                       |
| `readinessProbe.initialDelaySeconds`      | Delay before readiness probe is initiated                                                              | `30`                                                         |
| `readinessProbe.periodSeconds`            | How often to perform the probe                                                                         | `10`                                                         |
| `readinessProbe.timeoutSeconds`           | When the probe times out                                                                               | `5`                                                          |
| `readinessProbe.failureThreshold`         | Minimum consecutive failures for the probe                                                             | `6`                                                          |
| `readinessProbe.successThreshold`         | Minimum consecutive successes for the probe                                                            | `1`                                                          |
| `readinessProbeHeaders`                   | Headers to use for readinessProbe                                                                      | `nil`                                                        |
| `ingress.enabled`                         | Enable ingress controller resource                                                                     | `false`                                                      |
| `ingress.certManager`                     | Add annotations for cert-manager                                                                       | `false`                                                      |
| `ingress.hostname`                        | Default host for the ingress resource                                                                  | `wordpress.local`                                            |
| `ingress.annotations`                     | Ingress annotations                                                                                    | `[]`                                                         |
| `ingress.hosts[0].name`                   | Hostname to your Wordpress installation                                                                | `wordpress.local`                                            |
| `ingress.hosts[0].path`                   | Path within the url structure                                                                          | `/`                                                          |
| `ingress.tls[0].hosts[0]`                 | TLS hosts                                                                                              | `wordpress.local`                                            |
| `ingress.tls[0].secretName`               | TLS Secret (certificates)                                                                              | `wordpress.local-tls`                                        |
| `ingress.secrets[0].name`                 | TLS Secret Name                                                                                        | `nil`                                                        |
| `ingress.secrets[0].certificate`          | TLS Secret Certificate                                                                                 | `nil`                                                        |
| `ingress.secrets[0].key`                  | TLS Secret Key                                                                                         | `nil`                                                        |
| `schedulerName`                           | Name of the alternate scheduler                                                                        | `nil`                                                        |
| `persistence.enabled`                     | Enable persistence using PVC                                                                           | `true`                                                       |
| `persistence.existingClaim`               | Enable persistence using an existing PVC                                                               | `nil`                                                        |
| `persistence.storageClass`                | PVC Storage Class                                                                                      | `nil` (uses alpha storage class annotation)                  |
| `persistence.accessMode`                  | PVC Access Mode                                                                                        | `ReadWriteOnce`                                              |
| `persistence.size`                        | PVC Storage Request                                                                                    | `10Gi`                                                       |
| `nodeSelector`                            | Node labels for pod assignment                                                                         | `{}`                                                         |
| `tolerations`                             | List of node taints to tolerate                                                                        | `[]`                                                         |
| `affinity`                                | Map of node/pod affinities                                                                             | `{}`                                                         |
| `podAnnotations`                          | Pod annotations                                                                                        | `{}`                                                         |
| `metrics.enabled`                         | Start a side-car prometheus exporter                                                                   | `false`                                                      |
| `metrics.image.registry`                  | Apache exporter image registry                                                                         | `docker.io`                                                  |
| `metrics.image.repository`                | Apache exporter image name                                                                             | `bitnami/apache-exporter`                                    |
| `metrics.image.tag`                       | Apache exporter image tag                                                                              | `{TAG_NAME}`                                                 |
| `metrics.image.pullPolicy`                | Image pull policy                                                                                      | `IfNotPresent`                                               |
| `metrics.image.pullSecrets`               | Specify docker-registry secret names as an array                                                       | `[]` (does not add image pull secrets to deployed pods)      |
| `metrics.podAnnotations`                  | Additional annotations for Metrics exporter pod                                                        | `{prometheus.io/scrape: "true", prometheus.io/port: "9117"}` |
| `metrics.resources`                       | Exporter resource requests/limit                                                                       | `{}`                                                         |
| `metrics.serviceMonitor.enabled`          | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator                           | `false`                                                      |
| `metrics.serviceMonitor.namespace`        | Namespace where servicemonitor resource should be created                                              | `nil`                                                        |
| `metrics.serviceMonitor.interval`         | Specify the interval at which metrics should be scraped                                                | `30s`                                                        |
| `metrics.serviceMonitor.scrapeTimeout`    | Specify the timeout after which the scrape is ended                                                    | `nil`                                                        |
| `metrics.serviceMonitor.relabellings`     | Specify Metric Relabellings to add to the scrape endpoint                                              | `nil`                                                        |
| `metrics.serviceMonitor.honorLabels`      | honorLabels chooses the metric's labels on collisions with target labels.                              | `false`                                                      |
| `metrics.serviceMonitor.additionalLabels` | Used to pass Labels that are required by the Installed Prometheus Operator                             | `{}`                                                         |
| `sidecars`                                | Attach additional containers to the pod                                                                | `nil`                                                        |
| `updateStrategy`                          | Set up update strategy                                                                                 | `RollingUpdate`                                              |

The above parameters map to the env variables defined in [bitnami/wordpress](http://github.com/bitnami/bitnami-docker-wordpress). For more information please refer to the [bitnami/wordpress](http://github.com/bitnami/bitnami-docker-wordpress) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install my-release \
  --set wordpressUsername=admin,wordpressPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/wordpress
```

The above command sets the WordPress administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install my-release -f values.yaml stable/wordpress
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Production configuration

This chart includes a `values-production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`. You can use this file instead of the default one.

- Set Apache AllowOverride directive to None:
```diff
- allowOverrideNone: false
+ allowOverrideNone: true
```

- Number of WordPress Pods to run
```diff
- replicaCount: 1
+ replicaCount: 3
```

- Enable client source IP preservation:
```diff
- service.externalTrafficPolicy: Cluster
+ service.externalTrafficPolicy: Local
```

- PVC Access Mode:
```diff
- persistence.accessMode: ReadWriteOnce
+ ##
+ ## To use the /admin portal and to ensure you can scale wordpress you need to provide a
+ ## ReadWriteMany PVC, if you dont have a provisioner for this type of storage
+ ## We recommend that you install the nfs provisioner and map it to a RWO volume
+ ## helm install nfs-server stable/nfs-server-provisioner --set persistence.enabled=true,persistence.size=10Gi
+ persistence.accessMode: ReadWriteMany
```

- Start a side-car prometheus exporter:
```diff
- metrics.enabled: false
+ metrics.enabled: true
```

Note that [values-production.yaml](values-production.yaml) includes a replicaCount of 3, so there will be 3 WordPress pods. As a result, to use the /admin portal and to ensure you can scale wordpress you need to provide a ReadWriteMany PVC, if you don't have a provisioner for this type of storage, we recommend that you install the nfs provisioner (with the correct parameters, such as `persistence.enabled=true` and `persistence.size=10Gi`) and map it to a RWO volume.

Then you can deploy WordPress chart using the proper parameters:
```console
persistence.storageClass=nfs
mariadb.master.persistence.storageClass=nfs
```

### Sidecars

If you have a need for additional containers to run within the same pod as WordPress (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
- name: your-image-name
  image: your-image
  imagePullPolicy: Always
  ports:
  - name: portname
   containerPort: 1234

If these sidecars export extra ports, you can add extra port definitions using the `service.extraPorts` value:

```yaml
service:
...
  extraPorts:
  - name: extraPort
    port: 11311
    targetPort: 11311
```

### Using an external database

Sometimes you may want to have Wordpress connect to an external database rather than installing one inside your cluster, e.g. to use a managed database service, or use run a single database server for all your applications. To do this, the chart allows you to specify credentials for an external database under the [`externalDatabase` parameter](#parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. For example with the following parameters:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

Note also if you disable MariaDB per above you MUST supply values for the `externalDatabase` connection.

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik) you can utilize the ingress controller to serve your WordPress application.

To enable ingress integration, please set `ingress.enabled` to `true`

### Hosts

Most likely you will only want to have one hostname that maps to this WordPress installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.hosts` object is can be specified as an array.

For each item, please indicate a `name`, `tls`, `tlsSecret`, and any `annotations` that you may want the ingress controller to know about.

Indicating TLS will cause WordPress to generate HTTPS URLs, and WordPress will be connected to at port 443.  The actual secret that `tlsSecret` references do not have to be generated by this chart. However, please note that if TLS is enabled, the ingress record will not work until this secret exists.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md).
Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

### TLS Secrets

This chart will facilitate the creation of TLS secrets for use with the ingress controller, however, this is not required.  There are three common use cases:

* helm generates/manages certificate secrets
* user generates/manages certificates separately
* an additional tool (like [kube-lego](https://kubeapps.com/charts/stable/kube-lego)) manages the secrets for the application

In the first two cases, one will need a certificate and a key.  We would expect them to look like this:

* certificate files should look like (and there can be more than one certificate if there is a certificate chain)

```
-----BEGIN CERTIFICATE-----
MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
...
jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
-----END CERTIFICATE-----
```
* keys should look like:
```
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
...
wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
-----END RSA PRIVATE KEY-----
```

If you are going to use Helm to manage the certificates, please copy these values into the `certificate` and `key` values for a given `ingress.secrets` entry.

If you are going to manage TLS secrets outside of Helm, please know that you can create a TLS secret (named `wordpress.local-tls` for example).

Please see [this example](https://github.com/kubernetes/contrib/tree/master/ingress/controllers/nginx/examples/tls) for more information.

### Ingress-terminated https

In cases where HTTPS/TLS is terminated on the ingress, you may run into an issue where non-https liveness and readiness probes result in a 302 (redirect from HTTP to HTTPS) and are interpreted by Kubernetes as not-live/not-ready.  (See [Kubernetes issue #47893 on GitHub](https://github.com/kubernetes/kubernetes/issues/47893) for further details about 302 _not_ being interpreted as "successful".)  To work around this problem, use `livenessProbeHeaders` and `readinessProbeHeaders` to pass the same headers that your ingress would pass in order to get an HTTP 200 status result.  For example (where the following is in a `--values`-referenced file):

```yaml
livenessProbeHeaders:
- name: X-Forwarded-Proto
  value: https
readinessProbeHeaders:
- name: X-Forwarded-Proto
  value: https
```

Any number of name/value pairs may be specified; they are all copied into the liveness or readiness probe definition.

### Disabling `.htaccess`

For performance and security reasons, it is a good practice to configure Apache with `AllowOverride None`. Instead of using `.htaccess` files, Apache will load the same dircetives at boot time. These directives are located in `/opt/bitnami/wordpress/wordpress-htaccess.conf`. The container image includes by default these directives all of the default `.htaccess` files in WordPress (together with the default plugins). To enable this feature, install the chart with the following value: `allowOverrideNone=yes`

However, some plugins may include `.htaccess` directives that will not be loaded when `AllowOverride` is set to `None`. A way to make them work would be to create your own `wordpress-htaccess.conf` file with all the required dircectives to make the plugin work. After creating it, then create a ConfigMap with it and install the chart with the correct parameters:

```console
allowOverrideNone=true
customHTAccessCM=custom-htaccess
```

## Persistence

The [Bitnami WordPress](https://github.com/bitnami/bitnami-docker-wordpress) image stores the WordPress data and configurations at the `/bitnami` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

## Upgrading

### To 8.0.0

Helm performs a lookup for the object based on its group (apps), version (v1), and kind (Deployment). Also known as its GroupVersionKind, or GVK. Changing the GVK is considered a compatibility breaker from Kubernetes' point of view, so you cannot "upgrade" those objects to the new GVK in-place. Earlier versions of Helm 3 did not perform the lookup correctly which has since been fixed to match the spec.

In https://github.com/helm/charts/pulls/12642 the `apiVersion` of the deployment resources was updated to `apps/v1` in tune with the api's deprecated, resulting in compatibility breakage.

This major version signifies this change.

### To 3.0.0

Backwards compatibility is not guaranteed unless you modify the labels used on the chart's deployments.
Use the workaround below to upgrade from versions previous to `3.0.0`. The following example assumes that the release name is `wordpress`:

```console
$ kubectl patch deployment wordpress-wordpress --type=json -p='[{"op": "remove", "path": "/spec/selector/matchLabels/chart"}]'
$ kubectl delete statefulset wordpress-mariadb --cascade=false
```
