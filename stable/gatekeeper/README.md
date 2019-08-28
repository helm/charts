# Gatekeeper

[Gatekeeper](https://github.com/open-policy-agent/gatekeeper/), the Policy Controller for
Kubernetes.

## Prerequisites

- Kubernetes 1.15 (or newer) for validating and mutating webhook admission
  controller support.

## Overview

This helm chart installs Gatekeeper as a [Kubernetes admission
controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/).
Gatekeeper is a validating (mutating TBA) webhook that enforces CRD-based policies executed by [Open
Policy Agent](https://github.com/open-policy-agent/opa), a policy engine for Cloud Native
environments hosted by [CNCF](https://www.cncf.io) as an incubation-level project.

## Kick the tires

If you just want to see something run, install the chart without any
configuration.

```bash
helm install stable/gatekeeper
```

You can then follow the instructions
[here](https://github.com/open-policy-agent/gatekeeper/#how-to-use-gatekeeper) to learn how to use
Gatekeeper.

## Configuration

All configuration settings are contained and described in
[values.yaml](values.yaml).

| Parameter                                             | Description                                                                  | Default             |
| ----------------------------------------------------- | ---------------------------------------------------------------------------- | ------------------- |
| port                                                  | Port for gateekeper pod to listen on                                         | 8443                |
| securityContext.runAsUser                             | Run as user for gatekeeper pod                                               |                     |
| securityContext.fsGroup                               | FS group for gatekeeper pod                                                  |                     |
| service.annotations                                   | Service annotations                                                          |                     |
| service.type                                          | Service type                                                                 | "ClusterIP"         |
| service.port                                          | Service port                                                                 | 443                 |
| rbac.create                                           | Create RBAC resources                                                        | true                |
| serviceAccount.create                                 | Create service account                                                       | true                |
| serviceAccount.name                                   | Service account name (if not specified, will be generated from release name) |                     |
| priorityClassName                                     | Pod priority class name                                                      |                     |
| resources                                             | Pod resources                                                                |                     |
| admissionControllerFailurePolicy                      | Admission controller failure policy                                          | "Ignore"            |
| admissionControllerNamespaceSelector.matchExpressions | Admission controller namespace selector expressions                          | []                  |
| admissionControllerObjectSelector.matchExpressions    | Admission controller object selector expressions                             | []                  |
| admissionControllerObjectSelector.matchLabels         | Admission controller object label selector                                   | []                  |
| webhook.apiGroups                                     | Webhook rules API groups                                                     | [""]                |
| webhook.apiVersions                                   | Webhook rules API versions                                                   | ["*"]               |
| webhook.operations                                    | Webhook rules operations                                                     | ["CREATE","UPDATE"] |
| webhook.resources                                     | Webhook rules resources                                                      | ["pods"]            |
| webhook.scope                                         | Webhook rules scope                                                          | "Namespaced"        |
