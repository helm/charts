# Hazelcast Jet

[Hazelcast Jet](http://jet.hazelcast.org) is a distributed computing
platform built for high-performance stream processing and fast batch
processing. It embeds Hazelcast In-Memory Data Grid (IMDG) to provide
a lightweight, simple-to-deploy package that includes scalable
in-memory storage.

Visit [jet.hazelcast.org](http://jet.hazelcast.org) to learn more
about the architecture and use cases.

## Quick Start

```bash
$ helm install stable/hazelcast-jet
```

## Introduction

This chart bootstraps a [Hazelcast Jet](https://github.com/hazelcast/hazelcast-jet-docker) deployments on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/hazelcast-jet
```

The command deploys Hazelcast Jet on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Hazelcast chart and their default values.

| Parameter                                  | Description                                                                                                    | Default                                              |
|--------------------------------------------|----------------------------------------------------------------------------------------------------------------|------------------------------------------------------|
| `image.repository`                         | Hazelcast Jet Image name                                                                                       | `hazelcast/hazelcast-jet`                            |
| `image.tag`                                | Hazelcast Jet Image tag                                                                                        | `{VERSION}`                                          |
| `image.pullPolicy`                         | Image pull policy                                                                                              | `IfNotPresent`                                       |
| `image.pullSecrets`                        | Specify docker-registry secret names as an array                                                               | `nil`                                                |
| `cluster.memberCount`                      | Number of Hazelcast Jet members                                                                                | 2                                                    |
| `jet.rest`                                 | Enable REST endpoints for Hazelcast Jet member                                                                 | `true`                                               |
| `jet.javaOpts`                             | Additional JAVA_OPTS properties for Hazelcast Jet member                                                       | `nil`                                                |
| `jet.configurationFiles`                   | Hazelcast configuration files                                                                                  | `{DEFAULT_HAZELCAST_XML}`                            |
| `nodeSelector`                             | Hazelcast Node labels for pod assignment                                                                       | `nil`                                                |
| `gracefulShutdown.enabled`                 | Turn on and off Graceful Shutdown                                                                              | `true`                                               |
| `gracefulShutdown.maxWaitSeconds`          | Maximum time to wait for the Hazelcast Jet POD to shut down                                                    | `600`                                                |
| `livenessProbe.enabled`                    | Turn on and off liveness probe                                                                                 | `true`                                               |
| `livenessProbe.initialDelaySeconds`        | Delay before liveness probe is initiated                                                                       | `30`                                                 |
| `livenessProbe.periodSeconds`              | How often to perform the probe                                                                                 | `10`                                                 |
| `livenessProbe.timeoutSeconds`             | When the probe times out                                                                                       | `5`                                                  |
| `livenessProbe.successThreshold`           | Minimum consecutive successes for the probe to be considered successful after having failed                    | `1`                                                  |
| `livenessProbe.failureThreshold`           | Minimum consecutive failures for the probe to be considered failed after having succeeded.                     | `3`                                                  |
| `readinessProbe.enabled`                   | Turn on and off readiness probe                                                                                | `true`                                               |
| `readinessProbe.initialDelaySeconds`       | Delay before readiness probe is initiated                                                                      | `30`                                                 |
| `readinessProbe.periodSeconds`             | How often to perform the probe                                                                                 | `10`                                                 |
| `readinessProbe.timeoutSeconds`            | When the probe times out                                                                                       | `1`                                                  |
| `readinessProbe.successThreshold`          | Minimum consecutive successes for the probe to be considered successful after having failed                    | `1`                                                  |
| `readinessProbe.failureThreshold`          | Minimum consecutive failures for the probe to be considered failed after having succeeded.                     | `3`                                                  |
| `resources`                                | CPU/Memory resource requests/limits                                                                            | `nil`                                                |
| `service.type`                             | Kubernetes service type ('ClusterIP', 'LoadBalancer', or 'NodePort')                                           | `ClusterIP`                                          |
| `service.port`                             | Kubernetes service port                                                                                        | `5701`                                               |
| `rbac.create`                              | Enable installing RBAC Role authorization                                                                      | `true`                                               |
| `serviceAccount.create`                    | Enable installing Service Account                                                                              | `true`                                               |
| `serviceAccount.name`                      | Name of Service Account, if not set, the name is generated using the fullname template                         | `nil`                                                |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set cluster.memberCount=3,serviceAccount.create=false \
    stable/hazelcast-jet
```

The above command sets number of Hazelcast Jet members to 3 and disables REST endpoints.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/hazelcast-jet
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Custom Hazelcast IMDG and Jet configuration

Custom Hazelcast IMDG and Hazelcast Jet configuration can be specified inside `values.yaml`, as the `jet.configurationFiles.hazelcast.xml` and `jet.configurationFiles.hazelcast-jet.xml` properties.

```yaml
jet:
  configurationFiles:
    hazelcast.xml: |-
      <?xml version="1.0" encoding="UTF-8"?>
      <hazelcast xsi:schemaLocation="http://www.hazelcast.com/schema/config hazelcast-config-3.10.xsd"
                     xmlns="http://www.hazelcast.com/schema/config"
                     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    
        <properties>
          <property name="hazelcast.discovery.enabled">true</property>
        </properties>
        <network>
          <join>
            <multicast enabled="false"/>
            <tcp-ip enabled="false" />
            <discovery-strategies>
              <discovery-strategy enabled="true" class="com.hazelcast.kubernetes.HazelcastKubernetesDiscoveryStrategy">
                <properties>
                  <property name="service-name">${serviceName}</property>
                  <property name="namespace">${namespace}</property>
                </properties>
              </discovery-strategy>
            </discovery-strategies>
          </join>
        </network>
        <!-- Custom Configuration Placeholder -->
      </hazelcast>
    hazelcast-jet.xml: |-
      <?xml version="1.0" encoding="UTF-8"?>
      <hazelcast-jet xsi:schemaLocation="http://www.hazelcast.com/schema/jet-config hazelcast-jet-config-0.8.xsd"
                    xmlns="http://www.hazelcast.com/schema/jet-config"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
          <instance>
              <!-- number of threads in the cooperative thread pool -->
            <cooperative-thread-count>8</cooperative-thread-count>
              <!-- period between flow control packets in milliseconds -->
            <flow-control-period>100</flow-control-period>
              <!-- number of backup copies to configure for Hazelcast IMaps used internally in a Jet job -->
            <backup-count>1</backup-count>
          </instance>
          <!-- custom properties which can be read in the user code -->
          <properties>
            <property name="custom.property">custom property</property>
          </properties>
          <edge-defaults>
              <!-- capacity of the concurrent SPSC queue between each two processors -->
            <queue-size>1024</queue-size>
              <!-- network packet size limit in bytes, only applies to distributed edges -->
            <packet-size-limit>16384</packet-size-limit>
              <!-- receive window size multiplier, only applies to distributed edges -->
            <receive-window-multiplier>3</receive-window-multiplier>
          </edge-defaults>
          <!-- whether metrics collection is enabled -->
          <metrics enabled="true">
              <!-- the number of seconds the metrics will be retained on the instance -->
              <retention-seconds>120</retention-seconds>
              <!-- the metrics collection interval in seconds -->
              <collection-interval-seconds>5</collection-interval-seconds>
              <!-- whether metrics should be collected for data structures. Metrics
                  collection can have some overhead if there is a large number of data
                  structures -->
              <metrics-for-data-structures>false</metrics-for-data-structures>
          </metrics>
      </hazelcast-jet>
```
