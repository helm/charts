# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# gce-ingress

[ingress-gce](https://github.com/kubernetes/ingress-gce) is an Ingress controller that configures GCE loadbalancers

To use, add the `kubernetes.io/ingress.class: "gce"` annotation to your Ingress resources.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## TL;DR;

```console
$ helm install stable/gce-ingress
```

## Introduction

This chart bootstraps a gce-ingress deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.9+

## Installing the Chart

To install the chart with the release name `my-release` into the `kube-system` namespace:

```console
$ helm install --namespace kube-system --name my-release stable/gce-ingress
```

The command deploys gce-ingress on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the gce-ingress chart and their default values.

Parameter | Description | Default
--- | --- | ---
`controller.name` | name of the controller component | `controller`
`controller.image.repository` | controller container image repository | `k8s.gcr.io/ingress-gce-glbc-amd64`
`controller.image.tag` | controller container image tag | `v1.4.0`
`controller.image.pullPolicy` | controller container image pull policy | `IfNotPresent`
`controller.config` | gce ConfigMap entries | none
`controller.tolerations` | node taints to tolerate (requires Kubernetes >=1.6) | `[]`
`controller.affinity` | node/pod affinities (requires Kubernetes >=1.6) | `{}`
`controller.nodeSelector` | node labels for pod assignment | `{}`
`controller.replicaCount` | desired number of controller pods | `1`
`controller.resources` | controller pod resource requests & limits | `{}`
`defaultBackend.name` | name of the default backend component | `default-backend`
`defaultBackend.image.repository` | default backend container image repository | `k8s.gcr.io/defaultbackend`
`defaultBackend.image.tag` | default backend container image tag | `1.4`
`defaultBackend.image.pullPolicy` | default backend container image pull policy | `IfNotPresent`
`defaultBackend.tolerations` | node taints to tolerate (requires Kubernetes >=1.6) | `[]`
`defaultBackend.affinity` | node/pod affinities (requires Kubernetes >=1.6) | `{}`
`defaultBackend.nodeSelector` | node labels for pod assignment | `{}`
`defaultBackend.replicaCount` | desired number of default backend pods | `1`
`defaultBackend.resources` | default backend pod resource requests & limits | `{}`
`rbac.enabled` | use RBAC ? | `true`
`secret` | the name of the secret containing your google creds json | ``
`secretKey` | override the key containing your google creds json | ``

```console
$ helm install stable/gce-ingress --name my-release
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install stable/gce-ingress --name my-release -f values.yaml
```


```console
$ helm install stable/gce-ingress --set controller.extraArgs.v=2
```
