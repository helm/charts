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

## Upgrading an existing Release to a new major version

A major chart version change (like v0.40.0 -> v1.0.0) indicates that there is an incompatible breaking change needing manual actions.


### 1.0.0

Breaking changes:

- values have been renamed to follow helm chart best practices for naming conventions so
  that all variables start with a lowercase letter and words are separated with camelcase
  https://helm.sh/docs/chart_best_practices/#naming-conventions
- all resources are now using recommended standard labels
  https://helm.sh/docs/chart_best_practices/#standard-labels

As a result of the label changes also the selectors of the deployment have been updated.
Those are immutable so trying an updated will cause an error like:

```
Error: Deployment.apps "jenkins" is invalid: spec.selector: Invalid value: v1.LabelSelector{MatchLabels:map[string]string{"app.kubernetes.io/component":"jenkins-master", "app.kubernetes.io/instance":"jenkins"}, MatchExpressions:[]v1.LabelSelectorRequirement(nil)}: field is immutable
```

In order to upgrade, delete the Jenkins Deployment before upgrading:

```
kubectl delete deploy jenkins
```


## Configuration

The following tables list the configurable parameters of the Jenkins chart and their default values.

### Jenkins Master

| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `checkDeprecation`                | Checks for deprecated values used    | `true`                                 |
| `nameOverride`                    | Override the resource name prefix    | `jenkins`                                 |
| `fullnameOverride`                | Override the full resource names     | `jenkins-{release-name}` (or `jenkins` if release-name is `jenkins`) |
| `master.componentName`            | Jenkins master name                  | `jenkins-master`                          |
| `master.image`                    | Master image name                    | `jenkins/jenkins`                         |
| `master.imageTag`                 | Master image tag                     | `lts`                                     |
| `master.imagePullPolicy`          | Master image pull policy             | `Always`                                  |
| `master.imagePullSecret`          | Master image pull secret             | Not set                                   |
| `master.numExecutors`             | Set Number of executors              | 0                                         |
| `master.useSecurity`              | Use basic security                   | `true`                                    |
| `master.securityRealm`            | Custom Security Realm                | Not set                                   |
| `master.authorizationStrategy`    | Jenkins XML job config for AuthorizationStrategy | Not set                       |
| `master.deploymentLabels`         | Custom Deployment labels             | Not set                                   |
| `master.serviceLabels`            | Custom Service labels                | Not set                                   |
| `master.podLabels`                | Custom Pod labels                    | Not set                                   |
| `master.adminUser`                | Admin username (and password) created as a secret if useSecurity is true | `admin` |
| `master.adminPassword`            | Admin password (and user) created as a secret if useSecurity is true | Random value |
| `master.jenkinsAdminEmail`        | Email address for the administrator of the Jenkins instance | Not set            |
| `master.resources`                | Resources allocation (Requests and Limits) | `{requests: {cpu: 50m, memory: 256Mi}, limits: {cpu: 2000m, memory: 4096Mi}}`|
| `master.initContainerEnv`         | Environment variables for Init Container                                 | Not set |
| `master.containerEnv`             | Environment variables for Jenkins Container                              | Not set |
| `master.usePodSecurityContext`    | Enable pod security context (must be `true` if `runAsUser` or `fsGroup` are set) | `true` |
| `master.runAsUser`                | uid that jenkins runs with           | `0`                                       |
| `master.fsGroup`                  | uid that will be used for persistent volume | `0`                                |
| `master.hostAliases`              | Aliases for IPs in `/etc/hosts`      | `[]`                                      |
| `master.serviceAnnotations`       | Service annotations                  | `{}`                                      |
| `master.serviceType`              | k8s service type                     | `LoadBalancer`                            |
| `master.servicePort`              | k8s service port                     | `8080`                                    |
| `master.targetPort`               | k8s target port                      | `8080`                                    |
| `master.nodePort`                 | k8s node port                        | Not set                                   |
| `master.healthProbes`             | Enable k8s liveness and readiness probes    | `true`                             |
| `master.healthProbesLivenessTimeout`  | Set the timeout for the liveness probe  | `5`                              |
| `master.healthProbesReadinessTimeout` | Set the timeout for the readiness probe | `5`                               |
| `master.healthProbeLivenessPeriodSeconds` | Set how often (in seconds) to perform the liveness probe | `10`         |
| `master.healthProbeReadinessPeriodSeconds` | Set how often (in seconds) to perform the readiness probe | `10`         |
| `master.healthProbeLivenessFailureThreshold` | Set the failure threshold for the liveness probe | `5`               |
| `master.healthProbeReadinessFailureThreshold` | Set the failure threshold for the readiness probe | `3`               |
| `master.healthProbeLivenessInitialDelay` | Set the initial delay for the liveness probe | `90`               |
| `master.healthProbeReadinessInitialDelay` | Set the initial delay for the readiness probe | `60`               |
| `master.slaveListenerPort`        | Listening port for agents            | `50000`                                   |
| `master.slaveHostPort`            | Host port to listen for agents            | Not set                              |
| `master.slaveKubernetesNamespace` | Namespace in which the Kubernetes agents should be launched  | Not set           |
| `master.disabledAgentProtocols`   | Disabled agent protocols             | `JNLP-connect JNLP2-connect`              |
| `master.csrf.defaultCrumbIssuer.enabled` | Enable the default CSRF Crumb issuer | `true`                             |
| `master.csrf.defaultCrumbIssuer.proxyCompatability` | Enable proxy compatibility | `true`                            |
| `master.cli`                      | Enable CLI over remoting             | `false`                                   |
| `master.loadBalancerSourceRanges` | Allowed inbound IP addresses         | `0.0.0.0/0`                               |
| `master.loadBalancerIP`           | Optional fixed external IP           | Not set                                   |
| `master.jmxPort`                  | Open a port, for JMX stats           | Not set                                   |
| `master.extraPorts`               | Open extra ports, for other uses     | Not set                                   |
| `master.overwriteConfig`          | Replace init scripts and config w/ ConfigMap on boot  | `false`                  |
| `master.ingress.enabled`          | Enables ingress                      | `false`                                   |
| `master.ingress.apiVersion`       | Ingress API version                  | `extensions/v1beta1`                      |
| `master.ingress.hostName`         | Ingress host name                    | Not set                                   |
| `master.ingress.annotations`      | Ingress annotations                  | `{}`                                      |
| `master.ingress.labels`           | Ingress labels                       | `{}`                                      |
| `master.ingress.path`             | Ingress path                         | Not set                                   |
| `master.ingress.tls`              | Ingress TLS configuration            | `[]`                                      |
| `master.route.enabled`            | Enables openshift route              | `false`                                   |
| `master.route.annotations`        | Route annotations                    | `{}`                                      |
| `master.route.labels`             | Route labels                         | `{}`                                      |
| `master.route.path`               | Route path                           | Not set                                   |
| `master.jenkinsUrlProtocol`       | Set protocol for JenkinsLocationConfiguration.xml | Set to `https` if `Master.ingress.tls`, `http` otherwise |
| `master.JCasC.enabled`            | Wheter Jenkins Configuration as Code is enabled or not | `false`                 |
| `master.JCasC.configScripts`      | List of Jenkins Config as Code scripts | False                                   |
| `master.sidecars.configAutoReload` | Jenkins Config as Code auto-reload settings |                                   |
| `master.sidecars.configAutoReload.enabled` | Jenkins Config as Code auto-reload settings (Attention: rbac needs to be enabled otherwise the sidecar can't read the config map) | `false`                                                      |
| `master.sidecars.configAutoReload.image` | Image which triggers the reload | `shadwell/k8s-sidecar:0.0.2`            |
| `master.sidecars.others`          | Configures additional sidecar container(s) for Jenkins master | `{}`             |
| `master.initScripts`              | List of Jenkins init scripts         | Not set                                   |
| `master.credentialsXmlSecret`     | Kubernetes secret that contains a 'credentials.xml' file | Not set               |
| `master.secretsFilesSecret`       | Kubernetes secret that contains 'secrets' files | Not set                        |
| `master.jobs`                     | Jenkins XML job configs              | Not set                                   |
| `master.overwriteJobs`            | Replace jobs w/ ConfigMap on boot    | `false`                                   |
| `master.installPlugins`           | List of Jenkins plugins to install   | `kubernetes:1.14.0 workflow-aggregator:2.6 credentials-binding:1.17 git:3.9.1 workflow-job:2.31` |
| `master.overwritePlugins`         | Overwrite installed plugins on start.| `false`                                   |
| `master.enableRawHtmlMarkupFormatter` | Enable HTML parsing using (see below) | false                                |
| `master.scriptApproval`           | List of groovy functions to approve  | Not set                                   |
| `master.nodeSelector`             | Node labels for pod assignment       | `{}`                                      |
| `master.affinity`                 | Affinity settings                    | `{}`                                      |
| `master.tolerations`              | Toleration labels for pod assignment | `[]`                                      |
| `master.podAnnotations`           | Annotations for master pod           | `{}`                                      |
| `master.customConfigMap`          | Deprecated: Use a custom ConfigMap   | `false`                                   |
| `master.additionalConfig`         | Deprecated: Add additional config files | `{}`                                   |
| `master.jenkinsUriPrefix`         | Root Uri Jenkins will be served on   | Not set                                   |
| `master.customInitContainers`     | Custom init-container specification in raw-yaml format | Not set                 |
| `master.lifecycle`                | Lifecycle specification for master-container | Not set                           |
| `master.priorityClassName`        | The name of a `priorityClass` to apply to the master pod | Not set               |
| `networkPolicy.enabled`           | Enable creation of NetworkPolicy resources. | `false`                            |
| `networkPolicy.apiVersion`        | NetworkPolicy ApiVersion             | `networking.k8s.io/v1`                    |
| `rbac.create`                     | Whether RBAC resources are created   | `true`                                    |
| `serviceAccount.name`             | name of the ServiceAccount to be used by access-controlled resources | autogenerated |
| `serviceAccount.create`           | Configures if a ServiceAccount with this name should be created | `true`         |
| `serviceAccount.annotations`      | Configures annotation for the ServiceAccount | `{}`                              |
| `serviceAccountAgent.name`        | name of the agent ServiceAccount to be used by access-controlled resources | autogenerated |
| `serviceAccountAgent.create`      | Configures if an agent ServiceAccount with this name should be created | `false`         |
| `serviceAccountAgent.annotations` | Configures annotation for the agent ServiceAccount | `{}`                              |


Some third-party systems, e.g. GitHub, use HTML-formatted data in their payload sent to a Jenkins webhooks, e.g. URL of a pull-request being built. To display such data as processed HTML instead of raw text set `master.enableRawHtmlMarkupFormatter` to true. This option requires installation of OWASP Markup Formatter Plugin (antisamy-markup-formatter). The plugin is **not** installed by default, please update `master.installPlugins`.

### Jenkins Agent

| Parameter                  | Description                                     | Default                |
| -------------------------- | ----------------------------------------------- | ---------------------- |
| `agent.alwaysPullImage`    | Always pull agent container image before build  | `false`                |
| `agent.customJenkinsLabels`| Append Jenkins labels to the agent              | `{}`                   |
| `agent.enabled`            | Enable Kubernetes plugin jnlp-agent podTemplate | `true`                 |
| `agent.image`              | Agent image name                                | `jenkins/jnlp-slave`   |
| `agent.imagePullSecret`    | Agent image pull secret                         | Not set                |
| `agent.imageTag`           | Agent image tag                                 | `3.27-1`               |
| `agent.privileged`         | Agent privileged container                      | `false`                |
| `agent.resources`          | Resources allocation (Requests and Limits)      | `{requests: {cpu: 200m, memory: 256Mi}, limits: {cpu: 200m, memory: 256Mi}}`|
| `agent.volumes`            | Additional volumes                              | `nil`                  |
| `agent.envVars`            | Environment variables for the slave Pod         | Not set                |
| `agent.command`            | Executed command when side container starts     | Not set                |
| `agent.args`               | Arguments passed to executed command            | Not set                |
| `agent.sideContainerName`  | Side container name in agent                    | jnlp                   |
| `agent.TTYEnabled`         | Allocate pseudo tty to the side container       | false                  |
| `agent.containerCap`       | Maximum number of agent                         | 10                     |
| `agent.podName`            | slave Pod base name                             | Not set                |
| `agent.idleMinutes`        | Allows the Pod to remain active for reuse       | 0                      |
| `agent.yamlTemplate`       | The raw yaml of a Pod API Object to merge into the agent spec | Not set                |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml stable/jenkins
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Mounting volumes into your Agent pods

Your Jenkins Agents will run as pods, and it's possible to inject volumes where needed:

```yaml
agent:
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

    $ helm install stable/jenkins --set networkPolicy.enabled=true

## Adding customized securityRealm

`master.securityRealm` in values can be used to support custom security realm instead of default `LegacySecurityRealm`. For example, you can add a security realm to authenticate via keycloak.

```yaml
securityRealm: |-
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

`master.additionalConfig` can be used to add additional config files in `config.yaml`. For example, it can be used to add additional config files for keycloak authentication.

```yaml
additionalConfig:
  testConfig.txt: |-
    - name: testName
      clientKey: testKey
      clientURL: testUrl
```

## Adding customized labels

`master.serviceLabels` can be used to add custom labels in `jenkins-master-svc.yaml`. For example,

```yaml
ServiceLabels:
  expose: true
```

## Persistence

The Jenkins image stores persistence under `/var/jenkins_home` path of the container. A dynamically managed Persistent Volume
Claim is used to keep the data across deployments, by default. This is known to work in GCE, AWS, and minikube. Alternatively,
a previously configured Persistent Volume Claim can be used.

It is possible to mount several volumes using `persistence.volumes` and `persistence.mounts` parameters.

### Persistence Values

| Parameter                   | Description                     | Default         |
| --------------------------- | ------------------------------- | --------------- |
| `persistence.enabled`       | Enable the use of a Jenkins PVC | `true`          |
| `persistence.existingClaim` | Provide the name of a PVC       | `nil`           |
| `persistence.annotations`   | Annotations for the PVC         | `{}`            |
| `persistence.accessMode`    | The PVC access mode             | `ReadWriteOnce` |
| `persistence.size`          | The size of the PVC             | `8Gi`           |
| `persistence.subPath`       | SubPath for jenkins-home mount  | `nil`           |
| `persistence.volumes`       | Additional volumes              | `nil`           |
| `persistence.mounts`        | Additional mounts               | `nil`           |

#### Existing PersistentVolumeClaim

1. Create the PersistentVolume
2. Create the PersistentVolumeClaim
3. Install the chart

```bash
$ helm install --name my-release --set persistence.existingClaim=PVC_NAME stable/jenkins
```

## Configuration as Code
Jenkins Configuration as Code is now a standard component in the Jenkins project.  Add a key under configScripts for each configuration area, where each corresponds to a plugin or section of the UI.  The keys (prior to | character) are just labels, and can be any value.  They are only used to give the section a meaningful name.  The only restriction is they must conform to RFC 1123 definition of a DNS label, so may only contain lowercase letters, numbers, and hyphens.  Each key will become the name of a configuration yaml file on the master in /var/jenkins_home/casc_configs (by default) and will be processed by the Configuration as Code Plugin during Jenkins startup.  The lines after each | become the content of the configuration yaml file.  The first line after this is a JCasC root element, eg jenkins, credentials, etc.  Best reference is the Documentation link here: https://<jenkins_url>/configuration-as-code.  The example below creates ldap settings:

```yaml
configScripts:
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
Config as Code changes (to master.JCasC.configScripts) can either force a new pod to be created and only be applied at next startup, or can be auto-reloaded on-the-fly.  If you choose `master.sidecars.autoConfigReload.enabled: true`, a second, auxiliary container will be installed into the Jenkins master pod, known as a "sidecar".  This watches for changes to configScripts, copies the content onto the Jenkins file-system and issues a CLI command via SSH to reload configuration.  The admin user (or account you specify in master.adminUser) will have a random SSH private key (RSA 4096) assigned unless you specify a key in `master.adminSshKey`.  This will be saved to a k8s secret.  You can monitor this sidecar's logs using command `kubectl logs <master_pod> -c jenkins-sc-config -f`
If you want to enable auto-reload then you also need to configure rbac as the container which triggers the reload needs to watch the config maps.

```yaml
master:
  JCasC:
    enabled: true
  sidecars:
    configAutoReload:
      enabled: true
rbac:
  install: true
```

### Auto-reload with non-Jenkins identities
When enabling LDAP or another non-Jenkins identity source, the built-in admin account will no longer exist.  Since the admin account is used by the sidecar to reload config, in order to use auto-reload, you must change the .master.adminUser to a valid username on your LDAP (or other) server.  If you use the matrix-auth plugin, this user must also be granted Overall\Administer rights in Jenkins.  Failure to do this will cause the sidecar container to fail to authenticate via SSH and enter a restart loop.  You can enable LDAP using the example above and add a Config as Code block for matrix security that includes:
```yaml
configScripts:
  matrix-auth: |
    jenkins:
      authorizationStrategy:
        projectMatrix:
          grantedPermissions:
          - "Overall/Administer:<AdminUser_LDAP_username>"
```
You can instead grant this permission via the UI. When this is done, you can set `master.sidecars.configAutoReload.enabled: true` and upon the next Helm upgrade, auto-reload will be successfully enabled.

## RBAC

RBAC is enabled by default if you want to disable it you will need to do the following:

* `helm install stable/jenkins --set rbac.create=false`

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
master:
  runAsUser: 1000
  fsGroup: 1000
```

## Providing jobs xml

Jobs can be created (and overwritten) by providing jenkins config xml within the `values.yaml` file.
The keys of the map will become a directory within the jobs directory.
The values of the map will become the `config.xml` file in the respective directory.

Below is an example of a `values.yaml` file and the directory structure created:

#### values.yaml
```yaml
master:
  jobs:
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

The master pod uses an Init Container to install plugins etc. If you are behind a corporate proxy it may be useful to set `master.initContainerEnv` to add environment variables such as `http_proxy`, so that these can be downloaded.

Additionally, you may want to add env vars for the Jenkins container, and the JVM (`master.javaOpts`).

```yaml
master:
  initContainerEnv:
    - name: http_proxy
      value: "http://192.168.64.1:3128"
    - name: https_proxy
      value: "http://192.168.64.1:3128"
    - name: no_proxy
      value: ""
  containerEnv:
    - name: http_proxy
      value: "http://192.168.64.1:3128"
    - name: https_proxy
      value: "http://192.168.64.1:3128"
  javaOpts: >-
    -Dhttp.proxyHost=192.168.64.1
    -Dhttp.proxyPort=3128
    -Dhttps.proxyHost=192.168.64.1
    -Dhttps.proxyPort=3128
```

## Custom ConfigMap

The following configuration method is deprecated and will be removed in an upcoming version of this chart.
We recommend you use Jenkins Configuration as Code to configure instead.
When creating a new parent chart with this chart as a dependency, the `customConfigMap` parameter can be used to override the default config.xml provided.
It also allows for providing additional xml configuration files that will be copied into `/var/jenkins_home`. In the parent chart's values.yaml,
set the `jenkins.master.customConfigMap` value to true like so

```yaml
jenkins:
  master:
    customConfigMap: true
```

and provide the file `templates/config.tpl` in your parent chart for your use case. You can start by copying the contents of `config.yaml` from this chart into your parent charts `templates/config.tpl` as a basis for customization. Finally, you'll need to wrap the contents of `templates/config.tpl` like so:

```yaml
{{- define "override_config_map" }}
    <CONTENTS_HERE>
{{ end }}
```
