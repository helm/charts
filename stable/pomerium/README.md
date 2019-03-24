# Pomerium

[Pomerium](https://pomerium.io) is an [open-source](https://github.com/pomerium/pomerium) tool for managing secure access to internal applications and resources.

## TL;DR;

```console
helm install --name my-release stable/pomerium
```

> Note: Pomerium depends on being configured with a third party identity providers to function properly. If you run pomerium without specifiying default values, you will need to change those configuration variables following setup. 


## Install the chart

An example of a minimal, but complete installation of pomerium with identity provider settings, random secrets, certificates, and external URLs is as follows: 


```sh
helm install --name my-release \
	--set proxy.authenticateServiceUrl="https://auth.corp.pomerium.io" \
	--set proxy.authorizeServiceUrl="https://access.corp.pomerium.io" \
	--set config.sharedSecret=$(head -c32 /dev/urandom | base64) \
	--set config.cookieSecret=$(head -c32 /dev/urandom | base64) \
	--set config.cert=$(base64 -i cert.pem) \
	--set config.key=$(base64 -i privkey.pem) \
	--set config.policy=$(cat policy.example.yaml) \
	--set config.rootDomain="corp.pomerium.io" \
	--set authentiate.redirectUrl="https://auth.corp.pomerium.io/oauth2/callback" \
    --set authentiate.idp.provider="google" \
	--set authentiate.idp.clientID="" \
	--set authentiate.idp.clientSecret="" \
    stable/pomerium
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete --purge my-release
```

The command removes nearly all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

A full listing of Pomerium's configuration variables can be found on the [config reference page](https://www.pomerium.io/docs/config-reference.html).

| Parameter                       | Description                                                                                                                                                                                                | Default                                         |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `config.sharedSecret`           | Shared secret is a 32 byte key used to secure service communication. [See more](https://www.pomerium.io/docs/config-reference.html#shared-secret).                                                         | Hardcoded.                                      |
| `config.cookieSecret`           | Cookie secret is a 32 byte key used to encrypt user sessions.                                                                                                                                              | Hardcoded.                                      |
| `config.key`                    | Certificate is the x509 private-key used to establish secure HTTP and gRPC connections. [See more](https://www.pomerium.io/docs/config-reference.html#certificate-key).                                    | Hardcoded self-signed cert                      |
| `config.cert`                   | Certificate is the x509 public-key used to establish secure HTTP and gRPC connections. [See more](https://www.pomerium.io/docs/config-reference.html#certificate).                                         | Hardcoded self-signed cert                      |
| `config.policy`                 | Base64 encoded string containing the routes, and their access policies. [See more](https://www.pomerium.io/docs/config-reference.html#policy).                                                             | See values.yaml                                 |
| `config.policyFile`             | Relative file location of the policy file which contains the routes, and their access policies. [See more](https://www.pomerium.io/docs/config-reference.html#policy).                                     |                                                 |
| `authenticate.name`             | Name of the authenticate service.                                                                                                                                                                          | `authenticate`                                  |
| `authenticate.redirectUrl`      | Redirect URL is the url the user will be redirected to following authentication with the third-party identity provider (IdP). [See more](https://www.pomerium.io/docs/config-reference.html#redirect-url). | `https://auth.corp.pomerium.io/oauth2/callback` |
| `config.rootDomain`             | Proxy Root Domains specifies the sub-domains that can proxy requests. [See more](https://www.pomerium.io/docs/config-reference.html#proxy-root-domains).                                                   | `pomerium.io`                                   |
| `authenticate.idp.provider`     | Identity [Provider Name](https://www.pomerium.io/docs/config-reference.html#identity-provider-name).                                                                                                       | `google`                                        |
| `authenticate.idp.url`          | Identity [Provider URL](https://www.pomerium.io/docs/config-reference.html#identity-provider-url).                                                                                                         |                                                 |
| `authenticate.idp.clientID`     | Identity Provider oauth [client ID](https://www.pomerium.io/docs/config-reference.html#identity-provider-client-id).                                                                                       | ``                                              |
| `authenticate.idp.clientSecret` | Identity Provider oauth [client secret](https://www.pomerium.io/docs/config-reference.html#identity-provider-client-secret).                                                                               | ``                                              |
| `proxy.name`                    | Name of the proxy service.                                                                                                                                                                                 | `proxy`                                         |
| `proxy.authenticateServiceUrl`  | The externally accessible url for the authenticate service.                                                                                                                                                | `https://auth.corp.pomerium.io`                 |
| `proxy.authorizeServiceUrl`     | The externally accessible url for the authorize service.                                                                                                                                                   | `https://access.corp.pomerium.io`               |
| `images.server.repository`      | Pomerium image                                                                                                                                                                                             | `pomerium/pomerium`                             |
| `images.server.tag`             | Pomerium image tag                                                                                                                                                                                         | `latest`                                        |
| `images.server.pullPolicy`      | Pomerium image pull policy                                                                                                                                                                                 | `IfNotPresent`                                  |
| `service.annotations`           | Service annotations                                                                                                                                                                                        | `{}`                                            |
| `service.externalPort`          | Pomerium's port                                                                                                                                                                                            | `443`                                           |
| `service.type`                  | Service type (ClusterIP, NodePort or LoadBalancer)                                                                                                                                                         | `ClusterIP`                                     |
| `ingress.enabled`               | Enables Ingress for pomerium                                                                                                                                                                               | `false`                                         |
| `ingress.annotations`           | Ingress annotations                                                                                                                                                                                        | `{}`                                            |
| `ingress.hosts`                 | Ingress accepted hostnames                                                                                                                                                                                 | `nil`                                           |
| `ingress.tls`                   | Ingress TLS configuration                                                                                                                                                                                  | `[]`                                            |
