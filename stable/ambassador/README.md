# Ambassador

Ambassador is an open source, Kubernetes-native [microservices API gateway](https://www.getambassador.io/about/microservices-api-gateways) built on the [Envoy Proxy](https://www.envoyproxy.io/).

## TL;DR;

```console
$ helm install stable/ambassador
```

## Introduction

This chart bootstraps an [Ambassador](https://www.getambassador.io) deployment on
a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.7+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/ambassador
```

The command deploys Ambassador API gateway on the Kubernetes cluster in the default configuration.
The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete --purge my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Changelog

Notable chart changes are listed in the [CHANGELOG](https://github.com/helm/charts/blob/master/stable/ambassador/CHANGELOG.md)

## Configuration

The following tables lists the configurable parameters of the Ambassador chart and their default values.

| Parameter                          | Description                                                                     | Default                           |
| ---------------------------------- | ------------------------------------------------------------------------------- | --------------------------------- |
| `adminService.create`              | If `true`, create a service for Ambassador's admin UI                           | `true`                            |
| `adminService.nodePort`            | If explicit NodePort for admin service is required                              | `true`                            |
| `adminService.type`                | Ambassador's admin service type to be used                                      | `ClusterIP`                       |
| `adminService.annotations`         | Annotations to apply to Ambassador admin service                                | `{}`                              |
| `ambassadorConfig`                 | Config thats mounted to `/ambassador/ambassador-config`                         | `""`                              |
| `crds.enabled`                     | If `true`, enables CRD resources for the installation.                          | `true`                            |
| `crds.create`                      | If `true`, Creates CRD resources                                                | `true`                            |
| `crds.keep`                        | If `true`, if the ambassador CRDs should be kept when the chart is deleted      | `true`                            |
| `daemonSet`                        | If `true`, Create a DaemonSet. By default Deployment controller will be created | `false`                           |
| `hostNetwork`                      | If `true`, uses the host network, useful for on-premise setups                  | `false`                           |
| `dnsPolicy`                        | Dns policy, when hostNetwork set to ClusterFirstWithHostNet                     | `ClusterFirst`                    |
| `env`                              | Any additional environment variables for ambassador pods                        | `{}`                              |
| `image.pullPolicy`                 | Ambassador image pull policy                                                    | `IfNotPresent`                    |
| `image.repository`                 | Ambassador image                                                                | `quay.io/datawire/ambassador`     |
| `image.tag`                        | Ambassador image tag                                                            | `0.78.0`                          |
| `imagePullSecrets`                 | Image pull secrets                                                              | `[]`                              |
| `namespace.name`                   | Set the `AMBASSADOR_NAMESPACE` environment variable                             | `metadata.namespace`              |
| `scope.singleNamespace`            | Set the `AMBASSADOR_SINGLE_NAMESPACE` environment variable and create namespaced RBAC if `rbac.enabled: true` | `false`                           |
| `podAnnotations`                   | Additional annotations for ambassador pods                                      | `{}`                              |
| `deploymentAnnotations`            | Additional annotations for ambassador DaemonSet/Deployment                      | `{}`                              |
| `podLabels`                        | Additional labels for ambassador pods                                           |                                   |
| `priorityClassName`                | The name of the priorityClass for the ambassador DaemonSet/Deployment           | `""`                              |
| `rbac.create`                      | If `true`, create and use RBAC resources                                        | `true`                            |
| `rbac.podSecurityPolicies`         | pod security polices to bind to                                                 |                                   |
| `replicaCount`                     | Number of Ambassador replicas                                                   | `3`                               |
| `resources`                        | CPU/memory resource requests/limits                                             | `{}`                              |
| `securityContext`                  | Set security context for pod                                                    | `{ "runAsUser": "8888" }`         |
| `initContainers`                   | Containers used to initialize context for pods                                  | `[]`                              |
| `service.annotations`              | Annotations to apply to Ambassador service                                      | `""`                              |
| `service.externalTrafficPolicy`    | Sets the external traffic policy for the service                                | `""`                              |
| `service.ports`                    | List of ports Ambassador is listening on                                        |  `[{"name": "http","port": 80,"targetPort": 8080},{"name": "https","port": 443,"targetPort": 8443}]` |
| `service.loadBalancerIP`           | IP address to assign (if cloud provider supports it)                            | `""`                              |
| `service.loadBalancerSourceRanges` | Passed to cloud provider load balancer if created (e.g: AWS ELB)                | None                              |
| `service.type`                     | Service type to be used                                                         | `LoadBalancer`                    |
| `serviceAccount.create`            | If `true`, create a new service account                                         | `true`                            |
| `serviceAccount.name`              | Service account to be used                                                      | `ambassador`                      |
| `volumeMounts`                     | Volume mounts for the ambassador service                                        | `[]`                              |
| `volumes`                          | Volumes for the ambassador service                                              | `[]`                              |
| `pro.enabled`                      | Installs the Ambassador Pro container as a sidecar to Ambassador                | `false`                           |
| `pro.image.repository`             | Ambassador Pro image                                                            | `quay.io/datawire/ambassador_pro` |
| `pro.image.tag`                    | Ambassador Pro image tag                                                        | `0.7.0`               |
| `pro.ports.auth`                   | Ambassador Pro authentication port                                              | `8500`                            |
| `pro.ports.ratelimit`              | Ambassador Pro ratelimit port                                                   | `8500`                            |
| `pro.logLevel`                     | Log level for Ambassador Pro                                                    | `"info"`                          |
| `pro.licenseKey.value`             | License key for Ambassador Pro                                                  | ""                                |
| `pro.licenseKey.secret.enabled`    | Reads the license key as a base64-encoded string in a Kubernetes secret         | `true`                            |
| `pro.licenseKey.secret.create`     | Stores the license key as a base64-encoded string in a Kubernetes secret        | `true`                            |
| `pro.env`                          | Set additional environment variables for Ambassador Pro. (See below)            | `{}`                              |
| `pro.resources`                    | Set resource requests and limits from Ambassador Pro                            | `{}`                              |
| `pro.authService.enabled`          | Enables the Ambassador Pro authentication service                               | `true`                            |
| `pro.authService.optional_configurations` | Exposes [additional configuration options](https://www.getambassador.io/reference/services/auth-service/) for the `AuthService` | `""` | 
| `pro.rateLimit.enabled`            | Enables the Ambassador Pro rate limit service                                   | `true`                            |
| `pro.rateLimit.redis.annotations.deployment` | Annotations for the redis deployment                                  | `{}`                              |
| `pro.rateLimit.redis.annotations.service` | Annotations for the redis service                                        | `{}`                              |
| `pro.rateLimit.redis.resources`    | Set resource requests and limits for the rate limit service's redis instance    | `{}`                              |
| `autoscaling.enabled`              | If true, creates Horizontal Pod Autoscaler                                      | `false`                           |
| `autoscaling.minReplica`           | If autoscaling enabled, this field sets minimum replica count                   | `2`                               |
| `autoscaling.maxReplica`           | If autoscaling enabled, this field sets maximum replica count                   | `5`                               |
| `autoscaling.metrics`              | If autoscaling enabled, configure hpa metrics                                   |                                   |
| `prometheusExporter.enabled`       | DEPRECATED: Prometheus exporter side-car enabled                                | `false`                           |
| `prometheusExporter.pullPolicy`    | DEPRECATED: Image pull policy                                                   | `IfNotPresent`                    |
| `prometheusExporter.repository`    | DEPRECATED: Prometheus exporter image                                           | `prom/statsd-exporter`            |
| `prometheusExporter.tag`           | DEPRECATED: Prometheus exporter image                                           | `v0.8.1`                          |
| `prometheusExporter.resources`     | DEPRECATED: CPU/memory resource requests/limits                                 | `{}`                              |

**NOTE:** Make sure the configured `service.http.targetPort` and `service.https.targetPort` ports match your [Ambassador Module's](https://www.getambassador.io/reference/modules/#the-ambassador-module) `service_port` and `redirect_cleartext_from` configurations.

### Annotations

Ambassador configuration is done through annotations on Kubernetes services or Custom Resource Definitions (CRDs). The `service.annotations` section of the values file contains commented out examples of [Ambassador Module](https://www.getambassador.io/reference/core/ambassador) and a global [TLSContext](https://www.getambassador.io/reference/core/tls) configurations which are typically created in the Ambassador service.

If you intend to use `service.annotations`, remember to include the `getambassador.io/config` annotation key as above.

### Prometheus Metrics

Using the Prometheus Exporter has been deprecated and is no longer recommended.

Please see Ambassador's [monitoring with Prometheus](https://www.getambassador.io/user-guide/monitoring/) docs for more information on using the `/metrics` endpoint for metrics collection.

### Ambassador Pro

Setting `pro.enabled: true` will install Ambassador Pro as a sidecar to Ambassador with the required CRDs and redis instance.

You must set the `pro.licenseKey.value` to the license key issued to you. Sign up for a [free trial](https://www.getambassador.io/pro/free-trial) of Ambassador Pro or [contact](https://www.getambassador.io/contact) our sales team to obtain a license key.

`pro.ports.auth` and `pro.ports.ratelimit` must be the same value. If changing one, you must change the other.

For most use cases, `pro.image` and `pro.ports` can be left as default.

#### Ambassador Pro Environment

Click [here](https://www.getambassador.io/reference/pro/environment/) for full information regarding the different environment variables for Ambassador Pro.

Some environment variables are set by default. Some of these are configurable in the `Values` file.

| Environment Variable     | Default Value                     | Configurable     |
| ------------------------ | --------------------------------- | ---------------- |
| `REDIS_SOCKET_TYPE`      | `"tcp"`                           | No               |
| `REDIS_URL`              | `{{release name}}-pro-redis:6379` | No               |
| `APRO_HTTP_PORT`         | `8500`                            | `pro.ports.auth` |
| `APP_LOG_LEVEL`          | `"info"`                          | `pro.logLevel`   |
| `AMBASSADOR_NAMESPACE`   | `metadata.namespace`              | `namespace.name` |
| `AMBASSADOR_ID`          | `default`                         | `env`            |
| `AMBASSADOR_LICENSE_KEY` | `""`                              | `pro.licenseKey` |

Additional environment variables can be set with `pro.env`

**Note**: The Ambassador Pro container uses the same `AMBASSADOR_ID` as set in `env` for the Ambassador container. Setting `AMBASSADOR_ID` with `pro.env` will be ignored.

### Specifying Values

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm upgrade --install --wait my-release \
    --set adminService.type=NodePort \
    stable/ambassador
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm upgrade --install --wait my-release -f values.yaml stable/ambassador
```

---

# Upgrading

## To 4.0.0

The 4.0.0 chart contains a number of changes to the way Ambassador Pro is installed.

- Introduces the performance tuned and certified build of open source Ambassador, Ambassador core
- The license key is now stored and read from a Kubernetes secret by default
- Added `.Values.pro.licenseKey.secret.enabled` `.Values.pro.licenseKey.secret.create` fields to allow multiple releases in the same namespace to use the same license key secret.
- Introduces the ability to configure resource limits for both Ambassador Pro and it's redis instance
- Introduces the ability to configure additional `AuthService` options (see [AuthService documentation](https://www.getambassador.io/reference/services/auth-service/))
- The ambassador-pro-auth `AuthService` and ambassador-pro-ratelimit `RateLimitService` and now created as CRDs when `.Values.crds.enabled: true`
- Fixed misnamed selector for redis instance that failed in an edge case
- Exposes annotations for redis deployment and service

### Breaking changes

The value of `.Values.pro.image.tag` has been shortened to assume `amb-sidecar` (and `amb-core` for Ambassador core)
`values.yaml`
```diff
<3.0.0>
  image:
    repository: quay.io/datawire/ambassador_pro
-    tag: amb-sidecar-0.6.0

<4.0.0+>
  image:
    repository: quay.io/datawire/ambassador_pro
+    tag: 0.7.0
```

Method for creating a Kubernetes secret to hold the license key has been changed

`values.yaml`
```diff
<3.0.0>
-    secret: false
<4.0.0>
+    secret:
+      enabled: true
+      create: true
```

## To 3.0.0

### Service Ports

The way ports are assigned has been changed for a more dynamic method.

Now, instead of setting the port assignments for only the http and https, any port can be open on the load balancer using a list like you would in a standard Kubernetes YAML manifest.

`pre-3.0.0`
```yaml
service:
  http:
    enabled: true
    port: 80
    targetPort: 8080
  https:
    enabled: true
    port: 443
    targetPort: 8443
```

`3.0.0`
```yaml
service:
  ports:
  - name: http
    port: 80
    targetPort: 8080
  - name: https
    port: 443
    targetPort: 8443
```

This change has also replaced the `.additionalTCPPorts` configuration. Additional TCP ports can be created the same as the http and https ports above.

### Annotations and `service_port` 

The below Ambassador `Module` annotation is no longer being applied by default. 

```yaml
getambassador.io/config: |
  ---
  apiVersion: ambassador/v1
  kind: Module
  name: ambassador
  config:
    service_port: 8080
```
This was causing confusion with the `service_port` being hard-coded when enabling TLS termination in Ambassador.

Ambassador has been listening on port 8080 for HTTP and 8443 for HTTPS by default since version `0.60.0` (chart version 2.2.0). 

### RBAC and CRDs

A `ClusterRole` and `ClusterRoleBinding` named `{{release name}}-crd` will be created to watch for the Ambassador Custom Resource Definitions. This will be created regardless of the value of `scope.singleNamespace` since CRDs are created the cluster scope.

`rbac.namespaced` has been removed. For namespaced RBAC, set `scope.singleNamespace: true` and `rbac.enabled: true`.

`crds.enabled` will indicate that you are using CRDs and will create the rbac resources regardless of the value of `crds.create`. This allows for multiple deployments to use the CRDs.

## To 2.0.0

### Ambassador ID

ambassador.id has been removed in favor of setting it via an environment variable in `env`. `AMBASSADOR_ID` defaults to `default` if not set in the environment. This is mainly used for [running multiple Ambassadors](https://www.getambassador.io/reference/running#ambassador_id) in the same cluster.

| Parameter       | Env variables   |
| --------------- | --------------- |
| `ambassador.id` | `AMBASSADOR_ID` |

## Migrating from `datawire/ambassador` chart (chart version 0.40.0 or 0.50.0)

Chart now runs ambassador as non-root by default, so you might need to update your ambassador module config to match this.

### Timings

Timings values have been removed in favor of setting the env variables using `env´

| Parameter         | Env variables              |
| ----------------- | -------------------------- |
| `timing.restart`  | `AMBASSADOR_RESTART_TIME`  |
| `timing.drain`    | `AMBASSADOR_DRAIN_TIME`    |
| `timing.shutdown` | `AMBASSADOR_SHUTDOWN_TIME` |

### Single namespace

| Parameter          | Env variables                 |
| ------------------ | ----------------------------- |
| `namespace.single` | `AMBASSADOR_SINGLE_NAMESPACE` |

### Renamed values

Service ports values have changed names and target ports have new defaults.

| Previous parameter          | New parameter              | New default value |
| --------------------------- | -------------------------- | ----------------- |
| `service.enableHttp`        | `service.http.enabled`     |                   |
| `service.httpPort`          | `service.http.port`        |                   |
| `service.httpNodePort`      | `service.http.nodePort`    |                   |
| `service.targetPorts.http`  | `service.http.targetPort`  | `8080`            |
| `service.enableHttps`       | `service.https.enabled`    |                   |
| `service.httpsPort`         | `service.https.port`       |                   |
| `service.httpsNodePort`     | `service.https.nodePort`   |                   |
| `service.targetPorts.https` | `service.https.targetPort` | `8443`            |

### Exporter sidecar

Pre version `0.50.0` ambassador was using socat and required a sidecar to export statsd metrics. In `0.50.0` ambassador no longer uses socat and doesn't need a sidecar anymore to export its statsd metrics. Statsd metrics are disabled by default and can be enabled by setting environment `STATSD_ENABLED`, this will (in 0.50) send metrics to a service named `statsd-sink`, if you want to send it to another service or namespace it can be changed by setting `STATSD_HOST`

If you are using prometheus the chart allows you to enable a sidecar which can export to prometheus see the `prometheusExporter` values.
