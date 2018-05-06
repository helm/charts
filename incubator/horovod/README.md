# Horovod

[Horovod](https://eng.uber.com/horovod/) is a distributed training framework for TensorFlow, and it's provided by UBER. The goal of Horovod is to make distributed Deep Learning fast and easy to use.

## Introduction

This chart bootstraps Horovod which is a Distributed TensorFlow Framework on a Kubernetes cluster using the Helm Package manager. It deploys Secondary Horovod workers as statefulsets, and the Primary Horovod master as job, then discover the the host list automatically.ß

## Prerequisites

- Kubernetes cluster v1.8+ 

## Installing the Chart

To install the chart with the release name `horovod`:

```bash
$ helm install --values values.yaml --name horovod incubator/horovod
```

## Uninstalling the Chart

To uninstall/delete the `horovod` deployment:

```bash
$ helm delete horovod
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following tables lists the configurable parameters of the Horovod
chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ssh.port` | The ssh port | `22` |
| `worker.number`|  The worker's number | `5` |
| `worker.image.repository` | horovod worker image | `cheyang/horovod` |
| `worker.image.pullPolicy` | `pullPolicy` for the worker | `IfNotPresent` |
| `worker.image.tag` | `tag` for the worker | `gpu-tf-1.6.0` |
| `worker.resources`| worker's pod resource requests & limits| `{}`|
| `worker.env` | worker's environment varaibles | `{}` |
| `master.image.repository` | horovod master image | `cheyang/horovod` |
| `master.image.tag` | `tag` for the master | `gpu-tf-1.6.0` |
| `master.image.pullPolicy` | image pullPolicy for the master image| `IfNotPresent` |
| `master.args` | master's args | `{}` |
| `master.resources`| master's pod resource requests & limits| `{}`|
| `master.env` | master's environment varaibles | `{}` |
