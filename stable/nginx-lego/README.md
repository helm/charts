# nginx-lego

**This chart has been deprecated as of version 0.2.1 and will not be updated. Please use the nginx-ingress and (optional) kube-lego charts instead.**

[nginx-lego](https://github.com/jetstack/kube-lego/tree/master/examples/nginx) is a chart for an [`nginx` ingress](https://github.com/kubernetes/contrib/tree/master/ingress/controllers/nginx) with optional support for automatically generating `SSL` cert for the managed routes.

To use this ingress contoller add the following annotations to the `ingress` resources you would like to route through it:

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  namespace: foo
  annotations:
    # Add to route through the nginx service
    kubernetes.io/ingress.class: nginx
    # Add to generate certificates for this ingress
    kubernetes.io/tls-acme: "true"
spec:
  tls:
    # With this configuration kube-lego will generate a secret in namespace foo called `example-tls`
    # for the URL `www.example.com`
    - hosts:
      - "www.example.com"
      secretName: example-tls
```

## TL;DR;

```bash
$ helm install stable/kube-lego
```

## Introduction

This chart bootstraps an nginx-lego deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/nginx-lego
```

The command deploys nginx-lego on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

See `values.yaml` for configuration notes. Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set lego.enabled=false \
    stable/nginx-lego
```

Installs the chart without kube-lego and the ability to generate certs.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/nginx-lego
```

> **Tip**: You can use the default [values.yaml](values.yaml)
