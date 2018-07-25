# Filebeat

[filebeat](https://www.elastic.co/guide/en/beats/filebeat/current/index.html) is used to ship Kubernetes and host logs to multiple outputs.

## Prerequisites

- Kubernetes 1.9+

## Note

By default this chart only ships a single output to a file on the local system.  Users should set config.output.file.enabled=false and configure their own outputs as [documented](https://www.elastic.co/guide/en/beats/filebeat/current/configuring-output.html)

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
| `image.tag`                                              | Docker image tag                                                                                         | `6.3.1`                                            |
| `image.pullPolicy`                                       | Docker image pull policy                                                                                 | `IfNotPresent`                                     |
| `config.filebeat.config.prospectors.path`                | Mounted `filebeat-prospectors` configmap                                                                 | `${path.config}/prospectors.d/*.yml`               |
| `config.filebeat.config.prospectors.reload.enabled`      | Reload prospectors configs as they change                                                                | `false`                                            |
| `config.filebeat.config.modules.path`                    |                                                                                                          | `${path.config}/modules.d/*.yml`                   |
| `config.filebeat.config.modules.reload.enabled`          | Reload module configs as they change                                                                     | `false`                                            |
| `config.processors`                                      |                                                                                                          | `- add_cloud_metadata`                             |
| `config.filebeat.prospectors`                            |                                                                                                          | see values.yaml                                    |
| `config.output.file.path`                                |                                                                                                          | `"/usr/share/filebeat/data"`                       |
| `config.output.file.filename`                            |                                                                                                          | `filebeat`                                         |
| `config.output.file.rotate_every_kb`                     |                                                                                                          | `10000`                                            |
| `config.output.file.number_of_files`                     |                                                                                                          | `5`                                                |
| `config.http.enabled`                                    |                                                                                                          | `false`                                            |
| `config.http.port`                                       |                                                                                                          | `5066`                                             |
| `plugins`                                                | List of beat plugins                                                                                     | `[]`                                               |
| `extraVars`                                              | A map of additional environment variables                                                                | `{}`                                               |
| `extraVolumes`                                           | Add additional volumes                                                                                   | `[]`                                               |
| `extraVolumeMounts`                                      | Add additional mounts                                                                                    | `[]`                                               |
| `resources`                                              |                                                                                                          | `{}`                                               |
| `nodeSelector`                                           |                                                                                                          | `{}`                                               |  
| `annotations`                                            |                                                                                                          | `{}`                                               |
| `tolerations`                                            |                                                                                                          | `[]`                                               |
| `affinity`                                               |                                                                                                          | `{}`                                               |
| `rbac.create`                                            | Specifies whether RBAC resources should be created                                                       | `true`                                             |
| `serviceAccount.create`                                  | Specifies whether a ServiceAccount should be created                                                     | `true`                                             |
| `serviceAccount.name`                                    | he name of the ServiceAccount to use                                                                     | `""`                                               |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/filebeat
```
