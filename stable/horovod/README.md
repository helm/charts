# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Horovod

[Horovod](https://eng.uber.com/horovod/) is a distributed training framework for TensorFlow, and it's provided by UBER. The goal of Horovod is to make distributed Deep Learning fast and easy to use. And it provides [Horovod in Docker](https://github.com/uber/horovod/blob/master/docs/docker.md) to streamline the installation process.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

## Introduction

This chart bootstraps Horovod which is a Distributed TensorFlow Framework on a Kubernetes cluster using the Helm Package Manager. It deploys Horovod workers as statefulsets, and the Horovod master as a job, then discover the host list automatically.

## Prerequisites

- Kubernetes cluster v1.8+

## Build Docker Image

You can download [official Horovod Dockerfile](https://github.com/uber/horovod/blob/master/Dockerfile), then modify it according to your requirement, e.g. select a different CUDA, TensorFlow or Python version.

```
# mkdir horovod-docker
# wget -O horovod-docker/Dockerfile https://raw.githubusercontent.com/uber/horovod/master/Dockerfile
# docker build -t horovod:latest horovod-docker
```

## Prepare ssh keys

```
# Setup ssh key
export SSH_KEY_DIR=`mktemp -d`
cd $SSH_KEY_DIR
yes | ssh-keygen -N "" -f id_rsa
```

## Create the values.yaml

To run Horovod with GPU, you can create `values.yaml` like below

```
# cat << EOF > ~/values.yaml
---
ssh:
  useSecrets: true
  hostKey: |-
$(cat $SSH_KEY_DIR/id_rsa | sed 's/^/    /g')

  hostKeyPub: |-
$(cat $SSH_KEY_DIR/id_rsa.pub | sed 's/^/    /g')

resources:
  limits:
    nvidia.com/gpu: 1
  requests:
    nvidia.com/gpu: 1

worker:
  number: 2
  image:
    repository: uber/horovod
    tag: 0.12.1-tf1.8.0-py3.5
master:
  image:
    repository: uber/horovod
    tag: 0.12.1-tf1.8.0-py3.5
  args:
    - "mpirun -np 3 --hostfile /horovod/generated/hostfile --mca orte_keep_fqdn_hostnames t --allow-run-as-root --display-map --tag-output --timestamp-output sh -c 'python /examples/tensorflow_mnist.py'"
EOF
```

For most cases, the overlay network impacts the Horovod performance greatly, so we should apply `Host Network` solution. To run Horovod with Host Network and GPU, you can create `values.yaml` like below


```
# cat << EOF > ~/values.yaml
---
useHostNetwork: true

ssh:
  useSecrets: true
  port: 32222
  hostKey: |-
$(cat $SSH_KEY_DIR/id_rsa | sed 's/^/    /g')

  hostKeyPub: |-
$(cat $SSH_KEY_DIR/id_rsa.pub | sed 's/^/    /g')

resources:
  limits:
    nvidia.com/gpu: 1
  requests:
    nvidia.com/gpu: 1

worker:
  number: 2
  image:
    repository: uber/horovod
    tag: 0.12.1-tf1.8.0-py3.5
master:
  image:
    repository: uber/horovod
    tag: 0.12.1-tf1.8.0-py3.5
  args:
    - "mpirun -np 3 --hostfile /horovod/generated/hostfile --mca orte_keep_fqdn_hostnames t --allow-run-as-root --display-map --tag-output --timestamp-output sh -c 'python /examples/tensorflow_mnist.py'"
EOF
```

> notice: the difference is that you should set `useHostNetwork` as true, then set another ssh port rather than `22`

## Installing the Chart

To install the chart with the release name `mnist`:

```bash
$ helm install --values ~/values.yaml --name mnist stable/horovod
```

## Uninstalling the Chart

To uninstall/delete the `mnist` deployment:

```bash
$ helm delete mnist
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Upgrading an existing Release to a new major version
A major chart version change (like v1.2.3 -> v2.0.0) indicates that there is an
incompatible breaking change needing manual actions.

### 1.0.0
This version removes the `chart` label from the `spec.selector.matchLabels`
which is immutable since `StatefulSet apps/v1beta2`. It has been inadvertently
added, causing any subsequent upgrade to fail. See https://github.com/helm/charts/issues/7726.

In order to upgrade, delete the Horovod StatefulSet before upgrading, supposing your Release is named `my-release`:

```bash
$ kubectl delete statefulsets.apps --cascade=false my-release
```

## Configuration

The following table lists the configurable parameters of the Horovod
chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `useHostNetwork`  | Host network    | `false` |
| `ssh.port` | The ssh port | `22` |
| `ssh.useSecrets` | Determine if using the secrets for ssh | `false` |
| `worker.number`|  The worker's number | `5` |
| `worker.image.repository` | horovod worker image | `uber/horovod` |
| `worker.image.pullPolicy` | `pullPolicy` for the worker | `IfNotPresent` |
| `worker.image.tag` | `tag` for the worker | `0.12.1-tf1.8.0-py3.5` |
| `resources`| pod resource requests & limits| `{}`|
| `worker.env` | worker's environment variables | `{}` |
| `master.image.repository` | horovod master image | `uber/horovod` |
| `master.image.tag` | `tag` for the master | `0.12.1-tf1.8.0-py3.5` |
| `master.image.pullPolicy` | image pullPolicy for the master image| `IfNotPresent` |
| `master.args` | master's args | `{}` |
| `master.env` | master's environment variables | `{}` |
