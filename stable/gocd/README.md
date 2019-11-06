# GoCD Helm Chart

[![Join the chat at https://gitter.im/gocd/gocd](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/gocd/gocd?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[GoCD](https://www.gocd.org/) is an open-source continuous delivery server to model and visualize complex workflow with ease.

# Introduction

This chart bootstraps a single node GoCD server and GoCD agents on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

To quickly build your first pipeline while learning key GoCD concepts, visit the [Intro to GoCD guide](https://www.gocd.org/getting-started/part-1/).

## Prerequisites

- Kubernetes 1.13+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure
- LoadBalancer support or Ingress Controller
- Ensure that the service account used for starting tiller has enough permissions to create a role.

## Setup

Because of a [known issue](https://github.com/kubernetes/helm/issues/2224) while creating a role, in order for the `helm install` to work, please ensure to do the following:

- On minikube

```bash
$ minikube start --bootstrapper kubeadm
```

- On GKE, if tiller's in the kube-system namespace

```bash

$ kubectl create clusterrolebinding clusterRoleBinding \
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

The following tables list the configurable parameters of the GoCD chart and their default values.

### GoCD Server

| Parameter                                  | Description                                                                                                   | Default             |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------- | ------------------- |
| `server.enabled`                           | Enable GoCD Server. Supported values are `true`, `false`. When enabled, the GoCD server deployment is done on helm install.  | `true`              |
| `server.annotations.deployment`            | GoCD server Deployment annotations.                                                                           | `{}`                |
| `server.annotations.pod       `            | GoCD server Pod annotations.                                                                                  | `{}`                |
| `server.shouldPreconfigure`                | Preconfigure GoCD Server to have a default elastic agent profile and Kubernetes elastic agent plugin settings. Supported values are `true`, `false`.  | `true`              |
| `server.preconfigureCommand`               | Preconfigure GOCD Server with a custom command (shell,python, etc ...). Supported value is a list.            | `["/bin/bash", "/preconfigure_server.sh"]`|
| `server.preStop`                           | Perform cleanup and backup before stopping the gocd server. Supported value is a list.                        | `nil`               |
| `server.terminationGracePeriodSeconds`     | Optional duration in seconds the gocd server pod needs to terminate gracefully.                               | `nil`               |
| `server.image.repository`                  | GoCD server image                                                                                             | `gocd/gocd-server`  |
| `server.image.tag`                         | GoCD server image tag                                                                                         | `.Chart.appVersion` |
| `server.image.pullPolicy`                  | Image pull policy                                                                                             | `IfNotPresent`      |
| `server.resources`                         | GoCD server resource requests and limits                                                                      | `{}`                |
| `server.initContainers`                    | GoCD server init containers                                                                                   | `[]`                |
| `server.restartPolicy`                     | GoCD server restart policy                                                                                    | `Always`            |
| `server.nodeSelector`                      | GoCD server nodeSelector for pod labels                                                                       | `{}`                |
| `server.affinity`                          | GoCD server affinity                                                                                          | `{}`                |
| `server.tolerations`                       | GoCD server tolerations                                                                                       | `{}`                |
| `server.env.goServerJvmOpts`               | GoCD Server JVM arguments                                                                                     | `nil`               |
| `server.env.extraEnvVars`                  | GoCD Server extra Environment variables                                                                       | `nil`               |
| `server.service.type`                      | Type of GoCD server Kubernetes service                                                                        | `NodePort`          |
| `server.service.loadBalancerSourceRanges`  | GoCD server service Load Balancer source IP ranges to whitelist                                               | `nil`               |
| `server.service.httpPort`                  | GoCD server service HTTP port                                                                                 | `8153`              |
| `server.service.httpsPort`                 | GoCD server service HTTPS port                                                                                | `8154`              |  
| `server.service.nodeHttpPort`              | GoCD server service node HTTP port. **Note**: A random nodePort will get assigned if not specified            | `nil`               |  
| `server.service.nodeHttpsPort`             | GoCD server service node HTTPS port. **Note**: A random nodePort will get assigned if not specified           | `nil`               |  
| `server.ingress.enabled`                   | Enable/disable GoCD ingress. Allow traffic from outside the cluster via http. Do `kubectl describe ing` to get the public ip to access the gocd server.                                | `true`              |                                                                                     
| `server.ingress.hosts`                     | GoCD ingress hosts records.                                                                                   | `nil`               |
| `server.ingress.annotations`               | GoCD ingress annotations.                                                                                     | `{}`                |
| `server.ingress.tls`                       | GoCD ingress TLS configuration.                                                                               | `[]`                |
| `server.healthCheck.initialDelaySeconds`   | Initial delays in seconds to start the health checks. **Note**:GoCD server start up time.                     | `90`                |
| `server.healthCheck.periodSeconds`         | GoCD server health check interval period.                                                                      | `15`                |
| `server.healthCheck.failureThreshold`      | Number of unsuccessful attempts made to the GoCD server health check endpoint before restarting.              | `10`                |
| `server.hostAliases`                       | Aliases for IPs in /etc/hosts                                                                                 | `[]`                |
| `server.security.ssh.enabled`              | Enable the use of SSH keys for GoCD server                                                                    | `false`             |
| `server.security.ssh.secretName`           | The name of the secret holding the SSH keys                                                                   | `gocd-server-ssh`   |
| `server.securityContext.runAsUser`         | The container user for all the GoCD server pods.                                                              | `1000`              |
| `server.securityContext.runAsGroup`        | The container group for all the GoCD server pods.                                                             | `0`                 |
| `server.securityContext.fsGroup`           | The container supplementary group for all the GoCD server pods.                                               | `0`                 |

#### Preconfiguring the GoCD Server

Based on the information available about the Kubernetes cluster, the [Kubernetes elastic agent](https://github.com/gocd/kubernetes-elastic-agents) plugin settings can be configured. A default elastic agent profile too is created so that users can concentrate on building their CD pipeline.
A simple first pipeline is created in order to bootstrap the getting started experience for users.

If you are comfortable with GoCD and feel that there is no need to preconfigure the server, then you can override `server.shouldPreconfigure` to be false.

**Note: If the GoCD server is started with an existing config from a persistent volume, set the value of `server.shouldPreconfigure` to `false`.**

```bash
$ helm install --namespace gocd --name gocd-app --set server.shouldPreconfigure=false stable/gocd
```

We are using the `postStart` container lifecycle hook to configure the plugin settings and the elastic agent profile. On starting the container, an attempt is made to configure the GoCD server.

```bash
$ kubectl get pods --namespace gocd
```

The above command will show the pod state. This will be in `ContainerCreating` till the preconfigure script exits.

```bash
$ kubectl describe pods --namespace gocd
```

The above command will show the events that occurred in detail. This can be used to determine if there is any problem at the time of creating the GoCD server pod. If the preconfigure script fails for some reason, the event `FailedPostStartHook` is published.

The output of the preconfigure script is provided at `/godata/logs/preconfigure.log`.

```bash
$ helm status gocd-app
```

This command provides the information on how to access the GoCD server.

The cases when the attempt to preconfigure the GoCD server fails:

1. The service account token mounted as a secret for the GoCD server pod does not have sufficient permissions. The API call to configure the plugin settings will fail.
2. If the GoCD server is started with an existing configuration with security configured, then the API calls in the preconfigure script will fail.

#### SSH keys
For accessing repositories over SSH in GoCD server, you need to add SSH keys to the GoCD server.
Generate a new keypair, fetch the host key for the [host] you want to connect to and create the secret.
The secret is structured to hold the entire contents of the .ssh folder on the GoCD server.

 ```bash
$ ssh-keygen -t rsa -b 4096 -C "user@example.com" -f gocd-server-ssh -P ''
$ ssh-keyscan [host] > gocd_known_hosts
$ kubectl create secret generic gocd-server-ssh \
    --from-file=id_rsa=gocd-server-ssh \
    --from-file=id_rsa.pub=gocd-server-ssh.pub \
    --from-file=known_hosts=gocd_known_hosts
```
 The last step is to copy the key over to the host, so GoCD server can connect.

### GoCD Agent

 *Note: This is only for static gocd agents brought up in the cluster via the helm chart. The elastic agent pods need to be separately configured using [elastic agent profiles](https://docs.gocd.org/current/configuration/elastic_agents.html#elastic-agent-profile)*

| Parameter                                 | Description                                                                                                                                                                      | Default                      |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `agent.annotations.deployment`            | GoCD Agent Deployment annotations.                                                                                                                                               | `{}`                         |
| `agent.annotations.pod       `            | GoCD Agent Pod annotations.                                                                                                                                                      | `{}`                         |
| `agent.replicaCount`                      | GoCD Agent replicas Count. By default, no agents are provided.                                                                                                                   | `0`                          |
| `agent.preStop        `                   | Perform cleanup and backup before stopping the gocd server. Supported value is a list.                                                                                           | `nil`                        |
| `agent.terminationGracePeriodSeconds`     | Optional duration in seconds the gocd agent pods need to terminate gracefully.                                                                                                   | `nil`                        |
| `agent.deployStrategy`                    | GoCD Agent [deployment strategy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy).                                                                | `{}`                         |
| `agent.image.repository`                  | GoCD agent image                                                                                                                                                                 | `gocd/gocd-agent-alpine-3.6` |
| `agent.image.tag`                         | GoCD agent image tag                                                                                                                                                             | `.Chart.appVersion`          |
| `agent.image.pullPolicy`                  | Image pull policy                                                                                                                                                                | `IfNotPresent`               |
| `agent.resources`                         | GoCD agent resource requests and limits                                                                                                                                          | `{}`                |
| `agent.initContainers`                    | GoCD agent init containers                                                                                                                                                       | `[]`                |
| `agent.restartPolicy`                     | GoCD agent restart policy                                                                                                                                                        | `Always`               |
| `agent.nodeSelector`                      | GoCD agent nodeSelector for pod labels                                                                                                                                           | `{}`                |
| `agent.affinity`                         | GoCD agent affinity                                                                                                                                                               | `{}`                |
| `agent.tolerations`                       | GoCD agent tolerations                                                                                                                                                           | `{}`                |
| `agent.env.goServerUrl`                   | GoCD Server Url. If nil, discovers the GoCD server service if its available on the Kubernetes cluster                                                                            | `nil`                        |
| `agent.env.agentAutoRegisterKey`          | GoCD Agent autoregister key                                                                                                                                                      | `nil`                        |
| `agent.env.agentAutoRegisterResources`    | Comma separated list of GoCD Agent resources                                                                                                                                     | `nil`                        |
| `agent.env.agentAutoRegisterEnvironments` | Comma separated list of GoCD Agent environments                                                                                                                                  | `nil`                        |
| `agent.env.agentAutoRegisterHostname`     | GoCD Agent hostname                                                                                                                                                              | `nil`                        |
| `agent.env.goAgentBootstrapperArgs`       | GoCD Agent Bootstrapper Args. It can be used to [Configure end-to-end transport security](https://docs.gocd.org/current/installation/ssl_tls/end_to_end_transport_security.html) | `nil`                        |
| `agent.env.goAgentBootstrapperJvmArgs`    | GoCD Agent Bootstrapper JVM Args.                                                                                                                                                | `nil`                        |
| `agent.env.goAgentJvmOpts`                | GoCD Agent JVM arguments                                                                                     | `nil`               |
| `agent.env.extraEnvVars`                  | GoCD Agent extra Environment variables                                                                       | `nil`               |
| `agent.privileged`                        | Run container in privileged mode (needed for DinD, Docker-in-Docker agents)                                                                                                      | `false`                      |
| `agent.healthCheck.enabled`               | Enable use of GoCD agent health checks.                                                                                                                                          | `false`                      |
| `agent.healthCheck.initialDelaySeconds`   | GoCD agent start up time.                                                                                                                                                        | `60`                         |
| `agent.healthCheck.periodSeconds`         | GoCD agent health check interval period.                                                                                                                                          | `60`                         |
| `agent.healthCheck.failureThreshold`      | GoCD agent health check failure threshold. Number of unsuccessful attempts made to the GoCD server health check endpoint before restarting.                                       | `60`                         |
| `agent.hostAliases`                       | Aliases for IPs in /etc/hosts                                                                                 | `[]`                |
| `agent.security.ssh.enabled`              | Enable the use of SSH keys for GoCD agent                                                                                                                                        | `false`                      |
| `agent.security.ssh.secretName`           | The name of the secret holding the SSH keys                                                                                                                                      | `gocd-agent-ssh`             |
| `agent.securityContext.runAsUser`         | The container user for all the GoCD agent pods.                                                                                                                                  | `1000`                       |
| `agent.securityContext.runAsGroup`        | The container group for all the GoCD agent pods.                                                                                                                                 | `0`                          |
| `agent.securityContext.fsGroup`           | The container supplementary group for all the GoCD agent pods.                                                                                                                   | `0`                          |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --namespace gocd --name gocd-app -f values.yaml stable/gocd
```

> **Tip**: You can use the default [values.yaml](values.yaml)

#### SSH keys
For accessing repositories over SSH in GoCD agent, you need to add SSH keys to the GoCD agent.
Generate a new keypair, fetch the host key for the [host] you want to connect to and create the secret.
The secret is structured to hold the entire contents of the .ssh folder on the GoCD agent.

 ```bash
$ ssh-keygen -t rsa -b 4096 -C "user@example.com" -f gocd-agent-ssh -P ''
$ ssh-keyscan [host] > gocd_known_hosts
$ kubectl create secret generic gocd-agent-ssh \
    --from-file=id_rsa=gocd-agent-ssh \
    --from-file=id_rsa.pub=gocd-agent-ssh.pub \
    --from-file=known_hosts=gocd_known_hosts
```
 The last step is to copy the key over to the host, so GoCD agent can connect.

## Persistence

By default, the GoCD helm chart supports dynamic volume provisioning. This means that the standard storage class with a default provisioner provided by various cloud platforms used.
Refer to the [Kubernetes blog](http://blog.kubernetes.io/2017/03/dynamic-provisioning-and-storage-classes-kubernetes.html) to know more about the default provisioners across platforms.

> **Note**: The reclaim policy for most default volume provisioners is `delete`. This means that, the persistent volume provisioned using the default provisioner will be deleted along with the data when the PVC gets deleted.

One can change the storage class to be used by overriding `server.persistence.storageClass` and `agent.persistence.storageClass` like below:

```bash
$ helm install --namespace gocd --name gocd-app --set server.persistence.storageClass=STORAGE_CLASS_NAME stable/gocd
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

#### Additional Volumes

Additional volumes, such as `ConfigMaps` and `secrets`, can be mounted on the server and agent deployments.

To mount a `secret`:
```
  persistence:
    enabled: true
    extraVolumeMounts:
      - name: github-key
        mountPath: /etc/config/keys/
        readOnly: true
    extraVolumes:
      - name: github-key
        secret:
          secretName: github-key
          defaultMode: 0744
```

To mount a `ConfigMap` containing `/docker-entrypoint.d/` scripts:
```
  persistence:
    enabled: true
    name:
      dockerEntryPoint: gocd-init-scripts
    subpath:
      dockerEntryPoint: ""
    extraVolumes:
      - name: gocd-init-scripts
        configMap:
          name: gocd-init-scripts
          defaultMode: 0755
```

### Server persistence Values

| Parameter                                     | Description                                             | Default              |
| --------------------------------------------- | ------------------------------------------------------- | -------------------- |
| `server.persistence.enabled`                  | Enable the use of a GoCD server PVC                     | `true`               |
| `server.persistence.accessMode`               | The PVC access mode                                     | `ReadWriteOnce`      |
| `server.persistence.size`                     | The size of the PVC                                     | `2Gi`                |
| `server.persistence.storageClass`             | The PVC storage class name                              | `nil`                |
| `server.persistence.pvSelector`               | The godata Persistence Volume Selectors                 | `nil`                |
| `server.persistence.name.dockerEntryPoint`    | The Persitence Volume to mount at /docker-entrypoint.d/ | `goserver-vol`       |
| `server.persistence.subpath.godata`           | The /godata path on Persistence Volume                  | `godata`             |
| `server.persistence.subpath.homego`           | The /home/go path on Persistence Volume                 | `homego`             |
| `server.persistence.subpath.dockerEntryPoint` | The /docker-entrypoint.d path on Persistence Volume     | `scripts`            |
| `server.persistence.extraVolumes`             | Additional server volumes                               | `[]`                 |
| `server.persistence.extraVolumeMounts`        | Additional server volumeMounts                          | `[]`                 |

### Agent persistence Values

| Parameter                                     | Description                                             | Default              |
| --------------------------------------------- | ------------------------------------------------------- | -------------------- |
| `agent.persistence.enabled`                   | Enable the use of a GoCD agent PVC                      | `false`              |
| `agent.persistence.accessMode`                | The PVC access mode                                     | `ReadWriteOnce`      |
| `agent.persistence.size`                      | The size of the PVC                                     | `1Gi`                |
| `agent.persistence.storageClass`              | The PVC storage class name                              | `nil`                |
| `agent.persistence.pvSelector`                | The godata Persistence Volume Selectors                 | `nil`                |
| `agent.persistence.name.dockerEntryPoint`     | The Persitence Volume to mount at /docker-entrypoint.d/ | `goagent-vol`        |
| `agent.persistence.subpath.homego`            | The /home/go path on Persistence Volume                 | `homego`             |
| `agent.persistence.subpath.dockerEntryPoint`  | The /docker-entrypoint.d path on Persistence Volume     | `scripts`            |
| `agent.persistence.extraVolumes`              | Additional agent volumes                                | `[]`                 |
| `agent.persistence.extraVolumeMounts`         | Additional agent volumeMounts                           | `[]`                 |

##### Note:

`/home/go` directory shared between multiple agents implies:

1. That packages being cached here is shared between all the agents.
2. That all the agents sharing this directory are privy to all the secrets in `/home/go`

## Init containers

The GoCD helm chart supports specifying init containers for server and agents. This can for example be used to download `kubectl` or any other necessary ressources before starting GoCD:

```
agent:
  persistence:
    extraVolumes:
      - name: kubectl
        emptyDir: {}
    extraVolumeMounts:
      - name: kubectl
        mountPath: /usr/local/bin/kubectl
        subPath: kubectl
  initContainers:
    - name: download-kubectl
      image: "ellerbrock/alpine-bash-curl-ssl:latest"
      imagePullPolicy: "IfNotPresent"
      volumeMounts:
        - name: kubectl
          mountPath: /download
      workingDir: /download
      command: ["/bin/bash"]
      args:
        - "-c"
        - 'curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x ./kubectl'
u
```

Depending on how long the init containers take to complete, it might be necessary to tweak the values of `server.healthCheck.initialDelaySeconds` or `agent.healthCheck.initialDelaySeconds`.

## RBAC and Service Accounts

The RBAC section is for users who want to use the Kubernetes Elastic Agent Plugin with GoCD. The Kubernetes elastic agent plugin for GoCD brings up pods on demand while running a job.
If RBAC is enabled,
 1. A cluster role is created by default and the following privileges are provided.

    <a name="cluster-role-privileges"></a>Cluser role privileges:
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

#### Agent service account:

Service account can be configured specifically for agents. This configuration also allows for the reuse of the top level service account that is used to configure the server pod. The various settings and their possible states are described below:

| Parameter | Description | Default |
| --------------------------------------------- | ----------------------------------------------------------------------------------- | ------------------- |
| `agent.serviceAccount.reuseTopLevelServiceAccount`                   |  Specifies whether the top level service account (also used by the server) should be reused as the service account for gocd agents                                 | false                        |
| `agent.serviceAccount.name`                   |  If reuseTopLevelServiceAccount is false, this field specifies the name of an existing service account to be associated with gocd agents. By default (name field is empty), no service account is created for gocd agents | `nil`                        |

Possible states:

|State | Effect                                                                         |
|------|--------------------------------------------------|
|reuseTopLevelServiceAccount = false and name = empty|The service account 'default' will be used.|
|reuseTopLevelServiceAccount = false and name = 'agentSA'|The 'agentSA' service account will be used. The service account needs to exist and bound with the appropriate role. |
|reuseTopLevelServiceAccount = true| The GoCD service account will be created and used for the agents in the specified namespace. The permissions associated with the GoCD SA are defined here - [Cluster role privileges](#cluster-role-privileges).  |

# Adding plugins 

- Add the .jar file link from the releases section in the plugin's repo to the env.extraEnvVars section as a new environment variable.
The environment variable name must have GOCD_PLUGIN_INSTALL prefixed to it like the following section

```
env:
  extraEnvVars:
    - name: GOCD_PLUGIN_INSTALL_email-notifier
      value: https://github.com/gocd-contrib/email-notifier/releases/download/v0.3-68-exp/email-notifier-0.3-68.jar
```
- Make sure to add the link of the release you want to use before applying the values.

- If you are adding a plugin to an existing Go server, it will result in a new Go server pod being created that has the plugin installed and running.

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
