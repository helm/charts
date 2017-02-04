# nginx-ingress

[nginx-ingress](https://github.com/kubernetes/contrib/tree/master/ingress/controllers/nginx) is an Ingress controller that uses ConfigMap to store the nginx configuration.

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

The following tables lists the configurable parameters of the aws-cluster-autoscaler chart and their default values.

Parameter | Description | Default
--- | --- | ---
`controller.name` | name of the controller component | `controller`
`controller.image.repository` | controller container image repository | `gcr.io/google_containers/nginx-ingress-controller`
`controller.image.tag` | controller container image tag | `0.8.3`
`controller.image.pullPolicy` | controller container image pull policy | `IfNotPresent`
`controller.config` | nginx ConfigMap entries | none
`controller.enableStats` | enable & expose nginx "vts-status" page | `false`
`controller.kind` | install as Deployment or DaemonSet | `Deployment`
`controller.replicaCount` | desired number of controller pods | `1`
`controller.resources` | controller pod resource requests & limits | `requests: {cpu: 100m, memory: 64Mi}`
`controller.service.annotations` | annotations for controller service | none
`controller.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | none
`controller.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | none
`controller.service.type` | type of controller service to create | `LoadBalancer`
`defaultBackend.name` | name of the default backend component | `default-backend`
`defaultBackend.image.repository` | default backend container image repository | `gcr.io/google_containers/defaultbackend`
`defaultBackend.image.tag` | default backend container image tag | `1.2`
`defaultBackend.image.pullPolicy` | default backend container image pull policy | `IfNotPresent`
`defaultBackend.replicaCount` | desired number of default backend pods | `1`
`defaultBackend.resources` | default backend pod resource requests & limits | `limits: {cpu: 10m, memory: 20Mi}, requests: {cpu: 10m, memory: 20Mi}`
`tcp` | TCP service key:value pairs | none
`udp` | UDP service key:value pairs | none

```console
$ helm install --name my-release \
  --set controller.enableStats=true \
    stable/nginx-ingress
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/nginx-ingress
```

> **Tip**: You can use the default [values.yaml](values.yaml)
