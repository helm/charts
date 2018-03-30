# Jenkins Helm Chart

Jenkins master and slave cluster utilizing the Jenkins Kubernetes plugin

* https://wiki.jenkins-ci.org/display/JENKINS/Kubernetes+Plugin

Inspired by the awesome work of Carlos Sanchez <mailto:carlos@apache.org>

## Chart Details

This chart will do the following:

* 1 x Jenkins Master with port 8080 exposed on an external LoadBalancer
* All using Kubernetes Deployments

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release stable/jenkins
```

## Configuration

The following tables lists the configurable parameters of the Jenkins chart and their default values.

### Jenkins Master
| Parameter                         | Description                          | Default                                                                      |
| --------------------------------- | ------------------------------------ | ---------------------------------------------------------------------------- |
| `nameOverride`                    | Override the resource name prefix    | `jenkins`                                                                    |
| `fullnameOverride`                | Override the full resource names     | `jenkins-{release-name}` (or `jenkins` if release-name is `jenkins`)         |
| `Master.Name`                     | Jenkins master name                  | `jenkins-master`                                                             |
| `Master.Image`                    | Master image name                    | `jenkinsci/jenkins`                                                          |
| `Master.ImageTag`                 | Master image tag                     | `2.46.1`                                                                     |
| `Master.ImagePullPolicy`          | Master image pull policy             | `Always`                                                                     |
| `Master.ImagePullSecret`          | Master image pull secret             | Not set                                                                      |
| `Master.Component`                | k8s selector key                     | `jenkins-master`                                                             |
| `Master.UseSecurity`              | Use basic security                   | `true`                                                                       |
| `Master.AdminUser`                | Admin username (and password) created as a secret if useSecurity is true | `admin`                                  |
| `Master.Cpu`                      | Master requested cpu                 | `200m`                                                                       |
| `Master.Memory`                   | Master requested memory              | `256Mi`                                                                      |
| `Master.InitContainerEnv`         | Environment variables for Init Container                                 | Not set                                  |
| `Master.ContainerEnv`             | Environment variables for Jenkins Container                              | Not set                                  |
| `Master.RunAsUser`                | uid that jenkins runs with           | `0`                                                                          |
| `Master.FsGroup`                  | uid that will be used for persistent volume | `0`                                                                   |
| `Master.ServiceAnnotations`       | Service annotations                  | `{}`                                                                         |
| `Master.ServiceType`              | k8s service type                     | `LoadBalancer`                                                               |
| `Master.ServicePort`              | k8s service port                     | `8080`                                                                       |
| `Master.NodePort`                 | k8s node port                        | Not set                                                                      |
| `Master.HealthProbes`             | Enable k8s liveness and readiness probes | `true`                                                                   |
| `Master.HealthProbesTimeout`      | Set the timeout for the liveness and readiness probes | `120`                                                       |
| `Master.ContainerPort`            | Master listening port                | `8080`                                                                       |
| `Master.SlaveListenerPort`        | Listening port for agents            | `50000`                                                                      |
| `Master.LoadBalancerSourceRanges` | Allowed inbound IP addresses         | `0.0.0.0/0`                                                                  |
| `Master.LoadBalancerIP`           | Optional fixed external IP           | Not set                                                                      |
| `Master.JMXPort`                  | Open a port, for JMX stats           | Not set                                                                      |
| `Master.CustomConfigMap`          | Use a custom ConfigMap               | `false`                                                                      |
| `Master.Ingress.Annotations`      | Ingress annotations                  | `{}`                                                                         |
| `Master.Ingress.TLS`              | Ingress TLS configuration            | `[]`                                                                         |
| `Master.InitScripts`              | List of Jenkins init scripts         | Not set                                                                      |
| `Master.CredentialsXmlSecret`     | Kubernetes secret that contains a 'credentials.xml' file | Not set                                                  |
| `Master.SecretsFilesSecret`       | Kubernetes secret that contains 'secrets' files | Not set                                                           |
| `Master.Jobs`                     | Jenkins XML job configs              | Not set                                                                      |
| `Master.InstallPlugins`           | List of Jenkins plugins to install   | `kubernetes:0.11 workflow-aggregator:2.5 credentials-binding:1.11 git:3.2.0` |
| `Master.ScriptApproval`           | List of groovy functions to approve  | Not set                                                                      |
| `Master.NodeSelector`             | Node labels for pod assignment       | `{}`                                                                         |
| `Master.Affinity`                 | Affinity settings                    | `{}`                                                                         |
| `Master.Tolerations`              | Toleration labels for pod assignment | `{}`                                                                         |
| `NetworkPolicy.Enabled`           | Enable creation of NetworkPolicy resources. | `false`                                                               |
| `NetworkPolicy.ApiVersion`        | NetworkPolicy ApiVersion             | `extensions/v1beta1`                                                         |
| `rbac.install`                    | Create service account and ClusterRoleBinding for Kubernetes plugin | `false`                                       |
| `rbac.apiVersion`                 | RBAC API version                     | `v1beta1`                                                                    |
| `rbac.roleRef`                    | Cluster role name to bind to         | `cluster-admin`                                                              |

### Jenkins Agent

| Parameter               | Description                                     | Default                |
| ----------------------- | ----------------------------------------------- | ---------------------- |
| `Agent.AlwaysPullImage` | Always pull agent container image before build  | `false`                |
| `Agent.Enabled`         | Enable Kubernetes plugin jnlp-agent podTemplate | `true`                 |
| `Agent.Image`           | Agent image name                                | `jenkinsci/jnlp-slave` |
| `Agent.ImagePullSecret` | Agent image pull secret                         | Not set                |
| `Agent.ImageTag`        | Agent image tag                                 | `2.62`                 |
| `Agent.Privileged`      | Agent privileged container                      | `false`                |
| `Agent.Cpu`             | Agent requested cpu                             | `200m`                 |
| `Agent.Memory`          | Agent requested memory                          | `256Mi`                |
| `Agent.volumes`         | Additional volumes                              | `nil`                  |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/jenkins
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Mounting volumes into your Agent pods

Your Jenkins Agents will run as pods, and it's possible to inject volumes where needed:

```yaml
Agent:
  volumes:
  - type: Secret
    secretName: jenkins-mysecrets
    mountPath: /var/run/secrets/jenkins-mysecrets
