# RBAC Manager
[RBAC Manager](https://reactiveops.github.io/rbac-manager/) was designed to simplify authorization in Kubernetes. This is an operator that supports declarative configuration for RBAC with new custom resources. Instead of managing role bindings or service accounts directly, you can specify a desired state and RBAC Manager will make the necessary changes to achieve that state.

This project has three main goals:

1. Provide a declarative approach to RBAC that is more approachable and scalable.
2. Reduce the amount of configuration required for great auth.
3. Enable automation of RBAC configuration updates with CI/CD.

More information about RBAC Manager is available on [GitHub](https://github.com/reactiveops/rbac-manager) as well as from the [official documentation](https://reactiveops.github.io/rbac-manager/).

## Installation
We recommend installing rbac-manager in its own namespace and a simple release name:

```
helm install stable/rbac-manager --name rbac-manager --namespace rbac-manager
```

## Prerequisites
Kubernetes 1.8+, Helm 2.10+

## Configuration
Parameter | Description | Default
--- | --- | ---
`image.repository` | Docker image repo  | `quay.io/reactiveops/rbac-manager`
`image.tag` | Docker image tag  | `0.4.3`
`image.pullPolicy` | Docker image pull policy  | `Always`
`resources.requests.cpu` | CPU resource request | `100m`
`resources.requests.memory` | Memory resource request | `128Mi`
`resources.limits.cpu` | CPU resource limit | `100m`
`resources.limits.memory` | Memory resource limit | `128Mi`
`nodeSelector` | Deployment nodeSelector | `{}`
`tolerations` | Deployment tolerations | `[]`
`affinity` | Deployment affinity | `{}`
`rbacDefinitions` | List of [RBAC Definitions](https://reactiveops.github.io/rbac-manager/rbacdefinitions.html) to apply | `[]`
