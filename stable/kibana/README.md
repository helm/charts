# kibana

[kibana](https://github.com/elastic/kibana) is your window into the Elastic Stack. Specifically, it's an open source (Apache Licensed), browser-based analytics and search dashboard for Elasticsearch.

## TL;DR;

```console
$ helm install stable/kibana
```

## Introduction

This chart bootstraps a kibana deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install stable/kibana --name my-release
```

The command deploys kibana on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the kibana chart and their default values.

| Parameter                                     | Description                                | Default                                |
|-----------------------------------------------|--------------------------------------------|----------------------------------------|
| `affinity`                                    | node/pod affinities                        | None                                   |
| `env`                                         | Environment variables to configure Kibana  | `{}`                                   |
| `files`                                       | Kibana configuration files                 | None                                   |
| `image.pullPolicy`                            | Image pull policy                          | `IfNotPresent`                         |
| `image.repository`                            | Image repository                           | `docker.elastic.co/kibana/kibana-oss`  |
| `image.tag`                                   | Image tag                                  | `6.4.2`                                |
| `image.pullSecrets`                           | Specify image pull secrets                 | `nil`                                  |
| `commandline.args`                            | add additional commandline args            | `nil`                                  |
| `ingress.enabled`                             | Enables Ingress                            | `false`                                |
| `ingress.annotations`                         | Ingress annotations                        | None:                                  |
| `ingress.hosts`                               | Ingress accepted hostnames                 | None:                                  |
| `ingress.tls`                                 | Ingress TLS configuration                  | None:                                  |
| `nodeSelector`                                | node labels for pod assignment             | `{}`                                   |
| `podAnnotations`                              | annotations to add to each pod             | `{}`                                   |
| `replicaCount`                                | desired number of pods                     | `1`                                    |
| `revisionHistoryLimit`                        | revisionHistoryLimit                       | `3`                                    |
| `serviceAccountName`                          | DEPRECATED: use serviceAccount.name        | `nil`                                  |
| `serviceAccount.create`                       | create a serviceAccount to run the pod     | `false`                                |
| `serviceAccount.name`                         | name of the serviceAccount to create       | `kibana.fullname`                      |
| `authProxyEnabled`                            | enables authproxy. Create container in extracontainers   | `false`                  |
| `extraContainers`                             | Sidecar containers to add to the kibana pod| `{}`                                   |
| `resources`                                   | pod resource requests & limits             | `{}`                                   |
| `priorityClassName`                           | priorityClassName                          | `nil`                                  |
| `service.externalPort`                        | external port for the service              | `443`                                  |
| `service.internalPort`                        | internal port for the service              | `4180`                                 |
| `service.authProxyPort`                       | port to use when using sidecar authProxy   | None:                                  |
| `service.externalIPs`                         | external IP addresses                      | None:                                  |
| `service.loadBalancerIP`                      | Load Balancer IP address                   | None:                                  |
| `service.loadBalancerSourceRanges`            | Limit load balancer source IPs to list of CIDRs (where available)) | `[]`           |
| `service.nodePort`                            | NodePort value if service.type is NodePort | None:                                  |
| `service.type`                                | type of service                            | `ClusterIP`                            |
| `service.annotations`                         | Kubernetes service annotations             | None:                                  |
| `service.labels`                              | Kubernetes service labels                  | None:                                  |
| `tolerations`                                 | List of node taints to tolerate            | `[]`                                   |
| `dashboardImport.timeout`                     | Time in seconds waiting for Kibana to be in green overall state | `60`                                   |
| `dashboardImport.xpackauth.enabled`           | Enable Xpack auth                          | `false`                                |
| `dashboardImport.xpackauth.username`          | Optional Xpack username                    | `myuser`                               |
| `dashboardImport.xpackauth.password`          | Optional Xpack password                    | `mypass`                               |
| `dashboardImport.dashboards`                  | Dashboards                                 | `{}`                                   |
| `plugins`                                     | List of URLs pointing to zip files of Kibana plugins to install                                 | None:                                   |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

* The Kibana configuration files config properties can be set through the `env` parameter too.
* All the files listed under this variable will overwrite any existing files by the same name in kibana config directory.
* Files not mentioned under this variable will remain unaffected.

```console
$ helm install stable/kibana --name my-release \
  --set=image.tag=v0.0.2,resources.limits.cpu=200m
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install stable/kibana --name my-release -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Dasboard import

* A dashboard for dashboardImport.dashboards can be a JSON or a download url to a JSON file.
