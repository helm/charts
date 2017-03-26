# Kibana Helm Chart

This chart deploys [Kibana](https://www.elastic.co/products/kibana), for viewing logs stored in Elasticsearch.


## Installing the Chart

```bash
helm install stable/kibana
```

The command deploys Kibana with the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.


## Configuration

To use Kibana, the `elasticsearch.url` setting will need to be changed; you can specify this using `--set "elasticsearch\.url"="http://..."`.

The configurable parameters of the Kibana chart and the default values are listed in `values.yaml`.

The [full image documentation](https://www.elastic.co/guide/en/kibana/current/_configuring_kibana_on_docker.html) contains more information about running Kibana in Docker.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install --set config.elasticsearch.url=http://elasticsearch.logs:9200 stable/kibana
```

The above command specifies the URL of Elasticsearch.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install -f values.yaml stable/kibana
```

The `config` key in `values.yaml` will be serialized as the `kibana.yml` config file in the container.

> **Tip**: You can use the default [values.yaml](values.yaml)
