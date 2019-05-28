# prometheus-operator

Installs [prometheus-operator](https://github.com/coreos/prometheus-operator) to create/configure/manage Prometheus clusters atop Kubernetes. This chart includes multiple components and is suitable for a variety of use-cases.

The default installation is intended to suit monitoring a kubernetes cluster the chart is deployed onto. It closely matches the kube-prometheus project.
- [prometheus-operator](https://github.com/coreos/prometheus-operator)
- [prometheus](https://prometheus.io/)
- [alertmanager](https://prometheus.io/)
- [node-exporter](https://github.com/helm/charts/tree/master/stable/prometheus-node-exporter)
- [kube-state-metrics](https://github.com/helm/charts/tree/master/stable/kube-state-metrics)
- [grafana](https://github.com/helm/charts/tree/master/stable/grafana)
- service monitors to scrape internal kubernetes components
  - kube-apiserver
  - kube-scheduler
  - kube-controller-manager
  - etcd
  - kube-dns/coredns
With the installation, the chart also includes dashboards and alerts.

The same chart can be used to run multiple prometheus instances in the same cluster if required. To achieve this, the other components need to be disabled - it is necessary to run only one instance of prometheus-operator and a pair of alertmanager pods for an HA configuration.

## TL;DR;

```console
$ helm install stable/prometheus-operator
```

## Introduction

This chart bootstraps a [prometheus-operator](https://github.com/coreos/prometheus-operator) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.  The chart can be installed multiple times to create separate Prometheus instances managed by Prometheus Operator.

## Prerequisites
  - Kubernetes 1.10+ with Beta APIs
  - Helm 2.10+ (For a workaround using an earlier version see [below](#helm-210-workaround))

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/prometheus-operator
```

The command deploys prometheus-operator on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

The default installation includes Prometheus Operator, Alertmanager, Grafana, and configuration for scraping Kubernetes infrastructure.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

CRDs created by this chart are not removed by default and should be manually cleaned up:

```console
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
```

## Work-Arounds for Known Issues

### Helm fails to create CRDs
Due to a bug in helm, it is possible for the 4 CRDs that are created by this chart to fail to get fully deployed before Helm attempts to create resources that require them. This affects all versions of Helm with a [potential fix pending](https://github.com/helm/helm/pull/5112). In order to work around this issue when installing the chart you will need to make sure all 4 CRDs exist in the cluster first and disable their previsioning by the chart:

1. Create CRDs
```console
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/prometheus-operator-crd/alertmanager.crd.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/prometheus-operator-crd/prometheus.crd.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/prometheus-operator-crd/prometheusrule.crd.yaml
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/prometheus-operator-crd/servicemonitor.crd.yaml
```

2. Wait for CRDs to be created, which should only take a few seconds

3. Install the chart, but disable the CRD provisioning by setting `prometheusOperator.createCustomResource=false`
```console
$ helm install --name my-release stable/prometheus-operator --set prometheusOperator.createCustomResource=false
```

### Helm <2.10 workaround
The `crd-install` hook is required to deploy the prometheus operator CRDs before they are used. If you are forced to use an earlier version of Helm you can work around this requirement as follows:
1. Install prometheus-operator by itself, disabling everything but the prometheus-operator component, and also setting `prometheusOperator.serviceMonitor.selfMonitor=false`
2. Install all the other components, and configure `prometheus.additionalServiceMonitors` to scrape the prometheus-operator service.

## Configuration

The following tables list the configurable parameters of the prometheus-operator chart and their default values.

### General
| Parameter | Description | Default |
| ----- | ----------- | ------ |
| `nameOverride` | Provide a name in place of `prometheus-operator` |`""`|
| `fullNameOverride` | Provide a name to substitute for the full names of resources |`""`|
| `commonLabels` | Labels to apply to all resources | `[]` |
| `defaultRules.create` | Create default rules for monitoring the cluster | `true` |
| `defaultRules.rules.alertmanager` | Create default rules for Alert Manager | `true` |
| `defaultRules.rules.etcd` | Create default rules for ETCD | `true` |
| `defaultRules.rules.general` | Create General default rules| `true` |
| `defaultRules.rules.k8s` | Create K8S default rules| `true` |
| `defaultRules.rules.kubeApiserver` | Create Api Server default rules| `true` |
| `defaultRules.rules.kubePrometheusNodeAlerting` | Create Node Alerting default rules| `true` |
| `defaultRules.rules.kubePrometheusNodeRecording` | Create Node Recording default rules| `true` |
| `defaultRules.rules.kubeScheduler` | Create Kubernetes Scheduler default rules| `true` |
| `defaultRules.rules.kubernetesAbsent` | Create Kubernetes Absent (example API Server down) default rules| `true` |
| `defaultRules.rules.kubernetesApps` | Create Kubernetes Apps  default rules| `true` |
| `defaultRules.rules.kubernetesResources` | Create Kubernetes Resources  default rules| `true` |
| `defaultRules.rules.kubernetesStorage` | Create Kubernetes Storage  default rules| `true` |
| `defaultRules.rules.kubernetesSystem` | Create Kubernetes System  default rules| `true` |
| `defaultRules.rules.node` | Create Node  default rules| `true` |
| `defaultRules.rules.PrometheusOperator` | Create Prometheus Operator  default rules| `true` |
| `defaultRules.rules.prometheus` | Create Prometheus  default rules| `true` |
| `defaultRules.labels` | Labels for default rules for monitoring the cluster | `{}` |
| `defaultRules.annotations` | Annotations for default rules for monitoring the cluster | `{}` |
| `additionalPrometheusRules` | List of `prometheusRule` objects to create. See https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#prometheusrulespec. | `[]` |
| `global.rbac.create` | Create RBAC resources | `true` |
| `global.rbac.pspEnabled` | Create pod security policy resources | `true` |
| `global.imagePullSecrets` | Reference to one or more secrets to be used when pulling images | `[]` |

### Prometheus Operator
| Parameter | Description | Default |
| ----- | ----------- | ------ |
| `prometheusOperator.enabled` | Deploy Prometheus Operator. Only one of these should be deployed into the cluster | `true` |
| `prometheusOperator.serviceAccount.create` | Create a serviceaccount for the operator | `true` |
| `prometheusOperator.serviceAccount.name` | Operator serviceAccount name | `""` |
| `prometheusOperator.logFormat` | Operator log output formatting | `"logfmt"` |
| `prometheusOperator.logLevel` | Operator log level. Possible values: "all", "debug",	"info",	"warn",	"error", "none" | `"info"` |
| `prometheusOperator.createCustomResource` | Create CRDs. Required if deploying anything besides the operator itself as part of the release. The operator will create / update these on startup. If your Helm version < 2.10 you will have to either create the CRDs first or deploy the operator first, then the rest of the resources | `true` |
| `prometheusOperator.crdApiGroup` | Specify the API Group for the CustomResourceDefinitions | `monitoring.coreos.com` |
| `prometheusOperator.cleanupCustomResource` | Attempt to delete CRDs when the release is removed. This option may be useful while testing but is not recommended, as deleting the CRD definition will delete resources and prevent the operator from being able to clean up resources that it manages | `false` |
| `prometheusOperator.podLabels` | Labels to add to the operator pod | `{}` |
| `prometheusOperator.podAnnotations` | Annotations to add to the operator pod | `{}` |
| `prometheusOperator.priorityClassName` | Name of Priority Class to assign pods | `nil` |
| `prometheusOperator.kubeletService.enabled` | If true, the operator will create and maintain a service for scraping kubelets | `true` |
| `prometheusOperator.kubeletService.namespace` | Namespace to deploy kubelet service | `kube-system` |
| `prometheusOperator.serviceMonitor.selfMonitor` | Enable monitoring of prometheus operator | `true` |
| `prometheusOperator.serviceMonitor.interval` | Scrape interval. If not set, the Prometheus default scrape interval is used | `nil` |
| `prometheusOperator.serviceMonitor.metricRelabelings` | The `metric_relabel_configs` for scraping the operator instance. | `` |
| `prometheusOperator.serviceMonitor.relabelings` | The `relabel_configs` for scraping the operator instance. | `` |
| `prometheusOperator.service.type` | Prometheus operator service type | `ClusterIP` |
| `prometheusOperator.service.clusterIP` | Prometheus operator service clusterIP IP | `""` |
| `prometheusOperator.service.nodePort` | Port to expose prometheus operator service on each node | `30080` |
| `prometheusOperator.service.annotations` | Annotations to be added to the prometheus operator service | `{}` |
| `prometheusOperator.service.labels` |  Prometheus Operator Service Labels | `{}` |
| `prometheusOperator.service.externalIPs` | List of IP addresses at which the Prometheus Operator server service is available  | `[]` |
| `prometheusOperator.service.loadBalancerIP` |  Prometheus Operator Loadbalancer IP | `""` |
| `prometheusOperator.service.loadBalancerSourceRanges` | Prometheus Operator Load Balancer Source Ranges | `[]` |
| `prometheusOperator.resources` | Resource limits for prometheus operator | `{}` |
| `prometheusOperator.securityContext` | SecurityContext for prometheus operator | `{"runAsNonRoot": true, "runAsUser": 65534}` |
| `prometheusOperator.nodeSelector` | Prometheus operator node selector https://kubernetes.io/docs/user-guide/node-selection/ | `{}` |
| `prometheusOperator.tolerations` | Tolerations for use with node taints https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ | `[]` |
| `prometheusOperator.affinity` | Assign custom affinity rules to the prometheus operator https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ | `{}` |
| `prometheusOperator.image.repository` | Repository for prometheus operator image | `quay.io/coreos/prometheus-operator` |
| `prometheusOperator.image.tag` | Tag for prometheus operator image | `v0.29.0` |
| `prometheusOperator.image.pullPolicy` | Pull policy for prometheus operator image | `IfNotPresent` |
| `prometheusOperator.configmapReloadImage.repository` | Repository for configmapReload image | `quay.io/coreos/configmap-reload` |
| `prometheusOperator.configmapReloadImage.tag` | Tag for configmapReload image | `v0.0.1` |
| `prometheusOperator.prometheusConfigReloaderImage.repository` | Repository for config-reloader image | `quay.io/coreos/prometheus-config-reloader` |
| `prometheusOperator.prometheusConfigReloaderImage.tag` | Tag for config-reloader image | `v0.29.0` |
| `prometheusOperator.configReloaderCpu` | Set the prometheus config reloader side-car CPU limit. If unset, uses the prometheus-operator project default | `nil` |
| `prometheusOperator.configReloaderMemory` | Set the prometheus config reloader side-car memory limit. If unset, uses the prometheus-operator project default | `nil` |
| `prometheusOperator.hyperkubeImage.repository` | Repository for hyperkube image used to perform maintenance tasks | `k8s.gcr.io/hyperkube` |
| `prometheusOperator.hyperkubeImage.tag` | Tag for hyperkube image used to perform maintenance tasks | `v1.12.1` |
| `prometheusOperator.hyperkubeImage.repository` | Image pull policy for hyperkube image used to perform maintenance tasks | `IfNotPresent` |

### Prometheus
| Parameter | Description | Default |
| ----- | ----------- | ------ |
| `prometheus.enabled` | Deploy prometheus | `true` |
| `prometheus.serviceMonitor.selfMonitor` | Create a `serviceMonitor` to automatically monitor the prometheus instance | `true` |
| `prometheus.serviceMonitor.interval` | Scrape interval. If not set, the Prometheus default scrape interval is used | `nil` |
| `prometheus.serviceMonitor.metricRelabelings` | The `metric_relabel_configs` for scraping the prometheus instance. | `` |
| `prometheus.serviceMonitor.relabelings` | The `relabel_configs` for scraping the prometheus instance. | `` |
| `prometheus.serviceAccount.create` | Create a default serviceaccount for prometheus to use | `true` |
| `prometheus.serviceAccount.name` | Name for prometheus serviceaccount | `""` |
| `prometheus.rbac.roleNamespaces` | Create role bindings in the specified namespaces, to allow Prometheus monitoring a role binding in the release namespace will always be created. | `["kube-system"]` |
| `prometheus.podDisruptionBudget.enabled` | If true, create a pod disruption budget for prometheus pods. The created resource cannot be modified once created - it must be deleted to perform a change | `true` |
| `prometheus.podDisruptionBudget.minAvailable` | Minimum number / percentage of pods that should remain scheduled | `1` |
| `prometheus.podDisruptionBudget.maxUnavailable` | Maximum number / percentage of pods that may be made unavailable | `""` |
| `prometheus.ingress.enabled` | If true, Prometheus Ingress will be created | `false` |
| `prometheus.ingress.annotations` | Prometheus Ingress annotations | `{}` |
| `prometheus.ingress.labels` | Prometheus Ingress additional labels | `{}` |
| `prometheus.ingress.hosts` | Prometheus Ingress hostnames | `[]` |
| `prometheus.ingress.paths` | Prometheus Ingress paths | `[]` |
| `prometheus.ingress.tls` | Prometheus Ingress TLS configuration (YAML) | `[]` |
| `prometheus.service.type` |  Prometheus Service type | `ClusterIP` |
| `prometheus.service.clusterIP` | Prometheus service clusterIP IP | `""` |
| `prometheus.service.targetPort` |  Prometheus Service internal port | `9090` |
| `prometheus.service.nodePort` |  Prometheus Service port for NodePort service type | `30090` |
| `prometheus.service.additionalPorts` |  Additional Prometheus Service ports to add for NodePort service type | `[]` |
| `prometheus.service.annotations` |  Prometheus Service Annotations | `{}` |
| `prometheus.service.labels` |  Prometheus Service Labels | `{}` |
| `prometheus.service.externalIPs` | List of IP addresses at which the Prometheus server service is available  | `[]` |
| `prometheus.service.loadBalancerIP` |  Prometheus Loadbalancer IP | `""` |
| `prometheus.service.loadBalancerSourceRanges` | Prometheus Load Balancer Source Ranges | `[]` |
| `prometheus.service.sessionAffinity` | Prometheus Service Session Affinity | `""` |
| `prometheus.additionalServiceMonitors` | List of `serviceMonitor` objects to create. See https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#servicemonitorspec | `[]` |
| `prometheus.prometheusSpec.podMetadata` | Standard object’s metadata. More info: https://github.com/kubernetes/community/blob/master/contributors/devel/api-conventions.md#metadata Metadata Labels and Annotations gets propagated to the prometheus pods. | `{}` |
| `prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues` | If true, a nil or {} value for prometheus.prometheusSpec.serviceMonitorSelector will cause the prometheus resource to be created with selectors based on values in the helm deployment, which will also match the servicemonitors created | `true` |
| `prometheus.prometheusSpec.serviceMonitorSelector` | ServiceMonitors to be selected for target discovery. If {}, select all ServiceMonitors | `{}` |
| `prometheus.prometheusSpec.serviceMonitorNamespaceSelector` | Namespaces to be selected for ServiceMonitor discovery. See [metav1.LabelSelector](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.11/#labelselector-v1-meta) for usage | `{}` |
| `prometheus.prometheusSpec.image.repository` | Base image to use for a Prometheus deployment. | `quay.io/prometheus/prometheus` |
| `prometheus.prometheusSpec.image.tag` | Tag of Prometheus container image to be deployed. | `v2.9.1` |
| `prometheus.prometheusSpec.paused` | When a Prometheus deployment is paused, no actions except for deletion will be performed on the underlying objects. | `false` |
| `prometheus.prometheusSpec.replicas` | Number of instances to deploy for a Prometheus deployment. | `1` |
| `prometheus.prometheusSpec.retention` | Time duration Prometheus shall retain data for. Must match the regular expression `[0-9]+(ms\|s\|m\|h\|d\|w\|y)` (milliseconds seconds minutes hours days weeks years). | `10d` |
| `prometheus.prometheusSpec.logLevel` | Log level for Prometheus to be configured with. | `info` |
| `prometheus.prometheusSpec.logFormat` | Log format for Prometheus to be configured with. | `logfmt` |
| `prometheus.prometheusSpec.scrapeInterval` | Interval between consecutive scrapes. | `""` |
| `prometheus.prometheusSpec.evaluationInterval` | Interval between consecutive evaluations. | `""` |
| `prometheus.prometheusSpec.externalLabels` | The labels to add to any time series or alerts when communicating with external systems (federation, remote storage, Alertmanager). | `[]` |
| `prometheus.prometheusSpec.externalUrl` | The external URL the Prometheus instances will be available under. This is necessary to generate correct URLs. This is necessary if Prometheus is not served from root of a DNS name. | `""` |
| `prometheus.prometheusSpec.routePrefix` | The route prefix Prometheus registers HTTP handlers for. This is useful, if using ExternalURL and a proxy is rewriting HTTP routes of a request, and the actual ExternalURL is still true, but the server serves requests under a different route prefix. For example for use with `kubectl proxy`. | `/` |
| `prometheus.prometheusSpec.storageSpec` | Storage spec to specify how storage shall be used. | `{}` |
| `prometheus.prometheusSpec.ruleSelectorNilUsesHelmValues` | If true, a nil or {} value for prometheus.prometheusSpec.ruleSelector will cause the prometheus resource to be created with selectors based on values in the helm deployment, which will also match the PrometheusRule resources created. | `true` |
| `prometheus.prometheusSpec.ruleSelector` | A selector to select which PrometheusRules to mount for loading alerting rules from. Until (excluding) Prometheus Operator v0.24.0 Prometheus Operator will migrate any legacy rule ConfigMaps to PrometheusRule custom resources selected by RuleSelector. Make sure it does not match any config maps that you do not want to be migrated. If {}, select all PrometheusRules | `{}` |
| `prometheus.prometheusSpec.ruleNamespaceSelector` | Namespaces to be selected for PrometheusRules discovery. If nil, select own namespace. See [namespaceSelector](https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#namespaceselector) for usage | `{}` |
| `prometheus.prometheusSpec.alertingEndpoints` | Alertmanagers to which alerts will be sent https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#alertmanagerendpoints Default configuration will connect to the alertmanager deployed as part of this release | `[]` |
| `prometheus.prometheusSpec.resources` | Define resources requests and limits for single Pods. | `{}` |
| `prometheus.prometheusSpec.nodeSelector` | Define which Nodes the Pods are scheduled on. | `{}` |
| `prometheus.prometheusSpec.secrets` | Secrets is a list of Secrets in the same namespace as the Prometheus object, which shall be mounted into the Prometheus Pods. The Secrets are mounted into /etc/prometheus/secrets/<secret-name>. Secrets changes after initial creation of a Prometheus object are not reflected in the running Pods. To change the secrets mounted into the Prometheus Pods, the object must be deleted and recreated with the new list of secrets. | `[]` |
| `prometheus.prometheusSpec.configMaps` | ConfigMaps is a list of ConfigMaps in the same namespace as the Prometheus object, which shall be mounted into the Prometheus Pods. The ConfigMaps are mounted into /etc/prometheus/configmaps/ | `[]` |
| `prometheus.prometheusSpec.query` | QuerySpec defines the query command line flags when starting Prometheus. Not all parameters are supported by the operator - [see coreos documentation](https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#queryspec) | `{}` |
| `prometheus.prometheusSpec.podAntiAffinity` | Pod anti-affinity can prevent the scheduler from placing Prometheus replicas on the same node. The default value "soft" means that the scheduler should *prefer* to not schedule two replica pods onto the same node but no guarantee is provided. The value "hard" means that the scheduler is *required* to not schedule two replica pods onto the same node. The value "" will disable pod anti-affinity so that no anti-affinity rules will be configured. | `""` |
| `prometheus.prometheusSpec.podAntiAffinityTopologyKey` | If anti-affinity is enabled sets the topologyKey to use for anti-affinity. This can be changed to, for example `failure-domain.beta.kubernetes.io/zone`| `kubernetes.io/hostname` |
| `prometheus.prometheusSpec.affinity` | Assign custom affinity rules to the prometheus instance https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ | `{}` |
| `prometheus.prometheusSpec.tolerations` | If specified, the pod's tolerations. | `[]` |
| `prometheus.prometheusSpec.remoteWrite` | If specified, the remote_write spec. This is an experimental feature, it may change in any upcoming release in a breaking way. | `[]` |
| `prometheus.prometheusSpec.remoteRead` | If specified, the remote_read spec. This is an experimental feature, it may change in any upcoming release in a breaking way. | `[]` |
| `prometheus.prometheusSpec.securityContext` | SecurityContext holds pod-level security attributes and common container settings. This defaults to non root user with uid 1000 and gid 2000 in order to support migration from operator version <0.26. | `{"runAsNonRoot": true, "runAsUser": 1000, "fsGroup": 2000}` |
| `prometheus.prometheusSpec.listenLocal` | ListenLocal makes the Prometheus server listen on loopback, so that it does not bind against the Pod IP. | `false` |
| `prometheus.prometheusSpec.enableAdminAPI` | EnableAdminAPI enables Prometheus the administrative HTTP API which includes functionality such as deleting time series. | `false` |
| `prometheus.prometheusSpec.containers` | Containers allows injecting additional containers. This is meant to allow adding an authentication proxy to a Prometheus pod. |`[]`|
| `prometheus.prometheusSpec.additionalScrapeConfigs` | AdditionalScrapeConfigs allows specifying additional Prometheus scrape configurations. Scrape configurations are appended to the configurations generated by the Prometheus Operator. Job configurations must have the form as specified in the official Prometheus documentation: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#<scrape_config>. As scrape configs are appended, the user is responsible to make sure it is valid. Note that using this feature may expose the possibility to break upgrades of Prometheus. It is advised to review Prometheus release notes to ensure that no incompatible scrape configs are going to break Prometheus after the upgrade. | `{}` |
| `prometheus.prometheusSpec.additionalScrapeConfigsExternal` | Enable additional scrape configs that are managed externally to this chart. Note that the prometheus will fail to provision if the correct secret does not exist. | `false` |
| `prometheus.prometheusSpec.additionalAlertManagerConfigs` | AdditionalAlertManagerConfigs allows for manual configuration of alertmanager jobs in the form as specified in the official Prometheus documentation: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#<alertmanager_config>. AlertManager configurations specified are appended to the configurations generated by the Prometheus Operator. As AlertManager configs are appended, the user is responsible to make sure it is valid. Note that using this feature may expose the possibility to break upgrades of Prometheus. It is advised to review Prometheus release notes to ensure that no incompatible AlertManager configs are going to break Prometheus after the upgrade. | `{}` |
| `prometheus.prometheusSpec.additionalAlertRelabelConfigs` | AdditionalAlertRelabelConfigs allows specifying additional Prometheus alert relabel configurations. Alert relabel configurations specified are appended to the configurations generated by the Prometheus Operator. Alert relabel configurations specified must have the form as specified in the official Prometheus documentation: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#alert_relabel_configs. As alert relabel configs are appended, the user is responsible to make sure it is valid. Note that using this feature may expose the possibility to break upgrades of Prometheus. It is advised to review Prometheus release notes to ensure that no incompatible alert relabel configs are going to break Prometheus after the upgrade. | `[]` |
| `prometheus.prometheusSpec.thanos` | Thanos configuration allows configuring various aspects of a Prometheus server in a Thanos environment. This section is experimental, it may change significantly without deprecation notice in any release.This is experimental and may change significantly without backward compatibility in any release. See https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#thanosspec | `{}` |
| `prometheus.prometheusSpec.priorityClassName` | Priority class assigned to the Pods | `""` |

### Alertmanager
| Parameter | Description | Default |
| ----- | ----------- | ------ |
| `alertmanager.enabled` | Deploy alertmanager | `true` |
| `alertmanager.serviceMonitor.selfMonitor` | Create a `serviceMonitor` to automatically monitor the alartmanager instance | `true` |
| `alertmanager.serviceMonitor.interval` | Scrape interval. If not set, the Prometheus default scrape interval is used | `nil` |
| `alertmanager.serviceMonitor.metricRelabelings` | The `metric_relabel_configs` for scraping the alertmanager instance. | `` |
| `alertmanager.serviceMonitor.relabelings` | The `relabel_configs` for scraping the alertmanager instance. | `` |
| `alertmanager.serviceAccount.create` | Create a `serviceAccount` for alertmanager | `true` |
| `alertmanager.serviceAccount.name` | Name for Alertmanager service account | `""` |
| `alertmanager.podDisruptionBudget.enabled` | If true, create a pod disruption budget for Alertmanager pods. The created resource cannot be modified once created - it must be deleted to perform a change | `true` |
| `alertmanager.podDisruptionBudget.minAvailable` | Minimum number / percentage of pods that should remain scheduled | `1` |
| `alertmanager.podDisruptionBudget.maxUnavailable` | Maximum number / percentage of pods that may be made unavailable | `""` |
| `alertmanager.ingress.enabled` | If true, Alertmanager Ingress will be created | `false` |
| `alertmanager.ingress.annotations` | Alertmanager Ingress annotations | `{}` |
| `alertmanager.ingress.labels` | Alertmanager Ingress additional labels | `{}` |
| `alertmanager.ingress.hosts` | Alertmanager Ingress hostnames | `[]` |
| `alertmanager.ingress.paths` | Alertmanager Ingress paths | `[]` |
| `alertmanager.ingress.tls` | Alertmanager Ingress TLS configuration (YAML) | `[]` |
| `alertmanager.service.type` | Alertmanager Service type | `ClusterIP` |
| `alertmanager.service.clusterIP` | Alertmanager service clusterIP IP | `""` |
| `alertmanager.service.nodePort` | Alertmanager Service port for NodePort service type | `30903` |
| `alertmanager.service.annotations` | Alertmanager Service annotations | `{}` |
| `alertmanager.service.labels` |  Alertmanager Service Labels | `{}` |
| `alertmanager.service.externalIPs` | List of IP addresses at which the Alertmanager server service is available  | `[]` |
| `alertmanager.service.loadBalancerIP` |  Alertmanager Loadbalancer IP | `""` |
| `alertmanager.service.loadBalancerSourceRanges` | Alertmanager Load Balancer Source Ranges | `[]` |
| `alertmanager.config` | Provide YAML to configure Alertmanager. See https://prometheus.io/docs/alerting/configuration/#configuration-file. The default provided works to suppress the Watchdog alert from `defaultRules.create` | `{"global":{"resolve_timeout":"5m"},"route":{"group_by":["job"],"group_wait":"30s","group_interval":"5m","repeat_interval":"12h","receiver":"null","routes":[{"match":{"alertname":"Watchdog"},"receiver":"null"}]},"receivers":[{"name":"null"}]}` |
| `alertmanager.alertmanagerSpec.podMetadata` | Standard object’s metadata. More info: https://github.com/kubernetes/community/blob/master/contributors/devel/api-conventions.md#metadata Metadata Labels and Annotations gets propagated to the prometheus pods. | `{}` |
| `alertmanager.alertmanagerSpec.image.tag` | Tag of Alertmanager container image to be deployed. | `v0.17.0` |
| `alertmanager.alertmanagerSpec.image.repository` | Base image that is used to deploy pods, without tag. | `quay.io/prometheus/alertmanager` |
| `alertmanager.alertmanagerSpec.useExistingSecret` | Use an existing secret for configuration (all defined config from values.yaml will be ignored) | `false` |
| `alertmanager.alertmanagerSpec.secrets` | Secrets is a list of Secrets in the same namespace as the Alertmanager object, which shall be mounted into the Alertmanager Pods. The Secrets are mounted into /etc/alertmanager/secrets/<secret-name>. | `[]` |
| `alertmanager.alertmanagerSpec.configMaps` | ConfigMaps is a list of ConfigMaps in the same namespace as the Alertmanager object, which shall be mounted into the Alertmanager Pods. The ConfigMaps are mounted into /etc/alertmanager/configmaps/ | `[]` |
| `alertmanager.alertmanagerSpec.logLevel` | Log level for Alertmanager to be configured with. | `info` |
| `alertmanager.alertmanagerSpec.replicas` | Size is the expected size of the alertmanager cluster. The controller will eventually make the size of the running cluster equal to the expected size. | `1` |
| `alertmanager.alertmanagerSpec.retention` | Time duration Alertmanager shall retain data for. Value must match the regular expression `[0-9]+(ms\|s\|m\|h)` (milliseconds seconds minutes hours). | `120h` |
| `alertmanager.alertmanagerSpec.storage` | Storage is the definition of how storage will be used by the Alertmanager instances. | `{}` |
| `alertmanager.alertmanagerSpec.externalUrl` | The external URL the Alertmanager instances will be available under. This is necessary to generate correct URLs. This is necessary if Alertmanager is not served from root of a DNS name. | `""` |
| `alertmanager.alertmanagerSpec.routePrefix` | The route prefix Alertmanager registers HTTP handlers for. This is useful, if using ExternalURL and a proxy is rewriting HTTP routes of a request, and the actual ExternalURL is still true, but the server serves requests under a different route prefix. For example for use with `kubectl proxy`. | `/` |
| `alertmanager.alertmanagerSpec.paused` | If set to true all actions on the underlying managed objects are not going to be performed, except for delete actions. | `false` |
| `alertmanager.alertmanagerSpec.nodeSelector` | Define which Nodes the Pods are scheduled on. | `{}` |
| `alertmanager.alertmanagerSpec.resources` | Define resources requests and limits for single Pods. | `{}` |
| `alertmanager.alertmanagerSpec.podAntiAffinity` | Pod anti-affinity can prevent the scheduler from placing Prometheus replicas on the same node. The default value "soft" means that the scheduler should *prefer* to not schedule two replica pods onto the same node but no guarantee is provided. The value "hard" means that the scheduler is *required* to not schedule two replica pods onto the same node. The value "" will disable pod anti-affinity so that no anti-affinity rules will be configured. | `""` |
| `alertmanager.alertmanagerSpec.podAntiAffinityTopologyKey` | If anti-affinity is enabled sets the topologyKey to use for anti-affinity. This can be changed to, for example `failure-domain.beta.kubernetes.io/zone`| `kubernetes.io/hostname` |
| `alertmanager.alertmanagerSpec.affinity` | Assign custom affinity rules to the alertmanager instance https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ | `{}` |
| `alertmanager.alertmanagerSpec.tolerations` | If specified, the pod's tolerations. | `[]` |
| `alertmanager.alertmanagerSpec.securityContext` | SecurityContext holds pod-level security attributes and common container settings. This defaults to non root user with uid 1000 and gid 2000 in order to support migration from operator version < 0.26 | `{"runAsNonRoot": true, "runAsUser": 1000, "fsGroup": 2000}` |
| `alertmanager.alertmanagerSpec.listenLocal` | ListenLocal makes the Alertmanager server listen on loopback, so that it does not bind against the Pod IP. Note this is only for the Alertmanager UI, not the gossip communication. | `false` |
| `alertmanager.alertmanagerSpec.containers` | Containers allows injecting additional containers. This is meant to allow adding an authentication proxy to an Alertmanager pod. | `[]` |
| `alertmanager.alertmanagerSpec.priorityClassName` | Priority class assigned to the Pods | `""` |
| `alertmanager.alertmanagerSpec.additionalPeers` | AdditionalPeers allows injecting a set of additional Alertmanagers to peer with to form a highly available cluster. | `[]` |

### Grafana
| Parameter | Description | Default |
| ----- | ----------- | ------ |
| `grafana.enabled` | If true, deploy the grafana sub-chart | `true` |
| `grafana.serviceMonitor.selfMonitor` | Create a `serviceMonitor` to automatically monitor the grafana instance | `true` |
| `grafana.serviceMonitor.metricRelabelings` | The `metric_relabel_configs` for scraping the grafana instance. | `` |
| `grafana.serviceMonitor.relabelings` | The `relabel_configs` for scraping the grafana instance. | `` |
| `grafana.additionalDataSources` | Configure additional grafana datasources | `[]` |
| `grafana.adminPassword` | Admin password to log into the grafana UI | "prom-operator" |
| `grafana.defaultDashboardsEnabled` | Deploy default dashboards. These are loaded using the sidecar | `true` |
| `grafana.ingress.enabled` | Enables Ingress for Grafana | `false` |
| `grafana.ingress.annotations` | Ingress annotations for Grafana | `{}` |
| `grafana.ingress.labels` | Custom labels for Grafana Ingress | `{}` |
| `grafana.ingress.hosts` | Ingress accepted hostnames for Grafana| `[]` |
| `grafana.ingress.tls` | Ingress TLS configuration for Grafana | `[]` |
| `grafana.sidecar.dashboards.enabled` | Enable the Grafana sidecar to automatically load dashboards with a label `{{ grafana.sidecar.dashboards.label }}=1` | `true` |
| `grafana.sidecar.dashboards.label` | If the sidecar is enabled, configmaps with this label will be loaded into Grafana as dashboards | `grafana_dashboard` |
| `grafana.sidecar.datasources.enabled` | Enable the Grafana sidecar to automatically load dashboards with a label `{{ grafana.sidecar.datasources.label }}=1` | `true` |
| `grafana.sidecar.datasources.defaultDatasourceEnabled` | Enable Grafana `Prometheus` default datasource` | `true` |
| `grafana.sidecar.datasources.label` | If the sidecar is enabled, configmaps with this label will be loaded into Grafana as datasources configurations | `grafana_datasource` |
| `grafana.rbac.pspUseAppArmor` | Enforce AppArmor in created PodSecurityPolicy (requires rbac.pspEnabled) | `true` |
| `grafana.extraConfigmapMounts` | Additional grafana server configMap volume mounts | `[]` |

### Exporters
| Parameter | Description | Default |
| ----- | ----------- | ------ |
| `kubeApiServer.enabled` | Deploy `serviceMonitor` to scrape the Kubernetes API server | `true` |
| `kubeApiServer.relabelings` | Relablings for the API Server ServiceMonitor | `[]` |
| `kubeApiServer.tlsConfig.serverName` | Name of the server to use when validating TLS certificate | `kubernetes` |
| `kubeApiServer.tlsConfig.insecureSkipVerify` | Skip TLS certificate validation when scraping | `false` |
| `kubeApiServer.serviceMonitor.jobLabel` | The name of the label on the target service to use as the job name in prometheus | `component` |
| `kubeApiServer.serviceMonitor.selector` | The service selector | `{"matchLabels":{"component":"apiserver","provider":"kubernetes"}}` |
| `kubeApiServer.serviceMonitor.interval` | Scrape interval. If not set, the Prometheus default scrape interval is used | `nil` |
| `kubeApiServer.serviceMonitor.relabelings` | The `relabel_configs` for scraping the Kubernetes API server. | `` |
| `kubeApiServer.serviceMonitor.metricRelabelings` | The `metric_relabel_configs` for scraping the Kubernetes API server. | `` |
| `kubelet.enabled` | Deploy servicemonitor to scrape the kubelet service. See also `prometheusOperator.kubeletService` | `true` |
| `kubelet.namespace` | Namespace where the kubelet is deployed. See also `prometheusOperator.kubeletService.namespace` | `kube-system` |
| `kubelet.serviceMonitor.https` | Enable scraping of the kubelet over HTTPS. For more information, see https://github.com/coreos/prometheus-operator/issues/926 | `true` |
| `kubelet.serviceMonitor.cAdvisorMetricRelabelings` | The `metric_relabel_configs` for scraping cAdvisor. | `` |
| `kubelet.serviceMonitor.cAdvisorRelabelings` | The `relabel_configs` for scraping cAdvisor. | `` |
| `kubelet.serviceMonitor.interval` | Scrape interval. If not set, the Prometheus default scrape interval is used | `nil` |
| `kubeControllerManager.enabled` | Deploy a `service` and `serviceMonitor` to scrape the Kubernetes controller-manager | `true` |
| `kubeControllerManager.endpoints` | Endpoints where Controller-manager runs. Provide this if running Controller-manager outside the cluster | `[]` |
| `kubeControllermanager.service.port` | Controller-manager port for the service runs on | `10252` |
| `kubeControllermanager.service.targetPort` | Controller-manager targetPort for the service runs on | `10252` |
| `kubeControllermanager.service.selector` | Controller-manager service selector | `{"component" : "kube-controller-manager" }` |
| `kubeControllermanager.serviceMonitor.https` | Controller-manager service scrape over https | `false` |
| `kubeControllermanager.serviceMonitor.interval` | Scrape interval. If not set, the Prometheus default scrape interval is used | `nil` |
| `kubeControllermanager.serviceMonitor.metricRelabelings` | The `metric_relabel_configs` for scraping the scheduler. | `` |
| `kubeControllermanager.serviceMonitor.relabelings` | The `relabel_configs` for scraping the scheduler. | `` |
| `coreDns.enabled` | Deploy coreDns scraping components. Use either this or kubeDns | true |
| `coreDns.service.port` | CoreDns port | `9153` |
| `coreDns.service.targetPort` | CoreDns targetPort | `9153` |
| `coreDns.service.selector` | CoreDns service selector | `{"k8s-app" : "kube-dns" }` |
| `coreDns.serviceMonitor.interval` | Scrape interval. If not set, the Prometheus default scrape interval is used | `nil` |
| `coreDns.serviceMonitor.metricRelabelings` | The `metric_relabel_configs` for scraping CoreDns. | `` |
| `coreDns.serviceMonitor.relabelings` | The `relabel_configs` for scraping CoreDNS. | `` |
| `kubeDns.enabled` | Deploy kubeDns scraping components. Use either this or coreDns| `false` |
| `kubeDns.service.selector` | kubeDns service selector | `{"k8s-app" : "kube-dns" }` |
| `kubeDns.serviceMonitor.interval` | Scrape interval. If not set, the Prometheus default scrape interval is used | `nil` |
| `kubeDns.serviceMonitor.metricRelabelings` | The `metric_relabel_configs` for scraping kubeDns. | `` |
| `kubeDns.serviceMonitor.relabelings` | The `relabel_configs` for scraping kubeDns. | `` |
| `kubeEtcd.enabled` | Deploy components to scrape etcd | `true` |
| `kubeEtcd.endpoints` | Endpoints where etcd runs. Provide this if running etcd outside the cluster | `[]` |
| `kubeEtcd.service.port` | Etcd port | `4001` |
| `kubeEtcd.service.targetPort` | Etcd targetPort | `4001` |
| `kubeEtcd.service.selector` | Selector for etcd if running inside the cluster | `{"component":"etcd"}` |
| `kubeEtcd.serviceMonitor.scheme` | Etcd servicemonitor scheme | `http` |
| `kubeEtcd.serviceMonitor.insecureSkipVerify` | Skip validating etcd TLS certificate when scraping | `false` |
| `kubeEtcd.serviceMonitor.serverName` | Etcd server name to validate certificate against when scraping | `""` |
| `kubeEtcd.serviceMonitor.caFile` | Certificate authority file to use when connecting to etcd. See `prometheus.prometheusSpec.secrets` | `""` |
| `kubeEtcd.serviceMonitor.metricRelabelings` | The `metric_relabel_configs` for scraping Etcd. | `` |
| `kubeEtcd.serviceMonitor.relabelings` | The `relabel_configs` for scraping Etcd. | `` |
| `kubeEtcd.serviceMonitor.certFile` | Client certificate file to use when connecting to etcd. See `prometheus.prometheusSpec.secrets` | `""` |
| `kubeEtcd.serviceMonitor.keyFile` | Client key file to use when connecting to etcd.  See `prometheus.prometheusSpec.secrets` | `""` |
| `kubeEtcd.serviceMonitor.interval` | Scrape interval. If not set, the Prometheus default scrape interval is used | `nil` |
| `kubeScheduler.enabled` | Deploy a `service` and `serviceMonitor` to scrape the Kubernetes scheduler | `true` |
| `kubeScheduler.endpoints` | Endpoints where scheduler runs. Provide this if running scheduler outside the cluster | `[]` |
| `kubeScheduler.service.port` | Scheduler port for the service runs on | `10251` |
| `kubeScheduler.service.targetPort` | Scheduler targetPort for the service runs on | `10251` |
| `kubeScheduler.service.selector` | Scheduler service selector | `{"component" : "kube-scheduler" }` |
| `kubeScheduler.serviceMonitor.https` | Scheduler service scrape over https | `false` |
| `kubeScheduler.serviceMonitor.interval` | Scrape interval. If not set, the Prometheus default scrape interval is used | `nil` |
| `kubeScheduler.serviceMonitor.metricRelabelings` | The `metric_relabel_configs` for scraping the Kubernetes scheduler. | `` |
| `kubeScheduler.serviceMonitor.relabelings` | The `relabel_configs` for scraping the Kubernetes scheduler. | `` |
| `kubeStateMetrics.enabled` | Deploy the `kube-state-metrics` chart and configure a servicemonitor to scrape | `true` |
| `kubeStateMetrics.serviceMonitor.interval` | Scrape interval. If not set, the Prometheus default scrape interval is used | `nil` |
| `kubeStateMetrics.serviceMonitor.metricRelabelings` | Metric relablings for the `kube-state-metrics` ServiceMonitor | `[]` |
| `kubeStateMetrics.serviceMonitor.relabelings` | The `relabel_configs` for scraping `kube-state-metrics`. | `` |
| `kube-state-metrics.rbac.create` | Create RBAC components in kube-state-metrics. See `global.rbac.create` | `true` |
| `kube-state-metrics.podSecurityPolicy.enabled` | Create pod security policy resource for kube-state-metrics. | `true` |
| `nodeExporter.enabled` | Deploy the `prometheus-node-exporter` and scrape it | `true` |
| `nodeExporter.jobLabel` | The name of the label on the target service to use as the job name in prometheus. See `prometheus-node-exporter.podLabels.jobLabel=node-exporter` default | `jobLabel` |
| `nodeExporter.serviceMonitor.metricRelabelings` | Metric relablings for the `prometheus-node-exporter` ServiceMonitor | `[]` |
| `nodeExporter.serviceMonitor.interval` | Scrape interval. If not set, the Prometheus default scrape interval is used | `nil` |
| `nodeExporter.serviceMonitor.relabelings` | The `relabel_configs` for scraping the `prometheus-node-exporter`. | `` |
| `prometheus-node-exporter.podLabels` | Additional labels for pods in the DaemonSet | `{"jobLabel":"node-exporter"}` |
| `prometheus-node-exporter.extraArgs` | Additional arguments for the node exporter container | `["--collector.filesystem.ignored-mount-points=^/(dev|proc|sys|var/lib/docker/.+)($|/)", "--collector.filesystem.ignored-fs-types=^(autofs|binfmt_misc|cgroup|configfs|debugfs|devpts|devtmpfs|fusectl|hugetlbfs|mqueue|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|sysfs|tracefs)$"]` |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release stable/prometheus-operator --set prometheusOperator.enabled=true
```

Alternatively, one or more YAML files that specify the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release stable/prometheus-operator -f values1.yaml,values2.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)


## Developing Prometheus Rules and Grafana Dashboards

This chart Grafana Dashboards and Prometheus Rules are just a copy from coreos/prometheus-operator and other sources, synced (with alterations) by scripts in [hack](hack) folder. In order to introduce any changes you need to first [add them to the original repo](https://github.com/coreos/kube-prometheus/blob/master/docs/developing-prometheus-rules-and-grafana-dashboards.md) and then sync there by scripts.

## Further Information

For more in-depth documentation of configuration options meanings, please see
- [Prometheus Operator](https://github.com/coreos/prometheus-operator)
- [Prometheus](https://prometheus.io/docs/introduction/overview/)
- [Grafana](https://github.com/helm/charts/tree/master/stable/grafana#grafana-helm-chart)

# Migrating from coreos/prometheus-operator chart

The multiple charts have been combined into a single chart that installs prometheus operator, prometheus, alertmanager, grafana as well as the multitude of exporters necessary to monitor a cluster.

There is no simple and direct migration path between the charts as the changes are extensive and intended to make the chart easier to support.

The capabilities of the old chart are all available in the new chart, including the ability to run multiple prometheus instances on a single cluster - you will need to disable the parts of the chart you do not wish to deploy.

You can check out the tickets for this change [here](https://github.com/coreos/prometheus-operator/issues/592) and [here](https://github.com/helm/charts/pull/6765).

## High-level overview of Changes
The chart has 3 dependencies, that can be seen in the chart's requirements file:
https://github.com/helm/charts/blob/master/stable/prometheus-operator/requirements.yaml

### Node-Exporter, Kube-State-Metrics
These components are loaded as dependencies into the chart. The source for both charts is found in the same repository. They are relatively simple components.

### Grafana
The Grafana chart is more feature-rich than this chart - it contains a sidecar that is able to load data sources and dashboards from configmaps deployed into the same cluster. For more information check out the [documentation for the chart](https://github.com/helm/charts/tree/master/stable/grafana)

### Coreos CRDs
The CRDs are provisioned using crd-install hooks, rather than relying on a separate chart installation. If you already have these CRDs provisioned and don't want to remove them, you can disable the CRD creation by these hooks by passing `prometheusOperator.createCustomResource=false`

### Kubelet Service
Because the kubelet service has a new name in the chart, make sure to clean up the old kubelet service in the `kube-system` namespace to prevent counting container metrics twice.

### Persistent Volumes
If you would like to keep the data of the current persistent volumes, it should be possible to attach existing volumes to new PVCs and PVs that are created using the conventions in the new chart. For example, in order to use an existing Azure disk for a helm release called `prometheus-migration` the following resources can be created:
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pvc-prometheus-migration-prometheus-0
spec:
  accessModes:
  - ReadWriteOnce
  azureDisk:
    cachingMode: None
    diskName: pvc-prometheus-migration-prometheus-0
    diskURI: /subscriptions/f5125d82-2622-4c50-8d25-3f7ba3e9ac4b/resourceGroups/sample-migration-resource-group/providers/Microsoft.Compute/disks/pvc-prometheus-migration-prometheus-0
    fsType: ""
    kind: Managed
    readOnly: false
  capacity:
    storage: 1Gi
  persistentVolumeReclaimPolicy: Delete
  storageClassName: prometheus
  volumeMode: Filesystem
```
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  labels:
    app: prometheus
    prometheus: prometheus-migration-prometheus
  name: prometheus-prometheus-migration-prometheus-db-prometheus-prometheus-migration-prometheus-0
  namespace: monitoring
spec:
  accessModes:
  - ReadWriteOnce
  dataSource: null
  resources:
    requests:
      storage: 1Gi
  storageClassName: prometheus
  volumeMode: Filesystem
  volumeName: pvc-prometheus-migration-prometheus-0
status:
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 1Gi
```

The PVC will take ownership of the PV and when you create a release using a persistent volume claim template it will use the existing PVCs as they match the naming convention used by the chart. For other cloud providers similar approaches can be used.
