# Jenkins Helm Chart

Jenkins master and agent cluster utilizing the Jenkins Kubernetes plugin

* https://plugins.jenkins.io/kubernetes

Inspired by the awesome work of Carlos Sanchez <mailto:carlos@apache.org>

## Chart Details

This chart will do the following:

* 1 x Jenkins Master with port 8080 exposed on an external LoadBalancer
* All using Kubernetes Deployments

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release stable/jenkins
```

## Upgrading an existing Release to a new major version

A major chart version change (like v0.40.0 -> v1.0.0) indicates that there is an incompatible breaking change needing manual actions.

### 2.0.0 Configuration as Code now default + container does not run as root anymore

#### Configuration as Code new default

Configuration is done via [Jenkins Configuration as Code Plugin](https://github.com/jenkinsci/configuration-as-code-plugin) by default.
That means that changes in values which result in a configuration change are always applied.
In contrast the XML configuration was only applied during the first start and never altered.

:exclamation::exclamation::exclamation:
Attention:
This also means if you manually altered configuration then this will most likely be reset to what was configured by default.
It also applies to `securityRealm` and `authorizationStrategy` as they are also configured using configuration as code.
:exclamation::exclamation::exclamation:

#### Image does not run as root anymore

It's not recommended to run containers in Kubernetes as `root`.

:exclamation: Attention: If you had not configured a different user before then you need to ensure that your image supports the user and group id configured and also manually change permissions of all files so that Jenkins is still able to use them.

#### Summary of updated values

As version 2.0.0 only updates default values and nothing else it's still possible to migrate to this version and opt out of some or all new defaults.
All you have to do is ensure the old values are set in your installation.

Here we show which values have changed and the previous default values:

```yaml
master:
  enableXmlConfig: false  # was true
  runAsUser: 1000         # was unset before
  fsGroup: 1000           # was unset before
  JCasC:
    enabled: true         # was false
    defaultConfig: true   # was false
  sidecars:
    configAutoReload:
      enabled: true       # was false
