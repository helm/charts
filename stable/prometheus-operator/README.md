# prometheus-operator

Installs [prometheus-operator](https://github.com/coreos/prometheus-operator) to create/configure/manage Prometheus clusters atop Kubernetes.

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

```
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
```

## Configuration

The following tables lists the configurable parameters of the prometheus-operator chart and their default values.

### General
| Parameter | Description | Default |
| ----- | ----------- | ------ |
| `nameOverride` | Provide a name in place of `prometheus-operator` |`""`|
| `fullNameOverride` | Provide a name to substitute for the full names of resources |`""`|
| `commonLabels` | Labels to apply to all resources | `[]` |
| `defaultRules.create` | Create default rules for monitoring the cluster | `true` |
| `global.rbac.create` | Create RBAC resources | `true` |
| `global.rbac.pspEnabled` | Create pod security policy resources | `true` |
| `global.imagePullSecrets` | Reference to one or more secrets to be used when pulling images | `[]` |

### Prometheus Operator
| Parameter | Description | Default |
| ----- | ----------- | ------ |
| `prometheusOperator.enabled` | Deploy Prometheus Operator. Only one of these should be deployed into the cluster | `true` |
| `prometheusOperator.serviceAccount` | Create a serviceaccount for the operator | `true` |
| `prometheusOperator.name` | Operator serviceAccount name | `""` |
| `prometheusOperator.createCustomResource` | Create CRDs. Required if deploying anything besides the operator itself as part of the release. The operator will create / update these on startup. If your Helm version < 2.10 you will have to either create the CRDs first or deploy the operator first, then the rest of the resources | `true` |
| `prometheusOperator.cleanupCustomResource` | Attempt to delete CRDs when the release is removed. This option may be useful while testing but is not recommended, as deleting the CRD definition will delete resources and prevent the operator from being able to clean up resources that it manages | `false` |
| `prometheusOperator.podLabels` | Labels to add to the operator pod | `{}` |
| `prometheusOperator.kubeletService.enabled` | If true, the operator will create and maintain a service for scraping kubelets | `true` |
| `prometheusOperator.kubeletService.namespace` | Namespace to deploy kubelet service | `true` |
| `prometheusOperator.serviceMonitor.selfMonitor` | Enable monitoring of prometheus operator | `true` |
| `prometheusOperator.resources` | Resource limits for prometheus operator | `{}` |
| `prometheusOperator.nodeSelector` | Prometheus operator node selector https://kubernetes.io/docs/user-guide/node-selection/ | `{}` |
| `prometheusOperator.tolerations` | Tolerations for use with node taints https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ | `[]` |
| `prometheusOperator.affinity` | Assign the prometheus operator to run on specific nodes https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ | `{}` |
| `prometheusOperator.image.repository` | Repository for prometheus operator image | `quay.io/coreos/prometheus-operator` |
| `prometheusOperator.image.tag` | Tag for prometheus operator image | `v0.24.0` |
| `prometheusOperator.image.pullPolicy` | Pull policy for prometheus operator image | `IfNotPresent` |
| `prometheusOperator.configmapReloadImage.repository` | Repository for configmapReload image | `quay.io/coreos/configmap-reload` |
| `prometheusOperator.configmapReloadImage.tag` | Tag for configmapReload image | `v0.0.1` |
| `prometheusOperator.prometheusConfigReloaderImage.repository` | Repository for config-reloader image | `quay.io/coreos/prometheus-config-reloader` |
| `prometheusOperator.prometheusConfigReloaderImage.tag` | Tag for config-reloader image | `v0.24.0` |
| `prometheusOperator.hyperkubeImage.repository` | Repository for hyperkube image used to perform maintenance tasks | `gcr.io/google-containers/hyperkube` |
| `prometheusOperator.hyperkubeImage.tag` | Tag for hyperkube image used to perform maintenance tasks | `v1.12.1` |
| `prometheusOperator.hyperkubeImage.repository` | Image pull policy for hyperkube image used to perform maintenance tasks | `IfNotPresent` |

### Prometheus
| Parameter | Description | Default |
| ----- | ----------- | ------ |
| `prometheus.enabled` | Deploy prometheus | `true` |
| `prometheus.serviceMonitor.selfMonitor` | Create a `serviceMonitor` to automatically monitor the prometheus instance | `true` |
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
| `prometheus.ingress.tls` | Prometheus Ingress TLS configuration (YAML) | `[]` |
| `prometheus.additionalServiceMonitors` | List of `serviceMonitor` objects to create. See https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#servicemonitorspec | `[]` |
| `prometheus.prometheusSpec.podMetadata` | Standard object’s metadata. More info: https://github.com/kubernetes/community/blob/master/contributors/devel/api-conventions.md#metadata Metadata Labels and Annotations gets propagated to the prometheus pods. | `{}` |
| `prometheus.prometheusSpec.serviceMonitorSelector` | ServiceMonitors to be selected for target discovery. | `{}` |
| `prometheus.prometheusSpec.serviceMonitorNamespaceSelector` | Namespaces to be selected for ServiceMonitor discovery. If nil, only check own namespace. | `{}` |
| `prometheus.prometheusSpec.image.repository` | Base image to use for a Prometheus deployment. | `quay.io/prometheus/prometheus` |
| `prometheus.prometheusSpec.image.tag` | Tag of Prometheus container image to be deployed. | `v2.3.4` |
| `prometheus.prometheusSpec.paused` | When a Prometheus deployment is paused, no actions except for deletion will be performed on the underlying objects. | `false` |
| `prometheus.prometheusSpec.replicas` | Number of instances to deploy for a Prometheus deployment. | `1` |
| `prometheus.prometheusSpec.retention` | Time duration Prometheus shall retain data for. Must match the regular expression `[0-9]+(ms\|s\|m\|h\|d\|w\|y)` (milliseconds seconds minutes hours days weeks years). | `120h` |
| `prometheus.prometheusSpec.logLevel` | Log level for Prometheus to be configured with. | `info` |
| `prometheus.prometheusSpec.scrapeInterval` | Interval between consecutive scrapes. | `""` |
| `prometheus.prometheusSpec.evaluationInterval` | Interval between consecutive evaluations. | `""` |
| `prometheus.prometheusSpec.externalLabels` | The labels to add to any time series or alerts when communicating with external systems (federation, remote storage, Alertmanager). | `[]` |
| `prometheus.prometheusSpec.externalUrl` | The external URL the Prometheus instances will be available under. This is necessary to generate correct URLs. This is necessary if Prometheus is not served from root of a DNS name. | `""` |
| `prometheus.prometheusSpec.routePrefix` | The route prefix Prometheus registers HTTP handlers for. This is useful, if using ExternalURL and a proxy is rewriting HTTP routes of a request, and the actual ExternalURL is still true, but the server serves requests under a different route prefix. For example for use with `kubectl proxy`. | `/` |
| `prometheus.prometheusSpec.storage` | Storage spec to specify how storage shall be used. | `{}` |
| `prometheus.prometheusSpec.ruleSelector` | A selector to select which PrometheusRules to mount for loading alerting rules from. Until (excluding) Prometheus Operator v0.24.0 Prometheus Operator will migrate any legacy rule ConfigMaps to PrometheusRule custom resources selected by RuleSelector. Make sure it does not match any config maps that you do not want to be migrated. | `{}` |
| `prometheus.prometheusSpec.ruleNamespaceSelector` | Namespaces to be selected for PrometheusRules discovery. If unspecified, only the same namespace as the Prometheus object is in is used. | `{}` |
| `prometheus.prometheusSpec.alertingEndpoints` | Alertmanagers to which alerts will be sent https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#alertmanagerendpoints Default configuration will connect to the alertmanager deployed as part of this release | `[]` |
| `prometheus.prometheusSpec.resources` | Define resources requests and limits for single Pods. | `{}` |
| `prometheus.prometheusSpec.nodeSelector` | Define which Nodes the Pods are scheduled on. | `{}` |
| `prometheus.prometheusSpec.secrets` | Secrets is a list of Secrets in the same namespace as the Prometheus object, which shall be mounted into the Prometheus Pods. The Secrets are mounted into /etc/prometheus/secrets/<secret-name>. Secrets changes after initial creation of a Prometheus object are not reflected in the running Pods. To change the secrets mounted into the Prometheus Pods, the object must be deleted and recreated with the new list of secrets. | `[]` |
| `prometheus.prometheusSpec.configMaps` | ConfigMaps is a list of ConfigMaps in the same namespace as the Prometheus object, which shall be mounted into the Prometheus Pods. The ConfigMaps are mounted into /etc/prometheus/configmaps/ | `[]` |
|`prometheus.prometheusSpec.podAntiAffinity` | Pod anti-affinity can prevent the scheduler from placing Prometheus replicas on the same node. The default value "soft" means that the scheduler should *prefer* to not schedule two replica pods onto the same node but no guarantee is provided. The value "hard" means that the scheduler is *required* to not schedule two replica pods onto the same node. The value "" will disable pod anti-affinity so that no anti-affinity rules will be configured. | `""` |
| `prometheus.prometheusSpec.tolerations` | If specified, the pod's tolerations. | `[]` |
| `prometheus.prometheusSpec.remoteWrite` | If specified, the remote_write spec. This is an experimental feature, it may change in any upcoming release in a breaking way. | `[]` |
| `prometheus.prometheusSpec.remoteRead` | If specified, the remote_read spec. This is an experimental feature, it may change in any upcoming release in a breaking way. | `[]` |
| `prometheus.prometheusSpec.securityContext` | SecurityContext holds pod-level security attributes and common container settings. This defaults to non root user with uid 1000 and gid 2000 for Prometheus >v2.0 and default PodSecurityContext for other versions. | `{}` |
| `prometheus.prometheusSpec.listenLocal` | ListenLocal makes the Prometheus server listen on loopback, so that it does not bind against the Pod IP. | `false` |
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
| `alertmanager.serviceAccount.create` | Create a `serviceAccount` for alertmanager | `true` |
| `alertmanager.serviceAccount.name` | Name for Alertmanager service account | `""` |
| `alertmanager.podDisruptionBudget.enabled` | If true, create a pod disruption budget for Alertmanager pods. The created resource cannot be modified once created - it must be deleted to perform a change | `true` |
| `alertmanager.podDisruptionBudget.minAvailable` | Minimum number / percentage of pods that should remain scheduled | `1` |
| `alertmanager.podDisruptionBudget.maxUnavailable` | Maximum number / percentage of pods that may be made unavailable | `""` |
| `alertmanager.ingress.enabled` | If true, Alertmanager Ingress will be created | `false` |
| `alertmanager.ingress.annotations` | Alertmanager Ingress annotations | `{}` |
| `alertmanager.ingress.labels` | Alertmanager Ingress additional labels | `{}` |
| `alertmanager.ingress.hosts` | Alertmanager Ingress hostnames | `[]` |
| `alertmanager.ingress.tls` | Alertmanager Ingress TLS configuration (YAML) | `[]` |
| `alertmanager.config` | Provide YAML to configure Alertmanager. See https://prometheus.io/docs/alerting/configuration/#configuration-file. The default provided works to suppress the DeadMansSwitch alert from `defaultRules.create` | `{"global":{"resolve_timeout":"5m"},"route":{"group_by":["job"],"group_wait":"30s","group_interval":"5m","repeat_interval":"12h","receiver":"null","routes":[{"match":{"alertname":"DeadMansSwitch"},"receiver":"null"}]},"receivers":[{"name":"null"}]}` |
| `alertmanager.alertmanagerSpec.podMetadata` | Standard object’s metadata. More info: https://github.com/kubernetes/community/blob/master/contributors/devel/api-conventions.md#metadata Metadata Labels and Annotations gets propagated to the prometheus pods. | `{}` |
| `alertmanager.alertmanagerSpec.image.tag` | Tag of Alertmanager container image to be deployed. | `v0.15.2` |
| `alertmanager.alertmanagerSpec.image.repository` | Base image that is used to deploy pods, without tag. | `quay.io/prometheus/alertmanager` |
| `alertmanager.alertmanagerSpec.secrets` | Secrets is a list of Secrets in the same namespace as the Alertmanager object, which shall be mounted into the Alertmanager Pods. The Secrets are mounted into /etc/alertmanager/secrets/<secret-name>. | `[]` |
| `alertmanager.alertmanagerSpec.configMaps` | ConfigMaps is a list of ConfigMaps in the same namespace as the Alertmanager object, which shall be mounted into the Alertmanager Pods. The ConfigMaps are mounted into /etc/alertmanager/configmaps/ | `[]` |
| `alertmanager.alertmanagerSpec.logLevel` | Log level for Alertmanager to be configured with. | `info` |
| `alertmanager.alertmanagerSpec.replicas` | Size is the expected size of the alertmanager cluster. The controller will eventually make the size of the running cluster equal to the expected size. | `1` |
| `alertmanager.alertmanagerSpec.retention` | Time duration Alertmanager shall retain data for. Value must match the regular expression `[0-9]+(ms\|s\|m\|h\|d\|w\|y)` (milliseconds seconds minutes hours days weeks years). | `120h` |
| `alertmanager.alertmanagerSpec.storage` | Storage is the definition of how storage will be used by the Alertmanager instances. | `{}` |
| `alertmanager.alertmanagerSpec.externalUrl` | The external URL the Alertmanager instances will be available under. This is necessary to generate correct URLs. This is necessary if Alertmanager is not served from root of a DNS name. | `""` |
| `alertmanager.alertmanagerSpec.routePrefix` | The route prefix Alertmanager registers HTTP handlers for. This is useful, if using ExternalURL and a proxy is rewriting HTTP routes of a request, and the actual ExternalURL is still true, but the server serves requests under a different route prefix. For example for use with `kubectl proxy`. | `/` |
| `alertmanager.alertmanagerSpec.paused` | If set to true all actions on the underlying managed objects are not going to be performed, except for delete actions. | `false` |
| `alertmanager.alertmanagerSpec.nodeSelector` | Define which Nodes the Pods are scheduled on. | `{}` |
| `alertmanager.alertmanagerSpec.resources` | Define resources requests and limits for single Pods. | `{}` |
| `alertmanager.alertmanagerSpec.podAntiAffinity` | Pod anti-affinity can prevent the scheduler from placing Prometheus replicas on the same node. The default value "soft" means that the scheduler should *prefer* to not schedule two replica pods onto the same node but no guarantee is provided. The value "hard" means that the scheduler is *required* to not schedule two replica pods onto the same node. The value "" will disable pod anti-affinity so that no anti-affinity rules will be configured. | `""` |
| `alertmanager.alertmanagerSpec.tolerations` | If specified, the pod's tolerations. | `[]` |
| `alertmanager.alertmanagerSpec.securityContext` | SecurityContext holds pod-level security attributes and common container settings. This defaults to non root user with uid 1000 and gid 2000. | `{}` |
| `alertmanager.alertmanagerSpec.listenLocal` | ListenLocal makes the Alertmanager server listen on loopback, so that it does not bind against the Pod IP. Note this is only for the Alertmanager UI, not the gossip communication. | `false` |
| `alertmanager.alertmanagerSpec.containers` | Containers allows injecting additional containers. This is meant to allow adding an authentication proxy to an Alertmanager pod. | `[]` |
| `alertmanager.alertmanagerSpec.priorityClassName` | Priority class assigned to the Pods | `""` |
| `alertmanager.alertmanagerSpec.additionalPeers` | AdditionalPeers allows injecting a set of additional Alertmanagers to peer with to form a highly available cluster. | `[]` |

### Grafana
| Parameter | Description | Default |
| ----- | ----------- | ------ |
| `grafana.enabled` | If true, deploy the grafana sub-chart | `true` |
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
| `grafana.sidecar.datasources.label` | If the sidecar is enabled, configmaps with this label will be loaded into Grafana as datasources configurations | `grafana_datasource` |

### Exporters
| Parameter | Description | Default |
| ----- | ----------- | ------ |
| `kubeApiServer.enabled` | Deploy `serviceMonitor` to scrape the Kubernetes API server | `true` |
| `kubeApiServer.tlsConfig.serverName` | Name of the server to use when validating TLS certificate | `kubernetes` |
| `kubeApiServer.tlsConfig.insecureSkipVerify` | Skip TLS certificate validation when scraping | `false` |
| `kubeApiServer.serviceMonitor.jobLabel` | The name of the label on the target service to use as the job name in prometheus | `component` |
| `kubeApiServer.serviceMonitor.selector` | The service selector | `{"matchLabels":{"component":"apiserver","provider":"kubernetes"}}`
| `kubelet.enabled` | Deploy servicemonitor to scrape the kubelet service. See also `prometheusOperator.kubeletService` | `true` |
| `kubelet.namespace` | Namespace where the kubelet is deployed. See also `prometheusOperator.kubeletService.namespace` | `kube-system` |
| `kubelet.serviceMonitor.https` | Enable scraping of the kubelet over HTTPS. For more information, see https://github.com/coreos/prometheus-operator/issues/926 | `false` |
| `kubeControllerManager.enabled` | Deploy a `service` and `serviceMonitor` to scrape the Kubernetes controller-manager | `true` |
| `kubeControllermanager.service.port` | Controller-manager port for the service runs on | `10252` |
| `kubeControllermanager.service.targetPort` | Controller-manager targetPort for the service runs on | `10252` |
| `kubeControllermanager.service.targetPort.selector` | Controller-manager service selector | `{"k8s-app" : "kube-controller-manager" }`
| `coreDns.enabled` | Deploy coreDns scraping components. Use either this or kubeDns | true |
| `coreDns.service.port` | CoreDns port | `9153` |
| `coreDns.service.targetPort` | CoreDns targetPort | `9153` |
| `coreDns.service.selector` | CoreDns service selector | `{"k8s-app" : "coredns" }`
| `kubeDns.enabled` | Deploy kubeDns scraping components. Use either this or coreDns| `false` |
| `kubeDns.service.selector` | CoreDns service selector | `{"k8s-app" : "kube-dns" }` |
| `kubeEtcd.enabled` | Deploy components to scrape etcd | `true` |
| `kubeEtcd.endpoints` | Endpoints where etcd runs. Provide this if running etcd outside the cluster | `[]` |
| `kubeEtcd.service.port` | Etct port | `4001` |
| `kubeEtcd.service.targetPort` | Etct targetPort | `4001` |
| `kubeEtcd.service.selector` | Selector for etcd if running inside the cluster | `{"k8s-app":"etcd-server"}` |
| `kubeEtcd.servicemonitor.scheme` | Etcd servicemonitor scheme | `http` |
| `kubeEtcd.servicemonitor.insecureSkipVerify` | Skip validating etcd TLS certificate when scraping | `false` |
| `kubeEtcd.servicemonitor.serverName` | Etcd server name to validate certificate against when scraping | `""` |
| `kubeEtcd.servicemonitor.caFile` | Certificate authority file to use when connecting to etcd. See `prometheus.prometheusSpec.secrets` | `""` |
| `kubeEtcd.servicemonitor.certFile` | Client certificate file to use when connecting to etcd. See `prometheus.prometheusSpec.secrets` | `""` |
| `kubeEtcd.servicemonitor.keyFile` | Client key file to use when connecting to etcd.  See `prometheus.prometheusSpec.secrets` | `""` |
| `kubeStateMetrics.enabled` | Deploy the `kube-state-metrics` chart and configure a servicemonitor to scrape | `true` |
| `kube-state-metrics.rbac.create` | Create RBAC components in kube-state-metrics. See `global.rbac.create` | `true` |
| `nodeExporter.enabled` | Deploy the `prometheus-node-exporter` and scrape it | `true` |
| `nodeExporter.jobLabel` | The name of the label on the target service to use as the job name in prometheus. See `prometheus-node-exporter.podLabels.jobLabel=node-exporter` default | `jobLabel` |
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

## Further Information

For more in-depth documentation of configuration options meanings, please see
- [Prometheus Operator](https://github.com/coreos/prometheus-operator)
- [Prometheus](https://prometheus.io/docs/introduction/overview/)
- [Grafana](https://github.com/helm/charts/tree/master/stable/grafana#grafana-helm-chart)

## Helm <2.10 workaround
The `crd-install` hook is required to deploy the prometheus operator CRDs before they are used. If you are forced to use an earlier version of Helm you can work around this requirement as follows:
1. Install prometheus-operator by itself, disabling everything but the prometheus-operator component, and also setting `prometheusOperator.serviceMonitor.selfMonitor=false`
2. Install all the other components, and configure `prometheus.additionalServiceMonitors` to scrape the prometheus-operator service.
