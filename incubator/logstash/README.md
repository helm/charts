# Logstash

[Logstash](https://www.elastic.co/products/logstash) is an open source, server-side data processing pipeline that ingests data from a multitude of sources simultaneously, transforms it, and then sends it to your favorite “stash.”

## TL;DR;

```console
$ helm install incubator/logstash
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release incubator/logstash
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes nearly all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the chart and its default values.

|              Parameter           |                    Description                     |                     Default                      |
| -------------------------------- | -------------------------------------------------- | ------------------------------------------------ |
| `replicaCount`                   | Number of replicas                                 | `1`                                              |
| `podDisruptionBudget`            | Pod disruption budget                              | `maxUnavailable: 1`                              |
| `updateStrategy`                 | Update strategy                                    | `type: RollingUpdate`                            |
| `image.repository`               | Container image name                               | `docker.elastic.co/logstash/logstash-oss`        |
| `image.tag`                      | Container image tag                                | `6.2.2`                                          |
| `image.pullPolicy`               | Container image pull policy                        | `IfNotPresent`                                   |
| `serviceAwsLoadBalancerInternal.enabled      | Enables `aws-load-balancer-internal`   | `false`                                          |
| `serviceAwsLoadBalancerInternal.annotations  | Extra annotations for the internal ELB | `false`                                          |
| `serviceAwsLoadBalancerInternal.exposedPorts | TCP port names exposed by internal ELB | `["beats"]`                                      |
| `service.type`                   | Service type (ClusterIP, NodePort or LoadBalancer) | `ClusterIP`                                      |
| `service.ports`                  | Ports exposed by service                           | `["beats", "http"]`                              |
| `ports`                          | Input ports exposed by logstash container          | beats, http                                      |
| `ingress.enabled`                | Enables Ingress                                    | `false`                                          |
| `ingress.annotations`            | Ingress annotations                                | `{}`                                             |
| `ingress.path`                   | Ingress path                                       | `/`                                              |
| `ingress.hosts`                  | Ingress accepted hostnames                         | `["logstash.cluster.local"]`                     |
| `ingress.tls`                    | Ingress TLS configuration                          | `[]`                                             |
| `resources`                      | Pod resource requests & limits                     | `{}`                                             |
| `nodeSelector`                   | Node selector                                      | `{}`                                             |
| `tolerations`                    | Tolerations                                        | `[]`                                             |
| `affinity`                       | Affinity or Anti-Affinity                          | `{}`                                             |
| `podAnnotations`                 | Pod annotations                                    | `{}`                                             |
| `podLabels`                      | Pod labels                                         | `{}`                                             |
| `livenessProbe`                  | Liveness probe settings for logstash container     | (see `values.yaml`)                              |
| `readinessProbe`                 | Readiness probe settings for logstash container    | (see `values.yaml`)                              |
| `persistentVolumes.storageClass` | storageClass for PVCs                              | `default`                                        |
| `persistentVolumes.size`         | Size for PVCs                                      | `2Gi`                                            |
| `volumeMounts`                   | Volume mounts to configure for logstash container  | (see `values.yaml`)                              |
| `exporter.logstash`              | Prometheus logstash-exporter settings              | (see `values.yaml`)                              |
| `exporter.logstash.enabled`      | Enables Prometheus logstash-exporter               | `false`                                          |
| `elasticsearch.host`             | ElasticSearch hostname                             | `elasticsearch-client.default.svc.cluster.local` |
| `elasticsearch.port`             | ElasticSearch port                                 | `9200`                                           |
| `config`                         | Logstash configuration key-values                  | (see `values.yaml`)                              |
| `patterns`                       | Logstash patterns configuration                    | `nil`                                            |
| `inputs`                         | Logstash inputs configuration                      | `(basic)`                                        |
| `filters`                        | Logstash filters configuration                     | `nil`                                            |
| `outputs`                        | Logstash outputs configuration                     | `(basic)`                                        |
