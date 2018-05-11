# cert-manager

cert-manager is a Kubernetes addon to automate the management and issuance of
TLS certificates from various issuing sources.

It will ensure certificates are valid and up to date periodically, and attempt
to renew certificates at an appropriate time before expiry.

## Prerequisites

- Kubernetes 1.7+

## Installing the Chart

Full installation instructions, including details on how to configure extra
functionality in cert-manager can be found in the [getting started docs](https://cert-manager.readthedocs.io/en/latest/getting-started/).

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/cert-manager
```

In order to begin issuing certificates, you will need to set up a ClusterIssuer
or Issuer resource (for example, by creating a 'letsencrypt-staging' issuer).

More information on the different types of issuers and how to configure them
can be found in our documentation:

https://cert-manager.readthedocs.io/en/latest/reference/issuers.html

For information on how to configure cert-manager to automatically provision
Certificates for Ingress resources, take a look at the `ingress-shim`
documentation:

https://cert-manager.readthedocs.io/en/latest/reference/ingress-shim.html

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the cert-manager chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `image.repository` | Image repository | `quay.io/jetstack/cert-manager-controller` |
| `image.tag` | Image tag | `v0.2.5` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `replicaCount`  | Number of cert-manager replicas  | `1` |
| `createCustomResource` | Create CRD/TPR with this release | `true` |
| `certificateResourceShortNames` | Custom aliases for Certificate CRD | `["cert", "certs"]` |
| `extraArgs` | Optional flags for cert-manager | `[]` |
| `rbac.create` | If `true`, create and use RBAC resources | `true`
| `serviceAccount.create` | If `true`, create a new service account | `true`
| `serviceAccount.name` | Service account to be used. If not set and `serviceAccount.create` is `true`, a name is generated using the fullname template | ``
| `resources` | CPU/memory resource requests/limits | `requests: {cpu: 10m, memory: 32Mi}` |
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `affinity` | Node affinity for pod assignment | `{}` |
| `tolerations` | Node tolerations for pod assignment | `[]` |
| `ingressShim.enabled` | Enable ingress-shim for automatic ingress integration | `true`|
| `ingressShim.extraArgs` | Optional flags for ingress-shim | `[]` |
| `ingressShim.resources` | CPU/memory resource requests/limits for ingress-shim | `requests: {cpu: 10m, memory: 32Mi}` |
| `ingressShim.image.repository` | Image repository for ingress-shim | `quay.io/jetstack/cert-manager-ingress-shim` |
| `ingressShim.image.tag` | Image tag for ingress-shim. Defaults to `image.tag` if empty | `` |
| `ingressShim.image.pullPolicy` | Image pull policy for ingress-shim | `IfNotPresent` |
| `podAnnotations` | Annotations to add to the cert-manager pod | `{}` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml .
```
> **Tip**: You can use the default [values.yaml](values.yaml)
