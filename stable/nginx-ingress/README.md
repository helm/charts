# nginx-ingress

[nginx-ingress](https://github.com/kubernetes/ingress-nginx) is an Ingress controller that uses ConfigMap to store the nginx configuration.

To use, add the `kubernetes.io/ingress.class: nginx` annotation to your Ingress resources.

## TL;DR;

```console
$ helm install stable/nginx-ingress
```

## Introduction

This chart bootstraps an nginx-ingress deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/nginx-ingress
```

The command deploys nginx-ingress on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the nginx-ingress chart and their default values.

Parameter | Description | Default
--- | --- | ---
`controller.name` | name of the controller component | `controller`
`controller.image.repository` | controller container image repository | `quay.io/kubernetes-ingress-controller/nginx-ingress-controller`
`controller.image.tag` | controller container image tag | `0.10.2`
`controller.image.pullPolicy` | controller container image pull policy | `IfNotPresent`
`controller.config` | nginx ConfigMap entries | none
`controller.hostNetwork` | If the nginx deployment / daemonset should run on the host's network namespace. Do not set this when `controller.service.externalIPs` is set and `kube-proxy` is used as there will be a port-conflict for port `80` | false
`controller.defaultBackendService` | default 404 backend service; required only if `defaultBackend.enabled = false` | `""`
`controller.electionID` | election ID to use for the status update | `ingress-controller-leader`
`controller.extraEnvs` | any additional environment variables to set in the pods | `{}`
`controller.ingressClass` | name of the ingress class to route through this controller | `nginx`
`controller.scope.enabled` | limit the scope of the ingress controller | `false` (watch all namespaces)
`controller.scope.namespace` | namespace to watch for ingress | `""` (use the release namespace)
`controller.extraArgs` | Additional controller container arguments | `{}`
`controller.kind` | install as Deployment or DaemonSet | `Deployment`
`controller.tolerations` | node taints to tolerate (requires Kubernetes >=1.6) | `[]`
`controller.affinity` | node/pod affinities (requires Kubernetes >=1.6) | `{}`
`controller.minReadySeconds` | how many seconds a pod needs to be ready before killing the next, during update | `0`
`controller.nodeSelector` | node labels for pod assignment | `{}`
`controller.podAnnotations` | annotations to be added to pods | `{}`
`controller.replicaCount` | desired number of controller pods | `1`
`controller.minAvailable` | minimum number of available controller pods for PodDisruptionBudget | `1`
`controller.resources` | controller pod resource requests & limits | `{}`
`controller.lifecycle` | controller pod lifecycle hooks | `{}`
`controller.service.annotations` | annotations for controller service | `{}`
`controller.publishService.enabled` | if true, the controller will set the endpoint records on the ingress objects to reflect those on the service | `false`
`controller.publishService.pathOverride` | override of the default publish-service name | `""`
`controller.service.clusterIP` | internal controller cluster service IP | `""`
`controller.service.externalIPs` | controller service external IP addresses. Do not set this when `controller.hostNetwork` is set to `true` and `kube-proxy` is used as there will be a port-conflict for port `80` | `[]`
`controller.service.externalTrafficPolicy` | If `controller.service.type` is `NodePort` or `LoadBalancer`, set this to `Local` to enable [source IP preservation](https://kubernetes.io/docs/tutorials/services/source-ip/#source-ip-for-services-with-typenodeport) | `"Cluster"`
`controller.service.healthCheckNodePort` | If `controller.service.type` is `NodePort` or `LoadBalancer` and `controller.service.externalTrafficPolicy` is set to `Local`, set this to [the managed health-check port the kube-proxy will expose](https://kubernetes.io/docs/tutorials/services/source-ip/#source-ip-for-services-with-typenodeport). If blank, a random port in the `NodePort` range will be assigned | `""`
`controller.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`controller.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`controller.service.targetPorts.http` | Sets the targetPort that maps to the Ingress' port 80 | `80`
`controller.service.targetPorts.https` | Sets the targetPort that maps to the Ingress' port 443 | `443`
`controller.service.type` | type of controller service to create | `LoadBalancer`
`controller.service.nodePorts.http` | If `controller.service.type` is `NodePort` and this is non-empty, it sets the nodePort that maps to the Ingress' port 80 | `""`
`controller.service.nodePorts.https` | If `controller.service.type` is `NodePort` and this is non-empty, it sets the nodePort that maps to the Ingress' port 443 | `""`
`controller.livenessProbe.initialDelaySeconds` | Delay before liveness probe is initiated | 10
`controller.livenessProbe.periodSeconds` | How often to perform the probe | 10
`controller.livenessProbe.timeoutSeconds` | When the probe times out | 5
`controller.livenessProbe.successThreshold` | Minimum consecutive successes for the probe to be considered successful after having failed. | 1
`controller.livenessProbe.failureThreshold` | Minimum consecutive failures for the probe to be considered failed after having succeeded. | 3
`controller.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated | 10
`controller.readinessProbe.periodSeconds` | How often to perform the probe | 10
`controller.readinessProbe.timeoutSeconds` | When the probe times out | 1
`controller.readinessProbe.successThreshold` | Minimum consecutive successes for the probe to be considered successful after having failed. | 1
`controller.readinessProbe.failureThreshold` | Minimum consecutive failures for the probe to be considered failed after having succeeded. | 3
`controller.stats.enabled` | if `true`, enable "vts-status" page | `false`
`controller.stats.service.annotations` | annotations for controller stats service | `{}`
`controller.stats.service.clusterIP` | internal controller stats cluster service IP | `""`
`controller.stats.service.externalIPs` | controller service stats external IP addresses | `[]`
`controller.stats.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`controller.stats.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`controller.stats.service.type` | type of controller stats service to create | `ClusterIP`
`controller.metrics.enabled` | if `true`, enable Prometheus metrics (`controller.stats.enabled` must be `true` as well) | `false`
`controller.metrics.service.annotations` | annotations for Prometheus metrics service | `{}`
`controller.metrics.service.clusterIP` | cluster IP address to assign to service | `""`
`controller.metrics.service.externalIPs` | Prometheus metrics service external IP addresses | `[]`
`controller.metrics.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`controller.metrics.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`controller.metrics.service.servicePort` | Prometheus metrics service port | `9913`
`controller.metrics.service.targetPort` | Prometheus metrics target port | `10254`
`controller.metrics.service.type` | type of Prometheus metrics service to create | `ClusterIP`
`controller.customTemplate.configMapName` | configMap containing a custom nginx template | `""`
`controller.customTemplate.configMapKey` | configMap key containing the nginx template | `""`
`controller.headers` | configMap key:value pairs containing the [custom headers](https://github.com/kubernetes/ingress-nginx/tree/master/docs/examples/customization/custom-headers) for Nginx | `{}`
`controller.updateStrategy` | allows setting of RollingUpdate strategy | `{}`
`defaultBackend.name` | name of the default backend component | `default-backend`
`defaultBackend.image.repository` | default backend container image repository | `k8s.gcr.io/defaultbackend`
`defaultBackend.image.tag` | default backend container image tag | `1.3`
`defaultBackend.image.pullPolicy` | default backend container image pull policy | `IfNotPresent`
`defaultBackend.extraArgs` | Additional default backend container arguments | `{}`
`defaultBackend.tolerations` | node taints to tolerate (requires Kubernetes >=1.6) | `[]`
`defaultBackend.affinity` | node/pod affinities (requires Kubernetes >=1.6) | `{}`
`defaultBackend.nodeSelector` | node labels for pod assignment | `{}`
`defaultBackend.podAnnotations` | annotations to be added to pods | `{}`
`defaultBackend.replicaCount` | desired number of default backend pods | `1`
`defaultBackend.minAvailable` | minimum number of available default backend pods for PodDisruptionBudget | `1`
`defaultBackend.resources` | default backend pod resource requests & limits | `{}`
`defaultBackend.service.annotations` | annotations for default backend service | `{}`
`defaultBackend.service.clusterIP` | internal default backend cluster service IP | `""`
`defaultBackend.service.externalIPs` | default backend service external IP addresses | `[]`
`defaultBackend.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`defaultBackend.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`defaultBackend.service.type` | type of default backend service to create | `ClusterIP`
`rbac.create` | If true, create & use RBAC resources | `false`
`rbac.serviceAccountName` | ServiceAccount to be used (ignored if rbac.create=true) | `default`
`revisionHistoryLimit` | The number of old history to retain to allow rollback. | `10`
`tcp` | TCP service key:value pairs | `{}`
`udp` | UDP service key:value pairs | `{}`

```console
$ helm install stable/nginx-ingress --name my-release \
    --set controller.stats.enabled=true
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install stable/nginx-ingress --name my-release -f values.yaml
```

## Prometheus Metrics

The Nginx ingress controller can export Prometheus metrics. In order for this to work, the VTS dashboard must be enabled as well.

```console
$ helm install stable/nginx-ingress --name my-release \
    --set controller.stats.enabled=true \
    --set controller.metrics.enabled=true
```

You can add Prometheus annotations to the metrics service using `controller.metrics.service.annotations`. Alternatively, if you use the Prometheus Operator, you need to create a ServiceMonitor as follows:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: nginx-ingress-service-monitor
spec:
  jobLabel: nginx-ingress
  selector:
    matchLabels:
      app: nginx-ingress
      release: <RELEASE>
  namespaceSelector:
    matchNames:
      - <RELEASE_NAMESPACE>
  endpoints:
    - port: metrics
      interval: 30s
```
> **Tip**: You can use the default [values.yaml](values.yaml)
