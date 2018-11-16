# Keycloak-gatekeeper

[Keycloak gatekeeper](https://github.com/keycloak/keycloak-gatekeeper) is an authentication proxy service which at the risk of stating the obvious integrates with the Keycloak authentication service.

# TL;DR;

```bash
helm install stable/keycloak-gatekeeper \
    --set discoveryURL=https://keycloak.example.com/auth/realms/myrealm \
    --set upstreamURL=http://my-svc.my-namespace.svc.cluster.local:8088 \
    --set ClientID=myOIDCClientID \
    --set ClientSecret=8cbf1a0e-ed08-4978-af7a-70cbda07baac \
    --set ingress.enabled=true \
    --set ingress.hosts[0]=my-svc-auth.example.com
```

# Introduction

This chart bootstraps an authenticating proxy for a service.

Users accessing this service will be required to login and then they will be granted access to the backend service.

This can be used with Kubernetes-dashboard, Grafana, Jenkins, ...

# Configuration options

| Parameter      | Description                                                | Default |
| -------------- | ---------------------------------------------------------- | :-----: |
| `discoveryURL` | URL for OpenID autoconfiguration                           | ``      |
| `upstreamURL`  | URL of the service to proxy                                | ``      |
| `ClientID`     | Client ID for OpenID server                                | ``      |
| `ClientSecret` | Client secret for OpenID server                            | ``      |
| `scopes`       | Additional required scopes for authentication              | `[]`    |
| `addClaims`    | Set these claims as headers in the request for the backend | `[]`    |
| `matchClaims`  | Key-Value pairs that the JWT should contain                | `{}`    |
| `resources`    | Specify fine grained rules for authentication              | `[]`    |
| `debug`        | Use verbose logging                                        | `false` |

# Setting up Keycloak

After having installed Keycloak from its [Helm chart](https://github.com/helm/charts/tree/master/stable/keycloak)

* Create a client in Keycloak with protocol `openid-connect` and access-type: `confidential`
* Add a redirect URL to `<SCHEME>://<PROXY_HOST>/oauth/callback`
* Get the `ClientID` and `ClientSecret` from the `Credentials` page

You can now use this new client from keycloak-gatekeeper

# Fine grained rules for authentication

This chart allows to specify rules inside of the `resource` array, these can be used to fine-tweak your authentication endpoints

Each element of `resource` is a `|` (pipe separator) delimited list of key, value pairs.

Here is a non exhaustive list of key-value pairs

| Example          | Description                                                        |
| :--------------: | ------------------------------------------------------------------ |
| uri=/private/*   | require access to subpaths of /private                             |
| roles=admin,user | require the user to have both roles to access                      |
| require-any-role | combined with roles above, switches the conditional from AND to OR |
| white-listed     | allow anyone to have access                                        |
| methods=GET,POST | apply authentication to these methods                              |

## Example

```yaml
resources:
- "uri=/admin*|roles=admin,root|require-any-role"
- "uri=/public*|white-listed=true"
- "uri=/authenticated/users|roles=user"
```

This sets up

* Paths under `/admin` to be accessible only from admins or root
* Paths under `/public` to be accessible by anyone
* Path `/authenticated/users` is accessible only from users
