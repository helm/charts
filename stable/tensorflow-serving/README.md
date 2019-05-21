# TensorFlow Serving

TensorFlow Serving is an open-source software library for serving machine learning models. We hope to demonstrate how to deploy a generic TensorFlow Model Server and serve a model from distributed storage instead of baking into the image like [TensorFlow inception](../../incubator/tensorflow-inception/README.md). 

For more information,
[visit the project on github](https://github.com/tensorflow/serving).

## Prerequisites

- Kubernetes cluster v1.8+ 
- Because TensorFlow Serving needs model in persistent storage, you have to put your servable model in  NFS (Network File System) or
HDFS (Hadoop Distributed File System), AWS S3 (Simple Storage Service) or Google Cloud Storage. Here is a sample for NAS storage.


## Copy a Model in NAS Storage


*  create `/serving` directory in the NFS server side, take `10.244.1.4` as example

```
mkdir /nfs
mount -t nfs -o vers=4.0 10.244.1.4:/ /nfs
mkdir -p /nfs/serving
umount /nfs
```

* Put the mnist model into NAS

```
mkdir /serving
mount -t nfs -o vers=4.0 10.244.1.4:/serving /serving
mkdir -p /serving/model
cd /serving/model
curl -O https://raw.githubusercontent.com/kubernetes/charts/master/stable/tensorflow-serving/models/mnist-export.tar.gz
tar -xzvf mnist-export.tar.gz
rm -rf mnist-export.tar.gz
cd /
```

* You will see that the contents of the model are stored in the  directory. This is the first version of the model that we will serve.

```
tree /serving/model/mnist
/serving/model/mnist
└── 1
    ├── saved_model.pb
    └── variables
        ├── variables.data-00000-of-00001
        └── variables.index

umount /serving
```

## Create Persistent Volume

Creating Persistent Volume with configuration like below

```
--- 
apiVersion: v1
kind: PersistentVolume
metadata: 
  labels: 
    model: mnist
  name: pv-nas-mnist
spec:
  persistentVolumeReclaimPolicy: Retain
  accessModes: 
    - ReadWriteMany
  capacity: 
    storage: 5Gi
  nfs:
  	# FIXME: use the right IP
    server: 10.244.1.4
    path: "/serving/model/mnist"
```

## Prepare values.yaml

* To deploy with GPU, you can create `values.yaml` like

```
---
modelName: "mnist"
modelBasePath: "/serving/model/mnist"
image: "cheyang/tf-model-server-gpu:1.4"
persistence: 
  mountPath: /serving/model/mnist
  pvc: 
    matchLabels: 
      model: mnist
    storage: 5Gi
resources:
  limits:
    nvidia.com/gpu: 1
```

* To deploy without GPU, you can create `values.yaml` like 

```
---
modelName: "mnist"
modelBasePath: "/serving/model/mnist"
image: "cheyang/tf-model-server:1.4"
persistence: 
  mountPath: /serving/model/mnist
  pvc: 
    matchLabels: 
      model: mnist
    storage: 5Gi
```

## Installing the Chart

To install the chart with the release name `mnist`:

```bash
$ helm install --values values.yaml --name mnist stable/tensorflow-serving
```

## Uninstalling the Chart

To uninstall/delete the `mnist` deployment:

```bash
$ helm delete mnist
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following table lists the configurable parameters of the Service Tensorflow Serving
chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image` | TensorFlow Serving image | `cheyang/tf-model-server-gpu:1.4`, the docker file is [Tensorflow Serving Dockerfile](https://github.com/kubeflow/kubeflow/tree/master/components/k8s-model-server/images) |
| `imagePullPolicy` | `imagePullPolicy` for the service mnist | `IfNotPresent` |
| `port` | Tensorflow Serving port | `9090` |
| `serviceType` | The service type which supports NodePort, LoadBalancer | `LoadBalancer` |
|`replicas`| K8S deployment replicas | `1` |
|`modelName`|  The model name | `mnist`|
|`modelBasePath`| The model base path | `/serving/model/mnist"` |
|`mountPath`| the mount path inside the container | `/serving/model/mnist` |
|`persistence.enabled` | enable pvc for the tensorflow serving | `false` |
|`persistence.size`| the storage size to request | `5Gi` |
|`persistence.matchLabels`| the selector for pv | `{}` |



