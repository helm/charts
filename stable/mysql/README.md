# MySQL

[MySQL](https://MySQL.org) is one of the most popular database servers in the world. Notable users include Wikipedia, Facebook and Google.

## Introduction

This chart bootstraps a single node MySQL deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/mysql
```

The command deploys MySQL on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

By default a random password will be generated for the root user. If you'd like to set your own password change the mysqlRootPassword
in the values.yaml.

You can retrieve your root password by running the following command. Make sure to replace [YOUR_RELEASE_NAME]:

    printf $(printf '\%o' `kubectl get secret [YOUR_RELEASE_NAME]-mysql -o jsonpath="{.data.mysql-root-password[*]}"`)

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the MySQL chart and their default values.

| Parameter                            | Description                               | Default                                              |
| ------------------------------------ | ----------------------------------------- | ---------------------------------------------------- |
| `imageTag`                           | `mysql` image tag.                        | Most recent release                                  |
| `imagePullPolicy`                    | Image pull policy                         | `IfNotPresent`                                       |
| `mysqlRootPassword`                  | Password for the `root` user.             | `nil`                                                |
| `mysqlUser`                          | Username of new user to create.           | `nil`                                                |
| `mysqlPassword`                      | Password for the new user.                | `nil`                                                |
| `mysqlDatabase`                      | Name for new database to create.          | `nil`                                                |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated  | 30                                                   |
| `livenessProbe.periodSeconds`        | How often to perform the probe            | 10                                                   |
| `livenessProbe.timeoutSeconds`       | When the probe times out                  | 5                                                    |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed. | 1 |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | 3 |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated | 5                                                    |
| `readinessProbe.periodSeconds`       | How often to perform the probe            | 10                                                   |
| `readinessProbe.timeoutSeconds`      | When the probe times out                  | 1                                                    |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed. | 1 |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.   | 3 |
| `persistence.enabled`                | Create a volume to store data             | true                                                 |
| `persistence.size`                   | Size of persistent volume claim           | 8Gi RW                                               |
| `persistence.storageClass`           | Type of persistent volume claim           | nil  (uses alpha storage class annotation)           |
| `persistence.accessMode`             | ReadWriteOnce or ReadOnly                 | ReadWriteOnce                                        |
| `persistence.existingClaim`          | Name of existing persistent volume        | `nil`                                                |
| `persistence.subPath`                | Subdirectory of the volume to mount       | `nil`                                                |
| `resources`                          | CPU/Memory resource requests/limits       | Memory: `256Mi`, CPU: `100m`                         |
| `configurationFiles`                 | List of mysql configuration files         | `nil`                                                |

Some of the parameters above map to the env variables defined in the [MySQL DockerHub image](https://hub.docker.com/_/mysql/).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set mysqlRootPassword=secretpassword,mysqlUser=my-user,mysqlPassword=my-password,mysqlDatabase=my-database \
    stable/mysql
```

The above command sets the MySQL `root` account password to `secretpassword`. Additionally it creates a standard database user named `my-user`, with the password `my-password`, who has access to a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/mysql
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [MySQL](https://hub.docker.com/_/mysql/) image stores the MySQL data and configurations at the `/var/lib/mysql` path of the container.

By default a PersistentVolumeClaim is created and mounted into that directory. In order to disable this functionality
you can change the values.yaml to disable persistence and use an emptyDir instead.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

## Custom MySQL configuration files

The [MySQL](https://hub.docker.com/_/mysql/) image accepts custom configuration files at the path `/etc/mysql/conf.d`. If you want to use a customized MySQL configuration, you can create your alternative configuration files by passing the file contents on the `configurationFiles` attribute. Note that according to the MySQL documentation only files ending with `.cnf` are loaded.

```yaml
configurationFiles:
  mysql.cnf: |-
    [mysqld]
    skip-host-cache
    skip-name-resolve
    sql-mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
  mysql_custom.cnf: |-
    [mysqld]
```
