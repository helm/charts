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
| `Master.NumExecutors`             | Set Number of executors              | 0                                                                             |
| `Master.UseSecurity`              | Use basic security                   | `true`                                                                       |
| `Master.SecurityRealm`            | Custom Security Realm                | Not set                                                                      |
| `Master.AuthorizationStrategy`    | Jenkins XML job config for AuthorizationStrategy | Not set                                                                      |
| `Master.DeploymentLabels`         | Custom Deployment labels             | Not set                                                                      |
| `Master.ServiceLabels`            | Custom Service labels                | Not set                                                                      |
| `Master.PodLabels`                | Custom Pod labels                    | Not set                                                                      |
| `Master.AdminUser`                | Admin username (and password) created as a secret if useSecurity is true | `admin`                                  |
| `Master.AdminPassword`            | Admin password (and user) created as a secret if useSecurity is true | Random value                                  |
| `Master.JenkinsAdminEmail`        | Email address for the administrator of the Jenkins instance | Not set                                               |
| `Master.resources`                | Resources allocation (Requests and Limits) | `{requests: {cpu: 50m, memory: 256Mi}, limits: {cpu: 2000m, memory: 4096Mi}}`|
| `Master.InitContainerEnv`         | Environment variables for Init Container                                 | Not set                                  |
| `Master.ContainerEnv`             | Environment variables for Jenkins Container                              | Not set                                  |
| `Master.UsePodSecurityContext`    | Enable pod security context (must be `true` if `RunAsUser` or `FsGroup` are set) | `true`                           |
| `Master.RunAsUser`                | uid that jenkins runs with           | `0`                                                                          |
| `Master.FsGroup`                  | uid that will be used for persistent volume | `0`                                                                   |
| `Master.HostAliases`              | Aliases for IPs in `/etc/hosts`      | `[]`                                                                         |
| `Master.ServiceAnnotations`       | Service annotations                  | `{}`                                                                         |
| `Master.ServiceType`              | k8s service type                     | `LoadBalancer`                                                               |
| `Master.ServicePort`              | k8s service port                     | `8080`                                                                       |
| `Master.NodePort`                 | k8s node port                        | Not set                                                                      |
| `Master.HealthProbes`             | Enable k8s liveness and readiness probes | `true`                                                                   |
| `Master.HealthProbesLivenessTimeout`      | Set the timeout for the liveness probe | `120`                                                       |
| `Master.HealthProbesReadinessTimeout` | Set the timeout for the readiness probe | `60`                                                       |
| `Master.HealthProbeReadinessPeriodSeconds` | Set how often (in seconds) to perform the liveness probe | `10`                                                       |
| `Master.HealthProbeLivenessFailureThreshold` | Set the failure threshold for the liveness probe | `12`                                                       |
| `Master.SlaveListenerPort`        | Listening port for agents            | `50000`                                                                      |
| `Master.SlaveHostPort`        | Host port to listen for agents            | Not set                                                                |
| `Master.DisabledAgentProtocols`   | Disabled agent protocols             | `JNLP-connect JNLP2-connect`                                                                      |
| `Master.CSRF.DefaultCrumbIssuer.Enabled` | Enable the default CSRF Crumb issuer | `true`                                                                      |
| `Master.CSRF.DefaultCrumbIssuer.ProxyCompatability` | Enable proxy compatibility | `true`                                                                      |
| `Master.CLI`                      | Enable CLI over remoting             | `false`                                                                      |
| `Master.LoadBalancerSourceRanges` | Allowed inbound IP addresses         | `0.0.0.0/0`                                                                  |
| `Master.LoadBalancerIP`           | Optional fixed external IP           | Not set                                                                      |
| `Master.JMXPort`                  | Open a port, for JMX stats           | Not set                                                                      |
| `Master.ExtraPorts`               | Open extra ports, for other uses     | Not set                                                                      |
| `Master.OverwriteConfig`          | Replace init scripts and config w/ ConfigMap on boot  | `false`                                                                      |
| `Master.ingress.enabled`          | Enables ingress      | `false`                                                                         |
| `Master.ingress.apiVersion`       | Ingress API version                  | `extensions/v1beta1`                                                         |
| `Master.ingress.hostName`         | Ingress host name      | Not set                                                                         |
| `Master.ingress.annotations`      | Ingress annotations                  | `{}`                                                                         |
| `Master.ingress.labels`           | Ingress labels                       | `{}`                                                                         |
| `Master.ingress.path`             | Ingress path                         | Not set                                                                         |
| `Master.ingress.tls`              | Ingress TLS configuration            | `[]`                                                                         |
| `Master.JCasC.enabled`            | Wheter Jenkins Configuration as Code is enabled or not | `false`                                                    |
| `Master.JCasC.ConfigScripts`      | List of Jenkins Config as Code scripts | False                                                                      |
| `Master.Sidecars.configAutoReload` | Jenkins Config as Code auto-reload settings |                                                                      |
| `Master.Sidecars.configAutoReload.enabled` | Jenkins Config as Code auto-reload settings (Attention: rbac needs to be enabled otherwise the sidecar can't read the config map) | `false`                                                      |
| `Master.Sidecars.configAutoReload.image` | Image which triggers the reload | `shadwell/k8s-sidecar:0.0.2`                        ````                       |
| `Master.Sidecars.others`          | Configures additional sidecar container(s) for Jenkins master | `{}`                                                |
| `Master.InitScripts`              | List of Jenkins init scripts         | Not set                                                                      |
| `Master.CredentialsXmlSecret`     | Kubernetes secret that contains a 'credentials.xml' file | Not set                                                  |
| `Master.SecretsFilesSecret`       | Kubernetes secret that contains 'secrets' files | Not set                                                           |
| `Master.Jobs`                     | Jenkins XML job configs              | Not set                                                                      |
| `Master.overwriteJobs`          | Replace jobs w/ ConfigMap on boot  | `false`                                                                      |
| `Master.InstallPlugins`           | List of Jenkins plugins to install   | `kubernetes:1.14.0 workflow-aggregator:2.6 credentials-binding:1.17 git:3.9.1 workflow-job:2.31` |
| `Master.OverwritePlugins`         | Overwrite installed plugins on start.| `false`                                                                      |
| `Master.EnableRawHtmlMarkupFormatter` | Enable HTML parsing using (see below) | Not set                                                                 |
| `Master.ScriptApproval`           | List of groovy functions to approve  | Not set                                                                      |
| `Master.NodeSelector`             | Node labels for pod assignment       | `{}`                                                                         |
| `Master.Affinity`                 | Affinity settings                    | `{}`                                                                         |
| `Master.Tolerations`              | Toleration labels for pod assignment | `{}`                                                                         |
| `Master.PodAnnotations`           | Annotations for master pod           | `{}`                                                                         |
| `Master.CustomConfigMap`          | Deprecated: Use a custom ConfigMap               | `false`                                                                      |
| `Master.AdditionalConfig`         | Deprecated: Add additional config files         | `{}`
| `Master.JenkinsUriPrefix`         | Root Uri Jenkins will be served on         | Not set
| `NetworkPolicy.Enabled`           | Enable creation of NetworkPolicy resources. | `false`                                                               |
| `NetworkPolicy.ApiVersion`        | NetworkPolicy ApiVersion             | `networking.k8s.io/v1`                                                         |
| `rbac.install`                    | Create service account and ClusterRoleBinding for Kubernetes plugin | `false`                                       |
| `rbac.serviceAccountName`         | Name of service account     | `default` |
| `rbac.serviceAccountAnnotations`  | Service Account annotations | `{}` |
| `rbac.roleRef`                    | Cluster role name to bind to         | `cluster-admin`                                                              |
| `rbac.roleKind`            | Role kind (`Role` or `ClusterRole`)| `ClusterRole`
| `rbac.roleBindingKind`            | Role binding kind (`RoleBinding` or `ClusterRoleBinding`)| `ClusterRoleBinding`                                             |

Some third-party systems, e.g. GitHub, use HTML-formatted data in their payload sent to a Jenkins webhooks, e.g. URL of a pull-request being built. To display such data as processed HTML instead of raw text set `Master.EnableRawHtmlMarkupFormatter` to true. This option requires installation of OWASP Markup Formatter Plugin (antisamy-markup-formatter). The plugin is **not** installed by default, please update `Master.InstallPlugins`.

### Jenkins Agent

| Parameter                  | Description                                     | Default                |
| -------------------------- | ----------------------------------------------- | ---------------------- |
| `Agent.AlwaysPullImage`    | Always pull agent container image before build  | `false`                |
| `Agent.CustomJenkinsLabels`| Append Jenkins labels to the agent              | `{}`                   |
| `Agent.Enabled`            | Enable Kubernetes plugin jnlp-agent podTemplate | `true`                 |
| `Agent.Image`              | Agent image name                                | `jenkins/jnlp-slave` |
| `Agent.ImagePullSecret`    | Agent image pull secret                         | Not set                |
| `Agent.ImageTag`           | Agent image tag                                 | `3.27-1`                 |
| `Agent.Privileged`         | Agent privileged container                      | `false`                |
| `Agent.resources`          | Resources allocation (Requests and Limits)      | `{requests: {cpu: 200m, memory: 256Mi}, limits: {cpu: 200m, memory: 256Mi}}`|
| `Agent.volumes`            | Additional volumes                              | `nil`                  |
| `Agent.envVars`            | Environment variables for the slave Pod         | Not set                |
| `Agent.Command`            | Executed command when side container starts     | Not set                |
| `Agent.Args`               | Arguments passed to executed command            | Not set                |
| `Agent.SideContainerName`  | Side container name in agent                    | jnlp                   |
| `Agent.TTYEnabled`         | Allocate pseudo tty to the side container       | false                  |
| `Agent.ContainerCap`       | Maximum number of agent                         | 10                     |
| `Agent.PodName`            | slave Pod base name                             | Not set                |


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

## Configuration as Code
Jenkins Configuration as Code is now a standard component in the Jenkins project.  Add a key under ConfigScripts for each configuration area, where each corresponds to a plugin or section of the UI.  The keys (prior to | character) are just labels, and can be any value.  They are only used to give the section a meaningful name.  The only restriction is they must conform to RFC 1123 definition of a DNS label, so may only contain lowercase letters, numbers, and hyphens.  Each key will become the name of a configuration yaml file on the master in /var/jenkins_home/casc_configs (by default) and will be processed by the Configuration as Code Plugin during Jenkins startup.  The lines after each | become the content of the configuration yaml file.  The first line after this is a JCasC root element, eg jenkins, credentials, etc.  Best reference is the Documentation link here: https://<jenkins_url>/configuration-as-code.  The example below creates ldap settings:

```yaml
ConfigScripts:
  ldap-settings: |
    jenkins:
      securityRealm:
        ldap:
          configurations:
            configurations:
              - server: ldap.acme.com
                rootDN: dc=acme,dc=uk
                managerPasswordSecret: ${LDAP_PASSWORD}
              - groupMembershipStrategy:
                  fromUserRecord:
                    attributeName: "memberOf"
```

Further JCasC examples can be found [here.](https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos)
### Config as Code with and without auto-reload 
Config as Code changes (to Master.JCasC.ConfigScripts) can either force a new pod to be created and only be applied at next startup, or can be auto-reloaded on-the-fly.  If you choose `Master.Sidecars.autoConfigReload.enabled: true`, a second, auxiliary container will be installed into the Jenkins master pod, known as a "sidecar".  This watches for changes to ConfigScripts, copies the content onto the Jenkins file-system and issues a CLI command via SSH to reload configuration.  The admin user (or account you specify in Master.AdminUser) will have a random SSH private key (RSA 4096) assigned unless you specify a key in `Master.AdminSshKey`.  This will be saved to a k8s secret.  You can monitor this sidecar's logs using command `kubectl logs <master_pod> -c jenkins-sc-config -f`
If you want to enable auto-reload then you also need to configure rbac as the container which triggers the reload needs to watch the config maps.

```yaml
Master:
  JCasC:
    enabled: true
  Sidecars:
    configAutoReload:
      enabled: true
rbac:
  install: true
```

### Auto-reload with non-Jenkins identities
When enabling LDAP or another non-Jenkins identity source, the built-in admin account will no longer exist.  Since the admin account is used by the sidecar to reload config, in order to use auto-reload, you must change the .Master.AdminUser to a valid username on your LDAP (or other) server.  If you use the matrix-auth plugin, this user must also be granted Overall\Administer rights in Jenkins.  Failure to do this will cause the sidecar container to fail to authenticate via SSH and enter a restart loop.  You can enable LDAP using the example above and add a Config as Code block for matrix security that includes:
```yaml
ConfigScripts:
  matrix-auth: |
    jenkins:
      authorizationStrategy:
        projectMatrix:
          grantedPermissions:
          - "Overall/Administer:<AdminUser_LDAP_username>"
```
You can instead grant this permission via the UI. When this is done, you can set `Master.Sidecars.configAutoReload.enabled: true` and upon the next Helm upgrade, auto-reload will be successfully enabled.

## RBAC

If running upon a cluster with RBAC enabled you will need to do the following:

* `helm install stable/jenkins --set rbac.install=true`
* Create a Jenkins credential of type Kubernetes service account with service account name provided in the `helm status` output.
* Under configure Jenkins -- Update the credentials config in the cloud section to use the service account credential you created in the step above.

## Backup

Adds a backup CronJob for jenkins, along with required RBAC resources.

### Backup Values

| Parameter                   | Description                                | Default                           |
| --------------------------- | ------------------------------------------ | --------------------------------- |
| `backup.enabled`            | Enable the use of a backup CronJob         | `false`                           |
| `backup.schedule`           | Schedule to run jobs                       | `0 2 * * *`                       |
| `backup.annotations`        | Backup pod annotations                     | iam.amazonaws.com/role: `jenkins` |
| `backup.image.repo`         | Backup image repository                    | `nuvo/kube-tasks`                 |
| `backup.image.tag`          | Backup image tag                           | `0.1.2`                           |
| `backup.extraArgs`          | Additional arguments for kube-tasks        | `[]`                              |
| `backup.env`                | Backup environment variables               | AWS_REGION: `us-east-1`           |
| `backup.resources`          | Backup CPU/Memory resource requests/limits | Memory: `1Gi`, CPU: `1`           |
| `backup.destination`        | Destination to store backup artifacts      | `s3://nuvo-jenkins-data/backup`   |

### Restore from backup

To restore a backup, you can use the `kube-tasks` underlying tool called [skbn](https://github.com/nuvo/skbn), which copies files from cloud storage to Kubernetes.
The best way to do it would be using a `Job` to copy files from the desired backup tag to the Jenkins pod.
See the [skbn in-cluster example](https://github.com/nuvo/skbn/tree/master/examples/in-cluster) for more details.


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

## Custom ConfigMap

The following configuration method is deprecated and will be removed in an upcoming version of this chart.
We recommend you use Jenkins Configuration as Code to configure instead.
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
