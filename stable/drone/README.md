# Drone.io

[Drone](http://docs.drone.io/) is a Continuous Integration platform built on
container technology. Version 2 of this chart is compatible with drone version
1. If you wish to install drone version 0.8, using version 1.x of this chart.

Users on version 1.12 of kubernetes or later can make use of the
[TTLAfterFinished](https://kubernetes.io/docs/concepts/workloads/controllers/ttlafterfinished/) feature gate, to delete completed pipelines. If your cluster version does not support TTLAfterFinished, you will have to set a cronjob to clean up afer drone.

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
| `images.server.tag`         | Drone **server** image tag                                                                    | `1.0.0-rc.2`                |
| `images.server.pullPolicy`  | Drone **server** image pull policy                                                            | `IfNotPresent`              |
| `images.cronjob.repository` | Drone **cronjob** image                                                                       | `docker.io/docker.io/lachlanevenson/k8s-kubectl` |
| `images.cronjob.tag`        | Drone **cronjob** image tag                                                                   | `v1.9.3`                    |
| `images.cronjob.pullPolicy` | Drone **cronjob** image pull policy                                                           | `IfNotPresent`              |
| `service.nodePort`          | If `service.type` is `NodePort` and this is non-empty, sets the http node port of the service | `nil`                       |
| `service.type`              | Service type (ClusterIP, NodePort or LoadBalancer)                                            | `ClusterIP`                 |
| `service.annotations`       | Service annotations                                                                           | `{}`                        |
| `ingress.enabled`           | Enables Ingress for Drone                                                                     | `false`                     |
| `ingress.annotations`       | Ingress annotations                                                                           | `{}`                        |
| `ingress.hosts`             | Ingress accepted hostnames                                                                    | `nil`                       |
| `ingress.tls`               | Ingress TLS configuration                                                                     | `[]`                        |
| `server.host`               | Drone **server** hostname                                                                     | `(internal hostname)`       |
| `server.scheme`             | Drone **server** scheme                                                                       | `(internal scheme)`         |
| `server.letsEncrypt`        | Drone **server** `DRONE_TLS_AUTOCERT`                                                         | `false`                     |
| `server.env`                | Drone **server** environment variables                                                        | `(default values)`          |
| `server.envSecrets`         | Drone **server** secret environment variables                                                 | `(default values)`          |
| `server.annotations`        | Drone **server** annotations                                                                  | `{}`                        |
| `server.resources`          | Drone **server** pod resource requests & limits                                               | `{}`                        |
| `server.schedulerName`      | Drone **server** alternate scheduler name                                                     | `nil`                       |
| `server.affinity`           | Drone **server** scheduling preferences                                                       | `{}`                        |
| `server.nodeSelector`       | Drone **server** node labels for pod assignment                                               | `{}`                        |
| `server.extraContainers`    | Additional sidecar containers                                                                 | `""`                        |
| `server.extraVolumes`       | Additional volumes for use in extraContainers                                                 | `""`                        |
| `persistence.enabled`       | Use a PVC to persist data                                                                     | `true`                      |
| `persistence.existingClaim` | Use an existing PVC to persist data                                                           | `nil`                       |
| `persistence.storageClass`  | Storage class of backing PVC                                                                  | `nil`                       |
| `persistence.accessMode`    | Use volume as ReadOnly or ReadWrite                                                           | `ReadWriteOnce`             |
| `persistence.size`          | Size of data volume                                                                           | `1Gi`                       |
| `sharedSecret`              | Drone server and agent shared secret (Note: The Default random value changes on every `helm upgrade` causing a rolling update of server and agents) | `(random value)` |
| `rbac.create`               | Specifies whether RBAC resources should be created.                                           | `true`                      |
| `rbac.apiVersion`           | RBAC API version                                                                              | `v1`                        |
| `serviceAccount.create`     | Specifies whether a ServiceAccount should be created.                                         | `true`                      |
| `serviceAccount.name`       | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template. | `(fullname template)` |
| `cronjob.enabled`           | Enable or disable drone job deletion                                                          | `false`                     |
| `cronjob.schedule`          | The schedule for the cronjob                                                                  | `*/15 0 * * *`              |
| `cronjob.command`           | The command, which will delete jobs                                                           | `["/bin/sh", "-c", "/opt/bin/clean.sh"]` |
