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

The following tables list the configurable parameters of the Jenkins chart and their default values.

### Jenkins Master
| Parameter                         | Description                          | Default                                                                      |
| --------------------------------- | ------------------------------------ | ---------------------------------------------------------------------------- |
| `nameOverride`                    | Override the resource name prefix    | `jenkins`                                                                    |
| `fullnameOverride`                | Override the full resource names     | `jenkins-{release-name}` (or `jenkins` if release-name is `jenkins`)         |
| `Master.Name`                     | Jenkins master name                  | `jenkins-master`                                                             |
| `Master.Image`                    | Master image name                    | `jenkins/jenkins`                                                            |
| `Master.ImageTag`                 | Master image tag                     | `lts`                                                                     |
| `Master.ImagePullPolicy`          | Master image pull policy             | `Always`                                                                     |
| `Master.ImagePullSecret`          | Master image pull secret             | Not set                                                                      |
| `Master.Component`                | k8s selector key                     | `jenkins-master`                                                             |
| `Master.UseSecurity`              | Use basic security                   | `true`                                                                       |
| `Master.SecurityRealm`            | Custom Security Realm                | Not set                                                                      |
| `Master.AuthorizationStrategy`    | Jenkins XML job config for AuthorizationStrategy | Not set                                                                      |
| `Master.ServiceLabels`            | Custom Service labels                | Not set                                                                      |
| `Master.AdminUser`                | Admin username (and password) created as a secret if useSecurity is true | `admin`                                  |
| `Master.AdminPassword`            | Admin password (and user) created as a secret if useSecurity is true | Random value                                  |
| `Master.JenkinsAdminEmail`        | Email address for the administrator of the Jenkins instance | Not set                                               |
| `Master.resources`                | Resources allocation (Requests and Limits) | `{requests: {cpu: 50m, memory: 256Mi}, limits: {cpu: 2000m, memory: 2048Mi}}`|
| `Master.InitContainerEnv`         | Environment variables for Init Container                                 | Not set                                  |
| `Master.ContainerEnv`             | Environment variables for Jenkins Container                              | Not set                                  |
| `Master.UsePodSecurityContext`    | Enable pod security context (must be `true` if `RunAsUser` or `FsGroup` are set) | `true`                           |
| `Master.RunAsUser`                | uid that jenkins runs with           | `0`                                                                          |
| `Master.FsGroup`                  | uid that will be used for persistent volume | `0`                                                                   |
| `Master.ServiceAnnotations`       | Service annotations                  | `{}`                                                                         |
| `Master.ServiceType`              | k8s service type                     | `LoadBalancer`                                                               |
| `Master.ServicePort`              | k8s service port                     | `8080`                                                                       |
| `Master.NodePort`                 | k8s node port                        | Not set                                                                      |
| `Master.HealthProbes`             | Enable k8s liveness and readiness probes | `true`                                                                   |
| `Master.HealthProbesLivenessTimeout`      | Set the timeout for the liveness probe | `120`                                                       |
| `Master.HealthProbesReadinessTimeout` | Set the timeout for the readiness probe | `60`                                                       |
| `Master.HealthProbeLivenessFailureThreshold` | Set the failure threshold for the liveness probe | `12`                                                       |
| `Master.SlaveListenerPort`        | Listening port for agents            | `50000`                                                                      |
| `Master.DisabledAgentProtocols`   | Disabled agent protocols             | `JNLP-connect JNLP2-connect`                                                                      |
| `Master.CSRF.DefaultCrumbIssuer.Enabled` | Enable the default CSRF Crumb issuer | `true`                                                                      |
| `Master.CSRF.DefaultCrumbIssuer.ProxyCompatability` | Enable proxy compatibility | `true`                                                                      |
| `Master.CLI`                      | Enable CLI over remoting             | `false`                                                                      |
| `Master.LoadBalancerSourceRanges` | Allowed inbound IP addresses         | `0.0.0.0/0`                                                                  |
| `Master.LoadBalancerIP`           | Optional fixed external IP           | Not set                                                                      |
| `Master.JMXPort`                  | Open a port, for JMX stats           | Not set                                                                      |
| `Master.ExtraPorts`               | Open extra ports, for other uses     | Not set                                                                      |
| `Master.CustomConfigMap`          | Use a custom ConfigMap               | `false`                                                                      |
| `Master.AdditionalConfig`          | Add additional config files         | `{}`                                                                      |
| `Master.OverwriteConfig`          | Replace config w/ ConfigMap on boot  | `false`                                                                      |
| `Master.Ingress.Annotations`      | Ingress annotations                  | `{}`                                                                         |
| `Master.Ingress.Path`             | Ingress path                         | Not set                                                                         |
| `Master.Ingress.TLS`              | Ingress TLS configuration            | `[]`                                                                         |
| `Master.InitScripts`              | List of Jenkins init scripts         | Not set                                                                      |
| `Master.CredentialsXmlSecret`     | Kubernetes secret that contains a 'credentials.xml' file | Not set                                                  |
| `Master.SecretsFilesSecret`       | Kubernetes secret that contains 'secrets' files | Not set                                                           |
| `Master.Jobs`                     | Jenkins XML job configs              | Not set                                                                      |
| `Master.InstallPlugins`           | List of Jenkins plugins to install   | `kubernetes:1.12.0 workflow-aggregator:2.5 credentials-binding:1.16 git:3.9.1 workflow-job:2.23` |
| `Master.ScriptApproval`           | List of groovy functions to approve  | Not set                                                                      |
| `Master.NodeSelector`             | Node labels for pod assignment       | `{}`                                                                         |
| `Master.Affinity`                 | Affinity settings                    | `{}`                                                                         |
| `Master.Tolerations`              | Toleration labels for pod assignment | `{}`                                                                         |
| `Master.PodAnnotations`           | Annotations for master pod           | `{}`                                                                         |
| `NetworkPolicy.Enabled`           | Enable creation of NetworkPolicy resources. | `false`                                                               |
| `NetworkPolicy.ApiVersion`        | NetworkPolicy ApiVersion             | `extensions/v1beta1`                                                         |
| `rbac.install`                    | Create service account and ClusterRoleBinding for Kubernetes plugin | `false`                                       |
| `rbac.roleRef`                    | Cluster role name to bind to         | `cluster-admin`                                                              |
| `rbac.roleBindingKind`            | Role kind (`RoleBinding` or `ClusterRoleBinding`)| `ClusterRoleBinding`                                             |

