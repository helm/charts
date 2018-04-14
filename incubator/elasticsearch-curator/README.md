# Elasticsearch Curator Helm Chart

This directory contains a Kubernetes chart to deploy the [Elasticsearch Curator](https://github.com/elastic/curator).

## Prerequisites Details

* Elasticsearch

## Chart Details

This chart will do the following:

* Create a CronJob which runs the Curator

## Installing the Chart

To install the chart, use the following:

```console
$ helm install incubator/elasticsearch-curator
```

## Configuration

The following table lists the configurable parameters of the docker-registry chart and
their default values.

|          Parameter           |                      Description                      |                   Default                    |
| :--------------------------- | :---------------------------------------------------- | :------------------------------------------- |
| `image.pullPolicy`           | Container pull policy                                 | `IfNotPresent`                               |
| `image.repository`           | Container image to use                                | `quay.io/pires/docker-elasticsearch-curator` |
| `image.tag`                  | Container image tag to deploy                         | `5.4.1`                                      |
| `cronjob.schedule`           | Schedule for the CronJob                              | `0 1 * * *`                                  |
| `config.elasticsearch.hosts` | Array of Elasticsearch hosts to curate                | - CHANGEME.host                              |
| `config.elasticsearch.port`  | Elasticsearch port to connect too                     | 9200                                         |
| `configMaps.action_file_yml` | Contents of the Curator action_file.yml               | See values.yaml                              |
| `configMaps.config_yml`      | Contents of the Curator config.yml (overrides config) | See values.yaml                              |
| `resources`                  | Resource requests and limits                          | {}                                           |

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`.
