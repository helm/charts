# Hadoop Chart

[Hadoop](https://hadoop.apache.org/) is a framework for running large scale distriubted applications.

This chart is primarily intended to be used for YARN and MapReduce job execution where HDFS is just used as a means to transport small artifacts within the framework and not for a distributed filesystem. Data should be read from cloud based datastores such as Google Cloud Storage, S3 or Swift.

## Chart Details

## Installing the Chart

To install the chart with the release name `hadoop` that utilizes 50% of the available node resources:

```
$ helm install --name hadoop $(stable/hadoop/tools/calc_resources.sh 50) stable/hadoop
```

The optional [`calc_resources.sh`](./tools/calc_resources.sh) script is used as a convienince helper to set the `yarn.numNodes`, and `yarn.nodeManager.resources` appropriately to utilize all nodes in the Kubernetes cluster and a given percentage of their resources. For example, with a 3 node `n1-standard-4` GKE cluster and an argument of `50`, this would create 3 NodeManager pods claiming 2 cores and 7.5Gi of memory.

## Configuration

The following tables lists the configurable parameters of the Hadoop chart and their default values.

| Parameter                            | Description                                | Default                                                    |
| -------------------------------      | -------------------------------            | ---------------------------------------------------------- |
| `hadoop.image`                              | Hadoop image ([source](https://github.com/Comcast/kube-yarn/tree/master/image))                            | `danisla/hadoop:{VERSION}`                              |
| `hadoop.version`                    | Version of hadoop libaries being used                          | `{VERSION}`                                             |
| `yarn.numNodes`                  | Number of YARN NodeManager replicas                    | `2`                                                     |
| `yarn.nodeManager.resources`                  | Resource limits and requests for YARN NodeManager pods                    | `limits.memory=2048Mi, limits.cpu=1000m`                                                     |

## Related charts

The [Zeppelin Notebook](https://github.com/kubernetes/charts/tree/master/stable/zeppelin) chart can use the hadoop config for the hadoop cluster and use the YARN executor:

```
helm install --set hadoop.useConfigMap=true stable/zeppelin
```

# References

- Original K8S Hadoop adaptation this chart was derived from: https://github.com/Comcast/kube-yarn
