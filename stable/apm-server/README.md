# apm-server

[apm-server](https://www.elastic.co/guide/en/apm/server/current/index.html)  is the server receives data from the Elastic APM agents and stores the data into a datastore like Elasticsearch.

## Introduction

This chart deploys apm-server agents to all the nodes in your cluster via a DaemonSet.

By default this chart only ships a single output to a file on the local system.  Users should set config.output.file.enabled=false and configure their own outputs as [documented](https://www.elastic.co/guide/en/apm/get-started/current/install-and-run.html)

## Prerequisites

- Kubernetes 1.9+

## Installing the Chart

To install the chart with the release name `my-release`, run:

```bash
$ helm install --name my-release stable/apm-server
```

After a few minutes, you should see service statuses being written to the configured output, which is a log file inside the apm-server container.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the apm-server chart and their default values.

|             Parameter               |            Description             |                    Default                |
|-------------------------------------|------------------------------------|-------------------------------------------|
| `image.repository`                  | The image repository to pull from  | `docker.elastic.co/apm/apm-server`        |
| `image.tag`                         | The image tag to pull              | `6.2.4`                                   |
| `image.pullPolicy`                  | Image pull policy                  | `IfNotPresent`                            |
| `kind`                              | Install as Deployment or DaemonSet | `Deployment`                              |
| `replicaCount`                      | Number of replicas when kind is Deployment | `1`                               |
| `updateStrategy`                    | Allows setting of RollingUpdate strategy | `{}`                                |
| `service.enabled`                   | If true, create service pointing to APM Server | `true`                        |
| `service.type`                      | type of service                          | `ClusterIP`                         |
| `service.port`                      | Service port                             | `8200`                              |
| `service.portName`                  | Service port name                        | None                                |
| `service.clusterIP`                 | Static clusterIP or None for headless services | None                          |
| `service.externalIPs`               | External IP addresses                    | None                                |
| `service.loadBalancerIP`            | Load Balancer IP address                 | None                                |
| `service.loadBalancerSourceRanges`  | Limit load balancer source IPs to list of CIDRs (where available)  | `[]`      |
| `service.nodePort`                  | NodePort value if service.type is NodePort | None                              |
| `service.annotations`               | Kubernetes service annotations           | None                                |
| `service.labels`                    | Kubernetes service labels                | None                                |
| `rbac.create`                       | If true, create & use RBAC resources | `true`                                  |
| `rbac.serviceAccount`               | existing ServiceAccount to use (ignored if rbac.create=true) | `default`       |
| `config`                            | The content of the configuration file consumed by apm-server. See the [apm-server documentation](https://www.elastic.co/guide/en/beats/apm-server/current/apm-server-reference-yml.html) for full details | |
| `plugins`                           | List of apm-server plugins         |                                           |
| `extraVars`                         | A map of additional environment variables |                                    |
| `extraVolumes`, `extraVolumeMounts` | Additional volumes and mounts, for example to provide other configuration files | |
| `resources.requests.cpu`            | CPU resource requests              |                                           |
| `resources.limits.cpu`              | CPU resource limits                |                                           |
| `resources.requests.memory`         | Memory resource requests           |                                           |
| `resources.limits.memory`           | Memory resource limits             |                                           |
| `nodeSelector`                      | Node labels for pod assignment     | `{}`                                      |
| `tolerations`                       | List of node taints to tolerate    | `[]`                                      |
| `affinity`                          | Node/Pod affinities                | None                                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
    --set rbac.create=true \
    stable/apm-server
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/apm-server
```

> **Tip**: You can use the default [values.yaml](values.yaml)
