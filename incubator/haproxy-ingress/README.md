# haproxy-ingress

[haproxy-ingress](https://github.com/jcmoraisjr/haproxy-ingress) is an Ingress controller that uses ConfigMap to store the global haproxy configuration, and ingress annotations to configure per-backend settings.

## DEPRECATION NOTICE

This chart repository is deprecated. It was moved to https://github.com/haproxy-ingress/charts

## Introduction

This chart bootstraps an haproxy-ingress deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.8+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/haproxy-ingress
```

The command deploys haproxy-ingress on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete --purge my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the haproxy-ingress chart and their default values.

Parameter | Description | Default
--- | --- | ---
`rbac.create` | If true, create & use RBAC resources | `true`
`rbac.security.enable` | If true, and rbac.create is true, create & use PSP resources | `false`
`serviceAccount.create` | If true, create serviceAccount | `true`
`serviceAccount.name` | ServiceAccount to be used | ``
`controller.name` | name of the controller component | `controller`
`controller.image.repository` | controller container image repository | `quay.io/jcmoraisjr/haproxy-ingress`
`controller.image.tag` | controller container image tag | `v0.7.2`
`controller.image.pullPolicy` | controller container image pullPolicy | `IfNotPresent`
`controller.imagePullSecrets` | controller image pull secrets | `[]`
`controller.initContainers` | extra containers that can initialize the haproxy-ingress-controller | `[]`
`controller.extraArgs` | extra command line arguments for the haproxy-ingress-controller | `{}`
`controller.extraEnv` | extra environment variables for the haproxy-ingress-controller | `{}`
`controller.template` | custom template for haproxy-ingress-controller | `{}`
`controller.defaultBackendService` | backend service if defualtBackend.enabled==false | `""`
`controller.ingressClass` | name of the ingress class to route through this controller | `haproxy`
`controller.healthzPort` | The haproxy health check (monitoring) port | `10253`
`controller.livenessProbe.path` | The liveness probe path | `/healthz`
`controller.livenessProbe.port` | The livneness probe port | `10253`
`controller.livenessProbe.failureThreshold` | The livneness probe failure threshold | `3`
`controller.livenessProbe.initialDelaySeconds` | The livneness probe initial delay (in seconds) | `10`
`controller.livenessProbe.periodSeconds` | The livneness probe period (in seconds) | `10`
`controller.livenessProbe.successThreshold` | The livneness probe success threshold | `1`
`controller.livenessProbe.timeoutSeconds` | The livneness probe timeout (in seconds) | `1`
`controller.readinessProbe.path` | The readiness probe path | `/healthz`
`controller.readinessProbe.port` | The readiness probe port | `10253`
`controller.readinessProbe.failureThreshold` | The readiness probe failure threshold | `3`
`controller.readinessProbe.initialDelaySeconds` | The readiness probe initial delay (in seconds) | `10`
`controller.readinessProbe.periodSeconds` | The readiness probe period (in seconds) | `10`
`controller.readinessProbe.successThreshold` | The readiness probe success threshold | `1`
`controller.readinessProbe.timeoutSeconds` | The readiness probe timeout (in seconds) | `1`
`controller.podAnnotations` | Annotations for the haproxy-ingress-controller pod | `{}`
`controller.podLabels` | Labels for the haproxy-ingress-controller pod | `{}`
`controller.podAffinity` | Add affinity to the controller pods to control scheduling | `{}`
`controller.priorityClassName` | Priority Class to be used | ``
`controller.securityContext` | Security context settings for the haproxy-ingress-controller pod | `{}`
`controller.config` | additional haproxy-ingress [ConfigMap entries](https://github.com/jcmoraisjr/haproxy-ingress/blob/v0.6/README.md#configmap) | `{}`
`controller.hostNetwork` | Optionally set to true when using CNI based kubernetes installations | `false`
`controller.dnsPolicy` | Optionally change this to ClusterFirstWithHostNet in case you have 'hostNetwork: true' | `ClusterFirst`
`controller.terminationGracePeriodSeconds` | How much to wait before terminating a pod (in seconds) | `60`
`controller.kind` | Type of deployment, DaemonSet or Deployment | `Deployment`
`controller.tcp` | TCP [service ConfigMap](https://github.com/jcmoraisjr/haproxy-ingress/blob/v0.6/README.md#tcp-services-configmap): `<port>: <namespace>/<servicename>:<portnumber>[:[<in-proxy>][:<out-proxy>]]` | `{}`
`controller.enableStaticPorts` | Set to `false` to only rely on ports from `controller.tcp` | `true`
`controller.daemonset.useHostPort` | Set to true to use host ports 80 and 443 | `false`
`controller.daemonset.hostPorts.http` | If `controller.daemonset.useHostPort` is `true` and this is non-empty sets the hostPort for http | `"80"`
`controller.daemonset.hostPorts.https` | If `controller.daemonset.useHostPort` is `true` and this is non-empty sets the hostPort for https | `"443"`
`controller.daemonset.hostPorts.tcp` | If `controller.daemonset.useHostPort` is `true` use hostport for these ports from `tcp` | `[]`
`controller.updateStrategy` | the update strategy settings | _see defaults below_
`controller.updateStrategy.type` | the update strategy type to use | `RollingUpdate`
`controller.updateStrategy.rollingUpdate.maxUnavailable` | the max number of unavailable controllers when doing rolling updates | `1`
`controller.minReadySeconds` | seconds to avoid killing pods before we are ready | `0`
`controller.replicaCount` | the number of replicas to deploy (when `controller.kind` is `Deployment`) | `1`
`controller.minAvailable` | PodDisruptionBudget minimum available controller pods | `1`
`controller.resources` | controller container resource requests & limits | `{}`
`controller.autoscaling.enabled` | enabling controller horizontal pod autoscaling (when `controller.kind` is `Deployment`) | `false`
`controller.autoscaling.minReplicas` | minimum number of replicas |
`controller.autoscaling.maxReplicas` | maximum number of replicas |
`controller.autoscaling.targetCPUUtilizationPercentage` | target cpu utilization |
`controller.autoscaling.targetMemoryUtilizationPercentage` | target memory utilization |
`controller.autoscaling.customMetrics` | Extra custom metrics to add to the HPA | `[]`
`controller.tolerations` | to control scheduling to servers with taints | `[]`
`controller.affinity` | to control scheduling | `{}`
`controller.nodeSelector` | to control scheduling | `{}`
`controller.service.annotations` | annotations for controller service | `{}`
`controller.service.labels` | labels for controller service | `{}`
`controller.service.clusterIP` | internal controller cluster service IP | `nil`
`controller.service.externalTrafficPolicy` | If `controller.service.type` is `NodePort` or `LoadBalancer`, set this to `Local` to enable [source IP preservation](https://kubernetes.io/docs/tutorials/services/source-ip/#source-ip-for-services-with-typenodeport) | `Local`
`controller.service.externalIPs` | list of IP addresses at which the controller services are available | `[]`
`controller.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`controller.service.loadBalancerSourceRanges` |  | `[]`
`controller.service.httpPorts` | The http ports to open, that map to the Ingress' port 80. Each entry specifies a `port`, `targetPort` and an optional `nodePort`. | `[ port: 80, targetPort: http ]`
`controller.service.httpsPorts` | The https ports to open, that map to the Ingress' port 443. Each entry specifies a `port`, `targetPort` and an optional `nodePort`. | `[ port: 443 , targetPort: https]`
`controller.service.type` | type of controller service to create | `LoadBalancer`
`controller.stats.enabled` | whether to enable exporting stats |  `false`
`controller.stats.port` | The port number used haproxy-ingress-controller for haproxy statistics | `1936`
`controller.stats.service.annotations` | annotations for stats service | `{}`
`controller.stats.service.clusterIP` | internal stats cluster service IP | `nil`
`controller.stats.service.externalIPs` | list of IP addresses at which the stats service is available | `[]`
`controller.stats.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`controller.stats.service.loadBalancerSourceRanges` |  | `[]`
`controller.stats.service.servicePort` | the port number exposed by the stats service | `1936`
`controller.stats.service.type` | type of controller service to create | `ClusterIP`
`controller.metrics.enabled` | If `controller.stats.enabled = true` and `controller.metrics.enabled = true`, Prometheus metrics will be exported |  `false`
`controller.metrics.image.repository` | prometheus-exporter image repository | `quay.io/prometheus/haproxy-exporter`
`controller.metrics.image.tag` | prometheus-exporter image tag | `v0.10.0`
`controller.metrics.image.pullPolicy` | prometheus-exporter image pullPolicy | `IfNotPresent`
`controller.metrics.extraArgs` | Extra arguments to the haproxy_exporter |  `{}`
`controller.metrics.resources` | prometheus-exporter container resource requests & limits |  `{}`
`controller.metrics.service.annotations` | annotations for metrics service | `{}`
`controller.metrics.service.clusterIP` | internal metrics cluster service IP | `nil`
`controller.metrics.service.externalIPs` | list of IP addresses at which the metrics service is available | `[]`
`controller.metrics.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`controller.metrics.service.loadBalancerSourceRanges` |  | `[]`
`controller.metrics.service.servicePort` | the port number exposed by the metrics service | `1936`
`controller.metrics.service.type` | type of controller service to create | `ClusterIP`
`controller.logs.enabled` | enable an access-logs sidecar container that collects access logs from haproxy and outputs to stdout | `false`
`controller.logs.image.repository` | access-logs container image repository | `quay.io/prometheus/haproxy-exporter`
`controller.logs.image.tag` | access-logs image tag | `v0.10.0`
`controller.logs.image.pullPolicy` | access-logs image pullPolicy | `IfNotPresent`
`controller.logs.resources` | access-logs container resource requests & limits |  `{}`
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
`defaultBackend.service.clusterIP` | internal metrics cluster service IP | `nil`
`defaultBackend.service.externalIPs` | list of IP addresses at which the metrics service is available | `[]`
`defaultBackend.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`defaultBackend.service.loadBalancerSourceRanges` |  | `[]`
`defaultBackend.service.servicePort` | the port number exposed by the metrics service | `1936`
`defaultBackend.service.type` | type of controller service to create | `ClusterIP`
