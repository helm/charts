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

| Parameter                       | Description                                | Default                                                    |
| ------------------------------- | ------------------------------------------ | ---------------------------------------------------------- |
| `imagePullSecrets` | Image pull secrets | None
| `image.repository` | Image | `quay.io/datawire/ambassador`
| `image.tag` | Image tag | `0.50.0`
| `image.pullPolicy` | Image pull policy | `IfNotPresent`
| `daemonSet` | If `true `, Create a daemonSet. By default Deployment controller will be created | `false`
| `env` | Any additional environment variables for ambassador pods | `{}`
| `replicaCount` | Number of Ambassador replicas  | `1`
| `volumes` | Volumes for the ambassador service | `[]`
| `volumeMounts` | Volume mounts for the ambassador service | `[]`
| `resources` | CPU/memory resource requests/limits | `{}`
| `rbac.create` | If `true`, create and use RBAC resources | `true`
| `serviceAccount.create` | If `true`, create a new service account | `true`
| `serviceAccount.name` | Service account to be used | `ambassador`
| `namespace.single` | Set the `AMBASSADOR_SINGLE_NAMESPACE` environment variable | `false`
| `namespace.name` | Set the `AMBASSADOR_NAMESPACE` environment variable | `metadata.namespace`
| `podAnnotations` | Additional annotations for ambassador pods |  `{}`
| `ambassador.id` | Set the identifier of the Ambassador instance | `default`
| `service.http.enabled` | if port 80 should be opened for service | `true`
| `service.http.port` | if port 443 should be opened for service | `true`
| `service.http.targetPort` | Sets the targetPort that maps to the service's cleartext port | `80`
| `service.http.nodePort` | If explicit NodePort is required | None
| `service.https.enabled` | if port 443 should be opened for service | `true`
| `service.https.port` | if port 443 should be opened for service | `true`
| `service.https.targetPorts` | Sets the targetPort that maps to the service's TLS port | `443`
| `service.https.nodePort` | If explicit NodePort is required | None
| `service.type` | Service type to be used | `LoadBalancer`
| `service.loadBalancerIP` | IP address to assign (if cloud provider supports it) | `""`
| `service.annotations` | Annotations to apply to Ambassador service | None
| `service.loadBalancerSourceRanges` | Passed to cloud provider load balancer if created (e.g: AWS ELB) | None
| `adminService.create` | If `true`, create a service for Ambassador's admin UI | `true`
| `adminService.nodePort` | If explicit NodePort for admin service is required  | `true`
| `adminService.type` | Ambassador's admin service type to be used | `ClusterIP`
| `prometheusExporter.enabled` | Prometheus exporter side-car enabled | `false`
| `prometheusExporter.image` | Prometheus exporter image | `prom/statsd-exporter:v0.8.1`
| `prometheusExporter.pullPolicy` | Image pull policy | `IfNotPresent`

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
