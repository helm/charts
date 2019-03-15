# Loki Helm Chart

* Installs the [Loki](https://grafana.com/loki)

## TL;DR;

```console
$ helm install stable/loki
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/loki
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.


## Configuration

Loki has server named "loki" and client named "promtail".

### Basic
| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `rbac.create`                             | Create RBAC or not                            | `true`                                                  |
| `rbac.pspEnabled`                         | Enable podsecuritypolicy or not               | `true`                                                  |
| `serviceAccount.create`                   | Create service account or not                 | `true                                                   |
| `serviceAccount.name`                     | Custom service account name                   | ``                                                      |

### Loki

| `loki.replicas`                                           | Number of nodes                   | `1`                                                 |
| `loki.deploymentStrategy`                                 | Deployment strategy         | `RollingUpdate`                                           |
| `loki.image.repository`                                   | Image repository                              | `grafana/loki`                          |
| `loki.image.tag`                                          | Image tag           | `master`                                                          |
| `loki.image.pullPolicy`                                   | Image pull policy                             | `Always`                                |
| `loki.service.port`                                       | Kubernetes port where service is exposed      | `3100`                                  |
| `loki.service.annotations`                                | Service annotations                           | `{}`                                    |
| `loki.service.labels`                                     | Custom labels                                 | `{}`                                    |
| `loki.readinessProbe`                                     | Rediness Probe settings                       | `{}`                                    |
| `loki.livenessProbe`                                      | Liveness Probe settings                       | `{}`                                    |
| `loki.resources`                                          | CPU/Memory resource requests/limits           | `{}`                                    |
| `loki.nodeSelector`                                       | Node labels for pod assignment                | `{}`                                    |
| `loki.tolerations`                                        | Toleration labels for pod assignment          | `{}`                                    |
| `loki.affinity`                                           | Affinity settings for pod assignment          | `[]`                                    |
| `loki.persistence.enabled`                                | Use persistent volume to store data           | `false`                                 |
| `loki.persistence.accessModes`                            | Persistence access modes                      | `[ReadWriteOnce]`                       |
| `loki.persistence.storageClassName`                       | Type of persistent volume claim               | `default`                               |
| `loki.config.auth_enabled`                                | Enable authorization                          | `false`                                 |
| `loki.config.ingester.lifecycler.ring.store`              | The store way of lifecycler                   | `inmemory`                              |
| `loki.config.ingester.lifecycler.ring.replication_factor` | The number of lifecycler ring                 | `1`                                     |
| `loki.schema_configs`                                     | Loki scheam config                            | `[{"from":0,"store":"boltdb","object_store":"filesystem","schema":"v9","index":{"prefix":"index_","period":"168h"}}]` |
| `loki.storage_configs`                                    | Loki storage config                           | `[{"name":"boltdb","directory":"/data/loki/index"},{"name":"filesystem","directory":"/data/loki/chunks"}]` |

### Promtail

| `promtail.nameOverride`                                   | Promtail name                                 | `promtail`                              |
| `deploymentStrategy`                                      | Deployment strategy                           | `RollingUpdate`                         |
| `entryParser`                                             | Entry parser                                  | `docker`                                |
| `dataRoot`                                                | Docker data root                              | `/var/lib/docker`                       |
| `promtail.image.repository`                               | Image repository                              | `grafana/promtail`                      |
| `promtail.image.tag`                                      | Image tag                                     | `master`                                |
| `promtail.image.pullPolicy`                               | Image pull policy                             | `Always`                                |
| `promtail.service.port`                                   | Kubernetes port where service is exposed      | `3100`                                  |
| `promtail.service.annotations`                            | Service annotations                           | `{}`                                    |
| `promtail.service.labels`                                 | Custom labels                                 | `{}`                                    |
| `promtail.readinessProbe`                                 | Rediness Probe settings                       | `{}`                                    |
| `promtail.livenessProbe`                                  | Liveness Probe settings                       | `{}`                                    |
| `promtail.resources`                                      | CPU/Memory resource requests/limits           | `{}`                                    |
| `promtail.nodeSelector`                                   | Node labels for pod assignment                | `{}`                                    |
| `promtail.tolerations`                                    | Toleration labels for pod assignment          | `[{"key":"node-role.kubernetes.io/master","effect":"NoSchedule"}]` |
| `promtail.affinity`                                       | Affinity settings for pod assignment          | `[]`                                    |