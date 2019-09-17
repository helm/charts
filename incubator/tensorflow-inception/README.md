# Tensorflow Inception Model Chart

TensorFlow is an open source software library for numerical computation using data flow graphs.

* https://www.tensorflow.org/

My hope was to make TensorFlow more accessible by simplifying the following document -- https://tensorflow.github.io/serving/serving_inception.html

## Chart Details
This chart will do the following:

* 1 x TensorFlow inception model server on an external LoadBalancer

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-release incubator/tensorflow-inception
```

## Configuration

The following table lists the configurable parameters of the TensorFlow inception chart and their default values.


| Parameter               | Description                        | Default                                                    |
| ----------------------- | ---------------------------------- | ---------------------------------------------------------- |
| `image.repository`          | Container image name               | `quay.io/thomasjungblut/tfs-inception`                              |
| `image.tag`       | Container image tag                | `tfs-1.8.0-cpu`                                                          |
| `replicas`       | k8s deployment replicas            | `1`                                                               |
| `component`      | k8s selector key                   | `tensorflow-inception`                                            |
| `resources`      | Set the resource to be allocated and allowed for the Pods                   | `{}`                                            |
| `servicePort`    | k8s service port                   | `9090`                                                            |
| `containerPort`  | Container listening port           | `9090`                                                            |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

> **Note**: For the GPU version, use `image.tag=tfs-1.8.0-gpu`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/tensorflow-inception
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Example
```bash
docker run -v ~/Downloads:/downloads quay.io/lachie83/inception_serving /serving/bazel-bin/tensorflow_serving/example/inception_client --server=$INCEPTION_SERVICE_IP:9090 --image=/downloads/dog.jpg
D1028 17:07:30.650550118       7 ev_posix.c:101]             Using polling engine: poll
outputs {
  key: "classes"
  value {
    dtype: DT_STRING
    tensor_shape {
      dim {
        size: 1
      }
      dim {
        size: 5
      }
    }
    string_val: "golden retriever"
    string_val: "cocker spaniel, English cocker spaniel, cocker"
    string_val: "clumber, clumber spaniel"
    string_val: "tennis ball"
    string_val: "Labrador retriever"
  }
}
outputs {
  key: "scores"
  value {
    dtype: DT_FLOAT
    tensor_shape {
      dim {
        size: 1
      }
      dim {
        size: 5
      }
    }
    float_val: 9.7533788681
    float_val: 6.67022132874
    float_val: 6.18963956833
    float_val: 5.90754127502
    float_val: 5.4464302063
  }
}

E1028 17:07:33.565394639       7 chttp2_transport.c:1810]    close_transport: {"created":"@1477674453.565348591","description":"FD shutdown","file":"src/core/lib/iomgr/ev_poll_posix.c","file_line":427}
```
