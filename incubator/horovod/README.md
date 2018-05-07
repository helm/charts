# Horovod

[Horovod](https://eng.uber.com/horovod/) is a distributed training framework for TensorFlow, and it's provided by UBER. The goal of Horovod is to make distributed Deep Learning fast and easy to use. And it provides [Horovod in Docker](https://github.com/uber/horovod/blob/master/docs/docker.md) to streamline the installation process.

## Introduction

This chart bootstraps Horovod which is a Distributed TensorFlow Framework on a Kubernetes cluster using the Helm Package manager. It deploys Horovod workers as statefulsets, and the Horovod master as a job, then discover the the host list automatically.ß

## Prerequisites

- Kubernetes cluster v1.8+ 

## Build Docker Image

You can download [offical Horovod Dockerfile](https://github.com/uber/horovod/blob/master/Dockerfile), then modify it according to your requirement, e.g. select a different CUDA, TensorFlow or Python version.

```
# mkdir horovod-docker
# wget -O horovod-docker/Dockerfile https://raw.githubusercontent.com/uber/horovod/master/Dockerfile
# docker build -t horovod:latest horovod-docker
```

## Define the values.yaml

To deploy Horovod with GPU, you can create `values.yaml` like

```
worker:
  number: 3
  podManagementPolicy: Parallel
  image:
    repository: cheyang/horovod
    tag: gpu-tf-1.6.0
    pullPolicy: IfNotPresent
  resources:
    limits:
      nvidia.com/gpu: 1
    requests:
      nvidia.com/gpu: 1

master:
  image:
    repository: cheyang/horovod
    tag: gpu-tf-1.6.0
    pullPolicy: IfNotPresent
  args:
    - "mpiexec -n ${WORKERS} --hostfile /kubeflow/openmpi/assets/hostfile --mca orte_keep_fqdn_hostnames t --allow-run-as-root --display-map --tag-output --timestamp-output sh -c 'python /examples/tensorflow_mnist.py'"
```

To deploy Horovod without GPU, you can create `values.yaml` like 

```
worker:
  number: 3
  podManagementPolicy: Parallel
  image:
    repository: cheyang/horovod
    tag: gpu-tf-1.6.0
    pullPolicy: IfNotPresent

master:
  image:
    repository: cheyang/horovod
    tag: gpu-tf-1.6.0
    pullPolicy: IfNotPresent
  args:
    - "mpiexec -n 3 --hostfile /horovod/generated/hostfile --mca orte_keep_fqdn_hostnames t --allow-run-as-root --display-map --tag-output --timestamp-output sh -c 'LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-9.0/targets/x86_64-linux/lib/stubs python /examples/tensorflow_mnist.py'"
```



## Installing the Chart

To install the chart with the release name `mnist`:

```bash
$ helm install --values values.yaml --name mnist incubator/horovod
```

## Uninstalling the Chart

To uninstall/delete the `mnist` deployment:

```bash
$ helm delete mnist
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
