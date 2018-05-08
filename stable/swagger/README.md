# Swagger UI

Swagger UI is a collection of HTML, Javascript, and CSS assets that dynamically generate beautiful documentation from a Swagger-compliant API.


This chart allows for setting the Swagger UI behind basic auth or oauth, by taking advantage of the [`nginx-ingress`](https://github.com/kubernetes/charts/tree/master/stable/nginx-ingress) and [`oauth2-proxy`](https://github.com/kubernetes/charts/tree/master/stable/oauth2-proxy) charts, which should be installed and managed separately.


### Prerequisites

- Kubernetes 1.8+

### Install

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/swagger
```

If you want to preload a specific swagger configuration file:
- `--set env.API_URL=http://generator.swagger.io/api/swagger.json`


## Configuration

The following tables lists the configurable parameters of the Swagger UI chart and their default values.

|              Parameter                   |               Description                   |             Default             |
|------------------------------------------|---------------------------------------------|---------------------------------|
| `env.API_URL`                            | URL to fetch configuration document from.   | `nil`                           |
| `image.repository`                       | Swagger ui image                            | `swaggerapi/swagger-ui`         |
| `image.tag`                              | Swagger ui image tag                        | `v3.14.1`                       |
| `image.pullPolicy`                       | Image pull policy                           | `IfNotPresent`                  |
| `service.type`                           | Kubernetes service type                     | `TCP`                           |
| `service.protocol`                       | Kubernetes service protocol                 | `NodePort`                      |
| `service.externalPort`                   | Port in which swagger service is exposed    | `80`                            |
| `ingress.enabled`                        | Enable ingress controller resource          | `false`                         |
| `ingress.annotations`                    | Ingress annotations                         | `{}`                            |
| `ingress.hostname`                       | URL to address Swagger                      | `nil`                           |
| `ingress.tls`                            | Ingress TLS configuration                   | `[]`                            |
| `ingress.basicAuth.enabled`              | Enable basic auth                           | `false`                         |
| `ingress.basicAuth.secret`               | htpasswd username:password hash             | `YWRtaW46JGFwcjEkUm4zVHBwNDUkb2VOd0JoeWtWWHh0bUNmNnJ1Y2VaMAo=` which is the equivalent of `admin:test`, use `htpasswd -n <username>` to generate your own  |
| `ingress.basicAuth.basicAuthAnnotations` | Ingress annotations specific to basic auth  | `{  nginx.ingress.kubernetes.io/auth-type: basic,    nginx.ingress.kubernetes.io/auth-realm: "Authentication Required"}`   |
| `ingress.oauth.enabled`                  | Enable oauth auth                           | `false`                         |
| `ingress.oauth.oauthAnnotations`         | Ingress annotations specific to oauth       | `{  kubernetes.io/ingress.class: nginx,   nginx.ingress.kubernetes.io/auth-signin: https://$host/oauth2/start,   nginx.ingress.kubernetes.io/auth-url: https://$host/oauth2/auth}`     |
| `resources`                              | pod resource requests & limits              | `{}`                            |
| `nodeSelector`                           | node labels for pod assignment              | `{}`                            |
| `tolerations`                            | node taints to tolerate                     | `[]`                            |
| `affinity`                               | node/pod affinities                         | `{}`                            |


**Https and Nginx**

An example configuration that uses `nginx-ingress` and `cert-manager` to provide a UI with https enabled. For more information on the dependecy configurations, please review the respective charts.
```yaml
ingress:
  enabled: true
  hostname: test.example.com
  annotations:
    kubernetes.io/ingress.class: nginx
    kubernetes.io/tls-acme: 'true'
  tls:
    - hosts:
      - test.example.com
        secretName: swagger-tls

cert-manager:
  ingressShim:
    extraArgs:
      - --default-issuer-name=letsencrypt-prod
      - --default-issuer-kind=Issuer
```

**Basic Auth**

An example for basic auth is similar to the above, but the ingress configuration would be:
```yaml
ingress:
  enabled: true
  hostname: test.example.com
  annotations:
    kubernetes.io/ingress.class: nginx
    kubernetes.io/tls-acme: 'true'
  tls:
    - hosts:
      - test.example.com
        secretName: swagger-tls
  basicAuth:
    enabled: true
    secret: YWRtaW46JGFwcjEkUm4zVHBwNDUkb2VOd0JoeWtWWHh0bUNmNnJ1Y2VaMAo=
```

**Oauth**

An example using `oauth2-proxy` and `nginx-ingress` with Github as a backend. More documentation on [how to use Github as a backend](https://github.com/kubernetes/ingress-nginx/blob/master/docs/examples/external-auth/README.md):
```yaml
ingress:
  enabled: true
  hostname: test.example.com
  oauth:
    enabled: true

oauth2-proxy:
  config:
    # OAuth client ID
    clientID: ""
    # OAuth client secret
    clientSecret: ""
    # Create a new secret with the following command
    cookieSecret: ""
  extraArgs:
    provider: github
  ingress:
    enabled: true
    path: /oauth2
    annotations:
      kubernetes.io/ingress.class: nginx
      kubernetes.io/tls-acme: 'true'
    hosts:
      - test.example.com
    tls:
      - secretName: test-auth-tls
        hosts:
          - test.example.com
```