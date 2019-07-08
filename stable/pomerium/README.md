# Pomerium

[Pomerium](https://pomerium.io) is an [open-source](https://github.com/pomerium/pomerium) tool for managing secure access to internal applications and resources.

## TL;DR;

```console
helm install --name my-release stable/pomerium
```

> Note: Pomerium depends on being configured with a third party identity providers to function properly. If you run pomerium without specifying default values, you will need to change those configuration variables following setup.

## Install the chart

An example of a minimal, but complete installation of pomerium with identity provider settings, random secrets, certificates, and external URLs is as follows:

```sh
kubectl create configmap config --from-file="config.yaml"="$HOME/pomerium/docs/docs/examples/config/config.example.yaml"

helm install $HOME/pomerium-helm \
	--set service.type="NodePort" \
	--set config.rootDomain="corp.beyondperimeter.com" \
	--set config.existingConfig="config" \
	--set config.sharedSecret=$(head -c32 /dev/urandom | base64) \
	--set config.cookieSecret=$(head -c32 /dev/urandom | base64) \
	--set ingress.secret.name="pomerium-tls" \
	--set ingress.secret.cert=$(base64 -i "$HOME/.acme.sh/*.corp.beyondperimeter.com_ecc/fullchain.cer") \
	--set ingress.secret.key=$(base64 -i "$HOME/.acme.sh/*.corp.beyondperimeter.com_ecc/*.corp.beyondperimeter.com.key") \
	--set authenticate.idp.provider="google" \
	--set authenticate.idp.clientID="REPLACE_ME" \
	--set authenticate.idp.clientSecret="REPLACE_ME" \
	stable/pomerium

```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete --purge my-release
```

The command removes nearly all the Kubernetes components associated with the chart and deletes the release.

## Configuration

A full listing of Pomerium's configuration variables can be found on the [config reference page](https://www.pomerium.io/docs/config-reference.html).

Parameter                         | Description                                                                                                                                                                                                | Default
--------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------
`config.rootDomain`               | Root Domain specifies the sub-domain handled by pomerium. [See more](https://www.pomerium.io/docs/config-reference.html#proxy-root-domains).                                                               | `corp.pomerium.io`
`config.generateTLS`              | Generate a dummy Certificate Authority and certs for service communication. Manual CA and certs can be set in values.                                                                                      | `true`
`config.sharedSecret`             | 256 bit key to secure service communication. [See more](https://www.pomerium.io/docs/config-reference.html#shared-secret).                                                                                 | 32 [random ascii chars](http://masterminds.github.io/sprig/strings.html)
`config.cookieSecret`             | Cookie secret is a 32 byte key used to encrypt user sessions.                                                                                                                                              | 32 [random ascii chars](http://masterminds.github.io/sprig/strings.html)
`config.policy`                   | Base64 encoded string containing the routes, and their access policies.                                                                                                                                    |
`config.policyFile`               | Relative file location of the policy file which contains the routes, and their access policies.                                                                                                            | [See example](https://www.pomerium.io/docs/config-reference.html#policy) in values
`authenticate.nameOverride`       | Name of the authenticate service.                                                                                                                                                                          |
`authenticate.fullnameOverride`   | Full name of the authenticate service.                                                                                                                                                                     |
`authenticate.redirectUrl`        | Redirect URL is the url the user will be redirected to following authentication with the third-party identity provider (IdP). [See more](https://www.pomerium.io/docs/config-reference.html#redirect-url). | `https://{{authenticate.name}}.{{config.rootDomain}}/oauth2/callback`
`authenticate.idp.provider`       | Identity [Provider Name](https://www.pomerium.io/docs/config-reference.html#identity-provider-name).                                                                                                       | `google`
`authenticate.idp.clientID`       | Identity Provider oauth [client ID](https://www.pomerium.io/docs/config-reference.html#identity-provider-client-id).                                                                                       | Required
`authenticate.idp.clientSecret`   | Identity Provider oauth [client secret](https://www.pomerium.io/docs/config-reference.html#identity-provider-client-secret).                                                                               | Required
`authenticate.idp.url`            | Identity [Provider URL](https://www.pomerium.io/docs/config-reference.html#identity-provider-url).                                                                                                         | Optional
`authenticate.idp.serviceAccount` | Identity Provider [service account](https://www.pomerium.io/docs/config-reference.html#identity-provider-service-account).                                                                                 | Optional
`proxy.nameOverride`              | Name of the proxy service.                                                                                                                                                                                 |
`proxy.fullnameOverride`          | Full name of the proxy service.                                                                                                                                                                            |
`proxy.authenticateServiceUrl`    | The externally accessible url for the authenticate service.                                                                                                                                                | `https://{{authenticate.name}}.{{config.rootDomain}}`
`proxy.authorizeServiceUrl`       | The externally accessible url for the authorize service.                                                                                                                                                   | `https://{{authorize.name}}.{{config.rootDomain}}`
`authorize.nameOverride`          | Name of the authorize service.                                                                                                                                                                             |
`authorize.fullnameOverride`      | Full name of the authorize service.                                                                                                                                                                        |
`images.server.repository`        | Pomerium image                                                                                                                                                                                             | `pomerium/pomerium`
`images.server.tag`               | Pomerium image tag                                                                                                                                                                                         | `latest`
`images.server.pullPolicy`        | Pomerium image pull policy                                                                                                                                                                                 | `Always`
`service.annotations`             | Service annotations                                                                                                                                                                                        | `{}`
`service.externalPort`            | Pomerium's port                                                                                                                                                                                            | `443`
`service.type`                    | Service type (ClusterIP, NodePort or LoadBalancer)                                                                                                                                                         | `ClusterIP`
`ingress.enabled`                 | Enables Ingress for pomerium                                                                                                                                                                               | `false`
`ingress.annotations`             | Ingress annotations                                                                                                                                                                                        | `{}`
`ingress.hosts`                   | Ingress accepted hostnames                                                                                                                                                                                 | `nil`
`ingress.tls`                     | Ingress TLS configuration                                                                                                                                                                                  | `[]`
`metrics.enabled`                     | Enable prometheus metrics endpoint                                                                                                                                                                                  | `false`
`metrics.port`                     | Prometheus metrics endpoint port                                                                                                                                                                                  | `9090`

## Metrics Discovery Configuration


### Prometheus kubernetes_sd_configs

Example chart values:

```yaml
metrics:
  enabled: true
  port: 9090 # default
service:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9090"
```

Example prometheus discovery config:
```yaml
- job_name: 'pomerium'
metrics_path: /metrics
kubernetes_sd_configs:
- role: endpoints
relabel_configs:
- source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
  action: keep
  regex: true
- source_labels: [__meta_kubernetes_service_label_app_kubernetes_io_instance]
  action: keep
  regex: pomerium
- action: labelmap
  regex: __meta_kubernetes_service_label_(.+)
- source_labels: [__meta_kubernetes_namespace]
  action: replace
  target_label: kubernetes_namespace
- source_labels: [__meta_kubernetes_service_name]
  action: replace
  target_label: kubernetes_name
- source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
  action: replace
  regex: ([^:]+)(?::\d+)?;(\d+)
  replacement: $1:$2
  target_label: __address__
```
