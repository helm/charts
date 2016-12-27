Minio
=====

[Minio](https://minio.io) is a lightweight, AWS S3 compatible object storage server. It is best suited for storing unstructured data such as photos, videos, log files, backups, VM and container images. Size of an object can range from a few KBs to a maximum of 5TB.

Minio server is light enough to be bundled with the application stack, similar to NodeJS, Redis and MySQL. Read more about Minio [here](https://docs.minio.io/).

Introduction
------------

This chart bootstraps a single node Minio deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Prerequisites
-------------

-	Kubernetes 1.4+ with Beta APIs enabled
-	PV provisioner support in the underlying infrastructure

Installing the Chart
--------------------

Install this chart using:

```bash
$ helm install stable/minio
```

The command deploys Minio on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

### Release name

An instance of a chart running in a Kubernetes cluster is called a release. Each release is identified by a unique name within the cluster. Helm automatically assigns a unique release name after installing the chart. You can also set your preferred name by:

```bash
$ helm install --name my-release stable/minio
```

### Access and Secret keys

By default a pre-generated access and secret key will be used. To override the default keys, pass the access and secret keys as arguments to helm install.

```bash
$ helm install --set accessKey=myaccesskey,secretKey=mysecretkey \
    stable/minio
```

Alternately, you may change the access and secret keys in the [values.yaml](values.yaml) file before installing the Chart.

Uninstalling the Chart
----------------------

Assuming your release is named as `my-release`, delete it using the command:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

Configuration
-------------

The following tables lists the configurable parameters of the Minio chart and their default values.

| Parameter                  | Description                         | Default                                                 |
|----------------------------|-------------------------------------|---------------------------------------------------------|
| `image`                    | Minio image name                    | `minio/minio`                                           |
| `imageTag`                 | Minio image tag. Possible values listed [here](https://hub.docker.com/r/minio/minio/tags/).| `latest`|
| `imagePullPolicy`          | Image pull policy                   | `Always`                                                |
| `accessKey`                | Default access key                  | `AKIAIOSFODNN7EXAMPLE`                                  |
| `secretKey`                | Default secret key                  | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`              |
| `configPath`               | Default config file location        | `~/.minio`                                              |
| `mountPath`                | Default mount location for persistent drive| `/export`                                        |
| `serviceType`              | Kubernetes service type             | `ClusterIP`                                             |
| `servicePort`              | Kubernetes port where service is exposed| `9000`                                              |
| `persistence.enabled`      | Use persistent volume to store data | `true`                                                  |
| `persistence.size`         | Size of persistent volume claim     | `10Gi RW`                                               |
| `persistence.storageClass` | Type of persistent volume claim     | `generic`                                               |
| `persistence.accessMode`   | ReadWriteOnce or ReadOnly           | `ReadWriteOnce`                                         |
| `resources`                | CPU/Memory resource requests/limits | Memory: `256Mi`, CPU: `100m`                            |

Some of the parameters above map to the env variables defined in the [Minio DockerHub image](https://hub.docker.com/r/minio/minio/).

You can specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set persistence.size=100Gi \
    stable/minio
```

The above command deploys Minio server with a 100Gi backing persistent volume.

Alternately, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example:

```bash
$ helm install --name my-release -f values.yaml stable/minio
```

> **Tip**: You can use the default [values.yaml](values.yaml)

Persistence
-----------

This chart creates a PersistentVolumeClaim and mounts corresponding persistent volume to default location `/export`. You'll need physical storage available in the Kubernetes cluster for this to work. If you'd rather use `emptyDir`, disable PersistentVolumeClaim by:

```bash
$ helm install --set persistence.enabled=false stable/minio
```

Alternately, you can set the `persistence.enabled` to `false` in the [values.yaml](values.yaml) to disable persistence.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

TODO:
-----

-	Erasure encoding and distributed server
-	Configmap for the Minio config
