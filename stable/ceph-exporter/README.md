# Ceph-Exporter

Ceph-Exporter is a Prometheus exporter for allowing [Prometheus](https://prometheus.io/) to gather metrics about Ceph.

## Introduction

This chart bootstraps a [Prometheus](https://prometheus.io/) Ceph exporter on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.3+
- Ceph
- Prometheus

## Installing the Chart

First, you need a Ceph credential uploaded to Kubernetes as a secret.

Create an account if you dont have one already like:
```console
$ ceph auth get-or-create client.read-only mon 'allow r' osd 'allow r' > /etc/ceph/ceph.client.read-only.keyring
```

Then import it into Kubernetes such as:
```console
$ kubectl create secret generic ceph-read-only --from-file=key=/etc/ceph/ceph.client.read-only.keyring
```

Next, you need a ceph config file. Upload the default such as:
```console
$ kubectl create configmap ceph-read-only --from-file=conf=/etc/ceph/ceph.conf
```

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/ceph-exporter --set enable=true,secret.manage=false,configmap.manage=false
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the ceph-exporter chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `enabled` | Enable the chart | 'false' |
| `image` | Image to use | `digitalocean/ceph_exporter` |
| `imageTag` | Image tag to use | `1.0.0` |
| `imagePullPolicy` | Image pull policy | `IfNotPresent` |
| `replicaCount` | Number of replicas | `1` |
| `nodeSelector` | Node selector to use to schedule pods | `{}` |
| `serviceType` | The type of service to bind | `ClusterIP` |
| `secret.user` | The ceph username to use | `read-only` |
| `secret.name` | The name of the secret with the ceph credentials | `ceph-read-only` |
| `configmap.name` | The name of the configmap with the ceph config | `ceph-read-only` |
| `httpPort` | The http port to listen on | `8081` |
| `annotations` | Add extra annotations to the pods | `{}` |
| `resources` | Request resource allocation | `{}` |

