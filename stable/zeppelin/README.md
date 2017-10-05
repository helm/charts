# Zeppelin Chart

[Zeppelin](https://zeppelin.apache.org/) is a web based notebook for interactive data analytics with Spark, SQL and Scala.

## Chart Details

## Installing the Chart

To install the chart:

```
$ helm install stable/zeppelin
```

## Configuration

The following tables lists the configurable parameters of the Zeppelin chart and their default values.

| Parameter                            | Description                                                       | Default                                                    |
| ------------------------------------ | ----------------------------------------------------------------- | ---------------------------------------------------------- |
| `zeppelin.image`                     | Zeppelin image                                                    | `dylanmei/zeppelin:{VERSION}`                              |
| `zeppelin.resources`                 | Resource limits and requests                                      | `limits.memory=4096Mi, limits.cpu=2000m`                   |
| `spark.driverMemory`                 | Memory used by [Spark driver](https://spark.apache.org/docs/latest/configuration.html#application-properties) (Java notation)  | `1g` |
| `spark.executorMemory`               | Memory used by [Spark executors](https://spark.apache.org/docs/latest/running-on-yarn.html) (Java notation)                    | `1g` |
| `spark.numExecutors`                 | Number of [Spark executors](https://spark.apache.org/docs/latest/running-on-yarn.html)                                         | `2`  |
| `hadoop.useConfigMap`                | Use external Hadoop configuration for Spark executors             | `false`                                                    |
| `hadoop.configMapName`               | Name of the hadoop config map to use (must be in same namespace)  | `hadoop-config`                                            |
| `hadoop.configPath`                  | Path in the Zeppelin image where the Hadoop config is mounted     | `/usr/hadoop-2.7.3/etc/hadoop`                             |

## Related charts

The [Hadoop](https://github.com/kubernetes/charts/tree/master/stable/hadoop) chart can be used to create a YARN cluster where Spark jobs are executed:

```
helm install -n hadoop stable/hadoop
helm install --set hadoop.useConfigMap=true,hadoop.configMapName=hadoop-hadoop stable/zeppelin
```

> Note that you may also want to set the `spark.numExecutors` value to match the number of yarn NodeManager replicas and the `executorMemory` value to half of the NodeManager memory limit.