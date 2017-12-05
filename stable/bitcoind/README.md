# Bitcoind

[Bitcoin](https://bitcoin.org/) uses peer-to-peer technology to operate with no central authority or banks; 
managing transactions and the issuing of bitcoins is carried out collectively by the network.

## Introduction

This chart bootstraps a single node Bitcoin deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/bitcoind
```

The command deploys bitcoind on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

By default a random password will be generated for the root user. If you'd like to set your own password change the bitcoindRootPassword
in the values.yaml.

You can retrieve your root password by running the following command. Make sure to replace [YOUR_RELEASE_NAME]:

    printf $(printf '\%o' `kubectl get secret [YOUR_RELEASE_NAME]-bitcoind -o jsonpath="{.data.bitcoind-root-password[*]}"`)

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the bitcoind chart and their default values.

| Parameter                  | Description                        | Default                                                    |
| -----------------------    | ---------------------------------- | ---------------------------------------------------------- |
| `imageTag`                 | `bitcoind` image tag.                 | Most recent release                                        |
| `imagePullPolicy`          | Image pull policy                  | `IfNotPresent`                                             |
| `bitcoindRootPassword`        | Password for the `root` user.      | `nil`                                                      |
| `bitcoindUser`                | Username of new user to create.    | `nil`                                                      |
| `bitcoindPassword`            | Password for the new user.         | `nil`                                                      |
| `bitcoindDatabase`            | Name for new database to create.   | `nil`                                                      |
| `persistence.enabled`      | Create a volume to store data      | true                                                       |
| `persistence.size`         | Size of persistent volume claim    | 8Gi RW                                                     |
| `persistence.storageClass` | Type of persistent volume claim    | nil  (uses alpha storage class annotation)                 |
| `persistence.accessMode`   | ReadWriteOnce or ReadOnly          | ReadWriteOnce                                              |
| `persistence.existingClaim`| Name of existing persistent volume | `nil`
| `persistence.subPath`      | Subdirectory of the volume to mount | `nil`
| `resources`                | CPU/Memory resource requests/limits | Memory: `256Mi`, CPU: `100m`                              |
| `configurationFiles`       | List of bitcoind configuration files  | `nil`

Some of the parameters above map to the env variables defined in the [bitcoind DockerHub image](https://hub.docker.com/_/bitcoind/).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set bitcoindLRootPassword=secretpassword,bitcoindUser=my-user,bitcoindPassword=my-password,bitcoindDatabase=my-database \
    stable/bitcoind
```

The above command sets the bitcoind `root` account password to `secretpassword`. Additionally it creates a standard database user named `my-user`, with the password `my-password`, who has access to a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/bitcoind
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [bitcoind](https://hub.docker.com/_/bitcoind/) image stores the bitcoind data and configurations at the `/var/lib/bitcoind` path of the container.

By default a PersistentVolumeClaim is created and mounted into that directory. In order to disable this functionality
you can change the values.yaml to disable persistence and use an emptyDir instead.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

## Custom bitcoind configuration files

The [bitcoind](https://hub.docker.com/_/bitcoind/) image accepts custom configuration files at the path `/etc/bitcoind/conf.d`. If you want to use a customized bitcoind configuration, you can create your alternative configuration files by passing the file contents on the `configurationFiles` attribute. Note that according to the bitcoind documentation only files ending with `.cfn` are loaded.

```yaml
configurationFiles:
  bitcoind.cnf: |-
    [bitcoindd]
    skip-host-cache
    skip-name-resolve
    sql-mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
  bitcoind_custom.cnf: |-
    [bitcoindd]
```
