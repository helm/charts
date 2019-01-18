# Drone.io

[Drone](http://readme.drone.io/) is a Continuous Integration platform built on container technology.

## TL;DR;

```console
$ helm install stable/drone
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/drone
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes nearly all the Kubernetes components associated with the
chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the drone charts and their default values.

| Parameter                   | Description                                                                                   | Default                     |
|-----------------------------|-----------------------------------------------------------------------------------------------|-----------------------------|
| `images.server.repository`  | Drone **server** image                                                                        | `docker.io/drone/drone`     |
| `images.server.tag`         | Drone **server** image tag                                                                    | `0.8.9`                     |
| `images.server.pullPolicy`  | Drone **server** image pull policy                                                            | `IfNotPresent`              |
| `images.agent.repository`   | Drone **agent** image                                                                         | `docker.io/drone/agent`     |
| `images.agent.tag`          | Drone **agent** image tag                                                                     | `0.8.6`                     |
| `images.agent.pullPolicy`   | Drone **agent** image pull policy                                                             | `IfNotPresent`              |
| `images.dind.repository`    | Docker **dind** image                                                                         | `docker.io/library/docker`  |
| `images.dind.tag`           | Docker **dind** image tag                                                                     | `18.06.1-ce-dind`           |
| `images.dind.pullPolicy`    | Docker **dind** image pull policy                                                             | `IfNotPresent`              |
| `service.annotations`       | Service annotations                                                                           | `{}`                        |
| `service.httpPort`          | Drone's Web GUI HTTP port                                                                     | `80`                        |
| `service.nodePort`          | If `service.type` is `NodePort` and this is non-empty, sets the http node port of the service | `32015`                     |
| `service.type`              | Service type (ClusterIP, NodePort or LoadBalancer)                                            | `ClusterIP`                 |
| `ingress.enabled`           | Enables Ingress for Drone                                                                     | `false`                     |
| `ingress.annotations`       | Ingress annotations                                                                           | `{}`                        |
| `ingress.hosts`             | Ingress accepted hostnames                                                                    | `nil`                       |
| `ingress.tls`               | Ingress TLS configuration                                                                     | `[]`                        |
| `server.host`               | Drone **server** scheme and hostname                                                          | `(internal hostname)`       |
| `server.env`                | Drone **server** environment variables                                                        | `(default values)`          |
| `server.envSecrets`         | Drone **server** secret environment variables                                                 | `(default values)`          |
| `server.annotations`        | Drone **server** annotations                                                                  | `{}`                        |
| `server.resources`          | Drone **server** pod resource requests & limits                                               | `{}`                        |
| `server.schedulerName`      | Drone **server** alternate scheduler name                                                     | `nil`                       |
| `server.affinity`           | Drone **server** scheduling preferences                                                       | `{}`                        |
| `server.nodeSelector`       | Drone **server** node labels for pod assignment                                               | `{}`                        |
| `server.extraContainers`    | Additional sidecar containers                                                                 | `""`                        |
| `server.extraVolumes`       | Additional volumes for use in extraContainers                                                 | `""`                        |
| `agent.env`                 | Drone **agent** environment variables                                                         | `(default values)`          |
| `agent.replicas`            | Drone **agent** replicas                                                                      | `1`                         |
| `agent.annotations`         | Drone **agent** annotations                                                                   | `{}`                        |
| `agent.resources`           | Drone **agent** pod resource requests & limits                                                | `{}`                        |
| `agent.schedulerName`       | Drone **agent** alternate scheduler name                                                      | `nil`                       |
| `agent.affinity`            | Drone **agent** scheduling preferences                                                        | `{}`                        |
| `agent.nodeSelector`        | Drone **agent** node labels for pod assignment                                                | `{}`                        |
| `agent.livenessProbe.initialDelaySeconds` | Delay before liveness probe is initiated                                        | 0                           |
| `agent.livenessProbe.periodSeconds` | How often to perform the probe                                                        | 10                          |
| `agent.livenessProbe.timeoutSeconds` | When the probe times out                                                             | 1                           |
| `agent.livenessProbe.successThreshold` | Minimum consecutive successes for the probe to be considered successful after having failed. | 1                 |
| `agent.livenessProbe.failureThreshold` | Minimum consecutive failures for the probe to be considered failed after having succeeded. | 3                   |
| `agent.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated                                     | 0                            |
| `agent.readinessProbe.periodSeconds` | How often to perform the probe                                                      | 10                           |
| `agent.readinessProbe.timeoutSeconds` | When the probe times out                                                           | 1                            |
| `agent.readinessProbe.successThreshold` | Minimum consecutive successes for the probe to be considered successful after having failed. | 1                |
| `agent.readinessProbe.failureThreshold` | Minimum consecutive failures for the probe to be considered failed after having succeeded. | 3                  |
| `dind.enabled`              | Enable or disable **DinD**                                                                    | `true`                      |
| `dind.driver`               | **DinD** storage driver                                                                       | `overlay2`                  |
| `dind.resources`            | **DinD** pod resource requests & limits                                                       | `{}`                        |
| `dind.env`                  | **DinD** environment variables                                                                | `nil`                       |
| `dind.command`              | **DinD** custom command instead of default entry point                                        | `nil`                       |
| `dind.args`                 | **DinD** arguments for custom command or entry point                                          | `nil`                       |
| `metrics.prometheus.enabled` | Enable Prometheus metrics endpoint                                                          | `false`                     |
| `persistence.enabled`       | Use a PVC to persist data                                                                     | `true`                      |
| `persistence.existingClaim` | Use an existing PVC to persist data                                                           | `nil`                       |
| `persistence.storageClass`  | Storage class of backing PVC                                                                  | `nil`                       |
| `persistence.accessMode`    | Use volume as ReadOnly or ReadWrite                                                           | `ReadWriteOnce`             |
| `persistence.size`          | Size of data volume                                                                           | `1Gi`                       |
| `sharedSecret`              | Drone server and agent shared secret (Note: The Default random value changes on every `helm upgrade` causing a rolling update of server and agents) | `(random value)`            |
| `rbac.create`               | Specifies whether RBAC resources should be created.                                           | `true`                      |
| `rbac.apiVersion`           | RBAC API version                                                                              | `v1`                        |
| `serviceAccount.create`     | Specifies whether a ServiceAccount should be created.                                         | `true`                      |
| `serviceAccount.name`       | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template. | `(fullname template)` |
