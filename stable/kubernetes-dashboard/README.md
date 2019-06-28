# kubernetes-dashboard

[Kubernetes Dashboard](https://github.com/kubernetes/dashboard) is a general purpose, web-based UI for Kubernetes clusters. It allows users to manage applications running in the cluster and troubleshoot them, as well as manage the cluster itself.

## TL;DR

```console
helm install stable/kubernetes-dashboard
```

## Introduction

This chart bootstraps a [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install stable/kubernetes-dashboard --name my-release
```

The command deploys kubernetes-dashboard on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Access control

It is critical for the Kubernetes cluster to correctly setup access control of Kubernetes Dashboard. See this [guide](https://github.com/kubernetes/dashboard/wiki/Access-control) for best practises.

It is highly recommended to use RBAC with minimal privileges needed for Dashboard to run.

## Configuration

The following table lists the configurable parameters of the kubernetes-dashboard chart and their default values.

| Parameter                           | Description                                                                                                                 | Default                                                                    |
|-------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------|
| `image.repository`                  | Repository for container image                                                                                              | `k8s.gcr.io/kubernetes-dashboard-amd64`                                    |
| `image.tag`                         | Image tag                                                                                                                   | `v1.10.1`                                                                  |
| `image.pullPolicy`                  | Image pull policy                                                                                                           | `IfNotPresent`                                                             |
| `image.pullSecrets`                 | Image pull secrets                                                                                                          | `[]`                                                                       |
| `annotations`                       | Annotations for deployment                                                                                                  | `{}`                                                                       |
| `replicaCount`                      | Number of replicas                                                                                                          | `1`                                                                        |
| `extraArgs`                         | Additional container arguments                                                                                              | `[]`                                                                       |
| `extraEnv`                          | Additional container environment variables                                                                                  | `[]`                                                                       |
| `podAnnotations`                    | Annotations to be added to pods                                                                                             | {}                                                                         |
| `nodeSelector`                      | node labels for pod assignment                                                                                              | `{}`                                                                       |
| `tolerations`                       | List of node taints to tolerate (requires Kubernetes >= 1.6)                                                                | `[]`                                                                       |
| `affinity`                          | Affinity for pod assignment                                                                                                 | `[]`                                                                       |
| `enableSkipLogin`                   | Enable possibility to skip login                                                                                            | `false`                                                                    |
| `enableInsecureLogin`               | Serve application over HTTP without TLS                                                                                     | `false`                                                                    |
| `service.externalPort`              | Dashboard external port                                                                                                     | 443                                                                        |
| `service.internalPort`              | Dashboard internal port                                                                                                     | 443                                                                        |
| `service.loadBalancerSourceRanges`  | list of IP CIDRs allowed access to load balancer (if supported)                                                             | nil                                                                        |
| `ingress.labels`                    | Add custom labels                                                                                                           | `[]`                                                                       |
| `ingress.annotations`               | Specify ingress class                                                                                                       | `kubernetes.io/ingress.class: nginx`                                       |
| `ingress.enabled`                   | Enable ingress controller resource                                                                                          | `false`                                                                    |
| `ingress.paths`                     | Paths to match against incoming requests. Both `/` and `/*` are required to work on gce ingress.                            | `[/]`                                                                      |
| `ingress.hosts`                     | Dashboard Hostnames                                                                                                         | `nil`                                                                      |
| `ingress.tls`                       | Ingress TLS configuration                                                                                                   | `[]`                                                                       |
| `resources`                         | Pod resource requests & limits                                                                                              | `limits: {cpu: 100m, memory: 100Mi}, requests: {cpu: 100m, memory: 100Mi}` |
| `rbac.create`                       | Create & use RBAC resources                                                                                                 | `true`                                                                     |
| `rbac.clusterAdminRole`             | "cluster-admin" ClusterRole will be used for dashboard ServiceAccount ([NOT RECOMMENDED](#access-control))                  | `false`                                                                    |
| `rbac.clusterReadOnlyRole`          | If clusterAdminRole disabled, an additional role will be created with read only permissions to all resources listed inside. | `false`                                                                    |
| `serviceAccount.create`             | Whether a new service account name that the agent will use should be created.                                               | `true`                                                                     |
| `serviceAccount.name`               | Service account to be used. If not set and serviceAccount.create is `true` a name is generated using the fullname template. |                                                                            |
| `livenessProbe.initialDelaySeconds` | Number of seconds to wait before sending first probe                                                                        | 30                                                                         |
| `livenessProbe.timeoutSeconds`      | Number of seconds to wait for probe response                                                                                | 30                                                                         |
| `podDisruptionBudget.enabled`       | Create a PodDisruptionBudget                                                                                                | `false`                                                                    |
| `podDisruptionBudget.minAvailable`  | Minimum available instances; ignored if there is no PodDisruptionBudget                                                     |                                                                            |
| `podDisruptionBudget.maxUnavailable`| Maximum unavailable instances; ignored if there is no PodDisruptionBudget                                                   |                                                                            |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install stable/kubernetes-dashboard --name my-release \
  --set=service.externalPort=8080,resources.limits.cpu=200m
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install stable/kubernetes-dashboard --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Using the dashboard with 'kubectl proxy'

When running 'kubectl proxy', the address `localhost:8001/ui` automatically expands to:

- `http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:https/proxy/` or
- `http://localhost:8001/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:http/proxy/` if `enableInsecureLogin=true`

For this to reach the dashboard, the name of the service must be 'kubernetes-dashboard', not any other value as set by Helm. You can manually specify this using the value 'fullnameOverride':

```
fullnameOverride: 'kubernetes-dashboard'
```

### Upgrade from 0.x.x to 1.x.x

Upgrade from 0.x.x version to 1.x.x version is seamless if you use default `ingress.path` value. If you have non-default `ingress.path` values with version 0.x.x, you need to add your custom path in `ingress.paths` list value as shown as examples in `values.yaml`.

Notes:

- The proxy url changed please refer to the [usage section](#using-the-dashboard-with-kubectl-proxy)
