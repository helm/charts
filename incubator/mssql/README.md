# Microsoft SQL Server on Linux

[SQL Server](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-overview) now runs on Linux! This latest release, SQL Server 2017 RC2, runs on Linux and is in many ways simply SQL Server. It’s the same SQL Server database engine, with many similar features and services regardless of your operating system.

## Introduction

This chart bootstraps a single node SQL Server deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/mssql
```

The command deploys SQL Server on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

By default a random password will be generated for the root user. If you'd like to set your own password change the saPassword
in the values.yaml.

You can retrieve your root password by running the following command. Make sure to replace [YOUR_RELEASE_NAME]:

    printf $(printf '\%o' `kubectl get secret --namespace {{ .Release.Namespace }} {{ template "fullname" . }} -o jsonpath="{.data.sa-password}" | base64 --decode; echo"`)

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the SQL Server chart and their default values.

| Parameter                  | Description                        | Default                                                    |
| -----------------------    | ---------------------------------- | ---------------------------------------------------------- |
| `imageTag`                 | `mssql` image tag.                 | Most recent release                                        |
| `imagePullPolicy`          | Image pull policy                  | `IfNotPresent`                                             |
| `saPassword`               | Password for the `sa` user.        | `nil`                                                                                                       |
| `persistence.enabled`      | Create a volume to store data      | true                                                       |
| `persistence.size`         | Size of persistent volume claim    | 8Gi RW                                                     |
| `persistence.storageClass` | Type of persistent volume claim    | nil  (uses alpha storage class annotation)                 |
| `persistence.accessMode`   | ReadWriteOnce or ReadOnly          | ReadWriteOnce                                              |
| `resources`                | CPU/Memory resource requests/limits | Memory: `256Mi`, CPU: `100m`                              |

Some of the parameters above map to the env variables defined in the [SQL Server DockerHub image](https://hub.docker.com/r/microsoft/mssql-server-linux/).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set saPassword=secretpassword \
    incubator/mssql
```

The above command sets the SQL Server `sa` account password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml incubator/mssql
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [SQL Server](https://hub.docker.com/r/microsoft/mssql-server-linux/) image stores the SQL Server data and configurations at the `/var/opt/mssql/data` path of the container.

By default a PersistentVolumeClaim is created and mounted into that directory. In order to disable this functionality
you can change the values.yaml to disable persistence and use an emptyDir instead.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*
