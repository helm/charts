# Presto Chart

[Prestosql](https://prestosql.io/) is an open source distributed SQL query engine for running interactive analytic queries against data sources of all sizes ranging from gigabytes to petabytes.

## Chart Details

This chart will do the following:

* Install a single server which acts both as coordinator and worker
* Install a configmap for it
* Install a service

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/presto
```

## Configuration

Configurable values are documented in the `values.yaml`:

| Parameter                               | Description                                                                 | Default                  |
|-----------------------------------------|-----------------------------------------------------------------------------|--------------------------|
| `server.workers`                        | Numbers of prestosql worker nodes.                                          | `2`                      |
| `server.node.environment`               | The name of the environment.                                                | `production`             |
| `server.node.dataDir`                   | The location (filesystem path) of the data directory.                       | `/data/presto`           |
| `server.note.pluginDir`                 | The location of the plugin directory.                                       | `/usr/lib/presto/plugin` |
| `server.log.presto.level`               | The minimum log level of named logger `io.prestosql`.                       | `INFO`                   |
| `server.config.path`                    | The location of customize configuration.                                    | `/usr/lib/presto/etc`    |
| `server.config.http.port`               | The port number of coordinator service                                      | `8080`                   |
| `server.config.query.maxMemory`         | The maximum amount of distributed memory, that a query may use.             | `4GB`                    |
| `server.config.query.maxMemoryPerNode`  | The maximum amount of user memory, that a query may use on any one machine. | `1GB`                    |
| `server.catalog.secretName`             | The name of a secret contains properties files for catalog                  | nil                      |
| `server.catalog.data`                   | The properties file contents for catalog                                    | nil                      |
| `server.jvm.maxHeapSize`                | The value for JVM option `-Xmx`                                             | `8G`                     |
| `server.jvm.gcMethod.type`              | Portion of the value for JVM option `-XX:`                                  | `UseG1GC`                |
| `server.jvm.gcMethod.g1.heapRegionSize` | The value for JVM option `-XX:G1HeapRegionSize=`                            | `32M`                    |
| `image.repository`                      | `prestosql` image repository.                                               | `prestosql/presto`       |
| `image.tag`                             | `prestosql` image tag.                                                      | `329`                    |
| `image.securityContext.runAsUser`       | The `uid` of `prestosql` image repository.                                  | `1000`                   |
| `image.securityContext.runAsGroup`      | The `gid` of `prestosql` image repository.                                  | `1000`                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release stable/presto -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Popluate catalog properties

You can choose to use either a secret or inline properties to configure [catalog properties](https://prestosql.io/docs/current/installation/deployment.html#catalog-properties).

Option 1: Given secret like:

```YAML
apiVersion: v1
kind: Secret
metadata:
    name: prestosql-catalog-properties
data:
    mysql.properties: <base64-encoded-properties-file>
    postgresql.properties: <base64-encoded-properties-file>
```

Specify the parameter using the `--set server.catalog.secretName=prestosql-catalog-properties` argument to `helm install`.

Option 2: Uses inline properties in a YAML file that specifies the values for the parameters. Given below file `values-catalog-data.yaml`:

```YAML
server:
  catalog:
    data: 
      mysql.properties: |
        connector.name=mysql
        foo=bar1
      postgresql.properties: |
        connector.name=postgresql
        foo=bar2
```

```bash
$ helm install my-release stable/presto -f values-catalog-data.yaml
```

**Notices**:

1. When both `server.catalog.secretName` and `server.catalog.data` are provided, only `server.catalog.serverName` will take effect.
1. When using `server.catalog.data`, it may expose sensitive info like db credentials in values file.