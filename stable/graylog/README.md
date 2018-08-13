# Graylog2 Helm Chart

This is an implementation of Graylog2:

 * https://github.com/Graylog2/graylog-docker

## Pre Requisites:

* MongoDB for storing Graylog settings

* Elasticsearch cluster

* DNS Manager such as [External DNS](https://github.com/kubernetes-incubator/external-dns) for setting up the UI endpoint

## Chart Details

This chart will do the following:

* Create a single master node for exposing the Graylog UI

* Create a dynamically scalable cluster of worker nodes

### Installing the Chart

To install the chart with the release name `my-graylog` in the default
namespace:

```
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ helm install --name my-graylog incubator/graylog
```

If using a dedicated namespace(recommended) then make sure the namespace exists with:

```
$ helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
$ kubectl create ns graylog
$ helm install --name my-graylog --set global.namespace=graylog incubator/graylog
```

The chart can be customized using the following configurable parameters:

| Parameter                        | Description                                                                                                     | Default                                                    |
| -------------------------------- | --------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| `image.repository`               | Graylog Container image repository                                                                              | `graylog/graylog`                                          |
| `image.tag`                      | Graylog Container image tag                                                                                     | `2.4.5-1`                                                  |
| `image.pullPolicy`               | Graylog Container pull policy                                                                                   | `IfNotPresent`                                             |
| `timezone`                       | Time zone                                                                                                       | `UTC`                                                      |
| `batchSize`                      | Batch size for the Elasticsearch output                                                                         | `5000`                                                     |
| `secrets.mongo`                  | Mongo Connection URI: https://docs.mongodb.com/manual/reference/connection-string/                              | `3`                                                        |
| `secrets.passwordSecret`         | Secret used for password encryption and salting. See here for creating one: http://docs.graylog.org/en/2.4/pages/installation/manual_setup.html                                                    | `{}`                                                       |
| `secrets.rootPasword`            | A SHA2 hash of a password you will use for your initial login                                                   | `{}`                                                       |
| `master.resources`               | Graylog master node resources requests and limits                                                               | `{}`                                                       |
| `master.javaOpts`                | Graylog master node optional extra system properties                                                            | `{}`                                                       |
| `master.host`                    | Url to use for the web UI                                                                                       | `graylog.example.com`                                      |
| `master.service.port`            | Port to used to expose the graylog UI                                                                           | `9000`                                                     |
| `master.service.protocol`        | Protocol to used to expose the graylog UI                                                                       | `TCP`                                                      |
| `master.ingress.annotations`     | Extra annotations to add to the graylog UI ingress object                                                       | `{}`                                                       |
| `nodes.replicas`                 | Number of graylog worker nodes                                                                                  | `3`                                                        |
| `nodes.resources`                | Graylog worker nodes resources requests and limits                                                              | `{}`                                                       |
| `nodes.javaOpts`                 | Graylog worker nodes optional extra system properties                                                           | `{}`                                                       |
| `nodes.apiService.port`          | Port used for the worker nodes api                                                                              | `1337`                                                     |
| `nodes.inputService.type`        | Service type for the system inputs (For example GELF input)                                                     | `LoadBalancer`                                             |
| `nodes.inputService.ports`       | Additional ports to expose for system inputs                                                                    | `{ name: gelf, containerPort: 12201, protocol: TCP}`       |
| `nodes.inputService.annotations` | Extra annotations to add to the system inputs service                                                           | `{}`                                                       |
| `elasticsearch.hosts`            | Elasticsearch host name to connect to                                                                           | `elasticsearch`                                            |
| `elasticsearch.discovery`        | Indicates whether to enable Elasticsearch dicovery                                                              | `true`                                                     |
| `elasticsearch.compression`      | Indicates whether to enable Elasticsearch compression                                                           | `true`                                                     |

Specify parameters using `--set key=value[,key=value]` argument to `helm install`

Alternatively a YAML file that specifies the values for the parameters can be provided like this:

```bash
$ helm install --name my-graylog -f values.yaml incubator/graylog
```

## Known Limitations

* When connecting to an AWS Elasticsearch cluster, compression must be disabled