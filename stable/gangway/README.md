# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Gangway

An application that can be used to easily enable authentication flows via OIDC for a kubernetes cluster.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## TL;DR

    helm install stable/gangway

## Introduction

The chart deploys an instance of Gangway into a Kubernetes cluster using the Helm package manager.

This chart will do the following:

* Create a deployment of [gangway] within your Kubernetes Cluster.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm install --name my-release stable/gangway
```

Due to the nature of OIDC configuration, deploying the chart without at least some of the values being set will not result in a functioning application. See the Configuration section below for more information.

## Configuration

The following table lists the configurable parameters of the external-dns chart and their default values.

All values under the `gangway` top level object are passed directly to the Gangway container via a `yaml` config file. The contents of that object in [`values.yaml`](values.yaml) are lifted directly from the Gangway [documentation](https://github.com/heptiolabs/gangway/tree/master/docs).

At a minimum you *must* configure any of the values marked as **required** in the table below.

| Parameter                        | Description                                                                                                                                                                                                     | Default                                            |
| -------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| `affinity`                       | List of affinities (requires Kubernetes >=1.6)                                                                                                                                                                  | `{}`                                               |
| `env`                            | Environment variables to apply to the pod.                                                                                                                                                                      | `{}`                                               |
| `extraVolumes`                   | List of extra volumes                                                                                                                                                                                           | `[]`                                               |
| `extraVolumeMounts`              | List of extra volumeMounts                                                                                                                                                                                      | `[]`                                               |
| `gangway.allowEmptyClientSecret` | Some identity providers accept an empty client secret, this is not generally considered a good idea. If you have to use an empty secret and accept the risks that come with that then you can set this to true. | `false`                                            |
| `gangway.apiServerURL`           | The API server endpoint used to configure kubectl. **Required**                                                                                                                                                 | `""`                                               |
| `gangway.audience`               | Endpoint that provides user profile information [optional]. Not all providers will require this. To be taken from the configuration of your OIDC provider.  **Required**                                        | `""`                                               |
| `gangway.authorizeURL`           | OAuth2 URL to start authorization flow. To be taken from the configuration of your OIDC provider.  **Required**                                                                                                 | `""`                                               |
| `gangway.certFile`               | The public cert file (including root and intermediates) to use when serving TLS.                                                                                                                                | `/etc/gangway/tls/tls.crt`                         |
| `gangway.clientID`               | API client ID as indicated by the identity provider. **Required**                                                                                                                                               | `""`                                               |
| `gangway.clientSecret`           | API client secret as indicated by the identity provider. **Required**                                                                                                                                           | `""`                                               |
| `gangway.cluster_ca_path`        | The path to find the CA bundle for the API server. Used to configure kubectl.  This is typically mounted into the default location for workloads running on a Kubernetes cluster and doesn't need to be set.    | `""`                                               |
| `gangway.clusterName`            | The cluster name. Used in UI and kubectl config instructions. **Required**                                                                                                                                      | `""`                                               |
| `gangway.host`                   | The address to listen on. Defaults to 0.0.0.0 to listen on all interfaces.                                                                                                                                      | `80`                                               |
| `gangway.httpPath`               | The path gangway uses to create urls (defaults to "")                                                                                                                                                           | `/`                                                |
| `gangway.keyFile`                | The private key file when serving TLS.                                                                                                                                                                          | `/etc/gangway/tls/tls.key`                         |
| `gangway.port`                   | The port to listen on. Defaults to 8080.                                                                                                                                                                        | `80`                                               |
| `gangway.redirectURL`            | Where to redirect back to. This should be a URL where gangway is reachable. Typically this also needs to be registered as part of the oauth application with the oAuth provider. **Required**                   | `""`                                               |
| `gangway.scopes`                 | Used to specify the scope of the requested Oauth authorization.                                                                                                                                                 | `["openid", "profile", "email", "offline_access"]` |
| `gangway.serviceAccountName`                 | Used to specify an alternative serviceAccount name to be created and used. If not set, default account will be used.                                                                                                                                                | `""` |
| `gangway.serveTLS`               | Should Gangway serve TLS vs. plain HTTP?                                                                                                                                                                        | `false`                                            |
| `gangway.sessionKey`             | Encryption key for cookie contents. Will autogenerate if not provided. Caution: Do not use auto generation in production environments.                                                                          | `""`                                               |
| `gangway.tokenURL`               | OAuth2 URL to obtain access tokens. To be taken from the configuration of your OIDC provider. **Required**                                                                                                      | `""`                                               |
| `gangway.trustedCAPath`          | The path to a root CA to trust for self signed certificates at the Oauth2 URLs                                                                                                                                  | `""`                                               |
| `gangway.usernameClaim`          | The JWT claim to use as the username. This is used in UI. Default is "nickname". This is combined with the clusterName for the "user" portion of the kubeconfig.                                                | `name`                                             |
| `trustedCACert`                  | Specify a CA cert to trust for self signed certificates at the Oauth2 URLs.                                                                                                                                     | `""`                                               |
| `image.repository`               | Container image name (Including repository name if not `hub.docker.com`).                                                                                                                                       | `gcr.io/heptio-images/gangway`                     |
| `image.pullPolicy`               | Container pull policy.                                                                                                                                                                                          | `IfNotPresent`                                     |
| `image.tag`                      | Container image tag.                                                                                                                                                                                            | `v3.2.0`                                           |
| `image.pullSecrets`              | Name of Secret resource containing private registry credentials                                                                                                                                                 | `""`                                               |
| `ingress.annotations`            | Ingress annotations                                                                                                                                                                                             | `{}`                                               |
| `ingress.enabled`                | Enables or Disables the ingress resource                                                                                                                                                                        | `false`                                            |
| `ingress.hosts`                  | List of FQDN's for the ingress                                                                                                                                                                                  | `""`                                               |
| `ingress.tls.hosts`              | List of FQDN's the above secret is associated with                                                                                                                                                              | `""`                                               |
| `ingress.tls.secretName`         | Name of the secret to use                                                                                                                                                                                       | `""`                                               |
| `ingress.tls`                    | List of SSL certs to use                                                                                                                                                                                        | `""`                                               |
| `livenessProbe.scheme`           | Scheme to use for httpGet probe, `HTTP` or `HTTPS`.                                                                                                                                                             | `HTTP`                                             |
| `nodeSelector`                   | Node labels for pod assignment                                                                                                                                                                                  | `{}`                                               |
| `podAnnotations`                 | Additional annotations to apply to the pod.                                                                                                                                                                     | `{}`                                               |
| `resources`                      | CPU/Memory resource requests/limits.                                                                                                                                                                            | `{}`                                               |
| `readinessProbe.scheme`          | Scheme to use for httpGet probe, `HTTP` or `HTTPS`.                                                                                                                                                             | `HTTP`                                             |
| `service.port`                   | The port the service should listen on                                                                                                                                                                           | `80`                                               |
| `service.type`                   | Type of service to create                                                                                                                                                                                       | `ClusterIP`                                        |
| `tls.certData`                   | The Public cert data. This is normally safe to leave alone.                                                                                                                                                     | `""`                                               |
| `tls.existingSecret`             | An existing secret with a `tls.crt` and `tls.key`                                                                                                                                                               | `""`                                               |
| `tls.keyData`                    | The Private key data                                                                                                                                                                                            | `""`                                               |
| `tolerations`                    | List of node taints to tolerate (requires Kubernetes >= 1.6)                                                                                                                                                    | `[]`                                               |

You will likely want to expose Gangway to your users somehow, possibly by way of an ingress, the values below would be a way of doing this with the [Traefik] ingress controller, this assumes TLS offload is happening at the load balancer:

```yaml
ingress:
enabled: true
annotations:
    kubernetes.io/ingress.class: traefik
