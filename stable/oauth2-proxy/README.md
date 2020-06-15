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

## Upgrading an existing Release to a new major version

A major chart version change (like v1.2.3 -> v2.0.0) indicates that there is an
incompatible breaking change needing manual actions.

### To 1.0.0

This version upgrade oauth2-proxy to v4.0.0. Please see the [changelog](https://github.com/pusher/oauth2_proxy/blob/v4.0.0/CHANGELOG.md#v400) in order to upgrade.

### To 2.0.0

Version 2.0.0 of this chart introduces support for Kubernetes v1.16.x by way of addressing the deprecation of the Deployment object apiVersion `apps/v1beta2`.  See [the v1.16 API deprecations page](https://kubernetes.io/blog/2019/07/18/api-deprecations-in-1-16/) for more information.

Due to [this issue](https://github.com/helm/helm/issues/6583) there may be errors performing a `helm upgrade`of this chart from versions earlier than 2.0.0.

### To 3.0.0

Version 3.0.0 introduces support for [EKS IAM roles for service accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) by adding a managed service account to the chart.  This is a breaking change since the service account is enabled by default.  To disable this behaviour set `serviceAccount.enabled` to `false`

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
`extraEnv` | key:value list of extra environment variables to give the binary | `[]`
`extraVolumes` | list of extra volumes | `[]`
`extraVolumeMounts` | list of extra volumeMounts | `[]`
`htpasswdFile.enabled` | enable htpasswd-file option | `false`
`htpasswdFile.entries` | list of [SHA encrypted user:passwords](https://pusher.github.io/oauth2_proxy/configuration#command-line-options) | `{}`
`htpasswdFile.existingSecret` | existing Kubernetes secret to use for OAuth2 htpasswd file | `""`
`httpScheme` | `http` or `https`. `name` used for port on the deployment. `httpGet` port `name` and `scheme` used for `liveness`- and `readinessProbes`. `name` and `targetPort` used for the service. | `http`
`image.pullPolicy` | Image pull policy | `IfNotPresent`
`image.repository` | Image repository | `quay.io/pusher/oauth2_proxy`
`image.tag` | Image tag | `v5.1.0`
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
`podDisruptionBudget.enabled`| Enabled creation of PodDisruptionBudget (only if replicaCount > 1) | true
`podDisruptionBudget.minAvailable`| minAvailable parameter for PodDisruptionBudget | 1
`podSecurityContext` | Kubernetes security context to apply to pod | `{}`
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
`serviceAccount.enabled` | create a service account | `true`
`serviceAccount.name` | the service account name | ``
`serviceAccount.annotations` | (optional) annotations for the service account | `{}`
`tolerations` | list of node taints to tolerate | `[]`
`securityContext.enabled` | enable Kubernetes security context on container | `false`
`securityContext.runAsNonRoot` | make sure that the container runs as a non-root user | `true`
`proxyVarsAsSecrets` | choose between environment values or secrets for setting up OAUTH2_PROXY variables. When set to false, remember to add the variables OAUTH2_PROXY_CLIENT_ID, OAUTH2_PROXY_CLIENT_SECRET, OAUTH2_PROXY_COOKIE_SECRET in extraEnv | `true`


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

## SSL Configuration

See: [SSL Configuration](https://pusher.github.io/oauth2_proxy/tls-configuration).
Use ```values.yaml``` like:

```yaml
...
extraArgs:
  tls-cert: /path/to/cert.pem
  tls-key: /path/to/cert.key

extraVolumes:
  - name: ssl-cert
    secret:
      secretName: my-ssl-secret

extraVolumeMounts:
  - mountPath: /path/to/
    name: ssl-cert
...
```

With a secret called `my-ssl-secret`:

```yaml
...
data:
  cert.pem: AB..==
  cert.key: CD..==
```
