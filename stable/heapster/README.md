# Heapster

[Heapster](https://github.com/kubernetes/heapster) enables Container Cluster Monitoring and Performance Analysis. It collects and interprets various signals like compute resource usage, lifecycle events, etc, and exports cluster metrics via REST endpoints.
The Chart can also enable eventer, which can send the kubernetes event logs to a remote location.

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
| `image.repository`                    | Repository for container image                               | gcr.io/google_containers/heapster                 |
| `image.tag`                           | Container image tag                                          | v1.3.0                                            |
| `image.pullPolicy`                    | Image pull policy                                            | IfNotPresent                                      |
| `service.name`                        | Service port name                                            | api                                               |
| `service.type`                        | Type for the service                                         | ClusterIP                                         |
| `service.externalPort`                | Service external port                                        | 8082                                              |
| `service.internalPort`                | Service internal port                                        | 8082                                              |
| `resources.limits`                    | Server resource  limits                                      | limits: {cpu: 100m, memory: 128Mi}              |
| `resources.requests`                  | Server resource requests                                     | requests: {cpu: 100m, memory: 128Mi}              |
| `command`                             | Commands for heapster pod                                    | "/heapster --source=kubernetes.summary_api:''     |
| `rbac.create`                         | Bind system:heapster role                                    | false                                             |
| `rbac.serviceAccountName`             | existing ServiceAccount to use (ignored if rbac.create=true) | default                                           |
| `resizer.enabled`                     | If enabled, scale resources                                  | true                                              |
| `eventer.enabled`                     | If enabled, start eventer                                    | false                                             |
| `nodeSelector`                        | Node labels for pod assignment                               | `{}`                                              |

The table below is only applicable if `resizer.enabled` is `true`. More information on resizer can be found [here](https://github.com/kubernetes/contrib/blob/master/addon-resizer/README.md).

| Parameter                             | Description                         | Default                                           |
|---------------------------------------|-------------------------------------|---------------------------------------------------|
| `resizer.image.repository`            | Repository for container image      | gcr.io/google_containers/addon-resizer            |
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
