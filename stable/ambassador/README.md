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

## Configuration

The following tables lists the configurable parameters of the Ambassador chart and their default values.

| Parameter                          | Description                                                                     | Default                       |
| ---------------------------------- | ------------------------------------------------------------------------------- | ----------------------------- |
| `adminService.create`              | If `true`, create a service for Ambassador's admin UI                           | `true`                        |
| `adminService.nodePort`            | If explicit NodePort for admin service is required                              | `true`                        |
| `adminService.type`                | Ambassador's admin service type to be used                                      | `ClusterIP`                   |
| `ambassador.id`                    | Set the identifier of the Ambassador instance                                   | `default`                     |
| `daemonSet`                        | If `true`, Create a daemonSet. By default Deployment controller will be created | `false`                       |
| `env`                              | Any additional environment variables for ambassador pods                        | `{}`                          |
| `image.pullPolicy`                 | Image pull policy                                                               | `IfNotPresent`                |
| `image.repository`                 | Image                                                                           | `quay.io/datawire/ambassador` |
| `image.tag`                        | Image tag                                                                       | `0.50.0`                      |
| `imagePullSecrets`                 | Image pull secrets                                                              | `[]`                          |
| `namespace.name`                   | Set the `AMBASSADOR_NAMESPACE` environment variable                             | `metadata.namespace`          |
| `podAnnotations`                   | Additional annotations for ambassador pods                                      | `{}`                          |
| `prometheusExporter.enabled`       | Prometheus exporter side-car enabled                                            | `false`                       |
| `prometheusExporter.pullPolicy`    | Image pull policy                                                               | `IfNotPresent`                |
| `prometheusExporter.repository`    | Prometheus exporter image                                                       | `prom/statsd-exporter`        |
| `prometheusExporter.tag`           | Prometheus exporter image                                                       | `v0.8.1`                      |
| `rbac.create`                      | If `true`, create and use RBAC resources                                        | `true`                        |
| `replicaCount`                     | Number of Ambassador replicas                                                   | `1`                           |
| `resources`                        | CPU/memory resource requests/limits                                             | `{}`                          |
| `service.annotations`              | Annotations to apply to Ambassador service                                      | None                          |
| `service.externalTrafficPolicy`    | Sets the external traffic policy for the service                                | `""`                          |
| `service.http.enabled`             | if port 80 should be opened for service                                         | `true`                        |
| `service.http.nodePort`            | If explicit NodePort is required                                                | None                          |
| `service.http.port`                | if port 443 should be opened for service                                        | `true`                        |
| `service.http.targetPort`          | Sets the targetPort that maps to the service's cleartext port                   | `80`                          |
| `service.https.enabled`            | if port 443 should be opened for service                                        | `true`                        |
| `service.https.nodePort`           | If explicit NodePort is required                                                | None                          |
| `service.https.port`               | if port 443 should be opened for service                                        | `true`                        |
| `service.https.targetPort`         | Sets the targetPort that maps to the service's TLS port                         | `443`                         |
| `service.loadBalancerIP`           | IP address to assign (if cloud provider supports it)                            | `""`                          |
| `service.loadBalancerSourceRanges` | Passed to cloud provider load balancer if created (e.g: AWS ELB)                | None                          |
| `service.type`                     | Service type to be used                                                         | `LoadBalancer`                |
| `serviceAccount.create`            | If `true`, create a new service account                                         | `true`                        |
| `serviceAccount.name`              | Service account to be used                                                      | `ambassador`                  |
| `volumeMounts`                     | Volume mounts for the ambassador service                                        | `[]`                          |
| `volumes`                          | Volumes for the ambassador service                                              | `[]`                          |

Make sure the configured `service.targetPorts.http` and `service.targetPorts.https` ports match your Ambassador Module's `service_port` and `redirect_cleartext_from` configurations.

If you intend to use `service.annotations`, remember to include the annotation key, for example:

```
service:
  type: LoadBalancer
  port: 80
  annotations:
    getambassador.io/config: |
      ---
      apiVersion: ambassador/v0
      kind: Module
      name:  ambassador
      config:
        diagnostics:
          enabled: false
        redirect_cleartext_from: 80
        service_port: 443
```

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

## Migrating from datawire/ambassador chart

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

### Renamde values

Service ports values have changed names.

| Previous value name         | New value name             |
| --------------------------- | -------------------------- |
| `service.enableHttp`        | `service.http.enabled`     |
| `service.httpPort`          | `service.http.port`        |
| `service.httpNodePort`      | `service.http.nodePort`    |
| `service.targetPorts.http`  | `service.http.targetPort`  |
| `service.enableHttps`       | `service.https.enabled`    |
| `service.httpsPort`         | `service.https.port`       |
| `service.httpsNodePort`     | `service.https.nodePort`   |
| `service.targetPorts.https` | `service.https.targetPort` |

### Exporter sidecar

Pre version `0.50.0` ambassador was using socat and required a sidecar to export statsd metrics. In `0.50.0` ambassador no longer uses socat and doesn't need a sidecar anymore to export its statsd metrics. Statsd metrics are disabled by default and can be enabled by setting environment `STATSD_ENABLED`, this will (in 0.50) send metrics to a service named `statsd-sink`, if you want to send it to another service or namespace it can be changed by setting `STATSD_HOST`

If you are using prometheus the chart allows you to enable a sidecar which can export to prometheus see the `prometheusExporter` values.
