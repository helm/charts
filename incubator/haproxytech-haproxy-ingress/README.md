# haproxytech haproxy-ingress
[haproxy-ingress](https://github.com/haproxytech/kubernetes-ingress/blob/ef1b5d404ead21b40352a1a453063dde3887283e/documentation/controller.md) is an Ingress Controller built by Haproxy Technologies as part of the v2.0 release. It uses ConfigMap and image arguments to configue the controller, along with ingress annotations to configure per-backend settings.

## Introduction

This chart bootstraps an haproxy-ingress deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/haproxytech-haproxy-ingress
```

The command deploys haproxytech-haproxy-ingress on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete --purge my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the haproxtech-haproxy-ingress chart and their default values.

Parameter | Description | Default
--- | --- | ---
`rbac.create` | If true, create & use RBAC resources | `true`
`rbac.security.enable` | If true, and rbac.create is true, create & use PSP resources | `false`
`serviceAccount.create` | If true, create serviceAccount | `true`
`serviceAccount.name` | ServiceAccount to be used | ``
`controller.name` | name of the controller component | `controller`
`controller.image.repository` | controller container image repository | `haproxytech/kubernetes-ingress`
`controller.image.tag` | controller container image tag | `1.0.2`
`controller.image.pullPolicy` | controller container image pullPolicy | `IfNotPresent`
`controller.ingressClass` | name of the ingress class to route through this controller | `haproxytech`
`controller.extraArgs` | extra command line arguments for the ingress controller | `{}`
`controller.extraEnv` | extra environment variables for the ingress controller | `{`}
`controller.podLabels` | Labels for the haproxy-ingress-controller pod | `{}`
`controller.defaultBackendService` | backend service if defualtBackend.enabled==false | `""`
`controller.config` | additional controller [ConfigMap entries](https://github.com/haproxytech/kubernetes-ingress/blob/master/documentation/README.md) | `{}`
`controller.service.loadBalancerIP` | external load balancer service IP | `""`
`controller.metrics.resources` | prometheus-exporter container resource requests & limits |  `{}`
`controller.livenessProbe.path` | The liveness probe path | `/healthz`
`controller.livenessProbe.port` | The livneness probe port | `1042`
`controller.livenessProbe.failureThreshold` | The livneness probe failure threshold | `3`
`controller.livenessProbe.initialDelaySeconds` | The livneness probe initial delay (in seconds) | `10`
`controller.livenessProbe.periodSeconds` | The livneness probe period (in seconds) | `10`
`controller.livenessProbe.successThreshold` | The livneness probe success threshold | `1`
`controller.livenessProbe.timeoutSeconds` | The livneness probe timeout (in seconds) | `1`
`controller.readinessProbe.path` | The readiness probe path | `/healthz`
`controller.readinessProbe.port` | The readiness probe port | `1042`
`controller.readinessProbe.failureThreshold` | The readiness probe failure threshold | `3`
`controller.readinessProbe.initialDelaySeconds` | The readiness probe initial delay (in seconds) | `10`
`controller.readinessProbe.periodSeconds` | The readiness probe period (in seconds) | `10`
`controller.readinessProbe.successThreshold` | The readiness probe success threshold | `1`
`controller.readinessProbe.timeoutSeconds` | The readiness probe timeout (in seconds) | `1`
`controller.tolerations` | to control scheduling to servers with taints | `[]`
`controller.affinity` | to control scheduling | `{}`
`controller.nodeSelector` | to control scheduling | `{}`
`controller.service.annotations` | annotations for controller service | `{}`
`controller.service.labels` | labels for controller service | `{}`
`controller.service.clusterIP` | internal controller cluster service IP | `""`
`controller.service.externalTrafficPolicy` | external traffic policy | `Cluster`
`controller.service.externalIPs` | list of IP addresses at which the controller services are available | `[]`
`controller.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`controller.service.loadBalancerSourceRanges` |  | `[]`
`controller.service.type` | type of controller service to create | `LoadBalancer`
`defaultBackend.enabled` | whether to use the default backend component | `true`
`defaultBackend.name` | name of the default backend component | `default-backend`
`defaultBackend.image.repository` | default backend container image repository | `gcr.io/google_containers/defaultbackend`
`defaultBackend.image.tag` | default backend container image repository tag | `1.0`
`defaultBackend.image.pullPolicy` | default backend container image pullPolicy | `IfNotPresent`
`defaultBackend.tolerations` | to control scheduling to servers with taints | `[]`
`defaultBackend.affinity` | to control scheduling | `{}`
`defaultBackend.nodeSelector` | to control scheduling | `{}`
`defaultBackend.podAnnotations` | Annotations for the default backend pod | `{}`
`defaultBackend.podLabels` | Labels for the default backend pod | `{}`
`defaultBackend.replicaCount` | the number of replicas to deploy (when `controller.kind` is `Deployment`) | `1`
`defaultBackend.minAvailable` | PodDisruptionBudget minimum available default backend pods | `1`
`defaultBackend.resources` | default backend pod resources | _see defaults below_
`defaultBackend.resources.limits.cpu` | default backend cpu resources limit | `10m`
`defaultBackend.resources.limits.memory` | default backend memory resources limit | `20Mi`
`defaultBackend.service.name` | name of default backend service to create | `ingress-default-backend`
`defaultBackend.service.annotations` | annotations for metrics service | `{}`
`defaultBackend.service.clusterIP` | internal metrics cluster service IP | `""`
`defaultBackend.service.externalIPs` | list of IP addresses at which the metrics service is available | `[]`
`defaultBackend.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`defaultBackend.service.loadBalancerSourceRanges` |  | `[]`
`defaultBackend.service.servicePort` | the port number exposed by the metrics service | `1936`
`defaultBackend.service.type` | type of controller service to create | `ClusterIP`
