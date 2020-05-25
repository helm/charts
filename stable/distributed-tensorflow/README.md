# Distributed TensorFlow

TensorFlow is an open source software library for numerical computation using data flow graphs, and it supports distributed computing, allowing 'data parallel' or 'model parallel' on different servers. This means data scientists can now scale out distributed training to 100s of GPUs using TensorFlow.

-  https://www.tensorflow.org
-  https://www.tensorflow.org/deploy/distributed

![](distributed-tf.jpg)

## Prerequisites

- Kubernetes cluster v1.12+

## Chart Details

This chart will create a TensorFlow cluster, and distribute a computation graph across that cluster.

## Installing the Chart

* To install the chart with the release name `mnist`:

  ```bash
  $ helm install mnist incubator/distributed-tensorflow
  ```

* To install with custom values via file:

  ```
  $ helm install --values values.yaml mnist incubator/distributed-tensorflow
  ```

  Below is an example of the custom value file values.yaml with GPU support.

  ```
  worker:
    number: 2
    podManagementPolicy: Parallel
    image:
      repository: dysproz/distributed-tf
      tag: 1.6.0-gpu
    port: 9090
    gpuCount: 1

  ps:
    number: 2
    podManagementPolicy: Parallel
    image:
      repository: dysproz/distributed-tf
      tag: 1.6.0
      pullPolicy: IfNotPresent
    port: 8080

  # optimize for training
  hyperparams:
    batchsize: 20
    learningrate: 0.001
    trainsteps: 10000
  ```

> Notice: you can check the details of docker image from [Docker hub](https://hub.docker.com/r/dysproz/distributed-tf/)

## Uninstalling the Chart

* To uninstall/delete the `mnist` deployment:

	```bash
	$ helm delete mnist
	```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Service Distributed Tensorflow
chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `worker.image.repository` | TensorFlow Worker Server's image repository | `dysproz/distributed-tf` |
| `worker.image.tag` | TensorFlow Worker Server's image tag | `gpu` |
| `worker.image.pullPolicy` | image pullPolicy for the  worker | `IfNotPresent` |
| `worker.gpuCount` | Set the gpu to be allocated and allowed for the Pods | `0` |
| `worker.env` | key-value environment variables | None |
| `ps.image.repository` | TensorFlow Parameter Server's image repository | `dysproz/distributed-tf` |
| `ps.image.tag` | TensorFlow Parameter Server's image tag | `1.7.0-gpu` |
| `ps.image.pullPolicy` | image pullPolicy for the  ps | `IfNotPresent` |
| `ps.env` | key-value environment variables | None |
| `volumes` | List of volumes defined in cluster (in standard k8s format) | host path to */tmp/mnist* |
| `volumeMounts` | Volumes mounted into Pods (in standard k8s format) | host path volume mounted into */tmp/mnist-log* |
| `hyperparams.batchsize` | batch size | `20` |
| `hyperparams.learningrate` | learning rate | `0.001` |
| `hyperparams.trainsteps` | train steps | `0` (continuous run) |
| `hyperparams.datadir` | data directory | None |
| `hyperparams.logdir` | logging directory | None |
| `hyperparams.hiddenunits` | Hidden units in neural network | None |
