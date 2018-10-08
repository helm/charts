# haproxy-ingress

[haproxy-ingress](https://github.com/jcmoraisjr/haproxy-ingress) is an Ingress controller that uses ConfigMap to store the haproxy configuration.

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
`serviceAccount.create` | If true, create serviceAccount | `true`
`serviceAccount.name` | ServiceAccount to be used | ``
`defaultBackend.name` | name of the default backend component | `ingress-default-backend`
`defaultBackend.image.repository` | default backend container image repository | `gcr.io/google_containers/defaultbackend`
`defaultBackend.image.tag` | default backend container image repository tag | `1.0`
`defaultBackend.image.pullPolicy` | default backend container image pullPolicy | `IfNotPresent`
`defaultBackend.resources.cpu` | default backend cpu resources limit | `10m`
`defaultBackend.resources.memory` | default backend memory resources limit | `20Mi`
`defaultBackend.service.name` | name of default backend service to create | `ingress-default-backend`
`controller.name` | name of the controller component | `controller`
`controller.image.repository` | controller container image repository | `quay.io/jcmoraisjr/haproxy-ingress`
`controller.image.tag` | controller container image tag | `v0.5-beta.3`
`controller.image.pullPolicy` | controller container image pullPolicy | `IfNotPresent`
`controller.defaultSslCertificate.secret.namespace` | namespace of default certificate for controller | `{{ .Release.Namespace }}`
`controller.defaultSslCertificate.secret.name` | name of the secret for default certificate of controller | `""`
`controller.config` | haproxy ConfigMap entries | none
`controller.service.annotations` | annotations for controller service | `{}`
`controller.service.labels` | labels for controller service | `{}`
`controller.service.clusterIP` | internal controller cluster service IP | `""`
`controller.service.targetPorts.http` | Sets the targetPort that maps to the Ingress' port 80 | `80`
`controller.service.targetPorts.https` | Sets the targetPort that maps to the Ingress' port 443 | `443`
`controller.service.type` | type of controller service to create | `LoadBalancer`
`controller.service.nodePorts.http` | If `controller.service.type` is `NodePort` and this is non-empty, it sets the nodePort that maps to the Ingress' port 80 | `""`
`controller.service.nodePorts.https` | If `controller.service.type` is `NodePort` and this is non-empty, it sets the nodePort that maps to the Ingress' port 443 | `""`


