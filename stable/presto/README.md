# ⚠️ Repo Archive Notice

As of Nov 13, 2020, charts in this repo will no longer be updated.
For more information, see the Helm Charts [Deprecation and Archive Notice](https://github.com/helm/charts#%EF%B8%8F-deprecation-and-archive-notice), and [Update](https://helm.sh/blog/charts-repo-deprecation/).

# Presto Chart

[Prestosql](https://prestosql.io/) is an open source distributed SQL query engine for running interactive analytic queries against data sources of all sizes ranging from gigabytes to petabytes.

## DEPRECATION NOTICE

This chart is deprecated and no longer supported.

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
