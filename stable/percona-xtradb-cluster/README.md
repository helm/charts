# Percona XtraDB Cluster

[Percona Server](https://MySQL.org) for MySQL® is a free, fully compatible, enhanced, open source drop-in replacement for MySQL that provides superior performance, scalability and instrumentation. With over 3,000,000 downloads, Percona Server for MySQL's self-tuning algorithms and support for extremely high-performance hardware delivers excellent performance and reliability.

Notable users include Netflix, Amazon Web Services, Alcatel-Lucent, and Smug Mug.

## Introduction

This chart, based off of the Percona chart (which in turn is based off the MySQL chart), bootstraps a multi-node Percona XtraDB Cluster deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

The chart exploits the deterministic nature of StatefulSet and KubeDNS to ensure the cluster bootstrap is performed in the correct order.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/percona-xtradb-cluster
```

The command deploys a Percona XtraDB Cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

The root password can only be used inside each `pod`.  You should set a default `mysqlDatabase`, `mysqlUser` and `mysqlPassword` in the values.yaml file.

By default an **insecure** password will be generated for the root and replication users. If you'd like to set your own password change the `mysqlRootPassword` or `xtraBackupPassword` respectively
in the values.yaml.

You can retrieve your root password (usable only via localhost in each pod) by running the following command. Make sure to replace [YOUR_RELEASE_NAME]:

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
| `image.repository`         | `percona-xtradb-cluster` image Repo.                 | 5.7.19 release                                        |
| `image.tag`                 | `percona-xtradb-cluster` image tag.                 | `percona/percona-xtradb-cluster` |
| `image.pullPolicy`          | Image pull policy                  | `IfNotPresent` |
| `replicas`                 | Number of pods to join the Percona XtraDB Cluster   | 3                                         |
| `allowRootFrom`            | Remote hosts to allow root access, set to `127.0.0.1` to disable remote root  | `%` |
| `mysqlRootPassword`        | Password for the `root` user.      | `not-a-secure-password`                                                      |
| `xtraBackupPassword`       | Password for the `xtrabackup` user. | `replicate-my-data` |
| `mysqlUser`                | Username of new user to create.    | `nil`                                                      |
| `mysqlPassword`            | Password for the new user.         | `nil`                                                      |
| `mysqlDatabase`            | Name for new database to create.   | `nil`                                                      |
| `persistence.enabled`      | Create a volume to store data      | false                                                       |
| `persistence.size`         | Size of persistent volume claim    | 8Gi RW                                                     |
| `persistence.storageClass` | Type of persistent volume claim    | nil  (uses alpha storage class annotation)                 |
| `persistence.accessMode`   | ReadWriteOnce or ReadOnly          | ReadWriteOnce                                              |
| `tolerations`              | Node labels for pod assignment     | `[]`							|
| `nodeSelector`             | Node labels for pod assignment     | `{}`							|
| `podAnnotations`           | Pod annotations                    | `{}`                                                       |
| `resources`                | CPU/Memory resource requests/limits | Memory: `256Mi`, CPU: `100m`                              |
| `configFiles` | files to write to /etc/mysql/conf.d | see values.yaml |
| `ssl.enabled`                                | Setup and use SSL for MySQL connections                                                      | `false`                                              |
| `ssl.secret`                                 | Name of the secret containing the SSL certificates                                           | mysql-ssl-certs                                      |
| `ssl.certificates[0].name`                   | Name of the secret containing the SSL certificates                                           | `nil`                                                |
| `ssl.certificates[0].ca`                     | CA certificate                                                                               | `nil`                                                |
| `ssl.certificates[0].cert`                   | Server certificate (public key)                                                              | `nil`                                                |
| `ssl.certificates[0].key`                    | Server key (private key)                                                                     | `nil`                                                |
| `logTail` | if set to true runs a container to tail /var/log/mysqld.log in the pod | true |
| `metricsExporter.enabled` | if set to true runs a [mysql metrics exporter](https://github.com/prometheus/mysqld_exporter) container in the pod | false |
| `metricsExporter.commandOverrides` | Overrides default docker command for metrics exporter | `[]` |
| `metricsExporter.argsOverrides`   | Overrides default docker args for metrics exporter     | `[]` |
| `podDisruptionBudget` | Pod disruption budget | `{enabled: false, maxUnavailable: 1}` |


Some of the parameters above map to the env variables defined in the [Percona XtraDB Cluster DockerHub image](https://hub.docker.com/r/percona/percona-xtradb-cluster/).

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set mysqlRootPassword=secretpassword,mysqlUser=my-user,mysqlPassword=my-password,mysqlDatabase=my-database \
    stable/percona-xtradb-cluster
```

The above command sets the MySQL `root` account password to `secretpassword`. Additionally it creates a standard database user named `my-user`, with the password `my-password`, who has access to a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/percona-xtradb-cluster
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The [Percona XtraDB Cluster DockerHub image](https://hub.docker.com/r/percona/percona-xtradb-cluster/) stores the MySQL data and configurations at the `/var/lib/mysql` path of the container.

By default, an emptyDir volume is mounted at that location.

> *"An emptyDir volume is first created when a Pod is assigned to a Node, and exists as long as that Pod is running on that node. When a Pod is removed from a node for any reason, the data in the emptyDir is deleted forever."*

You can change the values.yaml to enable persistence and use a PersistentVolumeClaim instead.

## SSL

This chart supports configuring MySQL to use [encrypted connections](https://dev.mysql.com/doc/refman/5.7/en/encrypted-connections.html) with TLS/SSL certificates provided by the user. This is accomplished by storing the required Certificate Authority file, the server public key certificate, and the server private key as a Kubernetes secret. The SSL options for this chart support the following use cases:

* Manage certificate secrets with helm
* Manage certificate secrets outside of helm

## Manage certificate secrets with helm

Include your certificate data in the `ssl.certificates` section. For example:

```
ssl:
  enabled: false
  secret: mysql-ssl-certs
  certificates:
  - name: mysql-ssl-certs
    ca: |-
      -----BEGIN CERTIFICATE-----
      ...
      -----END CERTIFICATE-----
    cert: |-
      -----BEGIN CERTIFICATE-----
      ...
      -----END CERTIFICATE-----
    key: |-
      -----BEGIN RSA PRIVATE KEY-----
      ...
      -----END RSA PRIVATE KEY-----
```

> **Note**: Make sure your certificate data has the correct formatting in the values file.

## Manage certificate secrets outside of helm

1. Ensure the certificate secret exist before installation of this chart.
2. Set the name of the certificate secret in `ssl.secret`.
3. Make sure there are no entries underneath `ssl.certificates`.

To manually create the certificate secret from local files you can execute:
```
kubectl create secret generic mysql-ssl-certs \
  --from-file=ca.pem=./ssl/certificate-authority.pem \
  --from-file=server-cert.pem=./ssl/server-public-key.pem \
  --from-file=server-key.pem=./ssl/server-private-key.pem
```
> **Note**: `ca.pem`, `server-cert.pem`, and `server-key.pem` **must** be used as the key names in this generic secret.

If you are using a certificate your configurationFiles must include the three ssl lines under [mysqld]

```
[mysqld]
    ssl-ca=/ssl/ca.pem
    ssl-cert=/ssl/server-cert.pem
    ssl-key=/ssl/server-key.pem
```
