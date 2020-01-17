# Apache superset

## Introduction

This chart bootstraps an [Apache superset](https://superset.incubator.apache.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## TL;DR;

```bash
$ helm install stable/superset
```

## Prerequisites

- Kubernetes 1.9+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure (Only when persisting data)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/superset
```

The command deploys Superset on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

| Parameter                  | Description                                     | Default                                                      |
| -------------------------- | ----------------------------------------------- | ------------------------------------------------------------ |
| `image.repository`         | `superset` image repository                     | `amancevice/superset`                                        |
| `image.tag`                | `superset` image tag                            | `0.28.1`                                                     |
| `image.pullPolicy`         | Image pull policy                               | `IfNotPresent`                                               |
| `image.pullSecrets`        | Secrets for private registry                    | `[]`                                                         |
| `configFile`               | Content of [`superset_config.py`](https://superset.incubator.apache.org/installation.html) | See values.yaml](./values.yaml) |
| `extraConfigFiles`         | Content of additional configuration files. Let the dictionary key name represent the name of the file and its value the files content. | `{}` |
| `initFile`                 | Content of init shell script                    | See [values.yaml](./values.yaml)                             |
| `replicas`                 | Number of replicas of superset                  | `1`                                                          |
| `extraEnv`                 | Extra environment variables passed to pods      | `{}`                                                         |
| `extraEnvFromSecret`       | The name of a Kubernetes secret (must be manually created in the same namespace) containing values to be added to the environment | `""` |
| `deploymentAnnotations`              | Key Value pairs of deployment level annotations. Useful for 3rd party integrations | `{}` |
| `persistence.enabled`      | Enable persistence                              | `false`                                                      |
| `persistence.existingClaim`| Provide an existing PersistentVolumeClaim       | `""`                                                         |
| `persistence.storageClass` | Storage class of backing PVC                    | `nil` (uses alpha storage class annotation)                  |
| `persistence.accessMode`   | Use volume as ReadOnly or ReadWrite             | `ReadWriteOnce`                                              |
| `persistence.size`         | Size of data volume                             | `8Gi`                                                        |
| `resources`                | CPU/Memory resource requests/limits             | Memory: `256Mi`, CPU: `50m`   / Memory: `500Mi`, CPU: `500m` |
| `service.port`             | TCP port                                        | `9000`                                                       |
| `service.type`             | k8s service type exposing ports, e.g. `NodePort`| `ClusterIP`                                                  |
| `nodeSelector`             | Node labels for pod assignment                  | `{}`                                                         |
| `tolerations`              | Toleration labels for pod assignment            | `[]`                                                         |
| `livenessProbe`            | Parameter for liveness probe                    | See [values.yaml](./values.yaml)                             |
| `readinessProbe`           | Parameter for readiness probe                   | See [values.yaml](./values.yaml)                             |
| `ingress.enabled`          | Create an ingress resource when true            | `false`                                                      |
| `ingress.annotations`      | ingress annotations                             | `{}`                                                         |
| `ingress.hosts`            | ingress hosts                                   | `[superset.domain.com]`                                      |
| `ingress.path`             | ingress path                                    | `\`                                                          |
| `ingress.tls`              | ingress tls                                     | `[]`                                                         |

 see [values.yaml](./values.yaml)

## Init script

There is a script (`init_superset.sh`) which is called at the entrypoint of the container. It initialzes the db and creates an user account. You can configure the content with `initFile`. E.g. in order to change admin password and load examples:

```yaml
initFile: |-
  /usr/local/bin/superset-init --username admin --firstname myfirstname --lastname mylastname --email admin@fab.org --password mypassword
  superset load_examples
  superset runserver
```

## Persistence

The [superset image](https://hub.docker.com/r/amancevice/superset/) mounts the SQLite DB file (`superset.db`) on path `/var/lib/superset`. The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) at this location. The volume is created using dynamic volume provisioning. If the PersistentVolumeClaim should not be managed by the chart, define `persistence.existingClaim`.

### Existing PersistentVolumeClaims

1. Create the PersistentVolumeClaim with name `superset-pvc` in the same namespace
1. Install the chart

```bash
$ helm install --set persistence.enabled=true,persistence.existingClaim=superset-pvc stable/superset
```
