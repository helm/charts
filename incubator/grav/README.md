# Grav
[Grav](https://getgrav.org/) is a modern open source flat-file CMS.

## TL;DR;
```bash
helm install incubator/grav
```

## Introduction
This chart deploys [Grav](https://getgrav.org/) on Kubernetes using thelm package manager.

## Prerequisites
- PV provisioner support

## Installation
To install the chart with the release name `my-release`
```bash
helm install --name my-release incubator/grav
```
This command will deploy Grav with the default configuration.

## Uninstalling
```bash
helm delete my-release
```
This command removes all the Kubernetes resources associated with the chart and deletes the release.

## Configuration
The following table lists the configurable parameters and their default values.
| Parameter                            | Description                                | Default value                                              |
| ------------------------------------ | ------------------------------------------ | ---------------------------------------------------------- |
| `image.repository`                   | Grav image name                            | `flojon/grav`                                              |
| `image.tag`                          | Grav image tag                             | `1.4.8`                                                    |
| `image.pullPolicy`                   | Image pull policy                          | `Always` if `imageTag` is `latest`, else `IfNotPresent`    |
| `image.pullSecrets`                  | Specify image pull secrets                 | `nil`                                                      |
| `replicaCount`                       | Number of Grav Pods to run                 | `1`                                                        |
| `serviceType`                        | Kubernetes Service type                    | `ClusterIP`                                                |
| `nodePorts.http`                     | Kubernetes http node port                  | `""`                                                       |
| `nodePorts.https`                    | Kubernetes https node port                 | `""`                                                       |
| `ingress.enabled`                    | Enable ingress controller resource         | `false`                                                    |
| `ingress.hosts[0].name`              | Hostname to your Grav installation         | `grav.local`                                               |
| `ingress.hosts[0].path`              | Path within the url structure              | `/`                                                        |
| `ingress.hosts[0].tls`               | Utilize TLS backend in ingress             | `false`                                                    |
| `ingress.hosts[0].tlsSecret`         | TLS Secret (certificates)                  | `grav.local-tls-secret`                                    |
| `ingress.hosts[0].annotations`       | Annotations for this host's ingress record | `[]`                                                       |
| `ingress.secrets[0].name`            | TLS Secret Name                            | `nil`                                                      |
| `ingress.secrets[0].certificate`     | TLS Secret Certificate                     | `nil`                                                      |
| `ingress.secrets[0].key`             | TLS Secret Key                             | `nil`                                                      |
| `persistence.enabled`                | Enable persistence using PVC               | `true`                                                     |
| `persistence.existingClaim`          | Enable persistence using an existing PVC   | `nil`                                                      |
| `persistence.storageClass`           | PVC Storage Class                          | `nil` (uses alpha storage class annotation)                |
| `persistence.accessMode`             | PVC Access Mode                            | `ReadWriteOnce`                                            |
| `persistence.size`                   | PVC Storage Request                        | `10Gi`                                                     |
| `nodeSelector`                       | Node labels for pod assignment             | `{}`                                                       |
| `tolerations`                        | List of node taints to tolerate            | `[]`                                                       |
| `affinity`                           | Map of node/pod affinities                 | `{}`                                                       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install --name my-release \
  --set replicaCount=3,persistence.size=1Gi \
    incubator/grav
```
The above command will set replica count to 3 and volume size to 1Gb.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```bash
helm install --name my-release -f values.yaml incubator/grav
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [flojon/grav](https://github.com/flojon/docker-grav) image stores the data and configurations at the `/var/www/html` path of the container.

Persistent Volume Claims are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.
See the [Configuration](#configuration) section to configure the PVC or to disable persistence.

## Ingress

This chart provides support for ingress resources. If you have an
ingress controller installed on your cluster, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress)
or [traefik](https://kubeapps.com/charts/stable/traefik) you can utilize
the ingress controller to serve your Grav application.

To enable ingress integration, please set `ingress.enabled` to `true`

### Hosts

Most likely you will only want to have one hostname that maps to this
Grav installation, however, it is possible to have more than one
host.  To facilitate this, the `ingress.hosts` object is an array.

For each item, please indicate a `name`, `tls`, `tlsSecret`, and any
`annotations` that you may want the ingress controller to know about.

Indicating TLS will cause Grav to generate HTTPS URLs, and
Grav will be connected to at port 443.  The actual secret that
`tlsSecret` references do not have to be generated by this chart.
However, please note that if TLS is enabled, the ingress record will not
work until this secret exists.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/annotations.md).
Not all annotations are supported by all ingress controllers, but this
document does a good job of indicating which annotation is supported by
many popular ingress controllers.

### TLS Secrets

This chart will facilitate the creation of TLS secrets for use with the
ingress controller, however, this is not required.  There are three
common use cases:

* helm generates/manages certificate secrets
* user generates/manages certificates separately
* an additional tool (like [kube-lego](https://kubeapps.com/charts/stable/kube-lego))
manages the secrets for the application

In the first two cases, one will need a certificate and a key.  We would
expect them to look like this:

* certificate files should look like (and there can be more than one
certificate if there is a certificate chain)

```
-----BEGIN CERTIFICATE-----
MIID6TCCAtGgAwIBAgIJAIaCwivkeB5EMA0GCSqGSIb3DQEBCwUAMFYxCzAJBgNV
...
jScrvkiBO65F46KioCL9h5tDvomdU1aqpI/CBzhvZn1c0ZTf87tGQR8NK7v7
-----END CERTIFICATE-----
```
* keys should look like:
```
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvLYcyu8f3skuRyUgeeNpeDvYBCDcgq+LsWap6zbX5f8oLqp4
...
wrj2wDbCDCFmfqnSJ+dKI3vFLlEz44sAV8jX/kd4Y6ZTQhlLbYc=
-----END RSA PRIVATE KEY-----
````

If you are going to use Helm to manage the certificates, please copy
these values into the `certificate` and `key` values for a given
`ingress.secrets` entry.

If you are going are going to manage TLS secrets outside of Helm, please
know that you can create a TLS secret by doing the following:

```
kubectl create secret tls Grav.local-tls --key /path/to/key.key --cert /path/to/cert.crt
```

Please see [this example](https://github.com/kubernetes/contrib/tree/master/ingress/controllers/nginx/examples/tls)
for more information.
