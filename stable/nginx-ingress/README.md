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
`controller.image.repository` | controller container image repository | `gcr.io/google_containers/nginx-ingress-controller`
`controller.image.tag` | controller container image tag | `0.9.0-beta.15`
`controller.image.pullPolicy` | controller container image pull policy | `IfNotPresent`
`controller.config` | nginx ConfigMap entries | none
`controller.hostNetwork` | If the nginx deployment / daemonset should run on the host's network namespace | false
`controller.defaultBackendService` | default 404 backend service; required only if `defaultBackend.enabled = false` | `""`
`controller.electionID` | election ID to use for the status update | `ingress-controller-leader`
`controller.extraEnvs` | any additional environment variables to set in the pods | `{}`
`controller.ingressClass` | name of the ingress class to route through this controller | `nginx`
`controller.scope.enabled` | limit the scope of the ingress controller | `false` (watch all namespaces)
`controller.scope.namespace` | namespace to watch for ingress | `""` (use the release namespace)
`controller.extraArgs` | Additional controller container arguments | `{}`
`controller.kind` | install as Deployment or DaemonSet | `Deployment`
`controller.tolerations` | node taints to tolerate (requires Kubernetes >=1.6) | `[]`
`controller.nodeSelector` | node labels for pod assignment | `{}`
`controller.podAnnotations` | annotations to be added to pods | `{}`
`controller.replicaCount` | desired number of controller pods | `1`
`controller.resources` | controller pod resource requests & limits | `{}`
`controller.lifecycle` | controller pod lifecycle hooks | `{}`
`controller.service.annotations` | annotations for controller service | `{}`
`controller.publishService.enabled` | if true, the controller will set the endpoint records on the ingress objects to reflect those on the service | `false`
`controller.publishService.pathOverride` | override of the default publish-service name | `""`
`controller.service.clusterIP` | internal controller cluster service IP | `""`
`controller.service.externalIPs` | controller service external IP addresses | `[]`
`controller.service.externalTrafficPolicy` | If `controller.service.type` is `NodePort` or `LoadBalancer`, set this to `Local` to enable [source IP preservation](https://kubernetes.io/docs/tutorials/services/source-ip/#source-ip-for-services-with-typenodeport) | `"Cluster"`
`controller.service.healthCheckNodePort` | If `controller.service.type` is `NodePort` or `LoadBalancer` and `controller.service.externalTrafficPolicy` is set to `Local`, set this to [the managed health-check port the kube-proxy will expose](https://kubernetes.io/docs/tutorials/services/source-ip/#source-ip-for-services-with-typenodeport). If blank, a random port in the `NodePort` range will be assigned | `""`
`controller.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`controller.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`controller.service.targetPorts.http` | Sets the targetPort that maps to the Ingress' port 80 | `80`
`controller.service.targetPorts.https` | Sets the targetPort that maps to the Ingress' port 443 | `443`
`controller.service.type` | type of controller service to create | `LoadBalancer`
`controller.service.nodePorts.http` | If `controller.service.type` is `NodePort` and this is non-empty, it sets the nodePort that maps to the Ingress' port 80 | `""`
`controller.service.nodePorts.https` | If `controller.service.type` is `NodePort` and this is non-empty, it sets the nodePort that maps to the Ingress' port 443 | `""`
`controller.stats.enabled` | if true, enable "vts-status" page & Prometheus metrics | `false`
`controller.stats.service.annotations` | annotations for controller stats service | `{}`
`controller.stats.service.clusterIP` | internal controller stats cluster service IP | `""`
`controller.stats.service.externalIPs` | controller service stats external IP addresses | `[]`
`controller.stats.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`controller.stats.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`controller.stats.service.type` | type of controller stats service to create | `ClusterIP`
`controller.customTemplate.configMapName` | configMap containing a custom nginx template | `""`
`controller.customTemplate.configMapKey` | configMap key containing the nginx template | `""`
`defaultBackend.name` | name of the default backend component | `default-backend`
`defaultBackend.image.repository` | default backend container image repository | `gcr.io/google_containers/defaultbackend`
`defaultBackend.image.tag` | default backend container image tag | `1.3`
`defaultBackend.image.pullPolicy` | default backend container image pull policy | `IfNotPresent`
`defaultBackend.extraArgs` | Additional default backend container arguments | `{}`
`defaultBackend.tolerations` | node taints to tolerate (requires Kubernetes >=1.6) | `[]`
`defaultBackend.nodeSelector` | node labels for pod assignment | `{}`
`defaultBackend.podAnnotations` | annotations to be added to pods | `{}`
`defaultBackend.replicaCount` | desired number of default backend pods | `1`
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
`statsExporter.name` | name of the Prometheus metrics exporter component | `stats-exporter`
`statsExporter.image.repository` | Prometheus metrics exporter container image repository | `sophos/nginx-vts-exporter`
`statsExporter.image.tag` | Prometheus metrics exporter image tag | `v0.6`
`statsExporter.image.pullPolicy` | Prometheus metrics exporter image pull policy | `IfNotPresent`
`statsExporter.endpoint` | path at which Prometheus metrics are exposed | `/metrics`
`statsExporter.extraArgs` | Additional Prometheus metrics exporter container arguments | `{}`
`statsExporter.metricsNamespace` | namespace used for metrics labeling | `nginx`
`statsExporter.statusPage` | URL of "vts-stats" page exposed by controller | `http://localhost:18080/nginx_status/format/json`
`statsExporter.resources` | Prometheus metrics exporter resource requests & limits | `{}`
`statsExporter.service.annotations` | annotations for Prometheus metrics exporter service | `{}`
`statsExporter.service.clusterIP` | cluster IP address to assign to service | `""`
`statsExporter.service.externalIPs` | Prometheus metrics exporter service external IP addresses | `[]`
`statsExporter.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`statsExporter.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`statsExporter.service.servicePort` | Prometheus metrics exporter service port | `9913`
`statsExporter.service.type` | type of Prometheus metrics exporter service to create | `ClusterIP`
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

> **Tip**: You can use the default [values.yaml](values.yaml)