```

#### Migration steps

Migration instructions heavily depend on your current setup.
So think of the list below more as a general guideline of what should be done.

- Ensure that the Jenkins image you are using contains a user with id 1000 and a group with the same id.
  That's the case for `jenkins/jenkins:lts` image, which the chart uses by default
- Make a backup of your existing installation especially the persistent volume
- Ensure that you have the configuration as code plugin installed
- Export your current settings via the plugin:
  `Manage Jenkins` -> `Configuration as Code` -> `Download Configuration`
- prepare your values file for the update e.g. add additional configuration as code setting that you need.
  The export taken from above might be a good starting point for this.
  In addition the [demos](https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos) from the plugin itself are quite useful.
- test drive those setting on a separate installation
- Put Jenkins to Quiet Down mode so that it does not accept new jobs
  `<JENKINS_URL>/quietDown`
- change permissions of all files and folders to the new user and group id

  ```shell script
  kubectl exec -it <jenkins_pod> -c jenkins /bin/bash
  chown -R 1000:1000 /var/jenkins_home
  ```
- Update Jenkins

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
| `clusterZone`                     | Override the cluster name for FQDN resolving    | `cluster.local`                |
| `nameOverride`                    | Override the resource name prefix    | `jenkins`                                 |
| `fullnameOverride`                | Override the full resource names     | `jenkins-{release-name}` (or `jenkins` if release-name is `jenkins`) |
| `namespaceOverride`               | Override the deployment namespace    | Not set (`Release.Namespace`)             |
| `master.componentName`            | Jenkins master name                  | `jenkins-master`                          |
| `master.enableXmlConfig`          | enables configuration done via XML files | `false`                               |
| `master.testEnabled`              | Can be used to disable rendering test resources when using helm template | `true`                         |

#### Jenkins Configuration as Code (JCasC)
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `master.JCasC.enabled`            | Whether Jenkins Configuration as Code is enabled or not | `true`                  |
| `master.JCasC.defaultConfig`      | Enables default Jenkins configuration via configuration as code plugin | `true`  |
| `master.JCasC.configScripts`      | List of Jenkins Config as Code scripts | `{}`                                    |
| `master.JCasC.securityRealm`      | Jenkins Config as Code for Security Realm | `legacy`                             |
| `master.JCasC.authorizationStrategy` | Jenkins Config as Code for Authorization Strategy | `loggedInUsersCanDoAnything` |
| `master.sidecars.configAutoReload` | Jenkins Config as Code auto-reload settings |                                   |
| `master.sidecars.configAutoReload.enabled` | Jenkins Config as Code auto-reload settings (Attention: rbac needs to be enabled otherwise the sidecar can't read the config map) | `true`                                                      |
| `master.sidecars.configAutoReload.image` | Image which triggers the reload | `kiwigrid/k8s-sidecar:0.1.144`           |
| `master.sidecars.configAutoReload.reqRetryConnect` | How many connection-related errors to retry on  | `10`          |
| `master.sidecars.configAutoReload.env` | Environment variables for the Jenkins Config as Code auto-reload container  | Not set |

#### Jenkins Configuration Files & Scripts
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `master.initScripts`              | List of Jenkins init scripts         | `[]`                                      |
| `master.overwriteConfig`          | Replace init scripts and config w/ ConfigMap on boot  | `false`                  |
| `master.credentialsXmlSecret`     | Kubernetes secret that contains a 'credentials.xml' file | Not set               |
| `master.secretsFilesSecret`       | Kubernetes secret that contains 'secrets' files | Not set                        |
| `master.jobs`                     | Jenkins XML job configs              | `{}`                                      |
| `master.overwriteJobs`            | Replace jobs w/ ConfigMap on boot    | `false`                                   |

#### Jenkins Global Security
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `master.useSecurity`              | Use basic security                   | `true`                                    |
| `master.disableRememberMe`        | Disable use of remember me           | `false`                                   |
| `master.securityRealm`            | Jenkins XML for Security Realm       | XML for `LegacySecurityRealm`             |
| `master.authorizationStrategy`    | Jenkins XML for Authorization Strategy | XML for `FullControlOnceLoggedInAuthorizationStrategy` |
| `master.enableRawHtmlMarkupFormatter` | Enable HTML parsing using (see below) | false                                |
| `master.markupFormatter`          | Yaml of the markup formatter to use  | `plainText`                               |
| `master.disabledAgentProtocols`   | Disabled agent protocols             | `JNLP-connect JNLP2-connect`              |
| `master.csrf.defaultCrumbIssuer.enabled` | Enable the default CSRF Crumb issuer | `true`                             |
| `master.csrf.defaultCrumbIssuer.proxyCompatability` | Enable proxy compatibility | `true`                            |
| `master.cli`                      | Enable CLI over remoting             | `false`                                   |

#### Jenkins Global Settings
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `master.numExecutors`             | Set Number of executors              | 0                                         |
| `master.executorMode`             | Set executor mode of the Jenkins node. Possible values are: NORMAL or EXCLUSIVE | NORMAL |
| `master.customJenkinsLabels`      | Append Jenkins labels to the master  | `{}`                                      |
| `master.jenkinsHome`              | Custom Jenkins home path             | `/var/jenkins_home`                       |
| `master.jenkinsRef`               | Custom Jenkins reference path        | `/usr/share/jenkins/ref`                  |
| `master.jenkinsAdminEmail`        | Email address for the administrator of the Jenkins instance | Not set            |
| `master.jenkinsUrlProtocol`       | Set protocol for JenkinsLocationConfiguration.xml | Set to `https` if `Master.ingress.tls`, `http` otherwise |
| `master.jenkinsUriPrefix`         | Root Uri Jenkins will be served on   | Not set                                   |

#### Jenkins In-Process Script Approval
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `master.scriptApproval`           | List of groovy functions to approve  | `[]`                                      |

#### Jenkins Plugins
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `master.installPlugins`           | List of Jenkins plugins to install. If you don't want to install plugins set it to `[]` | `kubernetes:1.18.2 workflow-aggregator:2.6 credentials-binding:1.19 git:3.11.0 workflow-job:2.33` |
| `master.additionalPlugins`        | List of Jenkins plugins to install in addition to those listed in master.installPlugins | `[]` |
| `master.initializeOnce`           | Initialize only on first install. Ensures plugins do not get updated inadvertently. Requires `persistence.enabled` to be set to `true`. | `false` |
| `master.overwritePlugins`         | Overwrite installed plugins on start.| `false`                                   |
| `master.overwritePluginsFromImage` | Keep plugins that are already installed in the master image.| `true`            |

#### Jenkins Kubernetes Plugin
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `master.slaveListenerPort`        | Listening port for agents            | `50000`                                   |
| `master.slaveHostPort`            | Host port to listen for agents            | Not set                              |
| `master.slaveKubernetesNamespace` | Namespace in which the Kubernetes agents should be launched  | Not set           |
| `master.slaveDefaultsProviderTemplate` | The name of the pod template to use for providing default values | Not set  |
| `master.slaveJenkinsUrl`          | Overrides the Kubernetes Jenkins URL    | Not set                                |
| `master.slaveJenkinsTunnel`       | Overrides the Kubernetes Jenkins tunnel | Not set                                |
| `master.slaveConnectTimeout`      | The connection timeout in seconds for connections to Kubernetes API. Minimum value is 5. | 5 |
| `master.slaveReadTimeout`         | The read timeout in seconds for connections to Kubernetes API. Minimum value is 15. | 15 |
| `master.slaveListenerServiceType` | Defines how to expose the slaveListener service | `ClusterIP`                    |
| `master.slaveListenerLoadBalancerIP`  | Static IP for the slaveListener LoadBalancer | Not set                       |

#### Kubernetes Deployment & Service
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `master.image`                    | Master image name                    | `jenkins/jenkins`                         |
| `master.tag`                      | Master image tag                     | `lts`                                     |
| `master.imagePullPolicy`          | Master image pull policy             | `Always`                                  |
| `master.imagePullSecretName`      | Master image pull secret             | Not set                                   |
| `master.resources`                | Resources allocation (Requests and Limits) | `{requests: {cpu: 50m, memory: 256Mi}, limits: {cpu: 2000m, memory: 4096Mi}}`|
| `master.initContainerEnv`         | Environment variables for Init Container                                 | Not set |
| `master.containerEnv`             | Environment variables for Jenkins Container                              | Not set |
| `master.usePodSecurityContext`    | Enable pod security context (must be `true` if `runAsUser` or `fsGroup` are set) | `true` |
| `master.runAsUser`                | uid that jenkins runs with           | `1000`                                    |
| `master.fsGroup`                  | uid that will be used for persistent volume | `1000`                             |
| `master.hostAliases`              | Aliases for IPs in `/etc/hosts`      | `[]`                                      |
| `master.serviceAnnotations`       | Service annotations                  | `{}`                                      |
| `master.serviceType`              | k8s service type                     | `ClusterIP`                               |
| `master.clusterIP`                | k8s service clusterIP                | Not set                                   |
| `master.servicePort`              | k8s service port                     | `8080`                                    |
| `master.targetPort`               | k8s target port                      | `8080`                                    |
| `master.nodePort`                 | k8s node port                        | Not set                                   |
| `master.jmxPort`                  | Open a port, for JMX stats           | Not set                                   |
| `master.extraPorts`               | Open extra ports, for other uses     | `[]`                                      |
| `master.loadBalancerSourceRanges` | Allowed inbound IP addresses         | `0.0.0.0/0`                               |
| `master.loadBalancerIP`           | Optional fixed external IP           | Not set                                   |
| `master.deploymentLabels`         | Custom Deployment labels             | Not set                                   |
| `master.serviceLabels`            | Custom Service labels                | Not set                                   |
| `master.podLabels`                | Custom Pod labels                    | Not set                                   |
| `master.nodeSelector`             | Node labels for pod assignment       | `{}`                                      |
| `master.affinity`                 | Affinity settings                    | `{}`                                      |
| `master.schedulerName`            | Kubernetes scheduler name            | Not set                                   |
| `master.terminationGracePeriodSeconds` | Set TerminationGracePeriodSeconds   | Not set                               |
| `master.tolerations`              | Toleration labels for pod assignment | `[]`                                      |
| `master.podAnnotations`           | Annotations for master pod           | `{}`                                      |
| `master.deploymentAnnotations`           | Annotations for master deployment           | `{}`                                      |
| `master.lifecycle`                | Lifecycle specification for master-container | Not set                           |
| `master.priorityClassName`        | The name of a `priorityClass` to apply to the master pod | Not set               |
| `master.admin.existingSecret`     | The name of an existing secret containing the admin credentials. | `""`|
| `master.admin.userKey`            | The key in the existing admin secret containing the username. | `jenkins-admin-user` |
| `master.admin.passwordKey`        | The key in the existing admin secret containing the password. | `jenkins-admin-password` |
| `master.customInitContainers`     | Custom init-container specification in raw-yaml format | Not set                 |
| `master.sidecars.other`           | Configures additional sidecar container(s) for Jenkins master | `[]`             |

#### Kubernetes Health Probes
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `master.healthProbes`             | Enable k8s liveness and readiness probes    | `true`                             |
| `master.healthProbesLivenessTimeout`  | Set the timeout for the liveness probe  | `5`                              |
| `master.healthProbesReadinessTimeout` | Set the timeout for the readiness probe | `5`                               |
| `master.healthProbeLivenessPeriodSeconds` | Set how often (in seconds) to perform the liveness probe | `10`         |
| `master.healthProbeReadinessPeriodSeconds` | Set how often (in seconds) to perform the readiness probe | `10`         |
| `master.healthProbeLivenessFailureThreshold` | Set the failure threshold for the liveness probe | `5`               |
| `master.healthProbeReadinessFailureThreshold` | Set the failure threshold for the readiness probe | `3`               |
| `master.healthProbeLivenessInitialDelay` | Set the initial delay for the liveness probe | `90`               |
| `master.healthProbeReadinessInitialDelay` | Set the initial delay for the readiness probe | `60`               |

#### Kubernetes Ingress
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `master.ingress.enabled`          | Enables ingress                      | `false`                                   |
| `master.ingress.apiVersion`       | Ingress API version                  | `extensions/v1beta1`                      |
| `master.ingress.hostName`         | Ingress host name                    | Not set                                   |
| `master.ingress.resourceRootUrl`  | Hostname to serve assets from        | Not set                                   |
| `master.ingress.annotations`      | Ingress annotations                  | `{}`                                      |
| `master.ingress.labels`           | Ingress labels                       | `{}`                                      |
| `master.ingress.path`             | Ingress path                         | Not set                                   |
| `master.ingress.paths`            | Override for the default Ingress paths  | `[]`                                   |
| `master.ingress.tls`              | Ingress TLS configuration            | `[]`                                      |

#### GKE BackendConfig
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `master.backendconfig.enabled`     | Enables backendconfig     | `false`              |
| `master.backendconfig.apiVersion`  | backendconfig API version | `extensions/v1beta1` |
| `master.backendconfig.name`        | backendconfig name        | Not set              |
| `master.backendconfig.annotations` | backendconfig annotations | `{}`                 |
| `master.backendconfig.labels`      | backendconfig labels      | `{}`                 |
| `master.backendconfig.spec`        | backendconfig spec        | `{}`                 |

#### OpenShift Route
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `master.route.enabled`            | Enables openshift route              | `false`                                   |
| `master.route.annotations`        | Route annotations                    | `{}`                                      |
| `master.route.labels`             | Route labels                         | `{}`                                      |
| `master.route.path`               | Route path                           | Not set                                   |

#### Prometheus
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `master.prometheus.enabled`       | Enables prometheus service monitor | `false`                                     |
| `master.prometheus.serviceMonitorAdditionalLabels` | Additional labels to add to the service monitor object | `{}`                       |
| `master.prometheus.serviceMonitorNamespace` | Custom namespace for serviceMonitor | Not set (same ns where is Jenkins being deployed) |
| `master.prometheus.scrapeInterval` | How often prometheus should scrape metrics | `60s`                              |
| `master.prometheus.scrapeEndpoint` | The endpoint prometheus should get metrics from | `/prometheus`                 |
| `master.prometheus.alertingrules` | Array of prometheus alerting rules | `[]`                                        |
| `master.prometheus.alertingRulesAdditionalLabels` | Additional labels to add to the prometheus rule object     | `{}`                                   |

#### HTTPS Keystore
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `master.httpsKeyStore.enable`     | Enables https keystore on jenkins master      | `false`      |
| `master.httpsKeyStore.jenkinsHttpsJksSecretName`     | Name of the secret that already has ssl keystore      | ``      |
| `master.httpsKeyStore.httpPort`   | Http Port that Jenkins should listen on along with https, it also serves liveness and readiness probs port. When https keystore is enabled servicePort and targetPort will be used as https port  | `8081`   |
| `master.httpsKeyStore.path`       | Path of https keystore file                  |     `/var/jenkins_keystore`     |
| `master.httpsKeyStore.fileName`  | Jenkins keystore filename which will apear under master.httpsKeyStore.path      | `keystore.jks` |
| `master.httpsKeyStore.password`   | Jenkins keystore password                                           | `password` |
| `master.httpsKeyStore.jenkinsKeyStoreBase64Encoded`  | Base64 ecoded Keystore content. Keystore must be converted to base64 then being pasted here  | a self signed cert |

#### Kubernetes Secret
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `master.adminUser`                | Admin username (and password) created as a secret if useSecurity is true | `admin` |
| `master.adminPassword`            | Admin password (and user) created as a secret if useSecurity is true | Random value |

#### Kubernetes NetworkPolicy
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `networkPolicy.enabled`           | Enable creation of NetworkPolicy resources. | `false`                            |
| `networkPolicy.apiVersion`        | NetworkPolicy ApiVersion             | `networking.k8s.io/v1`                    |
| `networkPolicy.internalAgents.allowed`           | Allow internal agents (from the same cluster) to connect to master. Agent pods would be filtered based on PodLabels. | `false`                            |
| `networkPolicy.internalAgents.podLabels`           | A map of labels (keys/values) that agents pods must have to be able to connect to master. | `{}`                            |
| `networkPolicy.internalAgents.namespaceLabels`           | A map of labels (keys/values) that agents namespaces must have to be able to connect to master. | `{}`                            |
| `networkPolicy.externalAgents.ipCIDR`           | The IP range from which external agents are allowed to connect to master. | ``                            |
| `networkPolicy.externalAgents.except`           | A list of IP sub-ranges to be excluded from the whitelisted IP range. | `[]`                            |

#### Kubernetes RBAC
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `rbac.create`                     | Whether RBAC resources are created   | `true`                                    |
| `rbac.readSecrets`                | Whether the Jenkins service account should be able to read Kubernetes secrets    | `false` |

#### Kubernetes ServiceAccount - Master
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `serviceAccount.name`             | name of the ServiceAccount to be used by access-controlled resources | autogenerated |
| `serviceAccount.create`           | Configures if a ServiceAccount with this name should be created | `true`         |
| `serviceAccount.annotations`      | Configures annotation for the ServiceAccount | `{}`                              |

#### Kubernetes ServiceAccount - Agent
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `serviceAccountAgent.name`        | name of the agent ServiceAccount to be used by access-controlled resources | autogenerated |
| `serviceAccountAgent.create`      | Configures if an agent ServiceAccount with this name should be created | `false`         |
| `serviceAccountAgent.annotations` | Configures annotation for the agent ServiceAccount | `{}`                              |

#### Deprecated
| Parameter                         | Description                          | Default                                   |
| --------------------------------- | ------------------------------------ | ----------------------------------------- |
| `master.customConfigMap`          | Deprecated: Use a custom ConfigMap   | `false`                                   |
| `master.additionalConfig`         | Deprecated: Add additional config files | `{}`                                   |

Some third-party systems, e.g. GitHub, use HTML-formatted data in their payload sent to a Jenkins webhooks, e.g. URL of a pull-request being built. To display such data as processed HTML instead of raw text set `master.enableRawHtmlMarkupFormatter` to true. This option requires installation of OWASP Markup Formatter Plugin (antisamy-markup-formatter). The plugin is **not** installed by default, please update `master.installPlugins`.

### Jenkins Agent(s)

| Parameter                  | Description                                     | Default                |
| -------------------------- | ----------------------------------------------- | ---------------------- |
| `agent.enabled`            | Enable Kubernetes plugin jnlp-agent podTemplate | `true`                 |
| `agent.containerCap`       | Maximum number of agent                         | 10                     |

#### Pod Configuration
| Parameter                  | Description                                     | Default                |
| -------------------------- | ----------------------------------------------- | ---------------------- |
| `agent.podName`            | Agent Pod base name                             | Not set                |
| `agent.customJenkinsLabels`| Append Jenkins labels to the agent              | `{}`                   |
| `agent.envVars`            | Environment variables for the agent Pod         | `[]`                   |
| `agent.idleMinutes`        | Allows the Pod to remain active for reuse       | 0                      |
| `agent.imagePullSecretName` | Agent image pull secret                        | Not set                |
| `agent.nodeSelector`       | Node labels for pod assignment                  | `{}`                   |
| `agent.slaveConnectTimeout`| Timeout in seconds for an agent to be online    | 100                    |
| `agent.volumes`            | Additional volumes                              | `[]`                   |
| `agent.yamlTemplate`       | The raw yaml of a Pod API Object to merge into the agent spec | Not set  |
| `agent.yamlMergeStrategy`   | Defines how the raw yaml field gets merged with yaml definitions from inherited pod templates | `override` |

#### Side Container Configuration
| Parameter                  | Description                                     | Default                |
| -------------------------- | ----------------------------------------------- | ---------------------- |
| `agent.sideContainerName`  | Side container name in agent                    | jnlp                   |
| `agent.image`              | Agent image name                                | `jenkins/inbound-agent`|
| `agent.tag`                | Agent image tag                                 | `4.3-4`               |
| `agent.alwaysPullImage`    | Always pull agent container image before build  | `false`                |
| `agent.privileged`         | Agent privileged container                      | `false`                |
| `agent.resources`          | Resources allocation (Requests and Limits)      | `{requests: {cpu: 512m, memory: 512Mi}, limits: {cpu: 512m, memory: 512Mi}}` |
| `agent.runAsUser`          | Configure container user                        | Not set                |
| `agent.runAsGroup`         | Configure container group                       | Not set                |
| `agent.command`            | Executed command when side container starts     | Not set                |
| `agent.args`               | Arguments passed to executed command            | `${computer.jnlpmac} ${computer.name}` |
| `agent.TTYEnabled`         | Allocate pseudo tty to the side container       | false                  |
| `agent.workingDir`         | Configure working directory for default agent   | `/home/jenkins`        |

#### Other
| Parameter                  | Description                                     | Default                |
| -------------------------- | ----------------------------------------------- | ---------------------- |
| `agent.podTemplates`       | Configures extra pod templates for the default kubernetes cloud | `{}`   |
| `additionalAgents`         | Configure additional agents which inherit values from `agent` | `{}`     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml stable/jenkins
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

The supported volume types are: `ConfigMap`, `EmptyDir`, `HostPath`, `Nfs`, `PVC`, `Secret`. Each type supports a different set of configurable attributes, defined by [the corresponding Java class](https://github.com/jenkinsci/kubernetes-plugin/tree/master/src/main/java/org/csanchez/jenkins/plugins/kubernetes/volumes).

## NetworkPolicy

To make use of the NetworkPolicy resources created by default,
install [a networking plugin that implements the Kubernetes
NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin).

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting
the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

    kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"

Install helm chart with network policy enabled:

    $ helm install stable/jenkins --set networkPolicy.enabled=true

You can use `master.networkPolicy.internalAgents` and `master.networkPolicy.externalAgents` stanzas to fine grained controls over where internal/external agents can connect from. Internal ones are allowed based on pod labels and (optionally) namespaces, and external ones are allowed based on IP ranges.

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
| `persistence.storageClass`  | Storage class for the PVC       | `nil`           |
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
$ helm install my-release --set persistence.existingClaim=PVC_NAME stable/jenkins
```

