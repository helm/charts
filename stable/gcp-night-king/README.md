# GCP Night King Helm Chart

This directory contains a Kubernetes chart to deploy a
[GCP Night King](https://github.com/itamaro/gcp-go-night-king) service.

## TL;DR;

```console
$ helm install stable/gcp-night-king --set projectID=$( gcloud config get-value project )
```

## Chart Details

This chart will do the following:

* Install a service (K8s Deployment) that listens on a Pub/Sub subscription for instance preemption
  messages and resurrects preempted instances once they are terminated.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/gcp-night-king
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of this chart and their default values.

|     Parameter          |          Description                      |       Default                   |
|------------------------|-------------------------------------------|---------------------------------|
| `image.pullPolicy`     | Container pull policy                     | `IfNotPresent`                  |
| `image.repository`     | Container image to use                    | `itamarost/gcp-night-king`      |
| `image.tag`            | Container image tag to deploy             | `v1-golang`                     |
| `replicaCount`         | k8s replicas                              | `1`                             |
| `resources`            | Service resource requests and limits      | `nil`                           |
| `projectID`            | GCE project ID for GCE API                | Mandatory parameter             |
| `subscriptionName`     | Pub/Sub subscription name to listen on    | `nil`                           |
| `nodeSelector`         | Node labels for pod assignment            | `{}`                            |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.
