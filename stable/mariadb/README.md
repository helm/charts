# MariaDB

[MariaDB](https://mariadb.org) is one of the most popular database servers in the world. It’s made by the original developers of MySQL and guaranteed to stay open source. Notable users include Wikipedia, Facebook and Google.

MariaDB is developed as open source software and as a relational database it provides an SQL interface for accessing data. The latest versions of MariaDB also include GIS and JSON features.

## TL;DR;

```bash
$ helm install stable/mariadb
```

## Introduction

This chart bootstraps a [MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/mariadb
```

The command deploys MariaDB on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the MariaDB chart and their default values.

|          Parameter          |                Description                 |                   Default                   |
| --------------------------- | ------------------------------------------ | ------------------------------------------- |
| `image`                     | MariaDB image                              | `bitnami/mariadb:{VERSION}`                 |
| `service.type`              | Kubernetes service type to expose          | `ClusterIP`                                 |
| `service.nodePort`          | Port to bind to for NodePort service type  | `nil`                                       |
| `service.annotations`       | Additional annotations to add to service   | `nil`                                       |
| `imagePullPolicy`           | Image pull policy.                         | `IfNotPresent`                              |
| `usePassword`               | Enable password authentication             | `true`                                      |
| `mariadbRootPassword`       | Password for the `root` user.              | Randomly generated                          |
| `mariadbUser`               | Username of new user to create.            | `nil`                                       |
| `mariadbPassword`           | Password for the new user.                 | `nil`                                       |
| `mariadbDatabase`           | Name for new database to create.           | `nil`                                       |
| `persistence.enabled`       | Use a PVC to persist data                  | `true`                                      |
| `persistence.existingClaim` | Use an existing PVC                        | `nil`                                       |
| `persistence.storageClass`  | Storage class of backing PVC               | `nil` (uses alpha storage class annotation) |
| `persistence.accessMode`    | Use volume as ReadOnly or ReadWrite        | `ReadWriteOnce`                             |
| `persistence.size`          | Size of data volume                        | `8Gi`                                       |
| `resources`                 | CPU/Memory resource requests/limits        | Memory: `256Mi`, CPU: `250m`                |
| `config`                    | Multi-line string for my.cnf configuration | `nil`                                       |
| `metrics.enabled`           | Start a side-car prometheus exporter       | `false`                                     |
| `metrics.image`             | Exporter image                             | `prom/mysqld-exporter`                      |
| `metrics.imageTag`          | Exporter image                             | `v0.10.0`                                   |
| `metrics.imagePullPolicy`   | Exporter image pull policy                 | `IfNotPresent`                              |
| `metrics.resources`         | Exporter resource requests/limit           | `nil`                                       |

The above parameters map to the env variables defined in [bitnami/mariadb](http://github.com/bitnami/bitnami-docker-mariadb). For more information please refer to the [bitnami/mariadb](http://github.com/bitnami/bitnami-docker-mariadb) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set mariadbRootPassword=secretpassword,mariadbUser=my-user,mariadbPassword=my-password,mariadbDatabase=my-database \
    stable/mariadb
```

The above command sets the MariaDB `root` account password to `secretpassword`. Additionally it creates a standard database user named `my-user`, with the password `my-password`, who has access to a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/mariadb
```

> **Tip**: You can use the default [values.yaml](values.yaml)

### Custom my.cnf configuration

The Bitnami MariaDB image allows you to provide a custom `my.cnf` file for configuring MariaDB.
This Chart uses the `config` value to mount a custom `my.cnf` using a [ConfigMap](http://kubernetes.io/docs/user-guide/configmap/).
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

helm install --name my-release -f mariadb-values.yaml stable/mariadb
```

## Consuming credentials

To connect to your database in your application, you can consume the credentials from the secret. For example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-app
spec:
  containers:
    - name: my-app
      image: bitnami/mariadb:latest
      env:
        - name: MARIADB_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: my-release-mariadb
              key: mariadb-root-password
      command: ["sh", "-c"]
      args:
      - mysql -h my-release-mariadb.default.svc.cluster.local -p$MARIADB_ROOT_PASSWORD -e 'show databases;'
  restartPolicy: Never

```

## Persistence

The [Bitnami MariaDB](https://github.com/bitnami/bitnami-docker-mariadb) image stores the MariaDB data and configurations at the `/bitnami/mariadb` path of the container.

The chart mounts a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) volume at this location. The volume is created using dynamic volume provisioning, by default. An existing PersistentVolumeClaim can be defined.

### Existing PersistentVolumeClaims

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart
```bash
$ helm install --set persistence.existingClaim=PVC_NAME postgresql
```

## Metrics

The chart can optionally start a metrics exporter endpoint on port `9104` for [prometheus](https://prometheus.io). The data exposed by the endpoint is intended to be consumed by a prometheus chart deployed within the cluster and as such the endpoint is not exposed outside the cluster.