### Jenkins Agent

| Parameter                  | Description                                     | Default                |
| -------------------------- | ----------------------------------------------- | ---------------------- |
| `Agent.AlwaysPullImage`    | Always pull agent container image before build  | `false`                |
| `Agent.CustomJenkinsLabels`| Append Jenkins labels to the agent              | `{}`                   |
| `Agent.Enabled`            | Enable Kubernetes plugin jnlp-agent podTemplate | `true`                 |
| `Agent.Image`              | Agent image name                                | `jenkinsci/jnlp-slave` |
| `Agent.ImagePullSecret`    | Agent image pull secret                         | Not set                |
| `Agent.ImageTag`           | Agent image tag                                 | `2.62`                 |
| `Agent.Privileged`         | Agent privileged container                      | `false`                |
| `Agent.resources`          | Resources allocation (Requests and Limits)      | `{requests: {cpu: 200m, memory: 256Mi}, limits: {cpu: 200m, memory: 256Mi}}`|
| `Agent.volumes`            | Additional volumes                              | `nil`                  |

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

## Adding customized securityRealm

`Master.SecurityRealm` in values can be used to support custom security realm instead of default `LegacySecurityRealm`. For example, you can add a security realm to authenticate via keycloak.

```yaml
SecurityRealm: |-
  <securityRealm class="org.jenkinsci.plugins.oic.OicSecurityRealm" plugin="oic-auth@1.0">
    <clientId>testId</clientId>
    <clientSecret>testsecret</clientSecret>
    <tokenServerUrl>https:testurl</tokenServerUrl>
    <authorizationServerUrl>https:testAuthUrl</authorizationServerUrl>
    <userNameField>email</userNameField>
    <scopes>openid email</scopes>
  </securityRealm>
```

## Adding additional configs

`Master.AdditionalConfig` can be used to add additional config files in `config.yaml`. For example, it can be used to add additional config files for keycloak authentication.

```yaml
AdditionalConfig:
  testConfig.txt: |-
    - name: testName
      clientKey: testKey
      clientURL: testUrl
```

## Adding customized labels

`Master.ServiceLabels` can be used to add custom labels in `jenkins-master-svc.yaml`. For example,

```yaml
ServiceLabels:
  expose: true
```

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
| `Persistence.SubPath`       | SubPath for jenkins-home mount  | `nil`           |
| `Persistence.volumes`       | Additional volumes              | `nil`           |
| `Persistence.mounts`        | Additional mounts               | `nil`           |

#### Existing PersistentVolumeClaim

1. Create the PersistentVolume
2. Create the PersistentVolumeClaim
3. Install the chart

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

## Providing jobs xml

Jobs can be created (and overwritten) by providing jenkins config xml within the `values.yaml` file.
The keys of the map will become a directory within the jobs directory.
The values of the map will become the `config.xml` file in the respective directory.

Below is an example of a `values.yaml` file and the directory structure created:

#### values.yaml
```yaml
Master:
  Jobs:
    test-job: |-
      <?xml version='1.0' encoding='UTF-8'?>
      <project>
        <keepDependencies>false</keepDependencies>
        <properties/>
        <scm class="hudson.scm.NullSCM"/>
        <canRoam>false</canRoam>
        <disabled>false</disabled>
        <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
        <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
        <triggers/>
        <concurrentBuild>false</concurrentBuild>
        <builders/>
        <publishers/>
        <buildWrappers/>
      </project>
    test-job-2: |-
      <?xml version='1.0' encoding='UTF-8'?>
      <project>
        <keepDependencies>false</keepDependencies>
        <properties/>
        <scm class="hudson.scm.NullSCM"/>
        <canRoam>false</canRoam>
        <disabled>false</disabled>
        <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
        <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
        <triggers/>
        <concurrentBuild>false</concurrentBuild>
        <builders/>
        <publishers/>
        <buildWrappers/>
```

#### Directory structure of jobs directory
```
.
├── _test-job-1
|   └── config.xml
├── _test-job-2
|   └── config.xml
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
