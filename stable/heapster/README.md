# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Retired

Heapster work has been stopped. All efforts have been moved to metrics-server.
Metrics server helm chart is located at: https://github.com/helm/charts/tree/master/stable/metrics-server
More info on: https://github.com/kubernetes-retired/heapster

# Heapster

[Heapster](https://github.com/kubernetes/heapster) enables Container Cluster Monitoring and Performance Analysis. It collects and interprets various signals like compute resource usage, lifecycle events, etc, and exports cluster metrics via REST endpoints.
The Chart can also enable eventer, which can send the kubernetes event logs to a remote location.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## QuickStart

```bash
$ helm install stable/heapster
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/heapster
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The default configuration values for this chart are listed in `values.yaml`.

| Parameter                             | Description                                                  | Default                                           |
|---------------------------------------|-------------------------------------                         |---------------------------------------------------|
| `image.repository`                    | Repository for container image                               | k8s.gcr.io/heapster-amd64                               |
| `image.tag`                           | Container image tag                                          | v1.5.4                                            |
| `image.pullPolicy`                    | Image pull policy                                            | IfNotPresent                                      |
| `service.name`                        | Service port name                                            | api                                               |
| `service.type`                        | Type for the service                                         | ClusterIP                                         |
| `service.externalPort`                | Service external port                                        | 8082                                              |
| `service.internalPort`                | Service internal port                                        | 8082                                              |
| `service.annotations`                 | Service annotations, specified as a map                      | `{}`                                              |
| `resources.limits`                    | Server resource  limits                                      | limits: {cpu: 100m, memory: 128Mi}                |
| `resources.requests`                  | Server resource requests                                     | requests: {cpu: 100m, memory: 128Mi}              |
| `command`                             | Commands for heapster pod                                    | "/heapster --source=kubernetes.summary_api:''     |
| `rbac.create`                         | Bind system:heapster role                                    | true                                             |
| `rbac.serviceAccountName`             | existing ServiceAccount to use (ignored if rbac.create=true) | default                                           |
| `resizer.enabled`                     | If enabled, scale resources                                  | true                                              |
| `eventer.enabled`                     | If enabled, start eventer                                    | false                                             |
| `podAnnotations`                      | Pod Annotations to be added to the heapster Pod              | `{}`                                              |
| `nodeSelector`                        | Node labels for pod assignment                               | `{}`                                              |
| `tolerations`                         | Tolerations for pod assignment                               | `[]`                                              |
| `affinity`                            | Affinity for pod assignment                                  | `{}`                                              |

The table below is only applicable if `resizer.enabled` is `true`. More information on resizer can be found [here](https://github.com/kubernetes/contrib/blob/master/addon-resizer/README.md).

| Parameter                             | Description                         | Default                                           |
|---------------------------------------|-------------------------------------|---------------------------------------------------|
| `resizer.image.repository`            | Repository for container image      | k8s.gcr.io/addon-resizer            |
| `resizer.image.tag`                   | Container image tag                 | 1.7                                               |
| `resizer.image.pullPolicy`            | Image pull policy                   | IfNotPresent                                      |
| `resizer.resources.limits`            | Server resource  limits             | limits: {cpu: 50m, memory: 90Mi}                |
| `resizer.resources.requests`          | Server resource requests            | requests: {cpu: 50m, memory: 90Mi}                |
| `resizer.flags`                       | Flags for pod nanny command         | Defaults set in values.yaml                       |

The table below is only applicable if `eventer.enabled` is `true`. More information on eventer can be found
[here]https://github.com/kubernetes/heapster/blob/master/docs/overview.md

| Parameter                             | Description                              | Default                                           |
|---------------------------------------|------------------------------------------|---------------------------------------------------|
| `eventer.flags`                       | Flags for eventer command                | Defaults set in values.yaml                       |
| `eventer.resources.limits`            | Server resource  limits                  | requests: {}                                      |
| `eventer.resources.requests`          | Server resource requests                 | requests: {}                                      |
| `eventer.resizer.enabled`             | If enabled, scale resources              | true                                              |
| `eventer.resizer.flags`               | Flags for pod nanny command for eventer  | Defaults set in values.yaml                       |
| `eventer.resizer.resources.limits`    | Server resource limits                   | requests: {}                                      |
| `eventer.resizer.resources.requests`  | Server resource requests                 | requests: {}                                      |
