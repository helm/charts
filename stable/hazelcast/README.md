# DEPRECATED - Hazelcast

[Hazelcast IMDG](http://hazelcast.com/) is the most widely used in-memory data grid with hundreds of thousands of installed clusters around the world. It offers caching solutions ensuring that data is in the right place when it’s needed for optimal performance.

## This Helm chart is deprecated

**Given the [stable deprecation timeline](https://github.com/helm/charts#deprecation-timeline), the Hazelcast IMDG Helm chart is now located at [hazelcast/charts](https://github.com/hazelcast/charts/).**

**The Hazelcast IMDG chart repo is also avaliable at [Helm Hub](https://hub.helm.sh/charts/hazelcast/hazelcast).**

To install new chart, you just need to add the related repo and use `hazelcast/hazelcast` instead of `stable/hazelcast` as a chart name.

```bash
$ helm repo add hazelcast https://hazelcast-charts.s3.amazonaws.com/
$ helm install my-release hazelcast/hazelcast           # Helm 3
$ helm install --name my-release hazelcast-hazelcast   # Helm 2
```

## Quick Start

    $ helm install my-release stable/hazelcast        # Helm 3
    $ helm install --name my-release stable/hazelcast # Helm 2

## Introduction

This chart bootstraps a [Hazelcast](https://github.com/hazelcast/hazelcast-docker/tree/master/hazelcast-kubernetes) and [Management Center](https://github.com/hazelcast/management-center-docker) deployments on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

-   Kubernetes 1.9+

## Installing the Chart

To install the chart with the release name `my-release`:

    $ helm install my-release stable/hazelcast        # Helm 3
    $ helm install --name my-release stable/hazelcast # Helm 2

The command deploys Hazelcast on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

    $ helm delete my-release

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Hazelcast chart and their default values.

| Parameter                                    | Description                                                                                                                                                                                                         | Default                         |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| image.repository                             | Hazelcast Image name                                                                                                                                                                                                | hazelcast/hazelcast             |
| image.tag                                    | Hazelcast Image tag                                                                                                                                                                                                 | {VERSION}                       |
| image.pullPolicy                             | Image pull policy                                                                                                                                                                                                   | IfNotPresent                    |
| image.pullSecrets                            | Specify docker-registry secret names as an array                                                                                                                                                                    | nil                             |
| cluster.memberCount                          | Number of Hazelcast members                                                                                                                                                                                         | 2                               |
| hazelcast.javaOpts                           | Additional JAVA_OPTS properties for Hazelcast member                                                                                                                                                                | nil                             |
| hazelcast.loggingLevel                       | Level of Hazelcast logs (SEVERE, WARNING, INFO, CONFIG, FINE, FINER, and FINEST); note that changing this value requires setting securityContext.runAsUser to 0 and securityContext.readOnlyRootFilesystem to false | nil                             |
| hazelcast.existingConfigMap                  | ConfigMap which contains Hazelcast configuration file(s) that are used instead of hazelcast.yaml file embedded into values.yaml                                                                                     | nil                             |
| hazelcast.yaml                               | Hazelcast YAML Configuration (hazelcast.yaml embedded into values.yaml)                                                                                                                                             | {DEFAULT_HAZELCAST_YAML}        |
| hazelcast.configurationFiles                 | Hazelcast configuration files                                                                                                                                                                                       | nil                             |
| affinity                                     | Hazelcast Node affinity                                                                                                                                                                                             | nil                             |
| tolerations                                  | Hazelcast Node tolerations                                                                                                                                                                                          | nil                             |
| nodeSelector                                 | Hazelcast Node labels for pod assignment                                                                                                                                                                            | nil                             |
| hostPort                                     | Port under which Hazelcast PODs are exposed on the host machines                                                                                                                                                    | nil                             |
| gracefulShutdown.enabled                     | Turn on and off Graceful Shutdown                                                                                                                                                                                   | true                            |
| gracefulShutdown.maxWaitSeconds              | Maximum time to wait for the Hazelcast POD to shut down                                                                                                                                                             | 600                             |
| livenessProbe.enabled                        | Turn on and off liveness probe                                                                                                                                                                                      | true                            |
| livenessProbe.initialDelaySeconds            | Delay before liveness probe is initiated                                                                                                                                                                            | 30                              |
| livenessProbe.periodSeconds                  | How often to perform the probe                                                                                                                                                                                      | 10                              |
| livenessProbe.timeoutSeconds                 | When the probe times out                                                                                                                                                                                            | 5                               |
| livenessProbe.successThreshold               | Minimum consecutive successes for the probe to be considered successful after having failed                                                                                                                         | 1                               |
| livenessProbe.failureThreshold               | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                                                          | 3                               |
| livenessProbe.path                           | URL path that will be called to check liveness.                                                                                                                                                                     | /hazelcast/health/node-state    |
| livenessProbe.port                           | Port that will be used in liveness probe calls.                                                                                                                                                                     | nil                             |
| readinessProbe.enabled                       | Turn on and off readiness probe                                                                                                                                                                                     | true                            |
| readinessProbe.initialDelaySeconds           | Delay before readiness probe is initiated                                                                                                                                                                           | 30                              |
| readinessProbe.periodSeconds                 | How often to perform the probe                                                                                                                                                                                      | 10                              |
| readinessProbe.timeoutSeconds                | When the probe times out                                                                                                                                                                                            | 1                               |
| readinessProbe.successThreshold              | Minimum consecutive successes for the probe to be considered successful after having failed                                                                                                                         | 1                               |
| readinessProbe.failureThreshold              | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                                                          | 3                               |
| readinessProbe.path                          | URL path that will be called to check readiness.                                                                                                                                                                    | /hazelcast/health/ready         |
| readinessProbe.port                          | Port that will be used in readiness probe calls.                                                                                                                                                                    | nil                             |
| resources.limits.cpu                         | CPU resource limit                                                                                                                                                                                                  | default                         |
| resources.limits.memory                      | Memory resource limit                                                                                                                                                                                               | default                         |
| resources.requests.cpu                       | CPU resource requests                                                                                                                                                                                               | default                         |
| resources.requests.memory                    | Memory resource requests                                                                                                                                                                                            | default                         |
| service.create                               | Enable installing Service                                                                                                                                                                                           | true                            |
| service.name                                 | Name of Service, if not set, the name is generated using the fullname template                                                                                                                                      | nil                             |
| service.type                                 | Kubernetes service type (`ClusterIP`, `LoadBalancer`, or `NodePort`)                                                                                                                                                | ClusterIP                       |
| service.port                                 | Kubernetes service port                                                                                                                                                                                             | 5701                            |
| service.clusterIP                            | IP of the service, "None" makes the service headless                                                                                                                                                                | None                            |
| rbac.create                                  | Enable installing RBAC Role authorization                                                                                                                                                                           | true                            |
| serviceAccount.create                        | Enable installing Service Account                                                                                                                                                                                   | true                            |
| serviceAccount.name                          | Name of Service Account, if not set, the name is generated using the fullname template                                                                                                                              | nil                             |
| securityContext.enabled                      | Enables Security Context for Hazelcast and Management Center                                                                                                                                                        | true                            |
| securityContext.runAsUser                    | User ID used to run the Hazelcast and Management Center containers                                                                                                                                                  | 65534                           |
| securityContext.runAsGroup                   | Primary Group ID used to run all processes in the Hazelcast Jet and Hazelcast Jet Management Center containers                                                                                                      | 65534                           |
| securityContext.fsGroup                      | Group ID associated with the Hazelcast and Management Center container                                                                                                                                              | 65534                           |
| securityContext.readOnlyRootFilesystem       | Enables readOnlyRootFilesystem in the Hazelcast security context                                                                                                                                                    | true                            |
| metrics.enabled                              | Turn on and off JMX Prometheus metrics available at `/metrics`                                                                                                                                                      | false                           |
| metrics.service.type                         | Type of the metrics service                                                                                                                                                                                         | ClusterIP                       |
| metrics.service.port                         | Port of the `/metrics` endpoint and the metrics service                                                                                                                                                             | 8080                            |
| metrics.service.annotations                  | Annotations for the Prometheus discovery                                                                                                                                                                            |
| customVolume                                 | Configuration for a volume mounted as `/data/custom` (e.g. to mount a volume with custom JARs)                                                                                                                      | nil                             |
| mancenter.enabled                            | Turn on and off Management Center application                                                                                                                                                                       | true                            |
| mancenter.image.repository                   | Hazelcast Management Center Image name                                                                                                                                                                              | hazelcast/management-center     |
| mancenter.image.tag                          | Hazelcast Management Center Image tag (NOTE: must be the same or one minor release greater than Hazelcast image version)                                                                                            | {VERSION}                       |
| mancenter.image.pullPolicy                   | Image pull policy                                                                                                                                                                                                   | IfNotPresent                    |
| mancenter.image.pullSecrets                  | Specify docker-registry secret names as an array                                                                                                                                                                    | nil                             |
| mancenter.contextPath                        | the value for the `MC_CONTEXT_PATH` environment variable, thus overriding the default context path for Hazelcast Management Center                                                                                  | nil                             |
| mancenter.ssl                                | Enable SSL for Management                                                                                                                                                                                           | false                           |
| mancenter.javaOpts                           | Additional `JAVA_OPTS` properties for Hazelcast Management Center                                                                                                                                                   | nil                             |
| mancenter.licenseKey                         | License Key for Hazelcast Management Center, if not provided, can be filled in the web interface                                                                                                                    | nil                             |
| mancenter.licenseKeySecretName               | Kubernetes Secret Name, where Management Center License Key is stored (can be used instead of licenseKey)                                                                                                           | nil                             |
| mancenter.existingConfigMap                  | ConfigMap which contains Hazelcast Client configuration file(s) that are used instead of hazelcast-client.yaml file embedded into values.yaml                                                                       | {DEFAULT_HAZELCAST_CLIENT_YAML} |
| mancenter.yaml                               | Hazelcast Client YAML Configuration (hazelcast-client.yaml used to connect to Hazelcast cluster                                                                                                                     | nil                             |
| mancenter.affinity                           | Management Center Node affinity                                                                                                                                                                                     | nil                             |
| mancenter.tolerations                        | Management Center Node tolerations                                                                                                                                                                                  | nil                             |
| mancenter.nodeSelector                       | Hazelcast Management Center node labels for pod assignment                                                                                                                                                          | nil                             |
| mancenter.resources                          | CPU/Memory resource requests/limits                                                                                                                                                                                 | nil                             |
| mancenter.persistence.enabled                | Enable Persistent Volume for Hazelcast Management                                                                                                                                                                   | true                            |
| mancenter.persistence.existingClaim          | Name of the existing Persistence Volume Claim, if not defined, a new is created                                                                                                                                     | nil                             |
| mancenter.persistence.accessModes            | Access Modes of the new Persistent Volume Claim                                                                                                                                                                     | ReadWriteOnce                   |
| mancenter.persistence.size                   | Size of the new Persistent Volume Claim                                                                                                                                                                             | 8Gi                             |
| mancenter.service.type                       | Kubernetes service type (`ClusterIP`, `LoadBalancer`, or `NodePort`)                                                                                                                                                | LoadBalancer                    |
| mancenter.service.port                       | Kubernetes service port                                                                                                                                                                                             | 5701                            |
| mancenter.livenessProbe.enabled              | Turn on and off liveness probe                                                                                                                                                                                      | true                            |
| mancenter.livenessProbe.initialDelaySeconds  | Delay before liveness probe is initiated                                                                                                                                                                            | 30                              |
| mancenter.livenessProbe.periodSeconds        | How often to perform the probe                                                                                                                                                                                      | 10                              |
| mancenter.livenessProbe.timeoutSeconds       | When the probe times out                                                                                                                                                                                            | 5                               |
| mancenter.livenessProbe.successThreshold     | Minimum consecutive successes for the probe to be considered successful after having failed                                                                                                                         | 1                               |
| mancenter.livenessProbe.failureThreshold     | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                                                          | 3                               |
| mancenter.readinessProbe.enabled             | Turn on and off readiness probe                                                                                                                                                                                     | true                            |
| mancenter.readinessProbe.initialDelaySeconds | Delay before readiness probe is initiated                                                                                                                                                                           | 30                              |
| mancenter.readinessProbe.periodSeconds       | How often to perform the probe                                                                                                                                                                                      | 10                              |
| mancenter.readinessProbe.timeoutSeconds      | When the probe times out                                                                                                                                                                                            | 1                               |
| mancenter.readinessProbe.successThreshold    | Minimum consecutive successes for the probe to be considered successful after having failed                                                                                                                         | 1                               |
| mancenter.readinessProbe.failureThreshold    | Minimum consecutive failures for the probe to be considered failed after having succeeded.                                                                                                                          | 3                               |
| mancenter.ingress.enabled                    | Enable ingress for the management center                                                                                                                                                                            | false                           |
| mancenter.ingress.annotations                | Any annotations for the ingress                                                                                                                                                                                     | {}                              |
| mancenter.ingress.hosts                      | List of hostnames for ingress, see values.yaml for example                                                                                                                                                          | []                              |
| mancenter.ingress.tls                        | List of TLS configuration for ingress, see values.yaml for example                                                                                                                                                  | []                              |
| mancenter.secretsMountName                   | Secret name that is mounted as '/secrets/' (e.g. with keystore/trustore files)                                                                                                                                      | nil                             |


Specify each parameter using the `--set key=value,key=value` argument to `helm install`. For example,

    # Helm 3
    $ helm install my-release \
      --set cluster.memberCount=3 \
        stable/hazelcast

    # Helm 2
    $ helm install --name my-release \
      --set cluster.memberCount=3 \
        stable/hazelcast

The above command sets number of Hazelcast members to 3.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

    $ helm install my-release -f values.yaml stable/hazelcast        # Helm 3
    $ helm install --name my-release -f values.yaml stable/hazelcast # Helm 2

> **Tip**: You can use the default values.yaml

## Custom Hazelcast configuration

Custom Hazelcast configuration can be specified inside `values.yaml`, as the `hazelcast.yaml` property.

    hazelcast:
       yaml:
        hazelcast:
          network:
            join:
              multicast:
                enabled: false
              kubernetes:
                enabled: true
                service-name: ${serviceName}
                namespace: ${namespace}
                resolve-not-ready-addresses: true
            <!-- Custom Configuration Placeholder -->

# Notable changes

## 2.8.0

Hazelcast REST Endpoints are no longer enabled by default and the parameter `hazelcast.rest` is no longer available. If you want to enable REST, please add the related `endpoint-groups` to the Hazelcast Configuration. For example:

    rest-api:
      enabled: true
      endpoint-groups:
        HEALTH_CHECK:
          enabled: true
        CLUSTER_READ:
          enabled: true
        CLUSTER_WRITE:
          enabled: true
