# Apache Druid

[Apache Druid (incubating)](http://druid.io/) is a high performance analytics data store for event-driven data.


## Install Chart

To install the Druid Chart into your Kubernetes cluster :

```bash
helm install --namespace "druid" --name "druid" incubator/druid
```

After installation succeeds, you can get a status of Chart

```bash
helm status "druid"
```

If you want to delete your Chart, use this command:

```bash
helm delete  --purge "druid"
```

### Helm ingresses

The Chart provides ingress configuration to allow customization the installation by adapting
the `values.yaml` depending on your setup.
Please read the comments in the `values.yaml` file for more details on how to configure your reverse
proxy or load balancer.

### Chart Prefix

This Helm automatically prefixes all names using the release name to avoid collisions.

### URL prefix

This chart exposes 5 endpoints:

- Druid Overlord
- Druid Broker
- Druid Coordinator
- Druid Historical
- Druid Middle Manager


### Druid configuration

Druid configuration can be changed by using environment variables from Docker image.

See the
[Druid Docker entry point](https://github.com/maver1ck/druid-docker/blob/master/start-druid.sh)
for more informations

### Middle Manager and Historical Statefulset

Middle Managers and Historicals uses StatefulSet. Persistence is enabled by default.


## Helm chart Configuration

The following table lists the configurable parameters of the Druid chart and their default values.

| Parameter                                | Description                                             | Default                   |
|------------------------------------------|---------------------------------------------------------|---------------------------|
| `image.repository`                       | Container image name                                    | `maver1ckpl/druid-docker` |
| `image.tag`                              | Container image tag                                     | `0.12.3-1`                |
| `image.pullPolicy`                       | Container pull policy                                   | `IfNotPresent`            |
| `env`                                    | Custom env variables for all components                 | ``                        |
| `historical.name`                        | historical component name                               | `historical`              |
| `historical.replicaCount`                | historical node replicas (deployment)                   | `1`                       |
| `historical.port`                        | port of historical component                            | `8083`                    |
| `historical.serviceType`                 | service type for service                                | `ClusterIP`               |
| `historical.resources`                   | historical node resources requests & limits             | `{}`                      |
| `historical.podAnnotations`              | historical Deployment annotations                       | `{}`                      |
| `historical.nodeSelector`                | Node labels for historical pod assignment               | `{}`                      |
| `historical.tolerations`                 | historical tolerations                                  | `[]`                      |
| `historical.javaOpts`                    | historical node java options                            | `-Xms2G -Xmx2G -XX:MaxDirectMemorySize=8g` |
| `historical.persistence.enabled`         | historical persistent enabled/disabled                  | `true`                    |
| `historical.persistence.size`            | historical persistent volume size                       | `4Gi`                     |
| `historical.persistence.storageClass`    | historical persistent volume Class                      | `nil`                     |
| `historical.persistence.accessMode`      | historical persistent Access Mode                       | `ReadWriteOnce`           |
| `historical.antiAffinity`                | historical anti-affinity policy                         | `soft`                    |
| `historical.nodeAffinity`                | historical node affinity policy                         | `{}`                      |
| `historical.ingress.enabled`             | enable ingress                                          | `false`                   |
| `historical.ingress.hosts`               | hosts for the historical api                            | `[ "chart-example.local" ]` |
| `historical.ingress.path`                | path of the historical api                              | `/`                       |
| `historical.ingress.annotations`         | annotations for the historical api ingress              | `{}`                      |
| `historical.ingress.tls`                 | TLS configuration for the ingress                       | `[]`                      |
| `middleManager.name`                        | middleManager component name                               | `middleManager`           |
| `middleManager.replicaCount`                | middleManager node replicas (deployment)                   | `1`                       |
| `middleManager.port`                        | port of middleManager component                            | `8091`                    |
| `middleManager.serviceType`                 | service type for service                                   | `ClusterIP`               |
| `middleManager.resources`                   | middleManager node resources requests & limits             | `{}`                      |
| `middleManager.podAnnotations`              | middleManager Deployment annotations                       | `{}`                      |
| `middleManager.nodeSelector`                | Node labels for middleManager pod assignment               | `{}`                      |
| `middleManager.tolerations`                 | middleManager tolerations                                  | `[]`                      |
| `middleManager.javaOpts`                    | middleManager node java options                            | `-Xms1G -Xmx1G"`          |
| `middleManager.persistence.enabled`         | middleManager persistent enabled/disabled                  | `true`                    |
| `middleManager.persistence.size`            | middleManager persistent volume size                       | `4Gi`                     |
| `middleManager.persistence.storageClass`    | middleManager persistent volume Class                      | `nil`                     |
| `middleManager.persistence.accessMode`      | middleManager persistent Access Mode                       | `ReadWriteOnce`           |
| `middleManager.antiAffinity`                | middleManager anti-affinity policy                         | `soft`                    |
| `middleManager.nodeAffinity`                | middleManager node affinity policy                         | `{}`                      |
| `middleManager.ingress.enabled`             | enable ingress                                             | `false`                   |
| `middleManager.ingress.hosts`               | hosts for the middleManager api                            | `[ "chart-example.local" ]` |
| `middleManager.ingress.path`                | path of the middleManager api                              | `/`                       |
| `middleManager.ingress.annotations`         | annotations for the middleManager api ingress              | `{}`                      |
| `middleManager.ingress.tls`                 | TLS configuration for the ingress                          | `[]`                      |
| `broker.name`                        | broker component name                               | `broker`           |
| `broker.replicaCount`                | broker node replicas (deployment)                   | `1`                      |
| `broker.port`                        | port of broker component                            | `8082`                    |
| `broker.serviceType`                 | service type for service                            | `ClusterIP`               |
| `broker.resources`                   | broker node resources requests & limits             | `{}`                      |
| `broker.podAnnotations`              | broker Deployment annotations                       | `{}`                      |
| `broker.nodeSelector`                | Node labels for broker pod assignment               | `{}`                      |
| `broker.tolerations`                 | broker tolerations                                  | `[]`                      |
| `broker.javaOpts`                    | broker node java options                            | `-Xms2G -Xmx2G -XX:MaxDirectMemorySize=8g`          |
| `broker.nodeAffinity`                | broker node affinity policy                         | `{}`                      |
| `broker.ingress.enabled`             | enable ingress                                             | `false`                   |
| `broker.ingress.hosts`               | hosts for the broker api                            | `[ "chart-example.local" ]` |
| `broker.ingress.path`                | path of the broker api                              | `/`                       |
| `broker.ingress.annotations`         | annotations for the broker api ingress              | `{}`                      |
| `broker.ingress.tls`                 | TLS configuration for the ingress                          | `[]`                      |
| `overlord.name`                        | overlord component name                               | `overlord`           |
| `overlord.replicaCount`                | overlord node replicas (deployment)                   | `1`                      |
| `overlord.port`                        | port of overlord component                            | `8090`                    |
| `overlord.serviceType`                 | service type for service                            | `ClusterIP`               |
| `overlord.resources`                   | overlord node resources requests & limits             | `{}`                      |
| `overlord.podAnnotations`              | overlord Deployment annotations                       | `{}`                      |
| `overlord.nodeSelector`                | Node labels for overlord pod assignment               | `{}`                      |
| `overlord.tolerations`                 | overlord tolerations                                  | `[]`                      |
| `overlord.javaOpts`                    | overlord node java options                            | `--Xms1G -Xmx1G`          |
| `overlord.nodeAffinity`                | overlord node affinity policy                         | `{}`                      |
| `overlord.ingress.enabled`             | enable ingress                                             | `false`                   |
| `overlord.ingress.hosts`               | hosts for the overlord api                            | `[ "chart-example.local" ]` |
| `overlord.ingress.path`                | path of the overlord api                              | `/`                       |
| `overlord.ingress.annotations`         | annotations for the overlord api ingress              | `{}`                      |
| `overlord.ingress.tls`                 | TLS configuration for the ingress                          | `[]`                      |
| `coordinator.name`                        | coordinator component name                               | `coordinator`           |
| `coordinator.replicaCount`                | coordinator node replicas (deployment)                   | `1`                      |
| `coordinator.port`                        | port of coordinator component                            | `8081`                    |
| `coordinator.serviceType`                 | service type for service                            | `ClusterIP`               |
| `coordinator.resources`                   | coordinator node resources requests & limits             | `{}`                      |
| `coordinator.podAnnotations`              | coordinator Deployment annotations                       | `{}`                      |
| `coordinator.nodeSelector`                | Node labels for coordinator pod assignment               | `{}`                      |
| `coordinator.tolerations`                 | coordinator tolerations                                  | `[]`                      |
| `coordinator.javaOpts`                    | coordinator node java options                            | `--Xms1G -Xmx1G`          |
| `coordinator.nodeAffinity`                | coordinator node affinity policy                         | `{}`                      |
| `coordinator.ingress.enabled`             | enable ingress                                             | `false`                   |
| `coordinator.ingress.hosts`               | hosts for the coordinator api                            | `[ "chart-example.local" ]` |
| `coordinator.ingress.path`                | path of the coordinator api                              | `/`                       |
| `coordinator.ingress.annotations`         | annotations for the coordinator api ingress              | `{}`                      |
| `coordinator.ingress.tls`                 | TLS configuration for the ingress                          | `[]`                      |

Full and up-to-date documentation can be found in the comments of the `values.yaml` file.
