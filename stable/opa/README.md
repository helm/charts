# OPA

[OPA](https://www.openpolicyagent.org) is an open source general-purpose policy
engine designed for cloud-native environments.

## Prerequisites

- Kubernetes 1.9 (or newer) for validating and mutating webhook admission
  controller support.
- Optional, cert-manager (https://docs.cert-manager.io/en/latest/)

## Overview

This helm chart installs OPA as a [Kubernetes admission
controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/).
Using OPA, you can enforce fine-grained invariants over arbitrary resources in
your Kubernetes cluster.

## Kick the tires

If you just want to see something run, install the chart without any
configuration.

```bash
helm install stable/opa
```

Once installed, the OPA will download a sample bundle from
https://www.openpolicyagent.org. The sample bundle contains a simple policy that
restricts the hostnames that can be specified on Ingress objects created in the
`opa-example` namespace. You can download the bundle and inspect it yourself:

```bash
mkdir example && cd example
curl -s -L https://www.openpolicyagent.org/bundles/kubernetes/admission | tar xzv
```

See the [NOTES.txt](./templates/NOTES.txt) file for examples of how to exercise
the admission controller.

## Configuration

All configuration settings are contained and described in
[values.yaml](values.yaml).

You should set the URL and credentials for the OPA to use to download policies.
The URL should identify an HTTP endpoint that implements the [OPA Bundle
API](https://www.openpolicyagent.org/docs/bundles.html).

- `opa.services.controller.url` specifies the base URL of the OPA control plane.

- `opa.services.controller.credentials.bearer.token` specifies a bearer token
  for the OPA to use to authenticate with the control plane.

For more information on OPA-specific configuration see the [OPA Configuration
Reference](https://www.openpolicyagent.org/docs/configuration.html).

| Parameter | Description | Default |
| --- | --- | --- |
| `certManager.enabled` | Setup the Webhook using cert-manager | `false` |
| `admissionControllerKind` | Type of admission controller to install. | `ValidatingWebhookConfiguration` |
| `admissionControllerFailurePolicy` | Fail-open (`Ignore`) or fail-closed (`Fail`)? | `Ignore` |
| `admissionControllerRules` | Types of operations resources to check. | `*` |
| `admissionControllerNamespaceSelector` | Namespace selector for the admission controller | See [values.yaml](values.yaml) |
| `generateAdmissionControllerCerts` | Auto-generate TLS certificates for admission controller. | `true` |
| `admissionControllerCA` | Manually set admission controller certificate CA. | Unset |
| `admissionControllerCert` | Manually set admission controller certificate. | Unset |
| `admissionControllerKey` | Manually set admission controller key. | Unset |
| `podDisruptionBudget.enabled` | Enables creation of a PodDisruptionBudget for OPA. | `false` |
| `podDisruptionBudget.minAvailable` | Sets the minimum number of pods to be available. Cannot be set at the same time as maxUnavailable. | `1` |
| `podDisruptionBudget.maxUnavailable` | Sets the maximum number of pods to be unavailable. Cannot be set at the same time as minAvailable. | Unset |
| `image` | OPA image to deploy. | `openpolicyagent/opa` |
| `imageTag` | OPA image tag to deploy. | See [values.yaml](values.yaml) |
| `port` | Port in the pod to which OPA will bind itself. | `443` |
| `logLevel` | Log level that OPA outputs at, (`debug`, `info` or `error`) | `info` |
| `logFormat` | Log format that OPA produces (`text` or `json`) | `text` |
| `replicas` | Number of admission controller replicas to deploy. | `1` |
| `tolerations` | List of node taint tolerations. | `[]` |
| `nodeSelector` | Node labels for pod assignment. | `{}` |
| `resources` | CPU and memory limits for OPA container. | `{}` |
| `readinessProbe` | HTTP readiness probe for OPA container. | See [values.yaml](values.yaml) |
| `livenessProbe` | HTTP liveness probe for OPA container. | See [values.yaml](values.yaml) |
| `opa` | OPA configuration. | See [values.yaml](values.yaml) |
| `mgmt.resources` | CPU and memory limits for the kube-mgmt container. | `{}` |
| `sar.resources` | CPU and memory limits for the sar container. | `{}` |
| `priorityClassName` | The name of the priorityClass for the pods. | Unset |
