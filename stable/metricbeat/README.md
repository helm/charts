# Metricbeat

[metricbeat](https://www.elastic.co/guide/en/beats/metricbeat/current/index.html) is used to ship Kubernetes and host metrics to multiple outputs.

## Prerequisites

- Kubernetes 1.9+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/metricbeat
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the metricbeat chart and their default values.

|             Parameter               |            Description             |                    Default                |
|-------------------------------------|------------------------------------|-------------------------------------------|
| `image.repository`                  | The image repository to pull from  | `docker.elastic.co/beats/metricbeat`       |
| `image.tag`                         | The image tag to pull              | `6.4.3`                                   |
| `image.pullPolicy`                  | Image pull policy                  | `IfNotPresent`                            |
| `rbac.create`                       | If true, create & use RBAC resources | `true`                                  |
| `serviceAccount.create`             | If true, create & use ServiceAccount | `true`       |
| `serviceAccount.name`               | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |       |
| `config`                            | The content of the configuration file consumed by metricbeat. See the [metricbeat.reference.yml](https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-reference-yml.html) for full details | |
| `plugins`                           | List of beat plugins               |                                            |
| `extraEnv`                          | Additional environment |                                    |
| `extraVolumes`, `extraVolumeMounts` | Additional volumes and mounts, for example to provide other configuration files | |
| `resources.requests.cpu`            | CPU resource requests              |                                           |
| `resources.limits.cpu`              | CPU resource limits                |                                           |
| `resources.requests.memory`         | Memory resource requests           |                                           |
| `resources.limits.memory`           | Memory resource limits             |                                           |
| `daemonset.modules.<name>.config`   | The content of the modules configuration file consumed by metricbeat deployed as daemonset, which is assumed to collect metrics in each nodes. See the [metricbeat.reference.yml](https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-reference-yml.html) for full details |
| `daemonset.modules.<name>.enabled`  | If true, enable configuration | |
| `daemonset.podAnnotations`          | Pod annotations for daemonset | |
| `deployment.modules.<name>.config`  | The content of the modules configuration file consumed by metricbeat deployed as deployment, which is assumed to collect cluster-level metrics. See the [metricbeat.reference.yml](https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-reference-yml.html) for full details ||
| `deployment.modules.<name>.enabled` | If true, enable configuration ||
| `deployment.podAnnotations`         | Pod annotations for deployment | |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set rbac.create=true \
    stable/metricbeat
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/metricbeat
```

> **Tip**: You can use the default [values.yaml](values.yaml)
