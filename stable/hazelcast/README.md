# Hazelcast

[Hazelcast IMDG](http://hazelcast.com/) is the most widely used in-memory data grid with hundreds of thousands of installed clusters around the world. It offers caching solutions ensuring that data is in the right place when it’s needed for optimal performance.

## Quick Start

```bash
$ helm install stable/hazelcast
```

## Introduction

This chart bootstraps a [Hazelcast](https://github.com/hazelcast/hazelcast-docker/tree/master/hazelcast-kubernetes) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/hazelcast
```

The command deploys Hazelcast on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

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
| `image.repository`                         | Hazelcast Image name                                                                                           | `hazelcast/hazelcast-kubernetes`                     |
| `image.tag`                                | Hazelcast Image tag                                                                                            | `{VERSION}`                                          |
| `image.pullPolicy`                         | Image pull policy                                                                                              | `IfNotPresent`                                       |
| `image.pullSecrets`                        | Specify docker-registry secret names as an array                                                               | `nil`                                                |
| `cluster.memberCount`                      | Number of Hazelcast members                                                                                    | 2                                                    |
| `hazelcast.rest`                           | Enable REST endpoints for Hazelcast member                                                                     | `true`                                               |
| `hazelcast.javaOpts`                       | Additional JAVA_OPTS properties for Hazelcast member                                                           | `nil`                                                |
| `hazelcast.configurationFiles`             | Hazelcast configuration files                                                                                  | `{DEFAULT_HAZELCAST_XML}`                            |
| `nodeSelector`                             | Hazelcast Node labels for pod assignment                                                                       | `nil`                                                |
| `gracefulShutdown.enabled`                 | Turn on and off Graceful Shutdown                                                                              | `true`                                               |
| `gracefulShutdown.maxWaitSeconds`          | Maximum time to wait for the Hazelcast POD to shut down                                                        | `600`                                                |
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
| `securityContext.fsGroup`                  | Group ID associated with the Hazelcast container                                                               | `65534`                                              |
| `securityContext.runAsUser`                | User ID associated with the Hazelcast container                                                                | `65534`                                              |
| `securityContext.runAsNonRoot`             | Runs Hazelcast container as non-root user                                                                      | `true`                                               |
| `securityContext.readOnlyRootFilesystem`   | Read only root filesystem                                                                                      | `true`                                               |
| `securityContext.allowPrivilegeEscalation` | Allows privilege escalation                                                                                    | `false`                                              |
| `securityContext.defaultAllowPrivilegeEscalation` | Default allow privilege escalation                                                                             | `false`                                              |
| `metrics.enabled`                          | Turn on and off JMX Prometheus metrics available at `/metrics`                                                 | `false`                                              |
| `metrics.service.type`                     | Type of the metrics service                                                                                    | `ClusterIP`                                          |
| `metrics.service.port`                     | Port of the `/metrics` endpoint and the metrics service                                                        | `8080`                                               |
| `metrics.service.annotations`              | Annotations for the Prometheus discovery                                                                       |                                                      |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set cluster.memberCount=3,hazelcast.rest=false \
    stable/hazelcast
```

The above command sets number of Hazelcast members to 3 and disables REST endpoints.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/hazelcast
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Custom Hazelcast configuration

Custom Hazelcast configuration can be specified inside `values.yaml`, as the `hazelcast.configurationFiles.hazelcast.xml` property.

```yaml
hazelcast:
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
              </discovery-strategy>
            </discovery-strategies>
          </join>
        </network>

        <!-- Custom Configuration Placeholder -->
      </hazelcast>
```
