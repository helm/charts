# Linkerd2 Helm Chart

Linkerd is a *service mesh*, designed to give platform-wide observability,
reliability, and security without requiring configuration or code changes.

Linkerd is a Cloud Native Computing Foundation ([CNCF][cncf]) project.

## Quickstart and documentation

You can run Linkerd on any Kubernetes 1.12+ cluster in a matter of seconds. See
the [Linkerd Getting Started Guide][getting-started] for how.

For more comprehensive documentation, start with the [Linkerd
docs][linkerd-docs].

## Prerequisite: identity certificates

The identity component of Linkerd requires setting up a trust anchor
certificate, and an issuer certificate with its key. These need to be provided
to Helm by the user (unlike when using the `linkerd install` CLI which can
generate these automatically). You can provide your own, or follow [these
instructions](https://linkerd.io/2/tasks/generate-certificates/) to generate new ones.

Note that the provided certificates must be ECDSA certficates.

## Installing the chart

You must provide the certificates and keys described in the preceding section,
and the same expiration date you used to generate the Issuer certificate.

In this example we set the expiration date to one year ahead:

```bash
helm install \
  --set-file Identity.TrustAnchorsPEM=ca.crt \
  --set-file Identity.Issuer.TLS.CrtPEM=issuer.crt \
  --set-file Identity.Issuer.TLS.KeyPEM=issuer.key \
  --set Identity.Issuer.CrtExpiry=$(date -d '+8760 hour' +"%Y-%m-%dT%H:%M:%SZ") \
  charts/linkerd2
```

## Setting High-Availability

Besides the default `values.yaml` file, the chart provides a `values-ha.yaml`
file that overrides some default values as to set things up under a
high-availability scenario, analogous to the `--ha` option in `linkerd install`.
Values such as higher number of replicas, higher memory/cpu limits and
affinities are specified in that file.

```bash
helm install \
  --set-file Identity.TrustAnchorsPEM=ca.crt \
  --set-file Identity.Issuer.TLS.CrtPEM=issuer.crt \
  --set-file Identity.Issuer.TLS.KeyPEM=issuer.key \
  --set Identity.Issuer.CrtExpiry=$(date -d '+8760 hour' +"%Y-%m-%dT%H:%M:%SZ") \
  -f charts/linkerd2/values-ha.yaml
  charts/linkerd2
```

## Configuration

The following table lists the configurable parameters of the Linkerd2 chart and their default values.

| Parameter                            | Description                                                                                     | Default                       |
|--------------------------------------|-------------------------------------------------------------------------------------------------|-------------------------------|
|`ClusterDomain`                       | Kubernetes DNS Domain name to use                                                               | `cluster.local`|
|`EnableH2Upgrade`                     | Allow proxies to perform transparent HTTP/2 upgrading                                           |`true`|
|`ImagePullPolicy`                     | Docker image pull policy                                                                        |`IfNotPresent`|
|`LinkerdVersion`                      | Control plane version                                                                           |`stable-2.5.0`|
|`Namespace`                           | Control plane namespace                                                                         |`linkerd`|
|`OmitWebhookSideEffects`              | Omit the `sideEffects` flag in the webhook manifests                                            |`false`|
|`WebhookFailurePolicy`                | Failure policy for the proxy injector                                                           |`Ignore`|
|`ControllerImage`                     | Docker image for the controller, tap and identity components                                    |`gcr.io/linkerd-io/controller`|
|`ControllerLogLevel`                  | Log level for the control plane components                                                      |`info`|
|`ControllerReplicas`                  | Number of replicas for each control plane pod                                                   |`1`|
|`ControllerUID`                       | User ID for the control plane components                                                        |`2103`|
|`Identity.Issuer.ClockSkewAllowance`  | Amount of time to allow for clock skew within a Linkerd cluster                                 |`20s`|
|`Identity.Issuer.CrtExpiry`           | Expiration timestamp for the issuer certificate. It must be provided during install             ||
|`Identity.Issuer.CrtExpiryAnnotation` | Annotation used to identity the issuer certificate expiration timestamp. Do not edit.           |`linkerd.io/identity-issuer-expiry`|
|`Identity.Issuer.IssuanceLifeTime`    | Amount of time for which the Identity issuer should certify identity                            |`86400s`|
|`Identity.Issuer.TLS.CrtPEM`          | Issuer certificate (ECDSA). It must be provided during install.                                 ||
|`Identity.Issuer.TLS.KeyPEM`          | Key for the issuer certificate (ECDSA). It must be provided during install.                     ||
|`Identity.TrustAnchorsPEM`            | Trust root certificate (ECDSA). It must be provided during install.                             ||
|`Identity.TrustDomain`                | Trust domain used for identity                                                                  |`cluster.local`|
|`GrafanaImage`                        | Docker image for the Grafana container                                                          |`gcr.io/linkerd-io/grafana`|
|`HeartbeatSchedule`                   | Config for the heartbeat cronjob                                                                |`0 0 * * *`|
|`PrometheusImage`                     | Docker image for the Prometheus container                                                       |`prom/prometheus:v2.11.1`|
|`PrometheusLogLevel`                  | Log level for Prometheus                                                                        |`info`|
|`Proxy.EnableExternalProfiles`        | Enable service profiles for non-Kubernetes services                                             |`false`|
|`Proxy.Image.Name`                    | Docker image for the proxy                                                                      |`gcr.io/linkerd-io/proxy`|
|`Proxy.Image.PullPolicy`              | Pull policy for the proxy container Docker image                                                |`IfNotPresent`|
|`Proxy.Image.Version`                 | Tag for the proxy container Docker image                                                        |`stable-2.5.0`|
|`Proxy.LogLevel`                      | Log level for the proxy                                                                         |`warn,linkerd2_proxy=info`|
|`Proxy.Ports.Admin`                   | Admin port for the proxy container                                                              |`4191`|
|`Proxy.Ports.Control`                 | Control port for the proxy container                                                            |`4190`|
|`Proxy.Ports.Inbound`                 | Inbound port for the proxy container                                                            |`4143`|
|`Proxy.Ports.Outbound`                | Outbound port for the proxy container                                                           |`4140`|
|`Proxy.Resources.CPU.Limit`           | Maximum amount of CPU units that the proxy can use                                              ||
|`Proxy.Resources.CPU.Request`         | Amount of CPU units that the proxy requests                                                     ||
|`Proxy.Resources.Memory.Limit`        | Maximum amount of memory that the proxy can use                                                 ||
|`Proxy.Resources.Memory.Request`      | Amount of memory that the proxy requests                                                        ||
|`Proxy.UID`                           | User id under which the proxy runs                                                              |`2102`|
|`ProxyInit.IgnoreInboundPorts`        | Inbound ports the proxy should ignore                                                           ||
|`ProxyInit.IgnoreOutboundPorts`       | Outbound ports the proxy should ignore                                                          ||
|`ProxyInit.Image.Name`                | Docker image for the proxy-init container                                                       |`gcr.io/linkerd-io/proxy-init`|
|`ProxyInit.Image.PullPolicy`          | Pull policy for the proxy-init container Docker image                                           |`IfNotPresent`|
|`ProxyInit.Image.Version`             | Tag for the proxy-init container Docker image                                                   |`v1.1.0`|
|`ProxyInit.Resources.CPU.Limit`       | Maximum amount of CPU units that the proxy-init container can use                               |`100m`|
|`ProxyInit.Resources.CPU.Request`     | Amount of CPU units that the proxy-init container requests                                      |`10m`|
|`ProxyInit.Resources.Memory.Limit`    | Maximum amount of memory that the proxy-init container can use                                  |`50Mi`|
|`ProxyInit.Resources.Memory.Request`  | Amount of memory that the proxy-init container requests                                         |`10Mi`|
|`ProxyInjector.CrtPEM`                | Certificate for the proxy injector. If not provided then Helm will generate one.                ||
|`ProxyInjector.KeyPEM`                | Certificate key for the proxy injector. If not provided then Helm will generate one.            ||
|`ProfileValidator.CrtPEM`             | Certificate for the service profile validator. If not provided then Helm will generate one.     ||
|`ProfileValidator.KeyPEM`             | Certificate key for the service profile validator. If not provided then Helm will generate one. ||
|`Tap.CrtPEM`                          | Certificate for the Tap component. If not provided then Helm will generate one.                 ||
|`Tap.KeyPEM`                          | Certificate key for Tap component. If not provided then Helm will generate one.                 ||
|`WebImage`                            | Docker image for the web container                                                              |`gcr.io/linkerd-io/web`|
|`CreatedByAnnotation`                 | Annotation label for the proxy create. Do not edit.                                             |`linkerd.io/created-by`|
|`ProxyInjectAnnotation`               | Annotation label to signal injection. Do not edit.                                              ||
|`ProxyInjectDisabled`                 | Annotation value to disable injection. Do not edit.                                             |`disabled`|
|`ControllerComponentLabel`            | Control plane label. Do not edit                                                                |`linkerd.io/control-plane-component`|
|`ControllerNamespaceLabel`            | Control plane label. Do not edit                                                                |`linkerd.io/control-plane-component`|
|`LinkerdNamespaceLabel`               | Control plane label. Do not edit                                                                |`linkerd.io/control-plane-component`|

## Get involved

* Check out Linkerd's source code at [Github][linkerd2].
* Join Linkerd's [user mailing list][linkerd-users],
[developer mailing list][linkerd-dev], and [announcements mailing list][linkerd-announce].
* Follow [@linkerd][twitter] on Twitter.
* Join the [Linkerd Slack][slack].


[cncf]: https://www.cncf.io/
[getting-started]: https://linkerd.io/2/getting-started/
[linkerd2]: https://github.com/linkerd/linkerd2
[linkerd-announce]: https://lists.cncf.io/g/cncf-linkerd-announce
[linkerd-dev]: https://lists.cncf.io/g/cncf-linkerd-dev
[linkerd-docs]: https://linkerd.io/2/overview/
[linkerd-users]: https://lists.cncf.io/g/cncf-linkerd-users
[slack]: http://slack.linkerd.io
[twitter]: https://twitter.com/linkerd