#### Storage Class

It is possible to define which storage class to use:

```bash
$ helm install my-release --set persistence.storageClass=customStorageClass stable/jenkins
```

If set to a dash (`-`, as in `persistence.storageClass=-`), the dynamic provision is disabled.

If the storage class is set to null or left undefined (`persistence.storageClass=`),
the default provisioner is used (gp2 on AWS, standard on GKE, AWS & OpenStack).

## Configuration as Code
Jenkins Configuration as Code is now a standard component in the Jenkins project.  Add a key under configScripts for each configuration area, where each corresponds to a plugin or section of the UI.  The keys (prior to | character) are just labels, and can be any value.  They are only used to give the section a meaningful name.  The only restriction is they must conform to RFC 1123 definition of a DNS label, so may only contain lowercase letters, numbers, and hyphens.  Each key will become the name of a configuration yaml file on the master in /var/jenkins_home/casc_configs (by default) and will be processed by the Configuration as Code Plugin during Jenkins startup.  The lines after each | become the content of the configuration yaml file.  The first line after this is a JCasC root element, eg jenkins, credentials, etc.  Best reference is the Documentation link here: https://<jenkins_url>/configuration-as-code.  The example below creates ldap settings:

```yaml
configScripts:
  ldap-settings: |
    jenkins:
      securityRealm:
        ldap:
          configurations:
            - server: ldap.acme.com
              rootDN: dc=acme,dc=uk
              managerPasswordSecret: ${LDAP_PASSWORD}
              groupMembershipStrategy:
                fromUserRecord:
                  attributeName: "memberOf"
```

