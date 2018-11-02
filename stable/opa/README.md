# OPA

[OPA](https://www.openpolicyagent.org) is an open source general-purpose policy
engine designed for cloud-native environments.

## Prerequisites

- Kubernetes 1.9 (or newer) for validating and mutating webhook admission
  controller support.

## Overview

This helm chart installs OPA as a [Kubernetes admission
controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/).
Using OPA, you can enforce fine-grained invariants over arbitrary resources in
your Kubernetes cluster.

## Kick the tires

If you just want to see something run, install the chart without any
configuration.

```bash
helm install .
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
