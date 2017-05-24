# MariaDB Galera Cluster

[MariaDB](https://mariadb.org/) is one of the most popular database servers in the world. It’s made by the original developers of MySQL and guaranteed to stay open source. Notable users include Wikipedia, Facebook and Google.

[Galera Cluster](http://galeracluster.com/) is a multi-master solution for MariaDB which provides an easy-to-use, high-availability solution for MariaDB based databases.

## Introduction

This chart bootstraps a [MariaDB Galera Cluster](https://github.com/adfinis-sygroup/openshift-mariadb-galera) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.5+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release incubator/mariadb-galera
```

The command deploys MariaDB Galera Cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the MariaDB chart and their default values.

| Parameter                  | Description                                | Default                                                    |
| -----------------------    | ----------------------------------         | ---------------------------------------------------------- |
| `image`                    | MariaDB Galera image                       | `adfinissygroup/k8s-mariadb-galera-centos:v002`            |
| `imagePullPolicy`          | Image pull policy.                         | `IfNotPresent`                                             |
| `mysqlRootPassword`        | Password for the `root` user.              | _random 16 character alphanumeric string_                  |
| `mysqlUser`                | Username of new user to create.            | `nil`                                                      |
| `mysqlPassword`            | Password for the new user.                 | `nil`                                                      |
| `mysqlDatabase`            | Name for new database to create.           | `nil`                                                      |
| `replicas`                 | Number of replicas to deploy               | 3                                                          |
| `persistence.enabled`      | Use a PVC to persist data                  | `true`                                                     |
| `persistence.storageClass` | Storage class of backing PVC               | `nil` (uses alpha storage class annotation)                |
| `persistence.accessMode`   | Use volume as ReadOnly or ReadWrite        | `ReadWriteOnce`                                            |
| `persistence.size`         | Size of data volume                        | `8Gi`                                                      |
| `resources`                | CPU/Memory resource requests/limits        | Memory: `256Mi`, CPU: `250m`                               |
| `config`                   | Multi-line string for my.cnf configuration | `nil`                                                      |

The above parameters map to the env variables defined in the [adfinis-sygroup/openshift-mariadb-galera](https://github.com/adfinis-sygroup/openshift-mariadb-galera).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set mysqlRootPassword=secretpassword,mysqlUser=my-user,mysqlPassword=my-password,mysqlDatabase=my-database \
    stable/mariadb-galera
```

The above command sets the MariaDB `root` account password to `secretpassword`. Additionally it creates a standard database user named `my-user`, with the password `my-password`, who has access to a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/mariadb-galera
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Random MariaDB root password

If you don't configure a password for the MariaDB `root` user, `helm` will
generate a random one for you. You can get the configured password from the
created Kubernetes secret:

```bash
$ kubectl get secret ${release_name}-mariadb-galera  -o jsonpath='{.data.mysql-root-password}' | base64 -d
```

### Custom my.cnf configuration

The Adfinis SyGroup MariaDB Galera Cluster image allows you to provide a custom
`my_extra.cnf` file for configuring MariaDB.
This Chart uses the `config` value to mount a custom `my_extra.cnf` using a [ConfigMap](https://kubernetes.io/docs/user-guide/configmap/).
You can configure this by creating a YAML file that defines the `config` property as a multi-line string in the format of a `my.cnf` file.
For example:

```bash
cat > mariadb-values.yaml <<EOF
config: |-
  [mysqld]
  max_allowed_packet = 64M
  sql_mode=STRICT_ALL_TABLES
  ft_stopword_file=/etc/mysql/stopwords.txt
  ft_min_word_len=3
  ft_boolean_syntax=' |-><()~*:""&^'
  innodb_buffer_pool_size=2G
EOF

helm install --name my-release -f mariadb-values.yaml incubator/mariadb-galera
```

## Persistence

The [MariaDB Galera Chart](https://github.com/kubernetes/charts/) image stores the MariaDB data files at the `/var/lib/mysql` path of the container.

The chart mounts a [Persistent Volume](kubernetes.io/docs/user-guide/persistent-volumes/) at this location in every pod of the StatefulSet. The volume is either created using dynamic volume provisioning or must be created manually.
