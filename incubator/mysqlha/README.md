# MySQL

[Helm](https://helm.sh/) chart to deploy a multi-pod MySQL master-slave deployment [Kubernetes](http://kubernetes.io) cluster. Work was largely inspired by this [tutorial](https://kubernetes.io/docs/tutorials/stateful-application/run-replicated-stateful-application/).

## Usage

### Install 

To install the chart with the release name `my-release`:

```bash
$ git@github.com:jpoon/mysql-master-slave.git
$ cd mysql-master-slave
$ helm install --name my-release .
```

The command deploys MySQL cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

### Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

## Configuration

The following tables lists the configurable parameters of the MySQL chart and their default values.

| Parameter                  | Description                        | Default                                                    |
| -----------------------    | ---------------------------------- | ---------------------------------------------------------- |
| `imageTag`                 | `mysql` image tag.                 | Most recent release                                        |
| `mysqlRootPassword`        | Password for the `root` user.      | `nil`                                                      |
| `mysqlUser`                | Username of new user to create.    | `nil`                                                      |
| `mysqlPassword`            | Password for the new user.         | Randomly generated                                         |
| `mysqlReplicationUser`     | Username for replication user      | `repl`                                                     |
| `mysqlReplicationPassword` | Password for replication user.     | Randomly generated                                         |
| `persistence.enabled`      | Create a volume to store data      | true                                                       | 
| `persistence.size`         | Size of persistent volume claim    | 10Gi                                                       |
| `persistence.storageClass` | Type of persistent volume claim    | fast                                                       |
| `persistence.accessMode`   | ReadWriteOnce or ReadOnly          | ReadWriteOnce                                              |
| `resources`                | CPU/Memory resource requests/limits | Memory: `128Mi`, CPU: `100m`                              |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,