Further JCasC examples can be found [here.](https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos)
### Config as Code with and without auto-reload
Config as Code changes (to master.JCasC.configScripts) can either force a new pod to be created and only be applied at next startup, or can be auto-reloaded on-the-fly.  If you choose `master.sidecars.autoConfigReload.enabled: true`, a second, auxiliary container will be installed into the Jenkins master pod, known as a "sidecar".  This watches for changes to configScripts, copies the content onto the Jenkins file-system and issues a POST to http://<jenkins_url>/reload-configuration-as-code with a pre-shared key.  You can monitor this sidecar's logs using command `kubectl logs <master_pod> -c jenkins-sc-config -f`
If you want to enable auto-reload then you also need to configure rbac as the container which triggers the reload needs to watch the config maps.

```yaml
master:
  JCasC:
    enabled: true
  sidecars:
    configAutoReload:
      enabled: true
rbac:
  create: true
```

## RBAC

RBAC is enabled by default if you want to disable it you will need to do the following:

* `helm install stable/jenkins --set rbac.create=false`

## Backup

Adds a backup CronJob for jenkins, along with required RBAC resources.

### Backup Values

| Parameter                                | Description                                                       | Default                           |
| ---------------------------------------- | ----------------------------------------------------------------- | --------------------------------- |
| `backup.enabled`                         | Enable the use of a backup CronJob                                | `false`                           |
| `backup.schedule`                        | Schedule to run jobs                                              | `0 2 * * *`                       |
| `backup.labels`                          | Backup pod labels                                                 | `{}`                              |
| `backup.annotations`                     | Backup pod annotations                                            | `{}`                              |
| `backup.image.repo`                      | Backup image repository                                           | `maorfr/kube-tasks`               |
| `backup.image.tag`                       | Backup image tag                                                  | `0.2.0`                           |
| `backup.extraArgs`                       | Additional arguments for kube-tasks                               | `[]`                              |
| `backup.existingSecret`                  | Environment variables to add to the cronjob container             | `{}`                              |
| `backup.existingSecret.*`                | Specify the secret name containing the AWS or GCP credentials     | `jenkinsaws`                      |
| `backup.existingSecret.*.awsaccesskey`   | `secretKeyRef.key` used for `AWS_ACCESS_KEY_ID`                   | `jenkins_aws_access_key`          |
| `backup.existingSecret.*.awssecretkey`   | `secretKeyRef.key` used for `AWS_SECRET_ACCESS_KEY`               | `jenkins_aws_secret_key`          |
| `backup.existingSecret.*.gcpcredentials` | Mounts secret as volume and sets `GOOGLE_APPLICATION_CREDENTIALS` | `credentials.json`                |
| `backup.env`                             | Backup environment variables                                      | `[]`                              |
| `backup.resources`                       | Backup CPU/Memory resource requests/limits                        | Memory: `1Gi`, CPU: `1`           |
| `backup.destination`                     | Destination to store backup artifacts                             | `s3://jenkins-data/backup`        |

