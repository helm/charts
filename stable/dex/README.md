# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# dex

[Dex][dex] is an identity service that uses OpenID Connect to drive authentication for other apps.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported. The official chart is located at [dexidp/helm-charts](https://github.com/dexidp/helm-charts).

## Introduction

Dex acts as a portal to other identity providers through "connectors". This lets dex defer authentication to LDAP servers, SAML providers, or established identity providers like GitHub, Google, and Active Directory. Clients write their authentication logic once to talk to dex, then dex handles the protocols for a given backend.

**Kubernetes authentication note**

If you plan to use dex as a [Kubernetes OpenID Connect token authenticator plugin](http://kubernetes.io/docs/admin/authentication/#openid-connect-tokens) you'll need to additionally deploy some helper app which will provide authentication UI for users and talk to dex.

Several helper apps are listed below:
  - https://github.com/mintel/dex-k8s-authenticator
  - https://github.com/heptiolabs/gangway
  - https://github.com/micahhausler/k8s-oidc-helper
  - https://github.com/negz/kuberos
  - https://github.com/negz/kubehook
  - https://github.com/fydrah/loginapp
  - https://github.com/keycloak/keycloak

## Installing the Chart

To install the chart with the release name `my-release`:

```sh
$ helm install --name my-release stable/dex
```

It'll install the chart with the default parameters. However most probably it won't work for you as-is, thus before installing the chart you need to consult the [values.yaml](values.yaml) notes as well as [dex documentation][dex].

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```sh
$ helm delete --purge my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Upgrading an existing release to a new major version

A major chart version change (like v1.5.1 -> v2.0.0) indicates that there is an incompatible breaking change which requires manual actions.

### Upgrade to v2.0.0

Breaking changes which should be considered and require manual actions during release upgrade:

- ability to switch grpc and https on and off via dedicated chart parameters
- port definition for Pod, Service and dex config re-written from scratch
- dex config is _not_ taken from `.Values.config` as-is anymore, pay attention!

See the [Configuration](#configuration) section for the details on the parameters introduced in version 2.0.0.

Moreover, this release updates all the labels to the new [recommended labels](https://github.com/helm/charts/blob/master/REVIEW_GUIDELINES.md#names-and-labels), most of them being immutable.

In order to upgrade, please update your values file and uninstall/reinstall the chart.

## Configuration

Parameters introduced starting from v2

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `certs.grpc.pod.annotations` | Annotations for the pod created by the `grpc-certs` job | `{}` |
| `certs.grpc.pod.affinity` | Affinity for the pod created by the `grpc-certs` job | `{}` |
| `certs.grpc.pod.nodeSelector` | nodeSelector for the pod created by the `grpc-certs` job | `{}` |
| `certs.grpc.pod.tolerations` | Tolerations for the pod created by the `grpc-certs` job | `[]` |
| `certs.web.pod.annotations` | Annotations for the pod created by the `web-certs` job | `{}` |
| `certs.web.pod.affinity` | Affinity for the pod created by the `web-certs` job | `{}` |
| `certs.web.pod.nodeSelector` | nodeSelector for the pod created by the `web-certs` job | `{}` |
| `certs.web.pod.tolerations` | Tolerations for the pod created by the `web-certs` job | `[]` |
| `config.connectors` | Maps to the dex config `connectors` dict param | `{}` |
| `config.enablePasswordDB` | Maps to the dex config `enablePasswordDB` param | `true` |
| `config.frontend` | Maps to the dex config `frontend` dict param | `""` |
| `config.grpc.address` | dex grpc listen address | `127.0.0.1` |
| `config.grpc.tlsCert` | Maps to the dex config `grpc.tlsCert` param | `/etc/dex/tls/grpc/server/tls.crt` |
| `config.grpc.tlsClientCA` | Maps to the dex config `grpc.tlsClientCA` param | `/etc/dex/tls/grpc/ca/tls.crt` |
| `config.grpc.tlsKey` | Maps to the dex config `grpc.tlsKey` param | `/etc/dex/tls/grpc/server/tls.key` |
| `config.issuer` | Maps to the dex config `issuer` param | `http://dex.io:8080` |
| `config.logger` | Maps to the dex config `logger` dict param | `{"level": "debug"}` |
| `config.oauth2.alwaysShowLoginScreen` | Maps to the dex config `oauth2.alwaysShowLoginScreen` param | `false` |
| `config.oauth2.skipApprovalScreen` | Maps to the dex config `oauth2.skipApprovalScreen` param | `true` |
| `config.staticClients` | Maps to the dex config `staticClients` list param | `""` |
| `config.staticPasswords` | Maps to the dex config `staticPasswords` list param | `""` |
| `config.storage` | Maps to the dex config `storage` dict param | `{"type": "kubernetes", "config": {"inCluster": true}}` |
| `config.web.address` | dex http/https listen address | `0.0.0.0` |
| `config.web.tlsCert` | Maps to the dex config `web.tlsCert` param | `/etc/dex/tls/https/server/tls.crt` |
| `config.web.tlsKey` | Maps to the dex config `web.tlsKey` param | `/etc/dex/tls/https/server/tls.key` |
| `config.web.allowedOrigins` | Maps to the dex config `web.allowedOrigins` param | `[]` |
| `config.expiry.signingKeys` | Maps to the dex config `expiry.signingKeys` param | `6h` |
| `config.expiry.idTokens` | Maps to the dex config `expiry.idTokens` param | `24h` |
| `crd.present` | Whether dex's CRDs are already present (if not cluster role and cluster role binding will be created to enable dex to create them). Depends on `rbac.create` | `false` |
| `grpc` | Enable dex grpc endpoint | `true` |
| `https` | Enable TLS termination for the dex http endpoint | `false` |
| `podLabels` | Custom pod labels | `{}` |
| `ports.grpc.containerPort` | grpc port listened by the dex | `5000` |
| `ports.grpc.nodePort` | K8S Service node port for the dex grpc listener | `35000` |
| `ports.grpc.servicePort` | K8S Service port for the dex grpc listener | `35000` |
| `ports.web.containerPort` | http/https port listened by the dex | `5556` |
| `ports.web.nodePort` | K8S Service node port for the dex http/https listener | `32000` |
| `ports.web.servicePort` | K8S Service port for the dex http/https listener | `32000` |
| `rbac.create` | If `true`, create & use RBAC resources | `true` |
| `securityContext` | Allow setting the securityContext of the main dex deployment | `` |
| `service.loadBalancerIP` | IP override for K8S LoadBalancer Service | `""` |
| `livenessProbe.enabled` | k8s liveness probe enabled (cannot be enabled when `https = true`) | `false` |
| `livenessProbe.path` |  k8s liveness probe http path | `"/healthz"`  |
| `livenessProbe.initialDelaySeconds` | Number of seconds after the container has started before liveness probe is initiated.  |  `1` |
| `livenessProbe.periodSeconds` | How often (in seconds) to perform the probe | `10`  |
| `livenessProbe.timeoutSeconds` | Number of seconds after which the probe times out | `1`  |
| `livenessProbe.failureThreshold` | Times to perform probe before restarting the container | `3`  |
| `readinessProbe.enabled` | k8s readiness probe enabled (cannot be enabled when `https = true`) | `false`  |
| `readinessProbe.path` |  k8s readiness probe http path | `"/healthz"`  |
| `readinessProbe.initialDelaySeconds` | Number of seconds after the container has started before readiness probe is initiated.  |  `1` |
| `readinessProbe.periodSeconds` | How often (in seconds) to perform the probe  |  `10` |
| `readinessProbe.timeoutSeconds` | Number of seconds after which the probe times out | `1`  |
| `readinessProbe.failureThreshold` | Times to perform probe before marking the container `Unready` |  `3` |
| `imagePullSecrets` | Allows to run containers based on images in private registries. |  `{}` |


Check [values.yaml](values.yaml) notes together with [dex documentation][dex] and [config examples](https://github.com/dexidp/dex/tree/master/examples) for all the possible configuration options.


[dex]: https://github.com/dexidp/dex
