# Filebeat

[Filebeat](https://www.elastic.co/guide/en/beats/filebeat/current/index.html) is a lightweight shipper for forwarding and centralizing log data which supports various outputs.

## Prerequisites

- Kubernetes 1.9+


## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/filebeat
```

## Configuration

The following table lists the configurable parameters of the filebeat chart and their default values.

| Parameter                                                | Description                                                                                              | Default                                            |
| -------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| `image.repository`                                       | Docker image repo                                                                                        | `docker.elastic.co/beats/filebeat-oss`             |
| `image.tag`                                              | Docker image tag                                                                                         | `6.5.4`                                            |
| `image.pullPolicy`                                       | Docker image pull policy                                                                                 | `IfNotPresent`                                     |
| `image.pullSecrets`                                      | Specify image pull secrets                                                                               | `nil`                                              |
| `existingConfigmap`                                      | Provide an existing configmap to load configuration (`filebeat.yaml`) from                               | `nil`                                              |
| `config.filebeat.config.inputs.path`                     | Filebeat input configuration files path                                                                  | `${path.config}/prospectors.d/*.yml`               |
| `config.filebeat.config.inputs.reload.enabled`           | Reload input configs as they change                                                                      | `false`                                            |
| `config.filebeat.config.modules.path`                    | Filebeat module config files path (overridden when `modulesConfig` or `modulesExistingConfigmap` is provided) | `${path.config}/modules.d/*.yml` |
| `config.filebeat.config.modules.reload.enabled`          | Reload module configs as they change                                                                     | `false`                                            |
| `config.processors`                                      |                                                                                                          | `- add_cloud_metadata`                             |
| `config.filebeat.inputs`                                 | Host logs, docker containers logs are picked up by default (for details see [values.yaml](values.yml))   |                                                    |
| `config.output.file.path`                                |                                                                                                          | `"/usr/share/filebeat/data"`                       |
| `config.output.file.filename`                            |                                                                                                          | `filebeat`                                         |
| `config.output.file.rotate_every_kb`                     |                                                                                                          | `10000`                                            |
| `config.output.file.number_of_files`                     |                                                                                                          | `5`                                                |
| `config.http.enabled`                                    |                                                                                                          | `false`                                            |
| `config.http.port`                                       |                                                                                                          | `5066`                                             |
| `modulesExisitingConfigmap`                              | Existing modules configmap                                                                               | None                                               |
| `modulesConfig`                                          | Filebeat modules config                                                                                  | `[]`                                               |
| `indexTemplateLoad`                                      | List of Elasticsearch hosts to load index template, when logstash output is used                         | `[]`                                               |
| `command`                                                | Custom command (Docker Entrypoint)                                                                       | `[]`                                               |
| `args`                                                   | Custom args (Docker Cmd)                                                                                 | `[]`                                               |
| `plugins`                                                | List of beat plugins                                                                                     | `[]`                                               |
| `extraVars`                                              | A list of additional environment variables                                                                | `[]`                                              |
| `extraVolumes`                                           | Add additional volumes                                                                                   | `[]`                                               |
| `extraVolumeMounts`                                      | Add additional mounts                                                                                    | `[]`                                               |
| `extraInitContainers`                                    | Add additional initContainers                                                                            | `[]`                                               |
| `resources`                                              |                                                                                                          | `{}`                                               |
|`priorityClassName`                                       | priorityClassName                                                                                        | `nil`                                              |
| `nodeSelector`                                           |                                                                                                          | `{}`                                               |
| `annotations`                                            |                                                                                                          | `{}`                                               |
| `tolerations`                                            |                                                                                                          | `[]`                                               |
| `affinity`                                               |                                                                                                          | `{}`                                               |
| `rbac.create`                                            | Specifies whether RBAC resources should be created                                                       | `true`                                             |
| `serviceAccount.create`                                  | Specifies whether a ServiceAccount should be created                                                     | `true`                                             |
| `serviceAccount.name`                                    | the name of the ServiceAccount to use                                                                     | `""`                                               |
| `podSecurityPolicy.enabled`                              | Should the PodSecurityPolicy be created. Depends on `rbac.create` being set to `true`.                                                                     | `false`                                               |
| `podSecurityPolicy.annotations`                                    | Annotations to be added to the created PodSecurityPolicy:                                                                    | `""`                                               |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/filebeat
```

## Production configuration


By default this chart collects host logs, docker logs, adds Kubernetes and Cloud metadata then ships out to a file on the local system.

```bash
$ helm install --name my-release -f values.yaml stable/filebeat
```

## Configure filebeat output

Users **must disable the default** file output first and [configure/enable another output](https://www.elastic.co/guide/en/beats/filebeat/current/configuring-output.html) to ship logs into a different destination.

### Elasticsearch

The configuration bellow as can be noted from the example specifically defines index settings.

```yaml
config:
  output.file.enabled: false
  output.elasticsearch:
    hosts: ["YOUR-elasticsearch:9200"]

  # Example usage of setup.template
  setup.template:
    enabled: true
    overwrite: false
    settings:
      index.number_of_shards: 1
      index.number_of_replicas: 1
```

### Logstash (with manual index template)

The configuration bellow enables logstash output as well as manually sets up the index template in ES using `filebeat setup --template`.

```
config:
  output.file.enabled: false
  output.logstash:
    hosts: ["YOUR-logstash:5044"]

indexTemplateLoad:
  - YOUR-elasticsearch:9200
```

Note: though the index template is created **setup.template.settings** seem to be ignored!