### Restore from backup

To restore a backup, you can use the `kube-tasks` underlying tool called [skbn](https://github.com/maorfr/skbn), which copies files from cloud storage to Kubernetes.
The best way to do it would be using a `Job` to copy files from the desired backup tag to the Jenkins pod.
See the [skbn in-cluster example](https://github.com/maorfr/skbn/tree/master/examples/in-cluster) for more details.


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

## Adding custom pod templates

It is possible to add custom pod templates for the default configured kubernetes cloud.
Add a key under `agent.podTemplates` for each pod template. Each key (prior to | character) is just a label, and can be any value.
Keys are only used to give the pod template a meaningful name.  The only restriction is they may only contain RFC 1123 \ DNS label
characters: lowercase letters, numbers, and hyphens. Each pod template can contain multiple containers.
There's no need to add the *jnlp* container since the kubernetes plugin will automatically inject it into the pod.
For this pod templates configuration to be loaded the following values must be set:
```
master.JCasC.enabled: true
master.JCasC.defaultConfig: true
```
The example below creates a python pod template in the kubernetes cloud.
```yaml
agent:
  podTemplates:
    python: |
      - name: python
        label: jenkins-python
        serviceAccount: jenkins
        containers:
          - name: python
            image: python:3
            command: "/bin/sh -c"
            args: "cat"
            ttyEnabled: true
            privileged: true
            resourceRequestCpu: "400m"
            resourceRequestMemory: "512Mi"
            resourceLimitCpu: "1"
            resourceLimitMemory: "1024Mi"
```
Best reference is https://<jenkins_url>/configuration-as-code/reference#Cloud-kubernetes.

### Adding pod templates using additionalAgents

`additionalAgents` may be used to configure additional kubernetes pod templates. Each additional agent corresponds to `agent` in terms of the configurable values and inherits all values from `agent` so you only need to specify values which differ. For example,

```yaml
agent:
  podName: default
  customJenkinsLabels: default
  # set resources for additional agents to inherit
  resources:
    limits:
      cpu: "1"
      memory: "2048Mi"

additionalAgents:
  maven:
    podName: maven
    customJenkinsLabels: maven
    # An example of overriding the jnlp container
    # sideContainerName: jnlp
    image: jenkins/jnlp-agent-maven
    tag: latest
  python:
    podName: python
    customJenkinsLabels: python
    sideContainerName: python
    image: python
    tag: "3"
    command: "/bin/sh -c"
    args: "cat"
    TTYEnabled: true
```

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

## Https keystore configuration
This configuration enable jenkins to use keystore inorder to serve https: https://wiki.jenkins.io/pages/viewpage.action?pageId=135468777 <br />
Here is the value file section related to keystore configuration. <br />
Keystore itself should be placed in front of `jenkinsKeyStoreBase64Encoded` key and in base64 encoded format. To achive that after having `keystore.jks` file simply do this: `cat keystore.jks | base64` and paste the output in front of `jenkinsKeyStoreBase64Encoded` . <br />
After enabling `httpsKeyStore.enable` make sure that `httpPort` and `targetPort` are not the same as `targetPort` will serve https. <br />
Do not set `master.httpsKeyStore.httpPort` to `-1` because it will cause readiness and liveliness prob to fail. <br />
If you already have a kubernetes secret that has keystore and its password you can specify its' name in front of `jenkinsHttpsJksSecretName`, You need to remember that your secret should have proper data key names `jenkins-jks-file` and `https-jks-password`. <br />

```yaml
master:
   httpsKeyStore:
       enable: true
       jenkinsHttpsJksSecretName: ''
       httpPort: 8081
       path: "/var/jenkins_keystore"
       fileName: "keystore.jks"
       password: "changeit"
       jenkinsKeyStoreBase64Encoded: ''
```
