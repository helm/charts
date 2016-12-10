Minio
=====

[Minio](https://minio.io) is a distributed S3-compatible object storage server built for cloud applications and devops.

Introduction
------------

This chart bootstraps a single node Minio deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Prerequisites
-------------

-	Kubernetes 1.4+ with Beta APIs enabled
-	PV provisioner support in the underlying infrastructure

Installing the Chart
--------------------

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/minio
```

The command deploys Minio on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

By default a pre-generated Access Key and Secret will be used. If you'd like to set your own password change the AccessKey and SecretKey in the values.yaml.

Uninstalling the Chart
----------------------

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

Configuration
-------------

The following tables lists the configurable parameters of the Minio chart and their default values.

| Parameter                  | Description                         | Default                                                 |
|----------------------------|-------------------------------------|---------------------------------------------------------|
| `image`                    | `minio` image.                      | `minio/minio` The official release on Docker Hub        |
| `imageTag`                 | `minio` image tag.                  | The latest release                                      |
| `imagePullPolicy`          | Image pull policy                   | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `ServiceType`              | Kubernetes Service Type             | `ClusterIP`                                             |
| `ServicePort`              | Kuberntes Service Port              | `9000`                                                  |
| `AccessKey`                | Default Access Key                  | `AKIAIOSFODNN7EXAMPLE`                                  |
| `SecretKey`                | Default Secret Key                  | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`              |
| `persistence.enabled`      | Create a volume to store data       | true                                                    |
| `persistence.size`         | Size of persistent volume claim     | 8Gi RW                                                  |
| `persistence.storageClass` | Type of persistent volume claim     | generic                                                 |
| `persistence.accessMode`   | ReadWriteOnce or ReadOnly           | ReadWriteOnce                                           |
| `resources`                | CPU/Memory resource requests/limits | Memory: `256Mi`, CPU: `100m`                            |

Some of the parameters above map to the env variables defined in the [Minio DockerHub image](https://hub.docker.com/r/minio/minio/).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set AccessKey=myaccesskey,SecretKey=mysecretkey \
    stable/minio
```

The above command sets the Minio Access Key to `myaccesskey` and Secret Key to `mysecretkey`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/minio
```

> **Tip**: You can use the default [values.yaml](values.yaml)

Persistence
-----------

The [Minio](https://hub.docker.com/r/minio/minio/) image stores the Minio data at the `/export` path of the container.

By default a PersistentVolumeClaim is created and mounted into that directory. In order to disable this functionality you can change the values.yaml to disable persistence and use an emptyDir instead.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

TODO:
-----

-	Erasure encoding and distributed server
-	Configmap for the Minio config
