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

The following tables lists the configurable parameters of the drone charts and their default values.

|              Parameter               |                    Description                     |                     Default                      |
| -----------------------------------  | -------------------------------------------------- | ------------------------------------------------ |
| `replicaCount`                       | Number of replicas                                 | `1`                                              |
| `nodeSelector`                       | Node selectors                                     | `{}`                                             |
| `livenessProbe.initialDelaySeconds`  | initialDelaySeconds of Pod livenessProbe           | `60`                                             |
| `livenessProbe.periodSeconds`        | periodSeconds of Pod livenessProbe                 | `20`                                             |
| `readinessProbe.initialDelaySeconds` | initialDelaySeconds of Pod readinessProbe          | `60`                                             |
| `nodeSelector`                       | Node selectors                                     | `{}`                                             |
| `image.repository`                   | Container image name                               | `docker.elastic.co/logstash/logstash-oss`        |
| `image.tag`                          | Container image tag                                | `6.2.1`                                          |
| `image.pullPolicy`                   | Container image pull policy                        | `IfNotPresent`                                   |
| `service.type`                       | Service type (ClusterIP, NodePort or LoadBalancer) | `ClusterIP`                                      |
| `service.internalPort`               | Logstash internal port                             | `1514`                                           |
| `service.ports`                      | Service open ports                                 | `[TCP/1514, UDP/1514, TCP/5044]`                 |
| `ingress.enabled`                    | Enables Ingress                                    | `false`                                          |
| `ingress.annotations`                | Ingress annotations                                | `{}`                                             |
| `ingress.hosts`                      | Ingress accepted hostnames                         | `[]`                                             |
| `ingress.tls`                        | Ingress TLS configuration                          | `nil`                                            |
| `resources`                          | Pod resource requests & limits                     | `{}`                                             |
| `elasticsearch.host`                 | ElasticSearch hostname                             | `elasticsearch-client.default.svc.cluster.local` |
| `elasticsearch.port`                 | ElasticSearch port                                 | `9200`                                           |
| `configData`                         | Extra logstash config                              | `{}`                                             |
| `patterns`                           | Logstash patterns configuration                    | `nil`                                            |
| `inputs`                             | Logstash inputs configuration                      | `(basic)`                                        |
| `filters`                            | Logstash filters configuration                     | `nil`                                            |
| `outputs`                            | Logstash outputs configuration                     | `(basic)`                                        |
