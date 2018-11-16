# open-policy-agent

[open-policy-agent](https://www.openpolicyagent.org/) provides policy-based control for cloud native environments.

## TL;DR;

```console
helm install stable/open-policy-agent
```

## Introduction

This chart installs the Open Policy Agent, optionally deploying the `kube-mgmt` sidecar using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install --name my-release stable/open-policy-agent
```

The command deploys open-policy-agent on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the open-policy-agent chart and their default values.

Parameter | Description | Default
--- | --- | ---
`affinity` | node/pod affinities (requires Kubernetes >=1.6) | `{}`
`fullnameOverride` | override of the default full name | `""`
`kubeMgmt.enabled` | Should we deploy the `kube-mgmt` sidecar | `true`
`kubeMgmt.image.pullPolicy` | kube-mgmt container image pull policy | `IfNotPresent`
`kubeMgmt.image.repository` | kube-mgmt container image repository | `openpolicyagent/kube-mgmt`
`kubeMgmt.image.tag` | kube-mgmt container image tag | `0.6`
`kubeMgmt.replicate` | This is a list, which maps to the `--replicate` kube-mgmt cli option | `""`
`kubeMgmt.replicateCluster` | This is a list, which maps to the `--replicate-cluster` kube-mgmt cli option | `""`
`kubeMgmt.replicatePath` | This is a list, which maps to the `--replicate-path` kube-mgmt cli option | `""`
`kubeMgmt.resources` | kube-mgmt pod resource requests & limits | `{}`
`nameOverride` | override of the default name | `""`
`nodeSelector` | node labels for pod assignment | `{}`
`opa.defaultConfig` | Any default config you wish to pass to the agent. | `""`
`opa.deployWebhook` | Should we deploy the `ValidatingWebhookConfiguration` resource | `true`
`opa.image.pullPolicy` | agent container image pull policy | `IfNotPresent`
`opa.image.repository` | agent container image repository | `openpolicyagent/opa`
`opa.image.tag` | agent container image tag | `0.9.1`
`opa.insecureEnabled` | If using https, should we also enable http listener | `true`
`opa.logFormat` | Format the agent logs in. Can be either `text` or `json` | `text`
`opa.logLevel` | Level the agent logs at. Can be `info`, `warn` or `debug` | `info`
`opa.resources` | agent pod resource requests & limits | `{}`
`rbac.create` | if `true`, create & use RBAC resources | `true`
`replicaCount` | desired number of controller pods | `1`
`service.annotations` | annotations to be added to pods | `{}`
`service.port` | Outward facing http port | `80`
`service.targetPort` | Container http port | `8181`
`service.tlsPort` | Outward facing https port | `443`
`service.tlsTargetPort` | Container https port | `8443`
`service.type` | type of default service to create | `ClusterIP`
`serviceAccount.create` | if `true`, create a service account | `""`
`serviceAccount.name` | The name of the service account to use. If not set and `create` is `true`, a name is generated using the fullname template. | `""`
`tls.ca` | The CA Bundle used to make the `tlsCert` and `tlsKey`. Will be generated if needed and not provided. | `""`
`tls.caDays` | If generating certs, how many days until the CA expires. | `29691`
`tls.cert` | The TLS cert, if you wish to enable https (plain text, the chart base64 encodes) | `""`
`tls.certDays` | If generating certs, how many days until the cert expires. | `3650`
`tls.key` | The TLS key, if you wish to enable https (plain text, the chart base64 encodes) | `""`
`tolerations` | node taints to tolerate (requires Kubernetes >=1.6) | `[]`

```console
helm install stable/open-policy-agent --name my-release \
    --set kubeMgmt.enabled=false
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
helm install stable/open-policy-agent --name my-release -f values.yaml
```

## Use as a Webhook Admission Controller

One use of the Open Policy Agent, is as a custom admission controller inside Kubernetes. To do this, you *must* deploy opa with a SSL key and cert. This chart will generate a CA, key and cert when deployed if you do not provide values.

By default the webhook required to validate admission requests against OPA is not deployed. You can enable this by setting `opa.deployWebHook` to `true`. An example resource is shown below.

```yaml
---
kind: ValidatingWebhookConfiguration
apiVersion: admissionregistration.k8s.io/v1beta1
metadata:
  name: opa-validating-webhook
webhooks:
  - name: validating-webhook.openpolicyagent.org
    rules:
      - operations: ["CREATE", "UPDATE", "DELETE"]
        apiGroups: ["*"]
        apiVersions: ["*"]
        resources: ["*"]
    clientConfig:
      caBundle: REPLACE_WITH_BASE65_ENCODED_CA_CERT
      service:
        namespace: REPLACE_WITH_HELM_DEPLOYMENT_NAME-open-policy-agent
        name: REPLACE_WITH_HELM_DEPLOYMENT_NAMESPACE
```

The service name the chart deploys is named `{$Release.Name}-open-policy-agent` - please ensure you preserve `-open-policy-agent` on the end of the string.

If you wish to make your certs outside of helm, some helper scripts are provided inside the `scripts/` directory to generate the certs, a valid yaml for passing to this chart and a `ValidatingWebhookConfiguration` resource yaml file. Have a look at the [README](scripts/README.md) inside that directory.