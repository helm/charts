# Event Store

[Event Store](https://eventstore.org/) is an open-source, 
functional database with Complex Event Processing in JavaScript.

## TL;DR;
```
> helm install stable/eventstore
```
> The default username and password for the admin interface
is `admin:changeit`.

## Introduction

This chart bootstraps a [Event Store](https://hub.docker.com/r/eventstore/eventstore/) 
deployment on a [Kubernetes](http://kubernetes.io) cluster 
using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure (Only when persisting data)

## Installing the Chart

To install the Event Store chart with the release name `eventstore`:
```
> helm install -n eventstore stable/eventstore
```

To install the Event Store chart with a custom admin password:
```
> helm install -n eventstore stable/eventstore --set 'admin.password=<your admin password>'
```
> This triggers Helm to run a post-install Job which resets the admin password using
the Event Store HTTP API. You can then use the username `admin` and the password set 
in the above command to log into the admin interface.

The above commands install Event Store with the default configuration. 
The [configuration](#configuration) section below lists the parameters 
that can be configured during installation.

## Deleting the Chart

Delete the `eventstore` release.

```
$ helm delete eventstore --purge
```
> This command removes all the Kubernetes components 
associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Event Store chart and their default values.

| Parameter                            | Description                                                                   | Default                      |
|--------------------------------------|-------------------------------------------------------------------------------|------------------------------|
| `image`                              | Container image name                                                          | `eventstore/eventstore`      |
| `imageTag`                           | Container image tag                                                           | `release-4.1.1-hotfix1`      |
| `imagePullPolicy`                    | Container pull policy                                                         | `IfNotPresent`               |
| `imagePullSecrets`                   | Specify image pull secrets                                                    | `nil`                        |
| `clusterSize`                        | The number of nodes in the cluster                                            | `3`                          |
| `admin.jobImage`                     | Post install Job image with `curl` installed for setting admin password       | `tutum/curl`                 |
| `admin.jobImageTag`                  | Post install Job image tag                                                    | `latest`                     |
| `admin.password`                     | Custom password for admin interface (should be set in separate file)          | `nil`                        |
| `admin.serviceType`                  | Service type for the admin interface                                          | `ClusterIP`                  |
| `admin.proxyImage`                   | NGINX image for admin interface proxy                                         | `nginx`                      |
| `admin.proxyImageTag`                | NGINX image tag                                                               | `latest`                     |
| `podDisruptionBudget.enabled`        | Enable a pod disruption budget for nodes                                      | `false`                      |
| `podDisruptionBudget.minAvailable`   | Number of pods that must still be available after eviction                    | `2`                          |
| `podDisruptionBudget.maxUnavailable` | Number of pods that can be unavailable after eviction                         | `nil`                        |
| `intHttpPort`                        | Internal HTTP port                                                            | `2112`                       |
| `extHttpPort`                        | External HTTP port                                                            | `2113`                       |
| `intTcpPort`                         | Internal TCP port                                                             | `1112`                       |
| `extTcpPort`                         | External TCP port                                                             | `1113`                       |
| `gossipAllowedDiffMs`                | The amount of drift, in ms, between clocks on nodes before gossip is rejected | `600000`                     |
| `eventStoreConfig`                   | Additional Event Store parameters                                             | `{}`                         |
| `persistence.enabled`                | Enable persistence using PVC                                                  | `false`                      |
| `persistence.existingClaim`          | Provide an existing PVC                                                       | `nil`                        |
| `persistence.accessMode`             | Access Mode for PVC                                                           | `ReadWriteOnce`              |
| `persistence.size`                   | Size of data volume                                                           | `8Gi`                        |
| `persistence.mountPath`              | Mount path of data volume                                                     | `/var/lib/eventstore`        |
| `persistence.annotations`            | Annotations for PVC                                                           | `{}`                         |
| `resources`                          | CPU/Memory resource request/limits                                            | Memory: `256Mi`, CPU: `100m` |
| `nodeSelector`                       | Node labels for pod assignment                                                | `{}`                         |
| `tolerations`                        | Toleration labels for pod assignment                                          | `[]`                         |
| `affinity`                           | Affinity settings for pod assignment                                          | `{}`                         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`
or create a `values.yaml` file and use `helm install --values values.yaml`.

## Additional Resources
- [Event Store Docs](https://eventstore.org/docs/)
- [Event Store Parameters](https://eventstore.org/docs/server/command-line-arguments/index.html#parameter-list)
- [Event Store Docker Container](https://github.com/EventStore/eventstore-docker)
