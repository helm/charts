# Rendertron Helm Chart

> Rendertron is a dockerized, headless Chrome rendering solution designed to render & serialise web pages on the fly.

[Rendertron](https://github.com/GoogleChrome/rendertron#config) is designed to enable your Progressive Web App (PWA) to serve the correct
content to any bot that doesn't render or execute JavaScript. Rendertron runs as a
standalone HTTP server. Rendertron renders requested pages using Headless Chrome,
[auto-detecting](#auto-detecting-loading-function) when your PWA has completed loading
and serializes the response back to the original request. To use Rendertron, your application
configures [middleware](#middleware) to determine whether to proxy a request to Rendertron.
Rendertron is compatible with all client side technologies, including [web components](#web-components).

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/rendertron
```

## Configuration

The following tables list the configurable parameters of the Rendertron chart and their default values.

| Parameter                         | Description                          | Default                                                                      |
| --------------------------------- | ------------------------------------ | ---------------------------------------------------------------------------- |
| `nameOverride`                    | Override the resource name prefix    | `jenkins`                                                                    |
| `fullnameOverride`                | Override the full resource names     | `jenkins-{release-name}` (or `jenkins` if release-name is `jenkins`)         |

## Configuration

| Parameter                  | Description                         | Default                                                 |
|----------------------------|-------------------------------------|---------------------------------------------------------|
| `replicaCount`               | Number of nodes | `1` |
| `image.repository`           | Image repository | `ravishi/rendertron` |
| `image.tag`                  | Image tag. Possible values listed [here](https://hub.docker.com/r/ravishi/rendertron/tags/).| `a6b93ee7ca98687610542ac930597ce5064762d2`|
| `image.pullPolicy`           | Image pull policy | `IfNotPresent` |
| `config.cache`               | Enable cache | `false` |
| `config.debug`               | Enable debugging | `false` |
| `config.analyticsTrackingId` | Google Analytics tracking ID. See [config options](https://github.com/GoogleChrome/rendertron#config). | `""` |
| `config.renderOnly`          | Restricted Domains. See [config options](https://github.com/GoogleChrome/rendertron#config). | `[]` |
| `service.type`               | Kubernetes service type | `ClusterIP` |
| `service.externalPort`       | external port for the service| `8080` |
| `service.internalPort`       | internal port for the service| `3000` |
| `service.annotations`        | Service annotations | `{}` |
| `service.labels`             | Custom labels | `{}`
| `ingress.enabled`            | Enables Ingress | `false` |
| `ingress.annotations`        | Ingress path | `/` |
| `ingress.path`               | Ingress annotations | `{}` |
| `ingress.hosts`              | Ingress accepted hostnames | `[]` |
| `ingress.tls`                | Ingress TLS configuration | `[]` |
| `resources`                  | CPU/Memory resource requests/limits | `{}` |
| `nodeSelector`               | Node labels for pod assignment | `{}` |
| `tolerations`                | Toleration labels for pod assignment | `[]` |
| `affinity`                   | Affinity settings for pod assignment | `{}` |
| `env`                        | Extra environment variables passed to pods | `{}` |
| `annotations`                | Deployment annotations | `{}` |
| `podAnnotations`             | Pod annotations | `{}` |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/rendertron
```

> **Tip**: You can use the default [values.yaml](values.yaml)

Note that Rendertron [does not yet release official docker container images](https://github.com/GoogleChrome/rendertron/issues/93).  Therefore, you must build and publish your own images or use the unofficial ones available at https://hub.docker.com/r/ravishi/rendertron/tags/.