path: /
hosts:
    - gangway.your-domain.com
tls: []
```

## Note about `gangway.sessionKey`

The chart will auto generate a random value for `gangway.sessionKey` when you install the chart. Gangway uses this via the [Gorilla Secure Cookie] Go library to encrypt the contents of cookies sent to the users browser.  Relying on the autogeneration is acceptable in testing environments, however in production you are strongly advised to provide your own random value for this variable. If you do not and you subsequently update your Helm deployment this key will be regenerated. This has the impact that any cookies in your users browsers from before the upgrade, will have been encrypted with the old key, which Gangway no longer has. Therefore when they browse to your Gangway url they will get an error when they attempt to login. The only solution to that issue is to have the user delete all the gangway cookies from their browser. You have been warned!

### Specifying Values

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm upgrade --install --wait my-release \
    --set ingress.enabled=true \
    stable/gangway
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm upgrade --install --wait my-release stable/gangway -f values.yaml
```

> **Tip**: You can copy the default [values.yaml](values.yaml) and make any required edits in there

[gangway]: https://github.com/heptiolabs/gangway
[gangway docs]: https://github.com/heptiolabs/gangway/tree/master/docs
[Traefik]: https://docs.traefik.io/user-guide/kubernetes/
[Gorilla Secure Cookie]: https://github.com/gorilla/securecookie

## SSL Configuration

1. Edit `values.yaml`
    1. Set `gangway.serveTLS` to `true`.
    1. Set `livenessProbe.scheme` and `readinessProbe.scheme` to `HTTPS`.
2. Pass the TLS configuration to Gangway:
    - Either by pasting the certificate and private key in the `values.yaml` like:

    ```yaml
    tls:
      certData: |
        -----BEGIN CERTIFICATE-----
        ...
        -----END CERTIFICATE-----
      keyData: |
        -----BEGIN ENCRYPTED PRIVATE KEY-----
        ...
        -----END ENCRYPTED PRIVATE KEY-----
    ```

    - Or by specifying an existing secret in the `values.yaml` like:

    ```yaml
    ...
    tls:
      existingSecret: my-tls-secret
    ...
    ```

    > NB: The secret _must_ contain two entries, `tls.crt` and `tls.key`;
    > it will be mounted into `/etc/gangway/tls/` and e.g.
    > `/etc/gangway/tls/tls.crt` is the default path for `gangway.certFile`.
    > Otherwise adjust `gangway.certFile` and `gangway.keyFile` accordingly.
