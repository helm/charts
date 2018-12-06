# Percona

[Percona Server](https://MySQL.org) for MySQL® is a free, fully compatible, enhanced, open source drop-in replacement for MySQL that provides superior performance, scalability and instrumentation. With over 3,000,000 downloads, Percona Server for MySQL's self-tuning algorithms and support for extremely high-performance hardware delivers excellent performance and reliability. 

Notable users include Netflix, Amazon Web Services, Alcatel-Lucent, and Smug Mug.

## Introduction

This chart, based off of the MySQL chart,  bootstraps a single node Percona Server deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/percona
```

The command deploys Percona Server on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

By default a random password will be generated for the root user. If you'd like to set your own password change the perconaRootPassword
in the values.yaml.

You can retrieve your root password by running the following command. Make sure to replace [YOUR_RELEASE_NAME]:

    printf $(printf '\%o' `kubectl get secret [YOUR_RELEASE_NAME]-percona -o jsonpath="{.data.mysql-root-password[*]}"`)

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Percona chart and their default values.

| Parameter                  | Description                        | Default                                                    |
| -----------------------    | ---------------------------------- | ---------------------------------------------------------- |
| `imageTag`                 | `percona` image tag.                 | Most recent release                                        |
| `imagePullPolicy`          | Image pull policy                  | `IfNotPresent`                                             |
| `perconaRootPassword`        | Password for the `root` user.      | `nil`                                                      |
| `perconaUser`                | Username of new user to create.    | `nil`                                                      |
| `perconaPassword`            | Password for the new user.         | `nil`                                                      |
| `perconaDatabase`            | Name for new database to create.   | `nil`                                                      |
| `persistence.enabled`      | Create a volume to store data      | false                                                       |
| `persistence.size`         | Size of persistent volume claim    | 8Gi RW                                                     |
| `persistence.storageClass` | Type of persistent volume claim    | nil  (uses alpha storage class annotation)                 |
| `persistence.accessMode`   | ReadWriteOnce or ReadOnly          | ReadWriteOnce                                              |
| `resources`                | CPU/Memory resource requests/limits | Memory: `256Mi`, CPU: `100m`                              |
| `nodeSelector`             | Node labels for pod assignment     | `{}`							|
| `tolerations`              | Node labels for pod assignment     | `[]`							|

Some of the parameters above map to the env variables defined in the [Percona Server DockerHub image](https://hub.docker.com/_/percona/).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set mysqlLRootPassword=secretpassword,mysqlUser=my-user,mysqlPassword=my-password,mysqlDatabase=my-database \
    stable/percona
```

The above command sets the MySQL `root` account password to `secretpassword`. Additionally it creates a standard database user named `my-user`, with the password `my-password`, who has access to a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/percona
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Percona Server](https://hub.docker.com/_/percona/) image stores the MySQL data and configurations at the `/var/lib/mysql` path of the container.

By default, an emptyDir volume is mounted at that location.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

You can change the values.yaml to enable persistence and use a PersistentVolumeClaim instead.
