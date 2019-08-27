# Apache Knox Chart

[Apache Knox](https://knox.apache.org/) is an Application Gateway for interacting with the REST APIs and UIs of Apache Hadoop deployments. This chart is primarily intended to access HDFS from outside a Kubernetes cluster using simple REST APIs.

## Installing the Chart (requires an existing [Hadoop](../hadoop/) deployment)

Make sure that your Hadoop installation has WebHDFS enabled (by setting `hdfs.webhdfs.enabled` to `true` when using [stable/hadoop](../hadoop)).

To install the chart with the release name `knox`:

```
$ helm install --name knox stable/knox
```

For correctly proxying to your HDFS instance, set `knox.hadoop.nameNodeUrl`, `knox.hadoop.resourceManagerUrl`, and `knox.hadoop.webHdfsUrl`. Example: 

```
$ helm install --name knox stable/knox \
		--set "knox.hadoop.nameNodeUrl=hdfs://your-namenode-svc:9000/"  \
		--set "knox.hadoop.resourceManagerUrl=http://your-resource-mgr-svc:8088/ws" \
		--set "knox.hadoop.webHdfsUrl=http://your-namenode-svc:50070/webhdfs"
```

## Configuration

The following table lists the configurable parameters of the Apache Knox chart and their default values.

| Parameter                        | Description                              | Default                                                                                  |
| -------------------------------- | ---------------------------------------- | ---------------------------------------------------------------------------------------- |
| `knox.image`                     | Docker image for Apache Knox             | [farberg/apache-knox-docker:latest](https://hub.docker.com/r/farberg/apache-knox-docker) |
| `knox.servicetype`               | Type of service exposure for Apache Knox | `LoadBalancer`                                                                           |
| `knox.hadoop.nameNodeUrl`        | URL to Hadoop's name node                | `hdfs://nn:9000/webhdfs`                                                                 |
| `knox.hadoop.resourceManagerUrl` | URL to Hadoop's Resource Manager         | `http://rm:8088/ws`                                                                      |
| `knox.hadoop.webHdfsUrl`         | URL to Hadoop's webhdfs                  | `http://nn:50070/webhdfs`                                                                |
| `knox.users.admin.pw`            | Password for user `admin`                | `admin-password`                                                                         |
| `knox.users.sam.pw`              | Password for user `sam`                  | `sam-password`                                                                           |
| `knox.users.tom.pw`              | Password for user `tom`                  | `tom-password`                                                                           |

## Open Issues

- Enable the readiness probe in <templates/knox-dep.yaml> (requires authentication)
- Support additional services (not just HDFS)

## Related Charts

- The [Hadoop Chart](https://github.com/helm/charts/tree/master/stable/hadoop)
