# GoCD Helm Chart
A GoCD Helm chart for Kubernetes. [GoCD](https://www.gocd.org/) is an Open source continuous delivery server to model and visualize complex workflows with ease.

> ### **Warning**: GoCD helm chart is still under development. Users are not expected to use it in production!

# Introduction
This chart bootstraps a single node GoCD server and a GoCD Agent deployment with configurable agent count on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.7+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/gocd
```

The command deploys GoCD on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.


## Configuration

The following tables lists the configurable parameters of the GoCD chart and their default values.

### GoCD

| Parameter    | Description  | Default             |
| ------------ | ------------ | ------------------- |
| `app.version`| GoCD version | `.Chart.appVersion` |


### GoCD Server

| Parameter                             | Description                                                                                         | Default             |
| ------------------------------------- | --------------------------------------------------------------------------------------------------- | ------------------- |
| `server.replicaCount`                 | GoCD Server replicas Count                                                                          | `1`                 |
| `server.image.repository`             | GoCD server image                                                                                   | `gocd/gocd-server`  |
| `server.image.tag`                    | GoCD server image tag                                                                               | `.Chart.appVersion` |
| `server.image.pullPolicy`             | Image pull policy                                                                                   | `IfNotPresent`      |
| `server.env.goServerSystemProperties` | GoCD Server system properties                                                                       | `nil`               |
| `server.service.type`                 | Type of GoCD server Kubernetes service                                                              | `NodePort`          |
| `server.service.httpPort`             | GoCD server service HTTP port                                                                       | `8153`              |
| `server.service.httpsPort`            | GoCD server service HTTPS port                                                                      | `8154`              |  
| `server.service.nodeHttpPort`         | GoCD server service node HTTP port. **Note**: A random nodePort will get assigned if not specified  | `nil`               |  
| `server.service.nodeHttpsPort`        | GoCD server service node HTTPS port. **Note**: A random nodePort will get assigned if not specified | `nil`               |  
| `server.ingress.enabled`              | Enable GoCD ingress.                                                                                | `false`             |  
| `server.ingress.hosts`                | GoCD ingress hosts records.                                                                         | `nil`               |  

### GoCD Agent

| Parameter                                 | Description                                     | Default                      |
| ----------------------------------------- | ----------------------------------------------- | ---------------------------- |
| `agent.replicaCount`                      | GoCD Agent replicas Count                       | `1`                          |
| `agent.image.repository`                  | GoCD agent image                                | `gocd/gocd-agent-alpine-3.6` |
| `agent.image.tag`                         | GoCD agent image tag                            | `.Chart.appVersion`          |
| `agent.image.pullPolicy`                  | Image pull policy                               | `IfNotPresent`               |
| `agent.env.goServerUrl`                   | GoCD Server Url                                 | `nil`                        |
| `agent.env.agentAutoRegisterKey`          | GoCD Agent autoregister key                     | `nil`                        |
| `agent.env.agentAutoRegisterResources`    | Comma separated list of GoCD Agent resources    | `nil`                        |
| `agent.env.agentAutoRegisterEnvironemnts` | Comma separated list of GoCD Agent environments | `nil`                        |
| `agent.env.agentAutoRegisterHostname`     | GoCD Agent hostname                             | `nil`                        |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/gocd
```

> **Tip**: You can use the default [values.yaml](values.yaml)


## persistence

The GoCD server image stores persistence under `/godata` path of the container. A dynamically managed Persistent Volume
Claim is used to keep the data across deployments, by default. This is known to work in minikube. Alternatively,
a previously configured Persistent Volume Claim can be used.


### Server `/godata` persistence Values


| Parameter                                | Description                               | Default              |
| ---------------------------------------- | ----------------------------------------- | -------------------- |
| `server.persistence.enabled`             | Enable the use of a GoCD PVC              | `false`              |
| `server.persistence.godata.pvName`       | Provide the name of a PV for `godata` PVC | `godata-gocd-server` |
| `server.persistence.godata.name`         | The PVC name                              | `godata-pvc`         |
| `server.persistence.godata.accessMode`   | The PVC access mode                       | `ReadWriteOnce`      |
| `server.persistence.godata.size`         | The size of the PVC                       | `1Gi`                |
| `server.persistence.homego.storageClass` | The PVC storage class name                | `nil`                |

### Server `/homego` persistence Values


| Parameter                                | Description                               | Default              |
| ---------------------------------------- | ----------------------------------------- | -------------------- |
| `server.persistence.enabled`             | Enable the use of a GoCD PVC              | `false`              |
| `server.persistence.homego.pvName`       | Provide the name of a PV for `godata` PVC | `godata-gocd-server` |
| `server.persistence.homego.name`         | The PVC name                              | `godata-pvc`         |
| `server.persistence.homego.accessMode`   | The PVC access mode                       | `ReadWriteOnce`      |
| `server.persistence.homego.size`         | The size of the PVC                       | `1Gi`                |
| `server.persistence.homego.storageClass` | The PVC storage class name                | `nil`                |

### Agent `/godata` persistence Values


| Parameter                                | Description                               | Default              |
| ---------------------------------------- | ----------------------------------------- | -------------------- |
| `agent.persistence.enabled`             | Enable the use of a GoCD PVC              | `false`              |
| `agent.persistence.godata.pvName`       | Provide the name of a PV for `godata` PVC | `godata-gocd-server` |
| `agent.persistence.godata.name`         | The PVC name                              | `godata-pvc`         |
| `agent.persistence.godata.accessMode`   | The PVC access mode                       | `ReadWriteOnce`      |
| `agent.persistence.godata.size`         | The size of the PVC                       | `1Gi`                |
| `agent.persistence.homego.storageClass` | The PVC storage class name                | `nil`                |



### Existing PersistentVolumeClaim
    
1. Create the PersistentVolume
2. Create the PersistentVolumeClaim
3. Install the chart

```
$ helm install --name my-release --set server.persistence.godata.existingClaim=PVC_NAME stable/gocd
```


# License

```plain
Copyright 2017 ThoughtWorks, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[0]: https://www.gocd.org/download/