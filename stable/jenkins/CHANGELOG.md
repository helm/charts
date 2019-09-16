# Change Log

This file documents all notable changes to Jenkins Helm Chart. The release
numbering uses [semantic versioning](http://semver.org).


NOTE: The change log until version 1.5.7 is auto generated based on git commits. Those include a reference to the git commit to be able to get more details.

## 1.7.1

Update the default requirements for jenkins-slave to 512Mi which fixes frequently encountered [issue #3723](https://github.com/helm/charts/issues/3723)

## 1.7.0

[Jenkins Configuration as Code Plugin](https://github.com/jenkinsci/configuration-as-code-plugin) default configuration can now be enabled via `master.JCasC.defaultConfig`.

JCasC default configuration includes:
  - Jenkins url
  - Admin email `master.jenkinsAdminEmail`
  - crumbIssuer
  - disableRememberMe: false
  - mode: NORMAL
  - numExecutors: {{ .Values.master.numExecutors }}
  - projectNamingStrategy: "standard"
  - kubernetes plugin
    - containerCapStr via `agent.containerCap`
    - jenkinsTunnel
    - jenkinsUrl
    - maxRequestsPerHostStr: "32"
    - name: "kubernetes"
    - namespace
    - serverUrl: "https://kubernetes.default"
    - template
      - containers
        - alwaysPullImage: `agent.alwaysPullImage`
        - args
        - command
        - envVars
        - image: `agent.image:agent.imageTag`
        - name: `.agent.sideContainerName`
        - privileged: `.agent.privileged`
        - resourceLimitCpu: `agent.resources.limits.cpu`
        - resourceLimitMemory: `agent.resources.limits.memory`
        - resourceRequestCpu: `agent.resources.requests.cpu`
        - resourceRequestMemory: `agent.resources.requests.memory`
        - ttyEnabled: `agent.TTYEnabled`
        - workingDir: "/home/jenkins"
      - idleMinutes: `agent.idleMinutes`
      - instanceCap: 2147483647
      - imagePullSecrets:
        - name: `.agent.imagePullSecretName`
      - label
      - name
      - nodeUsageMode: "NORMAL"
      - podRetention: `agent.podRetention`
      - serviceAccount
      - showRawYaml: true
      - slaveConnectTimeoutStr: "100"
      - yaml: `agent.yamlTemplate`
      - yamlMergeStrategy: "override"
  - security:
    - apiToken:
      - creationOfLegacyTokenEnabled: false
      - tokenGenerationOnCreationEnabled: false
      - usageStatisticsEnabled: true

Example `values.yaml` which enables JCasC, it's default config and configAutoReload:

```
master:
  JCasC:
    enabled: true
    defaultConfig: true
  sidecars:
    configAutoReload:
      enabled: true
```

add master.JCasC.defaultConfig and configure location

- JCasC configuration is stored in template `jenkins.casc.defaults`
  so that it can be used in `config.yaml` and `jcasc-config.yaml`
  depending on if configAutoReload is enabled or not

- Jenkins Location (URL) is configured to provide a startin point
  for the config

## 1.6.1

Print error message when `master.sidecars.configAutoReload.enabled` is `true`, but the admin user can't be found to configure the SSH key.

## 1.6.0

Add support for Google Cloud Storage for backup CronJob (migrating from nuvo/kube-tasks to maorfr/kube-tasks)

## 1.5.9

Fixed a warning when sidecar resources are provided through a parent chart or override values

## 1.5.8

Fixed an issue when master.enableXmlConfig is set to false: Always mount jenkins-secrets volume if secretsFilesSecret is set (#16512)

## 1.5.7

added initial changelog (#16324)
commit: cee2ebf98

## 1.5.6

enable xml config misspelling (#16477)
commit: a125b99f9

## 1.5.5

Jenkins master label (#16469)
commit: 4802d14c9

## 1.5.4

add option enableXmlConfig (#16346)
commit: 387d97a4c

## 1.5.3

extracted "jenkins.url" into template (#16347)
commit: f2fdf5332

## 1.5.2

Fix backups when deployment has custom name (#16279)
commit: 16b89bfff

## 1.5.1

Ability to set custom namespace for ServiceMonitor (#16145)
commit: 18ee6cf01

## 1.5.0

update Jenkins plugins to fix security issue (#16069)
commit: 603cf2d2b

## 1.4.3

Use fixed container name (#16068)
commit: b3e4b4a49

## 1.4.2

Provide default job value (#15963)
commit: c462e2017

## 1.4.1

Add Jenkins backendconfig values (#15471)
commit: 7cc9b54c7

## 1.4.0

Change the value name for docker image tags - standartise to helm preferred value name - tag; this also allows auto-deployments using weaveworks flux (#15565)
commit: 5c3d920e7

## 1.3.6

jenkins deployment port should be target port (#15503)
commit: 83909ebe3

## 1.3.5

Add support for namespace specification (#15202)
commit: e773201a6

## 1.3.4

Adding sub-path option for scraping (#14833)
commit: e04021154

## 1.3.3

Add existingSecret to Jenkins backup AWS credentials (#13392)
commit: d9374f57d

## 1.3.2

Fix JCasC version (#14992)
commit: 26a6d2b99

## 1.3.1

Update affinity for a backup cronjob (#14886)
commit: c21ed8331

## 1.3.0

only install casc support plugin when needed (#14862)
commit: a56fc0540

## 1.2.2

DNS Zone customization (#14775)
commit: da2910073

## 1.2.1

only render comment if configAutoReload is enabled (#14754)
commit: e07ead283

## 1.2.0

update plugins to latest version (#14744)
commit: 84336558e

## 1.1.24

add example for EmptyDir volume (#14499)
commit: cafb60209

## 1.1.23

check if installPlugins is set before using it (#14168)
commit: 1218f0359

## 1.1.22

Support servicemonitor and alerting rules (#14124)
commit: e15a27f48

## 1.1.21

Fix: healthProbe timeouts mapping to initial delay (#13875)
commit: 825b32ece

## 1.1.20

Properly handle overwrite config for additional configs (#13915)
commit: 18ce9b558

## 1.1.18

update maintainer (#13897)
commit: 223002b27

## 1.1.17

add apiVersion (#13795)
commit: cd1e5c35a

## 1.1.16

allow changing of the target port to support TLS termination sidecar (#13576)
commit: a34d3bbcc

## 1.1.15

fix wrong pod selector in jenkins-backup (#13542)
commit: b5df4fd7e

## 1.1.14

allow templating of customInitContainers (#13536)
commit: d1e1421f4

## 1.1.13

fix #13467 (wrong deprecation message) (#13511)
commit: fbe28fa1c

## 1.1.12

Correct customInitContainers Name example. (#13405)
commit: 6c6e40405

## 1.1.11

fix master.runAsUser, master.fsGroup examples (#13389)
commit: 2d7e5bf72

## 1.1.10

Ability to specify raw yaml template (#13319)
commit: 77aaa9a5f

## 1.1.9

correct NOTES.txt - use master.ingress.hostname (#13318)
commit: b08ef6280

## 1.1.8

explain how to upgrade major versions (#13273)
commit: e7617a97e

## 1.1.7

Add support for idleMinutes and serviceAccount (#13263)
commit: 4595ee033

## 1.1.6

Use same JENKINS_URL no matter if slaves use different namespace (#12564)
commit: 94c90339f

## 1.1.5

fix deprecation checks (#13224)
commit: c7d2f8105

## 1.1.4

Fix issue introduced in #13136 (#13232)
commit: 0dbcded2e

## 1.1.3

fix chart errors (#13197)
commit: 692a1e3da

## 1.1.2

correct selector for jenkins pod (#13200)
commit: 4537e7fda

## 1.1.1

Fix rendering of customInitContainers and lifecycle for Jenkins helm chart (#13189)
commit: e8f6b0ada

## 1.1.0

Add support for openshift route in jenkins (#12973)
commit: 48c58a430

## 1.0.0

helm chart best practices (#13136)
commit: b02ae3f48

### Breaking changes:

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

## 0.40.0

Allow to override jenkins location protocol (#12257)
commit: 18a830626

## 0.39.0

Add possibility to add custom init-container and lifecycle for master-container (#13062)
commit: 14d043593

## 0.38.0

Support `priorityClassName` on Master Deployment (#13069)
commit: e896c62bc

## 0.37.3

Add support for service account annotations in jenkins (#12969)
commit: b22774e2f

## 0.37.2

fix: add hostName to ingress in values.yaml (#12946)
commit: 041045e9b

## 0.37.1

Update to match actual defaults in value.yaml (#12904)
commit: 73b6d37eb

## 0.37.0

Support multiple Jenkins instances in same namespace (#12748)
commit: 32ff2f343

## 0.36.5

Fix wrong comment in values.yaml (#12761)
commit: 9db8ced23

## 0.36.4

Re-add value for Ingress API Version (#12753)
commit: ecb7791b5

## 0.36.3

allow templating of volumes (#12734)
commit: adbda2ca6

## 0.36.2

Fix self-introduced whitespace bug (#12528)
commit: eec1678eb

## 0.36.1

Add flag to overwrite jobs definition from values.yaml (#12427)
commit: fd349b2fc

## 0.36.0

Replace OwnSshKey with AdminSshKey (#12140) (#12466)
commit: 80a8c9eb6

## 0.35.2

add note for breaking changes (#12203)
commit: e779c5a54

## 0.35.1

Allow Jenkins to run with READONLYROOTFS psp (#12338)
commit: 7c419e191

## 0.35.0

Jenkins OverwriteConfig setting also overwrites init scripts (#9468)
commit: 501335b76

## 0.34.1

Fix typo on hostname variable (#12156)
commit: 3d337d8dd

## 0.34.0

Allow ingress without host rule (#11960)
commit: ddc966d1e

## 0.33.2

Improve documentation - clarify that rbac is needed for autoreload (#11739)
commit: 9d75a5c34

## 0.33.1

use object for rollingUpdate (#11909)
commit: cb9cf21e8

## 0.33.0

Add hostAliases (#11701)
commit: 0b89e1094

## 0.32.10

Fix slave jnlp port always being reset when container is restarted (#11685)
commit: d7d51797b

## 0.32.9

add ingress Hostname an ApiVersion to docs (#11576)
commit: 4d3e77137

## 0.32.8

Support custom master pod labels in deployment (#9714) (#11511)
commit: 9de96faa0

## 0.32.7

Fix markdown syntax in README (#11496)
commit: a32221a95

## 0.32.6

Added custom labels on jenkins ingress (#11466)
commit: c875d2b9b

## 0.32.5

fix typo in default jenkins agent image fixes #11356 (#11463)
commit: 30adb9a91

## 0.32.4

fix incorrect Deployment when using sidecars (#11413)
commit: 362b4cef8

## 0.32.3

[]: #10131 (#11411)
commit: 49cb72055

## 0.32.2

Option to expose the slave listener port as host port (#11187)
commit: 2f85a9663

## 0.32.1

Updating Jenkins deployment fails appears rollingUpdate needs to be (#11166)
commit: 07fc9dbde

## 0.32.0

Merge Sidecard configs (#11339)
commit: 3696090b9

## 0.31.0

Add option to overwrite plugins (#11231)
commit: 0e9aa00a5

## 0.30.0

Added slave Pod env vars (#8743)
commit: 1499f6608

## 0.29.3

revert indentation to previous working version (#11293)
commit: 61662f17a

## 0.29.2

allow running sidecar containers for Jenkins master (#10950)
commit: 9084ce54a

## 0.29.1

Indent lines related to EnableRawHtmlMarkupFormatter (#11252)
commit: 20b310c08

## 0.29.0

Jenkins Configuration as Code (#9057)
commit: c3e8c0b17

## 0.28.11

Allow to enable OWASP Markup Formatter Plugin (#10851)
commit: 9486e5ddf

## 0.28.10

Fixes #1341 -- update Jenkins chart documentation (#10290)
commit: 411c81cd0

## 0.28.9

Quoted JavaOpts values (#10671)
commit: 926a843a8

## 0.28.8

Support custom labels in deployment (#9714) (#10533)
commit: 3e00b47fa

## 0.28.7

separate test resources (#10597)
commit: 7b7ae2d11

## 0.28.6

allow customizing livenessProbe periodSeconds (#10534)
commit: 3c94d250d

## 0.28.5

Add role kind option (#8498)
commit: e791ad124

## 0.28.4

workaround for busybox's cp (Closes: #10471) (#10497)
commit: 0d51a4187

## 0.28.3

fix parsing java options (#10140)
commit: 9448d0293

## 0.28.2

Fix job definitions in standard values.yaml (#10184)
commit: 6b6355ae7

## 0.28.1

add numExecutors as a variable in values file (#10236)
commit: d5ea2050f

## 0.28.0

various (#10223)
commit: e17d2a65d

## 0.27.0

add backup cronjob (#10095)
commit: 863ead8db

## 0.26.2

add namespace flag for port-forwarding in jenkins notes (#10399)
commit: 846b589a9

## 0.26.1

* fixes #10267 when executed with helm template - otherwise produces an invalid template. (#10403)
commit: 266f9d839

## 0.26.0

Add subPath for jenkins-home mount (#9671)
commit: a9c76ac9b

## 0.25.1

update readme to indicate the correct image that is used by default (#9915)
commit: 6aba9631c

## 0.25.0

Add ability to manually set Jenkins URL (#7405)
commit: a0178fcb4

## 0.24.0

Make AuthorizationStrategy configurable (#9567)
commit: 06545b226

## 0.23.0

Update Jenkins public chart (#9296)
commit: 4e5f5918b

## 0.22.0

allow to override jobs (#9004)
commit: dca9f9ab9

## 0.21.0

Simple implementation of the option to define the ingress path to the jenkins service (#8101)
commit: 013159609

## 0.20.2

Cosmetic change to remove necessity of changing "appVersion" for every new LTS release (#8866)
commit: f52af042a

## 0.20.1

Added ExtraPorts to open in the master pod (#7759)
commit: 78858a2fb

## 0.19.1

Fix component label in NOTES.txt ... (#8300)
commit: c5494dbfe

## 0.19.0

Kubernetes 1.9 support as well as automatic apiVersion detection (#7988)
commit: 6853ad364

## 0.18.1

Respect SlaveListenerPort value in config.xml (#7220)
commit: 0a5ddac35

## 0.18.0

Allow replacement of Jenkins config with configMap. (#7450)
commit: c766da3de

## 0.17.0

Add option to allow host networking (#7530)
commit: dc2eeff32

## 0.16.25

add custom jenkins labels to the build agent (#7167)
commit: 3ecde5dbf

## 0.16.24

Move kubernetes and job plugins to latest versions (#7438)
commit: 019e39456

## 0.16.23

Add different Deployment Strategies based on persistence (#6132)
commit: e0a20b0b9

## 0.16.22

avoid lint errors when adding Values.Ingress.Annotations (#7425)
commit: 99eacc854

## 0.16.21

bump appVersion to reflect new jenkins lts release version 2.121.3 (#7217)
commit: 296df165d

## 0.16.20

Configure kubernetes plugin for including namespace value (#7164)
commit: c0dc6cc48

## 0.16.19

make pod retention policy setting configurable (#6962)
commit: e614c1033

## 0.16.18

Update plugins version (#6988)
commit: bf8180018

## 0.16.17

Add Master.AdminPassword in README (#6987)
commit: 13e754ad7

## 0.16.16

Added jenkins location configuration (#6573)
commit: 79de7026c

## 0.16.15

use generic env var, not oracle specific env var (#6116)
commit: 6084ab4a4

## 0.16.14

Allow to specify resource requests and limits on initContainers (#6723)
commit: 942a33b1a

## 0.16.13

Added support for NodePort service type for jenkens agent svc (#6571)
commit: 89a213c2b

## 0.16.12

Added ability to configure multiple LoadBalancerSourceRanges (#6243)
commit: 01604ddbc

## 0.16.11

Removing ContainerPort configuration as at the moment it does not work when you change this setting (#6411)
commit: e1c0468bd

## 0.16.9

Fix jobs parsing for configmap by adding toYaml to jobs.yaml template (#3747)
commit: b2542a123

## 0.16.8

add jenkinsuriprefix in healthprobes (#5737)
commit: 435d7a7b9

## 0.16.7

Added the ability to switch from ClusterRoleBinding to RoleBinding. (#6190)
commit: dde03ede0

## 0.16.6

Make jenkins master pod security context optional (#6122)
commit: 63653fd59

## 0.16.5

Rework resources requests and limits (#6077) (#6077)
commit: e738f99d0

## 0.16.4

Add jenkins master pod annotations (#6313)
commit: 5e7325721

## 0.16.3

Split Jenkins readiness and liveness probe periods (#5704)
commit: fc6100c38

## 0.16.1

fix typo in jenkins README (#5228)
commit: 3cd3f4b8b

## 0.16.0

Inherit existing plugins from Jenkins image (#5409)
commit: fd93bff82

## 0.15.1

Allow NetworkPolicy.ApiVersion and Master.Ingress.ApiVersion to Differ (#5103)
commit: 78ee4ba15

## 0.15.0

Secure Defaults (#5026)
commit: 0fe90b520

## 0.14.6

Wait for up to 2 minutes before failing liveness check (#5161)
commit: 2cd3fc481

## 0.14.5

correct ImageTag setting (#4371)
commit: 8ea04174d

## 0.14.4

Update jenkins/README.md (#4559)
commit: d4e6352dd

## 0.14.3

Bump appVersion (#4177)
commit: 605d3d441

## 0.14.2

Master.InitContainerEnv: Init Container Env Vars (#3495)
commit: c64abe27d

## 0.14.1

Allow more configuration of Jenkins agent service (#4028)
commit: fc82f39b2

## 0.14.0

Add affinity settings (#3839)
commit: 64e82fa6a

## 0.13.5

bump test timeouts (#3886)
commit: cd05dd99c

## 0.13.4

Add OWNERS to jenkins chart (#3881)
commit: 1c106b9c8

## 0.13.3

Add fullnameOverride support (#3705)
commit: ec8080839

## 0.13.2

Update README.md (#3638)
commit: f6d274c37

## 0.13.1

Lower initial healthcheck delay (#3463)
commit: 9b99db67c

## 0.13.0

Provision credentials.xml, secrets files and jobs (#3316)
commit: d305c5961

## 0.12.1

fix the default value for nodeUsageMode. (#3299)
commit: b68d19516

## 0.12.0

Recreate pods when CustomConfigMap is true and there are changes to the ConfigMap (which is how the vanilla chart works) (#3181)
commit: 86d29f804

## 0.11.1

Optionally adds liveness and readiness probes to jenkins (#3245)
commit: 8b9aa73ee

## 0.11.0

Feature/run jenkins as non root user (#2899)
commit: 8918f4175

## 0.10.3

template the version to keep them synced (#3084)
commit: 35e7fa49a

## 0.10.2

Update Chart.yaml
commit: e3e617a0b

## 0.10.1

Merge branch 'master' into jenkins-test-timeout
commit: 9a230a6b1

## 0.8.1

Double retry count for Jenkins test
commit: 129c8e824

## 0.10.1

Jenkins: Update README | Master.ServiceAnnotations (#2757)
commit: 6571810bc

## 0.10.0

Update Jenkins images and plugins (#2496)
commit: 2e2622682

## 0.9.4

Updating to remove the `.lock` directory as well (#2747)
commit: 6e676808f

## 0.9.3

Use variable for service port when testing (#2666)
commit: d044f99be

## 0.9.2

Review jenkins networkpolicy docs (#2618)
commit: 49911e458

## 0.9.2

Add image pull secrets to jenkins templates (#1389)
commit: 4dfae21fd

## 0.9.1

Added persistent volume claim annotations (#2619)
commit: ac9e5306e

## 0.9.1

Fix failing CI lint (#2758)
commit: 26f709f0e

## 0.9.0

#1785 namespace defined templates with chart name (#2140)
commit: 408ae0b3f

## 0.8.9

added useSecurity and adminUser to params (#1903)
commit: 39d2a03cd

## 0.8.9

Use storageClassName for jenkins. (#1997)
commit: 802f6449b

## 0.8.8

Remove old plugin locks before installing plugins (#1746)
commit: 6cd7b8ff4

## 0.8.8

promote initContainrs to podspec (#1740)
commit: fecc804fc

## 0.8.7

add optional LoadBalancerIP option. (#1568)
commit: d39f11408

## 0.8.6

Fix bad key in values.yaml (#1633)
commit: dc27e5af3

## 0.8.5

Update Jenkins to support node selectors for agents. (#1532)
commit: 4af5810ff

## 0.8.4

Add support for supplying JENKINS_OPTS and/or uri prefix (#1405)
commit: 6a331901a

## 0.8.3

Add serviceAccountName to deployment (#1477)
commit: 0dc349b44

## 0.8.2

Remove path from ingress specification to allow other paths (#1599)
commit: e727f6b32

## 0.8.2

Update git plugin to 3.4.0 for CVE-2017-1000084 (#1505)
commit: 03482f995

## 0.8.1

Use consistent whitespace in template placeholders (#1437)
commit: 912f50c71

## 0.8.1

add configurable service annotations #1234 (#1244)
commit: 286861ca8

## 0.8.0

Jenkins v0.8.0 (#1385)
commit: 0009a2393

## 0.7.4

Use imageTag as version in config map (#1333)
commit: e8bb6ebb4

## 0.7.3

Add NetworkPolicy to Jenkins (#1228)
commit: 572b36c6d

## 0.7.2

- Workflow plugin pin (#1178)
commit: ac3a0c7bc

## 0.7.1

copy over plugins.txt in case of update (#1222)
commit: 75b5b1174

## 0.7.0

add jmx option (#964)
commit: 6ae8d1945

## 0.6.4

update jenkins to latest LTS 2.46.3 (#1182)
commit: ad90b4c27

## 0.6.3

Update chart maints to gh u/n (#1107)
commit: f357b77ed

## 0.6.2

Add Agent.Privileged option (#957)
commit: 2cf4aced2

## 0.6.1

Upgrade jenkins to 2.46.2 (#971)
commit: 41bd742b4

## 0.6.0

Smoke test for Jenkins Chart (#944)
commit: 110441054

## 0.5.1

removed extra space from hardcoded password (#925)
commit: 85a9b9123

## 0.5.0

move config to init-container allowing use of upstream containers (#921)
commit: 1803c3d33

## 0.4.1

add ability to toggle jnlp-agent podTemplate generation (#918)
commit: accd53203

## 0.4.0

Jenkins add script approval (#916)
commit: c1746656e

## 0.3.1

Update Jenkins to Latest LTS fixes #731 (#733)
commit: e9a3aed8b

## 0.3.0

Added option to add Jenkins init scripts (#617)
commit: b889623d0

## 0.2.0

Add existing PVC (#716)
commit: 05271f145

## 0.1.15

use Master.ServicePort in config.xml (#769)
commit: f351f4b16

## 0.1.14

Added option to disable security on master node (#403)
commit: 3a6113d18

## 0.1.13

Added: extra mount points support for jenkins master (#474)
commit: fab0f7eb1

## 0.1.12

fix storageclass config typo (#548)
commit: 6fc0ff242

## 0.1.10

Changed default value of Kubernetes Cloud name to match one in kubernetes plugin (#404)
commit: 68351304a

## 0.1.10

Add support for overriding the Jenkins ConfigMap (#524)
commit: f97ca53b1

## 0.1.9

Added jenkins-master ingress support (#402)
commit: d76a09588

## 0.1.8

Change description (#553)
commit: 91f5c24e1

## 0.1.8

Removed default Persistence.StorageClass: generic (#530)
commit: c87494c10

## 0.1.8

Update to the recommended pvc patterns. (#448)
commit: a7fc595aa

## 0.1.8

Remove helm.sh/created annotations (#505)
commit: f380da2fb

## 0.1.7

add support for explicit NodePort on jenkins chart (#342)
commit: f63c188da

## 0.1.7

Add configurable loadBalancerSourceRanges for jenkins chart (#360)
commit: 44007c50e

## 0.1.7

Update Jenkins version to current LTS (2.19.4) and Kubernetes Plugin to 0.10 (#341)
commit: 6c8678167

## 0.1.6

Add imagePullPolicy to init container (#295)
commit: 103ee1952

## 0.1.5

bump chart version with PVC metadata label additions
commit: 4aa9cf5b1

## 0.1.4

removed `*` from `jenkins/templates/NOTES.txt`
commit: 76212230b

## 0.1.4

apply standard metadata labels to PVC's
commit: 58b730836

## 0.1.4

specify namespace in `kubectl get svc` commands in NOTES.txt
commit: 7d3287e81

## 0.1.4

Update Jenkins version to current LTS (#194)
commit: 2c0404049

## 0.1.1

escape fixed
commit: 2026e1d15

## 0.1.1

.status.loadBalancer.ingress[0].ip is empty in AWS
commit: 1810e37f4

## 0.1.1

.status.loadBalancer.ingress[0].ip is empty in AWS
commit: 3cbd3ced6

## 0.1.1

Remove 'Getting Started:' from various NOTES.txt. (#181)
commit: 2f63fd524

## 0.1.1

docs(*): update READMEs to reference chart repos (#119)
commit: c7d1bff05

## 0.1.0

Move first batch of PVC charts to stable
commit: d745f4879
