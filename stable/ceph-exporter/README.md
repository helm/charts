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
$ helm install --name my-release stable/ceph-exporter
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