```

The supported volume types are: `ConfigMap`, `EmptyDir`, `HostPath`, `Nfs`, `Pod`, `Secret`. Each type supports a different set of configurable attributes, defined by [the corresponding Java class](https://github.com/jenkinsci/kubernetes-plugin/tree/master/src/main/java/org/csanchez/jenkins/plugins/kubernetes/volumes).

## NetworkPolicy

To make use of the NetworkPolicy resources created by default,
install [a networking plugin that implements the Kubernetes
NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin).

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting
the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

    kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"

Install helm chart with network policy enabled:

    $ helm install stable/jenkins --set NetworkPolicy.Enabled=true

## Persistence

The Jenkins image stores persistence under `/var/jenkins_home` path of the container. A dynamically managed Persistent Volume
Claim is used to keep the data across deployments, by default. This is known to work in GCE, AWS, and minikube. Alternatively,
a previously configured Persistent Volume Claim can be used.

It is possible to mount several volumes using `Persistence.volumes` and `Persistence.mounts` parameters.

### Persistence Values

| Parameter                   | Description                     | Default         |
| --------------------------- | ------------------------------- | --------------- |
| `Persistence.Enabled`       | Enable the use of a Jenkins PVC | `true`          |
| `Persistence.ExistingClaim` | Provide the name of a PVC       | `nil`           |
| `Persistence.AccessMode`    | The PVC access mode             | `ReadWriteOnce` |
| `Persistence.Size`          | The size of the PVC             | `8Gi`           |
| `Persistence.volumes`       | Additional volumes              | `nil`           |
| `Persistence.mounts`        | Additional mounts               | `nil`           |

#### Existing PersistentVolumeClaim

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart

```bash
$ helm install --name my-release --set Persistence.ExistingClaim=PVC_NAME stable/jenkins
```

## Custom ConfigMap

When creating a new parent chart with this chart as a dependency, the `CustomConfigMap` parameter can be used to override the default config.xml provided.
It also allows for providing additional xml configuration files that will be copied into `/var/jenkins_home`. In the parent chart's values.yaml,
set the `jenkins.Master.CustomConfigMap` value to true like so

```yaml
jenkins:
  Master:
    CustomConfigMap: true
```

and provide the file `templates/config.tpl` in your parent chart for your use case. You can start by copying the contents of `config.yaml` from this chart into your parent charts `templates/config.tpl` as a basis for customization. Finally, you'll need to wrap the contents of `templates/config.tpl` like so:

```yaml
{{- define "override_config_map" }}
    <CONTENTS_HERE>
{{ end }}
```

## RBAC

If running upon a cluster with RBAC enabled you will need to do the following:

* `helm install stable/jenkins --set rbac.install=true`
* Create a Jenkins credential of type Kubernetes service account with service account name provided in the `helm status` output.
* Under configure Jenkins -- Update the credentials config in the cloud section to use the service account credential you created in the step above.

## Run Jenkins as non root user

The default settings of this helm chart let Jenkins run as root user with uid `0`.
Due to security reasons you may want to run Jenkins as a non root user.
Fortunately the default jenkins docker image `jenkins/jenkins` contains a user `jenkins` with uid `1000` that can be used for this purpose.

Simply use the following settings to run Jenkins as `jenkins` user with uid `1000`.

```yaml
jenkins:
  Master:
    RunAsUser: 1000
    FsGroup: 1000
```

Docs taken from https://github.com/jenkinsci/docker/blob/master/Dockerfile:
_Jenkins is run with user `jenkins`, uid = 1000. If you bind mount a volume from the host or a data container,ensure you use the same uid_

## Running behind a forward proxy

The master pod uses an Init Container to install plugins etc. If you are behind a corporate proxy it may be useful to set `Master.InitContainerEnv` to add environment variables such as `http_proxy`, so that these can be downloaded.

Additionally, you may want to add env vars for the Jenkins container, and the JVM (`Master.JavaOpts`).

```yaml
Master:
  InitContainerEnv:
    - name: http_proxy
      value: "http://192.168.64.1:3128"
    - name: https_proxy
      value: "http://192.168.64.1:3128"
    - name: no_proxy
      value: ""
  ContainerEnv:
    - name: http_proxy
      value: "http://192.168.64.1:3128"
    - name: https_proxy
      value: "http://192.168.64.1:3128"
  JavaOpts: >-
    -Dhttp.proxyHost=192.168.64.1
    -Dhttp.proxyPort=3128
    -Dhttps.proxyHost=192.168.64.1
    -Dhttps.proxyPort=3128
```
