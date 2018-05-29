# Elastalert Helm Chart

[elastalert](https://github.com/Yelp/elastalert) is a simple framework for alerting on anomalies, spikes, or other patterns of interest from data in Elasticsearch.

## TL;DR;

```console
$ helm install stable/elastalert
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/elastalert
```

The command deploys elastalert on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

|       Parameter        |                    Description                    |             Default             |
| ---------------------- | ------------------------------------------------- | ------------------------------- |
| `image.repository`     | docker image                                      | jertel/elastalert-docker        |
| `image.tag`            | docker image tag                                  | 0.1.30                          |
| `image.pullPolicy`     | image pull policy                                 | IfNotPresent                    |
| `command`              | command override for container                    | `NULL`                          |
| `args`                 | args override for container                       | `NULL`                          |
| `replicaCount`         | number of replicas to run                         | 1                               |
| `elasticsearch.host`   | elasticsearch endpoint to use                     | elasticsearch                   |
| `elasticsearch.port`   | elasticsearch port to use                         | 80                              |
| `elasticsearch.useSsl` | whether or not to connect to es_host using SSL    | False                           |
| `resources`            | Container resource requests and limits            | {}                              |
| `rules`                | Rule and alert configuration for Elastalert       | {} example shown in values.yaml |
| `runIntervalMins`      | Default interval between alert checks, in minutes | 1                               |
| `bufferTimeMins`       | Default rule buffer time, in minutes              | 15                              |
