# oauth2-proxy

[oauth2-proxy](https://github.com/pusher/oauth2_proxy) is a reverse proxy and static file server that provides authentication using Providers (Google, GitHub, and others) to validate accounts by email, domain or group.

## TL;DR;

```console
$ helm install stable/oauth2-proxy
```

## Introduction

This chart bootstraps an oauth2-proxy deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install stable/oauth2-proxy --name my-release
```

The command deploys oauth2-proxy on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the oauth2-proxy chart and their default values.

Parameter | Description | Default
--- | --- | ---
`affinity` | node/pod affinities | None
`authenticatedEmailsFile.enabled` | Enables authorize individual email addresses | `false`
`authenticatedEmailsFile.template` | Name of the configmap that is handled outside of that chart | `""`
`authenticatedEmailsFile.restricted_access` | [email addresses](https://github.com/pusher/oauth2_proxy#email-authentication) list config | `""`
`config.clientID` | oauth client ID | `""`
`config.clientSecret` | oauth client secret | `""`
`config.cookieSecret` | server specific cookie for the secret; create a new one with `openssl rand -base64 32 | head -c 32 | base64` | `""`
`config.existingSecret` | existing Kubernetes secret to use for OAuth2 credentials. See [secret template](https://github.com/helm/charts/blob/master/stable/oauth2-proxy/templates/secret.yaml) for the required values | `nil`
`config.configFile` | custom [oauth2_proxy.cfg](https://github.com/pusher/oauth2_proxy/blob/master/contrib/oauth2_proxy.cfg.example) contents for settings not overridable via environment nor command line | `""`
`config.existingConfig` | existing Kubernetes configmap to use for the configuration file. See [config template](https://github.com/helm/charts/blob/master/stable/oauth2-proxy/templates/configmap.yaml) for the required values | `nil`
`config.google.adminEmail` | user impersonated by the google service account | `""`
`config.google.serviceAccountJson` | google service account json contents | `""`
`config.google.existingConfig` | existing Kubernetes configmap to use for the service account file. See [google secret template](https://github.com/helm/charts/blob/master/stable/oauth2-proxy/templates/google-secret.yaml) for the required values | `nil`
`extraArgs` | key:value list of extra arguments to give the binary | `{}`
`htpasswdFile.enabled` | enable htpasswd-file option | `false`
`htpasswdFile.entries` | list of [SHA encrypted user:passwords](https://pusher.github.io/oauth2_proxy/configuration#command-line-options) | `{}`
`htpasswdFile.existingSecret` | existing Kubernetes secret to use for OAuth2 htpasswd file` | `""`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`image.repository` | Image repository | `quay.io/pusher/oauth2_proxy`
`image.tag` | Image tag | `v3.2.0`
`imagePullSecrets` | Specify image pull secrets | `nil` (does not add image pull secrets to deployed pods)
`ingress.enabled` | Enable Ingress | `false`
`ingress.path` | Ingress accepted path | `/`
`ingress.annotations` | Ingress annotations | `nil`
`ingress.hosts` | Ingress accepted hostnames | `nil`
`ingress.tls` | Ingress TLS configuration | `nil`
`livenessProbe.enabled`  | enable Kubernetes livenessProbe. Disable to use oauth2-proxy with Istio mTLS. See [Istio FAQ](https://istio.io/help/faq/security/#k8s-health-checks) | `true`
`livenessProbe.initialDelaySeconds` | number of seconds | 0
`livenessProbe.timeoutSeconds` | number of seconds | 1
`nodeSelector` | node labels for pod assignment | `{}`
`podAnnotations` | annotations to add to each pod | `{}`
`podLabels` | additional labesl to add to each pod | `{}`
`priorityClassName` | priorityClassName | `nil`
`readinessProbe.enabled` | enable Kubernetes readinessProbe. Disable to use oauth2-proxy with Istio mTLS. See [Istio FAQ](https://istio.io/help/faq/security/#k8s-health-checks) | `true`
`readinessProbe.initialDelaySeconds` | number of seconds | 0
`readinessProbe.timeoutSeconds` | number of seconds | 1
`readinessProbe.periodSeconds` | number of seconds | 10
`readinessProbe.successThreshold` | number of successes | 1
`replicaCount` | desired number of pods | `1`
`resources` | pod resource requests & limits | `{}`
`service.port` | port for the service | `80`
`service.type` | type of service | `ClusterIP`
`service.clusterIP` | cluster ip address | `nil`
`service.loadBalancerIP` | ip of load balancer | `nil`
`service.loadBalancerSourceRanges` | allowed source ranges in load balancer | `nil`
`tolerations` | List of node taints to tolerate | `[]`

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install stable/oauth2-proxy --name my-release \
  --set=image.tag=v0.0.2,resources.limits.cpu=200m
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/oauth2-proxy --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
