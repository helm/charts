# GoCD Helm Chart

[![Join the chat at https://gitter.im/gocd/gocd](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/gocd/gocd?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[GoCD](https://www.gocd.org/) is an open-source continuous delivery server to model and visualize complex workflow with ease.

# Introduction

This chart bootstraps a single node GoCD server and GoCD agents on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.8+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure
- LoadBalancer support or Ingress Controller
- Ensure that the service account used for starting tiller has enough permissions to create a role. 

## Setup

Because of the [known issue] (https://github.com/kubernetes/helm/issues/2224) while creating a role, in order for the `helm install` to work, please ensure to do the following:

- On minikube

```bash
$ minikube start --bootstrapper kubeadm
```

- On GKE, if tiller's in the kube-system namespace

```bash

$ kubectl create clusterrolebinding clusterRoleBinding \                                                                                                               1 ↵
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:default
```

## Installing the Chart

Refer the [GoCD website](https://www.gocd.org/kubernetes) for getting started with GoCD on Helm.
 
To install the chart with the release name `gocd-app`:

```bash
$ helm repo add stable https://kubernetes-charts.storage.googleapis.com
$ helm install --name gocd-app --namespace gocd stable/gocd
```

The command deploys GoCD on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `gocd-app` deployment:

```bash
$ helm delete --purge gocd-app
```
The command removes all the Kubernetes components associated with the chart and deletes the release.


## Configuration

The following tables lists the configurable parameters of the GoCD chart and their default values.

### GoCD Server

| Parameter                                  | Description                                                                                                   | Default             |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------- | ------------------- |
| `server.enabled`                           | Enable GoCD Server. Supported values are `true`, `false`. When enabled, the GoCD server deployment is done on helm install.  | `true`              |
| `server.image.repository`                  | GoCD server image                                                                                             | `gocd/gocd-server`  |
| `server.image.tag`                         | GoCD server image tag                                                                                         | `.Chart.appVersion` |
| `server.image.pullPolicy`                  | Image pull policy                                                                                             | `IfNotPresent`      |
| `server.resources`                         | GoCD server resource requests and limits                                                                      | `{}`                |
| `server.nodeSelector`                      | GoCD server nodeSelector for pod labels                                                                       | `{}`                |
| `server.env.goServerSystemProperties`      | GoCD Server system properties                                                                                 | `nil`               |
| `server.env.extraEnvVars`                  | GoCD Server extra Environment variables                                                                       | `nil`               |
| `server.service.type`                      | Type of GoCD server Kubernetes service                                                                        | `NodePort`          |
| `server.service.httpPort`                  | GoCD server service HTTP port                                                                                 | `8153`              |
| `server.service.httpsPort`                 | GoCD server service HTTPS port                                                                                | `8154`              |  
| `server.service.nodeHttpPort`              | GoCD server service node HTTP port. **Note**: A random nodePort will get assigned if not specified            | `nil`               |  
| `server.service.nodeHttpsPort`             | GoCD server service node HTTPS port. **Note**: A random nodePort will get assigned if not specified           | `nil`               |  
| `server.ingress.enabled`                   | Enable/disable GoCD ingress. Allow traffic from outside the cluster via http. Do `kubectl describe ing` to get the public ip to access the gocd server.                                | `true`              |                                                                                     
| `server.ingress.hosts`                     | GoCD ingress hosts records.                                                                                   | `nil`               |
| `server.healthCheck.initialDelaySeconds`   | Initial delays in seconds to start the health checks. **Note**:GoCD server start up time.                     | `90`                |
| `server.healthCheck.periodSeconds`         | GoCD server heath check interval period.                                                                      | `15`                |
| `server.healthCheck.failureThreshold`      | Number of unsuccessful attempts made to the GoCD server health check endpoint before restarting.              | `10`                |

### GoCD Agent

| Parameter                                 | Description                                                                                                                                                                      | Default                      |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `agent.replicaCount`                      | GoCD Agent replicas Count. By default, no agents are provided.                                                                                                                   | `0`                          |
| `agent.image.repository`                  | GoCD agent image                                                                                                                                                                 | `gocd/gocd-agent-alpine-3.6` |
| `agent.image.tag`                         | GoCD agent image tag                                                                                                                                                             | `.Chart.appVersion`          |
| `agent.image.pullPolicy`                  | Image pull policy                                                                                                                                                                | `IfNotPresent`               |
| `agent.resources`                         | GoCD agent resource requests and limits                                                                                                                                          | `{}`                |
| `agent.nodeSelector`                      | GoCD agent nodeSelector for pod labels                                                                                                                                           | `{}`                |
| `agent.env.goServerUrl`                   | GoCD Server Url. If nil, discovers the GoCD server service if its available on the Kubernetes cluster                                                                            | `nil`                        |
| `agent.env.agentAutoRegisterKey`          | GoCD Agent autoregister key                                                                                                                                                      | `nil`                        |
| `agent.env.agentAutoRegisterResources`    | Comma separated list of GoCD Agent resources                                                                                                                                     | `nil`                        |
| `agent.env.agentAutoRegisterEnvironemnts` | Comma separated list of GoCD Agent environments                                                                                                                                  | `nil`                        |
| `agent.env.agentAutoRegisterHostname`     | GoCD Agent hostname                                                                                                                                                              | `nil`                        |
| `agent.env.goAgentBootstrapperArgs`       | GoCD Agent Bootstrapper Args. It can be used to [Configure end-to-end transport security](https://docs.gocd.org/current/installation/ssl_tls/end_to_end_transport_security.html) | `nil`                        |
| `agent.env.goAgentBootstrapperJvmArgs`    | GoCD Agent Bootstrapper JVM Args.                                                                                                                                                | `nil`                        |
| `agent.healthCheck.enabled`               | Enable use of GoCD agent health checks.                                                                                                                                          | `false`                      |
| `agent.healthCheck.initialDelaySeconds`   | GoCD agent start up time.                                                                                                                                                        | `60`                         |
| `agent.healthCheck.periodSeconds`         | GoCD agent heath check interval period.                                                                                                                                          | `60`                         |
| `agent.healthCheck.failureThreshold`      | GoCD agent heath check failure threshold. Number of unsuccessful attempts made to the GoCD server health check endpoint before restarting.                                       | `60`                         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --namespace gocd --name gocd-app -f values.yaml stable/gocd
```

> **Tip**: You can use the default [values.yaml](values.yaml)


## Persistence

By default, the GoCD helm chart supports dynamic volume provisioning. This means that the standard storage class with a default provisioner provided by various cloud platforms used. 
Refer to the [Kubernetes blog](http://blog.kubernetes.io/2017/03/dynamic-provisioning-and-storage-classes-kubernetes.html) to know more about the default provisioners across platforms.

> **Note**: The recalim policy for most default volume provisioners is `delete`. This means that, the persistent volume provisioned using the default provisioner will be deleted along with the data when the PVC gets deleted.

One can change the storage class to be used by overriding `server.persistence.storageClass` and `agent.persistence.storageClass` like below:

```bash
$ helm install --namespace gocd --name gocd-app --set server.persistence.stoageClass=STORAGE_CLASS_NAME stable/gocd
```

#### Static Volumes

Alternatively, a static persistent volume can be specified. This must be manually managed by the cluster admin outside of the helm scope.
For binding with a static persistent volume, dynamic volume provisioning must be **disabled** by setting `server.persistence.storageClass` or `agent.persistence.storageClass` to `-` .
The value pvSelector must be specified so that the right persistence volume will be bound.

#### Existing PersistentVolumeClaim

1. Create the PersistentVolume
2. Create the PersistentVolumeClaim
3. Install the chart

```
$ helm install --name gocd-app --set server.persistence.existingClaim=PVC_NAME stable/gocd
```

### Server persistence Values

| Parameter                                     | Description                                         | Default              |
| --------------------------------------------- | --------------------------------------------------- | -------------------- |
| `server.persistence.enabled`                  | Enable the use of a GoCD server PVC                 | `true`              |
| `server.persistence.accessMode`               | The PVC access mode                                 | `ReadWriteOnce`      |
| `server.persistence.size`                     | The size of the PVC                                 | `2Gi`                |
| `server.persistence.storageClass`             | The PVC storage class name                          | `nil`                |
| `server.persistence.pvSelector`               | The godata Persistence Volume Selectors             | `nil`                |
| `server.persistence.subpath.godata`           | The /godata path on Persistence Volume              | `godata`             |
| `server.persistence.subpath.homego`           | The /home/go path on Persistence Volume             | `homego`             |
| `server.persistence.subpath.dockerEntryPoint` | The /docker-entrypoint.d path on Persistence Volume | `scripts`            |

### Agent persistence Values

| Parameter                                     | Description                                          | Default              |
| --------------------------------------------- | ---------------------------------------------------- | -------------------- |
| `agent.persistence.enabled`                   | Enable the use of a GoCD agent PVC                   | `false`              |
| `agent.persistence.accessMode`                | The PVC access mode                                  | `ReadWriteOnce`      |
| `agent.persistence.size`                      | The size of the PVC                                  | `1Gi`                |
| `agent.persistence.storageClass`              | The PVC storage class name                           | `nil`                |
| `agent.persistence.pvSelector`                | The godata Persistence Volume Selectors              | `nil`                |
| `agent.persistence.subpath.homego`            | The /home/go path on Persistence Volume              | `homego`             |
| `agent.persistence.subpath.dockerEntryPoint`  | The /docker-entrypoint.d path on Persistence Volume  | `scripts`            |

##### Note:

`/home/go` directory shared between multiple agents implies:

1. That packages being cached here is shared between all the agents.
2. That all the agents sharing this directory are privy to all the secrets in `/home/go`

## RBAC and Service Accounts

The RBAC section is for users who want to use the Kubernetes Elastic Agent Plugin with GoCD. The Kubernetes elastic agent plugin for GoCD brings up pods on demand while running a job.
If RBAC is enabled,
 1. A cluster role is created by default and the following privileges are provided.
    Privileges:
      - nodes: list, get
      - events: list, watch
      - namespace: list, get
      - pods, pods/log: *

 2. A cluster role binding to bind the specified service account with the cluster role.

 3. A gocd service account . This service account is bound to a cluster role.
 If `rbac.create=true` and `serviceAccount.create=false`, the `default` service account in the namespace will be used for cluster role binding.


| Parameter                                     | Description                                                                         | Default              |
| --------------------------------------------- | ----------------------------------------------------------------------------------- | -------------------- |
| `rbac.create`                                 | If true, a gocd service account, role, and role binding is created.                 | `true`               |
| `rbac.apiVersion`                             | The Kubernetes API version                                                          | `v1beta1`            |
| `rbac.roleRef`                                | An existing role that can be bound to the gocd service account.                     | `nil`                |
| `serviceAccount.create`                       | Specifies whether a service account should be created.                              | `true`               |
| `serviceAccount.name`                         | Name of the service account.                                                        | `nil`                |
 
If `rbac.create=false`, the service account that will be used, either the default or one that's created, will not have the cluster scope or pod privileges to use with the Kubernetes EA plugin.
A cluster role binding must be created like below:

```
kubectl create clusterrolebinding clusterRoleBinding \
--clusterrole=CLUSTER_ROLE_WITH_NECESSARY_PRIVILEGES \
--serviceaccount=NAMESPACED_SERVICE_ACCOUNT

```

#### Existing role references:

The gocd service account can be associated with an existing role in the namespace that has privileges to create and delete pods. To use an existing role,

```bash
helm install --namespace gocd --name gocd-app --set rbac.roleRef=ROLE_NAME stable/gocd
```

# License

```plain
Copyright 2018 ThoughtWorks, Inc.

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
